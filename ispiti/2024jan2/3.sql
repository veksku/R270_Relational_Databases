--a

create table smerovi (
	id integer primary key not null,
	naziv varchar(100),
	nivo varchar(10),
	studenti integer,
	prosek double,
	constraint vrednost_nivo check (nivo in ('osnovne','master','doktorske'))
);


--b

create function to_cm(broj integer, jed_mere varchar(1))
returns integer
return
	case
		when jed_mere = 'd' then broj*10
		when jed_mere = 'm' then broj*100
		when jed_mere = 'k' then broj*1000
		else -1
	end;
	
	
--c

insert into smerovi(id, naziv, studenti)
select sp.id, sp.naziv, count(*) br_studenata
from da.studijskiprogram sp join da.dosije d
	on d.idstatusa = sp.idnivoa and sp.idnivoa = 1
group by sp.id, sp.naziv


--d




--e

delete from smerovi
where (studenti<1000) and (prosek>9.0);













