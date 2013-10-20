# Gnuplot script file for plotting data in file
# extension files "gnu.dat"

set terminal postscript eps color lw 15 "Helvetica" 20
set out 'tef.png'
set title "Deca-alanine - Force vs. Extension" 
set xlabel "Extension"
set ylabel "Force"

# set margin 1
set autoscale 
set border lw 0.1

#set xr [1:7]
#set yr [2.5:9.5]
#set xtic .5
#set ytic .5

set style data lines
set style line 1 lc rgb "red" lt 1 lw .5
set style line 2 lc rgb "green" lt 1 lw .5
set style line 3 lc rgb "blue" lt 1 lw .5

unset log                              # remove any log-scaling
unset label                            # remove any previous labels

# EXTRAS
# set key 0.01,100
# set label "Yield Point" at 0.003,260
# set arrow from 0.0028,250 to 0.003,280

plot    "1-tef.dat" using 2:3 t 'run 1' ls 1, \
        "2-tef.dat" using 2:3 t 'run 2' ls 2, \
        "3-tef.dat" using 2:3 t 'run 3' ls 2, \
        "4-tef.dat" using 2:3 t 'run 4' ls 2, \
        "5-tef.dat" using 2:3 t 'run 5' ls 2, \
        "6-tef.dat" using 2:3 t 'run 6' ls 2, \
        "7-tef.dat" using 2:3 t 'run 7' ls 3

stuff again