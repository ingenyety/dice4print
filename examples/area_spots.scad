/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>

/*
Spots of equal area

The total area of all the spots on each face is the same so the same
volume of material should be removed to avoid biasing the die.

Note that this is a volume calculation and does not account for
differences in perimeter and infill material when printing. Printing 
with solid infill should ensure the weight, as well as the volume of 
each face is the same but this may not be desirable.
*/
$color_main = "cyan";
$color_design = "teal";
$color_cut = undef;

die(25, "3x2u", 
        img = [
            "img/spot_1.svg",
            "img/spot_2.svg", 
            "img/spot_3.svg", 
            "img/spot_4.svg", 
            "img/spot_5.svg", 
            "img/spot_6.svg"
        ]);
