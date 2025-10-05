-- 1. Fakultet organizuje putovanje za studente. Puna cena putovanja je 25000 RSD.
-- Napraviti tabelu putovanje koja čuva podatke o studentima zainteresovanim za putovanje.
-- Tabela ima kolone:
--      > indeks - indeks studenta
--      > cena - cena putovanja za studenta
--      > status_placanja - status plaćanja
-- Definisati primarni ključ i strani ključ na tabelu dosije.
-- Napisati naredbu koja u tabeli putovanje postavlja ograničenja:
--      > vrednost kolone status_placanja može biti placeno, oslobodjen, neplaceno
--      > podrazumevana vrednost kolone status_placanja je neplaceno
-- Napisati naredbu koja u tabelu putovanje unosi podatke za studente koji su u 2016/2017.
-- školskoj godini položili bar polovinu upisanih ESPB u toj školskoj godini.
-- Napisati naredbu koja menja tabelu putovanje tako da sadrži prijave svih studenata koji
-- nisu diplomirali. Studentima o kojima postoje podaci u tabeli putovanje ažurirati podatke
-- na sledeći način:
--      > ako je student bar na polovini položenih ispita dobio ocenu 10 oslobođen je plaćanja putovanja.
--        Postaviti cenu na 0 i status plaćanja na oslobodjen
--      > ostalim studentima izračunati cenu prema formuli: cena putovanja se umanjuje za procenat koji
--        odgovara procentu ispita koje je student položio sa ocenom 10 u odnosu na njegov br položenih ispita.
-- Za studente o kojima ne postoje podaci u tabeli putovanje uneti podatke. Uneti indeks i cenu.
-- Punu cenu putovanja umanjiti za procenat koji odgovara procentu ispita koje je student položio sa ocenom 10.
-- Napisati naredbu za brisanje tabele putovanje.



-- 2. Napraviti okidač koji sprečava brisanje predmeta sa brojem espb bodova većim od 15.



-- 3. Za sve studente osnovnih studija izdvojiti pregledne podatke o količini ispunjenih obaveza.
-- Izdvojiti broj indeksa, oznaku smera, ukupan broj ESPB potrebnih za završetak studija,
-- ukupan broj ESPB iz položenih predmeta, procenat položenosti ESPB, ukupan broj ESPB koje nose
-- obavezni predmeti, ukupan broj ESPB koje nose položeni obavezni predmeti, procenat položenosti
-- ESPB koje nose obavezni položeni predmeti. Izveštaj urediti po procentu položenosti ESPB.


