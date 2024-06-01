select d.indeks, d.ime, d.prezime, 
	case
		when p.naziv is null then '/'
		else p.naziv
	end
	"Naziv predmeta", i.ocena, d.datupisa
from da.dosije d join da.ispit i
		on d.indeks = i.indeks and year(d.datupisa) between 2015 and 2020 and i.ocena > 5 and i.status = 'o'--and d.indeks=20162022
	join da.predmet p
		on p.id = i.idpredmeta
where not exists(
	select *
	from da.upisankurs uk
	where uk.skgodina = 2018 and not exists(
		select *
		from da.ispit i1
		where i1.indeks = uk.indeks and i1.status = 'o'
	)
)
order by d.prezime desc, d.ime asc;

--ne valja