--1. Korišćenjem agregatnih funkcija, pronaći podatke o predmetima sa najvećim broj espb podova.

select *
from da.predmet
where espb = (
	select max(espb)
	from da.predmet
);

--2. Za svaki predmet izdvojiti naziv, prosečnu ocenu dobijenu na položenim ispitima, broj studenata koji su
--   položili ispit iz tog predmeta i najveću ocenu dobijenu na položenim ispitima iz tog predmeta.

select naziv, decimal(avg(ocena + 0.0), 4, 2) prosek, count(*) br_studenata, max(ocena) max_ocena
from da.predmet p join da.ispit i
	on i.idpredmeta = p.id
group by naziv;

--3. Za svakog studenta koji zadovoljava uslove:
--      -rođen je u mestu koje u imenu sadrži malo slovo o i malo slovo a (slovo o se pojavlju pre slova a)
--      -prijavio je bar 3 ispita
--      -najveća ocena sa kojom je položio ispit je 9
--   Izdvojiti indeks, ime, prezime, mesto rođenja i ime dana u kome je polagao prvi ispit. Rezultat urediti prema
--   mestu rođenja i indeksu u rastućem poretku.

select ime, prezime, mestorodjenja, dayname(datpolaganja) dan_polaganja
from da.dosije d join da.ispit i
	on d.indeks = i.indeks and mestorodjenja like '%o%a%'
where 3 <= (
	select count(*)
	from da.ispit i
	where d.indeks = i.indeks and status='p'
) and
9 = (
	select max(ocena)
	from da.ispit i
	where d.indeks = i.indeks
) and
datpolaganja = (
	select min(datpolaganja)
	from da.ispit i
	where d.indeks = i.indeks
)
order by mestorodjenja asc, d.indeks asc;

--4. Za svaki ispitni rok izdvojiti predmet koji su u tom ispitnom roku studenti položili sa najvećom prosečnom ocenom.
--   Izdvojiti naziv ispitnog roka, naziv predmeta sa najvećom prosečnom ocenom i najveću prosečnu ocenu.

--select distinct ir.naziv naziv_roka, p.naziv naziv_predmeta, decimal(avg(ocena + 0.0), 4, 2) as prosek
--from da.ispitnirok ir join da.ispit i
--		on ir.oznakaroka = i.oznakaroka and i.ocena is not null
--	join da.predmet p
--		on i.idpredmeta = p.id
--group by ir.naziv, p.naziv;

--select max(prosek)
--from (select ir2.naziv, p2.naziv, decimal(avg(ocena + 0.0), 4, 2) as prosek
--		from da.ispitnirok ir2 join da.ispit i2
--				on ir2.oznakaroka = i2.oznakaroka and i2.ocena is not null
--			join da.predmet p2
--				on i2.idpredmeta = p2.id
--		group by ir2.naziv, p2.naziv)

--with prosek as(
--	select decimal(avg(ocena + 0.0), 4, 2)
--	from da.ispitnirok ir join da.ispit i
--			on ir.oznakaroka = i2.oznakaroka and i2.ocena is not null
--		join da.predmet p
--			on i.idpredmeta = p.id
--	group by ir.naziv, p.naziv
--)
--select 
