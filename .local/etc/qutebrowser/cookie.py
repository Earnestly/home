import logging

from types import SimpleNamespace

from qutebrowser.api import cmdutils

# Unstable API
import qutebrowser.misc

cookie = SimpleNamespace()
cookie.config = config.configdir / 'cookie-whitelist'
cookie.logger = logging.getLogger('cookie')

def cookie_whitelist_load():
    """Read in cookie whitelist and update global config accordingly."""
    # Reset per-domain cookie.accept to never.
    for line in config._config.dump_userconfig().splitlines():
        fields = line.split(' ')

        if len(fields) == 4 and fields[1] == 'content.cookies.accept':
            config.set('content.cookies.accept', 'never', fields[0][:-1])

    whitelist = []

    with open(cookie.config) as f:
        for i, line in enumerate(f.read().splitlines()):
            if not (line.startswith('#') or line.strip() == ''):
                domain, *warrant = line.split(' ')

                if len(warrant) > 1:
                    cookie.logger.debug('cookie:{cookies.config}:{i}:{line}: expected 1 or 2 fields but saw {length}')
                else:
                    warrant = warrant[0] if warrant else 'no-3rdparty'
                    config.set('content.cookies.accept', warrant, domain)


qutebrowser.misc.objects.commands.pop('cookie-whitelist-edit', None)

@cmdutils.register()
def cookie_whitelist_edit():
    """Open the cookie whitelist with the editor."""
    editor = qutebrowser.misc.editor.ExternalEditor(watch=True, parent=config._config)

    def on_file_updated():
        cookie_whitelist_load()

    editor.file_updated.connect(on_file_updated)
    editor.edit_file(str(cookie.config))


cookie_whitelist_load()
