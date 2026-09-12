"""Generate main/room.tilemap from a small layout description.

Run from the project root:  python tools/gen_room_tilemap.py

Cells use Kenney Tiny Dungeon indices (0-based, 12 columns); Defold tile ids are index + 1.
The room is W x H cells with a one-cell wall ring. room.go offsets the tilemap by
(-W*8, -H*8) so the interior is centred on the world origin (16 px per tile).
"""
import random

OUT = "main/room.tilemap"
W, H = 32, 22
FLOOR = [48, 48, 48, 48, 48, 48, 49, 50, 51]  # mostly plain sand with a few variants
WALL_NORTH, WALL_OTHER = 40, 58              # brick face on the far wall, stone cap elsewhere
DECOR = {  # (x, y): tile
    (3, 20): 75, (4, 20): 75, (5, 20): 63,        # shelves and a crate along the north wall
    (8, 16): 72, (7, 16): 73, (9, 16): 73,        # table with stools
    (28, 2): 89, (27, 2): 56,                    # chest and bucket in a corner
    (2, 2): 56, (2, 19): 66,                     # bucket, boulder
    (24, 18): 72, (25, 18): 73,                  # second table
    (6, 21): 130, (16, 21): 130, (26, 21): 130,  # torches on the north wall
}
SEED = 7


def cell(x, y, t):
    return f"  cell {{\n    x: {x}\n    y: {y}\n    tile: {t + 1}\n    h_flip: 0\n    v_flip: 0\n  }}\n"


def layer(id_, z, cells):
    return f'layers {{\n  id: "{id_}"\n  z: {z}\n  is_visible: 1\n' + "".join(cells) + "}\n"


def main():
    rng = random.Random(SEED)
    floor, walls, decor = [], [], []
    for y in range(H):
        for x in range(W):
            if x == 0 or x == W - 1 or y == 0 or y == H - 1:
                walls.append(cell(x, y, WALL_NORTH if y == H - 1 else WALL_OTHER))
            else:
                floor.append(cell(x, y, rng.choice(FLOOR)))
    for (x, y), t in DECOR.items():
        decor.append(cell(x, y, t))
    text = ('tile_set: "/assets/tiny_dungeon.tilesource"\n'
            + layer("floor", 0.0, floor) + layer("walls", 0.01, walls) + layer("decor", 0.02, decor)
            + 'material: "/builtins/materials/tile_map.material"\nblend_mode: BLEND_MODE_ALPHA\n')
    with open(OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    print(f"wrote {OUT}: {len(floor)} floor, {len(walls)} wall, {len(decor)} decor cells")


if __name__ == "__main__":
    main()
