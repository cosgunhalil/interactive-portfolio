--- All interactive content, keyed by the `content` property of an interactable.go instance.
-- Adding a room means adding entries here and placing interactable.go instances in the
-- collection whose `content` property names a key. No new code.
--
-- Fields:
--   type    "video" (payload = YouTube id), "link" (payload = URL), or "text" (payload = body text)
--   prompt  label shown on the action button / prompt when the player is in range
--   title   heading shown on link and text cards (defaults to prompt)
--   color   optional sprite tint for the placeholder square
local M = {}

M.items = {
	[hash("talks_monitor")] = {
		type = "video",
		prompt = "Watch the talk",
		title = "Talks",
		-- TODO: replace with the id of a real talk. This is a placeholder video that allows embedding.
		payload = "M7lc1UVf-VE",
		color = vmath.vector4(0.22, 0.64, 0.89, 1),
	},
	[hash("spawn_sign")] = {
		type = "text",
		prompt = "Read the sign",
		title = "Welcome",
		payload = "This is an interactive portfolio.\n\n"
			.. "Walk up to things and press E, or tap Interact, to open them.\n"
			.. "The blue screen over there plays a talk.",
		color = vmath.vector4(0.93, 0.78, 0.3, 1),
	},
}

--- @param id hash content key
--- @return table|nil
function M.get(id)
	return M.items[id]
end

return M
