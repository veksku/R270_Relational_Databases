--  1. (8п) Написати упит коjим се издваjаjу студенти основних коjи су факултет уписали 2015, 2017. или 2019.
--  године, а рођени су у месту чиjи назив садржи бар две речи. Потребно jе издвоjити назив студиjског
--  програма на ком студент студира (колона смер), индекс (колона индекс), име и презиме раздвоjено
--  размаком (колона име) и колону порука. Уколико студент ниjе дипломирао, колона порука садржи
--  вредност „Ниjе дипломирао“, а уколико jе дипломирао, исписати „Дипломирао пре <броj година коjи
--  jе прошао од дипломирања> година“.

select sp.naziv smer, d.indeks indeks, d.ime || ' ' || d.prezime ime,
    case when d.datdiplomiranja is null then 'Nije diplomirao'
    else 'Diplomirao pre ' || year(current_date - date(d.DATDIPLOMIRANJA)) || ' godina' end poruka
from da.dosije d join da.STUDIJSKIPROGRAM sp
    on d.IDPROGRAMA = sp.ID
where year(d.DATUPISA) in (2015, 2017, 2019) and d.MESTORODJENJA like '% %' and sp.IDNIVOA=1;

--  2. (12п) Написати упит коjим се за сваку школску годину издваjаjу предмети коjе jе те године уписало
--  наjвише или наjмање студената (ред за наjвише и ред за наjмање). Потребно jе издвоjити школску
--  годину (колона година), назив предмета (колона предмет), броj студената коjи jе те године уписао
--  таj предмет (колона броj студената) и колону коментар. Уколико jе ред за наjмање студената колона
--  коментар треба да садржи Najmanje studenata, а ако за наjвише треба да саджи Najvise studenata.
--  Сортирати по броjу студената опадаjуће и школскоj години растуће.

with
broj_studenata (skgodina, idpredmeta, broj) as (
    select uk.skgodina, p.id, count(*)
    from da.PREDMET p join da.UPISANKURS uk
        on p.id = uk.IDPREDMETA
    group by uk.skgodina, p.id
)
select bs1.skgodina godina, p1.naziv predmet, bs1.broj "Broj studenata", 'Najvise studenata' komentar
from da.predmet p1 join broj_studenata bs1
    on p1.ID = bs1.idpredmeta
where not exists (
    select *
    from da.predmet p2 join broj_studenata bs2
        on p2.id = bs2.idpredmeta
    where p2.id <> p1.id and bs2.skgodina = bs1.skgodina and
          bs2.broj > bs1.broj
)
union
select bs1.skgodina godina, p1.naziv predmet, bs1.broj "broj studenata", 'Najmanje studenata' komentar
from da.predmet p1 join broj_studenata bs1
    on p1.ID = bs1.idpredmeta
where not exists (
    select *
    from da.predmet p2 join broj_studenata bs2
        on p2.id = bs2.idpredmeta
    where p2.id <> p1.id and bs2.skgodina = bs1.skgodina and
          bs2.broj < bs1.broj
)
order by 3 desc, 1 asc;

--  3. (a) (3п) Написати упит коjим се креира табела Dodatni_poeni, са следећим колонама:
--  • indeks– цео броj, примарни кључ
--  • ukupni_poeni– цео броj, подразумевано 0
--  • espb_poeni– цео броj
--  • dodatni_poeni– цео броj, подразумевано 0
--  • diplomirao_u_roku– истинитосна вредност

drop table if exists Dodatni_poeni;

create table Dodatni_poeni (
    indeks integer not null primary key,
    ukupni_poeni integer default 0,
    espb_poeni integer,
    dodatni_poeni integer default 0,
    diplomirao_u_roku boolean
);

--  (b) (4п) У табелу из претходне тачке унети податке о свим студентима коjи су дипломирали. Унети
--  индекс, броj положених ESPB бодова и да ли jе студент дипломирао у року. Студент jе дипломирао
--  у року ако jе дипломирао за 4 или мање година.

insert into Dodatni_poeni(indeks, espb_poeni, diplomirao_u_roku)
select d.indeks, sum(p.espb),
       case when year(d.datdiplomiranja) - year(d.datupisa) <= 4 then true
        else false end
from da.DOSIJE d join da.ispit i
        on d.indeks = i.INDEKS
    join da.PREDMET p
        on i.IDPREDMETA = p.ID
where i.STATUS = 'o' and i.OCENA > 5 and d.DATDIPLOMIRANJA is not null
group by d.indeks, d.DATDIPLOMIRANJA, d.DATUPISA; --nzm sto mora datdiplomiranja i datupisa, izbacuju error da traze group by

--  (c) (4п) Изменити редове табеле из дела под б) тако што ће се dodatni_poeni повећати за 5 ако jе
--  студент дипломирао у року и ако никад ниjе пао испи. Студент jе пао испит ако га jе регуларно
--  полагао и добио оцену 5.

update Dodatni_poeni dp
set dodatni_poeni = dodatni_poeni + 5
where diplomirao_u_roku = true and not exists(
    select *
    from da.ispit i join Dodatni_poeni dp
        on i.INDEKS = dp.indeks
    where i.STATUS = 'o' and OCENA = 5
);

--  (d) (3п) Направити окидач коjи при измени реда из дела под а) поставља броj ukupni_poeni на збир
--  ESPB поена и додатних поена.

create or replace trigger Uneti_poeni
    before update on Dodatni_poeni
        referencing new as n
    for each row
        begin atomic
            set n.ukupni_poeni = n.dodatni_poeni + n.espb_poeni;
        end;
--  (e) (3п) Написати наредбу коjом се креира функциjа IZRACUNAJ_POPUST. Аргументи су два цела броjа– цена и проценат.
--  Уколико jе проценат већи од 100, вратити дуплирану вредност цене. Ако jе проценат мањи од 0, цена се умањуjе
--  за таj проценат, иначе се увећава за проценат.

create or replace function IZRACUNAJ_POPUST (cena_in integer, procenat_in integer)
returns decimal
return case when procenat_in > 100 then 2*cena_in
    else cena_in*1.0 + (cena_in/100.0 * procenat_in)
    end;

--  (f) (3п) Обрисати табелу из дела под а), окидач из дела под d) и функциjу из дела под e)

drop table Dodatni_poeni;
drop trigger Uneti_poeni;
drop function IZRACUNAJ_POPUST;
