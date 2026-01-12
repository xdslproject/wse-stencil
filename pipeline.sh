#!/bin/bash
echo " $* " | grep -Eq "( -h )|( --help )" && { echo "Usage: $(basename "$0") < FILE

    -3, --wse3             target wse3
    -t, --target           compile to CSL
        --slices=X,Y       distribute-stencil slices
        --chunks=C         num_chunks
        --args=ARGS        arguments to forward to xdsl-opt
        --layout=FILE      name of the layout file to generate
                           (default: layout.csl)
        --xdsl-ver=VER     xDSL version used (default: unknown)

    -h, --help             print this message and exit
"; exit 0; }
wse=2
chunks=1
echo " $* " | grep -Eq "( -t )|( --target )" && comp_to_csl=1
echo " $* " | grep -Eq "( -3 )|( --wse3 )" && wse=3
slices=$(echo " $* " | grep -Eo ' --slices=[^ ]+ ' | cut -d= -f2 | sed 's/\s*$//'||:)
chunks=$(echo " $* " | grep -Eo ' --chunks=[^ ]+ ' | cut -d= -f2 | sed 's/\s*$//'||:)
layout_file=$(echo " $* " | grep -Eo ' --layout=[^ ]+ ' | cut -d= -f2 | sed 's/\s*$//'||:)
extra_args=$(echo " $* " | grep -Eo ' --args=[^ ]+ ' | cut -d= -f2 | sed 's/\s*$//'||:)
xdsl_ver=$(echo " $* " | grep -Eo ' --xdsl-ver=[^ ]+ ' | cut -d= -f2 | sed 's/\s*$//'||:)
[ -z "$slices" ] && { echo "--slices is mandatory, see --help"; exit 1; }
[ -z "$layout_file" ] && layout_file=layout.csl
<<< "$chunks" grep -Eq '^[0-9]+$' || { echo "--chunks has to be a number"; exit 1; }

pipeline=()
pipeline+=("canonicalize")
pipeline+=("stencil-inlining")
pipeline+=("test-add-timers-to-top-level-funcs")
pipeline+=("function-persist-arg-names")
pipeline+=("cse")
pipeline+=("convert-arith-to-varith")
pipeline+=("varith-fuse-repeated-operands")
pipeline+=("convert-varith-to-arith")
pipeline+=("arith-add-fastmath")
pipeline+=("mlir-opt[test-math-algebraic-simplification,cse]")
pipeline+=("canonicalize")
pipeline+=("distribute-stencil{strategy=2d-grid slices=$slices restrict_domain=true}")
pipeline+=("shape-inference")
pipeline+=("stencil-shape-minimize")
pipeline+=("canonicalize-dmp")
pipeline+=("canonicalize")
pipeline+=("stencil-tensorize-z-dimension")
pipeline+=("cse")
pipeline+=("stencil-bufferize")
pipeline+=("convert-stencil-to-csl-stencil{num_chunks=$chunks}")
pipeline+=("lift-arith-to-linalg")
pipeline+=("linalg-fuse-multiply-add{require-scalar-factor=true}")
pipeline+=("csl-stencil-bufferize")
pipeline+=("csl-stencil-to-csl-wrapper{target=wse${wse}}")
pipeline+=("cse")
pipeline+=("mlir-opt[one-shot-bufferize{allow-unknown-ops analysis-heuristic=top-down},cse,canonicalize]")
pipeline+=("csl-stencil-materialize-stores")
pipeline+=("linalg-to-csl")
pipeline+=("csl-stencil-set-global-coeffs")
pipeline+=("csl-stencil-handle-async-flow{task_ids=8}")
pipeline+=("lower-csl-stencil")
pipeline+=("csl-wrapper-hoist-buffers")
pipeline+=("canonicalize")
pipeline+=("memref-to-dsd")
pipeline+=("cse")
pipeline+=("lower-csl-wrapper")
pipeline+=("cse")
pipeline+=("canonicalize")
P="$(IFS=, ; echo "${pipeline[*]}")"

echo "pipeline.sh: Running xdsl (WSE${wse})"

echo "pipeline.sh: slices = $slices"
[ -n "$extra_args" ] && echo "pipeline.sh: Additional arguments to xdsl-opt: $extra_args"

if [ -z "$comp_to_csl" ]; then
    xdsl_opt=xdsl-opt
    echo "pipeline.sh: Compiling to MLIR"
else
    xdsl_opt="xdsl-opt -t csl"
    echo "pipeline.sh: Compiling to CSL"
fi
# shellcheck disable=SC2086 # extra_args needs to expand
$xdsl_opt $extra_args -p "$P" | if [ -n "$comp_to_csl" ]; then
awk -vlayout_file="$layout_file" -vxdsl_ver="$xdsl_ver" '
function log_ver(file) {
     print "// xDSL version: " xdsl_ver > f
}
/^\/\/ FILE:.*_program/ { f= substr($3, 1, length($3) - length("_program")) ".csl"; print "pipeline.sh: Writing " f; log_ver(f) }
/^\/\/ ---*/ { f=layout_file; print "pipeline.sh: Writing " f; log_ver(f)}
{ print > f }
END { printf "pipeline.sh: Estimated memory usage: "; system ("./estimate-mem-use.sh " f) }
'
else cat; fi
