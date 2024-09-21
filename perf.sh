#! /bin/sh

# $1: Complete execution command    $2: store folder for generated file
# eg:   ./performance_counter.sh "./hackbench -s 512 -l 200 -g 15 -f 25 -P" /home

#if [ $# -ne 2 ]; then
#    echo "Usage:  ./performance_counter.sh parameter1 parameter2"
#    exit 1
#fi

#echo "parameter1=$1"



#file_name=$(echo "$result" | sed 's/ //g')
#echo "file name : $file_name"

# just need a parameter to run the command 

result=$(echo "$1" | sed 's:.*/::')
if [ -f "performance.txt" ]; then
    rm -f performance.txt
    echo "performance.txt has been deleted"
fi
touch performance.txt

sudo perf stat --sync -e duration_time,task-clock,cycles,instructions,cache-references,cache-misses,branches,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-load-misses,LLC-loads -r 1 -o performance.txt $1

awk '{print $1, $2, $3}' performance.txt > performance_tmp.txt

mv -f performance_tmp.txt performance.txt

duration_time=`cat performance.txt | grep "duration_time" | awk '{print $1}' | sed 's/,//g'`
task_clock=`cat performance.txt | grep "task-clock" | awk '{print $1}' | sed 's/,//g'`
cpu_cycle=`cat performance.txt | grep "cycles" | awk '{print $1}' | sed 's/,//g'`
instruction=`cat performance.txt | grep "instructions" | awk '{print $1}' | sed 's/,//g'`
cache_references=`cat performance.txt | grep "cache-references" | awk '{print $1}' | sed 's/,//g'`
cache_misses=`cat performance.txt | grep "cache-misses" | awk '{print $1}' | sed 's/,//g'`
branches=`cat performance.txt | grep "branches" | awk '{print $1}' | sed 's/,//g'`
branch_misses=`cat performance.txt | grep "branch-misses" | awk '{print $1}' | sed 's/,//g'`
L1_dcache_loads=`cat performance.txt | grep "L1-dcache-loads" | awk '{print $1}' | sed 's/,//g'`
L1_dcache_load_misses=`cat performance.txt | grep "L1-dcache-load-misses" | awk '{print $1}' | sed 's/,//g'`
LLC_load_misses=`cat performance.txt | grep "LLC-load-misses" | awk '{print $1}' | sed 's/,//g'`
LLC_loads=`cat performance.txt | grep "LLC-loads" | awk '{print $1}' | sed 's/,//g'`

echo "$duration_time">>perf.txt
printf "%.3f\n" $task_clock>>perf.txt
echo "$cpu_cycle">>perf.txt
echo "$instruction">>perf.txt
echo "$cache_references">>perf.txt
echo "$cache_misses">>perf.txt
echo "$branches">>perf.txt
echo "$branch_misses">>perf.txt
echo "$L1_dcache_loads">>perf.txt
echo "$L1_dcache_load_misses">>perf.txt
echo "$LLC_load_misses">>perf.txt
echo "$LLC_loads">>perf.txt

IPC=`echo "scale=3; $instruction / $cpu_cycle" | bc`
printf "%.3f\n" $IPC >>perf.txt

rm -f performance.txt