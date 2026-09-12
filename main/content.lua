--- All interactive content, keyed by the `content` property of an interactable.go instance.
-- Rooms and object placement live in tools/gen_world.py; this file is only the content.
--
-- Fields:
--   type    "video" (payload = YouTube video id), "playlist" (payload = YouTube playlist id),
--           "link" (payload = URL), or "text" (payload = body text)
--   prompt  label shown on the action button / prompt when the player is in range
--   title   heading shown on link and text cards (defaults to prompt)
--   anim    animation id in assets/tiny_dungeon.tilesource used for the object's sprite
local M = {}

local GITHUB = "https://github.com/cosgunhalil"

M.items = {
	------------------------------------------------------------------ Talks (spawn room)
	[hash("spawn_sign")] = {
		type = "text", anim = "sign",
		prompt = "Read the sign",
		title = "Welcome",
		payload = "This is an interactive portfolio of Halil Coşgun.\n\n"
			.. "Walk up to things and press E, or tap Interact, to open them.\n\n"
			.. "This room: talks and the podcast.\n"
			.. "Door on the right: open source.\n"
			.. "Door at the top: games.\n"
			.. "Top right: about and contact.",
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

	------------------------------------------------------------------ Open source
	[hash("sign_open_source")] = {
		type = "text", anim = "sign",
		prompt = "Read the sign",
		title = "Open source",
		payload = "Each chest is a repository. Open one to jump to GitHub.",
	},
	[hash("repo_tickwise")] = {
		type = "link", anim = "chest",
		prompt = "Open Tickwise",
		title = "Tickwise (Rust)",
		payload = GITHUB .. "/Tickwise",
	},
	[hash("repo_jotphant")] = {
		type = "link", anim = "chest",
		prompt = "Open Jotphant",
		title = "Jotphant (Rust)",
		payload = GITHUB .. "/Jotphant",
	},
	[hash("repo_hannibalui")] = {
		type = "link", anim = "chest",
		prompt = "Open HannibalUI",
		title = "HannibalUI (Unity, C#)",
		payload = GITHUB .. "/HannibalUI",
	},
	[hash("repo_designpatterns")] = {
		type = "link", anim = "chest",
		prompt = "Open Design Patterns",
		title = "Design Patterns (C#)",
		payload = GITHUB .. "/DesignPatterns",
	},
	[hash("github_profile")] = {
		type = "link", anim = "badge",
		prompt = "Open GitHub profile",
		title = "GitHub",
		payload = GITHUB,
	},

	------------------------------------------------------------------ Games
	[hash("sign_games")] = {
		type = "text", anim = "sign",
		prompt = "Read the sign",
		title = "Games",
		payload = "Seven years of mobile multiplayer games at Masomo, from Unity developer to software architect.",
	},
	[hash("game_headball2")] = {
		type = "text", anim = "crate",
		prompt = "About Head Ball 2",
		title = "Head Ball 2",
		payload = "Lead Game Developer, then Technical Lead.\n\n"
			.. "Owned all client-side development: core gameplay systems, UI/UX, networking, "
			.. "Android/iOS security, ad mediation and third-party integrations. "
			.. "Led a team of 4 to 9 engineers, cut crash rates and sped up release cycles.",
	},
	[hash("game_basketball_arena")] = {
		type = "text", anim = "crate",
		prompt = "About Basketball Arena",
		title = "Basketball Arena",
		payload = "Technical Lead.\n\n"
			.. "Directed stability, crash-rate reduction and platform security across Android and iOS, "
			.. "designed a cheat detection system, and upgraded the tooling: unit tests, build pipeline, R&D.",
	},
	[hash("unity_years")] = {
		type = "text", anim = "table",
		prompt = "Read the notes",
		title = "Unity years",
		payload = "2015-2019: Unity developer at Simsoft and Masomo.\n\n"
			.. "Gameplay, UI, AI and tool programming, shaders, serious games and mobile games.",
	},

	------------------------------------------------------------------ About
	[hash("sign_about")] = {
		type = "text", anim = "sign",
		prompt = "Read the sign",
		title = "About",
		payload = "Who I am and how to reach me.",
	},
	[hash("about_bio")] = {
		type = "text", anim = "person",
		prompt = "Talk to Halil",
		title = "Halil Coşgun",
		payload = "CTO at Rapsodo Studios, Izmir.\n\n"
			.. "10+ years in software, 6+ in Unity, 4+ in mobile game development. "
			.. "Game optimization, gameplay and UI programming, team management. "
			.. "C#, C++, Python, and lately Rust.\n\n"
			.. "Game development is my childhood dream, and I get to live it.",
	},
	[hash("about_linkedin")] = {
		type = "link", anim = "badge",
		prompt = "Open LinkedIn",
		title = "LinkedIn",
		payload = "https://www.linkedin.com/in/halilcosgun",
	},
	[hash("about_website")] = {
		type = "link", anim = "shelf",
		prompt = "Open the website",
		title = "halilcosgun.com",
		payload = "https://halilcosgun.com",
	},
	[hash("about_email")] = {
		type = "link", anim = "potion",
		prompt = "Send an email",
		title = "Email",
		payload = "mailto:cosgun.halil@gmail.com",
	},
}

--- @param id hash content key
--- @return table|nil
function M.get(id)
	return M.items[id]
end

return M
