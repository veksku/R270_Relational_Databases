--a

create table stats (
	mesto varchar(30) not null primary key,
	broj_studenata integer,
	broj_diplomiranih integer,
	udeo_studenata float default 0.0
);


--b

create function izracunaj_udeo(mesto varchar(30))
returns float
return
	select decimal((count(case when d.mestorodjenja = mesto then 1 else null end) + 0.0)
		/  (count(*)+0.0), 5, 2)
	from da.dosije d;


--c

--#SET TERMINATOR @

create trigger azuriranje_unosa
before insert on stats
referencing new as n
for each row
begin atomic
	set n.udeo_studenata = izracunaj_udeo(n.mesto);
end@


--d

insert into stats
select d.mestorodjenja, count(*),
	count(case when d.datdiplomiranja is not null then 1 else null end), 0
from da.dosije d
where d.mestorodjenja like 'B%'
group by d.mestorodjenja@

select *
from stats

--e

drop table stats@
drop trigger azuriranje_unosa@
drop function izracunaj_udeo@