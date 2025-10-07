--  1. (8п) Написати SQL упит коjим се издваjаjу студенти на буџету са студиjског програма Математика чиjе
--  се име или презиме састоjи из више речи и коjи су полагали неки испит у петак. Издвоjити следеће
--  податке: индекс, име, презиме, назив предмета, ознаку рока и оцену добиjену на испиту коjи jе полагао
--  у петак. Колону за издваjање оцене назвати ”Оцена/Порука”. Издвоjити и студенте коjи нису полагали
--  ни jедан испит у петак − у том случаjу уместо оцене исписати поруку Ниjе полагао/ла ни jедан испит
--  петком. Резултат уредити у растући редослед према броjу индекса.

select d.indeks, d.ime, d.prezime, p.naziv, i.oznakaroka,
        case when ocena is null then 'Nije polagao/la petkom.'
           else char(ocena)
        end "Ocena/Poruka"
from da.dosije d left join da.ispit i
        on d.indeks = i.indeks and dayname(i.DATPOLAGANJA) = 'Friday' and status = 'o'
    left join da.predmet p
        on p.id = i.IDPREDMETA
where d.IDSTATUSA = 1 and d.IDPROGRAMA in (101, 201, 301)
    and (d.ime like '% %' or d.PREZIME like '% %')
order by d.INDEKS asc;

--  2. (12п) Написати SQL упит коjим се издваjаjу студенти треће године основних академских студиjа коjи
--  имаjу положено више од 90 ЕСПБ поена и jедини су на тоj години студиjа из свог места. Издвоjити
--  следеће податке: индекс, име, презиме, место рођења у облику <прво слово, последње слово> (нпр. за
--  Ужице- УЕ), назив студиjског програма и броj положених ЕСПБ.

with godine_studija(indeks,godina) as (
    select INDEKS, count(INDEKS)
    from da.UPISGODINE
    group by INDEKS
),
polozeno_espb(indeks, polozeno) as(
    select i.indeks, sum(espb)
    from da.ispit i join da.predmet p
        on i.idpredmeta = p.id
    where i.ocena > 5 and i.status='o'
    group by i.indeks
)
select d.indeks, d.ime, d.prezime, substr(d.mestorodjenja,1,1)||substr(d.MESTORODJENJA,length(d.MESTORODJENJA),1) "Mesto rodjenja", sp.NAZIV, pe.polozeno
from da.dosije d join godine_studija gs
        on d.INDEKS = gs.indeks
    join polozeno_espb pe
        on d.INDEKS = pe.indeks
    join da.STUDIJSKIPROGRAM sp
        on d.IDPROGRAMA = sp.id
where pe.polozeno > 90 and gs.godina = 3
and not exists(
    select *
    from da.dosije d1 join godine_studija gs1
        on d1.indeks = gs1.indeks
    where d1.MESTORODJENJA = d.MESTORODJENJA and gs1.godina = gs.godina and d1.INDEKS <> d.indeks
);

--  3. (20п)
--  (a) Написати SQL наредбу коjом се прави табела Studentska_organizacija коjа има наредне колоне:
--  • ID- индекс студента, примарни кључ. Додати страни кључ ка одговараjућоj табели.
--  • ime- име студента, ниска максималне дужине 50 карактера.
--  • prezime- презиме студента, ниска максималне дужине 50 карактера.
--  • tim- назив тима коjем студент припада унутар организациjе. Ниска коjа може имати jедну од
--  следећих вредности: CR, PR, HR ili IT.
--  • datum_uclanjenja_u_org- датум учлањења студента у организациjу. Вредност овог атрибута
--  мора бити позната.
--  • datum_uclanjenja_u_tim- датум учлањења студента у тренутни тим (током чланства у орга
-- низациjи могу се мењати тимови).
--  • upravni_odbor- ознака да ли jе студент члан управног одбора. Подразумевана вредност jе
--  False.

drop table if exists Studentska_organizacija;

create table Studentska_organizacija (
    id integer not null,
    ime varchar(50),
    prezime varchar(50),
    tim varchar(2) not null check (tim in ('CR', 'PR', 'HR', 'IT')),
    datum_uclanjenja_u_org date not null,
    datum_uclanjenja_u_tim date not null,
    upravni_odbor boolean default false,
    primary key (id),
    foreign key (id) references da.dosije
);

--  (b) Направити кориснички дефинисану функциjу clan_organizacije коjа у зависности од задатог
--  индекса студента:
--  • Уколико jе студент члан организациjе, враћа поруку: Student jeste clan organizacije.
--  • Уколико студент ниjе члан организациjе, враћа поруку: Student nije clan organizacije.

create function clan_organizacije(indeks_in integer)
returns varchar(200)
return case
    when indeks_in in (select id from Studentska_organizacija)
        then 'Student jeste clan organizacije.'
        else 'Student nije clan organizacije'
    end;

--  (c) Написати SQL наредбу коjом се уносе подаци о новим члановима у табелу Studentska_organizacija,
--  користећи податке из табеле dosije. Унети податке о студентима чиjе jе место рођења Нови Сад.
--  Уколико студираjу Информатику, постаjу чланови IT тима, уколико студираjу Астрономиjу и
--  астрофизику, постаjу део CR тима, уколико студираjу Математику-основне студиjе, тада постаjу
--  део HR тима, а иначе постаjу део PR тима. Као датум учлањења у организациjу поставити датум
--  уписа на факултет, а за датум учлањења у тим поставити вредност 15.3.2025.

insert into Studentska_organizacija(id, ime, prezime, tim, datum_uclanjenja_u_org, datum_uclanjenja_u_tim)
select d.indeks, d.ime, d.prezime, case when sp.naziv = 'Informatika' then 'IT'
    when sp.naziv = 'Astronomija i astrofizika' then 'CR'
    when sp.naziv = 'Matematika' and idnivoa=1 then 'HR'
    else 'PR'
end, datupisa, '15.3.2025'
from da.dosije d join da.studijskiprogram sp on d.idprograma = sp.id
where mestorodjenja = 'Novi sad';

--  (d) Написати SQL наредбу коjом се ажурирати вредности колоне upravni_odbor. Поставити вредност
--  на True за све чланове коjи су се у оквиру свог тима наjраниjе учланили у организациjу.

update Studentska_organizacija so1
set upravni_odbor = TRUE
where not exists(
    select * from Studentska_organizacija so2
    where so1.tim = so2.tim
    and so1.datum_uclanjenja_u_org > so2.datum_uclanjenja_u_org
)

--  (e) Написати SQL наредбу коjом се креира окидач prekvalifikacija, помоћу коjег се члану органи
-- зациjе дозвољава промена тима само уколико jе прошло више од 6 месеци од његовог учлањења у
--  тим. Тада вредност колоне datum_uclanjenja_u_tim поставити на тренутни датум.

create trigger prekvalifikacija before update on Studentska_organizacija
    referencing old as o new as n
    for each row begin atomic
    set n.tim = case when months_between(o.datum_uclanjenja_u_org, current_date ) < 6 then o.tim
    end;
    set n.datum_uclanjenja_u_tim = case when o.tim <> n.tim then current_date end;
end;

--  (f) Написати SQL наредбу коjом се из студентске организациjе бришу сви чланови коjи су дипломи
-- рали

delete from Studentska_organizacija
where id not in (select indeks from da.dosije where IDSTATUSA=-2)