fichier = open("test.txt", "r")
fichier2 = open("hex.txt", "w")
fichier3 = open("test.uart", "w", encoding="iso-8859-1")
tab = []
tab1 = []
tab2 = []

for ligne in fichier:
    if ligne.strip() == "":
        continue

    nombre_decimal = int(ligne.strip())
    nombre_hex = hex(nombre_decimal)[2:]
    tab1.append(nombre_hex)
    tab2.append(chr(int(nombre_hex, 16)))

for i in range(len(tab1)):
    fichier2.write(tab1[i] + "\n")

for i in range(len(tab2)):
    fichier3.write(tab2[i])

fichier.close()
fichier2.close()
fichier3.close()

