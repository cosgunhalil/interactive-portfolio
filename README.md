# Interactive Portfolio

A walkable portfolio built with [Defold](https://defold.com). The visitor controls a character who moves through
rooms; each room is a chapter of a career, and interacting with an object opens the real content behind it:
a talk on YouTube, a repository, an article.

Live: `https://<user>.github.io/interactive-portfolio/`

## Controls

| | Move | Interact | Close overlay |
|---|---|---|---|
| Desktop | WASD or arrow keys | E | Esc or click outside |
| Mobile | Virtual joystick (lower left) | Action button (lower right) | Close button |

## Development

Open `game.project` in the Defold editor (1.13.1). `Project > Build` runs the game locally.

Command-line build with [bob](https://defold.com/manuals/bob/), matching the engine version:

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
