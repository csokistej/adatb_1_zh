2. FA:
CREATE PROCEDURE Selejt(filmnev in out varchar) is
CURSOR ffazon IS SELECT fazon FROM film WHERE filnev=film.cím;
CURSOR kolcs IS SELECT kazon FROM kölcsönzés WHERE kazon=ffazon;
BEGIN
    FOR I IN kolcs LOOP
        DELETE FROM kölcsönzés WHERE kazon=I;
        DELETE FROM kazetta WHERE kazon=I;
    END LOOP;
    DELETE FROM film WHERE cím=filmnev;
END;

4.FA:
CREATE PROCEDURE TobbMintHarom is
CURSOR filmek IS SELECT fazon FROM film;
CURSOR kkazon IS SELECT kazon FROM kölcsönzés;
CURSOR osszekot IS SELECT fazon,kazon FROM kazetta;
coun number;
BEGIN
    FOR I IN filmek LOOP
        coun:=0;
        
END;