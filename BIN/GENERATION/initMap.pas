Procedure initMatrix(var matrix : theMatrix);
Var m, n, i, j, k : integer;
Begin
	setLength(matrix.map, 2*matrix.dimensions.x+1, 2*matrix.dimensions.y+1, 2*matrix.dimensions.z+1);
	n := -1;
	m := 0;
	For k := 0 to 2*matrix.dimensions.z do
	Begin
		If (k = 0) OR (k = 2*matrix.dimensions.z) then
		Begin
			For i := 0 to 2*matrix.dimensions.x do
			Begin
				For j := 0 to 2*matrix.dimensions.y do
					matrix.map[i][j][k] := -1;
			End;
		End
		Else
		Begin
			For i := 0 to 2*matrix.dimensions.x do
			Begin
				matrix.map[i][0][k] := -1;
				matrix.map[i][2*matrix.dimensions.y][k] := -1;
				For j := 1 to 2*matrix.dimensions.y-1 do
				Begin
					If (i = 0) OR (i = 2*matrix.dimensions.x) then
						matrix.map[i][j][k] := -1
					Else
					Begin
						If (i mod 2 = 1) AND (j mod 2 = 1) AND (k mod 2 = 1) then
						Begin
							matrix.map[i][j][k] := n + 1;
							n := n +1;
						End
						Else
						Begin
							matrix.map[i][j][k] := -1;
							If ((k mod 2 = 1) AND ((i mod 2 = 1) OR (j mod 2 = 1))) OR ((k mod 2 = 0) AND (i mod 2 = 1) AND (j mod 2 = 1)) then
							Begin
								m := m+1;
								setLength(matrix.wallsList, m);
								matrix.wallsList[m-1].x := i;
								matrix.wallsList[m-1].y := j;
								matrix.wallsList[m-1].z := k;
							End;
						End;
					End;
				End;
			End;
		End;
	End;
	setLength(matrix.wallsList, m-1);
End;
