Function mainMenuGUI(theme, edition : string) : integer;

{$I 'BIN/const.pas'}

Var 	choice, i : integer;
	choiceOk : boolean;
	mainTitle, menuTitle, background : gImage;
	menuItems : array [1 .. 3] of gImage;
	mainFont, menuTitleFont, menuItemsFont{, menuSelectedItemFont }: PTTF_Font;
	originalCursorPosition : cursorPosition;
Begin
	choiceOK := false;	// On initialise les variables de base : choix et position du curseur
	choice := 0;
	originalCursorPosition.x := sdl_get_mouse_x;
	originalCursorPosition.y := sdl_get_mouse_y;

	background := gTexLoad('BIN/RC/' + theme + '/background.png');

	// CHARGMENT DES DIFFERENTES POLICES
	mainFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 40);
	menuTitleFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 35);
	menuItemsFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 30);
	//menuSelectedItemFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 20);

	mainTitle := gTextLoad('Labyrinthe - ' + edition + ' Edition', mainFont);	// On définit les éléments de titre
	menuTitle := gTextLoad('--- MENU PRINCIPAL ---', menuTitleFont);

	menuItems[1] := gTextLoad('Jouer !', menuItemsFont);
	menuItems[2] := gTextLoad('Choix du theme', menuItemsFont);
	menuItems[3] := gTextLoad('Quitter', menuItemsFont);

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

		For i := 1 to 3 do
		Begin
        		gBeginRects(menuItems[i]);	// On affiche tous les éléments d'option
        	   		gSetCoordMode(G_CENTER);
        	    		gSetCoord(G_SCR_W div 2, (i+4)*(G_SCR_H div 10));
        	    		gSetColor(GUI_BLACK);
        	    		gAdd();
        		gEnd();
		End;

		For i := 1 to 3 do	// On effectue un test de présence du curseur sur une des options
		Begin
			If sdl_is_mouse_in(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (i+4)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20) then
			Begin
				choice := i;
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (i+4)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20, GUI_WHITE);
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 14, (i+4)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 9, menuItems[i]^.w + 28, menuItems[i]^.h + 18, GUI_WHITE);
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 13, (i+4)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 8, menuItems[i]^.w + 26, menuItems[i]^.h + 16, GUI_WHITE);
				If sdl_mouse_left_click AND (originalCursorPosition.x <> sdl_get_mouse_x) AND (originalCursorPosition.y <> sdl_get_mouse_y) then	// Si l'utilisateur a cliqué sur l'option ET que la position du curseur est différente de celle en début de boucle, alors ...
				Begin
					choiceOk := true;	// On arrête la boucle
					choice := i;	// On renvoie le choix (entre 1 et le nombre de cases du tableau)
				End;
			End;
		End;

		If sdl_is_keypressed then 
		Begin
			If sdl_get_keypressed = 27 then 	// Si ECHAP est pressée
			Begin
				choice := 0;
				choiceOk := true;
			End;
		End;

		gFlip();

		sdl_update;

	Until choiceOk = true;

	mainMenuGUI := choice;
End;
