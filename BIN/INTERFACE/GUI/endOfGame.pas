Procedure displayEndOfGame(theme, edition : string; win : boolean);

{$I 'BIN/const.pas'}

Var 	choice, i : integer;
	choiceOk : boolean;
	mainTitle, menuTitle, background, validate : gImage;
	mainFont, menuTitleFont, menuItemsFont : PTTF_Font;
	originalCursorPosition : cursorPosition;
Begin
	choiceOK := false;	// On initialise les variables de base : choix et position du curseur
	originalCursorPosition.x := sdl_get_mouse_x;
	originalCursorPosition.y := sdl_get_mouse_y;

	background := gTexLoad('BIN/RC/' + theme + '/background.png');

	// CHARGMENT DES DIFFERENTES POLICES
	mainFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 40);
	menuTitleFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 35);
	menuItemsFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 30);
	//menuSelectedItemFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 20);

	mainTitle := gTextLoad('Labyrinthe - ' + edition + ' Edition', mainFont);	// On définit les éléments de titre
	If win then menuTitle := gTextLoad('Vous avez gagne, bravo !', menuTitleFont)
	Else menuTitle := gTextLoad('Vous avez perdu !', menuTitleFont);

	validate := gTextLoad('Teminer', menuItemsFont);

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

		
        	gBeginRects(validate);	// On affiche tous les éléments d'option
        	   	gSetCoordMode(G_CENTER);
        	    	gSetCoord(G_SCR_W div 2, (6)*(G_SCR_H div 10));
        	    	gSetColor(GUI_BLACK);
        	    	gAdd();
        	gEnd();

		If sdl_is_mouse_in(G_SCR_W div 2 - (validate^.w div 2) - 15, (6)*(G_SCR_H div 10) - (validate^.h div 2) - 10, validate^.w + 30, validate^.h + 20) then
		Begin
			gDrawRect(G_SCR_W div 2 - (validate^.w div 2) - 15, (6)*(G_SCR_H div 10) - (validate^.h div 2) - 10, validate^.w + 30, validate^.h + 20, GUI_WHITE);
			gDrawRect(G_SCR_W div 2 - (validate^.w div 2) - 14, (6)*(G_SCR_H div 10) - (validate^.h div 2) - 9, validate^.w + 28, validate^.h + 18, GUI_WHITE);
			gDrawRect(G_SCR_W div 2 - (validate^.w div 2) - 13, (6)*(G_SCR_H div 10) - (validate^.h div 2) - 8, validate^.w + 26, validate^.h + 16, GUI_WHITE);
			If sdl_mouse_left_click AND (originalCursorPosition.x <> sdl_get_mouse_x) AND (originalCursorPosition.y <> sdl_get_mouse_y) then	// Si l'utilisateur a cliqué sur l'option ET que la position du curseur est différente de celle en début de boucle, alors ...
				choiceOk := true;	// On arrête la boucle
		End;

		If sdl_is_keypressed AND (sdl_get_keypressed = 27) then 
				choiceOk := true;

		gFlip();

		sdl_update;

	Until choiceOk = true;
End;
