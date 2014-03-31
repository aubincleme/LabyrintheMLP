Procedure shellStartup(var matrix : theMatrix);
Begin
	If matrix.globalVars.forceMenu then
	Begin
		Case mainShellMenu of
			1 : createShellLab(matrix, false, true);
			2 : createShellLab(matrix, false, false);
			3 : createShellLab(matrix, true, false);
		End;
	End
	Else createShellLab(matrix, false, true);
End;

Procedure GUIStartup(var matrix : theMatrix);
Var quit : boolean;
Begin
	gInit('Labyrinthe - ' + matrix.edition + ' Edition', 800, 800);
	Repeat
		Case mainMenuGUI(matrix.theme, matrix.edition) of 
			1 : newGUIGame(matrix);
			2 : themeOptions(matrix);
			3 : quit := true;
		End;
	Until quit = true;
End;

Procedure startup(var matrix : theMatrix);
Var i : integer;
	ok : boolean;
Begin
	matrix.globalVars.isGUI := false;
	matrix.globalVars.forceMenu := false;
	matrix.globalVars.is3d := false;
	matrix.globalVars.isSpecified := false;
	matrix.globalVars.xDim := 0;
	matrix.globalVars.yDim := 0;
	matrix.globalVars.zDim := 0;
	matrix.theme := 'DEFAULT';
	matrix.edition := 'My Little Pony';

	If (ParamCount = 0) then
		shellStartup(matrix)
	Else
	Begin
		For i := 1 to ParamCount do
		Begin
			Case ParamStr(i) of
				'-c' : matrix.globalVars.isGUI := false;
				'--shell' : matrix.globalVars.isGUI := false;
				'--pauStyle' : matrix.globalVars.isGUI := false;
				'-gui' : matrix.globalVars.isGUI := true;
				'-cergyStyle' : matrix.globalVars.isGUI := true;
				'--graphic' : matrix.globalVars.isGUI := true;
				'--menu' : matrix.globalVars.forceMenu := true;
				'-3D' : matrix.globalVars.is3D := true;
				'--avengers' : matrix.theme := 'AVENGERS';
				'-x' : Begin
						ok := false;
						//Try
							matrix.globalVars.xDim := StrToInt(ParamStr(i+1));
						{Except
							On E : EConvertError do
								Writeln ('ERREUR : Avenant au paramètre -x incorrect ! Paramètre ignoré !');
						End;}
					End;
				'-y' : Begin
					ok := false;
						//Try
							matrix.globalVars.yDim := StrToInt(ParamStr(i+1));
						{Except
							On E : EConvertError do
								Writeln ('ERREUR : Avenant au paramètre -y incorrect ! Paramètre ignoré !');
						End;}
					End;
				'-z' : Begin
					ok := false;
						//Try
							matrix.globalVars.zDim := StrToInt(ParamStr(i+1));
						{Except
							On E : EConvertError do
								Writeln ('ERREUR : Avenant au paramètre -z incorrect ! Paramètre ignoré !');
						End;}
					End;
			End;
		End;
		
		If ((matrix.globalVars.xDim <> 0) AND (matrix.globalVars.yDim <> 0) AND (matrix.globalVars.zDim <> 0) AND (matrix.globalVars.is3D = true)) 
		OR ((matrix.globalVars.xDim <> 0) AND (matrix.globalVars.yDim <> 0) AND (matrix.globalVars.is3D = false)) then
			matrix.globalVars.isSpecified := true;
	End;

	If matrix.globalVars.isGUI then GUIStartup(matrix)
	Else shellStartup(matrix);
End;
