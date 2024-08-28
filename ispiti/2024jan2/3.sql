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

merge into smerovi sm
using (select sp.id id, sp.naziv naziv,
	case
		when id like '1%' then 'osnovne'
		when id like '2%' then 'master'
		when id like '3%' then 'doktorske'
		else '-1'
	end nivo, count(*) br_studenata, decimal(avg(ocena+0.0), 4, 2) prosek
	from da.studijskiprogram sp join da.dosije d
			on d.idprograma = sp.id
		join da.ispit i
			on d.indeks = i.indeks and i.ocena > 5 and i.status = 'o'
	group by sp.id, sp.naziv) as tmp
on sm.id = tmp.id
when matched then
	update
	set (nivo, prosek) = (tmp.nivo, tmp.prosek)
when not matched then
	insert
	values(tmp.id, tmp.naziv, tmp.nivo, tmp.br_studenata, tmp.prosek);

--e

delete from smerovi
where studenti < 100 and prosek > 9.0;

--pomocni upiti

select *
from smerovi;
drop table smerovi;
drop function to_cm;
