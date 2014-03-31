Program Labyrinthe;

Uses glib2d, SDL, SDL_TTF, SDL_Addon, crt, dos, sysutils;

{$MODE objfpc}
{$I 'BIN/include.pas'}

Var matrix : theMatrix;
BEGIN
	Randomize;
	startup(matrix);
END.
