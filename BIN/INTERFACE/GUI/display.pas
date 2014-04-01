Procedure displayGUIMap(matrix : theMatrix; rc : ressources);
Var i, j, k, actualLevel : integer;
{$I 'BIN/const.pas'}
Begin
	actualLevel := matrix.player.z;
	gClear(GUI_BLACK);
	For i := 0 to 2*matrix.dimensions.x do
	Begin
		For j := 0 to 2*matrix.dimensions.y do 
		Begin
			gDraw(i*32, j*32, rc.grass);
			If matrix.map[i][j][actualLevel] = -1 then gDraw(i*32, j*32, rc.wall)
			Else
			Begin
				If (matrix.map[i][j][actualLevel-1] = -1) AND (matrix.map[i][j][actualLevel+1] <> -1) then gDraw(i*32, j*32, rc.upstairs)
				Else if (matrix.map[i][j][actualLevel-1] <> -1) AND (matrix.map[i][j][actualLevel+1] = -1) then gDraw(i*32, j*32, rc.downstairs)
				Else if (matrix.map[i][j][actualLevel-1] <> -1) AND (matrix.map[i][j][actualLevel+1] <> -1) then gDraw(i*32, j*32, rc.upAndDownStairs)
				Else if matrix.map[i][j][actualLevel] = -42 then gDraw(i*32, j*32, rc.path);
			End;
			If ((matrix.points.beginPoint.x = i) AND (matrix.points.beginPoint.y = j) AND (matrix.points.beginPoint.z = actualLevel)) OR ((matrix.points.endPoint.x = i) AND (matrix.points.endPoint.y = j) AND (matrix.points.endPoint.z = actualLevel)) then gDraw(i*32, j*32, rc.point);
		End;
	End;

	Case matrix.player.orientation of
		up : gDraw(matrix.player.x*32, matrix.player.y*32, rc.ponyBack);
		down : gDraw(matrix.player.x*32, matrix.player.y*32, rc.ponyFront);
		left : gDraw(matrix.player.x*32, matrix.player.y*32, rc.ponyLeft);
		right : gDraw(matrix.player.x*32, matrix.player.y*32, rc.ponyRight);
	End;
End;
