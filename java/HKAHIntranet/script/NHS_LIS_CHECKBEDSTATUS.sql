create or replace
FUNCTION NHS_LIS_CHECKBEDSTATUS (
  v_bedStatus IN VARCHAR2, 
  v_bedCode IN VARCHAR2,
  v_sex IN VARCHAR2
)
RETURN TYPES.CURSOR_TYPE
AS
	o_errcode NUMBER;
	o_errmsg VARCHAR2(1000) := 'OK';
	v_record NUMBER;
	v_lockusrid VARCHAR2(10);
	v_lockmac VARCHAR2(20);
  ls_sex VARCHAR2(1);
  ls_bedCode VARCHAR2(8);
  ls_bedddate date;
  BED_OK NUMBER := 0;
  BED_NOT_AVAILABLE NUMBER := 1;
  BED_WRONG_SEX NUMBER := 2;
  BED_NOT_CLEAN NUMBER := 3;
  OUTCUR TYPES.CURSOR_TYPE;  
BEGIN
  BEGIN
    Select r.romsex, b.bedcode, b.bedddate 
    INTO ls_sex, ls_bedCode, ls_bedddate
    from bed@iweb b, room@iweb r
    where b.romcode = r.romcode 
    and b.bedcode = v_bedCode 
    and BedSts = v_bedStatus;
    
    IF v_sex = 'M' AND instr('MUY', ls_sex) <= 0 THEN
      o_errcode := BED_WRONG_SEX;
      o_errmsg := 'BED_WRONG_SEX';       
    ELSIF v_sex = 'F' AND instr('FUZ', ls_sex) <= 0 THEN
      o_errcode := BED_WRONG_SEX;
      o_errmsg := 'BED_WRONG_SEX';     
    ELSIF TRUNC(SYSDATE,'MI')-(ls_bedddate+45/1440)<0 THEN
      o_errcode := BED_NOT_CLEAN;
      o_errmsg := 'BED_NOT_CLEAN';
    ELSE
      o_errcode := BED_OK;    
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
    o_errcode := BED_NOT_AVAILABLE;
    o_errmsg := 'BED_NOT_AVAILABLE';
  END;
    
  OPEN OUTCUR FOR
  SELECT o_errcode,o_errmsg FROM DUAL;
  
  RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	o_errcode := -999;
  OPEN OUTCUR FOR
  SELECT o_errcode,o_errmsg FROM DUAL;
  
  RETURN OUTCUR;
END NHS_LIS_CHECKBEDSTATUS;