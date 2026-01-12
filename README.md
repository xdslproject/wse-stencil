# WSE stencil examples


## Setup

Install all requirements and ensure that `mlir-opt` and `cslc` are in `PATH`

```sh
python -m venv venv
. ./venv/bin/activate
pip install -r requirements.txt
```

### Test that setup was successful

The following should compile and run a simulator program with no errors.

```sh
./driver.sh smoke-test
```

## Compiling and running

`driver.sh` is the main compiler driver. It can compile and run the provided `.mlir`
files.

### Flags

By default, the driver will perform two compilation steps (`xdsl` and `cslc`)
and then launch the simulator.

> [!NOTE]
> All flag arguments are of the form `--flag=ARG`


| Flag                 | Meaning                                          |
| -------------------- | ------------------------------------------------ |
| `-x`, `--no-slurm`   | Do not run `xdsl` step.                          |
| `-c`, `--no-compile` | Do not run `cslc` step.                          |
| `-r`, `--no-run`     | Do not execute compiled code.                    |
| `-q`, `--quick`      | Skip compilation step if it isn't needed         |
| `-f`, `--force-hw`   | Force running on hardware (not on simulator)     |
| `-s`, `--slurm`      | Generate a slurm file for running on hardware    |
| `--target=TARGET`    | Which WSE to target (`2` or `3`, default `3`)    |
| `--runs=RUNS`        | How many times to run compiled code (default `3` |

### Example

The following command will run `name-of-program.mlir`, using
`name-of-program-profile` (see below), through the `xdsl` based compiler and
stop.

```sh
./driver.sh name-of-program -c -r
```

### Profiles

Profiles for each program are defined within `driver.sh`. They come in the form
of `*-profile` functions. All `.mlir` files in this repository already have
associated profiles.

The following variables for each profile can be manually specified when running
`drver.sh` using environment variables. 


| Variable        | Meaning                                                                                  |
| -------------   | --------------                                                                           |
| `iter_count`\*  | Number of iterations of the main loop (default 1)                                        |
| `halo`          | Maximum halo size in any dimension                                                       |
| `xdim`          | Size of the X dimension                                                                  |
| `ydim`          | Size of the Y dimension                                                                  |
| `zdim`          | Size of the Z dimension                                                                  |
| `buf_names`\*   | Names of the input buffers to the main function. Space-separated list (default "a b" )   |
| `fn_name`       | Name of the main function                                                                |
| `layout_file`\* | Name of the main layout file (default layout.csl)                                        |
| `channels`\*    | `memcpy` channels (default automatically determined)                                     |

When a profile is specified, all variables are optional

> [!WARNING]
> If no profile is specified, all variables are required except those marked
> with \* in the table above.
