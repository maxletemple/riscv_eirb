Le programme peut être compilé en utilisant le makefile fourni en tapant en ligne de commande make. 


Le programme prend en argument le nom d’un fichier texte  et peut être exécutant en tapant en ligne de commande : . /riscV nom_du_fichier.txt. 


Le fichier texte prix en argument doit être écrit suivant une structure spécifique explicitée ci-dessous : 

Les instructions reg-reg:  NOM DE L'INSTRUCTION  R OUI ou NON  

Les instructions reg-imm:  NOM DE L'INSTRUCTION  I OUI ou NON  

Les instructions LB,LH,LW,LBU et LHU:  NOM DE L'INSTRUCTION  L OUI ou NON  

Les instructions de type S:  NOM DE L'INSTRUCTION  S OUI ou NON  

Les instructions de branchement :  NOM DE L'INSTRUCTION  B OUI ou NON 

L'instruction JAL:   JAL  J OUI ou NON  

Les instructions JALR,LUI et AUIPC:  NOM DE L'INSTRUCTION  NOM DE L'INSTRUCTION OUI ou NON  

La ligne suivante doit être écrite autant de fois que d’instructions ajoutées : NEW  NEW OUI 

Le champ OUI ou NON correspond à l’autorisation de l’utilisateur au programme pour implémenter ou non l’instruction correspondante. 


Afin de faciliter l’utilisation du programme, un fichier type riscV.txt a été fourni. 


La suppression d’instruction se fait sans aucun problème. Cependant  il faut implémenter au moins :  

Une instruction de type R  

Une instruction de type B  

Une instruction de type S  

Une instruction de type I   

Une des instructions LB, LH, LW, LBU et LHU 

L’instruction JAL 



L’ajout des instructions est plus délicat et nécessite plusieurs précautions :  
Chaque instruction ajoutée correspond à un nouvel état.
Il ne faut pas utiliser une adresse d’un état initial  même si cet état n’est pas implémenté. 
Il ne faut pas utiliser un opcode d’une instruction de base du risc V même si cette instruction n’est pas implémentée. 


Pour générer l’ALU, le programme demande à l’utilisateur de taper les lignes correspondantes au fonctionnement de l’ALU.
A la fin de l’opération, l’utilisateur doit taper le mot FIN. 
Pour générer Le decoblock, le programme demande à l’utilisateur de taper les lignes correspondantes au fonctionnement de l’ALU.
A la fin de l’opération, l’utilisateur doit taper le mot FIN.  
Ensuite,le programme demande à l’utilisateur:
La condition du passage de l’état decode (00010) au nouvel état ajouté
Les lignes correspondantes au passage de de l’état ajouté à l’état futur
Les sorties correspondant à ce nouvel état ajouté.
A chaque fois, l’utilisateur doit taper le mot FIN pour passer à l’étape suivante. 

A chaque instruction ajoutée, il ne faut donc pas oublier de lui attribuer : 
Une adresse correspondant au nouvel état ajouté  
Un opcode correspondant à cette nouvelle instruction ajoutée 
Une valeur au signal funct 3 si l’instruction ajoutée a un comportement similaire à une instruction de type R,I,S ou B.
Une valeur au signal funct 7 si l’instruction ajoutée a un comportement similaire à une instruction de type R. 
Les bons signaux de commande et les signaux du decoblock 
Une valeur au signal Imm_type :  
la valeur “000” si l’instruction ajoutée est assimilée à une instruction Reg-Reg.
“001” si elle ressemble à une instruction Reg-Imm.
“010” si elle ressemble à une instruction de type S.
“011” si elle est une instruction de branchement. 

