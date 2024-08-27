--a

create table smerovi(
	id integer primary key not null,
	naziv varchar(100),
	nivo varchar(10),
	studenti integer,
	prosek double,
	constraint vrednost_nivo check (nivo in ('osnovne', 'master', 'doktorske'))
);

--b

create function to_cm(broj integer, jmere varchar(1))
returns integer
return
	case
		when jmere = 'd' or jmere = 'D' then broj*10
		when jmere = 'm' or jmere = 'M' then broj*100
		when jmere = 'k' or jmere = 'K' then broj*1000
		else -1
	end;
	
--c

insert into smerovi(id, naziv, studenti)
select sp.id, sp.naziv, count(*) br_studenata
from da.studijskiprogram sp join da.dosije d
	on d.idprograma = sp.id
where sp.idnivoa = 1
group by sp.id, sp.naziv;

--d

insert into smerovi(id, naziv, studenti, prosek)
select sp.id, sp.naziv, count(*) br_studenata, decimal(avg(ocena+0.0), 4, 2)
from da.studijskiprogram sp join da.dosije d
		on d.idprograma = sp.id
	join da.ispit i
		on d.indeks = i.indeks and i.ocena > 5 and i.status = 'o'
where sp.idnivoa = 2  or sp.idnivoa = 3
group by sp.id, sp.naziv;
--ovo samo dodaje redove za master i doktorske, nmp kako da se i azuriraju vrednosti bez update

--e

delete from smerovi
where studenti < 100 and prosek > 9.0;

--pomocne f-je

select *
from smerovi;
drop table smerovi;
drop function to_cm;
