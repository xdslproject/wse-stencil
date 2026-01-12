from traceback import format_exc
import sys
import json
import os, signal
from timings import init, timer, fprint
from pathlib import Path

try:
    from cerebras.sdk.client import SdkCompiler

    def run_compile(json_file: Path, prog: str, args: str, /):
        with timer("compiling in cluster"):
            with SdkCompiler(resource_cpu=50000) as compiler:
                artifact_path = compiler.compile(".", prog, args, ".")
                # Write the artifact_path to a JSON file
                with open(json_file, "w", encoding="utf8") as f:
                    json.dump({"artifact_path": artifact_path}, f)

except ModuleNotFoundError:

    def run_compile(_: Path, prog: str, args: str, /):
        with timer("compiling locally"):
            os.system(f"cslc {prog} {args}")


try:
    json_file = Path(sys.argv[1])
    if json_file.suffix != ".json":
        print(
            "Expected 1st argument to be a path to the json file to write artifact path to"
        )
        exit(1)
    prog = sys.argv[2]
    args = " ".join(sys.argv[3:])

    init(f"compiling")

    fprint(f"{prog} {args} > {json_file}")
    run_compile(json_file, prog, args)
except:
    fprint("Error:\n", format_exc(), sep="")
finally:
    os.kill(os.getpid(), signal.SIGTERM)
