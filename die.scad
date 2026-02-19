/*----------------------------------------------------------------------
Die © 2020-2026 by Philip Nye is licensed under CC BY-SA 4.0.
To view a copy of this license, visit 
https://creativecommons.org/licenses/by-sa/4.0/ 

#tabs=4s
----------------------------------------------------------------------*/
/*----------------------------------------------------------------------
Die.

This code generates dice made from 6 identically shaped and oriented 
pieces, one per face, which glue together to make a complete cubic die. 
To facilitate correct assembly, the six pieces are keyed so they locate 
together snugly and clearly labelled so, providing the numbered 
internal faces are correctly matched up when gluing, the final die will 
have the correct structure.

Main Modules & Functions
------------------------
*module face()*
generates a single pyramidal face piece with edges labelled
on the back for assembly. It expects a single child which is a 2D 
design to be cut into the face. face() handles scaling the supplied 
design to fit the face so the design produced by any child module 
should be normalised to a size of 1.0

*module die()* is the top-level module. It instantiates face() six 
times providing the correct edge labels for the assembly to work. It 
unpacks the specification for the design on each face and instantiates 
either drawimage() or drawtext() for each face, passing the relevant 
unpacked specification.

*module drawimage()* imports an image (SVG only at present) and 
generates a 2D design according to the specification.

*module drawtext()* uses OpenSCAD's built in text features to generate 
text for a face. Text can be single or multi-line and can be 
aoutomatically sized to fit the face.
----------------------------------------------------------------------*/

$fa=1;
$fs=0.2;
$fn=0;
iota = 1/128;

$color_main = undef;
$color_design = undef;
$color_cut = undef;
/*----------------------------------------------------------------------

module die()

  This is the top-level module. It unpacks the specification for each 
  face, calls the face() module six times to generate each face piece, 
  and provides the unpacked design for that face as a child. The work 
  of generating a design for the face is done by either drawimage() or 
  drawtext() which generate a 2D design. See face(), drawimage() and 
  drawtext() for how the individual arguments work.

  The six face pieces are positioned in the OpenSCAD space according to
  the partLayout argument. See layout functions for details.

  Face numbering
  --------------
  In a conventinal numbered die, No6 is on the face opposite No1, No5 
  is opposite No2 and No4 is opposite No3 which means opposite faces 
  always add up to 7. The pieces generated here conform to this provided
  the internal labelling is observed when assembling.

  Face specifications are lists in the order 
  [face1, face2, face3, face4, face5, face6].

  Matching Text Size Across Faces
  -------------------------------
  For text designs, if no textsize argument is supplied, the code in
  drawtext() attempts to fit the text to the face taking account of 
  both the width and height of the text. It can do a good job of this 
  and save a lot of guessing or calculation getting manual textsize 
  settings right.
   
  However, if text varies a lot in line length or line count between 
  faces they may be generated at very different character heights which 
  may not look right. Setting the textsize argument to the special 
  string "match" tells die() to pre-calculate the values for each face 
  and choose the worst case value. This is then passed to drawtext() 
  for all faces ensuring that their character heights match while the 
  text still fits on all faces.

  Arguments
  ---------
  Note: arguments are not described here in the order they are passed
  to die().

  Apply to the whole die:
  --
  *size* is passed to face() to specify the size of the die (length of 
  edge of the cube) in mm.

  *partLayout* selects layout in OpenSCAD space for the 6 pieces. see: 
  layout functions

  *spacing* modifies the layout by controlling the spacing between the 
  pieces. The exact effect depends on the layout. see: layout 
  functions.

  The rest of the arguments define the design shown on each face and 
  how it looks. Designs may be an imported image (currently only SVGis 
  supported), some text or nothing. Images take precedence and if an 
  image is specified for a face, any text for that face is ignored. All 
  these arguments can be a list of six values one per face or if a 
  single value is given it is applied to every face.

  For both image and text faces:
  --
  *engrave_depth* is passed to face() to specify how deep the design is 
  to be cut into the face. If unspecified, the value $default_depth is 
  used.

  *rescale*. drawimage()/drawtext() attempt to  generate their design
  at a suitable scale for the die. The size can be adjusted by specifying
  rescale which is applied after this automatic sizing. Can be either
  a simple scalar or a vecctor [xscale, yscale]. Default is 1.0

  *rot*, *shift* are passed directly to drawimage()/drawtext() to 
  rotate or shift the design.

  For image faces: values are unpacked per face and passed to drawimage()
  --
  *img* the image to use

  For text faces: values are unpacked per face and passed to drawtext()
  --
  *text* the text to use

  *font*, *textsize*, *hspace*, *vspace*, *halign* see drawtext()
----------------------------------------------------------------------*/

module die(
    size,
    partLayout,
    text,
    rescale,
    img,
    engrave_depth,
    spacing,
    rot,
    shift,
    font,
    textsize,
    hspace,
    vspace,
    halign
) {
    iLayout = search([partLayout], layouts)[0];
    mLayout = is_num(iLayout) ? layouts[iLayout][1](size, spacing) : assert(false, str("Layout \"", partLayout, "\" not found"));

    tspec = (img || is_undef(textsize)) ? undef :
        is_num(textsize) ? [textsize, 0] :
        is_list(textsize) ? [textsize, [for (i = [0:len(textsize) -1]) 0]] :
        (textsize == "match") ? get_size(text, font, hspace, halign, 2) :
        assert(false, "die: unrecognised value for textsize");

    for (i = [0 : 5]) {
        _iDpth = is_list(engrave_depth) ? engrave_depth[i] : engrave_depth;
        iDpth = is_undef(_iDpth) ? $default_depth :
                is_num(_iDpth) ? _iDpth : 
                assert(false, "Bad image depth specfication.");

        imgfile = is_list(img) ? img[i] : img;
        assert(is_undef(imgfile) || is_string(imgfile), "can't interpret img");

        facetext = (imgfile || is_undef(text)) ? undef : // image has priority
            is_list(text) ? text[i] : text;
        assert(is_undef(facetext) || is_string(facetext) || is_list(facetext), "can't interpret text");

        multmatrix(m = mLayout[i])
        face(size, edgeLabels[i], iDpth) {
            if (imgfile)
                drawimage(imgfile, 
                    is_list(rescale) ? rescale[i] : rescale, 
                    is_list(rot) ? rot[i] : rot,
                    is_list(shift) ? shift[i] : shift
                );
            else if (facetext)
                drawtext(facetext, tspec,
                    is_list(rescale) ? rescale[i] : rescale, 
                    is_list(rot) ? rot[i] : rot,
                    is_list(shift) ? shift[i] : shift,
                    is_list(font) ? font[i] : font,
                    is_list(hspace) ? hspace[i] : hspace,
                    is_list(vspace) ? vspace[i] : vspace,
                    is_list(halign) ? halign[i] : halign
                );
        }
    }
}

/*----------------------------------------------------------------------

module face()

Generates one face piece. It expects one child which is a 2D design to 
be cut into (engraved) or extruded outward from (embossed) the face.

The child designs are scaled to fit the size of the face before being 
applied so should be supplied at a size of 1.0.

Arguments
---------
*fsize* the distance between opposite faces of the cube.

*edgeLabels* the four internal labels for the edges of this face. These 
are identifiers cut into the sides of the pyramid to assist in 
assembling the faces in the correct places.

*engrave_depth* the depth to cut the design into the face. If negative 
the design will be embossed instead. If zero, children are ignored and 
the face is blank.
----------------------------------------------------------------------*/
module face(fsize, edgeLabels, engrave_depth)
{
    fChamfer = 0.04;    /* fraction each side to chamfer */
    fSphere = 1.52;     /* diameter of the sphere used to round the corners */
    
    ir2 = 0.5 * sqrt(2);
    blockX = fsize * 0.8;
    blockY = min(4, 0.2 * fsize);
    clr = 0.25;
    blockZ = 0.5 * (fsize - blockY - clr);
    hTrunc = blockZ / fsize;   //  0.439;
    dpthELbl = 0.8;

    ofsELblX = 0.18;
    ofsELblY = 0.2;
    mEdgeLabel = [
        [1, 0, 0, -ofsELblX * fsize],
        [0, -ir2, -ir2, (0.5 - ir2 * ofsELblY) * fsize + ir2 * iota],
        [0, -ir2, 1, -(ir2 * ofsELblY * fsize) - ir2 * iota]
    ];
    
    scTrunc = 1 - 2 * hTrunc;
    rChamfer = fsize * fChamfer;    // width of chamfer along face

    translate([0, 0, 0.5 * fsize])
    difference() {
        union() {
            //translate([0, 0, 0.5 * fsize])
            color($color_main)
            intersection() {
                /* base pyramid */
                mirror([0, 0, 1])
                linear_extrude(height = 0.5 * fsize, scale = 0)
                square(fsize, center = true);

                /* chamfer around edges */
                translate([0, 0, -rChamfer]) {
                    linear_extrude(height = rChamfer, scale = (1 - 2 * fChamfer))
                    square(fsize, center = true);

                    mirror([0, 0, 1])
                    linear_extrude(height = blockZ - rChamfer)
                    square(fsize, center = true);
                }

                translate([0, 0, -0.5 * fsize])
                sphere(d = fsize * fSphere);
            }
    
            mirror([0, 0, 1])
            color($color_main)
            linear_extrude(blockZ)
            square([blockX, blockY], center = true);

            if (engrave_depth < 0)
                color($color_design)
                linear_extrude(height = -engrave_depth) 
                scale(fsize * $die_use_size)
                children();  // emboss
        }

        if (engrave_depth > 0) 
            color($color_design)
            translate([0, 0, -engrave_depth])    // engrave needs shifting down
            linear_extrude(height = engrave_depth + iota) 
            scale(fsize * $die_use_size)
            children();

        zRotRepeat(2, startAngle = 90)
        translate([-0.5 * fsize,  -0.5 * (blockY + clr), -0.5 * fsize])
        color($color_cut)
        cube([blockZ + 0.5 * clr, blockY + clr, 0.5 * (blockX + clr)]);

        for (i = [0 : 3]) { /* four edges */
            if (edgeLabels[i]) {
                rotate([0, 0, 360 - 90 * i])
                multmatrix(m = mEdgeLabel)
                color($color_cut)
                linear_extrude(height = dpthELbl + iota)
                text(edgeLabels[i], font = $labelfont, size = 0.16 * fsize, halign = "center", valign = "baseline");
            }
        }
    }
}

/*----------------------------------------------------------------------

module drawimage()

Generate a 2D image for a face.

Currently only SVG images are supported. See OpenSCAD documentation
for import() for limitations.

Image sizing
------------
The face() module assumes children are normalised to a size of 1.0
which it then scales to the specified die size.

Imported images are unlikely to be generated at a size of 1.0 which is 
not a convenient size for working with in a program like inkscape and 
OpenSCAD does not currently provide any way that this code can know the 
size of the imported image. As a compromise, drawimage() assumes all 
imported images are a size of $image_size which defaults to 32 and is 
close to the sizes typically used for printed dice.

If creating images for dice, making them fit a 32mm square will ensure 
they are a good fit on the faces. If images are other sizes, they can 
be made to fit using the rescale argument. e.g. for an image that is 
100mm square, rescale should be set to 32/100 (0.32).

Images are imported centered.

Arguments
---------
*imgfile* is a string giving the path to the file holding the image.
This is passed directly to OpenSCAD's import() module.

*rescale* adjust the size of the image. See _Image Sizing_ above for 
what the value should be. The value can be fine-tuned to get the 
best composition.

*rot* rotate the image about it's centre. Specified in degrees with 
the positive direction anticlockwise.

*shift* is a vector [Xshift, Yshift] and the image is shifted 
accordingly. Because the image is normalised to a size of 1.0, shift 
represent a fraction of the entire face width and a value of 1 or more 
will probably shift the image right off the face.

Combining rescale, rot and shift: the arguments are applied in that 
order with shift last.
----------------------------------------------------------------------*/
module drawimage(imgfile, rescale, rot, shift)
{
    fscale = (rescale ? rescale : 1) / $image_size;

    translate(shift ? shift : [0, 0])
    rotate(rot ? rot : 0)               // rotate if required
    scale(fscale)
    import(file = imgfile, center = true, dpi = 96);
}

/*----------------------------------------------------------------------

module drawtext()

Generate a 2D text design for a face.

drawtext() can accept single or multi-line text with controls for font, 
character spacing and line spacing, alignment (when multi-line) etc. 
The generated text design can then be rescaled, rotated and shifted.

Text size
---------
Text size is specified by the sizespec argument or, if this is undefined 
a value will be calculated so that it fits (see get_size()).
Sizespec derives from the textsize argument passed to die() if
that is used. See also "Matching Text Size".

OpenSCAD's values for text size are nominally baseline to ascender 
height and not the usual point size. See OpenSCAD manual. This module
tries to correct for that.

Centering
---------
Vertical
--
The code centres the design both horizontally and vertically. For 
single line text, it can just specify both vertical and horizontal 
alignment as 'center' but for multi-line text this does not work - this 
code aligns the baselines of each line on a fixed pitch and then shifts 
the whole down using a rule of thumb for how far the centre of the text 
is above the baseline. Fine tuning can be done if necessary using the 
shift argument.

Horizontal
--
The sizespec argument includes an amount to shift the text horizontally
to position it. If sizespec is supplied manually, this can be used to 
adjust it. 
See get_size() for details of 

Arguments
---------
*facetext* the text to use. Either a single string or for multi-line
text, a list of strings, one per line.

*sizespec* is a pair [textsize, hoffset]. textsize is the size to be 
passed to OpenSCAD's text() module, hoffset is the amount to translate 
it horizontally to centre it on the face. If setting these manually
note that the entire design size is 1.0 so must will be small. Also
for left or right justified multi-line text, the start/end of each
line will initially be centered on the face and the hoffset value must
shift it to the left or right as needed.

*rescale* is a scaling applied after the text has been laid out

*rot* rotate the design about the centre. Specified in degrees with 
the positive direction anticlockwise.

*shift* is a vector [Xshift, Yshift] and the design is shifted 
accordingly. Because the image is normalised to a size of 1.0, shift 
represent a fraction of the entire face width and a value of 1 or more 
will probably shift the image right off the face.

*font* the font to use, a string. If undefined $default_font is used. 
See OpenSCAD documentation for how to specify fonts. This code does not 
currently support changing fonts within or between lines although
different fonts can be used on each face.

*hspace* is a horizontal spacing factor passed as 'spacing' to 
OpenSCAD's text() module. Defaults to 1.0.

*vspace* is a vertical line-spacing factor. It is a multiplier of the
nominal text height (point size) and defaults to 1.0.

*halign* specifies horizontal alignment for multi-line text. Valid 
values are "left", "right" or "center". Defaults to "center" if halign 
is undefined.
----------------------------------------------------------------------*/
module drawtext(facetext, sizespec, rescale, rot, shift, font, hspace, vspace, halign)
{
    /* face text/image is potentially a list, 1 item per line */
    badmsg = "drawtext: text must be a string or list of strings";
    lines = is_string(facetext) ? 
                [ facetext ] :       // make a bare string into a single item list
                is_list(facetext) ?  // check items is a list of strings
                    let(dummy = [for (item = facetext) assert(is_string(item), badmsg)]) facetext :
                    assert(0, badmsg); 
    nLines = len(lines);

    lfont = !font ? $default_font :
        is_string(font) ? font :
        assert(0, "drawtext: font name must be a string.");
    lhspace = is_undef(hspace) ? 1 :
        !is_num(hspace) ? assert(0, "drawtext: hspace must be a number.") :
        hspace == 0 ? 1 : hspace;
    lvspace = is_undef(vspace) ? 1 :
        !is_num(vspace) ? assert(0, "drawtext: vspace must be a number."):
        vspace == 0 ? 1 : vspace;
    lhalign = is_undef(halign) ? "center" :
                is_string(halign) ? halign :
                assert(0, "drawtext: bad halign ." );
    lvalign = nLines > 1 ? "baseline" : "center";

    szspec = !is_undef(sizespec) ? 
            sizespec : 
            get_size(facetext, lfont, lhspace, lhalign, 1);

    lpitch = 1.6 * szspec[0] * lvspace;
    firstLine = (nLines - 1) * 0.5 * lpitch - (nLines > 1 ? 0.35 * szspec[0] : 0);

    translate(shift ? shift : [0, 0])   // engrave needs shifting down
    rotate(rot ? rot : 0)               // rotate if required
    scale(rescale ? rescale : 1)
    for (i = [0 : nLines - 1]) {
        translate([szspec[1], firstLine - i * lpitch])
        text(lines[i], font = lfont, size = szspec[0], 
                spacing = lhspace, halign = lhalign,
                valign = lvalign);
    }
}

/*----------------------------------------------------------------------

function get_size()

Calculate the size that text must be to fit the normalised image area.

This function is either called from drawtext() to calculate the size 
required for a single die face or may be called from the die() module
to calculate a matching size across all faces.

This calls get_extents to get an array of the extents for each line of 
text then calculates the necessary size.

Horizontal size is calculated from the minimum and maximum 
values while vertical size derives from the number of lines (or 
maximum number of lines if matching across faces). The smaller
of the two values from the vertical and horizontal calculations
is returned.

The return value is a pair [textsize, hoffset], textsize is calculated 
as described and hoffset is the amount the text must be shifted to
centre the whole multi-line design.
----------------------------------------------------------------------*/
function get_size(text, font, hspace, halign, maxdepth) =
    let (
        tm = get_extents(text, font, hspace, halign, maxdepth),
        dummy = echo(tm = tm),
        xmin = min([for (m = tm) m[0]]),
        xmax = max([for (m = tm) m[1]]),
        nmax = max([for (m = tm) m[2]]),
        rval = min(0.625 / nmax, 1 / (xmax - xmin))
    )
    [rval, -0.5 * rval * (xmin + xmax)];

/*----------------------------------------------------------------------
function get_extents()

Returns an array with the extents of all the text lines supplied.

Text may be a single string (one line of text), a list of strings 
(multi-line text for a face) or a list of texts, one per face,
as when textsize = "match" in die(). get_extents() calls itself 
recursively as necessary to handle nested lists and then calls 
get_extent() when it has unpacked a string.

*maxdepth* is used to control and limit the recursive descent.
----------------------------------------------------------------------*/
function get_extents(text, font, hspace, halign, maxdepth, nlines = 1) =
    [ each
        is_string(text) ?
            [ get_extent(text, font, hspace, halign, nlines) ] :
        is_list(text) ?
            assert(maxdepth > 0, "get_extents: text nested too deep")
            [(for (i = [0:len(text)-1]) let(
                nl = maxdepth == 1 ? len(text) : nlines,
                subtext = text[i],
                _hsp = is_list(hspace) ? hspace[i] : hspace,
                hsp = is_num(_hsp) ? _hsp : 1,
                _hal = is_list(halign) ? halign[i] : halign,
                hal = (_hal == "left" || _hal == "right") ? _hal : "center",
                fnt = is_list(font) ? font[i] : font,
                )
                each get_extents(subtext, fnt, hsp, hal, maxdepth - 1, nl)
            )] :
        is_undef(text) ?
            [] :
        assert(false, "get_extents: text must be a string or array")
    ];

/*----------------------------------------------------------------------
function get_extent()

Calculate the horizontal extents of a line of text (a string) using
the font, spacing and alignment values provided.

This uses the textmetrics() function available in recent versions of 
OpenSCAD. You may need to enable this development feature (go to Edit > 
Preferences > Features). If it is not available set $have_textmetrics 
to false and the code will estimate the width of text by multiplying 
the number of characters by $char_width (default 0.65) which represents 
the average ratio of width to height for text. This is a very rough 
method and the size may need to be adjusted using rescale.

Returns a triple [left, right, nlines]. left and right are the 
positions of the left and right extremes of the rendered text. nlines 
is just filled in from the supplied argument to facilitate processing 
the results.
----------------------------------------------------------------------*/
$char_width = 0.65;
$have_textmetrics = true;
function get_extent(line, font, hspace, halign, nlines) =
    ($have_textmetrics) ?
        let(tm = textmetrics(line, 1, font, halign = halign, spacing = hspace))
            [tm.offset.x, tm.advance.x + tm.offset.x, nlines] :
        let(xlen = $char_width * len(line) * (is_undef(hspace) ? 1 : hspace))
            (halign == "left") ? 
                [0, xlen, nlines] :
            (halign == "right") ?
                [-xlen, 0, nlines] :
            [-0.5 * xlen, 0.5 * xlen, nlines]  // centered
    ;

/*----------------------------------------------------------------------
zRotRepeat operator module

Generates n repeats of its children at angle around the Z axis. If 
angle is not supplied the repeats are evenly spaced around 360 degrees.
----------------------------------------------------------------------*/
module zRotRepeat(n, angle, startAngle = 0)
{
    theta = ! is_undef(angle) ? angle : 360/n;

    for (i = [0:1:n-1]) {
        rotate(a = i * theta + startAngle, [0, 0, 1])
        children();
    }
}

/*----------------------------------------------------------------------

Layout functions

The die() module generates six face pieces in OpenSCAD space. These 
cannot be generated on top of each other and it is helpful to separate 
them in different ways for different purposes: for visualising the 
results they should be assembled into a complete cube, for printing 
they may be well separated on the print bed in a 2 x 3 array.

Each item in layouts is a name (a string) and a function literal (see 
OpenSCAD documentation). The name is matched to find the desired layout 
and the function is called passing the die size and spacing argument. 
It returns list of 6 transformation matrices, one for each face piece, 
which move the piece into the appropriate position.
----------------------------------------------------------------------*/
layouts = [
    /*
    Position all pieces face up in a line along the X axis.
    Useful for examining and adjusting the face designs.
    */
    ["line", function (size, spacing)
        let(P = (!is_undef(spacing) ? 
                max(spacing, size) :
                ceil(size/10 + 1) * 10)
        )
        [   /* assy_line */
            [[ 1, 0, 0, 0 * P], [0, 1, 0, 0], [0, 0, 1, 0]],
            [[ 1, 0, 0, 1 * P], [0, 1, 0, 0], [0, 0, 1, 0]],
            [[ 1, 0, 0, 2 * P], [0, 1, 0, 0], [0, 0, 1, 0]],
            [[ 1, 0, 0, 3 * P], [0, 1, 0, 0], [0, 0, 1, 0]],
            [[ 1, 0, 0, 4 * P], [0, 1, 0, 0], [0, 0, 1, 0]],
            [[ 1, 0, 0, 5 * P], [0, 1, 0, 0], [0, 0, 1, 0]],
        ]
    ],

    /*
    Position pieces face down in a 3x2 array.
    Can be imported directly into your slicer for printing.
    */
    ["3x2d", function (size, spacing)
        let(P = !is_undef(spacing) ? 
                max(spacing, size) :
                (ceil(size/10) + 1) * 10 + 50
        )
        [
            [[ 1, 0, 0, -P], [ 0, -1,  0,  0.5 * P], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0,  0], [ 0, -1,  0,  0.5 * P], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0,  P], [ 0, -1,  0,  0.5 * P], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0, -P], [ 0, -1,  0, -0.5 * P], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0,  0], [ 0, -1,  0, -0.5 * P], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0,  P], [ 0, -1,  0, -0.5 * P], [ 0,  0, -1,  0]],
        ]
    ],

    /*
    Position pieces face up in a 3x2 array.
    */
    ["3x2u", function (size, spacing)
        let(P = !is_undef(spacing) ? 
                max(spacing, size) :
                (ceil(size/10) + 1) * 10 + 50
        )
        [
            [[ 1, 0, 0, -P], [ 0,  1,  0,  0.5 * P], [ 0,  0,  1,  0]], 
            [[ 1, 0, 0,  0], [ 0,  1,  0,  0.5 * P], [ 0,  0,  1,  0]], 
            [[ 1, 0, 0,  P], [ 0,  1,  0,  0.5 * P], [ 0,  0,  1,  0]], 
            [[ 1, 0, 0, -P], [ 0,  1,  0, -0.5 * P], [ 0,  0,  1,  0]], 
            [[ 1, 0, 0,  0], [ 0,  1,  0, -0.5 * P], [ 0,  0,  1,  0]], 
            [[ 1, 0, 0,  P], [ 0,  1,  0, -0.5 * P], [ 0,  0,  1,  0]],
        ]
    ],

    /*
    Position pieces face down in a 2x3 array.
    */
    ["2x3d", function (size, spacing)
        let(P = !is_undef(spacing) ? 
                max(spacing, size) :
                (ceil(size/10) + 1) * 10 + 50
        )
        [
            [[ 1, 0, 0, -0.5 * P], [ 0, -1,  0,  P], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0,  0.5 * P], [ 0, -1,  0,  P], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0, -0.5 * P], [ 0, -1,  0,  0], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0,  0.5 * P], [ 0, -1,  0,  0], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0, -0.5 * P], [ 0, -1,  0, -P], [ 0,  0, -1,  0]], 
            [[ 1, 0, 0,  0.5 * P], [ 0, -1,  0, -P], [ 0,  0, -1,  0]],
        ]
    ],

    /*
    Position pieces face up in a 2x3 array.
    */
    ["2x3u", function (size, spacing)
        let(P = !is_undef(spacing) ? 
                max(spacing, size) :
                (ceil(size/10) + 1) * 10 + 50
        )
        [
            [[ 1, 0, 0, -0.5 * P], [ 0, 1,  0,  P], [ 0,  0, 1,  0]], 
            [[ 1, 0, 0,  0.5 * P], [ 0, 1,  0,  P], [ 0,  0, 1,  0]], 
            [[ 1, 0, 0, -0.5 * P], [ 0, 1,  0,  0], [ 0,  0, 1,  0]], 
            [[ 1, 0, 0,  0.5 * P], [ 0, 1,  0,  0], [ 0,  0, 1,  0]], 
            [[ 1, 0, 0, -0.5 * P], [ 0, 1,  0, -P], [ 0,  0, 1,  0]], 
            [[ 1, 0, 0,  0.5 * P], [ 0, 1,  0, -P], [ 0,  0, 1,  0]],
        ]
    ],

    /*
    Assemble the pieces into a cube as in the finished die.
    Spacing > 0 can be specified to 'explode' the pieces outward.
    */
    ["cube", function (size, spacing)
        let(G = is_undef(spacing) ? 0 : max(spacing, 0))
        [   /* assy_cube */
            [[ 1,  0,  0,  0], [ 0,  1,  0,  0], [ 0,  0,  1,  G]],
            [[ 0,  0, -1, -G], [ 1,  0,  0,  0], [ 0, -1,  0,  0]],
            [[ 0,  1,  0,  0], [ 0,  0, -1, -G], [-1,  0,  0,  0]],
            [[ 0, -1,  0,  0], [ 0,  0,  1,  G], [-1,  0,  0,  0]],
            [[ 0,  0,  1,  G], [ 1,  0,  0,  0], [ 0,  1,  0,  0]],
            [[ 1,  0,  0,  0], [ 0, -1,  0,  0], [ 0,  0, -1, -G]],
        ]
    ],

    /*
    Position pieces in a cubic net.
    See how they will assemble and check that edges match up.
    */
    ["net", function (size, spacing)
        let(P = !is_undef(spacing) ? 
                max(spacing, size + 3) :
                size + 3
        )
        [   /* assy_net */
            [[ 1,  0, 0, 2 * P], [ 0, -1,  0,  0], [ 0,  0, -1,  0]],
            [[ 0, -1, 0,     P], [-1,  0,  0,  0], [ 0,  0, -1,  0]],
            [[ 0, -1, 0,     0], [-1,  0,  0,  P], [ 0,  0, -1,  0]],
            [[ 0,  1, 0,     0], [ 1,  0,  0, -P], [ 0,  0, -1,  0]],
            [[ 0, -1, 0,    -P], [-1,  0,  0,  0], [ 0,  0, -1,  0]],
            [[-1,  0, 0,     0], [ 0,  1,  0,  0], [ 0,  0, -1,  0]],
        ]
    ],
];

/*
Edge labels identify which faces come together in assembly. They are
not visible on the assembled die so use a font that prints clearly
*/
edgeLabels = [
    ["A", "B", "C", "D"], //A B C
    ["H", "I", "D", "J"], //B C A
    ["K", "E", "J", "C"], //C A B
    ["I", "G", "L", "A"], //B A C
    ["B", "L", "F", "K"], //A C B
    ["E", "F", "G", "H"]  //C B A
];

/*----------------------------------------------------------------------
Special variables
These are values that can be overridden if necessary for special 
purposes. Most are self explanatory

$image_size  An imported image is assumed to be this size (32mm x 
32mm) and will be fitted to the face of the die. Other sizes can 
normally be used easily by speficying an appropriate scale argument 
which can be specified per-face but this provides an alternative 
mechanism.

$die_use_size is the fraction of the nominal size (edge length) to use 
for the text/image. The scale argument can be used for normal
adjustments and can be specified per face so changing this variable is
rarely required.
----------------------------------------------------------------------*/
$default_depth = 0.6;   // default value for engrave_depth
$default_font = "Liberation Sans:style=Regular";    // for text faces
$labelfont = "Liberation Sans:style=Regular"; // used for internal labelling
$image_size = 32;
$die_use_size = 0.85;

// Test
//use <permute.scad>
//die(36, "line", ["gnome", "troll", "dwarf", "elf", "goblin", "giant"], textsize = "match", font = "BankGothic Md BT:style=Medium", rot = 45);
//die(32, "line", permute(["ning", "nang", "nong"]), vspace = 0.8, halign = "right", font = "VAGRounded BT:style=Regular");

