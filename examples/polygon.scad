/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>

off_center = 1;

$color_main = "ivory";
$color_design = "crimson";
$color_cut = undef;

/* geometrical images */
die(25, "3x2u", 
        img = [
            "img/poly_1.svg",
            "img/poly_2.svg", 
            "img/poly_3.svg", 
            "img/poly_4.svg", 
            "img/poly_5.svg", 
            "img/poly_6.svg"
        ], 
        shift = off_center ? [
            [0.13, 0.07],
            [0, -0.05],
            [0.12, -0.03],
            [-0.05, 0.06],
            [0.02, 0.07],
            [0.06, 0.025]
        ] : undef
);
