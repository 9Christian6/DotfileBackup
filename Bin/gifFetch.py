#!/usr/bin/python3
"""Show fastfetch beside a GIF that Kitty continues animating after exit."""

import argparse
from contextlib import ExitStack
import fcntl
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys
import termios
import tempfile
import unicodedata


IMAGE_ID = 1734960710
HOME = Path.home()
CONFIG_FILE = HOME / ".config/gifFetch/config"
DEFAULT_GIF = HOME / "Videos/space rotate GIF by Erica Anderson.gif"
ANSI = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]")


def configured_gif():
    """Read a plain GIF path from the config, falling back when absent."""
    try:
        value = CONFIG_FILE.read_text(encoding="utf-8").strip()
    except FileNotFoundError:
        return DEFAULT_GIF
    if not value:
        raise ValueError(f"empty GIF configuration: {CONFIG_FILE}")
    path = Path(value).expanduser()
    return path if path.is_absolute() else CONFIG_FILE.parent / path


def clipped(line, width):
    """Keep ANSI styling while preventing text from wrapping into the image."""
    result = []
    column = 0
    index = 0
    while index < len(line):
        match = ANSI.match(line, index)
        if match:
            result.append(match[0])
            index = match.end()
            continue
        char = line[index]
        size = 0 if unicodedata.combining(char) else (
            2 if unicodedata.east_asian_width(char) in "WF" else 1
        )
        if column + size > width:
            break
        result.append(char)
        column += size
        index += 1
    return "".join(result) + "\x1b[0m"


def transparent_frame(frame, threshold):
    """Preserve existing alpha and remove pixels whose RGB channels are dark."""
    from PIL import ImageChops

    rgba = frame.convert("RGBA")
    if threshold:
        red, green, blue, alpha = rgba.split()
        brightest = ImageChops.lighter(ImageChops.lighter(red, green), blue)
        mask = brightest.point(lambda value: 0 if value <= threshold else 255)
        rgba.putalpha(ImageChops.multiply(alpha, mask))
    return rgba


def save_transparent_gif(frames, durations, destination):
    """Reserve palette index 255 for transparency in every full GIF frame."""
    from PIL import Image

    indexed = []
    for frame in frames:
        palette = frame.convert("RGB").quantize(colors=255)
        palette.putpalette(palette.getpalette()[:765] + [0, 0, 0])
        palette.paste(255, mask=frame.getchannel("A").point(
            lambda alpha: 255 if alpha < 128 else 0))
        palette.info["transparency"] = 255
        indexed.append(palette)
    indexed[0].save(destination, save_all=True, append_images=indexed[1:],
                    duration=durations, loop=0, disposal=2, transparency=255,
                    background=255, optimize=False)


def transparent_gif(path, destination, threshold):
    from PIL import Image, ImageSequence

    with Image.open(path) as source:
        frames = []
        durations = []
        for frame in ImageSequence.Iterator(source):
            frames.append(transparent_frame(frame, threshold))
            durations.append(frame.info.get("duration", 100))
        save_transparent_gif(frames, durations, destination)


def ascii_gif(path, destination, width, height, cell_aspect, threshold=32):
    """Bake colored ASCII glyphs into frames for Kitty-owned playback."""
    from PIL import Image, ImageDraw, ImageFont, ImageSequence

    ramp = " .:-=+*#%@"
    font = ImageFont.truetype("DejaVuSansMono.ttf", 18)
    glyph_height = 24
    glyph_width = max(1, round(glyph_height * cell_aspect))
    frames = []
    durations = []
    with Image.open(path) as source:
        scale = min(width / source.width,
                    height / (source.height * cell_aspect))
        size = (max(1, round(source.width * scale)),
                max(1, round(source.height * scale * cell_aspect)))
        # Pillow composites GIF disposal/transparency while iterating.
        for frame in ImageSequence.Iterator(source):
            rgba = transparent_frame(frame, threshold)
            sample = rgba.resize(size, Image.Resampling.LANCZOS)
            canvas = Image.new("RGBA", (size[0] * glyph_width,
                                        size[1] * glyph_height), (0, 0, 0, 0))
            draw = ImageDraw.Draw(canvas)
            for y in range(size[1]):
                for x in range(size[0]):
                    color = sample.getpixel((x, y))
                    red, green, blue, alpha = color
                    if alpha < 128 or (threshold and max(red, green, blue) <= threshold):
                        continue
                    luminance = (299 * red + 587 * green + 114 * blue) / 1000
                    char = ramp[round(luminance * (len(ramp) - 1) / 255)]
                    draw.text((x * glyph_width + glyph_width / 2,
                               y * glyph_height + glyph_height / 2),
                              char, font=font, fill=color, anchor="mm")
            frames.append(canvas)
            durations.append(frame.info.get("duration", 100))
        save_transparent_gif(frames, durations, destination)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("gif", nargs="?", type=Path,
                        help=f"GIF path (default: path in {CONFIG_FILE})")
    parser.add_argument("--width", type=int, default=40, help="maximum GIF width in cells (default: 40)")
    parser.add_argument("--height", type=int, default=18, help="maximum GIF height in cells (default: 18)")
    parser.add_argument("--config", type=Path, help="fastfetch configuration file")
    parser.add_argument("--ascii", action="store_true",
                        help="show an animated colored ASCII GIF (requires Pillow)")
    parser.add_argument("--dark-threshold", type=int, default=32,
                        help="make pixels with all RGB channels <= this value transparent (0 disables; default: 32)")
    parser.add_argument("--clear", action="store_true", help="remove the gifFetch image")
    args = parser.parse_args()
    if args.clear:
        if not sys.stdout.isatty():
            parser.error("--clear requires a terminal")
        sys.stdout.write(f"\x1b_Ga=d,d=I,i={IMAGE_ID},q=2;\x1b\\")
        sys.stdout.flush()
        return 0
    if args.width < 1 or args.height < 1:
        parser.error("width and height must be positive")
    if not 0 <= args.dark_threshold <= 255:
        parser.error("dark-threshold must be between 0 and 255")
    fastfetch = shutil.which("fastfetch")
    if not fastfetch:
        parser.error("fastfetch is not installed")
    command = [fastfetch]
    if args.config:
        command += ["--config", str(args.config.expanduser())]
    command += ["--logo", "none"]
    # Redirected output remains useful as plain system information.
    if not sys.stdout.isatty():
        return subprocess.call(command + ["--pipe", "true"])
    if not (os.environ.get("KITTY_WINDOW_ID") or os.environ.get("TERM") == "xterm-kitty"):
        parser.error("animated images require Kitty; run gifFetch in a Kitty terminal")
    kitty = shutil.which("kitty")
    if not kitty:
        parser.error("kitty is not installed")
    try:
        gif = args.gif.expanduser() if args.gif is not None else configured_gif()
    except (OSError, ValueError) as error:
        parser.error(f"cannot read GIF configuration: {error}")
    if not gif.is_file():
        parser.error(f"image not found: {gif}")

    info = subprocess.run(command + ["--pipe", "false"], capture_output=True, text=True)
    if info.returncode:
        sys.stderr.write(info.stderr)
        return info.returncode
    lines = info.stdout.rstrip("\n").splitlines()
    rows, columns, pixels_x, pixels_y = struct.unpack(
        "HHHH", fcntl.ioctl(sys.stdout.fileno(), termios.TIOCGWINSZ, bytes(8))
    )
    if columns < 40 or rows < len(lines) + 2:
        sys.stderr.write("gifFetch: terminal too small for GIF and information; showing information only.\n")
        sys.stdout.write(info.stdout)
        return 0
    width = min(args.width, max(12, columns // 2 - 2))
    height = min(args.height, rows - 2)
    block_height = max(height, len(lines))
    cell_x = pixels_x / columns if pixels_x else 10
    cell_y = pixels_y / rows if pixels_y else 20
    # Upload every frame before returning the prompt. Kitty owns playback in
    # both modes; temporary rendered GIFs can be removed after icat reads them.
    with ExitStack() as stack:
        if args.ascii or args.dark_threshold:
            directory = stack.enter_context(tempfile.TemporaryDirectory(prefix="gifFetch-"))
            rendered = Path(directory) / "rendered.gif"
            try:
                if args.ascii:
                    ascii_gif(gif, rendered, width, height, cell_x / cell_y, args.dark_threshold)
                else:
                    transparent_gif(gif, rendered, args.dark_threshold)
            except ImportError:
                parser.error("image rendering requires Pillow (python3-pil)")
            except (OSError, ValueError) as error:
                parser.error(f"cannot render image: {error}")
            gif = rendered
        image = subprocess.run([
            kitty, "+kitten", "icat", "--stdin=no", "--transfer-mode=stream",
            f"--use-window-size={width},{height},{max(1, int(width * cell_x))},{max(1, int(height * cell_y))}",
            "--fit=both", "--align=left", "--no-trailing-newline", "--loop=-1",
            f"--image-id={IMAGE_ID}", str(gif.resolve()),
        ], capture_output=True)
    if image.returncode:
        sys.stderr.buffer.write(image.stderr)
        return image.returncode

    output = sys.stdout.buffer
    # Reserve room first, so even a call near the bottom has space for the GIF.
    output.write(("\n" * block_height + f"\x1b[{block_height}A\r").encode())
    output.write(f"\x1b_Ga=d,d=I,i={IMAGE_ID},q=2;\x1b\\\x1b7".encode())
    output.write(image.stdout)
    output.write(b"\x1b8")
    for index in range(block_height):
        text = clipped(lines[index], columns - width - 3) if index < len(lines) else ""
        output.write((f"\r\x1b[{width + 2}C{text}\n").encode())
    output.write(b"\r")
    output.flush()
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
    except BrokenPipeError:
        sys.exit(0)
