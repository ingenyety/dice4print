/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>
include <dice4print/permute.scad>

$color_main = "blue";
$color_design = "deeppink";
$color_cut = "orange";

/* Spike Milligan (https://childrens.poetryarchive.org/poem/on-the-ning-nang-nong/) */
die(25, "3x2u", permute(["ning", "nang", "nong"]), vspace = 0.9, font = "Revue SF:style=Regular", 
    halign = ["left", undef, "right", "left", undef, "right"], spacing = 90);
