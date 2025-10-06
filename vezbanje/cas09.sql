-- 1. Fakultet organizuje putovanje za studente. Puna cena putovanja je 25000 RSD.
-- Napraviti tabelu putovanje koja čuva podatke o studentima zainteresovanim za putovanje.
-- Tabela ima kolone:
--      > indeks - indeks studenta
--      > cena - cena putovanja za studenta
--      > status_placanja - status plaćanja
-- Definisati primarni ključ i strani ključ na tabelu dosije.
-- Napisati naredbu koja u tabeli putovanje postavlja ograničenja:
--      > vrednost kolone status_placanja može biti placeno, oslobodjen, neplaceno
--      > podrazumevana vrednost kolone status_placanja je neplaceno
-- Napisati naredbu koja u tabelu putovanje unosi podatke za studente koji su u 2016/2017.
-- školskoj godini položili bar polovinu upisanih ESPB u toj školskoj godini.
-- Napisati naredbu koja menja tabelu putovanje tako da sadrži prijave svih studenata koji
-- nisu diplomirali.
-- Studentima o kojima postoje podaci u tabeli putovanje ažurirati podatke
-- na sledeći način:
--      > ako je student bar na polovini položenih ispita dobio ocenu 10 oslobođen je plaćanja putovanja.
--        Postaviti cenu na 0 i status plaćanja na oslobodjen
--      > ostalim studentima izračunati cenu prema formuli: cena putovanja se umanjuje za procenat koji
--        odgovara procentu ispita koje je student položio sa ocenom 10 u odnosu na njegov br položenih ispita.
-- Za studente o kojima ne postoje podaci u tabeli putovanje uneti podatke. Uneti indeks i cenu.
-- Punu cenu putovanja umanjiti za procenat koji odgovara procentu ispita koje je student položio sa ocenom 10.
-- Napisati naredbu za brisanje tabele putovanje.

drop table if exists putovanje;

create table putovanje (
    indeks integer not null,
    cena integer default 25000,
    status_placanja varchar(50) default 'neplaceno',
    primary key (indeks),
    foreign key (indeks) references da.dosije,
    constraint vrednost_statusa check (status_placanja in ('placeno', 'oslobodjen', 'neplaceno'))
);

insert into putovanje(indeks)
with
polozeno(indeks, espb) as (
    select d.indeks, sum(espb)
    from da.dosije d join da.ispit i
            on d.indeks = i.indeks
        join da.PREDMET p
            on i.IDPREDMETA = p.ID
    where i.SKGODINA = 2016 and i.status = 'o' and i.ocena>5
    group by d.indeks
),
upisano(indeks, espb) as (
    select d.indeks, sum(espb)
    from da.dosije d join da.upisankurs uk
            on d.indeks = uk.indeks
        join da.PREDMET p
            on uk.IDPREDMETA = p.ID
    where uk.SKGODINA = 2016
    group by d.indeks
)
select d.indeks
from da.dosije d join upisano up
        on d.indeks = up.INDEKS
    join polozeno pol on pol.indeks = d.indeks
where up.ESPB/2 < pol.espb
group by d.indeks;

merge into putovanje put
using (
    select indeks
    from da.dosije
    where DATDIPLOMIRANJA is null
    ) as p
on put.INDEKS = p.INDEKS
when matched then
    delete
when not matched then
    insert
    values(p.INDEKS, 25000, 'neplaceno');

merge into putovanje put
using (
    select indeks,
    decimal(count(case when ocena=10 and status='o' then 1 else null end) * 1.0/count(*), 5, 2) procenat
    from da.ispit i
    group by indeks
    ) as p
on put.indeks = p.INDEKS
when matched and p.procenat >= 50 then
    update
    set (put.cena, put.status_placanja) = (0, 'oslobodjen')
when matched and p.procenat < 50 then
    update
    set put.cena = put.cena-(put.cena*p.procenat)
when not matched then
    insert
    values(p.INDEKS, 25000-(25000*p.procenat), 'neplaceno');

drop table putovanje;

-- 2. Napraviti okidač koji sprečava brisanje predmeta sa brojem espb bodova većim od 15.

create trigger brisanje_predmeta
before delete
on da.PREDMET
referencing old as stari
for each row
when (stari.espb in(
    select espb
    from da.predmet
    where espb>15
))
begin atomic
signal sqlstate '75000' ('nmz brises predmet sa preko 15 espb');
end;

-- trigger radi, namerno stavih 7espb da se ne bi menjala baza
insert into da.PREDMET (ID, OZNAKA, NAZIV, ESPB)
values (9999, 'ZZZZ', 'Testiramo', 7);

delete from da.PREDMET
where id=9999;

drop trigger brisanje_predmeta

-- 3. Za sve studente osnovnih studija izdvojiti pregledne podatke o količini ispunjenih obaveza.
-- Izdvojiti broj indeksa, oznaku smera, ukupan broj ESPB potrebnih za završetak studija,
-- ukupan broj ESPB iz položenih predmeta, procenat položenosti ESPB. Izveštaj urediti po procentu položenosti ESPB.

with
polozeno as (
    select i.indeks, sum(espb) polozeno_espb
    from da.ispit i join da.PREDMET p
        on i.IDPREDMETA = p.ID
    where i.ocena > 5 and i.status = 'o'
    group by i.indeks
)
select d.indeks, sp.OZNAKA, sp.OBIMESPB, p.polozeno_espb, decimal(p.polozeno_espb * 1.0 /sp.OBIMESPB, 5, 2)*100
from da.DOSIJE d join da.STUDIJSKIPROGRAM sp
    on d.IDPROGRAMA = sp.ID
    join polozeno p
        on d.INDEKS = p.INDEKS
