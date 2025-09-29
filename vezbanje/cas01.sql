--1. Izdvojiti indeks, ime i prezime za svakog studenta koji je upisao fakultet.

select indeks, ime, prezime
from da.dosije;

--2. Izdvojiti sve različite vrednosti u koloni espb u tabeli predmet.

select distinct espb
from da.predmet;

--3. Izdvojiti sva ženska imena studenata.

select ime
from da.dosije
where pol = 'z';

--4. Izdvojiti podatke o ispitima koji su održani u ispitnom roku sa oznakom jan1 i na kojima je student dobio 100 poena.

select *
from da.ispit
where oznakaroka = 'jan1' and poeni = 100;

--5. Izdvojiti indekse studenata koji su na nekom ispitu dobili između 65 i 87 poena.

select distinct indeks
from da.ispit
where poeni between 65 and 87;

--6. Izdvojiti indeks i godinu upisa na fakultet za studente koji fakultet nisu upisali između 2013. i 2016. godine. Kolonu sa godinom upisa nazvati Godina upisa, a kolonu sa indeksom Student. Koristiti pretpostavkom da godina iz indeksa odgovara godini upisa na fakultet.

select indeks as "Student", year(datupisa) as "Godina upisa"
from da.dosije
where indeks not like '2013%' and indeks not like '2014%' and indeks not like '2015%' and indeks not like '2016%';

--7. Izdvojiti indeks i godinu upisa na fakultet za studente koji fakultet nisu upisali između 2013. i 2016. godine. i čije ime počinje na slovo M, treće slovo u imenu je r, a završava se na a. Rezultat urediti prema imenu studenta u rastućem poretku.

select indeks as "Student", year(datupisa) as "Godina upisa"
from da.dosije
where year(datupisa) not in (2013, 2014, 2015, 2016) and ime like 'M_r%a'
order by ime asc;

--8. Izdvojiti ime i prezime svakog studenta čije ime nije Marko, Veljko ili Ana. Rezultat urediti prema prezimenu u opadajućem poretku, a zatim prema imenu u rastućem poretku.

select ime, prezime
from da.dosije
where ime not in ('Marko', 'Veljko', 'Ana')
order by prezime desc, ime asc;




