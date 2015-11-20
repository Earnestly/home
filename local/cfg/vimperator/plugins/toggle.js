/* LOCALDIR/cfg/vimperator/plugins/toggle.js */

function togglejs() {
    if(options.getPref("javascript.enabled") == true){
        options.setPref("javascript.enabled", false);
        liberator.echomsg("javascript disabled");
    }else{
        options.setPref("javascript.enabled", true);
        liberator.echomsg("javascript enabled");
    }
}

commands.addUserCommand(['togglejs'], 'toggle javascript', togglejs);
