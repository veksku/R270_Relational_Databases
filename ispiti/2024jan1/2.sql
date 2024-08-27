select d.ime || ' ' || d.prezime "Ime i prezime", 
	case
		when d.pol = 'm' then 'Student je jedini iz ' || d.mestorodjenja || ' upisao ' || ug.skgodina || ' sk godinu'
		else 'Studentkinja je jedina iz ' || d.mestorodjenja || ' upisala ' || ug.skgodina || ' sk godinu'
	end "Komentar",
	days(current_date) - days(d.datupisa) "Proteklo dana"
from da.dosije d join  da.upisgodine ug
	on d.indeks = ug.indeks
where not exists(
	select d1.indeks
	from da.dosije d1 join da.upisgodine ug1
		on d1.indeks = ug1.indeks
	where d1.indeks <> d.indeks and d1.mestorodjenja = d.mestorodjenja and ug1.skgodina = ug.skgodina
)
and 5 > (
	select count(*)
	from da.ispit i
	where i.indeks = d.indeks and ocena > 5 and i.status = 'o'
	group by i.indeks
)
order by "Proteklo dana" desc
