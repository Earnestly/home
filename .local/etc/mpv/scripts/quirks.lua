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
