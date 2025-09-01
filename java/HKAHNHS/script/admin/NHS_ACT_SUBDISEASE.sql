create or replace
FUNCTION "NHS_ACT_SUBDISEASE"
( v_action		IN VARCHAR2,
  v_SDSCODE IN VARCHAR2,
  v_SCKCODE IN VARCHAR2,
  v_SDSDESC IN VARCHAR2,
  v_SDSNEW IN VARCHAR2,
  v_SDSTABNUM IN VARCHAR2,
  v_SDSROWNUM IN VARCHAR2,
  v_SDSABB IN VARCHAR2,
  V_ISPAIRED in varchar2,
  v_OLDCODE IN VARCHAR2,
  o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode NUMBER;
  v_noOfRec NUMBER;
  L_SDSNEW NUMBER;
  L_SDSTABNUM NUMBER;
  L_SDSROWNUM NUMBER;
  L_ISPAIRED number;
  v_noOfOLDRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  L_SDSNEW := TO_NUMBER(v_SDSNEW);
  L_SDSTABNUM := TO_NUMBER(v_SDSTABNUM);
  L_SDSROWNUM := TO_NUMBER(v_SDSROWNUM);
  L_ISPAIRED := TO_NUMBER(v_ISPAIRED);

  select COUNT(1) into V_NOOFREC from SDISEASE where SDSCODE = V_SDSCODE;
  select COUNT(1) into V_NOOFOLDREC from SDISEASE where SDSCODE = V_OLDCODE;
  
	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      Insert into SDISEASE
        values
        ( v_SDSCODE,
          V_SCKCODE,
          v_SDSDESC,
          L_SDSNEW,          
          L_SDSTABNUM,
          L_SDSROWNUM,
          v_SDSABB,
          L_ISPAIRED);
   -- ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfOLDRec > 0 THEN
      UPDATE	SDISEASE
      set
          SDSCODE=v_SDSCODE,
          SCKCODE=v_SCKCODE,
          SDSNEW=L_SDSNEW,
          SDSDESC=v_SDSDESC,
          SDSTABNUM=L_SDSTABNUM,
          SDSROWNUM=L_SDSROWNUM,
          SDSABB=v_SDSABB,
          ISPAIRED=L_ISPAIRED
      where
          SDSCODE=v_OLDCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE SDISEASE WHERE SDSCODE=v_SDSCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_SUBDISEASE;
/