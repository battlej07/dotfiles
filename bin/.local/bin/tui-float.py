#!/usr/bin/env python3

import shlex
import subprocess
import sys


SHELL_METACHARS = set("|&;<>$`\\\n(){}[]*?!~=")


def needs_shell(cmd: str) -> bool:
    return any(c in cmd for c in SHELL_METACHARS)


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: tui-float.py <command...>", file=sys.stderr)
        return 2

    cmd_str = " ".join(sys.argv[1:])

    ghostty_base = [
        "ghostty",
        "--class=com.battlej07.tui-float",
        f"--title=TUI: {sys.argv[1]}",
    ]

    if needs_shell(cmd_str):
        argv = ghostty_base + ["-e", "bash", "-lc", cmd_str]
    else:
        argv = ghostty_base + ["-e"] + shlex.split(cmd_str)

    subprocess.run(argv, check=False)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
