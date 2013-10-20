# Gnuplot script file for plotting data in file
# extension files "gnu.dat"

set terminal postscript eps color lw 15 "Helvetica" 20
set out 'rmsd.eps'
set title "Chignolin-RMSD - 3 ns in a vacuum"
set xlabel "Timestep"
set ylabel "RMSD (A)"

# set margin 1
set autoscale 
set border lw 0.1

#set xr [1:7]
#set yr [2.5:9.5]
#set xtic .5
#set ytic .5

set style data lines
set style line 1 lc rgb "red" lt 1 lw .2
set style line 2 lc rgb "green" lt 1 lw .2
set style line 3 lc rgb "blue" lt 1 lw .2

unset log                              # remove any log-scaling
unset label                            # remove any previous labels

# EXTRAS
# set key 0.01,100
# set label "Yield Point" at 0.003,260
# set arrow from 0.0028,250 to 0.003,280

plot    "rmsd.dat" ls 1
