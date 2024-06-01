with tmp as (select i.idpredmeta, max(i.ocena) maxocena
	from da.ispit i
	where i.status='o' and i.ocena > 5
	group by i.idpredmeta)
select p.naziv, ir.naziv, count(*) br
from da.ispit i join da.ispitnirok ir
		on i.skgodina = ir.skgodina and i.oznakaroka = ir.oznakaroka
	join da.predmet p
		on p.id = i.idpredmeta
where i.status='o' and i.ocena = (
	select maxocena
	from tmp t
	where t.idpredmeta = i.idpredmeta
)
group by p.naziv, ir.naziv, p.id, ir.skgodina, ir.oznakaroka
order by p.naziv asc, br desc, ir.naziv asc;