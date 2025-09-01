create or replace FUNCTION ACT_MKTEVENT (
I_ACTION IN VARCHAR2,
I_TYPE IN VARCHAR2,
I_TITLE IN VARCHAR2,
I_DESC IN VARCHAR2,
I_STIME IN VARCHAR2,
I_ETIME IN VARCHAR2,
I_SCHID IN VARCHAR2,
I_OLDEVENTID IN VARCHAR2,
I_ISRECUR IN VARCHAR2,
I_RECURWKDAY IN VARCHAR2,
I_RECURENDDATE IN VARCHAR2,
I_RECURTYPE IN VARCHAR2,
o_errmsg OUT VARCHAR2
)
RETURN NUMBER AS 
o_errcode NUMBER;
v_scheduleID CO_SCHEDULE.CO_SCHEDULE_ID%TYPE;
v_keyID NUMBER;
DAY_DIFF NUMBER;
v_sdate DATE;
v_edate DATE;
v_weekday_num NUMBER;
NOT_FOUND EXCEPTION;  
BEGIN 
SELECT DECODE(I_RECURWKDAY,'SUNDAY',1,'MONDAY',2,'TUESDAY',3,'WEDNESDAY',4,'THURSDAY',5,'FRIDAY',6,'SATURDAY',7,0) INTO v_weekday_num FROM DUAL;

IF I_ACTION = 'ADD' THEN
    IF (I_RECURWKDAY IS NOT NULL AND I_RECURENDDATE IS NOT NULL AND I_ISRECUR = 'Y' AND I_RECURTYPE = 'A') THEN
    
        SELECT TO_DATE(I_RECURENDDATE, 'DD/MM/YYYY') - TO_DATE(I_STIME, 'DD/MM/YYYY HH24:MI:SS') INTO DAY_DIFF FROM DUAL;
        FOR i In 0..DAY_DIFF
        LOOP
          v_sdate := TO_DATE(TO_CHAR(TO_DATE(I_STIME, 'DD/MM/YYYY HH24:MI:SS') + i, 'DD/MM/YYYY HH24:MI:SS'), 'DD/MM/YYYY HH24:MI:SS');
          v_edate := TO_DATE(TO_CHAR(TO_DATE(I_ETIME, 'DD/MM/YYYY HH24:MI:SS') + i, 'DD/MM/YYYY HH24:MI:SS'), 'DD/MM/YYYY HH24:MI:SS');
          
            IF I_RECURWKDAY = TO_CHAR(v_sdate, 'FMDAY','NLS_DATE_LANGUAGE = ENGLISH') THEN
               SELECT NVL(MAX(CO_SCHEDULE_ID), 0)+1 INTO v_scheduleID FROM CO_SCHEDULE WHERE CO_SITE_CODE = 'twah' AND CO_MODULE_CODE = 'eventCal' AND CO_EVENT_ID = I_TYPE ; 
               SELECT  to_number(I_TYPE||DECODE(length(v_scheduleID),1,lpad(v_scheduleID, 2, '0'),v_scheduleID)) INTO v_keyID FROM DUAL;
               
               IF v_scheduleID IS NOT NULL THEN
                    INSERT INTO CO_SCHEDULE (CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_SCHEDULE_ID,
                                             CO_SCHEDULE_DESC,CO_SCHEDULE_START,CO_SCHEDULE_END,
                                             CO_LECTURE_DESC,CO_ENABLED,CO_CREATED_DATE,CO_CREATED_USER,
                                             CO_MODIFIED_DATE,CO_MODIFIED_USER,CO_SHOWREGONLINE
                                             )
                                                VALUES 
                                                ('twah','eventCal',I_TYPE,v_scheduleID,
                                                  I_TITLE,v_sdate,v_edate,
                                                  I_DESC,1,sysdate,'system',
                                                  sysdate,'system','N');
                O_ERRCODE := v_keyID;     
                o_errmsg := 'Record INSERTED'; 
                END IF;
            END IF;
        END LOOP;
    ELSIF (I_RECURWKDAY IS NOT NULL AND I_RECURENDDATE IS NOT NULL AND I_ISRECUR = 'Y' AND I_RECURTYPE <> 'A') THEN
    
      FOR r IN (
                SELECT CASE WHEN TRIM(TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(I_STIME, 'DD/MM/YYYY HH24:MI:SS'),'MM'),(LEVEL-1)),'DAY','NLS_DATE_LANGUAGE = ENGLISH')) = I_RECURWKDAY
                            THEN ADD_MONTHS(TRUNC(TO_DATE(I_STIME, 'DD/MM/YYYY HH24:MI:SS'),'MM'),(LEVEL-1))+(TO_NUMBER(I_RECURTYPE)*7)
                       ELSE NEXT_DAY(ADD_MONTHS(TRUNC(TO_DATE(I_STIME, 'DD/MM/YYYY HH24:MI:SS'),'MM'),(LEVEL-1)),v_weekday_num)+(TO_NUMBER(I_RECURTYPE)*7)
                       END AS rday --+0 1st +7 2nd +14 3rd 
--                                   --if 1st day the weekday,then use first day to add, else use 1st day of month to find first weekday then count
          FROM DUAL
          CONNECT BY LEVEL <= (MONTHS_BETWEEN(TO_DATE(I_RECURENDDATE, 'DD/MM/YYYY'),TO_DATE(I_STIME, 'DD/MM/YYYY HH24:MI:SS'))+1)
      ) LOOP
      
            v_sdate :=  TO_DATE(TO_CHAR(r.rday,'dd/mm/yyyy')||' '|| TO_CHAR(TO_DATE(I_STIME, 'DD/MM/YYYY HH24:MI:SS'),'HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS');
            v_edate :=  TO_DATE(TO_CHAR(r.rday,'dd/mm/yyyy')||' '|| TO_CHAR(TO_DATE(I_ETIME, 'DD/MM/YYYY HH24:MI:SS'),'HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS');
            
          SELECT NVL(MAX(CO_SCHEDULE_ID), 0)+1 INTO v_scheduleID FROM CO_SCHEDULE WHERE CO_SITE_CODE = 'twah' AND CO_MODULE_CODE = 'eventCal' AND CO_EVENT_ID = I_TYPE ; 
               SELECT  to_number(I_TYPE||DECODE(length(v_scheduleID),1,lpad(v_scheduleID, 2, '0'),v_scheduleID)) INTO v_keyID FROM DUAL;
    
               IF v_scheduleID IS NOT NULL THEN
                    INSERT INTO CO_SCHEDULE (CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_SCHEDULE_ID,
                                             CO_SCHEDULE_DESC,CO_SCHEDULE_START,CO_SCHEDULE_END,
                                             CO_LECTURE_DESC,CO_ENABLED,CO_CREATED_DATE,CO_CREATED_USER,
                                             CO_MODIFIED_DATE,CO_MODIFIED_USER,CO_SHOWREGONLINE
                                             )
                                                VALUES 
                                                ('twah','eventCal',I_TYPE,v_scheduleID,
                                                  I_TITLE,v_sdate,v_edate,
                                                  I_DESC,1,sysdate,'system',
                                                  sysdate,'system','N');
                O_ERRCODE := v_keyID;     
                o_errmsg := 'Record INSERTED'; 
                END IF;
      END LOOP;
      
    ELSE
          SELECT NVL(MAX(CO_SCHEDULE_ID), 0)+1 INTO v_scheduleID FROM CO_SCHEDULE WHERE CO_SITE_CODE = 'twah' AND CO_MODULE_CODE = 'eventCal' AND CO_EVENT_ID = I_TYPE ;  
         SELECT  to_number(I_TYPE||DECODE(length(v_scheduleID),1,lpad(v_scheduleID, 2, '0'),v_scheduleID)) INTO v_keyID FROM DUAL;
    
          IF v_scheduleID IS NOT NULL THEN
              INSERT INTO CO_SCHEDULE (CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_SCHEDULE_ID,
                                       CO_SCHEDULE_DESC,CO_SCHEDULE_START,CO_SCHEDULE_END,
                                       CO_LECTURE_DESC,CO_ENABLED,CO_CREATED_DATE,CO_CREATED_USER,
                                       CO_MODIFIED_DATE,CO_MODIFIED_USER,CO_SHOWREGONLINE
                                       )
                                          VALUES 
                                          ('twah','eventCal',I_TYPE,v_scheduleID,
                                            I_TITLE,TO_DATE(I_STIME,'dd/MM/YYYY HH24:MI:SS'),TO_DATE(I_ETIME,'dd/MM/YYYY HH24:MI:SS'),
                                            I_DESC,1,sysdate,'system',
                                            sysdate,'system','N');
          O_ERRCODE := v_keyID;     
          o_errmsg := 'Record INSERTED'; 
          END IF;
      END IF;
END IF;
IF I_ACTION = 'DEL' AND I_SCHID is not null THEN
    UPDATE CO_SCHEDULE
    SET CO_ENABLED = 0 
    WHERE  CO_MODULE_CODE = 'eventCal'
    AND CO_EVENT_ID = I_TYPE
    AND CO_SCHEDULE_ID = I_SCHID;
    
    O_ERRCODE := 0;     
    o_errmsg := 'Record DELETED'; 
END IF;

IF I_ACTION = 'MOD' AND I_SCHID is not null THEN
    UPDATE CO_SCHEDULE
    SET CO_EVENT_ID = I_TYPE,
    CO_SCHEDULE_START = TO_DATE(I_STIME,'dd/MM/YYYY HH24:MI:SS'),
    CO_SCHEDULE_END = TO_DATE(I_ETIME,'dd/MM/YYYY HH24:MI:SS'),
    CO_SCHEDULE_DESC = I_TITLE,
    CO_LECTURE_DESC = I_DESC,
    CO_MODIFIED_DATE = sysdate
    WHERE  CO_MODULE_CODE = 'eventCal'
    AND CO_EVENT_ID = I_OLDEVENTID
    AND CO_SCHEDULE_ID = I_SCHID;
       SELECT  to_number(I_TYPE||DECODE(length(I_SCHID),1,lpad(I_SCHID, 2, '0'),I_SCHID)) INTO v_keyID FROM DUAL;

          O_ERRCODE := v_keyID;     
      o_errmsg := 'Record UPDATED'; 
--      END IF;
END IF;
RETURN o_errcode;  
EXCEPTION 
WHEN NOT_FOUND THEN
	ROLLBACK;
  O_ERRCODE := -1;
  o_errmsg := 'NO SUCH SCHEDULE';
  RETURN o_errcode;  
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line(SQLCODE||' -ERROR- '||SQLERRM);
  o_errcode := -1;  
  o_errmsg := '[RETURN MSG]:'||SQLERRM;
  RETURN O_ERRCODE;
END ACT_MKTEVENT;
/
