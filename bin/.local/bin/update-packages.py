#!/usr/bin/env python3

import subprocess


def main() -> int:
    subprocess.run(["yay", "-Syu", "--noconfirm"])
    input("Done. Press enter to exit!")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
