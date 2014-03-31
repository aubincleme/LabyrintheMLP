Procedure createShellLab(var matrix : theMatrix; is3D, isOldSchool : boolean);
Var coordOk : boolean;
	x1, x2, y1, y2, z1, z2 : integer;
Begin
	If is3D = false then matrix.dimensions.z := 1;
	coordOk := false;
	While coordOk = false do
	Begin
		getBasicCoordinates(matrix.dimensions.x, matrix.dimensions.y, matrix.dimensions.z, is3D, 'Entrez la taille du labyrinthe : ');
		If (matrix.dimensions.x <= 1) OR (matrix.dimensions.y <= 1) OR (matrix.dimensions.z < 1) then
			writeLn('ERREUR ! Réessayez !')
		Else
			coordOk := true;
	End;
	initMatrix(matrix);
	generateMap(matrix);
	viewShellMap(matrix, isOldSchool);

	coordOk := false;
	While coordOk = false do
	Begin
		getBasicCoordinates(x1, y1, z1, is3D, 'Entrez les coordonnées du point de départ : ');
		If ((x1 <> 1) AND (x1 <> matrix.dimensions.x)) AND ((y1 <> 1) AND (y1 <> matrix.dimensions.y)) then
			writeLn('ERREUR ! Réessayez !')
		Else
			coordOk := true;
	End;
	coordOk := false;
	While coordOk = false do
	Begin
		getBasicCoordinates(x2, y2, z2, is3D, 'Entrez les coordonnées du point d''arrivée : ');
		If (((x1 <> 1) AND (x1 <> matrix.dimensions.x)) AND ((y1 <> 1) AND (y1 <> matrix.dimensions.y))) OR (x1 = x2) OR (y1 = y2) then
			writeLn('ERREUR ! Réessayez !')
		Else
			coordOk := true;
	End;

	matrix.points.beginPoint.x := 2*x1-1;
	matrix.points.beginPoint.y := 2*y1-1;
	matrix.points.endPoint.x := 2*x2-1;
	matrix.points.endPoint.y := 2*y2-1;
	
	If is3D then
	Begin
		matrix.points.beginPoint.z := 2*z1-1;
		matrix.points.endPoint.z := 2*z2-1;
		generateSolution(matrix, false);
	End
	Else 
	Begin
		matrix.points.beginPoint.z := 1;
		matrix.points.endPoint.z := 1;
		generateSolution(matrix, false);
	End;

	viewShellMap(matrix, isOldSchool);
	If isOldSchool then halt();
End;
