--  1. Написати SQL упит коjим се издваjаjу студенти коjи су се исписали са Математике или Астрономиjе и
--  полагали су неки испит између 20. и 25. у месецу а прва 3 слова имена и презимена им се поклапаjу.
--  Издвоjити следеће податке: индекс, име, презиме, идентификатор предмета, назив рока и броj поена
--  освоjених на испиту коjи jе полагао у датом периоду. Колону за издваjање броjа поена назвати ”Броj
--  поена/Порука”. Издвоjити и студенте коjи нису полагали ни jедан испит у поменутом периоду − у том
--  случаjу уместо броjа поена исписати поруку Ниjе полагао/ла ни jедан испит између 20. и 25. у месецу.
--  Резултат уредити у опадаjући редослед према броjу индекса.

select distinct d.indeks, d.ime, d.prezime, i.idpredmeta, i.oznakaroka,
    case
        when i.poeni is null then 'Nije polozila'
        else char(i.poeni)
    end "Broj poena/poruka"
from da.dosije d left join da.ispit i on d.INDEKS = i.INDEKS and day(i.DATPOLAGANJA) between 20 and 25
join da.STUDENTSKISTATUS ss on d.IDSTATUSA = ss.ID and ss.NAZIV like 'Ispis%'
join da.STUDIJSKIPROGRAM sp on d.IDPROGRAMA = sp.ID and sp.NAZIV like 'Matematika%' or sp.NAZIV like 'Astronomija%'
where substr(d.IME, 1, 3) = substr(d.PREZIME, 1, 3);

--  2. Написати SQL упит коjим се издваjаjу студенти са основних студиjа коjи имаjу просек изнад 9.5 и
--  предмети коjе су уписали а током студиjа пренели у наредне године године студиjа али их никада нису
--  полагали. Издвоjити следеће податке: индекс студента у облику [<прво слово студиjског програма>] :
--  <броj из индекса> / <година из индекса>, име, презиме, назив предмета и просечну оцену студента
--  записану на 3 децимале.

with predmet(indeks, naziv) as (
    select i.indeks, p.naziv
    from da.ispit i join da.PREDMET p
        on i.IDPREDMETA = p.ID
    where not exists (
        select *
        from da.ispit i1
        where i1.IDPREDMETA = i.IDPREDMETA and i.STATUS = 'o'
    )
),
prosecna(indeks, prosek) as (
    select i.indeks, decimal(avg(i.ocena*1.0), 5, 3) prosek
    from da.ispit i
    where i.status = 'o' and ocena>5
    group by i.indeks
)
select '[<' || substr(sp.naziv, 1, 1) || '>] : <'|| substr(d.INDEKS, 5, 4) || '> /' || substr(d.indeks, 1, 4) || '>',
       d.ime, d.prezime, pr.naziv, prosek
from da.dosije d join da.STUDIJSKIPROGRAM sp
    on d.idprograma = sp.id and sp.IDNIVOA = 1
    join prosecna p
        on p.indeks = d.INDEKS
    join predmet pr
        on d.indeks = pr.indeks
where p.prosek > 9.5;

--  3. (a) Написати SQL наредбу коjом се креира табела Apsolventsko_vece, са следећим колонама:
--  • indeks- индекс студента, примарни кључ.
--  • ukupna cena- укупна цена коjу студент треба да плати. Децимална вредност.
--  • ukupno uplaceno- укупан износ коjи jе студент уплатио. Децимална вредност.
--  • status uplate- Ниска коjа садржи jедну од следећих вредности: Плаћено, Ниjе плаћено.
--  Подразумевана вредност jе Ниjе плаћено.

drop table if exists Apsolventsko_vece;

create table Apsolventsko_vece(
    indeks integer not null primary key,
    ukupna_cena decimal,
    ukupno_placeno decimal,
    status_uplate varchar(50) default 'Nije placeno'
    constraint proveri_uplatu check (status_uplate in ('Placeno', 'Nije placeno'))
);

--  (b) Написати SQL наредбу коjом се креира кориснички дефинисана функциjа ostvaren_popust. Функ
-- циjа враћа вредност између 0 и 1 коjа представља попуст коjу jе студент остварио. Уколико jе
--  студент већ дипломирао, остваруjе 50% попуста, уколико ниjе дипломирао али jе на буџету онда
--  остваруjе 10% попуста, док у осталим случаjевима не остваруjе попуст.

create or replace function ostvaren_popust(indeks_in integer)
returns decimal(3,1)
return
    (select case
        when d.datdiplomiranja is not null then 0.5
        when d.idstatusa = 1 then 0.1
        else 0
    end
    from da.dosije d
    where d.indeks = indeks_in);

--  (c) Написати SQL наредбу коjом се у табелу Apsolventsko_vece уносе подаци о студентима коjи су
--  положили барем 180 ЕСПБ. За укупну цену коjу студент треба да плати поставити вредност 6000.
--  За студенте коjи су из Ужица унети да су укупно платили 3000, а иначе унети вредност 0.

insert into Apsolventsko_vece(indeks, ukupna_cena, ukupno_placeno)
select indeks, 6000.0,
       case
           when MESTORODJENJA = 'Uzice' then 3000.0
           else 0.0
       end
from da.dosije
where 180 <= (
    select sum(p.espb)
    from da.ispit i join da.PREDMET p
        on p.id = i.IDPREDMETA
    where i.INDEKS = indeks
);

--  (d) Написати SQL наредбу коjом се креира окидач Azuriranje_statusa коjи приликом ажурирања
--  табеле Apsolventsko_vece, аутоматски ажурира статус уплате у зависности од уплаћеног износа.
--  Студент може уплатити и износ коjи jе већи од оног коjи дугуjе.

create or replace trigger Azuriranje_statusa
    before update on Apsolventsko_vece
        referencing new as n
    for each row
        begin atomic
            set n.status_uplate = case
                                    when ukupno_placeno >= ukupna_cena then 'Placeno'
                                    else 'Nije placeno'
                                  end;
        end;

--  (e) Написати SQL наредбу коjом се свим студентима коjи су се приjавили за апсолвентско вече ажу
-- рира цена коjу треба да плате у односу на остварен попуст.

update Apsolventsko_vece
set ukupna_cena = ukupna_cena * (1.0 - ostvaren_popust(indeks));

--  (f) Написати SQL наредбу коjом се креира поглед Uplatili_apsolventsko коjи приказуjе индекс, име
--  и презиме студената коjи су платили апсолвентско вече у целости. Приказати податке коjи се
--  налазе у погледу

create or replace view Uplatili_apsolventsko as
select d.indeks, d.ime, d.prezime
from da.dosije d join Apsolventsko_vece av on d.INDEKS = Av.indeks
where av.status_uplate = 'Placeno';

select * from Uplatili_apsolventsko;