select distinct d.indeks, d.ime || ' ' || d.prezime "Ime i prezime", 
	case
		when d.idstatusa = 1 then sp.naziv
		else p.naziv
	end "Komentar", 
	case
		when d.idstatusa = 1 then DAYNAME(d.datupisa)
		else DAYNAME(i.datpolaganja)
	end "Naziv dana"
from da.dosije d join da.upisankurs uk
		on uk.indeks = d.indeks
	join da.predmet p
		on p.id = uk.idpredmeta
	join da.ispit i
		on i.idpredmeta = p.id
	join da.studijskiprogram sp
		on sp.id = d.idprograma
where d.idstatusa = 1 and 4 < (
	select count(*)
	from da.upisankurs uk 
	where uk.indeks = d.indeks and uk.idpredmeta = p.id
	group by idpredmeta
)
or 5 < (
	select count(*)
	from da.upisankurs uk 
	where uk.indeks = d.indeks and uk.idpredmeta = p.id
	group by idpredmeta
)