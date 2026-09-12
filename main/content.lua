--- All interactive content, keyed by the `content` property of an interactable.go instance.
-- Object placement lives in tools/gen_world.py; this file is only the content.
--
-- Fields:
--   type    "video" (payload = YouTube video id), "playlist" (payload = YouTube playlist id),
--           "link" (payload = URL), "text" (payload = body text), or
--           "card" (payload = { text = optional intro, entries = { { label, note, url }, ... } })
--           A card lists entries as tappable rows; a tapped row stays highlighted.
--   prompt  label shown on the action button / prompt when the player is in range
--   title   heading shown on cards (defaults to prompt)
--   anim    animation id in assets/tiny_dungeon.tilesource used for the object's sprite
local M = {}

local GITHUB = "https://github.com/cosgunhalil"

M.items = {
	[hash("spawn_sign")] = {
		type = "text", anim = "sign",
		prompt = "Read the sign",
		title = "Welcome",
		payload = "This is the interactive portfolio of Halil Coşgun.\n\n"
			.. "Walk up to things and press E, or tap Interact, to open them.\n\n"
			.. "The screen plays talks, the framed box plays the podcast. "
			.. "The chest holds open source work, the crate holds games, "
			.. "and the person over there is me.",
	},

	-- "Sunumlar": all presentations and webinars, as one playlist so new uploads appear automatically.
	[hash("talks_monitor")] = {
		type = "playlist", anim = "monitor",
		prompt = "Watch the talks",
		title = "Sunumlar",
		payload = "PLq-FKoPCrDxWf3UukjCPelX8ZjnoZTOgm",
	},

	-- "Zaten Her Şey Sıfır Bir": podcast, season one.
	[hash("podcast_radio")] = {
		type = "playlist", anim = "podcast",
		prompt = "Listen to the podcast",
		title = "Zaten Her Şey Sıfır Bir",
		payload = "PLq-FKoPCrDxU13_PF_5OG464XkPvfIbsN",
	},

	[hash("open_source_chest")] = {
		type = "card", anim = "chest",
		prompt = "Open source",
		title = "Open source",
		payload = {
			text = "Repositories on GitHub. Tap one to open it in a new tab.",
			entries = {
				{ label = "Tickwise", note = "Rust. Record, replay and diff deterministic simulations.", url = GITHUB .. "/Tickwise" },
				{ label = "Jotphant", note = "Rust. A desktop Pomodoro task board with a Markdown notebook.", url = GITHUB .. "/Jotphant" },
				{ label = "HannibalUI", note = "C#. UI management system for Unity games.", url = GITHUB .. "/HannibalUI" },
				{ label = "Design Patterns", note = "C#. Design pattern examples.", url = GITHUB .. "/DesignPatterns" },
				{ label = "SoftwareDevelopment101", note = "C#. Software development fundamentals, zero to hero.", url = GITHUB .. "/SoftwareDevelopment101" },
				{ label = "All repositories", note = "github.com/cosgunhalil", url = GITHUB },
			},
		},
	},

	[hash("games_crate")] = {
		type = "card", anim = "crate",
		prompt = "Games",
		title = "Games",
		payload = {
			text = "Seven years of mobile multiplayer games at Masomo, from Unity developer to software architect.",
			entries = {
				{ label = "Head Ball 2", note = "Lead Game Developer, then Technical Lead. All client-side development: gameplay systems, UI/UX, networking, platform security, ad mediation. Led 4 to 9 engineers." },
				{ label = "Basketball Arena", note = "Technical Lead. Stability, crash-rate reduction and platform security on Android and iOS; designed a cheat detection system; upgraded testing and build tooling." },
				{ label = "Unity years, 2015-2019", note = "Unity developer at Simsoft and Masomo: gameplay, UI, AI and tool programming, shaders, serious and mobile games." },
			},
		},
	},

	[hash("about_person")] = {
		type = "card", anim = "person",
		prompt = "Talk to Halil",
		title = "Halil Coşgun",
		payload = {
			text = "CTO at Rapsodo Studios, Izmir. 10+ years in software, 6+ in Unity, 4+ in mobile games. "
				.. "Game optimization, gameplay and UI programming, team management. C#, C++, Python, and lately Rust. "
				.. "Game development is my childhood dream, and I get to live it.",
			entries = {
				{ label = "LinkedIn", note = "linkedin.com/in/halilcosgun", url = "https://www.linkedin.com/in/halilcosgun" },
				{ label = "Website", note = "halilcosgun.com", url = "https://halilcosgun.com" },
				{ label = "Email", note = "cosgun.halil@gmail.com", url = "mailto:cosgun.halil@gmail.com" },
			},
		},
	},
}

--- @param id hash content key
--- @return table|nil
function M.get(id)
	return M.items[id]
end

return M
