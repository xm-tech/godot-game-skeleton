#!/usr/bin/env python3
"""把像素画精灵（辣椒主角 + 蛤蟆敌人）生成为 PNG。

每个精灵画在一个小的字符网格上（每个字符 = 一个像素颜色），
再用 SCALE 做最近邻放大，烘焙出「块状像素」效果。
运行：  python3 tools/gen_sprites.py
"""
import os
import struct
import zlib

SCALE = 2  # 把 2 倍放大烘焙进 PNG，让 Sprite2D 保持 scale (1,1)

# --------------------------------------------------------------------------
# 调色板
# --------------------------------------------------------------------------
PEPPER_PALETTE = {
    ".": (0, 0, 0, 0),          # 透明
    "K": (43, 18, 15, 255),     # 深色描边
    "R": (232, 67, 47, 255),    # 辣椒红
    "D": (190, 50, 35, 255),    # 深红（阴影）
    "G": (66, 176, 84, 255),    # 绿色辣椒蒂
    "g": (38, 120, 58, 255),    # 深绿
    "W": (255, 255, 255, 255),  # 眼白
    "B": (20, 20, 20, 255),     # 瞳孔
}

TOAD_PALETTE = {
    ".": (0, 0, 0, 0),          # 透明
    "K": (24, 40, 22, 255),     # 深绿黑色描边
    "G": (86, 158, 58, 255),    # 蛤蟆绿
    "L": (156, 204, 112, 255),  # 浅色肚皮
    "O": (240, 185, 52, 255),   # 金色眼睛
    "B": (22, 22, 22, 255),     # 瞳孔
}

# --------------------------------------------------------------------------
# 精灵网格（16x20）
# --------------------------------------------------------------------------
PEPPER = [
    "......GGGG......",
    ".....GGGGGG.....",
    "....GGGGGGGG....",
    ".....gGGGGg.....",
    "......KKKK......",
    ".....KRRRRK.....",
    "....KRRRRRRK....",
    "...KRRRRRRRRK...",
    "..KRRRRRRRRRRK..",
    "..KRRWWRRWWRRK..",
    "..KRRWBRRWBRRK..",
    "..KRRWWRRWWRRK..",
    "..KRRRRRRRRRRK..",
    "...KRRRRRRRRK...",
    "....KRRRRRRK....",
    ".....KRRRRK.....",
    "......KKKK......",
    ".....KK..KK.....",
    ".....KK..KK.....",
    ".....KK..KK.....",
]

TOAD = [
    "..KK........KK..",
    ".KOOK......KOOK.",
    ".KOBK......KOBK.",
    ".KOOK......KOOK.",
    "..KK........KK..",
    "...KKKKKKKKKK...",
    "..KGGGGGGGGGGK..",
    ".KGGGGGGGGGGGGK.",
    ".KGGGGGGGGGGGGK.",
    "KGGGGGGGGGGGGGGK",
    "KGGLLGGGGGGLLGGK",
    "KGGGGGGGGGGGGGGK",
    "KGGGGKKKKKKGGGGK",
    "KGGGGKGGGGKGGGGK",
    "KGGGGGGGGGGGGGGK",
    ".KGGGGGGGGGGGGK.",
    "..KKKKKKKKKKKK..",
    ".KKK........KKK.",
    ".KKK........KKK.",
    "KKKKK......KKKKK",
]


def write_png(path, width, height, pixels):
    """pixels：按行排列的 (r, g, b, a) 元组列表。"""

    def chunk(typ, data):
        c = struct.pack(">I", len(data)) + typ + data
        c += struct.pack(">I", zlib.crc32(typ + data) & 0xFFFFFFFF)
        return c

    raw = bytearray()
    for y in range(height):
        raw.append(0)  # 过滤类型 0（无）
        for x in range(width):
            r, g, b, a = pixels[y * width + x]
            raw += struct.pack("BBBB", r, g, b, a)

    ihdr = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    png = b"\x89PNG\r\n\x1a\n"
    png += chunk(b"IHDR", ihdr)
    png += chunk(b"IDAT", zlib.compress(bytes(raw), 9))
    png += chunk(b"IEND", b"")
    with open(path, "wb") as f:
        f.write(png)


def render(grid, palette, path):
    h = len(grid)
    w = len(grid[0])
    out = []
    for row in grid:
        assert len(row) == w, f"行宽不一致: {row!r}"
        for ch in row:
            out.append(palette[ch])
    # 最近邻放大
    big_w, big_h = w * SCALE, h * SCALE
    big = []
    for y in range(h):
        for _ in range(SCALE):
            for x in range(w):
                for _ in range(SCALE):
                    big.append(out[y * w + x])
    write_png(path, big_w, big_h, big)
    print(f"已生成 {path} ({w}x{h} -> {big_w}x{big_h})")


def main():
    os.makedirs("assets/sprites", exist_ok=True)
    render(PEPPER, PEPPER_PALETTE, "assets/sprites/player.png")
    render(TOAD, TOAD_PALETTE, "assets/sprites/enemy.png")


if __name__ == "__main__":
    main()
