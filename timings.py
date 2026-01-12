from contextlib import contextmanager
import time
from datetime import datetime
from typing import IO
from dataclasses import dataclass

timer_indent = 0
log_file: IO[str]
name: str


def init(n: str):
    global log_file, name
    name = n
    log_file = open(f"log_times_{name}", "a")
    tprint(f"___________({name}) {datetime.now()}___________")


def fprint(*args, **kwargs):
    print("run.py:", *args, **kwargs, flush=True)


def tprint(*args, **kwargs):
    fprint(*args, **kwargs, file=log_file, sep="")


def timer_start(n: str):
    global timer_indent
    tprint("  " * timer_indent, f"Starting {n} ", "{")
    timer_indent += 1
    return time.time()


def timer_end(start: float, name: str):
    end = time.time()
    took = end - start
    global timer_indent
    tprint("  " * timer_indent, f"{name} took {took}s")
    timer_indent -= 1
    tprint("  " * timer_indent, "}")
    return took


@dataclass
class TimeRef:
    time: float = 0


@contextmanager
def timer(name: str):
    ref = TimeRef()
    start = timer_start(name)
    yield ref
    ref.time = timer_end(start, name)
