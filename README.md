# FOURNIER_Lab3

## Introduction

Ce TP met en pratique les concepts de conception conjointe vus en cours en travaillant avec une carte DE10-Lite équipée d'un FPGA MAX10 10M50DAF484C7G de la gamme Altera. L'objectif principal est d'afficher les données de l'accéléromètre interne sur les afficheur 7 segments avec possibilité de changer l'affichage selon les axes grâce à des witchs.

## Architecture du Système

Le système comprend l'architecture de base avec :
- Un processeur Nios II
- Une IP I2C pour l'interfaçage avec l'accéléromètre 
- Une mémoire RAM
- Une clock
- Un port JTAG

- Ajouts :
- Cinq PIO 8 bits pour les 5 7 segments
- Un PIO 8 bits pour les switchs

![image](https://github.com/ESN2024/FOURNIER_Lab3/assets/124307686/db40c9fc-dc10-4919-8dda-8055c75f853e)


## Platform Designer

L'architecture sous Platform Designer (QSYS) inclut les composants mentionnés au-dessus.

![image](https://github.com/ESN2024/FOURNIER_Lab1/assets/124307686/b3b4c6ab-9288-4ef6-8814-4502d66a651d)

## Quartus et pin planner

Dans Quartus, le fichier toplevel.vhd est rédigé, et un autre fichier VHDL est ajouté au projet pour convertir un nombre binaire codé sur 4 bits (cnt) en une représentation 7 segments (seg_bcd_output). Chaque valeur possible de cnt est associée à une configuration spécifique des segments 7, conformément à la logique commune des afficheurs 7 segments. Une fois les signaux reliés dans le top level, les assignations de broches sont effectuées dans le pin planner. Il est essentiel d'assigner correctement les broches pour les ajouts mentionnés en se référant à la documentation de la carte.


![image](https://github.com/ESN2024/FOURNIER_Lab1/assets/124307686/a2ece9aa-72f3-46b9-b9ae-b78acc63c600)

Ensuite, la compilation complète du design est effectuée, le design est flashable sur la carte si aucune erreur n'est présente.

## Nios II Flow

À partir du terminal Nios II, le BSP est généré et un Makefile est créé. Ensuite, les scripts C sont écrits, compilés et téléversés sur la carte.

## Travail Effectué

J'ai découpé ce projet en plusieur partie, chacune réalisant une étape spécifique du projet :

### Lecture, écriture et affichage sur le terminal

En se référent à la documentation de l'accéléromètre on trouve les registres dans lesquels nous avons les information sur les différents paramètres important de l'accéléromètre :

![image](https://github.com/ESN2024/FOURNIER_Lab3/assets/124307686/2b90bb09-2dff-44fc-b4e4-215b51b9c7bc)

Les registres `0xIE` à `0x20` sont les registres permettant de calibrer l'accéléromètre.
Le registre `0x31` est le registre permettant de changer la définition des données, qui le rend plus ou moins précis.
Les registres `0x32` à `0x37` sont les registres où sont stocké les données de l'accéléromètre selon les axes.

Pour la lecture des données, les fonctions suivantes sont utilisées  :

![image](https://github.com/ESN2024/FOURNIER_Lab3/assets/124307686/dadde206-adbd-4266-ba30-15f202c34c41)

Pour la l'écriture des données, les fonctions suivantes sont utilisées  :

![image](https://github.com/ESN2024/FOURNIER_Lab3/assets/124307686/cdc95974-01b0-4f13-a339-6eac22f49545)

Ces fonction ont été écrite gràce à d'autres fonction existantes dans un fichier opencore_I2C.c

Pour afficher les valeurs de l'accéléromètre sur les axes, une nouvelle focntion de lecture est développé en s'appuyant sur les précédentes, et un complément à deux et une multiplication par 3.9 sont effectué pour mettre les données au bont format.

### La calibration de l'accéléromètre

Pour la calibration de l'accéléromètre, en suivant la documentation, nous avons un calcul pour trouver l'offset nécessaire. Il nous reste plusqu'à les écrire dans les registres correspondant après avoir paramétré la précision de l'accéléromètre au plus précis.


### L'affichage sur les 7 segments et ajout des modes en fonction des axes

Une boucle while réalise l'affichage des données sur les 7 segments, et pour les allumer la fonction suivante est utilisée :
`IOWR_AERA_AVALON_PIO_DATA(PIO_0_BASE, dx);` où dx est le digit à afficher (unité, dizaine,...). Selon la valeur de dx, un affichage est effectué selon le paramétrage dans le fichier seg_bcd.vhd. 
Enfin, avec un if on compare la valeur des switchs. Selon leur position on affiche la valeur de l'accéléromètre de l'axe X, Y ou Z.

## Démo

https://github.com/ESN2024/FOURNIER_Lab2/assets/124307686/23a308cc-c77f-41e5-8aa1-909f3612a659


## Conclusion

Ce TP nous a permis de prendre en main les outils de conception conjointe, tout en utilisant nos connaissances acquises en cours, particulièrement au niveau des interruptions.
