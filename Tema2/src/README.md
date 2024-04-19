# PCLP2 Tema 2

## Task 1
Idee de rezolvare:
* copiem cel mai semnificativ bit din numarul dat -> id furnica
* incarcam permisiunile furnicii intr-un registru
* incarcam numarul primit intr-un registru
* shiftam numarul 8 biti la stanga pentru a scapa de id
* shiftam si reg cu perm furnicii la stanga cu 8 biti
* comparam registrele bit cu bit
* salvam rezultatul cerut

## Task 2

### Task 2.1
Idee de rezolvare:
* implementam cea mai simpla sortare posibila, bubble sort
* comparam pe rand, in functie de criteriile din enunt:
    * gradul de admin
    * prioritatea requestului
    * userul

Pentru compararea numelor, implementam strcmp astfel:
* comparam caracter cu caracter cele 2 siruri
* cand gasim un caracter diferit, le putem compara

### Task 2.2
Idee de rezolvare:
* verificam daca primul bit din passkey este 1
* verificam daca ultimul bit este 1
* folosind niste masti, calculam nr de biti 1:
    * din cei 7 biti din dreapta
    * din cei 7 biti din stanga
* in functie de numarul lor, se afla usor daca este hacker

## Task 3

### Encrypt
Idee de rezolvare:
* folosind exemplul din cerinta, cu cei 5 pasi, ii implementam
* singura modificare este ca `block_size` devine 8
* operatiile se efectueaza de 10 ori, conform cerinta

### Decrypt
Se rezolva in mod analog

## Task 4
Idee de rezolvare:
* incepem parcurgerea matricei de la coltul stanga sus
* verificam unde putem merge in continuare
* la fiecare mutare, tinem minte directia deplasarii
* astfel, ne folosim de o variabila din .data:
    * `ultimaMutare` = 1 -> jos
    * `ultimaMutare` = 2 -> sus
    * `ultimaMutare` = 3 -> dreapta
    * `ultimaMutare` = 4 -> stanga
* repetam procesul pana cand ajungem la o margine
* margine = linia m - 1 / coloana n - 1
* ajungand la final, salvam pozitia