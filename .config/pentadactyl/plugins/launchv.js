/* ~/.config/pentadactyl/plugins/launchv.js

    Quick function to help reduce duplication in my config, thanks mostly to
    holomorph who started pretty much all of this

    Adds two new commands and two new hint modes:
    * :launchv  - Opens the current buffer url prefering yt-dl

    Hints:
    * ;u - launches the current hint with yt-dl

    Note: If the url contains a youtube playlist it will return the playlist's
          url rather than the direct youtube video.
*/

function launchv(target){

    /* Escape anything which could be used to inject shell commands before
     * passing it to the commands */
    var uri = target.replace(/([$`"\\])/g, "\\$1");

    function exec(launcher, uri){

        /* If we're using dactyl then echo the action as io.system won't */
        if(typeof dactyl !== "undefined")
            dactyl.echomsg("Launching: " + launcher + " " + uri);

        return io.system(launcher + ' "' + uri + '" &');
    }

    /* filter certain urls to more appropriate programs before passing to
     * quvi */
    if(uri.match(/twitch\.tv\/.*\/[bc]\/[0-9]+/))

        /* XXX Currently youtube-dl will only fetch the first 30 minutes of the
         *     stream.  Replacing this with livestreamer until fixed. */
        //exec("yt-dl", uri);
        exec("livestreamer", uri);

    /* Currently youtube-dl's support is buggy but adding for future */
    else if(uri.match(/hitbox\.tv\/video\/[0-9]+/))
        exec("yt-dl", uri);
    else if(uri.match(/twitch\.tv/) || uri.match(/hitbox\.tv/))
        exec("livestreamer", uri);

    else if(uri.match(/youtube.*[?&]list=RD/))
            exec("mpv --no-terminal", uri);

    /* Open youtube playlists of any kind directly with mpv */
    else if(uri.match(/youtube.*[?&]list=PL/)){

        /* Check if the url is part of a playlist but a direct video (watch?v=)
         * url is provided and return the real playlist url */
        if(uri.match(/watch\?v=/)){
            var uri = uri.replace(/watch\?v.+?\&/, "playlist\?")
            exec("mpv --no-terminal", uri);
        }else
            exec("mpv --no-terminal", uri);

    /* For everything else */
    }else
        exec("yt-dl", uri);
}

hints.addMode("q", "Launch video from hint", function (elem, loc) launchv(loc));

commands.add(["launchv", "lv"], "Launches current buffer video",
    function(args){ var uri = buffer.URL;
        launchv(uri);
    }
);
