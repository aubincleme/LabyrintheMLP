Const
	TRANSFORM_STACK_MAX = 128;
	
	DEFAULT_SIZE = 20;
	DEFAULT_COORD_MODE = G_UP_LEFT;
	DEFAULT_X = 0.0;
	DEFAULT_Y = 0.0;
	DEFAULT_COLOR : gColor = (r : 255; g : 255; b : 255; a : 255);
	DEFAULT_ALPHA = $FF;

	RECTS  = 0;
	LINES  = 1;
	QUADS  = 2;
	POINTS = 3;

Type
	Transform = record
		x, y : real;
		rot, rot_sin, rot_cos : real;
		scale_w, scale_h : real;
	end;
	
	Object_ = record
		x, y : real;
		rot_x, rot_y : real;
		rot, rot_sin, rot_cos : real;
		crop_x, crop_y, crop_w, crop_h : integer;
		scale_w, scale_h : real;
		color : gColor;
		alpha : gAlpha;
	end;

var
	(* Main vars *)
	init, start, scissor : Boolean;
	transform_stack : Array[0..(TRANSFORM_STACK_MAX - 1)] of Transform;
	transform_stack_size : integer;
	global_scale : real;
	
	(* Object vars *)
	obj_list : Array of Object_;
	obj : Object_;
	obj_type : gEnum;
	obj_list_size : integer;
	obj_begin, obj_line_strip : Boolean;
	obj_use_blend, obj_use_rot, obj_use_crop,
	obj_use_tex_linear : Boolean;
	obj_coord_mode : gEnum;
	obj_tex : gImage;


procedure gInit(windowName : ansistring; width, height : integer);
begin
   G_SCR_W := width;
   G_SCR_H := height;
   
	(* Setup SDL *)
	SDL_Init(SDL_INIT_VIDEO);
	SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 16);
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	SDL_SetVideoMode(G_SCR_W, G_SCR_H, 24, SDL_OPENGL);
	SDL_WM_SetCaption(PChar(windowName), nil);
    
    TTF_Init();
	
	(* Setup OpenGL *)
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity;
	glOrtho(0, G_SCR_W, G_SCR_H, 0, 0, 1);
	glMatrixMode(GL_MODELVIEW);
	
	gResetScissor;
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glEnable(GL_BLEND);
	glDepthFunc(GL_LEQUAL);
	glDepthRange(0, 65535);
	glClearDepth(65535);
	
	init := true;
end;

procedure gClose;
Begin
	init := false;
    
    	TTF_Quit;
    	SDL_Quit;
End;

procedure gExit;
begin
    	gClose;
	halt;
end;

procedure _gStart;
begin
	If not(init) Then
		gInit('gLib2D', 800, 600);
	
	start := true;
end;

procedure _gSetVertex(i : integer; crop_vx, crop_vy, vx, vy : real);
var
	x, y : real;
	tx, ty : real;
begin
	(* Texture *)
	If (obj_tex <> nil) Then
		glTexCoord2d(crop_vx, crop_vy);
	
	(* Color *)
	glColor4d(	obj_list[i].color.r / 255,
				obj_list[i].color.g / 255,
				obj_list[i].color.b / 255,
				obj_list[i].color.a / 255);
	
	(* Coord *)
	x := obj_list[i].x;
	y := obj_list[i].y;
	
	If (obj_type = RECTS) Then
	begin
		x += vx * obj_list[i].scale_w;
		y += vy * obj_list[i].scale_h;
	end;
	
	(* Rotation *)
	If (obj_use_rot and (obj_type = RECTS)) Then
	begin
		tx := x - obj_list[i].rot_x;
		ty := y - obj_list[i].rot_y;
		x := obj_list[i].rot_x - obj_list[i].rot_sin * ty + obj_list[i].rot_cos * tx;
		y := obj_list[i].rot_y + obj_list[i].rot_cos * ty + obj_list[i].rot_sin * tx;
	end;
	
	glVertex2d(x, y);
end;

(* Main functions *)
procedure gClear(color : gColor);
begin
	If not(start) Then
		_gStart;
		
	glClearColor(color.r, color.g, color.b, color.a);
	glClear(GL_COLOR_BUFFER_BIT);
end;

procedure _gBeginCommon;
begin
	If not(start) Then
		_gStart;
	
	obj_list_size := 0;
	SetLength(obj_list, 256);
	
	obj_use_blend := false;
	obj_use_rot := false;
	
	gReset;
	obj_begin := true;
end;

procedure gBeginRects(tex : gImage);
begin
	If (obj_begin) Then
		exit;
	
	obj_type := RECTS;
	obj_tex := tex;
	_gBeginCommon;
end;

procedure gBeginLines(line_mode : gEnum);
begin
	If (obj_begin) Then
		exit;
	
	obj_type := LINES;
	obj_tex := nil;
	
	If (line_mode = G_STRIP) Then
		obj_line_strip := true
	Else
		obj_line_strip := false;
	
	_gBeginCommon;
end;

procedure gBeginQuads(tex : gImage);
begin
	If (obj_begin) Then
		exit;
	
	obj_type := QUADS;
	obj_tex := tex;
	_gBeginCommon;
end;

procedure gBeginPoints;
begin
	If (obj_begin) Then
		exit;
	
	obj_type := POINTS;
	obj_tex := nil;
	_gBeginCommon;
end;

procedure _gEndRects;
var
	i : integer;
	sx, sy, max_x, max_y : real;
begin
	glBegin(GL_TRIANGLES);
    
	For i := 0 to obj_list_size - 1 Do
	begin
		if ((obj_tex <> nil) and (obj_use_crop)) then
		begin
            sx := obj_list[i].crop_x / obj_tex^.w;
            sy := obj_list[i].crop_y / obj_tex^.h;
              
            max_x := (obj_list[i].crop_x + obj_list[i].crop_w) / obj_tex^.w;
            max_y := (obj_list[i].crop_y + obj_list[i].crop_h) / obj_tex^.h;
			
			(*_gSetVertex(i, sx, max_y, 0, 1);
			_gSetVertex(i, sx, sy, 0, 0);
			_gSetVertex(i, max_x, sy, 1, 0);
			_gSetVertex(i, max_x, max_y, 1, 1);*)
            
            _gSetVertex(i, sx, sy, 0, 0);
            _gSetVertex(i, max_x, sx, 1, 0);
            _gSetVertex(i, sx, max_y, 0, 1);
            _gSetVertex(i, sx, max_y, 0, 1);
            _gSetVertex(i, max_x, sx, 1, 0);
            _gSetVertex(i, max_x, max_y, 1, 1)
		end
		else
		begin
			_gSetVertex(i, 0, 0, 0, 0); //0 1
			_gSetVertex(i, 1, 0, 1, 0); // 0 0
			_gSetVertex(i, 0, 1, 0, 1); // 1 0
			_gSetVertex(i, 0, 1, 0, 1); // 1 1
            _gSetVertex(i, 1, 0, 1, 0);
            _gSetVertex(i, 1, 1, 1, 1);
		end;
	end;
	
	glEnd;
end;

procedure _gEndLines;
var
	i : integer;
begin
	If obj_line_strip Then
		glBegin(GL_LINE_STRIP)
	Else
		glBegin(GL_LINES);
	
	For	i := 0 to obj_list_size - 1 Do
		_gSetVertex(i, 0, 0, 0, 0);
	
	glEnd;
end;

procedure _gEndQuads;
var
	i : integer;
begin
	glBegin(GL_TRIANGLES);
	
	i := 0;
	While (i + 3 < obj_list_size) do
	begin
		_gSetVertex(i, 0, 0, 0, 0);
		_gSetVertex(i + 1, 1, 0, 1, 0);
		_gSetVertex(i + 3, 0, 1, 0, 1);
		_gSetVertex(i + 3, 0, 1, 0, 1);
		_gSetVertex(i + 1, 1, 0, 1, 0);
		_gSetVertex(i + 2, 1, 1, 1, 1);
				
		i += 4;
	end;
	
	glEnd;
end;

procedure _gEndPoints;
var
	i : integer;
begin
	glBegin(GL_POINTS);
	
	For i := 0 to obj_list_size - 1 Do
		_gSetVertex(i, 0, 0, 0, 0);
	
	glEnd;
end;

procedure gEnd;
begin
	If (not(obj_begin) or (obj_list_size <= 0)) Then
	begin
		obj_begin := false;
		exit;
	end;
	
	(* Manage extensions *)	
	If (obj_use_blend) Then
		glEnable(GL_BLEND)
	Else
		glDisable(GL_BLEND);
	
	If (obj_tex = nil) Then
		glDisable(GL_TEXTURE_2D)
	Else
	begin
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, obj_tex^.id);
		
		If (obj_use_tex_linear) Then
		begin
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		end
		Else
		begin
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
		end;
	end;
	
	Case obj_type Of
		RECTS:  _gEndRects;
		LINES:  _gEndLines;
		QUADS:  _gEndQuads;
		POINTS: _gEndPoints;
	end;
	
	glColor3f(1.0, 1.0, 1.0);
	glEnable(GL_BLEND);
	
	obj_begin := false;
end;

procedure gReset;
begin
	gResetCoord;
	gResetScale;
	gResetColor;
	gResetAlpha;
	gResetRotation;
	gResetCrop;
	
    if (obj_tex <> NIL) then
    begin
        obj_use_tex_linear := true;
        obj_use_blend := true;
    end;

end;

procedure gFlip;
begin
	If (scissor) Then
		gResetScissor;
	
	glFinish;
	SDL_GL_SwapBuffers;
	
	start := false;
end;

procedure gAdd;
begin
	If (not(obj_begin) or (obj.scale_w = 0) or  (obj.scale_h = 0)) Then
		exit;
	
	inc(obj_list_size);
	obj.rot_x := obj.x;
	obj.rot_y := obj.y;
	
	obj_list[obj_list_size - 1] := obj;
	
    With obj_list[obj_list_size-1] Do
    begin
        (* Coord Mode Stuff *)
        Case obj_coord_mode Of
            G_UP_RIGHT:
                x -= scale_w;
            
            G_DOWN_LEFT:
                y -= scale_h;
            
            G_DOWN_RIGHT:
                begin
                    x -= scale_w;
                    y -= scale_h;
                end;
            
            G_CENTER:
                begin
                    x -= scale_w / 2;
                    y -= scale_h / 2;
                end;
        end;
        
        (* Alpha Stuff *)
        color.a := alpha;
    end;
end;

procedure gPush;
begin
	If (transform_stack_size >= TRANSFORM_STACK_MAX) Then
		exit;
	
	inc(transform_stack_size);
    
    With transform_stack[transform_stack_size-1] Do
    begin
        x := obj.x;
        y := obj.y;
        rot := obj.rot;
        rot_sin := obj.rot_sin;
        rot_cos := obj.rot_cos;
        scale_w := obj.scale_w;
        scale_h := obj.scale_h;
    end;
end;

procedure gPop;
begin
	If (transform_stack_size <= 0) Then
		exit;
	
    With transform_stack[transform_stack_size-1] Do
    begin
        obj.x := x;
        obj.y := y;
        obj.rot := rot;
        obj.rot_sin := rot_sin;
        obj.rot_cos := rot_cos;
        obj.scale_w := scale_w;
        obj.scale_h := scale_h;
	end;
    
	dec(transform_stack_size);
end;

(* Texture Management *)

procedure gTexFree(tex : gImage);
begin
	If (tex = nil) Then
		exit;
	
	glDeleteTextures(1, @tex^.id);
end;

procedure _gSurfToTex(var tex : gImage; var picture_surface : PSDL_Surface);
var
    gl_surface : PSDL_Surface;
	format : TSDL_PixelFormat;
begin	
	format := (picture_surface^.format)^;
	format.BitsPerPixel := 32;
	format.BytesPerPixel := 4;
	format.Rmask := $000000FF;
	format.Gmask := $0000FF00;
	format.Bmask := $00FF0000;
	format.Amask := $FF000000;
	
	gl_surface := SDL_ConvertSurface(picture_surface, @format, SDL_SWSURFACE);
	
	tex^.w := gl_surface^.w;
	tex^.h := gl_surface^.h;
	
	glGenTextures(1, @tex^.id);
	glBindTexture(GL_TEXTURE_2D, tex^.id);
	glTexImage2D(GL_TEXTURE_2D, 0, 4, gl_surface^.w,
				 gl_surface^.h, 0, GL_RGBA, GL_UNSIGNED_BYTE,
				 gl_surface^.pixels);
	
	SDL_FreeSurface(gl_surface);
end;

function gTexLoad(path : AnsiString) : gImage;
var
	tex : gImage;
	picture_surface : PSDL_Surface;
begin
	If (path = '') Then
		exit(nil);
	
	If not(start) Then
		_gStart;
	
	new(tex);
	
	picture_surface := IMG_Load(PChar(path));
    
	If (picture_surface = nil) Then
    begin
        writeln('Cannot load ', path);
		exit(nil);
    end;
	
    _gSurfToTex(tex, picture_surface);
	SDL_FreeSurface(picture_surface);
	
	exit(tex);
end;

function gTextLoad(text : AnsiString; var font : PTTF_Font) : gImage;
var
    white_sdl : TSDL_Color; (* Basically, Text is white *)
    text_surf : PSDL_Surface;
    tex : gImage;
begin
    If not(start) Then
		_gStart;
    
    white_sdl.r := 255;
    white_sdl.g := 255;
    white_sdl.b := 255;
    
    new(tex);
    
    text_surf := TTF_RenderText_Blended(font, PChar(text), white_sdl);
    
    _gSurfToTex(tex, text_surf);
    SDL_FreeSurface(text_surf);
    
    exit(tex);
end;


(* Coord functions *)

procedure gResetCoord;
begin
    obj_coord_mode := DEFAULT_COORD_MODE;
    obj.x := DEFAULT_X;
    obj.y := DEFAULT_Y;
end;

procedure gSetCoordMode(coord_mode : gEnum);
begin
    if (coord_mode >= G_UP_LEFT) and (coord_mode <= G_CENTER) then
        obj_coord_mode := coord_mode;
end;

procedure gGetCoord(var x, y : real);
begin
    x := obj.x;
    y := obj.y;
end;

procedure gSetCoord(x, y : real);
begin
    obj.x := x * global_scale;
    obj.y := y * global_scale;
end;

procedure gSetCoordRelative(x, y : real);
var
    inc_x, inc_y : real;
begin
    inc_x := x;
    inc_y := y;
    if (obj.rot_cos <> 1.0) then
    begin
        inc_x := -obj.rot_sin * y + obj.rot_cos * x;
        inc_y :=  obj.rot_cos * y + obj.rot_sin * x;
    end;
    obj.x += inc_x * global_scale;
    obj.y += inc_y * global_scale; 
end;


(* Scale functions *)

procedure gResetGlobalScale;
begin
    global_scale := 1.0;
end;

procedure gResetScale;
begin
    if (obj_tex = NIL) then
    begin
        obj.scale_w := DEFAULT_SIZE;
        obj.scale_h := DEFAULT_SIZE;
    end
    else
    begin
        obj.scale_w := obj_tex^.w;
        obj.scale_h := obj_tex^.h;
    end;
  
    obj.scale_w *= global_scale;
    obj.scale_h *= global_scale;
end;

procedure gGetGlobalScale(scale : real);
begin
    scale := global_scale;
end;

procedure gGetScaleWH(var w, h : real);
begin
    w := obj.scale_w;
    h := obj.scale_h;
end;

procedure gSetGlobalScale(scale : real);
begin
    global_scale := scale;
end;

procedure gSetScale(fact_w, fact_h : real);
begin
    gResetScale();
    gSetScaleRelative(fact_w, fact_h);
end;

procedure gSetScaleWH(w, h : real);
begin
    obj.scale_w := w * global_scale;
    obj.scale_h := h * global_scale;
    
    // A trick to prevent an unexpected behavior when mirroring.
    if (obj.scale_w < 0) or (obj.scale_h < 0) then
        obj_use_rot := true;
end;

procedure gSetScaleRelative(fact_w, fact_h : real);
begin
    obj.scale_w *= fact_w;
    obj.scale_h *= fact_h;

    if (obj.scale_w < 0) or (obj.scale_h < 0) then
        obj_use_rot := true;
end;

procedure gSetScaleWHRelative(w, h : real);
begin
    obj.scale_w += w * global_scale;
    obj.scale_h += h * global_scale;

    if (obj.scale_w < 0) or (obj.scale_h < 0) then
        obj_use_rot := true;
end;

(* Color functions *)

procedure gResetColor;
begin
    obj.color := DEFAULT_COLOR;
end;

procedure gResetAlpha;
begin
    obj.alpha := DEFAULT_ALPHA;
end;

procedure gGetAlpha(var alpha : gAlpha);
begin
    alpha := obj.alpha;
end;

procedure gSetColor(color : gColor);
begin
    obj.color := color;
    if (obj.color.a < 255) then
        obj_use_blend := true;
end;

procedure gSetAlpha(alpha : gAlpha);
begin
    obj.alpha := alpha;
    if (obj.alpha < 255) then
        obj_use_blend := true;
end;

procedure gSetAlphaRelative(alpha : integer);
begin
    gSetAlpha(obj.alpha + alpha);
end;

(* Rotations functions *)

procedure gResetRotation;
begin
    obj.rot := 0.0;
    obj.rot_sin := 0.0;
    obj.rot_cos := 1.0;
end;

procedure gGetRotationRad(var radians : real);
begin
    radians := obj.rot;
end;

procedure gGetRotation(var degrees : real);
begin
    degrees := obj.rot * 180.0 / PI;
end;

procedure gSetRotationRad(radians : real);
begin
    if (radians <> obj.rot) then
    begin
        obj.rot := radians;
        obj.rot_sin := sin(radians);
        obj.rot_cos := cos(radians);
        if (radians <> 0.0) then obj_use_rot := true;
    end;
end;

procedure gSetRotation(degrees : real);
begin
    gSetRotationRad(degrees * PI / 180.0);
end;

procedure gSetRotationRadRelative(radians : real);
begin
    gSetRotationRad(obj.rot + radians);
end;

procedure gSetRotationRelative(degrees : real);
begin
    gSetRotationRadRelative(degrees * PI / 180.0);
end;

(* Crop functions *)

procedure gResetCrop;
begin
    if (obj_tex <> NIL) then
    begin
        obj.crop_x := 0;
        obj.crop_y := 0;
        obj.crop_w := obj_tex^.w;
        obj.crop_h := obj_tex^.h;
        obj_use_crop := false;
    end;
end;

procedure gGetCropXY(var x, y : integer);
begin
    if (obj_tex <> NIL) then
    begin
        x := obj.crop_x;
        y := obj.crop_y;
    end;
end;

procedure gGetCropWH(var w, h : integer);
begin
    if (obj_tex <> NIL) then
    begin
        w := obj.crop_w;
        h := obj.crop_h;
    end;
end;

procedure gSetCropXY(x, y : integer);
begin
    if (obj_tex <> NIL) then
    begin
        obj.crop_x := x;
        obj.crop_y := y;
        obj_use_crop := true;
    end;
end;

procedure gSetCropWH(w, h : integer);
begin
    if (obj_tex <> NIL) then
    begin
        obj.crop_w := w;
        obj.crop_h := h;
        obj_use_crop := true;
    end;
end;

procedure gSetCropXYRelative(x, y : integer);
begin
    if (obj_tex <> NIL) then 
        gSetCropXY(obj.crop_x + x, obj.crop_y + y);
end;

procedure gSetCropWHRelative(w, h : integer);
begin
    if (obj_tex <> NIL) then
        gSetCropWH(obj.crop_w + w, obj.crop_h + h);
end;

(* Scissor functions *)

procedure gResetScissor;
begin
    gSetScissor(0, 0, G_SCR_W, G_SCR_H);
    scissor := false;
end;

procedure gSetScissor(x, y, w, h : integer);
begin
    glScissor(x,y,w,h);
    scissor := true;
end;

(* Other code *)

function gCreateColor(r, g, b, a : integer) : gColor;
begin
   gCreateColor.r := r;
   gCreateColor.g := g;
   gCreateColor.b := b;
   gCreateColor.a := a;
end;

procedure gDraw(x, y : real; image : gImage);
begin
    gBeginRects(image);
        gSetCoord(x, y);
        gAdd;
    gEnd;
end;

procedure gBlit(x, y : real; image : gImage; w, h : real);
begin
    gBeginRects(image);
        gSetCoord(x, y);
        gSetScaleWH(w, h);
        gAdd();
    gEnd();
end;

procedure gDrawRect(x, y, w, h : real; color : gColor);
begin
    gBeginLines(G_STRIP);
        gSetColor(color);
        
        gSetCoord(x, y);
        gAdd();
        
        gSetCoord(x + w, y);
        gAdd();
        
        gSetCoord(x + w, y + h);
        gAdd();
        
        gSetCoord(x, y + h);
        gAdd();
        
        gSetCoord(x, y);
        gAdd();
    gEnd();
end;

procedure gFillRect(x, y, w, h : real; color : gColor);
begin
    gBeginRects(nil);
        gSetColor(color);
        gSetScaleWH(w, h);
        gSetCoord(x, y);
        gAdd();
    gEnd();
end;

procedure gDrawCircle(cx, cy, radius : real; color : gColor);
var
    i : real;
begin
    i := 0;
    
    gBeginLines(G_STRIP);
    gSetColor(color);
    
    while (i <= 2*PI + 0.1) do
    begin
        gSetCoord(cx + radius * cos(i), cy + radius * sin(i));
        gAdd();
        
        i += 0.1;
    end;
    gEnd();
end;

procedure gFillCircle(cx, cy, radius : real; color : gColor);
var i : real;
begin
    i := 0;

    while (i <= radius) do
    begin
        gDrawCircle(cx, cy, i, color);
        i += 0.7;
    end;
end;

procedure gDrawTriangle(x1, y1, x2, y2, x3, y3 : real; color : gColor);
begin
   gBeginLines(G_STRIP);
   
   gSetColor(color);
   
   gSetCoord(x1, y1);
   gAdd;
   
   gSetCoord(x2, y2);
   gAdd;
   
   gSetCoord(x3, y3);
   gAdd;
   
   gSetCoord(x1, y1);
   gAdd;
   
   gEnd;
end;

procedure gFillTriangle(x1, y1, x2, y2, x3, y3 : real; color : gColor);
begin
   gBeginQuads(nil);
   
   gSetColor(color);
   
   gSetCoord(x1, y1);
   gAdd;
   
   gSetCoord(x2, y2);
   gAdd;
   
   gSetCoord(x3, y3);
   gAdd;
   gAdd; (* Little trick : Triangle is a quad with two points at the same position *)
   
   gEnd;
end;

procedure gSetPixel(x, y : real; color : gColor);
begin
   gBeginPoints;
   
   gSetColor(color);
   
   gSetCoord(x, y);
   gAdd;
   
   gEnd;
end;

function gGetPixel(x, y : integer) : gColor; (* Slow function *)
var
   px : pbyte;
begin
   getMem(px, 1 * 1 * 4); (* w * h * 4 *)
   
   glPixelStorei(GL_PACK_ALIGNMENT, 4);
   glReadPixels(x, y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, px);
   
   writeln(glGetError);
   
   gGetPixel.r := px[0];
   gGetPixel.g := px[1];
   gGetPixel.b := px[2];
   gGetPixel.a := px[3];
   
   freeMem(px);
end;

Initialization

init := false;
start := false;
scissor := false;
global_scale := 1.0;
obj_begin := false;

(* EOF *)
