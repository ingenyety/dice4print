/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>

$color_main = "red";
$color_design = "yellow";
$color_cut = "orange";

/* chinese characters */
die(25, "3x2u", ["一", "二", "三", "四", "五", "六"], font = "AR PL New Kai:style=Regular", textsize = 0.8);
