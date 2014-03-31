Function scanActions(var matrix : theMatrix; playerChoice : action; var win : boolean) : boolean;
Begin
	Case playerChoice of
		up : If (matrix.map[matrix.player.x][matrix.player.y-1][matrix.player.z] <> -1) then matrix.player.y := matrix.player.y-1;
		down : If (matrix.map[matrix.player.x][matrix.player.y+1][matrix.player.z] <> -1) then matrix.player.y := matrix.player.y+1;
		left : If (matrix.map[matrix.player.x-1][matrix.player.y][matrix.player.z] <> -1) then matrix.player.x := matrix.player.x-1;
		right : If (matrix.map[matrix.player.x+1][matrix.player.y][matrix.player.z] <> -1) then matrix.player.x := matrix.player.x+1;
		lvDown : If (matrix.map[matrix.player.x][matrix.player.y][matrix.player.z-1] <> -1) then matrix.player.z := matrix.player.z-2;
		lvUp : If (matrix.map[matrix.player.x][matrix.player.y][matrix.player.z+1] <> -1) then matrix.player.z := matrix.player.z+2;
		help : generateSolution(matrix, true);
		exit : win := false;
	End;
	
	If (matrix.player.x = matrix.points.endPoint.x) AND (matrix.player.y = matrix.points.endPoint.y) AND (matrix.player.z = matrix.points.endPoint.z) then begin scanActions := true; win := true; end
	Else scanActions := false;
End;

Procedure game(var matrix : theMatrix);
Var endOfGame, win : boolean;
Begin

	gClose();
	gInit('Labyrinthe - My Little Poney Edition', (2*matrix.dimensions.x+1) * 32, (2*matrix.dimensions.y+1) * 32 {+ 64});
	matrix.player.x := matrix.points.beginPoint.x;
	matrix.player.y := matrix.points.beginPoint.y;
	matrix.player.z := matrix.points.beginPoint.z;
	matrix.player.orientation := down;
	endOfGame := false;
	win := false;

	Repeat
		endOfGame := scanActions(matrix, getPlayerGUIChoice(matrix), win);
	Until endOfGame = true;
	gClose();
	gInit('Labyrinthe - ' + matrix.edition + ' Edition', 800, 800);
	displayEndOfGame(matrix.theme, matrix.edition, win);
End;
