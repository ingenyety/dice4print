/*----------------------------------------------------------------------
Copyright (c) 2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>

$color_main = "cornflowerblue";
$color_design = "darkblue";
$color_cut = "cyan";

/* Use unicode symbols for dice */
die(25, "3x2u", ["⚀", "⚁",  "⚂",  "⚃", "⚄", "⚅"], font = "DejaVu Sans:style=Book", rescale = 1.4, rot = 10);
