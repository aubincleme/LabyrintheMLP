Function getPlayerGUIChoice(Var matrix : theMatrix) : action;
Var	rc : ressources;
	choiceOk : boolean;
Begin

	choiceOk := false;
	rc.font := TTF_OpenFont('BIN/RC/mainFont.ttf', 25);
	rc.wall := gTexLoad('BIN/RC/wall32.png');
	rc.path := gTexLoad('BIN/RC/path32.png');
	rc.ponyLeft := gTexLoad('BIN/RC/' + matrix.theme + '/left.png');
	rc.ponyRight := gTexLoad('BIN/RC/' + matrix.theme + '/right.png');
	rc.ponyFront := gTexLoad('BIN/RC/' + matrix.theme + '/front.png');
	rc.ponyBack := gTexLoad('BIN/RC/' + matrix.theme + '/back.png');
	rc.upstairs := gTexLoad('BIN/RC/upstairs32.png');
	rc.point := gTexLoad('BIN/RC/point32.png');
	rc.downstairs := gTexLoad('BIN/RC/downstairs32.png');
	rc.upAndDownStairs := gTexLoad('BIN/RC/upAndDownStairs32.png');
	rc.grass := gTexLoad('BIN/RC/grass.png');

	Repeat
		displayGUIMap(matrix, rc);	// Affichage de la MAP

		If sdl_is_keypressed then
		Begin	// Y'A DES KEYCODES BIZZARES
			If (key_up = 273) then 
			Begin
				getPlayerGUIChoice := up;
				matrix.player.orientation := up;
				choiceOk := true;
			End
			Else if (key_up = 274) then
			Begin
				getPlayerGUIChoice := down;
				matrix.player.orientation := down;
				choiceOk := true;
			End
			Else if (key_up = 276) then
			Begin
				getPlayerGUIChoice := left;
				matrix.player.orientation := left;
				choiceOk := true;
			End
			Else if (key_up = 275) then 
			Begin
				getPlayerGUIChoice := right;
				matrix.player.orientation := right;
				choiceOk := true;
			End
			Else if (key_up = 280) then
			Begin
				getPlayerGUIChoice := lvUp;
				choiceOk := true;
			End
			Else if (key_up = 281) then
			Begin
				getPlayerGUIChoice := lvDown;
				choiceOk := true;
			End
			Else if (key_up = 104) then
			Begin
				getPlayerGUIChoice := help;
				choiceOk := true;
			End
			ELse if (sdl_get_keypressed = 27) then ////////////////////////////// A MODIFIER
			Begin
				getPlayerGUIChoice := exit;
				choiceOk := true;
			End;
		End;

		gFlip();
		sdl_update;
	Until choiceOk = true;
End;
