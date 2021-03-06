Function mainShellMenu() : integer;
Var choice, i, actualOption : integer;
	keyPressed : char;
	option : array [0 .. 3] of string;
Begin
	option[0] := 'Génération basique, toute pourrie et en 2D';
	option[1] := 'Génération en 2D, mais avec des effets stylés';
	option[2] := 'Génération en 3D, avec les mêmes effets stylés';
	option[3] := 'Quitter';

	choice := 42;
	actualOption := 0;
	TextColor(white);
	Repeat
			clrscr; // Pour une présentation plus soignée :) !
			WriteLn('***** Labyrinthe - PONYLAND Edition *****');
			writeln('');
			writeln(' ----- MENU PRINCIPAL ----- ');
			
			For i := 0 to 3 do // On affiche ligne par ligne les différentes options du menu
			Begin
				If actualOption = i then
				Begin
					TextBackground(White);
					TextColor(Black);
					writeln('--> ' + option[i]);
					TextBackground(Black);
					TextColor(White);
				End
				Else
					writeln('    ' + option[i]);
			End;
			
			keyPressed := ReadKey;
			If keyPressed = #13 then // La touche ENTREE est pressée
				choice := actualOption + 1
			Else if keyPressed = #0 then // Caractère étendu
			Begin
				keyPressed := ReadKey; // Obligatoire pour obtenir les codes des touches HAUT et BAS
				If keyPressed = #72 then // La touche HAUT est pressée
				Begin
					If actualOption = 0 then actualOption := 3 // Si on est au début de la liste de choix
					Else actualOption := actualOption - 1;
				End
				Else if keyPressed = #80 then // La touche BAS est pressée
				Begin
					If actualOption = 3 then actualOption := 0
					Else actualOption := actualOption + 1;
				End
			End
			
	Until (choice >= 1) AND (choice <= length(option));
	clrscr();
	mainShellMenu := choice;
END;
