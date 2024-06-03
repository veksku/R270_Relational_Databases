-- a
create table diplomirani (
	indeks integer not null primary key,
	polozeno_espb integer,
	prosek double,
	datum_prvog_polozenog date	
);


-- b

--#SET TERMINATOR @

create trigger unos
before update of datdiplomiranja
on da.dosije
referencing new as n
	old as o
for each row
when (o.datdiplomiranja is null and n.datdiplomiranja is not null)
begin
	insert into diplomirani
	select n.indeks, sum(p.espb), decimal(avg(i.ocena+0.0), 4, 2), min(i.datpolaganja)
	from da.ispit i join da.predmet p
		on i.idpredmeta = p.id
	where i.status='o' and i.ocena>5 and i.indeks=n.indeks;
end@

--trazi se student za testiranje
select *
from da.dosije
where datdiplomiranja is null@
--nadjen primer 20150109

update da.dosije
set datdiplomiranja = current date
where indeks=20150109@

select *
from diplomirani@

--vraca se stara vrednost
update da.dosije
set datdiplomiranja = null
where indeks=20150109@

-- c

-- valja napraviti kopiju tabele dosije da bismo vratili vrednosti kasnije

--create table dosije1 as (
--	select *
--	from da.dosije
--) with data@

-- 
update da.dosije d
set datdiplomiranja = current date
where year(datupisa)= 2015 and indeks in(
	select indeks
	from da.priznatispit pi
)@

--provera rezultata
select *
from diplomirani@

--vracanje vrednosti
update da.dosije d
set datdiplomiranja = (select d1.datdiplomiranja
	from dosije1 d1
	where d1.indeks=d.indeks)
where year(datupisa)= 2015 and indeks in(
	select indeks
	from da.priznatispit pi
)@
--


--d

delete from diplomirani
where indeks in(
	select indeks
	from da.upisgodine ug join da.studentskistatus ss
		on ug.idstatusa = ss.id
	where ss.naziv like '%mirovanje%' or ss.naziv like '%Mirovanje%'
)@

--e

drop table diplomirani@






