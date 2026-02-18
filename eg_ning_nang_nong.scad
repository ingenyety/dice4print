/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <die.scad>
include <permute.scad>

/* Spike Milligan (https://childrens.poetryarchive.org/poem/on-the-ning-nang-nong/) */
die(32, "line", permute(["ning", "nang", "nong"]), vspace = 0.9, font = "Revue SF:style=Regular", 
    halign = ["left", undef, "right", "left", undef, "right"]);
