from qutebrowser.api import interceptor

# XXX Internal API
import qutebrowser.extensions

def redirect(original, request: qutebrowser.api.interceptor.Request):
    if original != request.request_url.toString():
        request.redirect(request.request_url)

def rewrite(request: qutebrowser.api.interceptor.Request):
    url = request.request_url.toString()
    host = request.request_url.host()
    path = request.request_url.path()

    if host == 'reddit.com' or host == 'www.reddit.com' and '/r/' in path:
        request.request_url.setHost('old.reddit.com')
        redirect(url, request)

    if host.startswith('www.amazon.') and '/dp/' in path:
        request.request_url.setQuery(None)

        parts = path.split('/')
        i = parts.index('dp')

        request.request_url.setPath('/' + '/'.join(parts[i:i+2]))
        redirect(url, request)

    if host.startswith('www.ebay.') and '/itm/' in path:
        request.request_url.setQuery(None)

        parts = path.split('/')

        if len(parts) > 3:
            request.request_url.setPath('/' + parts[1] + '/' + parts[3])

        redirect(url, request)

    # if host == 'imgur.com':
    #     request.request_url.setHost('rimgo.ducks.party')
    #     redirect(url, request)


for fn in qutebrowser.extensions.interceptors._interceptors:
    if fn.__name__ == 'rewrite':
        qutebrowser.extensions.interceptors._interceptors.remove(fn)

interceptor.register(rewrite)
