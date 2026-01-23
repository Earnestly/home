-- XDG_CONFIG_HOME/mpv/scripts/quirks.lua

-- For my x220 thinkpad (HD2000). Both GPU usage (hwdec=vaapi) and temperatures
-- rise rapidly when the bt.601-525 RGB primaries are in effect. Switching to
-- bt.709 calms it back down.
mp.observe_property("video-params/primaries", "string", function(_, primaries)
    if primaries and primaries == "bt.601-525" then
        mp.command("no-osd vf append format=primaries=bt.709")
    end
end)

-- Quirks for specific paths.
mp.observe_property("path", "string", function(_, path)
    if path and path:find("https://www.twitch.tv/", 1, true) then
        -- XXX May not need this function.
        local function fgrep(patterns, string)
            for _, pattern in pairs(patterns) do
                if string:find(pattern, 1, true) then
                    return true
                end
            end

            return false
        end

        -- If ytdl_description is present for twitch.tv streams then use it as
        -- the title instead of the current date. Some streams already set the
        -- media-title to this value in which case ytdl_description is not
        -- present. In either case also prepend the streamer's username to the
        -- title.
        mp.observe_property("metadata", "native", function(_, metadata)
            if metadata then
                local title = metadata["ytdl_description"] or mp.get_property("media-title")
                mp.set_property("force-media-title", string.format("%s: %s", metadata["uploader"], title))
            end
        end)

        if not path:find("https://www.twitch.tv/videos/", 1, true) then
            mp.enable_messages("warn")
            mp.register_event("log-message", function(message)
                local module = message.prefix
                local content = string.gsub(message.text, "\n*$", "")

                -- It appears possible to bypass adverts on twitch.tv by reloading
                -- the stream when an advert is intending to play. Various messages
                -- are used as sentinels to detect this condition but there may be
                -- better ways.
                if module == "ffmpeg/demuxer" and fgrep({"hls: Packet corrupt (stream = 1, dts ="}, content) then
                    mp.osd_message("[twitch]: Advert incoming", 4)
                end

                -- Using audio timestamp warnings appear to be the best way to
                -- detect an advert so far.
                if module == "ad" then
                    local jump, _, from, to = content:find("Invalid audio PTS: (%d+)%.%d+ %-> (%d+)%.%d+")

                    from = tonumber(from)
                    to = tonumber(to)

                    -- nb. Preroll ads tend to always jump from 75.00xxx. Skipping
                    --     a reload on that specific timestamp prevents infinite
                    --     restarts unless the jump is to 60.00xxx in which case
                    --     the reload should proceed.
                    if jump and (from ~= 75 or to == 60) then
                        mp.osd_message("[twitch]: Reloading stream", 4)
                        mp.command("playlist-play-index current")
                    end
                end

                -- Some twitch.tv streams do not provide formats that can be
                -- downloaded when using live-from-start so this attempts to reload
                -- the stream without it.
                --
                -- nb. This is part of the advert skipping strategy; the stream
                --     itself does not actually start from the beginning if the
                --     formats are actually available.
                if module == "ytdl_hook" then
                    local triggers = {
                        "use --no-live-from-start",
                        "You must be logged into an account"
                    }

                    if fgrep(triggers, content) then
                        mp.osd_message("[yt-dlp]: live-from-start not available", 4)
                        mp.command("no-osd change-list ytdl-raw-options remove live-from-start; \
                                    playlist-play-index current")
                    end
                end
            end)
        end
    end
end)
