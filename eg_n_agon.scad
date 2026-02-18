/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <die.scad>

off_center = false;

/* geometrical images */
die(30, "line", 
        img = [
            "img/die_1spot.svg",
            "img/die_2spot.svg", 
            "img/die_3spot.svg", 
            "img/die_4spot.svg", 
            "img/die_5spot.svg", 
            "img/die_6spot.svg"
        ], 
        shift = off_center ? [
            [0.13, 0.07],
            [0, -0.05],
            [0.12, -0.03],
            [-0.05, 0.06],
            [0.02, 0.07],
            [0.06, 0.025]
        ] : undef,
        spacing = 40);
