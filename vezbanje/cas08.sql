--1. Napisati pogled koji izdvaja poslednji položeni ispit za svakog studenta koji ima prosek
--   iznad 8. Izdvojiti indeks, ime i prezime studenta i datum polaganja poslednjeg ispita.

create view poslednji_polozeni as
select d.indeks, ime, prezime, datpolaganja
from da.dosije d join da.ispit i
	on d.indeks = i.indeks
where 8.00 < (
	select decimal(avg(ocena+0.0), 4, 2)
	from da.ispit i1
	where i1.indeks = i.indeks);

--2. Napisati pogled koji izdvaja podatke o studntima koji su bar jedan ispit položili sa
--   ocenom 10. Pogled napisati tako da je kroz njega moguće dodavanje novih studenata.
--   Izdvojiti samo kolone iz tabele dosije koje su neophodne da bi mogao da se izvrši unos
--	 podataka o novom studentu preko pogleda.

--men..

--3. Napisati korisnički definisanu funkciju koja za prosleđen indeks vraća inicijale studenta.
--	 Ukoliko ne postoji stuedent vratiti 'XX'.

create function inicijali(indeks integer)
returns varchar(2)
return
	select substr(ime, 1, 1) || substr(prezime, 1, 1)
	from da.dosije d
	where d.indeks = indeks;
--nzm kako da ga napravim da prepoznaje prazan red i da vrati 'XX'

--4. Napisati korisnički definisanu funkciju koja vraća broj različitih rokova u kojim je
--	 student sa prosleđenim indeksom položio neki ispit.

create function rokovi(indeks integer)
returns smallint
return
	select count(distinct ir.oznakaroka)
	from da.ispitnirok ir join da.ispit i
			on ir.oznakaroka = i.oznakaroka
	where i.indeks = 20150001;

--5. Napisati korisnički definisanu funkciju koja vraća broj dana studiranja ako je student
--	 sa prosleđenim indeksom diplomirao, inače 0.

create function kolikostudira(indeks integer)
returns smallint
return
	(select
		case
			when d.datdiplomiranja is null then 0
			else days(d.datdiplomiranja) - days(d.datupisa)
		end
	from da.dosije d
	where d.indeks = indeks);
--ne prolazi iz nekog razloga, unexpected token "" was found following ""?
