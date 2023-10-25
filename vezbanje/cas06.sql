--1. Za svaki smer na kome studiraju studenti pronaći studenta koji ima najviše položenih espb bodova. Izdvojiti 
--   naziv smera, indeks, ime i prezime studenta i broj položenih bodova.

--with polozeno_espb as (
--	select d.indeks, d.idprograma, sum(espb) as ukupno
--	from da.dosije d join da.priznatispit pi
--		on pi.indeks = d.indeks
--	group by d.indeks, d.idprograma
--)
--select sp.naziv, d.indeks, ime, prezime, ukupno
--from polozeno_espb pe join da.dosije d
--		on pe.indeks = d.indeks
--	join da.studijskiprogram sp
--		on d.idprograma = sp.id
--where not exists (
--	select *
--	from polozeno_espb pe1
--	where pe1.indeks <> pe.indeks and pe.idprograma = pe1.idprograma and pe1.ukupno >= pe.ukupno
--);

--2. Izdvojiti podatke o studentu koji je predmet, koji u nazivu na 4. i 5. poziciji sadrži nisku 'gr' i koji ima 
--   između 5 i 10 espb bodova, polagao dva puta u roku od 20 dana. Izdvojiti naziv predmeta, indeks studenta koji  
--   je polagao predmet i broj dana između ispita. Kolonu sa brojem dana između ispita nazvati 'Broj dana'.

--with vreme_izlaska as (
--	select i1.indeks, abs(i1.datpolaganja - i2.datpolaganja) as broj_dana --, i1.oznakaroka or1, i2.oznakaroka or2, i1.datpolaganja dp1, i2.datpolaganja dp2
--	from da.ispit i1 join da.ispit i2
--	on i1.indeks = i2.indeks and i1.oznakaroka <> i2.oznakaroka
--	where abs(i1.datpolaganja - i2.datpolaganja) < 20
--)
--select distinct p.naziv, d.indeks, broj_dana as "Broj dana" --, vi.or1, vi.or2, vi.dp1, vi.dp2
--from da.predmet p join da.ispit i
--		on p.id = i.idpredmeta
--	join da.dosije d
--		on d.indeks = i.indeks
--	join vreme_izlaska vi
--		on d.indeks = vi.indeks
--where p.espb between 5 and 10 and p.naziv like '___gr%';

--ispiti iz razlicitih rokova su istog dana lol

--3. Izdvojiti predmet koji je polagan u samo jednom ispitnom roku. Izdvojiti naziv ispitnog roka, naziv predmeta,  
--   indeks, ime i prezime studenta koji je polagao taj predmet u tom ispitnom roku.

--with trazeni_predmet as (
--	select i.oznakaroka, p.naziv, i.indeks, d.ime, d.prezime, count(i.oznakaroka) as broj_rokova
--	from da.ispit i join da.predmet p
--		on i.idpredmeta = p.id
--	join da.dosije d
--		on i.indeks = d.indeks
--	group by i.oznakaroka, p.naziv, i.indeks, d.ime, d.prezime 
--)
--select *
--from trazeni_predmet
--where broj_rokova = 1;

--4. Izdvojiti podatke o parovima studenata koji su fakultet upisali 2012, 2015. ili 2018. godine i koji su rođeni  
--   u istom mestu koje u svom nazivu sadrži podnisku 'evo' počevši od 6. pozicije. Izdvojiti indekse studenata i  
--   mesto rođenja.

--select distinct d1.indeks, d2.indeks, d1.mestorodjenja
--from da.dosije d1 join da.dosije d2
--	on d1.mestorodjenja = d2.mestorodjenja and d1.mestorodjenja like '%______evo%'
--where d1.indeks < d2.indeks and year(d1.datupisa) in (2012, 2015, 2018) and year(d2.datupisa) in (2012, 2015, 2018);

--5. Izdvojiti podatke o ispitima za koje važi da je broj dobijenih bodova na ispitu 6 puta veći od broja bodova koje  
--   nosi predmet koji je polagan na ispitu. Izdvojiti indeks, ime i prezime studenta koji je polagao ispit, naziv  
--   polaganog predmeta, bodove polaganog predmeta, naziv ispitnog roka u kome je polagan ispit i dobijenu ocenu.

--select d.indeks, d.ime, d.prezime, nazivpredmeta, poeni, espb, oznakaroka, i.ocena
--from da.ispit i join da.dosije d
--		on i.indeks = d.indeks
--	join da.priznatispit pi
--		on pi.indeks = d.indeks
--where i.poeni = 6*pi.espb
--order by poeni desc;

--6. Za svaki predmet koji je položio bar jedan student, izdvojiti naziv predmeta i indeks najboljeg studenta sa tog  
--   predmeta. Za određivanje najboljeg studenta koristiti broj bodova sa kojima je ispit položen.

--select p.naziv, i.indeks, i.poeni
--from da.predmet p join da.ispit i
--	on p.id = i.idpredmeta and i.status = 'o'
--where not exists (
--	select *
--	from da.predmet p join da.ispit i2
--		on p.id = i2.idpredmeta
--	where i2.poeni > i.poeni
--);

--7. Za studenta koji najkraće studira fakultet izdvojiti nazive predmeta koje je položio. Ukoliko student nije položio  
--   nijedan ispit umesto naziva predmeta ispisati nisku koja sadrži karakter * onoliko puta koliko ima karaktera u  
--   prezimenu studenta.





--8. Pronaći studenta koji ima najviše položenih espb bodova. Izdvojiti indeks, ime i prezime studenta i broj položenih bodova.

--with polozeno_espb as (
--	select d.indeks, sum(espb) as ukupno
--	from da.dosije d join da.priznatispit pi
--		on pi.indeks = d.indeks
--	group by d.indeks
--)
--select distinct d.indeks, d.ime, d.prezime, ukupno
--from da.dosije d join da.priznatispit pi
--		on d.indeks = pi.indeks
--	join polozeno_espb pe
--		on d.indeks = pe.indeks
--where not exists (
--	select *
--	from polozeno_espb pe2
--	where pe2.ukupno > pe.ukupno and pe2.indeks <> pe.indeks
--)

--9. Izdvojiti nazive ispitnih rokova u kojima su svi predmeti iz kojih su ispite u tom roku prijavili studenti koji su  
--   fakultet upisali u novembru ili decembru položili studenti koji su fakultet upisali u septembru ili oktobru.

--????

--10. Za svaki nivo kvalifikacije i smer sa tog nivoa izdvojiti:
--      -naziv nivoa kvalifikacija
--      -stepen studija
--      -naziv smera
--      -potreban broj položenih espb bodova da bi student diplomirao na smeru
--      -broj studenata koji su ikada upisali taj smer
--      -procenat studenata koji su diplomirali na tom smeru u odnosu na broj upisanih
--      -procenat studenata koji su se ispisali tog smera u odnosu na broj upisanih
--      -procenat studenata tog smera koji su položili bar pola espb bodova predviđenih njihovim smerom.

--????



