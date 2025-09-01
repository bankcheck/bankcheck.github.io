CREATE OR REPLACE FUNCTION "NHS_GET_PRTSUPPDR" (
	v_STNID VARCHAR2
)
	RETURN VARCHAR2
IS
	memAllDr VARCHAR2(2000);
	docName VARCHAR2(500);

	CURSOR c_getPrtSuppDr IS
		SELECT DISTINCT dr.docfname || ' ' || docgname AS DrName
		FROM   txnendosdtls tsl, doctor dr
		WHERE  tsl.doccode_t = dr.doccode(+)
		AND    tsl.stnid = v_STNID
		AND    tsl.usrid_c IS NULL;
BEGIN
	OPEN c_getPrtSuppDr;
	LOOP
		FETCH c_getPrtSuppDr INTO docName;
		EXIT WHEN c_getPrtSuppDr%NOTFOUND;

		IF memAllDr IS NULL OR memAllDr = '' OR LENGTH(memAllDr) <= 0 THEN
			memAllDr := docName;
		ELSIF LENGTH(docName) > 0 THEN
			memAllDr := memAllDr || ', ' || docName;
		END IF;
	END LOOP;
	CLOSE c_getPrtSuppDr;

	RETURN memAllDr;
END NHS_GET_PRTSUPPDR;
/
