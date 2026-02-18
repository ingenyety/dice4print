# Printing Dice

Making cubic dice on a 3D printer is not straightforward. Simply 
printing a cubic shape is easy but such a die is highly likely to be 
biased to certain faces because of the weight differences between top, 
bottom and vertical faces and directional characteristics of the 
infill. It also results in a die with faces whose texture and quality 
of design differ hugely depending on their orientation on the print bed.

## Six-piece assembly

This parametric design generates a die in six identical pyramidal 
pieces, one for each face, which can all print in the same orientation 
and then interlock on assembly to ensure alignment. These are then 
glued together to produce the finished die which should roll fairly 
provided there are no huge discrepencies between the images on the faces. 
Letters printed on the inside of each piece should be matched up (A-A, 
B-B etc.) to ensure the pieces are fitted in the correct positions.

For an ordinary die with faces labelled 1 - 6, traditionally with spots 
but also with digits or other signifiers, the internal assembly 
labelling ensures the faces are properly arranged such that opposite 
faces add up to 7, an important feature of good dice; and that for 
labels using text or other designs with a 'right way up', the labels on 
opposite faces have opposing orientation and adjacent faces read at 
right angles.

# Files

- [**die.scad**](./die.scad): contains the main modules die(), face(), drawimage(), 
drawtext() and some helper functions and modules that do the work.

- **eg_xxx.scad**: are example files which include *die.scad* to 
generate a variety of different dice.

- [**permute.scad**](./permute.scad): is a library function that returns every 
permutation of a list. See *eg_ning_nang_nong.scad* or 
*eg_triathlon.scad* for examples of how this can relate to dice.

- [**LICENSE**](./LICENSE): what it says!

- [**README.md**](./README.md): This file (or the markdown that generated it).

## Documentation

die.scad is extensively documented in comments within the source.

## Face designs

There are a selection of sample designs here. Designs on each face can 
be text or images. They can be scaled or rotated. 

Pieces are designed to be printed face-down and designs are normally 
cut into the face (engraved). This means that large areas of "black" 
cut away can create bridging issues. They can alternatively be printed 
face-up and may print better but, depending on your printer, this way 
up may give overhang and/or bed adhesion problems.

All the sample designs are engraved which is conventional for dice. 
However, embossed designs, standing out from the face, are also 
possible although if they stand out very much, they are likely to 
influence the way the die rolls. Embossed designs must be either be 
printed face up or will require a lot of supports and won't work well 
on many printers.

### Permutation Designs

There are six possible ways of putting three things in order 
(permutations). This feature can been used with a six-sided die to draw 
for order when three things or tasks have to be arranged in random 
order. The triathlon training and [ning, nang, 
nong](https://childrens.poetryarchive.org/poem/on-the-ning-nang-nong/) 
examples illustrate this. (in Surf Life Saving competition, this is 
great for Oceanman events!)

## Printing

### Orientation

The pieces can be printed face down or face up. See Six-piece assembly.

### Order of Printing

You can print each piece separately or set the printer to *complete 
individual objects* and leave your printer to print them all 
sequentially. Printing them all simultaneously is not recommended 
because of the amount of stringing and disturbance as the printhead 
moves around all the pieces at each layer.

### Layout and Separation

The top level _die()_ module (in die.scad) creates all six pieces of a 
single die which OpenSCAD then incorporates in the generated model. 
_die()_ takes a layout argument which can arrange the six pieces in 
OpenSCAD space in a variety of ways. These include several 3x2 or 2x3 
options which can place the pieces in an array suitable for many 
printers without having to rearrange them. However, you will have to 
split the model into separate objects for slicing if you want to
print them sequentially (recommended) or print one piece at a time.

## Materials and Finishing

These designs works really well in ABS (or ASA) where you can use 
acetone to weld the parts together, smooth over any assembly lines 
along the edges and then acetone vapour polish the finished die to get 
a great surface finish.
