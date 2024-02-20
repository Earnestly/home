# SPDX-License-Identifier: BlueOak-1.0.0

import os
import re
import fnmatch
import logging

from types import SimpleNamespace

from qutebrowser.api import interceptor, cmdutils, message, apitypes

# Unstable APIs
import qutebrowser.misc

def qmatrix_read_config(config):
    """Load qmatrix rules from configuration file into the global rules list."""

    #   SYNOPSIS
    #       host_domain source_domain [flags [resource]]
    #
    #   DESCRIPTION
    #       host_domain and source_domain are matched according to fnmatch
    #       patterns. If no flags are provided the default set is used.
    #
    #       special flags
    #           *  all flags
    #           a  default flags (cdefikmorstwx)
    #           b  clear flags
    #
    #       resource flags
    #           c  stylesheet
    #           d  download (sub_resource)
    #           e  csp_report
    #           f  iframe (sub_frame)
    #           i  image
    #           k  worker
    #           m  media
    #           o  websocket
    #           p  ping
    #           r  prefetch
    #           s  script
    #           t  font
    #           w  service worker
    #           x  xhr
    #
    #       resource
    #           A specific web resource upon which to act.

    # https://doc.qt.io/qt-6/qwebengineurlrequestinfo.html#ResourceType-enum
    resource_flags = {
        'c': interceptor.ResourceType.stylesheet,
        'd': interceptor.ResourceType.sub_resource,
        'e': interceptor.ResourceType.csp_report,
        'f': interceptor.ResourceType.sub_frame,
        'i': interceptor.ResourceType.image,
        'k': interceptor.ResourceType.worker,
        'm': interceptor.ResourceType.media,
        'o': interceptor.ResourceType.websocket,
        'p': interceptor.ResourceType.ping,
        'r': interceptor.ResourceType.prefetch,
        's': interceptor.ResourceType.script,
        't': interceptor.ResourceType.font_resource,
        'w': interceptor.ResourceType.service_worker,
        'x': interceptor.ResourceType.xhr
    }

    default_flags = list('cdefikmorstwx')

    def compile_regex(s, flags=0):
        return re.compile(fnmatch.translate(s), flags)

    qmatrix.logger.debug(f'{qmatrix.config}: loading ruleset')

    with open(config) as f:
        for i, line in enumerate(f.read().splitlines()):
            if not (line.startswith('#') or line.strip() == ''):
                fields = line.split(' ')
                length = len(fields)
                granted = []
                resource = None

                if length < 2 or length > 4:
                    qmatrix.logger.debug(f'{qmatrix.config}:{i}: {line}: invalid rule')
                else:
                    host_domain = compile_regex(fields[0], re.IGNORECASE)
                    source_domain = compile_regex(fields[1], re.IGNORECASE)

                    flags = default_flags if length == 2 else list(fields[2])

                    if 'a' in flags:
                        flags = default_flags

                    if 'b' in flags:
                        flags.clear()

                    if '*' in flags:
                        flags = list(resource_flags.keys())

                    for f in flags:
                        if f in resource_flags:
                            granted.append(resource_flags[f])
                        else:
                            qmatrix.logger.debug(f'{qmatrix.config}:{i} {f}: unknown flag')

                    if length == 4:
                        resource = compile_regex(fields[3])

                    qmatrix.rules.append((host_domain, source_domain, tuple(granted), resource))

    qmatrix.logger.debug(f'{qmatrix.config}: {len(qmatrix.rules)} rules loaded')


@cmdutils.register()
def qmatrix_edit():
    """Open qmatrix-rules with a text editor."""
    editor = qutebrowser.misc.editor.ExternalEditor(watch=True, parent=config._config)

    def on_file_updated():
        qmatrix_read_config(qmatrix.config)

    # XXX This tends to produce File not Found errors messages when saving the
    #     file without closing. It appears to work nevertheless.
    editor.file_updated.connect(on_file_updated)
    editor.edit_file(str(qmatrix.config))


@cmdutils.register()
def qmatrix_toggle():
    """Enable or disable qmatrix."""

    qmatrix.active = not qmatrix.active
    message.info('qmatrix enabled' if qmatrix.active else 'qmatrix disabled')


def qmatrix_intercept(request: interceptor.Request):
    if qmatrix.active and not request.resource_type in qmatrix.whitelist:
        hosts = (request.first_party_url.host(), request.request_url.host())
        resource = (request.resource_type, request.request_url.toString())

        ruleset = qmatrix.rules

        access = False

        # start = qmatrix.timer()

        for rule in ruleset:
            if access:
                break

            if rule[0].match(hosts[0]) and rule[1].match(hosts[1]):
                if resource[0] in rule[2]:
                    access = True

                if rule[3] and not rule[3].match(resource[1]):
                    access = False

        # duration = qmatrix.timer() - start
        # qmatrix.logger.info(f'{duration:.5f}s [{resource[0].name}] {host[0]} {resource[1]}')

        if not access:
            qmatrix.logger.info(f'blocked: [{resource[0].name}] {hosts[0]} {resource[1]}')
            request.block()


qmatrix = SimpleNamespace()

qmatrix.active = True
qmatrix.config = config.configdir / 'qmatrix-rules'
qmatrix.logger = logging.getLogger('qmatrix')
qmatrix.rules = []
qmatrix.whitelist = (interceptor.ResourceType.main_frame, interceptor.ResourceType.favicon, None)
# import timeit
# qmatrix.timer = timeit.default_timer

qmatrix_read_config(qmatrix.config)
interceptor.register(qmatrix_intercept)
