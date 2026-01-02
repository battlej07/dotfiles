#!/usr/bin/env python3


import subprocess


def main() -> int:
    fzf_args = [
        "--multi",
        "--preview",
        "'yay -Sii {1}'",
        "--preview-label",
        "'alt-p: toggle description, alt-j/k: scroll, tab: multi-select'",
        "--preview-label-pos",
        "'bottom'",
        "--preview-window",
        "'down:65%:wrap'",
        "--bind",
        "'alt-p:toggle-preview'",
        "--bind",
        "'alt-d:preview-half-page-down,alt-u:preview-half-page-up'",
        "--bind",
        "'alt-k:preview-up,alt-j:preview-down'",
        "--color",
        "'pointer:green,marker:green'",
    ]

    try:
        result = subprocess.run(
            ["bash", "-lc", f"yay -Qq | fzf {' '.join(fzf_args)}"],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
        )
    except subprocess.CalledProcessError as e:
        return 0 if e.returncode in (130,) else e.returncode

    pkgs = [line.strip() for line in result.stdout.splitlines() if line.strip]
    if not pkgs:
        print("No packages selected.")
        return 0

    print("Selected:", " ".join(pkgs))

    ans = (
        input(
            f"Uninstalling {len(pkgs)} package{'s' if len(pkgs) > 1 else ''}. Proceed? [Y/n] "
        )
        .strip()
        .lower()
    )

    if ans in ("", "y", "yes"):
        subprocess.run(["yay", "-Rns", "--noconfirm", *pkgs], check=False)

    input("Done. Press enter to close!")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
