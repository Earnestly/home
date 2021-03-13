import os
import logging
import fnmatch

import qutebrowser.api.interceptor
import qutebrowser.api.cmdutils
import qutebrowser.api.message
import qutebrowser.api.apitypes

# Unstable API
import qutebrowser.utils
import qutebrowser.misc

qmatrix_active = True

resource_whitelist = [
    qutebrowser.api.interceptor.ResourceType.main_frame,
    qutebrowser.api.interceptor.ResourceType.favicon,
    None
]

resource_flags = {
    's': qutebrowser.api.interceptor.ResourceType.script,
    'x': qutebrowser.api.interceptor.ResourceType.xhr,
    'c': qutebrowser.api.interceptor.ResourceType.stylesheet,
    't': qutebrowser.api.interceptor.ResourceType.font_resource,
    'i': qutebrowser.api.interceptor.ResourceType.image,
    'm': qutebrowser.api.interceptor.ResourceType.media,
    'w': qutebrowser.api.interceptor.ResourceType.service_worker,
    'd': qutebrowser.api.interceptor.ResourceType.sub_resource,
    'f': qutebrowser.api.interceptor.ResourceType.sub_frame,
    'p': qutebrowser.api.interceptor.ResourceType.ping,
}

more_flags = ('=')

default_flags = 'sxctimwdf'
rules = []
logger = logging.getLogger('qmatrix')

def qmatrix_read_config():
    """Load qmatrix rules from configuration file into the global rules list."""

    #   SYNOPSIS
    #       primary_host secondary_host [flags] [resource]

    #   DESCRIPTION
    #       primary and secondary hosts are matched according to fnmatch
    #       globs.

    #       flags (default: sxctimf)
    #           s  script
    #           x  xhr
    #           c  stylesheet
    #           t  font
    #           i  image
    #           m  media
    #           w  service worker
    #           d  download (sub_resource)
    #           f  iframe (sub_frame)
    #           p  ping
    #           =  both primary and secondary domains must match

    #       resource
    #           A specific web resource upon which to act.

    global rules

    # Clear out any existing rules.
    rules = []

    with open(config.configdir / 'qmatrix-rules') as f:
        for line in f.read().splitlines():
            if not (line.startswith('#') or line.strip() == ''):
                fields = line.split(' ')

                length = len(fields)
                flags = default_flags
                granted = []
                resource = ''

                if length >= 2:
                    if length > 2:
                        flags = fields[2]

                    if 'a' in flags:
                        flags = default_flags

                    if 'b' in flags:
                        flags = ''

                    for f in flags:
                        if f in more_flags:
                            granted.append(f)

                        if f in resource_flags:
                            granted.append(resource_flags[f])

                    if length == 4:
                        resource = fields[3]

                    rules.append((fields[0], fields[1], tuple(granted), resource))

qmatrix_read_config()

@qutebrowser.api.cmdutils.register()
def qmatrix_edit():
    """Docstring."""
    editor = qutebrowser.misc.editor.ExternalEditor(watch=True, parent=config._config)

    def on_file_updated():
        qmatrix_read_config()

    editor.file_updated.connect(on_file_updated)
    editor.edit_file(str(config.configdir / 'qmatrix-rules'))

@qutebrowser.api.cmdutils.register()
def qmatrix_toggle():
    """Enable or disable qmatrix."""

    global qmatrix_active
    qmatrix_active = not qmatrix_active
    message = 'qmatrix enabled' if qmatrix_active else 'qmatrix disabled'
    qutebrowser.api.message.info(message)

def qmatrix_intercept(request: qutebrowser.api.interceptor.Request):
    if qmatrix_active and not request.resource_type in resource_whitelist:
        host_primary = request.first_party_url.host()
        host_secondary = request.request_url.host()
        resource_type = request.resource_type
        resource = request.request_url.toString()

        access = False

        global rules
        for rule in rules:
            if '=' in rule[2] and host_primary != host_secondary:
                continue

            if fnmatch.fnmatch(host_primary, rule[0]) and fnmatch.fnmatch(host_secondary, rule[1]):
                if resource_type in rule[2]:
                    access = True
                elif not rule[3]:
                    access = False

                if resource == rule[3]:
                    if resource_type in rule[2]:
                        access = True
                    else:
                        access = False

        if not access:
            logger.info('blocked: {} {} [{}] {}'.format(host_primary, host_secondary, resource_type.name, resource))
            request.block()

qutebrowser.api.interceptor.register(qmatrix_intercept)
