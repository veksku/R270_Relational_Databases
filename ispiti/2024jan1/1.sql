select d.indeks, d.ime, d.prezime, d.mestorodjenja, 
	case
		when decimal(avg(ocena + 0.0), 4, 2) is null then 0.00
		else decimal(avg(ocena + 0.0), 4, 2)
	end
	prosek,
	case
		when d.mestorodjenja like '%Beograd%' then
			 d.ime || ' ' || d.prezime || ' (' || replace(d.mestorodjenja, 'Beograd', 'Bg') || ')'
		else d.ime || ' ' || d.prezime || ' (' || d.mestorodjenja || ')'
	end
	kod
from da.dosije d join da.ispit i
	on d.indeks = i.indeks
where 2 >= (
	select count(status)
	from da.ispit i
	where i.indeks = d.indeks and status='x'
)
group by d.indeks, d.ime, d.prezime, d.mestorodjenja