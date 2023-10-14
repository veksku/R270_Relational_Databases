--1. Izdvojiti podatke o priznatim ispitima sa poznatom ocenom.

select *
from da.ispit
where status = 'o';

--2. Izdvojiti podatke o upisanim školskim godinama studenata. Izdvojiti indeks, ime i prezime studenta, školsku godinu i
--   datum upisa godine. Rezultat urediti prema indeksu u opadajućem poretku i školskoj godini u rastućem poretku.

select d.indeks, d.ime, d.prezime, u.skgodina, u.datupisa
from da.dosije d join da.upisgodine u
	on d.indeks = u.indeks
order by d.indeks desc, u.skgodina asc;

--3. Izdvojiti parove studenata koji su rođeni u istom mestu. Izdvojiti indekse studenata.

select distinct d1.indeks, d2.indeks
from da.dosije d1 join da.dosije d2
	on d1.mestorodjenja = d2.mestorodjenja and d1.indeks < d2.indeks;
	
--4. Za svaki predmet izdvojiti podatke o ispitnim rokovima u kojima je predmet poništen. Izdvojiti naziv predmeta, školsku
--   godinu u kojoj je održan ispitni rok i oznaku roka. Izdvojiti podatke i o predmetima čiji nijedan ispit nije poništen.
--   Upit napisati tako da nema ponavljanja redova u rezultatu.

select distinct p.naziv, i.skgodina, i.oznakaroka
from da.predmet p left join da.ispit i
	on i.idpredmeta = p.id and i.status = 'x';

--5. Za svaki predmet izdvojiti podatke o ispitnim rokovima u kojima je predmet poništen. Izdvojiti naziv predmeta i naziv
--   ispitnog roka. Izdvojiti podatke i o predmetima čiji nijedan ispit nije poništen. Upit napisati tako da nema ponavljanja
--   redova u rezultatu.

select distinct p.naziv, ir.naziv
from da.predmet p left join da.ispit i
		on i.idpredmeta = p.id and i.status = 'x'
	join da.ispitnirok as ir
		on ir.oznakaroka = i.oznakaroka;

--6. Izdvojiti podatke o studentima i njihovim upisanim predmetima od 5, 10, 12 ili 25 espb čiji naziv počinje sa Pr i sadrži
--   malo slovo o. Izdvojiti podatke samo za školske godine u intervalu od 2016/2017. do 2020/2021. Izdvojiti indeks, ime, prezime
--   studenta, školsku godinu, naziv upisanog predmeta i broj espb predmeta. Rezultat urediti prema indeksu, školskoj godini i
--   oznaci predmeta.

select d.indeks, d.ime, d.prezime, uk.skgodina, p.naziv, p.espb
from da.upisankurs uk join da.predmet p
		on uk.idpredmeta = p.id and espb in (5,10,12,25) and p.naziv like 'Pr%' and skgodina between 2016 and 2021
	join da.dosije d
		on d.indeks = uk.indeks
order by d.indeks, uk.skgodina, p.oznaka



 