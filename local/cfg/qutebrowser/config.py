# LOCALDIR/cfg/qutebrowser/config.py

import setproctitle

setproctitle.setproctitle('qutebrowser')

config.load_autoconfig = False

# General
config.set('backend', 'webengine')

config.set('editor.command', ['visual', '{}'])

config.set('downloads.position', 'bottom')

config.set('url.default_page', 'about:blank')
config.set('url.start_pages', ['about:blank'])
config.set('url.searchengines', {'DEFAULT': 'https://duckduckgo.com/html/?q=!{}'})

config.set('content.dns_prefetch', False)
config.set('content.javascript.enabled', False)

config.set('tabs.background', True)
config.set('tabs.last_close', 'close')
config.set('tabs.show', 'multiple')

config.set('hints.chars', 'fdsartgbvecwxqyiopmnhzuljk')
config.set('hints.scatter', False)
config.set('hints.uppercase', True)

config.set('completion.use_best_match', True)

# Colours
color_background = '#343d46'
color_foreground = '#65737e'
color_text = '#c0c5ce'
color_red = '#cc6666'

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

# Fonts
font_ui = '10pt Inter UI'
font_mono = '11.5pt Inconsolatazi4'

config.set('fonts.tabs', font_ui)
config.set('fonts.statusbar', font_mono)
config.set('fonts.completion.entry', font_mono)
config.set('fonts.completion.category', font_ui)

# Key Bindings
config.bind('t', 'set-cmd-text -s :open -t')
config.bind('O', 'set-cmd-text :open {url}')
config.bind('<Alt-h>', 'tab-prev')
config.bind('<Alt-l>', 'tab-next')

config.bind('yy', 'yank -s')
config.bind('p', 'open -- {primary}')
config.bind('P', 'open -t -- {primary}')

config.bind('U', 'spawn -vd mpv-url {url}')
config.bind(';q', 'hint links spawn -vd mpv-url {hint-url}')

config.bind('<Alt-x>', 'config-cycle -p content.javascript.enabled')
config.bind('<Ctrl-Shift-p>', 'config-cycle -p content.private_browsing')
