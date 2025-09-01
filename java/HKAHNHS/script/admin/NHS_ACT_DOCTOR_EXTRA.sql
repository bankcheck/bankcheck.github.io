create or replace FUNCTION "NHS_ACT_DOCTOR_EXTRA"
(v_action		IN VARCHAR2,
v_DOCCODE		IN DOCTOR_EXTRA.DOCCODE%TYPE,
v_SMSTEL		IN DOCTOR_EXTRA.SMSTEL%TYPE,
v_SMSTEL2		IN DOCTOR_EXTRA.SMSTEL2%TYPE,
v_DOC_CREATED_USER		IN DOCTOR_EXTRA.DOC_CREATED_USER%TYPE,
v_SMSTYPES  IN VARCHAR2,
v_OLDCODE IN VARCHAR2,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
o_errcode		NUMBER;
V_NOOFREC number;
v_EXISTSMSTYPE NUMBER;
V_ACTIVE NUMBER;
v_EXISTSMSENABLED NUMBER;
v_SMSTYPE DOCTOR_EXTRA.SMSTYPE%TYPE;

CURSOR c_smsTypeList IS
SELECT ALLTYPE.SMSTYPE,NVL(SELECTTYPE.ACTIVE,0)
FROM
(SELECT REGEXP_SUBSTR(TRIM(v_SMSTYPES),'[^,]+', 1, LEVEL) SMSTYPE,-1 ACTIVE FROM DUAL
CONNECT BY REGEXP_SUBSTR(TRIM(v_SMSTYPES), '[^,]+', 1, LEVEL) IS NOT NULL) SELECTTYPE,
(select HPKEY AS SMSTYPE,0 AS ACTIVE from HPSTATUS WHERE HPTYPE = 'DSMSTYPEC' AND HPACTIVE = -1) ALLTYPE
WHERE ALLTYPE.SMSTYPE = SELECTTYPE.SMSTYPE(+) ORDER BY 1;
  
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  select COUNT(1) into V_NOOFREC from DOCTOR_EXTRA where DOCCODE = V_DOCCODE;
  
	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO DOCTOR_EXTRA
      (
        DOCCODE,
        SMSTEL,
        SMSTEL2,
        DOC_CREATED_DATE,
        DOC_CREATED_USER,
        SMSTYPE
      ) VALUES (
        v_DOCCODE,
        v_SMSTEL,
        v_SMSTEL2,
        SYSDATE,
        v_DOC_CREATED_USER,
        V_SMSTYPE
      );
      
      -- insert new smstype    
      OPEN c_smsTypeList;
      LOOP
      FETCH c_smsTypeList INTO v_SMSTYPE,V_ACTIVE;
      EXIT WHEN c_smsTypeList%NOTFOUND;    
        INSERT INTO HPSTATUS (
        HPTYPE,
        HPKEY,
        HPSTATUS,
        HPSDATE,
        HPEDATE,
        HPRMK,
        HPCDATE,
        HPMDATE,
        HPCUSR,
        HPMUSR,
        HPACTIVE) VALUES (
        'DSMSTYPE', 
        V_DOCCODE, 
        v_SMSTYPE, 
        NULL,
        NULL,
        NULL,
        SYSDATE,
        SYSDATE,
        v_DOC_CREATED_USER,
        v_DOC_CREATED_USER,        
        -1);
      END LOOP;
      CLOSE c_smsTypeList;      
    ELSE
      UPDATE	DOCTOR_EXTRA
      SET
        SMSTEL = V_SMSTEL,
        SMSTEL2 = V_SMSTEL2,
        SMSTYPE = V_SMSTYPE
      WHERE	DOCCODE = V_DOCCODE;
    END IF; 
	ELSIF v_action = 'MOD' THEN
    IF V_NOOFREC > 0 THEN
      UPDATE	DOCTOR_EXTRA
      SET
        DOCCODE = V_DOCCODE,
        SMSTEL = V_SMSTEL,
        SMSTEL2 = V_SMSTEL2,
        SMSTYPE = V_SMSTYPE
      WHERE	DOCCODE = v_OLDCODE;
            
      -- insert new smstype    
      OPEN c_smsTypeList;
      LOOP
      FETCH c_smsTypeList INTO v_SMSTYPE,V_ACTIVE;
      EXIT WHEN c_smsTypeList%NOTFOUND; 
        SELECT COUNT(1) INTO v_EXISTSMSTYPE FROM HPSTATUS 
        WHERE HPKEY = V_DOCCODE 
        AND HPTYPE = 'DSMSTYPE' 
        AND HPSTATUS = v_SMSTYPE;
        
        IF v_EXISTSMSTYPE = 0 THEN
          INSERT INTO HPSTATUS (
          HPTYPE,
          HPKEY,
          HPSTATUS,
          HPSDATE,
          HPEDATE,
          HPRMK,
          HPCDATE,
          HPMDATE,
          HPCUSR,
          HPMUSR,
          HPACTIVE) VALUES (
          'DSMSTYPE', 
          V_DOCCODE, 
          v_SMSTYPE, 
          NULL,
          NULL,
          NULL,
          SYSDATE,
          SYSDATE,
          v_DOC_CREATED_USER,
          v_DOC_CREATED_USER,        
          V_ACTIVE);      
        ELSE
          SELECT HPACTIVE INTO v_EXISTSMSENABLED FROM HPSTATUS WHERE HPKEY = V_DOCCODE AND HPTYPE = 'DSMSTYPE' AND HPSTATUS = v_SMSTYPE;
        
          IF V_ACTIVE != v_EXISTSMSENABLED THEN
            UPDATE HPSTATUS
            SET HPACTIVE = V_ACTIVE,
            HPMDATE = SYSDATE,
            HPMUSR = v_DOC_CREATED_USER
            WHERE HPTYPE = 'DSMSTYPE'
            AND HPKEY = V_DOCCODE
            AND HPSTATUS = v_SMSTYPE;          
          END IF;
        END IF; 
      END LOOP;
      CLOSE c_smsTypeList;   
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  	  -- delete sms related fields only
      UPDATE	DOCTOR_EXTRA
      set
        SMSTEL = NULL,
        SMSTEL2 = NULL,
        SMSTYPE = NULL
      WHERE	DOCCODE = v_DOCCODE;
      
      DELETE FROM HPSTATUS WHERE hptype = 'DSMSTYPE' AND HPKEY = v_DOCCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
	RETURN o_errcode;
END NHS_ACT_DOCTOR_EXTRA;
/