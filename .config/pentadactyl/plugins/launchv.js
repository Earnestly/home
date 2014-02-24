/* ~/.config/pentadactyl/plugins/launchv.js

    Quick function to help reduce duplication in my config, thanks mostly to
    holomorph who started pretty much all of this

    Adds two new commands and two new hint modes:
    * :launchv  - Opens the current buffer url prefering yt-dl
    * :launchvq - Same as above but prefers quvi

    Hints:
    * ;u - launches the current hint prefering yt-dl
    * ;q - Same but prefers quvi

    Note: If the url contains a youtube playlist it will return the playlist's
          url rather than the direct youtube video.

    Todo:
    * Remove the duplication between quvi and yt-dl and unify the keys/hints
*/

function launchv(target, quvi=true){

    /* Escape anything which could be used to inject shell commands before
     * passing it to the commands */
    var uri = target.replace(/([$`"\\])/g, "\\$1");

    function exec(launcher, uri){
        commandline.echo("Launching: " + launcher + " " + uri);
        return io.system(launcher + ' "' + uri + '" &');
    }

    /* filter certain urls to more appropriate programs before passing to
     * quvi */
    if(uri.match(/twitch\.tv\/.*\/[bc]\/[0-9]+/))

        /* XXX Currently youtube-dl will only fetch the first 30 minutes of the
         *     stream.  Replacing this with lstream until fixed. */
        //exec("yt-dl", uri);
        exec("lstream", uri);
    else if(uri.match(/twitch\.tv/))
        exec("lstream", uri);

    /* Open youtube playlists of any kind directly with mpv */
    else if(uri.match(/youtube.*[?&]list=PL/))

        /* Check if the url is part of a playlist but a direct video (watch?v=)
         * url is provided and return the real playlist url */
        if(uri.match(/watch\?v=/)){
            var uri = uri.replace(/watch\?v.+?\&/, "playlist\?")
            exec("mpv --really-quiet --cache=4096", uri);
        }else
            exec("mpv --really-quiet --cache=4096", uri);

    /* For everything else */
    else if(quvi)
        exec("quvi dump -b mute", uri);
    else
        exec("yt-dl", uri);
}

/* Ugly duplication :( */
hints.addMode("q", "Launch video from hint (quvi)",
    function (elem, loc) launchv(loc));

hints.addMode("u", "Launch video from hint (yt-dl)",
    function (elem, loc) launchv(loc, quvi=false));

group.commands.add(["launchv", "lv"], "Launches current buffer video (yt-dl).",
    function(args){ var uri = buffer.URL;
        launchv(uri, quvi=false);
    });

group.commands.add(["launchvq", "lvq"], "Launches current buffer video (quvi).",
    function(args){ var uri = buffer.URL;
        launchv(uri);
    });
