-- HOME/.local/etc/mpv/scripts/quirks.lua

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
        -- present.  In either case also prepend the streamer's username to the
        -- title.
        mp.observe_property("metadata", "native", function(_, metadata)
            if metadata then
                local title = metadata["ytdl_description"] or mp.get_property("media-title")
                mp.set_property("force-media-title", string.format("%s: %s", metadata["uploader"], title))
            end
        end)

        mp.enable_messages("warn")
        mp.register_event("log-message", function(message)
            local module = message.prefix
            local content = string.gsub(message.text, "\n*$", "")

            -- It appears to be possible to bypass ads on twitch.tv by
            -- reloading the stream when an ad is intending to play.  Various
            -- messages are used as sentinels to detect this condition; there
            -- may be better ways.

            -- XXX Preroll ads cause some difficulty.
            if module == "ffmpeg/demuxer" and fgrep({"hls: Packet corrupt (stream = 1, dts ="}, content) then
                mp.osd_message("[twitch]: Advert incoming", 4)
            end

            if module == "ad" and fgrep({"Invalid audio PTS:"}, content) then
                mp.osd_message("[twitch]: Reloading stream", 4)
                mp.command("playlist-play-index current")
            end

            -- These triggers make it impossible to jump past preroll ads.
            -- local triggers = {
            --     "h264: co located POCs unavailable",
            --     "h264: mmco: unref short failure"
            -- }
            --
            -- if module == "ffmpeg/video" and fgrep(triggers, content) then
            --     mp.osd_message("[twitch]: Reloading stream", 2)
            --     mp.command("playlist-play-index current")
            -- end

            -- Some twitch.tv streams do not provide formats that can be
            -- downloaded when using live-from-start so this attempts to reload
            -- the stream without it.
            if module == "ytdl_hook" and fgrep({"use --no-live-from-start"}, content) then
                mp.osd_message("[yt-dlp]: live-from-start not available", 4)
                mp.command("no-osd change-list ytdl-raw-options remove live-from-start; \
                            playlist-play-index current")
            end
        end)
    end
end)

-- For my x220 thinkpad (HD2000). Both GPU usage (hwdec=vaapi) and temperatures
-- rise rapidly when the bt.601-525 RGB primaries are in effect. Switching to
-- bt.709 calms it back down.
mp.observe_property("video-params/primaries", "string", function(_, primaries)
    if primaries and primaries == "bt.601-525" then
        mp.command("no-osd vf append format=primaries=bt.709")
    end
end)
