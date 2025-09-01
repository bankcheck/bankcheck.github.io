create or replace FUNCTION "NHS_ACT_SCHEDULE_DETAILS" (
	i_action   IN VARCHAR2,
	i_SchID    IN VARCHAR2,
  i_docCode  IN VARCHAR2,
	i_SchSDate IN VARCHAR2,
	i_SchEDate IN VARCHAR2,
  v_weekDay  IN VARCHAR2,
  i_Remark   IN VARCHAR2,
  i_Location IN VARCHAR2,
	i_usrid    IN VARCHAR2,
	o_errmsg   OUT VARCHAR2)
RETURN  NUMBER
AS
	o_errcode0 NUMBER;
  o_errcode1 NUMBER;
	v_SchSDate DATE;
	v_SchEDate DATE;
	v_Scheduleid NUMBER;
	v_StartTime DATE;
	v_Endtime DATE;
  extraCount NUMBER;
  v_errcode NUMBER;
BEGIN
	o_errcode0 := 0;

	o_errmsg := 'OK';


IF LENGTH(i_SchID) > 0 THEN
    v_Scheduleid := TO_NUMBER(i_SchID);
	SELECT count(1) INTO o_errcode1 FROM SCHEDULE WHERE SchID = v_Scheduleid;
    if o_errcode1 > 0 then
        SELECT COUNT(1) INTO extraCount FROM SCHEDULE_EXTRA WHERE SCHID = v_Scheduleid;
        IF LENGTH(TRIM(i_Remark)) > 0 THEN
        v_errcode := NHS_ACT_SYSLOG('ADD', 'SCHEDULE_DETAILS', '[Schid:'||v_Scheduleid||']', 
        '[remark]'||i_Remark, i_usrid, NULL, o_errmsg);

              UPDATE SCHEDULE SET DOCPRACTICE = i_Remark WHERE SCHID = v_Scheduleid;
        END IF;
        IF LENGTH(TRIM(i_Location))> 0 then
          IF extraCount > 0 THEN
            UPDATE SCHEDULE_EXTRA SET RMID = i_Location WHERE SCHID = v_Scheduleid;
          ELSE
            INSERT INTO SCHEDULE_EXTRA (SCHID, RMID) VALUES
            (v_Scheduleid, i_Location);          
          END IF;
        END IF;
    END IF;
  v_errcode := NHS_ACT_SYSLOG('ADD', 'SCHEDULE_DETAILS', '[DOCCODE:'||I_DOCCODE||']', 
  '[Date Range:'||i_SchSDate||'-'||i_SchEDate||']'||'[[remark]'||i_Remark, i_usrid, NULL, o_errmsg);
END IF;
  IF (LENGTH(i_SchSDate) > 0 AND LENGTH(i_SchEDate) > 0 AND LENGTH(I_DOCCODE) > 0) THEN
    v_SchSDate := TRIM(TO_DATE(i_SchSDate||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS'));
    v_SchEDate := TO_DATE(i_SchEDate||' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');

    FOR R IN (
        SELECT SchID, doccode
				FROM   Schedule
				WHERE schsdate  >= v_SchSDate
        and SCHEDATE  <= v_SchEDate
        and (v_weekDay is null OR TO_NUMBER(TO_CHAR(SCHSDATE, 'D')) = v_weekDay)
				AND    schsts = 'N'
				AND   (doccode = i_docCode))
      LOOP
          v_errcode := NHS_ACT_SYSLOG('ADD', 'SCHEDULE_DETAILS', '[DOCCODE:'||I_DOCCODE||']', 
          '[Date Range:'||i_SchSDate||'-'||i_SchEDate||']'||'[[remark]'||i_Remark, i_usrid, NULL, o_errmsg);
        IF LENGTH(TRIM(i_Remark)) > 0 THEN
          UPDATE SCHEDULE SET DOCPRACTICE = i_Remark WHERE SCHID = R.SCHID AND DOCCODE = R.DOCCODE;
        END IF;
        IF LENGTH(TRIM(i_Location))> 0 then
         SELECT COUNT(1) INTO extraCount FROM SCHEDULE_EXTRA WHERE SCHID = R.SCHID;
          IF extraCount > 0 THEN
            UPDATE SCHEDULE_EXTRA SET RMID = i_Location WHERE SCHID = R.SCHID;
          ELSE
            INSERT INTO SCHEDULE_EXTRA (SCHID, RMID) VALUES
            (R.SCHID, i_Location);          
          END IF;
        END IF;
      END LOOP;     
END IF;
	RETURN o_errcode1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_ACT_SCHEDULE_DETAILS;
/