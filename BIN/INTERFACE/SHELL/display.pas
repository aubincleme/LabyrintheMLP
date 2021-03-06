Procedure displayShellMap(matrix : theMatrix; actualLevel : integer; isOldSchool : boolean);
Var i, j : integer;
Begin
	For i := 0 to 2*matrix.dimensions.x do
	Begin
		For j := 0 to 2*matrix.dimensions.y do 
		Begin
			If isOldSchool then
			Begin
				If matrix.map[i][j][actualLevel] = -1 then write('* ')
				Else if matrix.map[i][j][actualLevel] = -42 then write('. ')
				Else write('  ');
			End
			Else
			Begin
				If matrix.map[i][j][actualLevel] = -1 then TextBackground(white)
				Else if matrix.map[i][j][actualLevel] = -42 then TextBackground(green);
				If matrix.map[i][j][actualLevel-1] <> -1 then write('v')
				Else write(' ');
				If matrix.map[i][j][actualLevel+1] <> -1 then write('^')
				Else write(' ');
				TextBackground(black);
			End;
		End;
		writeLn();
	End;
End;

Procedure viewShellMap(matrix : theMatrix; isOldSchool : boolean);
Var i, j, actualLevel : integer;
	quit : boolean;
	keyPressed : char;
Begin
	actualLevel := 1;
	quit := false;
	Repeat
		clrscr();
		displayShellMap(matrix, actualLevel, isOldSchool);

		keyPressed := ReadKey();
		If keyPressed = #13 then
			quit := true
		Else 
		Begin
			keyPressed := ReadKey();
			If keyPressed = #72 then // La touche HAUT est pressée
			Begin
				If actualLevel = 1 then actualLevel := 2*matrix.dimensions.z-1
				Else actualLevel := actualLevel - 2;
			End
			Else if keyPressed = #80 then // La touche BAS est pressée
			Begin
				If actualLevel = 2*matrix.dimensions.z -1 then actualLevel := 1
				Else actualLevel := actualLevel + 2;
			End;
		End;
	Until quit = true;
End;
