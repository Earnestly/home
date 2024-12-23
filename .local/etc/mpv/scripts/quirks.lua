-- Prefer the much more informative ytdl_description property as media title
-- when watching twitch.tv live streams
mp.observe_property("metadata", "native", function(_, metadata)
    if metadata and mp.get_property("path"):match("^https://www.twitch.tv/") then
        local title = metadata["ytdl_description"]

        if title then
            mp.set_property("force-media-title", string.format("%s: %s", metadata["uploader"], title))
        end
    end
end)

-- Used for my x220 thinkpad (HD2000). Both GPU usage (hwdec=vaapi) and
-- temperatures rapidly increase when using bt.601-525 RGB primaries.
mp.observe_property("video-params/primaries", "string", function(_, primaries)
    if primaries and primaries == "bt.601-525" then
        mp.commandv("vf", "append", "format=primaries=bt.709")
    end
end)
