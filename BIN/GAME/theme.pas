Procedure themeOptions(var matrix : theMatrix);

{$I 'BIN/const.pas'}

Var 	leftArrow, rightArrow, background, mainTitle, menuTitle, validate : gImage;
	selectedSprite : array[1 .. 6] of gImage;
	mainFont, menuTitleFont, menuItemsFont : PTTF_Font;
	originalCursorPosition : cursorPosition;
	spriteStrings : array[1 .. 6] of string;
	choice, i, keyCode : integer;
	choiceOk : boolean;
Begin
	choiceOK := false;	// On initialise les variables de base : choix et position du curseur
	choice := 1;
	originalCursorPosition.x := sdl_get_mouse_x;
	originalCursorPosition.y := sdl_get_mouse_y;
	background := gTexLoad('BIN/RC/' + matrix.theme + '/background.png');

	mainFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 40);
	menuTitleFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 35);
	menuItemsFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 30);

	mainTitle := gTextLoad('Labyrinthe - ' + matrix.edition + ' Edition', mainFont);	// On définit les éléments de titre
	menuTitle := gTextLoad('--- CHOIX DU THEME ---', menuTitleFont);
	validate := gTextLoad('Valider !', menuItemsFont);

	leftArrow := gTexLoad('BIN/RC/leftarrow.png');
	rightArrow := gTexLoad('BIN/RC/rightarrow.png');

	spriteStrings[1] := 'PINKIEPIE';
	spriteStrings[2] := 'RAINBOWDASH';
	spriteStrings[3] := 'RARITY';
	spriteStrings[4] := 'TWILIGHTSPARKLE';
	spriteStrings[5] := 'VINYLSCRATCH';
	spriteStrings[6] := 'AVENGERS';

	For i := 1 to 6 do selectedSprite[i] := gTexLoad('BIN/RC/' + spriteStrings[i] + '/front.png');

	sdl_update;

	Repeat
		gClear(GUI_GRAY);

		gBeginRects(background);
          		gSetCoordMode(G_UP_LEFT);
          		gSetCoord(0, 0);
          		gAdd();
		gEnd();

		gBeginRects(mainTitle);	// On affiche le titre principal
          		gSetCoordMode(G_CENTER);
          		gSetCoord(G_SCR_W div 2, 1*(G_SCR_H div 12));
            		gSetColor(GUI_BLACK);
          		gAdd();
		gEnd();

		gBeginRects(menuTitle);	// On affiche le titre du menu
        		gSetCoordMode(G_CENTER);
        		gSetCoord(G_SCR_W div 2, 3*(G_SCR_H div 12));
        		gSetColor(GUI_BLACK);
        		gAdd();
        	gEnd();

        	gBeginRects(selectedSprite[choice]);
        	   	gSetCoordMode(G_CENTER);
        	    	gSetCoord(G_SCR_W div 2, (6)*(G_SCR_H div 10));
        	    	//gSetColor(GUI_AZURE);
        	    	gAdd();
        	gEnd();

		gBeginRects(leftArrow);
        	   	gSetCoordMode(G_CENTER);
        	    	gSetCoord((G_SCR_W div 6), (6)*(G_SCR_H div 10));
        	    	//gSetColor(GUI_AZURE);
        	    	gAdd();
        	gEnd();

		gBeginRects(rightArrow);
        	   	gSetCoordMode(G_CENTER);
        	    	gSetCoord(5*(G_SCR_W div 6), (6)*(G_SCR_H div 10));
        	    	//gSetColor(GUI_AZURE);
        	    	gAdd();
        	gEnd();

		gBeginRects(validate);
        		gSetCoordMode(G_CENTER);
        		gSetCoord(G_SCR_W div 2, 10*(G_SCR_H div 12));
        		gSetColor(GUI_BLACK);
        		gAdd();
        	gEnd();

		If sdl_is_mouse_in(G_SCR_W div 2 - (validate^.w div 2) - 15, 10*(G_SCR_H div 12) - (validate^.h div 2) - 10, validate^.w + 30, validate^.h + 20) then
			Begin
				gDrawRect(G_SCR_W div 2 - (validate^.w div 2) - 15, 10*(G_SCR_H div 12) - (validate^.h div 2) - 10, validate^.w + 30, validate^.h + 20, GUI_WHITE);
				gDrawRect(G_SCR_W div 2 - (validate^.w div 2) - 14, 10*(G_SCR_H div 12) - (validate^.h div 2) - 9, validate^.w + 28, validate^.h + 18, GUI_WHITE);
				gDrawRect(G_SCR_W div 2 - (validate^.w div 2) - 13, 10*(G_SCR_H div 12) - (validate^.h div 2) - 8, validate^.w + 26, validate^.h + 16, GUI_WHITE);
		End;

		If sdl_mouse_left_click AND (originalCursorPosition.x <> sdl_get_mouse_x) AND (originalCursorPosition.y <> sdl_get_mouse_y) then
		Begin
			If sdl_is_mouse_in((G_SCR_W div 6) - 10, 6*(G_SCR_H div 10) - (leftArrow^.h div 2) - 10, leftArrow^.w + 10, leftArrow^.h + 10) then
			Begin
				originalCursorPosition.x := sdl_get_mouse_x;
				originalCursorPosition.y := sdl_get_mouse_y;
				If choice = 1 then choice := 6
				Else choice := choice - 1;
			End
			Else if sdl_is_mouse_in(5*(G_SCR_W div 6) - 10, 6*(G_SCR_H div 10) - (rightArrow^.h div 2) - 10, rightArrow^.w + 10, rightArrow^.h + 10) then
			Begin
				originalCursorPosition.x := sdl_get_mouse_x;
				originalCursorPosition.y := sdl_get_mouse_y;
				If choice = 6 then choice := 1
				Else choice := choice + 1;
			End
			Else if sdl_is_mouse_in((G_SCR_W div 2) - (validate^.w div 2) - 10, 10*(G_SCR_H div 12) - (validate^.h div 2) - 10, validate^.w + 10, validate^.h + 10) then choiceOk := true;
		End;

		If sdl_is_keypressed then 
		Begin
			keyCode := sdl_get_keypressed;
			If keyCode = 27 then 	// Si ECHAP est pressée
			Begin
				choice := 1;
				choiceOk := true;
			End
			Else if keyCode = 276 then
				If choice = 1 then choice := 6
				Else choice := choice - 1
			Else if keyCode = 275 then 
				If choice = 6 then choice := 1
				Else choice := choice + 1;
		End;

		gFlip();

		sdl_update;

	Until choiceOk = true;

	matrix.theme := spriteStrings[choice];
	
	Case matrix.theme of
		'AVENGERS' : matrix.edition := 'Avengers';
		'PINKIEPIE' : matrix.edition := 'My Little Pony';
		'RAINBOWDASH' : matrix.edition := 'My Little Pony';
		'RARITY' : matrix.edition := 'My Little Pony';
		'TWILIGHTSPARKLE' : matrix.edition := 'My Little Pony';
		'VINYLSCRATCH' : matrix.edition := 'My Little Pony';
	End;
End;
