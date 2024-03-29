# SPDX-License-Identifier: BlueOak-1.0.0

import os
import re
import fnmatch
import logging

from types import SimpleNamespace

from qutebrowser.api import interceptor, cmdutils, message, apitypes

# XXX Internal APIs
import qutebrowser.misc
# Used to update the interceptor if it already exists.
import qutebrowser.extensions

qmatrix = SimpleNamespace()

qmatrix.active = True
qmatrix.config = config.configdir / 'qmatrix-rules'
qmatrix.logger = logging.getLogger('qmatrix')
qmatrix.rules = set()
qmatrix.default_flags = set(list('cdefikmorstwx'))

# https://doc.qt.io/qt-6/qwebengineurlrequestinfo.html#ResourceType-enum
qmatrix.resources = {
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

qmatrix.whitelist = {
    interceptor.ResourceType.main_frame,
    interceptor.ResourceType.favicon,
    None
}

# import timeit
# qmatrix.timer = timeit.default_timer


def qmatrix_add_rule(host, source, flags, resource):
    """ Adds an individual rule to the rule list. """
    #   SYNOPSIS
    #       host [source [flags [resource]]]
    #
    #   DESCRIPTION
    #       host and source are matched according to fnmatch patterns.
    #       If source is not provided then it is assumed to be equal to the
    #       host.  If no flags are provided the default set is used.
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

    def compile_regex(s, flags=0):
        return re.compile(fnmatch.translate(s), flags)

    access = set()

    host = compile_regex(host, re.IGNORECASE)
    source = compile_regex(source, re.IGNORECASE) if source else host
    resource = compile_regex(resource) if resource else None

    if flags:
        if 'a' in flags:
            flags = qmatrix.default_flags

        if 'b' in flags:
            flags.clear()

        if '*' in flags:
            flags = set(resource_flags.keys())
    else:
        flags = qmatrix.default_flags

    for f in flags:
        if f in qmatrix.resources:
            access.add(qmatrix.resources[f])
        else:
            qmatrix.logger.debug(f'{qmatrix.config}:{i} {f}: unknown flag')

    qmatrix.rules.add((host, source, frozenset(access), resource))


def qmatrix_read_config(config):
    """Load qmatrix rules from configuration file into the global rules list."""
    qmatrix.rules.clear()
    qmatrix.logger.debug(f'{qmatrix.config}: loading ruleset')

    with open(config) as f:
        for i, line in enumerate(f.read().splitlines()):
            if not (line.startswith('#') or line.strip() == ''):
                fields = line.split(' ')
                length = len(fields)

                if length < 1 or length > 4:
                    qmatrix.logger.debug(f'{qmatrix.config}:{i}: {line}: invalid rule')
                else:
                    host_domain = fields[0]
                    source_domain = host_domain if length == 1 else fields[1]
                    flags = list(fields[2]) if length > 2 else None
                    resource = fields[3] if length == 4 else None

                    qmatrix_add_rule(host_domain, source_domain, flags, resource)


for cmdname in ['qmatrix-edit', 'qmatrix-toggle']:
    qutebrowser.misc.objects.commands.pop(cmdname, None)

@cmdutils.register()
def qmatrix_edit():
    """Open qmatrix-rules with a text editor."""
    editor = qutebrowser.misc.editor.ExternalEditor(watch=True, parent=config._config)

    def on_file_updated():
        # XXX This tends to produce File not Found errors messages when saving
        #     the file without closing. It appears to work nevertheless.
        qmatrix_read_config(qmatrix.config)
        message.info(f'qmatrix: {qmatrix.config}: {len(qmatrix.rules)} rules loaded')

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

        access = False
        ruleset = qmatrix.rules

        # start = qmatrix.timer()

        for rule in ruleset:
            if not access:
                if rule[0].match(hosts[0]) and rule[1].match(hosts[1]):
                    if resource[0] in rule[2]:
                        access = True

                    if rule[3] and not rule[3].match(resource[1]):
                        access = False
            else:
                break

        # duration = qmatrix.timer() - start
        # qmatrix.logger.info(f'{duration:.5f}s [{resource[0].name}] {hosts[0]} {resource[1]}')

        if not access:
            qmatrix.logger.info(f'blocked: [{resource[0].name}] {hosts[0]} {resource[1]}')
            request.block()


qmatrix_read_config(qmatrix.config)

for fn in qutebrowser.extensions.interceptors._interceptors:
    if fn.__name__ == 'qmatrix_intercept':
        qutebrowser.extensions.interceptors._interceptors.remove(fn)

interceptor.register(qmatrix_intercept)
