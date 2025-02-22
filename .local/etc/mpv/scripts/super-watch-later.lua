local utils = require "mp.utils"

local data = {
    index,
    timestamp = 0,
    kind = "U",
    title,
    author,
    path,
    playlist_path,
    playlist_title,
    playlist_position,
    playlist_count
}

local function absolute(path)
    if not path:match("^/") then
        path = utils.getcwd() .. "/" .. path
    end

    return path
end

local function isfile(path)
    local r = false

    -- Assuming file:// is local to avoid decoding the path.
    if path:match("^file://") then
        r = true
    else
        local stat = utils.file_info(path)

        if stat then
            r = stat.is_file or stat.is_dir
        end
    end

    return r
end

mp.register_script_message("super-quit-watch-later", function()
    mp.observe_property("metadata", "native", function(_, metadata)
        if not metadata then
            mp.set_property("osd-msg1", "Waiting for the metadata property")
        else
            data.title = mp.get_property("media-title")

            -- If no title was found mpv probably fell back to a filename, so
            -- try to extract the basename as the title instead.
            --
            -- XXX It may be better to let downstream users handle this.
            if data.title and isfile(data.title) then
                _, data.title = utils.split_path(data.title)
            end

            data.author = metadata.artist

            if not data.author then
                data.author = metadata.uploader
            end

            data.path = mp.get_property("path")

            if data.path and isfile(data.path) then
                data.kind = "F"
                data.path = absolute(data.path)
            end

            data.index = data.path

            -- XXX Local playlists could consist of a bunch of paths given to
            --     mpv. This sort of playlist may(?) not really be supported.
            data.playlist_path = mp.get_property("playlist-path")

            if data.playlist_path then
                data.kind = "P"
                data.playlist_title = metadata.ytdl_playlist_title
                data.playlist_position = mp.get_property("playlist-pos-1")
                data.playlist_count = mp.get_property("playlist-count")

                -- XXX This code should go soon.
                if data.playlist_path:match("^https://") and not data.playlist_title then
                    mp.osd_message("Attempting to determine the playlist title (mpv/pr#15098)", 10)

                    -- XXX ytdl_playlist_title not available to single videos
                    --     that are part of a playlist.
                    --
                    --     https://github.com/yt-dlp/yt-dlp/issues/11234
                    --     https://github.com/mpv-player/mpv/pull/15098
                    local r = mp.command_native({
                        name = "subprocess",
                        args = {"yt-dlp", "-JI", "0", "--flat-playlist", "--", data.playlist_path},
                        capture_stdout = true
                    })

                    if r.status == 0 then
                        local stdout = utils.parse_json(r.stdout)
                        data.playlist_title = stdout.title
                    end
                end

                if isfile(data.playlist_path) then
                    data.playlist_path = absolute(data.playlist_path)

                    -- XXX Same as above.
                    if not data.playlist_title then
                        _, data.playlist_title = utils.split_path(data.playlist_path)
                    end
                end

                data.index = data.playlist_path
            end

            -- XXX Is os.time() accurate enough to order entries more or less
            --     faithfully?
            --
            --     local socket = require "socket"
            --     socket.gettime()?
            data.timestamp = os.time()

            local filename = mp.command_native({"expand-path", "~~state/super-watch-later.json"})
            local file, err = io.open(filename, 'a')

            if not file then
                msg.error(string.format("watchlater: error: %s: %s\n", filename, err))
                return
            end

            file:write(utils.format_json(data))
            file:close()

            mp.command("quit-watch-later")
        end
    end)
end)
