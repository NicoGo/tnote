                SEUIL EQU 3
                INA EQU 0xFF00    // Il faut modifier FFA0 dans l’IHM pour modifier la valeur d’input
                OUTA EQU 0xFFA2
                RESET_ADDRESS EQU 0xFFE4
                LOADA EQU 0xFF10  // Début du programme, si overflow il faut la remontée
                SP EQU R15        // Nouvelle adresse pour la stack
                STACKA EQU 0x1000 // Nouveau contenu à l’adresse du début de la stack

                ORG LOADA
                START LOADA

                LDW SP, #STACKA
DEBUT           LDW R2,@INA     // On load IN (x) dans R2
                LDW R1,#SEUIL   // On load le seuil de ?? dans R1
                STW R1, -(SP)   // PUSH R1
                JSR @DISTA
                // ⇒ On vient de faire une division par 2 de R0, que l’on stock dans R0
                STW R0,@OUTA    // Puis on stocke le résultat dans OUTA
                JMP #DEBUT-$-2  // On recommence la boucle

DISTA           SUB R2,R1,R0    // On soustrait R1 à R0. R0 = R1-R0
                JGE #POSIT-$-2  // Si le résultat de la soustraction est < 0, Sinon on passe directement au SR (division)
                NEG R0,R0       //    On fait le complément de R0 dans R0 (car on veut la val absolue), Puis on passe à la division
POSIT           SRA R0,R0       // On fait un SR arithmétique
                LDW R1,(SP)+    // POP R1
                RTS
