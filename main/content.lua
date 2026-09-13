--- All interactive content, keyed by the `content` property of an interactable.go instance.
-- Exactly four links, by owner decision (2026-09-13). Do not add more without asking.
--
-- Fields:
--   type    "video" (payload = YouTube video id), "playlist" (payload = YouTube playlist id),
--           "link" (payload = URL), "text" (payload = body text), or
--           "card" (payload = { text = optional intro, entries = { { label, note, url }, ... } })
--   prompt  label shown on the action button / prompt when the player is in range
--   title   heading shown on cards (defaults to prompt)
local M = {}

M.items = {
	[hash("youtube")] = {
		type = "link",
		prompt = "YouTube channel",
		title = "YouTube",
		payload = "https://www.youtube.com/@halilcosgun",
	},
	[hash("spotify")] = {
		type = "link",
		prompt = "Podcast on Spotify",
		title = "Podcast",
		payload = "https://open.spotify.com/show/1RtqgRpLCl0Zsc9ePeXn83",
	},
	[hash("linkedin")] = {
		type = "link",
		prompt = "LinkedIn profile",
		title = "LinkedIn",
		payload = "https://www.linkedin.com/in/halilcosgun/",
	},
	[hash("github")] = {
		type = "link",
		prompt = "GitHub profile",
		title = "GitHub",
		payload = "https://github.com/cosgunhalil",
	},
}

--- @param id hash content key
--- @return table|nil
function M.get(id)
	return M.items[id]
end

return M
