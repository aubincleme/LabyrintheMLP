Procedure calcParameters(var selectedItem : integer; var matrix : theMatrix; catchedNumber : integer);
Begin
	If selectedItem = 1 then
		If (matrix.dimensions.x <= 9) AND (catchedNumber <> -1) then
			matrix.dimensions.x := matrix.dimensions.x*10 + catchedNumber
		Else matrix.dimensions.x := matrix.dimensions.x div 10
	Else If selectedItem = 2 then
		If (matrix.dimensions.y <= 9) AND (catchedNumber <> -1) then
			matrix.dimensions.y := matrix.dimensions.y*10 + catchedNumber
		Else matrix.dimensions.y := matrix.dimensions.y div 10
	Else If selectedItem = 3 then
		If (matrix.dimensions.z <= 9) AND (catchedNumber <> -1) then
			matrix.dimensions.z := matrix.dimensions.z*10 + catchedNumber
		Else matrix.dimensions.z := matrix.dimensions.z div 10;
End;

Function getPersonnalizedOptions(var matrix : theMatrix) : boolean;

{$I 'BIN/const.pas'}

Var 	selectedItem, i : integer;
	settingsOk, return : boolean;
	mainTitle, menuTitle, background : gImage;
	menuItems : array[1 .. 4] of gImage;
	mainFont, titleFont, itemsFont : PTTF_Font;
	originalCursorPosition : cursorPosition;

Begin
	settingsOK := false;	// On initialise les variables de base : validité des paramètres et position du curseur
	return := false;
	originalCursorPosition.x := sdl_get_mouse_x;
	originalCursorPosition.y := sdl_get_mouse_y;
	matrix.dimensions.x := 5;	// Paramètres par défaut
	matrix.dimensions.y := 5;
	matrix.dimensions.z := 5;
	selectedItem := 0;

	background := gTexLoad('BIN/RC/' + matrix.theme + '/background.png');

	mainFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 45);	// On charge les différentes polices
	titleFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 35);
	itemsFont := TTF_OpenFont('BIN/RC/mainFont.ttf', 24);
	mainTitle := gTextLoad('Labyrinthe - ' + matrix.edition + ' Edition', mainFont);	// On définit les éléments de titre
	menuTitle := gTextLoad('--- Nouvelle Partie ---', titleFont);
	menuItems[4] := gTextLoad('Jouer !', itemsFont);	
	// Il s'agit d'un élément statique de la fenètre, pas besoin de l'actualiser à chaque boucle

	sdl_update;

	Repeat
		
		// On définit les éléments d'options du menu dynamiques
		menuItems[1] := gTextLoad('Dimension X : ' + intToStr(matrix.dimensions.x), itemsFont);
		menuItems[2] := gTextLoad('Dimension Y : ' + intToStr(matrix.dimensions.y), itemsFont);
		menuItems[3] := gTextLoad('Dimension Z : ' + intToStr(matrix.dimensions.z), itemsFont);

		gClear(GUI_GRAY);	// Fond noir

		gBeginRects(background);
          		gSetCoordMode(G_UP_LEFT);
          		gSetCoord(0, 0);
          		gAdd();
		gEnd();
		
		gBeginRects(mainTitle);					// On affiche le titre principal
          		gSetCoordMode(G_CENTER);
          		gSetCoord(G_SCR_W div 2, 1*(G_SCR_H div 12));
            		gSetColor(GUI_BLACK);
          		gAdd();
		gEnd();
			gBeginRects(menuTitle);				// On affiche le titre du menu
        		gSetCoordMode(G_CENTER);
        		gSetCoord(G_SCR_W div 2, 3*(G_SCR_H div 12));
        		gSetColor(GUI_BLACK);
        		gAdd();
        	gEnd();

		For i := 1 to 4 do
		Begin
        		gBeginRects(menuItems[i]);			// On affiche tous les éléments d'option
        	   		gSetCoordMode(G_CENTER);
        	    		gSetCoord(G_SCR_W div 2, (i+3)*(G_SCR_H div 10));
        	    		gSetColor(GUI_BLACK);
        	    		gAdd();
        		gEnd();
		End;

		For i := 1 to 4 do	// On effectue un test de présence du curseur sur une des options
		Begin
			If sdl_is_mouse_in(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (i+3)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20) then
			Begin
				// On fait un beau rectangle autour de l'item
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 15, (i+3)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 10, menuItems[i]^.w + 30, menuItems[i]^.h + 20, GUI_WHITE);
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 14, (i+3)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 9, menuItems[i]^.w + 28, menuItems[i]^.h + 18, GUI_WHITE);
				gDrawRect(G_SCR_W div 2 - (menuItems[i]^.w div 2) - 13, (i+3)*(G_SCR_H div 10) - (menuItems[i]^.h div 2) - 8, menuItems[i]^.w + 26, menuItems[i]^.h + 16, GUI_WHITE);

				If sdl_mouse_left_click 				// Si l'utilisateur a cliqué sur l'option 
				AND (originalCursorPosition.x <> sdl_get_mouse_x) 	// ET que la position du curseur est différente 
				AND (originalCursorPosition.y <> sdl_get_mouse_y) then	// de celle en début de procédure, alors ...

					If (i >= 1) AND (i <= 3) then selectedItem := i // On sélectionne l'élément cliqué

					Else if (i = 4) 
					AND (matrix.dimensions.x > 1) // On teste si les valeures entrées sont correctes
					AND (matrix.dimensions.y > 1) 
					AND (matrix.dimensions.z >= 1) then 
					settingsOk := true;	// On arrête la boucle (l'utilisateur a cliqué sur jouer)
			End;
		End;
	
		If selectedItem <> 0 then
		Begin
			gDrawRect(G_SCR_W div 2 - (menuItems[selectedItem]^.w div 2) - 15, (selectedItem+3)*(G_SCR_H div 10) - (menuItems[selectedItem]^.h div 2) - 10, menuItems[selectedItem]^.w + 30, menuItems[selectedItem]^.h + 20, GUI_WHITE);
			gDrawRect(G_SCR_W div 2 - (menuItems[selectedItem]^.w div 2) - 14, (selectedItem+3)*(G_SCR_H div 10) - (menuItems[selectedItem]^.h div 2) - 9, menuItems[selectedItem]^.w + 28, menuItems[selectedItem]^.h + 18, GUI_WHITE);
			gDrawRect(G_SCR_W div 2 - (menuItems[selectedItem]^.w div 2) - 13, (selectedItem+3)*(G_SCR_H div 10) - (menuItems[selectedItem]^.h div 2) - 8, menuItems[selectedItem]^.w + 26, menuItems[selectedItem]^.h + 16, GUI_WHITE);
		End;

		// On va tester si une touche digne d'intéret a été pressée ...
		If sdl_is_keypressed then
		Begin	// Y'A DES KEYCODES BIZZARES
			If (key_up = 27) then 					// Si ECHAP est pressée
				return := true // On quitte la boucle
			Else If (key_up = 8) then 					// Si RETOUR est pressée
				calcParameters(selectedItem, matrix , -1)

			// On teste successivement les touches du pavé numérique, mais aussi les "touches de saisie numérique"

			Else If (key_up = 257) OR (key_up = 38) then	// Touche 1
				calcParameters(selectedItem, matrix , 1)
			Else If (key_up = 258) OR (key_up = 233) then 	// Touche 2
				calcParameters(selectedItem, matrix , 2)
			Else If (key_up = 259) OR (key_up = 34) then 	// Touche 3
				calcParameters(selectedItem, matrix , 3)
			Else If (key_up = 260) OR (key_up = 39) then 	// Touche 4
				calcParameters(selectedItem, matrix , 4)
			Else If (key_up = 261) OR (key_up = 40) then 	// Touche 5
				calcParameters(selectedItem, matrix , 5)
			Else If (key_up = 262) OR (key_up = 45) then 	// Touche 6
				calcParameters(selectedItem, matrix , 6)
			Else If (key_up = 263) OR (key_up = 232) then 	// Touche 7
				calcParameters(selectedItem, matrix , 7)
			Else If (key_up = 264) OR (key_up = 95) then 	// Touche 8
				calcParameters(selectedItem, matrix , 8)
			Else If (key_up = 265) OR (key_up = 231) then 	// Touche 9
				calcParameters(selectedItem, matrix , 9)
			Else If (key_up = 256) OR (key_up = 224) then 	// Touche 0
				calcParameters(selectedItem, matrix , 0);
		End;

		gFlip();

		sdl_update;

	Until (settingsOk = true) OR (return = true);

	getPersonnalizedOptions := return;
End;

Procedure newGUIGame(var matrix : theMatrix);
Begin
	If getPersonnalizedOptions(matrix) = false then
	Begin
		initMatrix(matrix);
		generateMap(matrix);
		matrix.points.beginPoint.x := 1;
		matrix.points.beginPoint.y := 1;
		matrix.points.beginPoint.z := 1;
		matrix.points.endPoint.x := 2*matrix.dimensions.x-1;
		matrix.points.endPoint.y := 2*matrix.dimensions.y-1;
		matrix.points.endPoint.z := 2*matrix.dimensions.z-1;
		game(matrix);
	End;
End;
