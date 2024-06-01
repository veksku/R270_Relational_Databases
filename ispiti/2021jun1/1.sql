select p.naziv, d.ime || ' ' || d.prezime "IME I PREZIME"--, pp.naziv
from da.predmet p join da.ispit i
		on i.idpredmeta = p.id
	join da.dosije d
		on d.indeks = i.indeks
where p.naziv like '__od%' and length(d.prezime) < 5 and i.status = 'o' and i.ocena > 5;
		