create or replace
FUNCTION "NHS_GET_DHBIRTHCOUNT"
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
		SELECT count(*), to_number(to_char(sysdate, 'dd'))
		FROM dhbirthdtl d, patient p
		WHERE d.bbpatno = p.patno
    AND d.recstatus = 'N'
    AND to_char(p.patbdate,'yyyymm')<to_char(sysdate, 'yyyymm');
  RETURN OUTCUR;
END NHS_GET_DHBIRTHCOUNT;
/