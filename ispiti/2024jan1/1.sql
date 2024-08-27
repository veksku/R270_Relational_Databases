select d.indeks, d.ime, d.prezime, d.mestorodjenja, decimal(avg(i.ocena+0.0), 4, 2) "Prosek",
	d.ime || ' ' || d.prezime || ' (' || replace(d.mestorodjenja, 'Beograd', 'Bg') || ')'"Kod"
from da.dosije d join da.ispit i
		on d.indeks = i.indeks
where i.ocena > 5 and i.status = 'o'
	and 2 >= (
		select count(*)
		from da.ispit i1
		where i1.indeks = d.indeks and status = 'x'
	)
group by d.indeks, d.ime, d.prezime, d.mestorodjenja
