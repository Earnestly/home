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
config.set('url.searchengines', {'DEFAULT': 'https://duckduckgo.com/html/?q=!{}'})

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
# As a result all animations will be disabled; they often add nothing.  Most
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

config.bind('t', 'cmd-set-text -s :open -t')
config.bind('O', 'cmd-set-text :open {url}')
config.bind('<Alt-h>', 'tab-prev')
config.bind('<Alt-l>', 'tab-next')

config.bind(';a', 'hint images download')

# The binding C-e is taken for insert mode and used to move the cursor to the
# end of the line.
config.bind('<Ctrl-Shift-e>', 'edit-text', 'insert')

# Configure everything to use primary selection by default instead of clipboard.
config.bind('yy', 'yank -s')
config.bind(';y', 'hint links yank-primary')
config.bind('p', 'open -- {primary}')
config.bind('P', 'open -t -- {primary}')

# Implement emacs/readline style key bindings for insert mode.
config.bind('<Alt-Backspace>', 'fake-key <Ctrl-Backspace>', 'insert')
config.bind('<Alt-f>', 'fake-key <Ctrl-Right>', 'insert')
config.bind('<Alt-b>', 'fake-key <Ctrl-Left>', 'insert')
config.bind('<Ctrl-Shift-v>', 'fake-key <Ctrl-a>', 'insert')
config.bind('<Ctrl-h>', 'fake-key <Backspace>', 'insert')
config.bind('<Ctrl-a>', 'fake-key <Home>', 'insert')
config.bind('<Ctrl-n>', 'fake-key Up', 'insert')
config.bind('<Ctrl-p>', 'fake-key Down', 'insert')
config.bind('<Ctrl-e>', 'fake-key <End>', 'insert')
config.bind('<Ctrl-k>', 'fake-key <Shift-End> ;; fake-key <Delete>', 'insert')
config.bind('<Ctrl-w>', 'fake-key <Ctrl+Shift+Left> ;; fake-key <Delete>', 'insert')
config.bind('<Ctrl-u>', 'fake-key <Shift+Home> ;; fake-key <Delete>', 'insert')
config.bind('<Ctrl-r>', 'fake-key <Ctrl+z>', 'insert')

# Qt appears to be highly pessimistic about available memory when overcommit is
# disabled which prevents the starting of multiple mpv instances directly.  By
# using a script which starts mpv indirectly it appears Qt is willing to start
# more.
# config.bind('gv', 'spawn -du video')
# config.bind(';v', 'hint links spawn -du video')
config.bind('gv', 'spawn -v env PEONATTRS=video peon {url}')
config.bind(';v', 'hint links spawn -v env PEONATTRS=video peon {hint-url}')

config.bind(';q', 'hint links spawn sh -c \'qrencode -o - "$1" | imv -\' _ {hint-url}')
config.bind('gq', 'spawn sh -c \'qrencode -o - "$1" | imv -\' _ {url}')

config.bind('gl', 'spawn -ou ledger')

config.bind('Q', ':devtools window')

config.bind('gj', 'config-cycle -p content.javascript.enabled')
config.bind('gp', 'config-cycle -p content.private_browsing')

# Remove return from the javascript question prompts to reduce the chance of
# accidental acceptance.  Instead an explicit 'y' or 'n' will be required.
config.unbind('<Return>', mode='yesno')
