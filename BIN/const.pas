// Quelques constantes copiées depuis les fichiers d'addon SDL
Const
    G_VOID          = 0;

    (* Colors *)
    GUI_RED             : gColor = (r : 255; g : 0;   b : 0;   a : 255);
    GUI_YELLOW          : gColor = (r : 255; g : 255; b : 0;   a : 255);
    GUI_GRAY            : gColor = (r : 128; g : 128; b : 128; a : 255);

    GUI_WHITE           : gColor = (r : 255; g : 255; b : 255; a : 255);
    GUI_BLACK           : gColor = (r : 0;   g : 0;   b : 0;   a : 255);
    GUI_AZURE           : gColor = (r : 0;   g : 128; b : 255; a : 255);
    
    (* Coordinates modes *)
    G_UP_LEFT       = 0;
    G_UP_RIGHT      = 1;
    G_DOWN_RIGHT    = 2;
    G_DOWN_LEFT     = 3;
    G_CENTER        = 4;
    
    (* Enable line strip, in gBeginLines(G_STRIP); *)
    G_STRIP         = 1;
    
    PI              = 3.141592653589;
