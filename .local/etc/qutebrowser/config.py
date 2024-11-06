# XDG_CONFIG_HOME/qutebrowser/config.py

config.load_autoconfig(False)

try:
    import setproctitle
    setproctitle.setproctitle('qutebrowser')
except Exception:
    pass

config.source(config.configdir / 'qmatrix.py')
config.source(config.configdir / 'cookie.py')
config.source(config.configdir / 'rewrite.py')

config.set('editor.command', ['editor-gui', '{}'])

config.set('downloads.position', 'bottom')

config.set('session.lazy_restore', True)

config.set('url.default_page', 'about:blank')
config.set('url.start_pages', ['about:blank'])

# XXX https://github.com/qutebrowser/qutebrowser/issues/5970
config.set('url.searchengines', {'DEFAULT': 'https://html.duckduckgo.com/html?q=!{}'})

# XXX qutebrowser (webengine) cannot yet disable webrtc completely:
#     <https://bugreports.qt.io/browse/QTBUG-57505>
config.set('content.webrtc_ip_handling_policy', 'default-public-interface-only')

config.set('content.webgl', False)
config.set('content.cookies.accept', 'never')
config.set('content.javascript.enabled', False)
config.set('content.dns_prefetch', False)
config.set('content.notifications.enabled', False)
config.set('content.register_protocol_handler', False)

# Many websites use a placeholder for text that is fetched via javascript.
# This placeholder uses a subtle phasing animation which ends up consuming an
# obnoxious amount of CPU resources for something that will never be replaced
# as javascript is typically disabled.
# As a result all animations will be disabled; they often add nothing and most
# other effects are obtained using the transition property which hasn't yet
# caused problems.
config.set('content.user_stylesheets', 'css/no-animation.css')

config.set('tabs.background', True)
config.set('tabs.last_close', 'close')
# config.set('tabs.mode_on_change', 'restore')
config.set('tabs.show', 'multiple')

config.set('hints.chars', 'fjghdkslaweqvrtponimub')
config.set('hints.scatter', False)
config.set('hints.uppercase', True)

config.set('completion.use_best_match', True)

# Colours
color_background = '#343d46'
color_foreground = '#65737e'
color_text = '#c0c5ce'
color_red = '#cc6666'

config.set('colors.webpage.bg', color_text)

config.set('colors.tabs.indicator.system', 'none')
config.set('colors.tabs.bar.bg', color_background)
config.set('colors.tabs.odd.bg', color_background)
config.set('colors.tabs.odd.fg', color_foreground)
config.set('colors.tabs.even.bg', color_background)
config.set('colors.tabs.even.fg', color_foreground)
config.set('colors.tabs.selected.odd.fg', color_text)
config.set('colors.tabs.selected.odd.bg', color_background)
config.set('colors.tabs.selected.even.fg', color_text)
config.set('colors.tabs.selected.even.bg', color_background)
config.set('colors.tabs.indicator.start', color_text)
config.set('colors.tabs.indicator.stop', color_background)
config.set('colors.tabs.indicator.error', color_red)

font_ui = '10pt Inter'
config.set('fonts.default_family', 'Inconsolatazi4')
config.set('fonts.default_size', '12pt')

config.set('fonts.tabs.selected', font_ui)
config.set('fonts.tabs.unselected', font_ui)
config.set('fonts.hints', font_ui)
config.set('fonts.completion.category', font_ui)

config.set('aliases', config.get('aliases').update({'help': 'help -t'}))

c.bindings.commands = {
    'insert': {
        # The binding C-e is taken for insert mode and used to move the cursor
        # to the end of the line.
        '<Ctrl+Shift+e>': 'edit-text',

        # Attempt to mimic basic emacs editting in insert mode.
        '<Alt+Backspace>': 'fake-key <Ctrl-Backspace>',
        '<Alt+b>': 'fake-key <Ctrl-Left>',
        '<Alt+f>': 'fake-key <Ctrl-Right>',
        '<Ctrl+Shift+v>': 'fake-key <Ctrl-a>',
        '<Ctrl+a>': 'fake-key <Home>',
        '<Ctrl+e>': 'fake-key <End>',
        '<Ctrl+h>': 'fake-key <Backspace>',
        '<Ctrl+k>': 'fake-key <Shift-End> ;; fake-key <Delete>',
        '<Ctrl+n>': 'fake-key Up',
        '<Ctrl+p>': 'fake-key Down',
        '<Ctrl+r>': 'fake-key <Ctrl+z>',
        '<Ctrl+u>': 'fake-key <Shift+Home> ;; fake-key <Delete>',
        '<Ctrl+w>': 'fake-key <Ctrl+Shift+Left> ;; fake-key <Delete>'
    },

    'normal': {
        ';a': 'hint images download',

        # Configure everything to use primary selection by default instead of
        # clipboard.
        ';y': 'hint links yank-primary',
        'yy': 'yank -s',
        'P': 'open -t -- {primary}',

        '<Alt+h>': 'tab-prev',
        '<Alt+l>': 'tab-next',

        'O': 'cmd-set-text :open {url}',
        't': 'cmd-set-text -s :open -t',
        'p': 'open -- {primary}',

        'Q': ':devtools window',
        'gj': 'config-cycle -p content.javascript.enabled',
        'gp': 'config-cycle -p content.private_browsing',

        'gc': 'spawn web-secure {url}',
        ';c': 'hint links spawn web-secure {hint-url}',

        'gq': 'spawn sh -c "qrencode -o - \"$1\" | imv -" _ {url}',
        ';q': 'hint links spawn sh -c "qrencode -o - \"$1\" | imv -" _ {hint-url}',

        'gv': 'spawn -dv env PEONATTRS=video peon {url}',
        ';v': 'hint links spawn -dv env PEONATTRS=video peon {hint-url}',

        'gl': 'spawn -ou ledger'
    },

    'yesno': {
        # Remove return from the javascript question prompts to reduce the
        # chance of accidental acceptance. Instead an explicit 'y' or 'n' will
        # be required.
        '<Return>': None
        }
    }
