/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>

$color_main = "darkcyan";
$color_design = "gold";
$color_cut = undef;

/* fun words */
die(25, "3x2u",  ["one", "two", "three", "four", "five", "six"], textsize = "match", font = "Adamsky SF:style=Regular", rot = 30);
