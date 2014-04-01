// Procédure harmonizeValues :
// Harmoniser la valeur de la case ciblée à la valeur minimale des cases adjacentes
Procedure harmonizeValues(var matrix : theMatrix; x, y, z : integer);
Var minAdjValue : integer;
Begin
		If matrix.map[x][y][z] <> -1 then
		Begin
			minAdjValue := specialMin(specialMin(matrix.map[x][y-1][z], matrix.map[x][y+1][z]), specialMin(specialMin(matrix.map[x-1][y][z], matrix.map[x+1][y][z]), specialMin(matrix.map[x][y][z+1], matrix.map[x][y][z-1])));
			If minAdjValue < matrix.map[x][y][z] then
			Begin
				matrix.map[x][y][z] := minAdjValue;
				harmonizeValues(matrix, x+1, y, z);
				harmonizeValues(matrix, x-1, y, z);
				harmonizeValues(matrix, x, y+1, z);
				harmonizeValues(matrix, x, y-1, z);
				harmonizeValues(matrix, x, y, z-1);
				harmonizeValues(matrix, x, y, z+1);
			End;
		End;
End;

// Procédure : generateNewPath
// Casser un nouveau mur sélectionné aléatoirement, puis harmoniser les valeurs des cases adjacentes
Procedure generateNewPath(var matrix : theMatrix);
Var randValue, i : integer;
	adjacentValues : adjacentValuesArray;
Begin
	For i := 1 to 6 do adjacentValues[i] := -42; // On initialise à une valeur très très petite
	randValue := random(length(matrix.wallsList)); // Entre 0 et la valeur max de matrix.wallList
	getAdjacentValues(matrix, adjacentValues, matrix.wallsList[randValue].x, matrix.wallsList[randValue].y, matrix.wallsList[randValue].z);
	If (adjacentValues[5] <> adjacentValues[6]) then
	Begin
		matrix.map[matrix.wallsList[randValue].x][matrix.wallsList[randValue].y][matrix.wallsList[randValue].z] := specialMin(specialMin(adjacentValues[1], adjacentValues[2]), specialMin(specialMin(adjacentValues[3], adjacentValues[4]), specialMin(adjacentValues[5], adjacentValues[6])));
		harmonizeValues(matrix, matrix.wallsList[randValue].x+1, matrix.wallsList[randValue].y, matrix.wallsList[randValue].z);
		harmonizeValues(matrix, matrix.wallsList[randValue].x-1, matrix.wallsList[randValue].y, matrix.wallsList[randValue].z);
		harmonizeValues(matrix, matrix.wallsList[randValue].x, matrix.wallsList[randValue].y+1, matrix.wallsList[randValue].z);
		harmonizeValues(matrix, matrix.wallsList[randValue].x, matrix.wallsList[randValue].y-1, matrix.wallsList[randValue].z);
		harmonizeValues(matrix, matrix.wallsList[randValue].x, matrix.wallsList[randValue].y, matrix.wallsList[randValue].z+1);
		harmonizeValues(matrix, matrix.wallsList[randValue].x, matrix.wallsList[randValue].y, matrix.wallsList[randValue].z-1);
	End;
	exchangeWallsInfos(matrix, randValue, length(matrix.wallsList)-1);
	setLength(matrix.wallsList, length(matrix.wallsList)-1);
End;

// Procédure : littlePath
// Attribuer une valeur à la case ciblée, valeur qui changera en fonction de la distance entre la case et le point de départ
Procedure littlePath(var matrix : theMatrix; x, y, z, n : integer);
Begin
	If ((matrix.map[x][y][z] > n) OR (matrix.map[x][y][z] = 0)) then
	Begin
		matrix.map[x][y][z] := n;
		n := n+1;
		If (matrix.map[x-1][y][z] <> -1) AND (matrix.map[x-1][y][z] <> n-1) then littlePath(matrix, x-1, y, z, n);
		If (matrix.map[x+1][y][z] <> -1) AND (matrix.map[x+1][y][z] <> n-1) then littlePath(matrix, x+1, y, z, n);
		If (matrix.map[x][y-1][z] <> -1) AND (matrix.map[x][y-1][z] <> n-1) then littlePath(matrix, x, y-1, z, n);
		If (matrix.map[x][y+1][z] <> -1) AND (matrix.map[x][y+1][z] <> n-1) then littlePath(matrix, x, y+1, z, n);
		If (matrix.map[x][y][z+1] <> -1) AND (matrix.map[x][y][z+1] <> n-1) then littlePath(matrix, x, y, z+1, n);
		If (matrix.map[x][y][z-1] <> -1) AND (matrix.map[x][y][z-1] <> n-1) then littlePath(matrix, x, y, z-1, n);
	End;
End;

// Procédure : reversePath
// A partir des valeurs précédemment distribuées, retrouver le chemin initial
Procedure reversePath(var matrix : theMatrix; x, y, z : integer);
Var n : integer;
Begin
	n := matrix.map[x][y][z];
	matrix.map[x][y][z] := -42;
	If (matrix.map[x+1][y][z] = n-1) then
		reversePath(matrix, x+1, y, z)
	Else If (matrix.map[x-1][y][z] = n-1) then
		reversePath(matrix, x-1, y, z)
	Else If (matrix.map[x][y+1][z] = n-1) then
		reversePath(matrix, x, y+1, z)
	Else If (matrix.map[x][y-1][z] = n-1) then
		reversePath(matrix, x, y-1, z)
	Else If (matrix.map[x][y][z+1] = n-1) then
		reversePath(matrix, x, y, z+1)
	Else If (matrix.map[x][y][z-1] = n-1) then
		reversePath(matrix, x, y, z-1);
End;

// Procédure : genreateSolution
// Gestion de la génération de la solution
Procedure generateSolution(var matrix : theMatrix; isFromPlayer : boolean);
Begin
	matrix.n := 1;
	//writeLn('SolGen1');
	If isFromPlayer then littlePath(matrix, matrix.player.x, matrix.player.y, matrix.player.z, 2)
	ELse littlePath(matrix, matrix.points.beginPoint.x, matrix.points.beginPoint.y, matrix.points.beginPoint.z, 2);
	//writeLn('SolGen2');
	reversePath(matrix, matrix.points.endPoint.x, matrix.points.endPoint.y, matrix.points.endPoint.z);
End;

// Procédure : generateMap
// Gestion de la génération de la map
Procedure generateMap(var matrix : theMatrix);
Var isGenerationOk : boolean; i, j, k : integer;
Begin
	isGenerationOk := false;
	While isGenerationOk = false do
	Begin
		isGenerationOk := true; // On suppose que la génération est bonne
		For k := 1 to 2*matrix.dimensions.z-1 do
		Begin
			For i := 1 to 2*matrix.dimensions.x-1 do
			Begin
				For j := 1 to 2*matrix.dimensions.y-1 do
					If (matrix.map[i][j][k] <> -1) AND (matrix.map[i][j][k] <> 0) then isGenerationOk := false;
			End;
		End;
		If isGenerationOk = false then generateNewPath(matrix);
	End;
End;
