/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>

$color_main = "teal";
$color_design = "black";
$color_cut = undef;

/* arabic numerals */
die(25, "3x2u", ["١", "٢", "٣", "٤", "٥", "٦"], font = "DejaVu Sans:style=Book", textsize = 0.9);
