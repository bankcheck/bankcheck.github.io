CREATE OR REPLACE FUNCTION "NHS_ACT_MEDREC" (
	v_ACTION  IN VARCHAR2,
	v_PATNO   IN VARCHAR2,
	v_VOLUME  IN VARCHAR2,
	v_STECODE IN VARCHAR2,
	v_MRMID   IN VARCHAR2,
--	v_MRDID   IN VARCHAR2,
	v_USRID   IN VARCHAR2,
	v_MrlID_S IN VARCHAR2,
	v_MrlID_L IN VARCHAR2,
	o_ERRMSG  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_ERRCODE NUMBER;
	v_VOLCNT  NUMBER;
	v_NEWHDRID NUMBER;
	v_NEWDTLID NUMBER;
	MEDICAL_RECORD_PERMANENT VARCHAR2(1) := 'P';
BEGIN
  	o_ERRCODE := 0;
  	o_ERRMSG  := 'OK';

  	IF v_ACTION = 'ADD' THEN
    	SELECT SEQ_MEDRECHDR.NEXTVAL INTO v_NEWHDRID FROM DUAL;
    	SELECT SEQ_MEDRECDTL.NEXTVAL INTO v_NEWDTLID FROM DUAL;

    	SELECT COUNT(MRHVOLLAB) INTO v_VOLCNT
    	FROM   MEDRECHDR
    	WHERE  PATNO = v_PATNO
      	AND    MRHVOLLAB = v_VOLUME
      	AND    MRHSTS <> MEDICAL_RECORD_PERMANENT;

    	IF v_VOLCNT = 0 THEN
      		INSERT INTO MEDRECHDR (
				MRHID,
				PATNO,
				MRHVOLLAB,
				MRHSTS,
				MRMID,
				STECODE,
				MRDID,
				ISAUTOCRT
      		) VALUES (
      			v_NEWHDRID,
             	v_PATNO,
             	v_VOLUME,
             	'N',
             	v_MRMID,
             	v_STECODE,
             	v_NEWDTLID,
             	NULL
       		);

       		INSERT INTO MEDRECDTL (
				MRDID,
				MRHID,
				MRDSTS,
				MRDDDATE,
				MRDRDATE,
				MRLID_S,
				MRLID_L,
				DOCCODE,
				MRDRMK,
				USRID,
				MRLID_R,
				REQLOC
       		) VALUES (
       			v_NEWDTLID,
              	v_NEWHDRID,
              	'C',
              	SYSDATE,
              	NULL,
              	v_MrlID_S,
              	v_MrlID_L,
              	NULL,
              	NULL,
              	v_USRID,
              	NULL,
              	NULL
       		);
    	ELSE
       		o_ERRCODE := -1;
       		o_ERRMSG  := 'Volume number exists!';
    	END IF;
  	END IF;
  	RETURN o_ERRCODE;
END NHS_ACT_MEDREC;
/
