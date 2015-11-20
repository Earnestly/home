/* LOCALDIR/cfg/vimperator/plugins/launchv.js
 *
 * Quick function to help reduce duplication in my config, thanks mostly to
 * holomorph who started pretty much all of this.
 *
 * Requires: mpv, youtube-dl
 *
 * Command:
 *     :launchv  Attempts to start the current buffer URL as a video
 *
 * Hint:
 *     ;q        Likewise but for the selected hint
 */

function launchv(target){
    /*
     * Escape anything which could be used to inject shell commands before
     * passing it to the commands.
     */
    var uri = target.replace(/([$`"\\])/g, "\\$1");
    var mpv = "mpv --loop-file --cache-file=TMP";

    function exec(launcher, uri){
        /* If using pentadactyl then echo the action as io.system won't. */
        if(typeof dactyl !== "undefined")
            dactyl.echomsg("Executing: " + launcher + " \"" + uri + "\"");

        return io.system(launcher + ' "' + uri + '" &');
    }

    exec(mpv, uri);
}

hints.addMode("q", "Launch video from hint", function(elem, loc) launchv(loc));
commands.add(["launchv", "lv"], "Launches current buffer video", function(args){launchv(buffer.URL);});
