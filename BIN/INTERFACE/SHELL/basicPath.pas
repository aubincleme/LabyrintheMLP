Procedure getBasicCoordinates(var x, y, z : integer; is3d : boolean; coutMessage : string);
Begin
	writeLn(coutMessage);
	write('X = ');
	readLn(x);
	write('Y = ');
	readLn(y);
	If is3d then
	Begin
		write('Z = ');
		readLn(z);
	End;
End;
