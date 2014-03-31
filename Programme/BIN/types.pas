{ 	***** FILE : TYPES.PAS *****
	Objective : store all possible program types }

Type 	singleWallInfo = record
		x : integer;
		y : integer;
		z : integer;
	End;

	pointsInfos = record
		x : integer;
		y : integer;
		z : integer;
	End;
	
	bigPointsInfos = record
		beginPoint : pointsInfos;
		endPoint : pointsInfos;
	End;

	//orientationInfo = (left, right, up, down);
	action = (up, down, left, right, lvUp, lvDown, help, exit);

	globalVarsInfos = record
		isGUI : boolean;
		forceMenu : boolean;
		is3D : boolean;
		isSpecified : boolean;
		xDim : integer;
		yDim : integer;
		zDim : integer;
		theme : string;
	End;

	playerPosInfo = record
		x : integer;
		y : integer;
		z : integer;
		orientation : action;
	End;

	theMatrix = Record
		map : array of array of array of longint;
		wallsList : array of singleWallInfo;
		player : playerPosInfo;
		globalVars : globalVarsInfos;
		points : bigPointsInfos;
		dimensions : pointsInfos;
		theme : string;
		edition : string;
		n : integer;
	End;

	ressources = record
		font : PTTF_Font;
		wall, upstairs, downstairs, upAndDownStairs, path, grass, point : gImage;
		ponyFront, ponyLeft, ponyBack, ponyRight : gImage;
	End;
		
	cursorPosition = record
		x : Uint16;
		y : Uint16;
	End;

	adjacentValuesArray = array [1 .. 6] of integer;
