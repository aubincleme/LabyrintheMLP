(*
* gLib2D by Geecko - A simple, fast, light-weight 2D graphics library.
* This work is licensed under the Creative Commons BY-SA 3.0 Unported License.
*)

Unit gLib2D;

Interface

Uses 
    GL, SDL, SDL_Image, SDL_TTF, Math;

Type
	gImage = ^_gImage;
    _gImage = record
        w, h : integer;
        ratio : real;
        id : GLuint;
    end;
    
    gColor = record
        r, g, b, a : byte;
    end;
    
    gAlpha          = byte;
    gEnum           = integer;

Const
    G_VOID          = 0;

    (* Colors *)
    RED             : gColor = (r : 255; g : 0;   b : 0;   a : 255);
    GREEN           : gColor = (r : 0;   g : 255; b : 0;   a : 255);
    BLUE            : gColor = (r : 0;   g : 0;   b : 255; a : 255);

    CYAN            : gColor = (r : 0;   g : 255; b : 255; a : 255);
    MAGENTA         : gColor = (r : 255; g : 0;   b : 255; a : 255);
    YELLOW          : gColor = (r : 255; g : 255; b : 0;   a : 255);

    AZURE           : gColor = (r : 0;   g : 128; b : 255; a : 255);
    VIOLET          : gColor = (r : 128; g : 0;   b : 255; a : 255);
    PINK            : gColor = (r : 255; g : 128; b : 128; a : 255);
    ORANGE          : gColor = (r : 255; g : 128; b : 0;   a : 255);
    CHARTREUSE      : gColor = (r : 127; g : 255; b : 0;   a : 255);
    SPRING_GREEN    : gColor = (r : 0;   g : 255; b : 128; a : 255);

    WHITE           : gColor = (r : 255; g : 255; b : 255; a : 255);
    LITEGRAY        : gColor = (r : 159; g : 159; b : 159; a : 255);
    GRAY            : gColor = (r : 128; g : 128; b : 128; a : 255);
    DARKGRAY        : gColor = (r : 63;  g : 63;  b : 63;  a : 255);
    BLACK           : gColor = (r : 0;   g : 0;   b : 0;   a : 255);
    
    (* Coordinates modes *)
    G_UP_LEFT       = 0;
    G_UP_RIGHT      = 1;
    G_DOWN_RIGHT    = 2;
    G_DOWN_LEFT     = 3;
    G_CENTER        = 4;
    
    (* Enable line strip, in gBeginLines(G_STRIP); *)
    G_STRIP         = 1;
    
    PI              = 3.141592653589;

var
   G_SCR_W, G_SCR_H : integer;


(* Functions prototypes *)


(*
    gExit;
    * Exit the gLib2D, and close the window
*)

procedure gClose;

procedure gExit;

(*
    gClear(color);
    * Clear the screen 
*)

procedure gClear(color : gColor);


(*
    gBeginRects(tex);
    * Begin rectangles rendering
    * tex -> texture loaded with gTexLoad or nil (no texture)
*)

procedure gBeginRects(tex : gImage);


(*
    gBeginLines(line_mode);
    * Begin lines rendering
    * line_mode -> G_STRIP or G_VOID
*)

procedure gBeginLines(line_mode : gEnum);

(*
    gBeginQuads(tex);
    * Begin quads rendering
    * tex -> texture loaded with gTexLoad or nil (no texture)
*)

procedure gBeginQuads(tex : gImage);


(*
    gBeginPoints;
    * Begin points rendering
*)

procedure gBeginPoints;


(*
    gEnd;
    * End object rendering
*)

procedure gEnd;


(*
    gReset;
    * Reset current transformation and attribution
*)

procedure gReset;


(* 
    gFlip;
    * Flip the screen
*)

procedure gFlip;


(*
    gAdd;
    * Push the current transformation & attribution to a new object
*)

procedure gAdd;


(*
    gPush;
    * Save the current transformation to stack
*)

procedure gPush;


(*
    gPop;
    * Restore the current transformation from stack
*)

procedure gPop;



(*
    gTexFree;
    * Free an image
*)

procedure gTexFree(tex : gImage);


(*
    gTexLoad(path);
    * Loads an image
*)

function  gTexLoad(path : AnsiString) : gImage;


(*
    gTextLoad(text, font);
    * Print a text in an image, to be able to blit it after
*)

function  gTextLoad(text : AnsiString; var font : PTTF_Font) : gImage;


(*
    gResetCoord;
    * Reset the current coordinates
*)

procedure gResetCoord;


(*
    gSetCoordMode(mode);
    * Set coordinate mode
    * mode -> One of the coordinates modes (defined in Const)
*)

procedure gSetCoordMode(coord_mode : gEnum);


(*
    gGetCoord(x, y);
    * Get the current position
    * x, y -> variables in which the coordinates will be set
*)

procedure gGetCoord(var x, y : real);


(*
    gSetCoord(x, y);
    * Set the new position
    * x, y -> the new position on screen
*)

procedure gSetCoord(x, y : real);


(*
    gSetCoordRelative(x, y);
    * Set the new position, relatively to the current position
*)

procedure gSetCoordRelative(x, y : real);



(*
    gResetGlobalScale;
    * Reset the global scale
*)

procedure gResetGlobalScale;


(*
    gResetScale;
    * Reset the current scale
*)

procedure gResetScale;


(*
    gGetGlobalScale(scale : real);
    * Get the global scale
    * scale -> variable in which the global scale will be set
*)

procedure gGetGlobalScale(scale : real);


(*
    gGetScaleWH(w, h);
    * Get the current scale
    * w, h -> variables in which the scales's width and height will be set
*)

procedure gGetScaleWH(var w, h : real);


(*
    gSetGlobalScale(scale);
    * Set the global scale
    * scale -> the new global scale
*)

procedure gSetGlobalScale(scale : real);


(*
    gSetScale(w, h);
    * Set the new scale
    * w, h -> the new scale's width & height (factors)
*)

procedure gSetScale(fact_w, fact_h : real);


(*
    gSetScaleWH(w, h);
    * Set the new scale, in pixels
    * w, h -> the new scale's width & height
*)

procedure gSetScaleWH(w, h : real);


(*
    gSetScaleRelative(w, h);
    * Set the new scale, relatively to the current one
    * w, h -> Current width & height will be multiplicated by w & h
*)

procedure gSetScaleRelative(fact_w, fact_h : real);


(*
    gSetScaleWHRelative(w, h);
    * Set the new scale, in pixels, relatively to the current one
    * w, h -> new width & height to increment
*)

procedure gSetScaleWHRelative(w, h : real);



(*
    gResetColor;
    * Reset the current color
*)

procedure gResetColor;


(*
    gSetColor(color);
    * Set the new color
    * color -> the new color
*)

procedure gSetColor(color : gColor);


(*
    gResetAlpha;
    * Reset the current alpha value (opacity)
*)

procedure gResetAlpha;


(*
    gGetAlpha(alpha);
    * Get the current alpha value (0 -> 255)
    * alpha -> variable in which the current alpha value will be set
*)

procedure gGetAlpha(var alpha : gAlpha);


(*
    gSetAlpha(alpha);
    * Set the new alpha value
    * alpha -> the new alpha value (0 -> 255)
*)

procedure gSetAlpha(alpha : gAlpha);


(*
    gSetAlphaRelative(alpha);
    * Set the new alpha value, relatively to the current one
    * alpha -> the new alpha value (0 -> 255)
*)

procedure gSetAlphaRelative(alpha : integer);



(*
    gResetRotation;
    * Reset the current rotation
*)

procedure gResetRotation;


(*
    gGetRotationRad(radians);
    * Get the current rotation, in radians
    * radians -> variable in which the current rotation will be set
*)

procedure gGetRotationRad(var radians : real);


(*
    gGetRotation(degrees);
    * Get the current rotation, in degrees
    * degrees -> variable in which the current rotation will be set
*)

procedure gGetRotation(var degrees : real);


(*
    gSetRotationRad(radians);
    * Set the new rotation, in radians
    * radians -> the new rotation's angle
*)

procedure gSetRotationRad(radians : real);


(*
    gSetRotation(degrees);
    * Set the new rotation, in degrees
    * degrees -> the new rotation's angle
*)

procedure gSetRotation(degrees : real);


(*
    gSetRotationRadRelative(radians);
    * Set the new rotation, in radians, relatively to the current one
    * radians -> the angle to add to the current angle
*)

procedure gSetRotationRadRelative(radians : real);


(*
    gSetRotationRelative(degrees);
    * Set the new rotation, in degrees, relatively to the current one
    * degrees -> the angle to add to the current angle
*)

procedure gSetRotationRelative(degrees : real);



(*
    gResetCrop;
    * Reset the current crop
*)

procedure gResetCrop;


(*
    gGetCropXY(x, y);
    * Get the current crop's X & Y
    * x, y -> variables in which the crop's X & Y will be set
*)

procedure gGetCropXY(var x, y : integer);


(*
    gGetCropWH(w, h);
    * Get the current crop's width & height
    * w, h -> variables in which the crop's width & height will be set
*)

procedure gGetCropWH(var w, h : integer);


(*
    gSetCropXY(x, y);
    * Set the new crop's X & Y coordinates
    * x, y : the new crop's X & Y values
*)

procedure gSetCropXY(x, y : integer);


(*
    gSetCropWH(w, h);
    * Set the new crop's width & height size
    * w, h : the new crop's width & height values
*)

procedure gSetCropWH(w, h : integer);


(*
    gSetCropXYRelative(x, y);
    * Set the new crop's X & Y coordinates, relatively to the current one
    * x, y : the cooridinates to add to the current crop's X & Y
*)

procedure gSetCropXYRelative(x, y : integer);


(*
    gSetCropWHRelative(x, y);
    * Set the new crop's width & height size, relatively to the current one
    * w, h : the values to add to the current crop's width & height
*)

procedure gSetCropWHRelative(w, h : integer);



(*
    gResetScissor;
    * Reset the draw zone to the whole screen
*)

procedure gResetScissor;


(*
    gSetScissor(x, y, w, h);
    * Set the draw zone
    * x, y, w, h : the new draw zone's x, y, width & height
*)
procedure gSetScissor(x, y, w, h : integer);


(* Procedures pour les tapettes :D
    gDraw(x, y, image);
    * Blit an image at its initial size (calls gBeginRects, gSetCoord, gSetScale, gAdd, gEnd)
    
    gBlit(x, y, image, w, h);
    * Blit an image (calls gBeginRects, gSetCoord, gSetScale, gAdd, gEnd)
    
    gDrawRect(x, y, w, h, color);
    * Draw an empty rectangle
    
    gFillRect(x, y, w, h, color);
    * Draw a filled rectangle
    
    gDrawCircle(cx, cy, radius, color);
    * Draw an empty circle
    
    gFillCircle(cx, cy, radius, color);
    * Draw a filled circle
*)

procedure gInit(windowName : ansistring; width, height : integer);

function gCreateColor(r, g, b, a : integer) : gColor;

procedure gDraw(x, y : real; image : gImage);
procedure gBlit(x, y : real; image : gImage; w, h : real);

procedure gDrawRect(x, y, w, h : real; color : gColor);
procedure gFillRect(x, y, w, h : real; color : gColor);

procedure gDrawCircle(cx, cy, radius : real; color : gColor);
procedure gFillCircle(cx, cy, radius : real; color : gColor);

procedure gDrawTriangle(x1, y1, x2, y2, x3, y3 : real; color : gColor);
procedure gFillTriangle(x1, y1, x2, y2, x3, y3 : real; color : gColor);

procedure gSetPixel(x, y : real; color : gColor);
function gGetPixel(x, y : integer) : gColor;

Implementation

{$Include glib2dimplementation.pas}

End.

(* EOF *)
