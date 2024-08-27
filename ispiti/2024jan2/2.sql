select distinct d.indeks, d.ime || ' ' || d.prezime "Ime i prezime",
	case
		when d.idstatusa = 1 then sp.naziv
		else p.naziv || ' ' || isnull(i.ocena, 5)
	end "Komentar",
	case
		when d.idstatusa = 1 then dayname(d.datupisa)
		else dayname(i.datpolaganja)
	end "Naziv dana"
from da.dosije d join da.ispit i
		on d.indeks = i.indeks
	join da.predmet p
		on p.id = i.idpredmeta
	join da.studijskiprogram sp
		on sp.id = d.idprograma
where d.idstatusa = 1
	and 4 < (
		select count(*)
		from da.upisankurs uk
		where uk.indeks = d.indeks and uk.idpredmeta = p.id
		group by idpredmeta
	)
	or 5 = (
		select count(*)
		from da.upisankurs uk
		where uk.indeks = d.indeks and uk.idpredmeta = p.id
		group by idpredmeta
	)
