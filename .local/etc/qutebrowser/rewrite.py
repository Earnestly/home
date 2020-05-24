import qutebrowser.api.interceptor

def rewrite(request: qutebrowser.api.interceptor.Request):
    if request.request_url.host() == 'www.reddit.com':
        request.request_url.setHost('old.reddit.com')

        try:
            request.redirect(request.request_url)
        except:
            pass

    if request.request_url.host().startswith('www.amazon.') and '/dp/' in request.request_url.path():
        path = request.request_url.path().split('/')
        i = path.index('dp')
        request.request_url.setPath('/' + '/'.join(path[i:i+2]))
        request.request_url.setQuery(None)

        try:
            request.redirect(request.request_url)
        except:
            pass

    if request.request_url.host().startswith('www.ebay.') and '/itm/' in request.request_url.path():
        path = request.request_url.path().split('/')

        if len(path) > 3:
            request.request_url.setPath('/' + path[1] + '/' + path[3])
            request.request_url.setQuery(None)

        try:
            request.redirect(request.request_url)
        except:
            pass

    if request.request_url.host() == 'www.youtube.com':
        query = request.request_url.query()

        if 'disable_polymer=1' not in query:
            if query:
                request.request_url.setQuery(query + '&disable_polymer=1')
            else:
                request.request_url.setQuery('disable_polymer=1')

        try:
            request.redirect(request.request_url)
        except:
            pass

qutebrowser.api.interceptor.register(rewrite)
