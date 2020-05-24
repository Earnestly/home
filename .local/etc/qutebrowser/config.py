# XDG_CONFIG_HOME/qutebrowser/config.py

import setproctitle
setproctitle.setproctitle('qutebrowser')

config.source(config.configdir / 'qmatrix.py')
config.source(config.configdir / 'cookie.py')
config.source(config.configdir / 'rewrite.py')

config.load_autoconfig = False

config.set('editor.command', ['editor-gui', '{}'])
config.set('downloads.position', 'bottom')

config.set('url.default_page', 'about:blank')
config.set('url.start_pages', ['about:blank'])
config.set('url.searchengines', {'DEFAULT': 'https://duckduckgo.com/html/?q=!{}'})

# XXX qutebrowser (webengine) cannot yet disable webrtc completely:
#     <https://bugreports.qt.io/browse/QTBUG-57505>
config.set('content.webrtc_ip_handling_policy', 'default-public-interface-only')

config.set('content.webgl', False)
config.set('content.cookies.accept', 'never')
config.set('content.javascript.enabled', False)
config.set('content.dns_prefetch', False)
config.set('content.notifications', False)
config.set('content.register_protocol_handler', False)

config.set('tabs.background', True)
config.set('tabs.last_close', 'close')
config.set('tabs.show', 'multiple')

config.set('hints.chars', 'fdsartgbvecwxqyiopmnhzuljk')
config.set('hints.scatter', False)
config.set('hints.uppercase', True)

config.set('completion.use_best_match', True)

with config.pattern('twitter.com') as p:
    # IE 11's user agent forces twitter to use its older desktop UI for the
    # time being.
    p.content.headers.user_agent = 'Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko'
    p.content.javascript.enabled = True

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
font_ui = '10pt Inter'

config.set('fonts.default_family', 'Inconsolatazi4')
config.set('fonts.default_size', '12pt')

config.set('fonts.tabs', font_ui)
config.set('fonts.hints', font_ui)
config.set('fonts.completion.category', font_ui)

# Key Bindings
config.bind('t', 'set-cmd-text -s :open -t')
config.bind('O', 'set-cmd-text :open {url}')
config.bind('<Alt-h>', 'tab-prev')
config.bind('<Alt-l>', 'tab-next')

config.bind('yy', 'yank -s')
config.bind(';y', 'hint links yank-primary')
config.bind('p', 'open -- {primary}')
config.bind('P', 'open -t -- {primary}')

# config.bind('U', 'spawn -vd mpv --profile=url {url}')
# config.bind(';q', 'hint links spawn -vd mpv --profile=url {hint-url}')
config.bind('U', 'spawn -u video')
config.bind(';q', 'hint links userscript video')

config.bind('Q', ':inspector')

config.bind('<Alt-x>', 'config-cycle -p content.javascript.enabled')
config.bind('<Ctrl-Shift-p>', 'config-cycle -p content.private_browsing')

# Remove return from the javascript question prompts to reduce the chance of
# accidental acceptance.  Instead an explicit 'y' or 'n' will be required.
config.unbind('<Return>', mode='yesno')
