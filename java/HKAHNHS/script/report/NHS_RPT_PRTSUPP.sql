CREATE OR REPLACE FUNCTION "NHS_RPT_PRTSUPP" (
	v_STNID IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN
	OPEN OUTCUR FOR
	SELECT
		cgy.scydesc AS suppcategorydesc,
		TO_CHAR(TX.stntdate,'dd/Mon/yyyy','NLS_DATE_LANGUAGE=AMERICAN') AS txndate,
		cde.supdesc AS suppdesc,
		dr.docfname || ' ' || docgname AS TreatByDrName,
		TX.stndesc,
		TX.stndesc1, (
		SELECT SUM(stnnamt) FROM sliptx WHERE dixref = v_STNID) AS stnnamt
	FROM txnendosdtls tsl, suppcode cde, suppcategory cgy, doctor dr, sliptx TX
	WHERE tsl.supcode = cde.supcode
	AND cde.scycode = cgy.scycode
	AND tsl.doccode_t = dr.doccode(+)
	AND tsl.stnid = TX.stnid
	AND tsl.stnid = v_STNID
	and tsl.usrid_c is null;

	RETURN OUTCUR;
END NHS_RPT_PRTSUPP;
/
