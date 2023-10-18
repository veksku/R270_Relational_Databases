--1. Izdvojiti ime i prezime studenata za koga važi da postoji student koji je rođen u istom mestu i koji je godinu dana ranije
--   upisao fakultet.

select ime, prezime
from da.dosije d1
where exists (
	select *
	from da.dosije d2
	where d1.mestorodjenja = d2.mestorodjenja and year(d1.datupisa) = year(d2.datupisa) + 1
);

--2. Napisati na SQL-u upit koji za svaki predmet izdvaja studenta koji je taj predmet položio u poslednjih 5 godina i 3 meseca.
--   Izdvojiti naziv predmeta i ime i prezime studenta. Ime i prezime studenta izdvojiti kao jednu nisku i kolonu koja sadrži
--   ime i prezime studenta nazvati Student. Ako nijedan student nije položio predmet u zadatom periodu, umesto imena i prezimena
--   studenta ispisati Nema studenata. Rezultat urediti prema nazivu predmeta.

select distinct naziv, 
	case 
		when i.status = 'o' then ime || ' ' || prezime
		else 'Nema studenata'
	end as "Student"
from da.ispit i join da.dosije d
		on i.indeks = d.indeks
	join da.predmet p
		on i.idpredmeta = p.id and i.status = 'o' and (i.datpolaganja + 5 years + 3 months) > current_date
order by naziv;

--3. Za sve studente koji su fakultet upisali u julu ili septembru kod kojih su ime i prezime iste dužine, izdvojiti informacije
--   o polaganjima svih predmeta čiji naziv počinje slovom P. Izdvojiti indeks studenta, ime i prezime studenta u obliku prezime
--   razmak ime (kolonu nazvati Prezime pa ime), naziv predmeta i dobijenu ocenu. U rezultatu izdvojiti i podatke o studentima
--   koji su fakultet upisali u julu ili septembru, a nisu polagali predmet čiji naziv pocinje slovom P.

select distinct d.indeks, prezime || ' ' || ime "Prezime pa ime", naziv, ocena
from da.dosije d join da.ispit i
		on d.indeks = i.indeks and month(d.datupisa) in (7,9) and length(d.ime) = length(d.prezime) and i.ocena >= 5
	join da.predmet p
		on p.id = i.idpredmeta and p.naziv like 'P%' 
union
select distinct d.indeks, prezime || ' ' || ime "Prezime pa ime", naziv, null
from da.dosije d join da.ispit i
		on d.indeks = i.indeks and month(d.datupisa) in (7,9) and ocena is null
	join da.predmet p
		on p.id = i.idpredmeta and p.naziv like 'P%';

--4. Pronaći nazive ispitnih rokova u kojima su polagali svi studenti koji imaju bar jednu ocenu 10.

select distinct naziv
from da.ispitnirok ir
where not exists (
	select *
	from da.ispit i
	where not exists(
		select *
		from da.dosije d
		where d.indeks = i.indeks and i.ocena = 10
	)
);
--nisam siguran da li je ovo tacno