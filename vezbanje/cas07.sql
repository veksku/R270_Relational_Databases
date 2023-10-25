--1. Napraviti tabelu student_ispiti koja ima kolone:
--    	indeks – indeks studenta;
--    	broj_polozenih_ispita – broj položenih ispita;
--    	prosek – prosek studenta.
--	 Definisati primarni ključ i strani ključ na tabelu dosije.

--create table student_ispiti (
--	indeks integer not null,
--	broj_polozenih_ispita integer,
--	prosek float(4),
--	primary key (indeks),
--	foreign key fk_ispit (indeks) references da.dosije
--);

--2. Tabeli student_ispiti dodati kolonu broj_prijavljenih_ispita koja predstavlja broj polaganih ispita. Dodati i ograničenje da broj polaganih ispita mora biti veći ili jednak broju položenih ispita. 

--alter table student_ispiti 
--	add broj_prijavljenih_ispita integer
--	add constraint broj_prijavljenih_ispita check (broj_prijavljenih_ispita >= broj_polozenih_ispita);

--3. U tabelu student_ispiti uneti podatke za studente koji su polagali ispite.

--insert into student_ispiti (indeks, broj_polozenih_ispita, prosek, broj_prijavljenih_ispita)
--with broj_prijavljenih as (
--	select i.indeks, count(*) as prijavljeno
--	from da.ispit i
--	where i.status in ('o', 'n')
--	group by i.indeks
--)
--select pi.indeks, count(*) as polozeno, decimal(avg(ocena + 0.0), 4, 2), pi.prijavljeno
--from broj_prijavljenih pi join da.ispit i
--	on pi.indeks = i.indeks
--where i.status = 'o' and i.ocena > 5
--group by pi.indeks, pi.prijavljeno;

--select i.indeks, count(*) nesto, decimal(avg(ocena + 0.0), 4, 2)
--from da.ispit i
--where i.status in ('o', 'n') and i.indeks = 20160191
--group by i.indeks;

--4. U tabelu student_ispiti uneti podatke za studente koji nisu ništa polagali. U odgovarajuće kolone uneti NULL.

--insert into student_ispiti (indeks, broj_polozenih_ispita, prosek, broj_prijavljenih_ispita)
--select i.indeks, null as polozeno, count(*) nes, null
--from da.ispit i
--where i.status in ('p', 'n')
--and not exists (
--	select *
--	from da.ispit i1
--	where i1.indeks = i.indeks and status='o'
--)
--group by i.indeks
--order by nes desc;

--5. Obrisati tabelu student_ispiti.

--drop table student_ispiti;

--6. Za sve polagane ispite u roku jan2 2016 promeniti datum polaganja ispita na datum poslednjeg položenog ispita,
--   a ocenu na 10.

----kreiranje privremene tabele
--create table ispiti2016 as (
--	select *
--	from da.ispit
--)with data;

--update ispiti2016
--set (datpolaganja) = (
--	select distinct datpolaganja
--	from da.ispit
--	where datpolaganja = (
--		select max(datpolaganja)
--		from da.ispit
--	)
--), (ocena) = 10
--where skgodina=2016 and oznakaroka = 'jan2' and datpolaganja is not null;

----brisanje tabele
--drop table ispiti2016







