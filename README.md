# Interactive Portfolio

A small walkable portfolio built with [Defold](https://defold.com) and published as an HTML5/WebAssembly page.
You control a character in a pixel-art room. Four chests hold the links that matter: the YouTube channel, the
podcast on Spotify, LinkedIn, and GitHub. Walk up to a chest, open it, follow the link.

Live: `https://cosgunhalil.github.io/interactive-portfolio/`

## Controls

| | Move | Open a chest | Close overlay |
|---|---|---|---|
| Desktop | WASD or arrow keys | E | Esc, ✕, or click outside |
| Mobile | Virtual joystick (lower left) | Action button (lower right) | ✕ button |

The action button appears only when a chest is in reach and shows what it opens. If you do nothing for a few
seconds at the start, a hint explains how to move and the character walks to the first chest on its own.

## The chests

| Chest | Link |
|---|---|
| YouTube | https://www.youtube.com/@halilcosgun |
| Podcast | https://open.spotify.com/show/1RtqgRpLCl0Zsc9ePeXn83 |
| LinkedIn | https://www.linkedin.com/in/halilcosgun/ |
| GitHub | https://github.com/cosgunhalil |

Chests twitch on their own every few seconds, animate open when activated, show a card with the link, and close
again when the card is dismissed. Links open in a new tab so the game keeps running.

## Project layout

```
game.project                 Defold settings (960x640, HTML5 heap 64 MB, nearest texture filtering)
input/game.input_binding     WASD, arrows, E, Esc, mouse and multitouch
assets/tiny_dungeon.tilesource   Kenney Tiny Dungeon sheet: tilemap tiles and every sprite animation
main/main.collection         the room, the player, the HUD, four chests
main/room.tilemap            the room, edited by hand in the Defold editor
main/room.go                 tilemap component and wall collision
main/rooms.lua               room rectangle and title for the on-screen toast
main/player.go / .script     character: sprite, collision, camera, input, idle demo
main/movement.lua            pure movement math shared by keyboard and joystick
main/interactable.go / .script   a chest: distance check, idle/open/close animation, activates content
main/content.lua             the four links as data
main/overlay.lua             DOM overlay above the canvas via html5.run()
main/hud.go / .gui / .gui_script joystick, action button, hint, room title
tools/gen_world.py           historical map generator; not used since the room went hand-made
.github/workflows/deploy.yml build and deploy to GitHub Pages
```

### How the pieces talk

- `content.lua` maps a key to a link. Each chest instance in the collection carries that key as its `content`
  property, so adding a chest is one instance plus one table entry.
- `interactable.script` measures the distance to the player each frame and tells `player.script` when the
  player enters or leaves range. The player tells the HUD to show or hide the prompt and, on E or the button,
  sends `activate` back. The chest plays its opening animation, then calls the overlay.
- `overlay.lua` builds the card in the browser DOM, above the game canvas, and suspends game input until it is
  closed by Escape, the ✕ button, or a click on the backdrop. In the editor the overlay is simulated by a
  console print, and Escape closes it.
- The HUD lays itself out from the real window size, so it stays thumb-sized on phones in either orientation.
  The camera picks an integer zoom so about 16 tiles fit the shorter side of the window.

## Development

Open `game.project` in the Defold editor (1.13.1) and press Ctrl+B to run. The room tilemap and the chest
positions are edited in the editor; do not run `tools/gen_world.py`, it would overwrite them.

Command-line build with [bob](https://defold.com/manuals/bob/) needs Java 25 (the editor ships one under
`packages/jdk-25+36`) and the bob build matching the engine:

```bash
curl -L -o bob.jar https://d.defold.com/archive/stable/574678c7d44be490d874fbed2d0ae6211feec4d9/bob/bob.jar
java -jar bob.jar --platform wasm-web --architectures wasm-web --archive --variant release --bundle-output dist resolve build bundle
```

The bundle lands in `dist/interactive-portfolio/`. Serve that folder with any static server to test locally.
`build/` is reserved by Defold and cannot be used as the bundle target.

## Deployment

Every push to `main` runs `.github/workflows/deploy.yml`: download bob for the pinned engine SHA, bundle for
`wasm-web`, publish the bundle to GitHub Pages. The bundle is never committed. Bump `DEFOLD_VERSION` and
`DEFOLD_SHA1` at the top of the workflow when upgrading the editor.

## License and credits

Code is MIT, see `LICENSE`. Art is Kenney's Tiny Dungeon (CC0), listed with its license in `CREDITS.md`.
