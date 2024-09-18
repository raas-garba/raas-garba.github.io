#! /usr/bin/env python
"Create/update symlinks"

__author__ = "Paresh Adhia"
__copyright__ = "Copyright 2018-2019, Paresh Adhia"
__version__ = "0.1.0"

import sys
from argparse import ArgumentTypeError
from pathlib import Path
from tomllib import load
from typing import Any, Iterable, cast

type Schedule = dict[str, Schedule | list[str]]


def main(docs_dir: Path) -> None:
    "script entry-point"
    lib = {p.stem: p for d in docs_dir.iterdir() for p in d.resolve().rglob("*.md") if p.is_file()}

    schedules = (d for d in docs_dir.rglob("*.toml"))
    for s in schedules:
        fill_schedule(s, lib)


def fill_schedule(schedule_file: Path, lib: dict[str, Path]):
    with schedule_file.open("rb") as f:
        schedule = cast(Schedule, load(f))

    def iterpath(o: Schedule, parent: Path) -> Iterable[tuple[Path, Path | None]]:
        for k, v in o.items():
            if isinstance(v, list):
                yield from ((parent / k / f"{x}.md", lib.get(x)) for x in v)
            else:
                yield from iterpath(v, parent / str(k))


    links = dict(iterpath(schedule, schedule_file.parent / schedule_file.stem))
    for d in {k.parent for k, v in links.items() if v is not None}:
        d.mkdir(parents=True, exist_ok=True)

    for link, base in links.items():
        if base is None:
            print(f"No song file found for '{link}'", file=sys.stderr)
        else:
            if link.is_symlink():
                if link.samefile(base):
                    continue
                link.unlink()
            link.symlink_to(base)


def getargs():
    "script arguments; accept list paths to scan toc and root of library -- both optional"
    import argparse

    def existing_path(v: str) -> Path:
        p = Path(v)
        if not p.exists():
            raise ArgumentTypeError(f"'{v}' is not an existing path")
        return p.absolute()

    def mk_default(p: Path) -> dict[str, Any]:
        return {"default": p} if p.exists() else {"required": True}

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--docs-dir", **mk_default(Path.cwd() / "docs"), type=existing_path, help="Docs root directory (default: ./docs)"
    )

    return parser.parse_args()


def cli():
    main(**getargs().__dict__)


if __name__ == "__main__":
    cli()
