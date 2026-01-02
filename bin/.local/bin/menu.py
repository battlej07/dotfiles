#!/usr/bin/env python3

import os
import shlex
import subprocess
from dataclasses import dataclass
from enum import Enum
from typing import Callable, Union, cast
import sys


class ActionKind(Enum):
    COMMAND = "command"
    SUBMENU = "submenu"


MenuFactory = Callable[[], list["MenuItem"]]


@dataclass(frozen=True)
class MenuItem:
    icon: str
    label: str
    kind: ActionKind
    payload: Union[str, MenuFactory]


def format_options(menu: list[MenuItem]) -> str:
    return "\n".join(f"{item.icon} {item.label}" for item in menu)


def choose_with_walker(prompt: str, options: str) -> str | None:
    p = subprocess.run(
        ["walker", "--dmenu", "-p", prompt],
        input=options,
        text=True,
        capture_output=True,
    )
    if p.returncode != 0:
        return None

    return p.stdout.strip() or None


def run_menu(menu_factory: MenuFactory, prompt: str = "Menu") -> None:
    stack: list[tuple[str, MenuFactory]] = [(prompt, menu_factory)]

    while stack:
        cur_prompt, cur_factory = stack[-1]
        menu = cur_factory()

        if len(stack) > 1:
            menu = menu + [MenuItem(" ", "Back", ActionKind.SUBMENU, lambda: [])]

        selection = choose_with_walker(cur_prompt, format_options(menu))

        if not selection:
            return

        picked = next(
            (item for item in menu if f"{item.icon} {item.label}" == selection), None
        )

        if not picked:
            continue

        if picked.label == "Back" and len(stack) > 1:
            stack.pop()
            continue

        if picked.kind == ActionKind.COMMAND:
            if not isinstance(picked.payload, str):
                return

            subprocess.Popen(
                ["fish", "-lc", picked.payload],
                start_new_session=True,
                env=os.environ.copy(),
            )
            return

        if picked.kind == ActionKind.SUBMENU:
            submenu_factory = picked.payload
            if callable(submenu_factory):
                stack.append((picked.label, submenu_factory))


def _normalize_key(s: str) -> str:
    return s.strip().lower().replace(" ", "-").replace("_", "-")


def open_path(start_factory: MenuFactory, path: str) -> tuple[str, MenuFactory]:
    factory = start_factory
    prompt = "Menu"

    parts = [p for p in path.split("/") if p]
    for part in parts:
        key = _normalize_key(part)

        items = factory()
        match = next(
            (
                it
                for it in items
                if it.kind == ActionKind.SUBMENU
                and _normalize_key(it.label) == key
                and callable(it.payload)
            ),
            None,
        )

        if not match:
            raise SystemExit(f"Unknown menu path segment: {part}")

        prompt = match.label
        factory = cast(MenuFactory, match.payload)

    return prompt, factory


# -------------- MENUS --------------


def packages() -> list[MenuItem]:
    return [
        MenuItem(" ", "Update", ActionKind.COMMAND, "tui-float.py update-packages.py"),
        MenuItem(
            " ", "Install", ActionKind.COMMAND, "tui-float.py install-packages.py"
        ),
        MenuItem(
            " ", "Uninstall", ActionKind.COMMAND, "tui-float.py uninstall-package.py"
        ),
    ]


def settings() -> list[MenuItem]:
    return [
        MenuItem(" ", "Audio", ActionKind.COMMAND, "tui-float.py wiremix"),
        MenuItem(" ", "Bluetooth", ActionKind.COMMAND, "tui-float.py bluetui"),
        MenuItem(" ", "Network", ActionKind.COMMAND, "tui-float.py nmtui"),
    ]


def power() -> list[MenuItem]:
    return [
        MenuItem(" ", "Lock", ActionKind.COMMAND, "hyprlock"),
        MenuItem(" ", "Shutdown", ActionKind.COMMAND, "systemctl poweroff"),
        MenuItem(" ", "Reboot", ActionKind.COMMAND, "systemctl reboot"),
        MenuItem("󰍃 ", "Logout", ActionKind.COMMAND, "hyprctl dispatch exit"),
        MenuItem(" ", "Suspend", ActionKind.COMMAND, "systemctl suspend"),
    ]


def root() -> list[MenuItem]:
    return [
        MenuItem(" ", "Applications", ActionKind.COMMAND, "walker"),
        MenuItem(" ", "Packages", ActionKind.SUBMENU, packages),
        MenuItem(" ", "Settings", ActionKind.SUBMENU, settings),
        MenuItem(" ", "Power", ActionKind.SUBMENU, power),
    ]


if __name__ == "__main__":
    start = root
    prompt = "System"

    if len(sys.argv) > 1:
        prompt, start = open_path(root, sys.argv[1])

    run_menu(start, prompt)
