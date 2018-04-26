#!/bin/bash

declare -a TESTS=("interp.eff" "loop.eff" "parser.eff" "queens.eff" "range.eff")
# declare -a TESTS=("interp.eff" "loop.eff" "queens.eff" "range.eff")
# declare -a BRANCHES=("../eff-benchmarks/eff-algebraic-subtyping/" "../eff-benchmarks/eff-row-based/" "../eff-benchmarks/eff-subtyping/")
declare -a BRANCHES=("../eff-benchmarks/eff-algebraic-subtyping/" "../eff-benchmarks/eff-subtyping/")
TEST_FOLDER="../../algebraic-subtyping-for-algebraic-effects-and-handlers/src/"

QUALITY=10

function git_checkout {
    cd $i
    echo "Compiling $i"
    make clean 1> /dev/null
    make 1> /dev/null
}

function run_test {
    echo =============================
    echo "Branch $1 - testcase $2"
    time for ((i=1;i<=$QUALITY;i++)); do 
        "./../"$1"eff.native" -V 4 --no-pervasives $2 1> /dev/null; 
    done
}

function run_all_tests {
    cd $TEST_FOLDER
    for i in "${TESTS[@]}"
    do
        run_test "$1" "$i"
    done
    cd ../
}

function eval_all {
    for i in "${BRANCHES[@]}"
    do
        git_checkout "$i"
        run_all_tests "$i" tests
    done
}

eval_all



