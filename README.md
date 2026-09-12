# Interactive Portfolio

A walkable portfolio built with [Defold](https://defold.com). The visitor controls a character who walks through
four rooms; each room is a chapter of a career, and interacting with an object opens the real content behind it:
talks and a podcast on YouTube, repositories on GitHub, notes from the resume, and contact links.

Live: `https://cosgunhalil.github.io/interactive-portfolio/`

## Controls

| | Move | Interact | Close overlay |
|---|---|---|---|
| Desktop | WASD or arrow keys | E | Esc, ✕, or click outside |
| Mobile | Virtual joystick (lower left) | Action button (lower right) | ✕ button |

## Rooms

| Room | Position | Content |
|---|---|---|
| Talks & Podcast | spawn, bottom-left | presentations playlist, podcast playlist, welcome sign |
| Open Source | bottom-right | Tickwise, Jotphant, HannibalUI, Design Patterns, GitHub profile |
| Games | top-left | Head Ball 2, Basketball Arena, Unity years |
| About & Contact | top-right | bio, LinkedIn, website, email |

## How it is built

- `main/content.lua` holds every piece of content as data: type (`video`, `playlist`, `link`, `text`), prompt,
  title, payload, sprite frame. Adding content is adding an entry here.
- `tools/gen_world.py` generates the map: `main/room.tilemap`, `main/room.go` (wall collision) and
  `main/main.collection` (spawn, HUD, and one `interactable.go` per object), plus `main/rooms.lua` for room titles.
  Edit its `ROOMS` table and re-run `python tools/gen_world.py`. Do not hand-edit the generated files.
- `main/overlay.lua` opens content in a DOM overlay above the canvas through `html5.run()`, so YouTube plays in
  its real player and links open in a new tab without unloading the game. Input is suspended while it is open.
- Art is Kenney's Tiny Dungeon (CC0), see `CREDITS.md`.

## Development

Open `game.project` in the Defold editor (1.13.1). `Project > Build` runs the game locally. Outside HTML5 the
overlay is simulated with a console print, and Escape closes it.

Command-line build with [bob](https://defold.com/manuals/bob/), matching the engine version. Requires Java 25
(the editor ships one under `packages/jdk-25+36`):

```bash
curl -L -o bob.jar https://d.defold.com/archive/stable/574678c7d44be490d874fbed2d0ae6211feec4d9/bob/bob.jar
java -jar bob.jar --platform wasm-web --architectures wasm-web --archive --variant release --bundle-output dist resolve build bundle
```

The bundle lands in `dist/interactive-portfolio/`. `build/` is reserved by Defold and cannot be used as the bundle target.

## Deployment

Every push to `main` runs `.github/workflows/deploy.yml`, which builds the HTML5 bundle with bob and publishes it
to GitHub Pages. The bundle is never committed. Defold version and engine SHA are pinned at the top of the workflow.

## License

Code is MIT, see `LICENSE`. Third-party art and other assets are listed with their licenses in `CREDITS.md`.
