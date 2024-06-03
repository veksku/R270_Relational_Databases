with tmp as (
	select d.indeks indeks, d.ime ime, d.prezime prezime, 
		count(case when i.status='p' then 1 else null end) prijavljeno,
		count(case when i.status='o' and i.ocena > 5 then 1 else null end) polozeno,
		decimal(avg(case when i.status='o' and i.ocena > 5 then i.ocena * 1.00 else null end),4,2) prosek
	from da.dosije d join da.ispit i
			on d.indeks = i.indeks
	group by d.indeks, d.ime, d.prezime
)
select distinct t1.indeks, t1.ime, t1.prezime, t1.prijavljeno, t1.polozeno, t1.prosek
from tmp t1 join da.ispit i1
		on i1.indeks = t1.indeks
	join da.dosije d1
		on t1.indeks = d1.indeks
where prijavljeno >= 3 and not exists(
	select d1.indeks
	from da.dosije d2 join da.ispit i2
		on d2.indeks = i2.indeks
	where d1.indeks <> d2.indeks and i1.poeni < i2.poeni and d1.idprograma = d2.idprograma
)
order by t1.prosek asc, t1.indeks desc