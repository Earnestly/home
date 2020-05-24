import qutebrowser.api.cmdutils

# Unstable API
import qutebrowser.utils

def cookie_whitelist_load():
    # Reset per-domain cookie.accept
    for line in config._config.dump_userconfig().splitlines():
        fields = line.split(' ')

        if len(fields) == 4 and fields[1] == 'content.cookies.accept':
            config.set('content.cookies.accept', 'never', fields[0][:-1])

    whitelist = []

    with open(config.configdir / 'cookie-whitelist') as f:
        for line in f.read().splitlines():
            if not (line.startswith('#') or line.strip() == ''):
                pairs = line.split(' ')

                if len(pairs) > 1:
                    whitelist.append((pairs[0], pairs[1]))
                else:
                    whitelist.append((pairs[0], 'no-3rdparty'))

    for domain, permit in whitelist:
        config.set('content.cookies.accept', permit, domain)

@qutebrowser.api.cmdutils.register()
def cookie_whitelist_edit():
    editor = qutebrowser.misc.editor.ExternalEditor(watch=True, parent=config._config)

    def on_file_updated():
        cookie_whitelist_load()

    editor.file_updated.connect(on_file_updated)
    editor.edit_file(str(config.configdir / 'cookie-whitelist'))

cookie_whitelist_load()
