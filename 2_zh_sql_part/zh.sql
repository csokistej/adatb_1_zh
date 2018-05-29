--Táblák: branyi.
--HAJOS (HAZON, NEV, BESOROLAS, KOR)
--BERLES (HAZON, CSAZON, DATUM, TARTAM)
--CSONAK (CSAZON, TIPUS, SZIN)
--KEDVEZMENYH (NAPOKSZAMA, SZAZALEK)

--1. Adjuk meg, hogy a legöregebb hajós melyik nap érkezett vissza az utolsó útjáról!
select max(datum+tartam-1) from branyi.hajos natural join branyi.berles where kor = (select max(kor) from branyi.hajos) group by hazon;

--2. Adjuk meg, melyik piros színű hajók álltak a dokkban 2007.07-ik hónap vasárnapjain!
(select csazon from branyi.csonak where szin = 'piros') minus(
select csazon from branyi.berles where 
(to_date('01/07/07','DD/MM/YY') between datum and (datum+tartam-1)) or
(to_date('08/07/07','DD/MM/YY') between datum and (datum+tartam-1)) or
(to_date('15/07/07','DD/MM/YY') between datum and (datum+tartam-1)) or
(to_date('22/07/07','DD/MM/YY') between datum and (datum+tartam-1)) or
(to_date('29/07/07','DD/MM/YY') between datum and (datum+tartam-1)));

--3. Hozzon létre egy versenyzo(hazon,nev) nevű táblát a HAJOS tábla azon hajósaiból, akik béreltek már piros színű hajót!
create table versenyzo (
    hazon number(4,0),
    nev varchar2(25 BYTE)
);
--delete from versenyzo;
insert into versenyzo(hazon, nev) select distinct hazon, nev from branyi.hajos natural join branyi.berles natural join branyi.csonak where szin = 'piros';

--4. Bővítse a VERSENYZO táblát egy TISZTELETDIJ oszloppal!
alter table versenyzo add tiszteletdij integer;

--5. Töltse fel a TISZTELETDIJ oszlopot a következőképpen:
-- a. akinek a besorolása eléri a 3-ast, annak a tiszteletdíja 20000.-, de a főnöké, Bruce Ernsté 25000.-
-- b. az 1 és 2 besorolásúak közül aki 30 év alatti, az 10000,-t kap, a többiek 15000.-t kapnak
update versenyzo set tiszteletdij = 20000 where hazon in (select hazon from branyi.hajos where besorolas >= 3);

update versenyzo set tiszteletdij = 25000 where nev = 'bruce ernst';

update versenyzo set tiszteletdij = 10000 where hazon in (select hazon from branyi.hajos where (besorolas = 1 or besorolas = 2) and kor < 30);
update versenyzo set tiszteletdij = 15000 where hazon in (select hazon from branyi.hajos where (besorolas = 1 or besorolas = 2) and kor >= 30);
select * from versenyzo;

--6. Irassa ki a 2008. áprilisában kezdődő bérlések kezdődátumát, és hogy milyen típusú hajókat vittek el!
select datum, tipus from branyi.berles natural join branyi.csonak where datum between to_date('01/04/08','DD/MM/YY') and to_date('30/04/08','DD/MM/YY');

--7. Irassa ki a hajósok nevét nagy kezdőbetűvel s annyi # jelet tegyen mellé, ahány hajót bérelt összesen!
select lpad(Initcap(nev), (select count(hazon) from branyi.berles), '#') from branyi.hajos natural join branyi.berles;

--8. Kik azok, akik nem béreltek piros vagy zöld hajót?
select nev from branyi.hajos
minus
select nev from branyi.hajos natural join branyi.berles natural join branyi.csonak where szin = 'piros' or szin = 'zöld';

--9. Keressük ki azokat a hajósokat, akik fiatalabbak, mint a legöregebb 2-es besorolású hajós!
select hazon from branyi.hajos where kor < (select max(kor) from branyi.hajos where besorolas = 2);

--10. Irassa ki, melyik hajón kik (név) töltöttek a leghosszabb időt!
select csazon,hazon from berles where (max(datum)-min(datum));

--11. Ki bérelte pontosan ugyanazokat a hajókat, mint a legfiatalabb hajós!
select nev from branyi.hajos,branyi.berles,branyi.csonak where branyi.berles.csazon = branyi.csonak.csazon;


