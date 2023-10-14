--1. Izdvojiti ime i prezime studenta koji ima priznat ispit. Zadatak rešiti na tri načina.

select distinct ime, prezime
from da.dosije d join da.ispit i
	on d.indeks = i.indeks and i.status = 'o';

select distinct ime, prezime
from da.dosije d
where indeks in (
	select indeks
	from da.ispit i
		where i.indeks = d.indeks
			and status ='o'
);

select distinct ime, prezime
from da.dosije d
where 'o' in (
	select status
	from da.ispit i
		where i.indeks = d.indeks
);

--2. Izdvojiti nazive predmeta koje su polagali svi studenti. (napomena: rezultat je prazna tabela)

select naziv
from da.predmet p
where not exists (
	select *
	from da.ispit i
	where not exists (
		select *
		from da.dosije d
		where d.indeks = i.indeks and p.id = i.idpredmeta
	)
);

--3. Izdvojiti podatke o studentima koji su polagali sve predmete od 30 espb bodova.

select *
from da.dosije d
where not exists (
	select *
	from da.ispit i
	where not exists (
		select *
		from da.predmet p
		where d.indeks = i.indeks and p.espb = 30
	)
);

--4. Izdvojiti podatke o prvom održanom ispitnom roku na fakultetu. Zadatak rešiti na tri načina.

select *
from da.ispitnirok
where datpocetka <= all (
	select datpocetka
	from da.ispitnirok
	where datpocetka is not null
);

select *
from da.ispitnirok
where datkraja <= all (
	select datkraja
	from da.ispitnirok
	where datkraja is not null
);

select *
from da.ispitnirok
where oznakaroka in ('jan1', 'jan1P') and skgodina <= all (
	select skgodina
	from da.ispitnirok
	where skgodina is not null
);

--5. Za predmet koji je prvi polagan na fakultetu izdvojiti njegov naziv i imena i prezimena studenata koji su ga ikada upisali.

select p.naziv, d.ime, d.prezime
from da.predmet p join da.ispit i
		on i.idpredmeta = p.id
	join da.dosije d
		on d.indeks = i.indeks
where datpolaganja <= all (
	select datpolaganja
	from da.ispit i
	where datpolaganja is not null
);
		
		
		
		