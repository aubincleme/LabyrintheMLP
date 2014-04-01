Function specialMin(a, b : integer) : integer;
Begin
	If a = -1 then 
		If b = -1 then specialMin := -1 else specialMin := b
	Else
		If b = -1 then specialMin := a
		Else if b <= a then specialMin := b
		Else if a < b then specialMin := a;
End;

Procedure sortAdjValues(Var tab : adjacentValuesArray);
Var j, temp : Integer;
	endSort : boolean;
Begin
	endSort := true;
	While endSort do
	Begin
		endSort := false;
		For j:=2 to 6 Do
		Begin
			If tab[j-1] > tab[j] Then
			Begin
				endSort := true;
				temp := tab[j];
				tab[j] := tab[j-1];
				tab[j-1] := temp;
			End;
		End;
	End;
End;

Procedure exchangeWallsInfos(var matrix : theMatrix; posA, posB : integer);
Var temp : singleWallInfo;
Begin
	temp := matrix.wallsList[posA];
	matrix.wallsList[posA] := matrix.wallsList[posB];
	matrix.wallsList[posB] := temp;
End;

Procedure getAdjacentValues(matrix : theMatrix; var adjacentValues : adjacentValuesArray; x, y, z : integer);
Begin
	adjacentValues[1] := matrix.map[x+1][y][z];
	adjacentValues[2] := matrix.map[x-1][y][z];
	adjacentValues[3] := matrix.map[x][y+1][z];
	adjacentValues[4] := matrix.map[x][y-1][z];
	adjacentValues[5] := matrix.map[x][y][z+1];
	adjacentValues[6] := matrix.map[x][y][z-1];
	sortAdjValues(adjacentValues);
End;
