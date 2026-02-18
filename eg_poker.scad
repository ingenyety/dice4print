/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <die.scad>

select = 2;  // design 1 or 2
layout = "2x3u";

if (select == 1)
    die(32, layout, 
        img = [
            "img/poker1_9.svg",
            "img/poker1_10.svg", 
            "img/poker1_J.svg", 
            "img/poker1_Q.svg", 
            "img/poker1_K.svg", 
            "img/poker1_A.svg"
        ], rescale = 1, spacing = 50);

else if (select == 2)
    die(32, layout, 
        img = [
            "img/poker2_9.svg",
            "img/poker2_10.svg", 
            "img/poker2_J.svg", 
            "img/poker2_Q.svg", 
            "img/poker2_K.svg", 
            "img/poker2_A.svg"
        ], rescale = 1, spacing = 50);
