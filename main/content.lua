--- All interactive content, keyed by the `content` property of an interactable.go instance.
-- Adding a room means adding entries here and placing interactable.go instances in the
-- collection whose `content` property names a key. No new code.
--
-- Fields:
--   type    "video" (payload = YouTube video id), "playlist" (payload = YouTube playlist id),
--           "link" (payload = URL), or "text" (payload = body text)
--   prompt  label shown on the action button / prompt when the player is in range
--   title   heading shown on link and text cards (defaults to prompt)
--   anim    animation id in assets/tiny_dungeon.tilesource used for the object's sprite
local M = {}

M.items = {
	-- "Sunumlar": all presentations and webinars, as one playlist so new uploads appear automatically.
	[hash("talks_monitor")] = {
		type = "playlist",
		prompt = "Watch the talks",
		title = "Sunumlar",
		payload = "PLq-FKoPCrDxWf3UukjCPelX8ZjnoZTOgm",
		anim = "monitor",
	},
	-- "Zaten Her Şey Sıfır Bir": podcast, season one.
	[hash("podcast_radio")] = {
		type = "playlist",
		prompt = "Listen to the podcast",
		title = "Zaten Her Şey Sıfır Bir",
		payload = "PLq-FKoPCrDxU13_PF_5OG464XkPvfIbsN",
		anim = "podcast",
	},
	[hash("spawn_sign")] = {
		type = "text",
		prompt = "Read the sign",
		title = "Welcome",
		payload = "This is an interactive portfolio.\n\n"
			.. "Walk up to things and press E, or tap Interact, to open them.\n"
			.. "The screen on the right plays the talks; the framed box on the left plays the podcast.",
		anim = "sign",
	},
}

--- @param id hash content key
--- @return table|nil
function M.get(id)
	return M.items[id]
end

return M
