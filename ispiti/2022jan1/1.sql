select d.indeks, d.ime, d.prezime,
	coalesce(substring(p.naziv, 1, 2) || substring(p.naziv, length(p.naziv)-1), 'nema') "Kod"
from da.dosije d join da.studentskistatus ss
		on d.idstatusa = ss.id
	left join da.ispit i
		on i.indeks = d.indeks and i.ocena > 5 and i.status='o'
			and ss.studira = 1 and i.datpolaganja > current_date - 3 YEARS - 9 MONTHS
	left join da.predmet p
		on p.id=i.idpredmeta
where not exists (
	select *
	from da.ispit i1
	where i1.indeks = d.indeks and i1.status='x'
);