# Gnuplot script file for plotting data in file
# extension files "gnu.dat"

set terminal postscript eps color lw 15 "Helvetica" 20
set out 'ext14.eps'
set title "Chignolin-extension"
set xlabel "Timestep"
set ylabel "ext. (A)"

# set margin 1
set autoscale 
set border lw 0.1

#set xr [1:7]
#set yr [3.5:8.2]
#set xtic .5
#set ytic .5

set style data lines
set style line 1 lc rgb "red" lt 1 lw .2
set style line 2 lc rgb "green" lt 1 lw .2
set style line 3 lc rgb "blue" lt 1 lw .2
set style line 4 lc rgb "cyan" lt 1 lw .2

unset log                              # remove any log-scaling
unset label                            # remove any previous labels

# EXTRAS
# set key 0.01,100
# set label "Yield Point" at 0.003,260
# set arrow from 0.0028,250 to 0.003,280

plot    "extCA1-4.dat" using 1:2 t 'run 1-10'  ls 1, \
        "extCA1-4.dat" using 1:3 t 'run 2-9' ls 2, \
        "extCA1-4.dat" using 1:4 t 'run 3-8' ls 3, \
        "extCA1-4.dat" using 1:5 t 'run 4-7' ls 4
