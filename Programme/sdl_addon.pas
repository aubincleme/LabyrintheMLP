unit sdl_addon;

interface
    uses sdl, math;

    procedure sdl_update;
    
    function sdl_get_mouse_x : Uint16;
    function sdl_get_mouse_y : Uint16;
    function sdl_mouse_left_click : boolean;
    function sdl_mouse_right_click : boolean;
    
    function sdl_is_mouse_in(x, y, w, h : integer) : boolean;
    
    function sdl_get_keypressed : integer;
    function sdl_is_keypressed : boolean;

var key_up : Integer;
	keypressed : boolean;

implementation

var
	_event : TSDL_Event;
	delta : real;
	lastTime : longWord;
const
	FPS_target = 60;

procedure sdl_update;
begin
	key_up := -1;
	While SDL_PollEvent(@_event) = 1 do
	Begin
    		If (_event.type_ = SDL_QUITEV) then halt;
		If (_event.type_ = SDL_KEYDOWN) AND (not keypressed) then Begin 
			key_up := _event.key.keysym.sym; 
			keypressed := true; 
		End;
		If (_event.type_ = SDL_KEYUP) then keypressed := false;
		
	End;

	delta := (SDL_GetTicks() - lastTime) / 1000;
	If delta < 1 / FPS_target Then
		SDL_Delay(Floor((1 / FPS_target - delta)*1000));
	delta := (SDL_GetTicks() - lastTime) / 1000;
	lastTime := SDL_GetTicks();
    
    //exit(SDL_PollEvent(@_event));
end;


function sdl_get_mouse_x : Uint16;
begin
    exit(_event.motion.x);
end;

function sdl_get_mouse_y : Uint16;
begin
    exit(_event.motion.y);
end;

function sdl_mouse_left_click : boolean;
begin
    exit((_event.type_ = SDL_MOUSEBUTTONUP) 
    and  (_event.button.button = SDL_BUTTON_LEFT));
end;

function sdl_mouse_right_click : boolean;
begin
    exit((_event.type_ = SDL_MOUSEBUTTONUP) 
    and  (_event.button.button = SDL_BUTTON_RIGHT));
end;

function sdl_is_mouse_in(x, y, w, h : integer) : boolean;
begin
    exit((sdl_get_mouse_x >= x) and
         (sdl_get_mouse_x <= x + w) and
         (sdl_get_mouse_y >= y) and
         (sdl_get_mouse_y <= y + h));
end;


function sdl_get_keypressed : integer;
begin
    if (_event.type_ <> SDL_KEYDOWN) then
        exit(-1);
    
    exit(_event.key.keysym.sym);
end;

function sdl_is_keypressed : boolean;
begin
    exit(_event.type_ = SDL_KEYDOWN);
end;

end.

(* EOF *)
