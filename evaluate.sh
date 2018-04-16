#!/bin/bash

# place script in /eff
# run evaluate.sh
# make sure there are no unsaved changes in the code folder

declare -a BRANCHES=("master" "algebraic-subtyping" "rowbased" "explicit-effect-subtyping")
declare -a TESTS=("interp.eff" "loop.eff" "parser.eff" "queens.eff" "range.eff")
QUALITY=1
EFF_FOLDER="../eff-cp"
TEST_FOLDER="../algebraic-subtyping-for-algebraic-effects-and-handlers/src/"
EFF_LOC="./../../eff-cp/eff.native"

function git_checkout {
    cd $EFF_FOLDER
    git reset --hard 1> /dev/null
    git checkout "$1" 1> /dev/null
    git pull 1> /dev/null
    make clean 1> /dev/null
    make 1> /dev/null
}

function run_test {
    echo =============================
    echo "Branch $1 - testcase $2" 
    # for i in {1..100} ; do
    #     ( time ( echo $i ; sleep 1 ) ) 2>&1 | sed 's/^/   /'
    # done | tee timing.log
    time for ((i=1;i<=$QUALITY;i++)); do 
        $EFF_LOC -V 4 --no-pervasives "$2"; 
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



