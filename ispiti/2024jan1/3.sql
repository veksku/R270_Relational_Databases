--a

create table stats(
	mesto varchar(30) not null primary key,
	broj_studenata integer,
	broj_diplomiranih integer,
	udeo_studenata double default 0.0
);

--b

create function izracunaj_udeo(mesto varchar(30))
returns double
return
	select decimal((count(case when d.mestorodjenja = mesto then 1 else null end) + 0.0)
		/ (count(*)+0.0), 5, 2)
	from da.dosije d;

--c

--#SET TERMINATOR @
create trigger azuriranje_unosa
before insert on stats --before/after insert/update/delete
referencing new as n --referencing new/old as n/o
for each row
begin atomic
	set n.udeo_studenata = izracunaj_udeo(n.mesto);
end@
--#SET TERMINATOR ;

--d

insert into stats(mesto, broj_studenata, broj_diplomiranih)
select d.mestorodjenja, count(*),
	count(case when d.datdiplomiranja is not null then 1 else null end)
from da.dosije d
where d.mestorodjenja like 'B%'
group by d.mestorodjenja;

--e

drop table stats;
drop function izracunaj_udeo;
drop trigger azuriranje_unosa;

--pomocni upit
select *
from stats;
