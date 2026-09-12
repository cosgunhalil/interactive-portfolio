"""Generate the world: main/room.tilemap, main/room.go (wall collision), main/main.collection and main/rooms.lua.

Run from the project root:  python tools/gen_world.py

Layout: a 2 x 2 grid of rooms, each ROOM_W x ROOM_H interior cells, separated by one-cell walls with
two-cell doorways. Tiles are Kenney Tiny Dungeon indices (0-based, 12 columns); Defold ids are +1.
World units are pixels, 16 per tile; the tilemap is offset so the whole map is centred on the origin.

Objects (interactables) are listed per room with their content key (see main/content.lua), sprite
animation and local cell. Edit the tables below and re-run; do not hand-edit the generated files.
"""
import random

ROOM_W, ROOM_H = 24, 16
COLS, ROWS = 2, 2
W = COLS * ROOM_W + COLS + 1
H = ROWS * ROOM_H + ROWS + 1
OX, OY = -W * 8, -H * 8  # tilemap component offset so the map is centred on the world origin
SEED = 7

SAND = [48, 48, 48, 48, 48, 49, 50, 51]
DARK = [1, 1, 1, 1, 0, 12]
WALL_FACE, WALL_CAP, TORCH = 40, 58, 130

# rooms keyed by (col, row); row 0 is the bottom row
ROOMS = {
    (0, 0): dict(name="talks", title="Talks & Podcast", floor=SAND, objects=[
        ("spawn_sign", "sign", (9, 6)),
        ("talks_monitor", "monitor", (16, 10)),
        ("podcast_radio", "podcast", (6, 10)),
    ], decor={(2, 14): 75, (3, 14): 75, (4, 14): 63, (20, 2): 89, (21, 2): 56}),
    (1, 0): dict(name="open_source", title="Open Source", floor=DARK, objects=[
        ("sign_open_source", "sign", (3, 8)),
        ("repo_tickwise", "chest", (7, 10)),
        ("repo_jotphant", "chest", (11, 10)),
        ("repo_hannibalui", "chest", (15, 10)),
        ("repo_designpatterns", "chest", (19, 10)),
        ("github_profile", "badge", (12, 4)),
    ], decor={(20, 14): 72, (19, 14): 73, (21, 14): 73, (2, 2): 56}),
    (0, 1): dict(name="games", title="Games", floor=SAND, objects=[
        ("sign_games", "sign", (3, 8)),
        ("game_headball2", "crate", (8, 10)),
        ("game_basketball_arena", "crate", (15, 10)),
        ("unity_years", "table", (12, 4)),
    ], decor={(20, 14): 75, (21, 14): 75, (2, 14): 66, (21, 2): 89}),
    (1, 1): dict(name="about", title="About & Contact", floor=DARK, objects=[
        ("sign_about", "sign", (3, 8)),
        ("about_bio", "person", (12, 9)),
        ("about_linkedin", "badge", (7, 4)),
        ("about_website", "shelf", (17, 4)),
        ("about_email", "potion", (12, 13)),
    ], decor={(2, 14): 72, (3, 14): 73, (20, 2): 56, (21, 2): 56}),
}
SPAWN_ROOM, SPAWN_CELL = (0, 0), (12, 8)


def interior_origin(col, row):
    return 1 + col * (ROOM_W + 1), 1 + row * (ROOM_H + 1)


def world(x, y):
    """Centre of cell (x, y) in world units."""
    return OX + x * 16 + 8, OY + y * 16 + 8


def build_grid():
    floor = {}   # (x, y) -> tile
    wall = set()
    for y in range(H):
        for x in range(W):
            wall.add((x, y))
    rng = random.Random(SEED)
    for (c, r), room in ROOMS.items():
        ix, iy = interior_origin(c, r)
        for y in range(iy, iy + ROOM_H):
            for x in range(ix, ix + ROOM_W):
                wall.discard((x, y))
                floor[(x, y)] = rng.choice(room["floor"])
    # doorways: two cells wide, centred on the shared wall
    for c in range(COLS - 1):
        wx = interior_origin(c + 1, 0)[0] - 1
        for r in range(ROWS):
            iy = interior_origin(0, r)[1]
            for y in (iy + ROOM_H // 2 - 1, iy + ROOM_H // 2):
                wall.discard((wx, y)); floor[(wx, y)] = SAND[0]
    for r in range(ROWS - 1):
        wy = interior_origin(0, r + 1)[1] - 1
        for c in range(COLS):
            ix = interior_origin(c, 0)[0]
            for x in (ix + ROOM_W // 2 - 1, ix + ROOM_W // 2):
                wall.discard((x, wy)); floor[(x, wy)] = SAND[0]
    return floor, wall


def wall_tile(x, y, wall):
    # a wall cell with open floor directly below it shows its brick face
    return WALL_FACE if (x, y - 1) not in wall and y > 0 else WALL_CAP


def cell(x, y, t):
    return f"  cell {{\n    x: {x}\n    y: {y}\n    tile: {t + 1}\n    h_flip: 0\n    v_flip: 0\n  }}\n"


def layer(id_, z, cells):
    return f'layers {{\n  id: "{id_}"\n  z: {z}\n  is_visible: 1\n' + "".join(cells) + "}\n"


def write_tilemap(floor, wall):
    fl = [cell(x, y, t) for (x, y), t in sorted(floor.items())]
    wl = [cell(x, y, wall_tile(x, y, wall)) for (x, y) in sorted(wall)]
    dc = []
    for (c, r), room in ROOMS.items():
        ix, iy = interior_origin(c, r)
        for (lx, ly), t in room["decor"].items():
            dc.append(cell(ix + lx, iy + ly, t))
        for lx in (4, ROOM_W // 2, ROOM_W - 5):  # torches on each room's north wall
            if (ix + lx, iy + ROOM_H) in wall:
                dc.append(cell(ix + lx, iy + ROOM_H, TORCH))
    text = ('tile_set: "/assets/tiny_dungeon.tilesource"\n'
            + layer("floor", 0.0, fl) + layer("walls", 0.01, wl) + layer("decor", 0.02, dc)
            + 'material: "/builtins/materials/tile_map.material"\nblend_mode: BLEND_MODE_ALPHA\n')
    open("main/room.tilemap", "w", encoding="utf-8", newline="\n").write(text)
    return len(fl), len(wl), len(dc)


def wall_boxes(wall):
    """Merge wall cells into boxes: horizontal runs first, leftover singles merged vertically."""
    boxes = []
    used = set()
    for y in range(H):
        x = 0
        while x < W:
            if (x, y) in wall and (x, y) not in used:
                x0 = x
                while (x + 1, y) in wall and (x + 1, y) not in used:
                    x += 1
                if x > x0:
                    for xx in range(x0, x + 1):
                        used.add((xx, y))
                    boxes.append((x0, y, x, y))
            x += 1
    for x in range(W):
        y = 0
        while y < H:
            if (x, y) in wall and (x, y) not in used:
                y0 = y
                while (x, y + 1) in wall and (x, y + 1) not in used:
                    y += 1
                for yy in range(y0, y + 1):
                    used.add((x, yy))
                boxes.append((x, y0, x, y))
            y += 1
    return boxes


def write_room_go(boxes):
    shapes, data = [], []
    for i, (x0, y0, x1, y1) in enumerate(boxes):
        cx = OX + (x0 + x1 + 1) * 8
        cy = OY + (y0 + y1 + 1) * 8
        hx, hy = (x1 - x0 + 1) * 8, (y1 - y0 + 1) * 8
        shapes.append(
            '  "  shapes {\\n"\n  "    shape_type: TYPE_BOX\\n"\n'
            f'  "    position {{\\n"\n  "      x: {cx:.1f}\\n"\n  "      y: {cy:.1f}\\n"\n  "    }}\\n"\n'
            '  "    rotation {\\n"\n  "    }\\n"\n'
            f'  "    index: {i * 3}\\n"\n  "    count: 3\\n"\n  "    id: \\"wall_{i}\\"\\n"\n  "  }}\\n"\n')
        data.append(f'  "  data: {hx:.1f}\\n"\n  "  data: {hy:.1f}\\n"\n  "  data: 10.0\\n"\n')
    text = (
        'components {\n  id: "tilemap"\n  component: "/main/room.tilemap"\n'
        f'  position {{\n    x: {OX:.1f}\n    y: {OY:.1f}\n    z: 0.0\n  }}\n}}\n'
        'embedded_components {\n  id: "walls"\n  type: "collisionobject"\n'
        '  data: "type: COLLISION_OBJECT_TYPE_STATIC\\n"\n  "mass: 0.0\\n"\n  "friction: 0.1\\n"\n'
        '  "restitution: 0.5\\n"\n  "group: \\"wall\\"\\n"\n  "mask: \\"player\\"\\n"\n'
        '  "embedded_collision_shape {\\n"\n' + "".join(shapes) + "".join(data)
        + '  "}\\n"\n  ""\n}\n')
    open("main/room.go", "w", encoding="utf-8", newline="\n").write(text)


def instance(id_, proto, x, y, z, props=None):
    s = (f'instances {{\n  id: "{id_}"\n  prototype: "{proto}"\n'
         f'  position {{\n    x: {x:.1f}\n    y: {y:.1f}\n    z: {z}\n  }}\n  rotation {{\n  }}\n'
         '  scale3 {\n    x: 1.0\n    y: 1.0\n    z: 1.0\n  }\n')
    if props:
        s += '  component_properties {\n    id: "script"\n'
        for pid, val, typ in props:
            s += f'    properties {{\n      id: "{pid}"\n      value: "{val}"\n      type: {typ}\n    }}\n'
        s += "  }\n"
    return s + "}\n"


def write_collection():
    out = ['name: "main"\n']
    out.append(instance("room", "/main/room.go", 0, 0, "0.0"))
    sx, sy = interior_origin(*SPAWN_ROOM)
    px, py = world(sx + SPAWN_CELL[0], sy + SPAWN_CELL[1])
    out.append(instance("player", "/main/player.go", px, py, "0.1"))
    out.append(instance("hud", "/main/hud.go", 0, 0, "0.0"))
    for (c, r), room in ROOMS.items():
        ix, iy = interior_origin(c, r)
        for key, _anim, (lx, ly) in room["objects"]:
            x, y = world(ix + lx, iy + ly)
            out.append(instance(key, "/main/interactable.go", x, y, "0.05",
                                [("content", key, "PROPERTY_TYPE_HASH")]))
    out.append("scale_along_z: 0\n")
    open("main/main.collection", "w", encoding="utf-8", newline="\n").write("".join(out))


def write_rooms_lua():
    """World-space rectangles (including half the surrounding wall, so doorways belong to a room)."""
    out = ["-- GENERATED by tools/gen_world.py. Room rectangles in world units, used for the room title toast.\n",
           "return {\n"]
    for (c, r), room in ROOMS.items():
        ix, iy = interior_origin(c, r)
        x0, y0 = OX + (ix - 0.5) * 16, OY + (iy - 0.5) * 16
        x1, y1 = OX + (ix + ROOM_W + 0.5) * 16, OY + (iy + ROOM_H + 0.5) * 16
        out.append(f'\t{{ id = "{room["name"]}", title = "{room["title"]}", '
                   f'x0 = {x0:.1f}, y0 = {y0:.1f}, x1 = {x1:.1f}, y1 = {y1:.1f} }},\n')
    out.append("}\n")
    open("main/rooms.lua", "w", encoding="utf-8", newline="\n").write("".join(out))


def main():
    floor, wall = build_grid()
    counts = write_tilemap(floor, wall)
    boxes = wall_boxes(wall)
    write_room_go(boxes)
    write_collection()
    write_rooms_lua()
    print(f"map {W}x{H} cells, offset ({OX},{OY}); {counts[0]} floor / {counts[1]} wall / {counts[2]} decor cells; "
          f"{len(boxes)} wall boxes; {sum(len(r['objects']) for r in ROOMS.values())} objects")


if __name__ == "__main__":
    main()
