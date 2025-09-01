create or replace FUNCTION "NHS_CMB_DRROOM"
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
      SELECT  HPSTATUS, DECODE(HPKEY,'1','1/F-','G','G/F-','')||HPRMK FROM HPSTATUS WHERE HPTYPE = 'DRROOM' ORDER BY HPRMK1;
	RETURN outcur;
END NHS_CMB_DRROOM;
/
