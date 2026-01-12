#!/usr/bin/env bash
set -e
default_run_count=1
default_target=3
echo " $* " | grep -Eq "( -h )|( --help )" && { echo "Usage: $(basename "$0") PROFILE

    PROFILE                   Name of the profile to execute

    -s, --slurm               generate slurm file, don't run anything
    -x, --no-xdsl             skip running xdsl
    -c, --no-compile          skip compilation
    -r, --no-run              skip running
    -f, --force-hw            force running on hardware
    -q, --quick               skip compilation if artifact file already exists
        --target=TARGET       target to compile for/run on. '2', '3' or 'cpu'
                              (default '$default_target')
        --runs=RUNS           number of times to run benchmark
                              (default $default_run_count)
"; exit 0; }
echo " $* " | grep -Eq "( -s )|( --slurm )"      && make_slurm=1
echo " $* " | grep -Eq "( -x )|( --no-xdsl )"    && skip_xdsl=1
echo " $* " | grep -Eq "( -c )|( --no-compile )" && skip_compile=1
echo " $* " | grep -Eq "( -r )|( --no-run )"     && skip_run=1
echo " $* " | grep -Eq "( -f )|( --force-hw )"   && force_hw=1
echo " $* " | grep -Eq "( -q )|( --quick )"      && quick=1
dir=$(echo " $* " | grep -Eo ' --dir=[^ ]+ ' | cut -d= -f2 | sed 's/\s*$//'||:)
target=$({ echo " $* " | grep -Eo ' --target=[^ ]+ ' || echo "=$default_target"; } | cut -d= -f2 | sed 's/\s*$//'||:)
runs=$({ echo " $* " | grep -Eo ' --runs=[^ ]+ ' || echo "=$default_run_count"; } | cut -d= -f2 | sed 's/\s*$//'||:)

<<<"$runs" grep '^[0-9]+$' -qE || { echo "Argument to --runs has to be a number, got '$runs'"; exit 1; }

profile="$(for i in "$@"; do echo "$i"; done \
    | awk '/^[^-].*/ { if(!f) { f=1; o=$0; } else o=null } END { if(o) print o }')"

[ -z "$profile" ] && {
    echo "dirver.sh: No profile specified, using iter_count=$iter_count, halo = $halo, xdim = $xdim, ydim = $ydim, zdim = $zdim, fn_name = $fn_name";
}
[ -n "$force_hw" ] && RUNNING_ON_HARDWARE_=1

xdsl_ver=${xdsl_ver:-$(command -v xdsl-opt >/dev/null && xdsl-opt --version | sed -nE 's/^.*version (.*)$/\1/p' || echo "unknown")}
num_chunks=1
gen_slurm(){
    echo "driver.sh: generating ${fn_name}.slurm script"
    echo "#!/bin/bash
#SBATCH --job-name=${fn_name}
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --cpus-per-task 10
#SBATCH --time=02:00:00
#SBATCH --output slurm_out_${fn_name}_%J_%j.txt

#!/bin/bash

echo 'Starting slurm script'

if [ -z \"\$CSHOME\" ]; then
    echo \"Error: CSHOME is empty or not set. Point this to your venv parent directory and run the jobscript again\"
    exit 1
fi

if [ -z \"\$VENV_NAME\" ]; then
    echo \"Error: VENV_NAME is empty or not set. Point this to the name of the virtual environment and run the jobscript again\"
    exit 1
fi

export RUNNING_ON_HARDWARE_=1
source \"\$CSHOME/\$VENV_NAME/bin/activate\"
echo \"Virtual environment activated successfully.\"
json_file='${json_file}' \
xdsl_ver='${xdsl_ver}' \
iter_count='${iter_count}' \
halo='${halo}' \
xdim='${xdim}' \
ydim='${ydim}' \
zdim='${zdim}' \
buf_names='${buf_names}' \
channels='${channels}' \
fn_name='${fn_name}' \
./driver.sh '${profile}' -f -x -q --runs='${runs}' --target='${target}'
echo 'Slurm script finished'
" > "${fn_name}.slurm"
}


-profile() {
    :
}

assert-target() {
    if ((target != $1)); then
        echo "${FUNCNAME[1]} only runs on WSE$1"
        exit 1
    fi
}

get-fn-name() {
    echo "${FUNCNAME[${1:-1}]}" | sed 's/-profile$//g' | tr - _ | sed -E 's/^([0-9])/_\1/g'
}

get-layout-name() {
    echo "layout_$(get-fn-name 2).csl"
}

smoke-test-profile(){
    iter_count=${iter_count:-10}
    halo=${halo:-2}

    xdim=${xdim:-8}
    ydim=${ydim:-8}
    zdim=${zdim:-12}

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

uvbke-small-profile(){
    halo=${hello:-2}
    xdim=${xdim:-100}
    ydim=${ydim:-100}
    zdim=${zdim:-600}

    buf_names="arg0 arg1 arg2 arg3 arg4 arg5"

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

uvbke-medium-profile(){
    halo=${hello:-2}
    xdim=${xdim:-500}
    ydim=${ydim:-500}
    zdim=${zdim:-600}

    buf_names="arg0 arg1 arg2 arg3 arg4 arg5"

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

uvbke-large-profile(){
    halo=${hello:-2}
    xdim=${xdim:-750}
    ydim=${ydim:-994}
    zdim=${zdim:-600}

    buf_names="arg0 arg1 arg2 arg3 arg4 arg5"

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

loop-kernel-small-profile(){
    iter_count=${iter_count:-100000}
    halo=${halo:-2}

    xdim=${xdim:-100}
    ydim=${ydim:-100}
    zdim=${zdim:-900}

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

loop-kernel-medium-profile(){
    iter_count=${iter_count:-100000}
    halo=${halo:-2}

    xdim=${xdim:-500}
    ydim=${ydim:-500}
    zdim=${zdim:-900}

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

loop-kernel-large-profile(){
    iter_count=${iter_count:-100000}
    halo=${halo:-2}

    xdim=${xdim:-750}
    ydim=${ydim:-994}
    zdim=${zdim:-900}

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

diffusion-small-profile() {
    halo=${halo:-4}
    xdim=${xdim:-100}
    ydim=${ydim:-100}
    zdim=${zdim:-704}
    buf_names="u_vec0 u_vec1"

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

diffusion-medium-profile() {
    halo=${halo:-4}
    xdim=${xdim:-500}
    ydim=${ydim:-500}
    zdim=${zdim:-704}
    buf_names="u_vec0 u_vec1"

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

diffusion-large-profile() {
    halo=${halo:-4}
    xdim=${xdim:-750}
    ydim=${ydim:-994}
    zdim=${zdim:-704}
    buf_names="u_vec0 u_vec1"

    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}


acoustic-small-profile() {
    halo=${halo:-4}
    xdim=${xdim:-100}
    ydim=${ydim:-100}
    zdim=${zdim:-604}
    buf_names="u_vec0 u_vec1 u_vec2"
    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

acoustic-medium-profile() {
    halo=${halo:-4}
    xdim=${xdim:-500}
    ydim=${ydim:-500}
    zdim=${zdim:-604}
    buf_names="u_vec0 u_vec1 u_vec2"
    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

acoustic-large-profile() {
    halo=${halo:-4}
    xdim=${xdim:-750}
    ydim=${ydim:-994}
    zdim=${zdim:-604}
    buf_names="u_vec0 u_vec1 u_vec2"
    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

25-point-stencil-small-profile() {
    halo=${halo:-8}
    xdim=${xdim:-100}
    ydim=${ydim:-100}
    zdim=${zdim:-450}

    iter_count=${iter_count:-100000}
    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

25-point-stencil-medium-profile() {
    halo=${halo:-8}
    xdim=${xdim:-500}
    ydim=${ydim:-500}
    zdim=${zdim:-450}

    iter_count=${iter_count:-100000}
    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

25-point-stencil-large-profile() {
    halo=${halo:-8}
    xdim=${xdim:-750}
    ydim=${ydim:-994}
    zdim=${zdim:-450}

    iter_count=${iter_count:-100000}
    fn_name=${fn_name:-$(get-fn-name)}
    layout_file=$(get-layout-name)
}

if [ -z "$dir" ]; then
    "${profile}-profile"
    echo "driver.sh: running ${profile} (CS-${target}, xdsl ${xdsl_ver}): xdim=${xdim}, ydim=${ydim}, zdim=${zdim}, chunks=${num_chunks} halo=${halo}, iters=${iter_count:-"N/A"}"
else
    echo "Running in directory mode on $dir/"
    echo "Directory mode unsupported"
    exit 1
fi
buf_names=${buf_names:-a b}
channels=${channels:-$((xdim >= 32 || ydim >= 32 ? 16 : 1))}
layout_file=${layout_file:-layout.csl}
json_file=${json_file:-"artifact-path-${fn_name}-$(<<< "$target $profile $fn_name $xdim $ydim $zdim $iter_count $xdsl_ver" md5sum | cut -d' ' -f1).json"}

if [ -n "$make_slurm" ]; then
    gen_slurm
    exit 0
fi

comp_python=$(command -v python >/dev/null && echo "python" || echo "python3")

if [ -z "$RUNNING_ON_HARDWARE_" ]; then
    echo "driver.sh: running in simulator"
    # "+5" for infrastructure of memcpy
    FABRIC_DIMS_X=$(( xdim + halo + 5 ))
    FABRIC_DIMS_Y=$(( ydim + halo + 2 ))
    python=cs_python
    name="--name out"
    cslc_exta_args="--width-west-buf=0 --width-east-buf=0"
else
    if [ "$target" = cpu ]; then
        echo "driver.sh: running on CPU"
    else
        echo "driver.sh: running on hardware (WSE${target})"
        if [ "$target" = 2 ]; then
            FABRIC_DIMS_X=757
            FABRIC_DIMS_Y=996
        else
            FABRIC_DIMS_X=762
            FABRIC_DIMS_Y=1172
        fi
    fi
    python=python
fi



if [ -z "$skip_xdsl" ]; then
    [ -z "$dir" ] && DIRVER_=1 ./runall "$profile".mlir "$halo" "$xdim" "$ydim" "$zdim" "${iter_count:-1}" "$layout_file" "$xdsl_ver" "$target" "$num_chunks"
fi

[ -z "$RUNNING_ON_HARDWARE_" ] && sim="-(SIM)" || sim=

if [ -z "$skip_compile" ]; then
    if [ "$target" = cpu ]; then
        echo "driver.sh: Compiling for CPU not yet supported"
    else
        if [ -z "$quick" ] || [ ! -f "${json_file}" ] || [ -z "$RUNNING_ON_HARDWARE_" ]; then
            # shellcheck disable=SC2086 # cslc_exta_args cannot be quoted
            $comp_python compile.py "${json_file}" \
                "${layout_file}" \
                --arch=wse${target} \
                --fabric-dims=${FABRIC_DIMS_X},${FABRIC_DIMS_Y} --fabric-offsets=4,1 \
                --memcpy --channels="$channels" \
                -o out \
                --verbose \
                $cslc_exta_args |& \
                awk '
BEGIN { found=0; }
found {
    cmd="python -c '"'"'print(__import__(\"codecs\").escape_decode(bytes(__import__(\"sys\").stdin.read()[2:-2], \"utf-8\"))[0].decode(\"utf-8\"))'"'"'";
    print | cmd
    close(cmd);
    found=0;
    next;
}
/.*CSL compiler output.*/ { found = 1; }
{print}'
        else
            echo "driver.sh: Found existing artifact path (${json_file}): skipping compilation"
        fi
    fi
fi

if [ -z "$skip_run" ]; then
    if [ "$target" = cpu ]; then
        echo "driver.sh: running on CPU not yet supported"
    else
        file_template="run_result-${fn_name}-WSE${target}-${xdim}-${ydim}-${zdim}${sim}"
        for ((run = 1; run <= runs; run++)); do
            echo "driver.sh: Executing ($run/$runs)"
            count=$(find . -maxdepth 1 -name "${file_template}_*" -printf '.' | wc -m)
            # shellcheck disable=SC2086
            $python ./run.py                           \
              --wse=${target}                          \
              --xdim "$xdim"                           \
              --ydim "$ydim"                           \
              --zdim "$zdim"                           \
              --fn-name "$fn_name"                     \
              --xdsl-ver "$xdsl_ver"                   \
              --json-file "$json_file"                 \
              -o "${file_template}_${count}.txt" $name \
              --buf-names $buf_names ||: # The run.py script terminates itself
        done
    fi
fi
