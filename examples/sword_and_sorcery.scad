/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>

$color_main = "forestgreen";
$color_design = "plum";
$color_cut = undef;

/* sword and sorcery */
die(25, "3x2u", ["gnome", "troll", "dwarf", "elf", "goblin", "giant"], font = "BankGothic Md BT:style=Medium", textsize = "match", rescale = 1.2, rot = 45);
