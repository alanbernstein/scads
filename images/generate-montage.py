import json
import math
import subprocess
from pathlib import Path

github_repo_base_url = 'https://github.com/alanbernstein/scads/blob/master'

def run(cmd):
    subprocess.run(cmd, check=True)

def generate_montage(config_path):
    with open(config_path) as f:
        cfg = json.load(f)

    items = cfg["items"]
    cols = cfg.get("columns", 3)
    thumb_w, thumb_h = cfg.get("thumb_size", [300, 200])
    pad = cfg.get("padding", 20)
    font = cfg.get("font", "Arial-Bold")
    font_size = cfg.get("font_size", 48)
    stroke_width = cfg.get("stroke_width", 3)
    out_image = cfg.get("output_image", "montage.png")

    rows = math.ceil(len(items) / cols)

    canvas_w = cols * thumb_w + (cols + 1) * pad
    canvas_h = rows * thumb_h + (rows + 1) * pad

    tmp = Path("_montage_tmp")
    tmp.mkdir(exist_ok=True)

    numbered_images = []
    markdown_lines = []
    for idx, item in enumerate(items, start=1):
        out = tmp / f"thumb_{idx}.jpg"

        label_x = 5
        label_y = 0

        cmd = [
            "convert",
            item["image"],
            "-resize", f"{thumb_w}x{thumb_h}^",
            "-gravity", "SouthWest",
            "-extent", f"{thumb_w}x{thumb_h}",

            # Number label with outline
            "-font", font,
            "-pointsize", str(font_size),
            "-fill", "white",
            "-stroke", "black",
            "-strokewidth", str(stroke_width),
            "-annotate", f"+{label_x}+{label_y}", str(idx),

            out.as_posix()
        ]

        run(cmd)
        numbered_images.append(out)

        label = item.get("label", f"Item {idx}")
        markdown_lines.append(f"{idx}. [{label}]({github_repo_base_url}/{item['scad']})")

    # Build montage
    tile = f"{cols}x{rows}"
    geometry = f"{thumb_w}x{thumb_h}+{pad}+{pad}"

    montage_cmd = [
        "montage",
        *[img.as_posix() for img in numbered_images],
        "-background", "white",
        "-geometry", geometry,
        "-tile", tile,
        out_image
    ]
    run(montage_cmd)

    print("# Montage\n")
    print(f"![Montage]({out_image})\n")
    for line in markdown_lines:
        print(line)

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage: python generate_montage_im.py montage.json")
        sys.exit(1)

    generate_montage(sys.argv[1])
