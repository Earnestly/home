import qutebrowser.api.interceptor

def rewrite(request: qutebrowser.api.interceptor.Request):
    url = request.request_url.host()

    if url == 'reddit.com' or url == 'www.reddit.com':
        request.request_url.setHost('teddit.net')
        request.redirect(request.request_url)

    if request.request_url.host().startswith('www.amazon.') and '/dp/' in request.request_url.path():
        url = request.request_url.toString()
        path = request.request_url.path().split('/')
        i = path.index('dp')

        request.request_url.setPath('/' + '/'.join(path[i:i+2]))
        request.request_url.setQuery(None)

        if url != request.request_url.toString():
            request.redirect(request.request_url)

    if request.request_url.host().startswith('www.ebay.') and '/itm/' in request.request_url.path():
        url = request.request_url.toString()
        path = request.request_url.path().split('/')

        if len(path) > 3:
            request.request_url.setPath('/' + path[1] + '/' + path[3])
            request.request_url.setQuery(None)

        if url != request.request_url.toString():
            request.redirect(request.request_url)

qutebrowser.api.interceptor.register(rewrite)
