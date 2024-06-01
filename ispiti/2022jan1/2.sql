with tmp as (
	select ir.naziv rok, p.naziv predmet, p.espb, avg(case when ocena>5 and i.status='o' then i.ocena * 1.0 else null end) prosek,
		count(case when ocena>5 and i.status='o' then 1 else null end) polozilo,
		decimal(count(case when ocena>5 and i.status='o' then 1 else null end) * 100.0 / count(*), 5, 2)prolaznost
	from da.ispitnirok ir join da.ispit i
			on ir.skgodina = i.skgodina and ir.oznakaroka = i.oznakaroka
		join da.predmet p
			on p.id = i.idpredmeta 
	group by ir.skgodina, ir.oznakaroka, ir.naziv, p.naziv, p.espb
	order by ir.naziv)
select *
from tmp t1
where prolaznost >= all (
	select prolaznost
	from tmp t2
	where t1.rok = t2.rok
)
order by rok desc;