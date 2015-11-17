// ~/local/cfg/vimperator/plugins/toggle.js

function togglejs() {
    if(options.getPref("javascript.enabled") == true){
        options.setPref("javascript.enabled", false);
        liberator.echo("javascript disabled");
    }else{
        options.setPref("javascript.enabled", true);
        liberator.echo("javascript enabled");
    }
}

commands.addUserCommand(['togglejs'], 'toggle javascript', togglejs);
