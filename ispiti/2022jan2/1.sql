select distinct(d.indeks), d.ime, d.prezime, substr(d.mestorodjenja,1,2) mestorodjenja,
	year(d.datupisa) godina, monthname(d.datupisa) mesec, 
	case
		when pi.nazivpredmeta is NULL then 'nema priznat predmet'
		else pi.nazivpredmeta
	end
	"Priznati predmet"
from da.dosije d join da.priznatispit pi
	on d.indeks = pi.indeks
where exists(
	select *
	from da.ispit i join da.predmet p
		on p.id = i.idpredmeta
	where d.indeks = i.indeks and i.ocena > 5 and i.status = 'o' and p.espb = 6
);