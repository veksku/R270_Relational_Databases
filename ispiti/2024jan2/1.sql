select p1.naziv, p2.naziv
from da.predmet p1 join da.predmet p2
	on p1.espb = p2.espb
where p1.naziv like '___ri%' and length(p2.naziv) > 4 and p1.naziv < p2.naziv and exists (
	select *
	from da.ispit i1 join da.ispit i2
		on i1.skgodina = i2.skgodina and i1.indeks = i2.indeks
	where i1.status = 'o' and i2.status = 'o' and i1.ocena > 5 and i2.ocena > 5		
)