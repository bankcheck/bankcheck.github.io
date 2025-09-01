create or replace FUNCTION "GET_MKTEVENT"
(
  startDate varchar2,
  endDate varchar2
)
	RETURN Types.cursor_type
AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(5000);
  sqlstr1 VARCHAR2(5000);
BEGIN

  sqlstr:='(SELECT CE.CO_SCHEDULE_ID,TO_CHAR(CE.CO_SCHEDULE_START, ''YYYY-MM-DD HH24:MI'')||'':00'' as estart, 
  TO_CHAR(CE.CO_SCHEDULE_END, ''YYYY-MM-DD HH24:MI'')||'':00''
  ,CE.CO_SCHEDULE_DESC,CE.CO_EVENT_ID,C.CO_EVENT_DESC,CE.CO_LECTURE_DESC,
  TO_CHAR(CE.CO_SCHEDULE_START, ''DD'') as attendDD,
  TO_CHAR(CE.CO_SCHEDULE_START, ''MM'') as attendMM,
  TO_CHAR(CE.CO_SCHEDULE_START, ''YYYY'') as attendYYYY,
  TO_CHAR(CE.CO_SCHEDULE_START, ''HH24'') as fromHH,
  TO_CHAR(CE.CO_SCHEDULE_START, ''MI'') as fromMI,
  TO_CHAR(CE.CO_SCHEDULE_END, ''HH24'') as toHH,
  TO_CHAR(CE.CO_SCHEDULE_END, ''MI'') as toMI,
  TO_CHAR(CE.CO_SCHEDULE_START, ''DD/MM/YYYY HH24:MI'')||'' - ''||TO_CHAR(CE.CO_SCHEDULE_END, '' HH24:MI'') as eDate,
  TO_CHAR(CE.CO_SCHEDULE_START, ''HH24:MI'') ||'' - ''|| TO_CHAR(CE.CO_SCHEDULE_END, ''HH24:MI'') as tEventDate,
  CE.CO_EVENT_ID||DECODE(length(CE.CO_SCHEDULE_ID),1,lpad(CE.CO_SCHEDULE_ID, 2, ''0''),CE.CO_SCHEDULE_ID) as docID,
  C.CO_EVENT_REMARK as color
            FROM   CO_EVENT C, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2, CO_SCHEDULE CE, CO_STAFFS S         
            WHERE  CE.CO_SITE_CODE = C.CO_SITE_CODE                                                        
            AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE                                                    
            AND    CE.CO_EVENT_ID = C.CO_EVENT_ID                                                          
            AND    CE.CO_ENABLED = 1                                                                       
            AND    CE.CO_CREATED_USER = S.CO_STAFF_ID (+)                                                       
            AND    S.CO_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE (+)                                        
            AND    C.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+)                                        
            AND    C.CO_MODULE_CODE = ''eventCal''
            and    CE.CO_ENABLED=''1''';
        if(startdate = 'today') then
          SQLSTR := SQLSTR || ' AND TO_CHAR(CE.CO_SCHEDULE_START,''dd/mm/yyyy'') = TO_CHAR(SYSDATE, ''dd/mm/yyyy'')  ';
        else 
            SQLSTR := SQLSTR || ' AND    CE.CO_SCHEDULE_START >= TO_DATE('''||startDate||' 00:00:00'', ''yyyy-mm-dd HH24:MI:SS'')
            AND    CE.CO_SCHEDULE_START <= TO_DATE('''||endDate||' 23:59:59'', ''yyyy-mm-dd HH24:MI:SS'')';
        end if;
        SQLSTR1 := 'UNION
                    SELECT 0, TO_CHAR(HOLIDAY, ''YYYY-MM-DD'')||'' 00:00:00'' as estart,
                    TO_CHAR(HOLIDAY, ''YYYY-MM-DD'')||'' 24:00:00'',
                    '''',C.CO_EVENT_ID,DESCRIPTION,'''',
                      TO_CHAR(HOLIDAY, ''DD'') as attendDD,
                      TO_CHAR(HOLIDAY, ''MM'') as attendMM,
                      TO_CHAR(HOLIDAY, ''YYYY'') as attendYYYY,
                      TO_CHAR(HOLIDAY, ''HH24'') as fromHH,
                      TO_CHAR(HOLIDAY, ''MI'') as fromMI,
                      TO_CHAR(HOLIDAY, ''HH24'') as toHH,
                      TO_CHAR(HOLIDAY, ''MI'') as toMI,
                      '''' as eDate,'''' as tEventDate,'''' as docID,C.CO_EVENT_REMARK as color
                              FROM PUBLIC_HOLIDAY@IWEB,CO_EVENT C
                              WHERE HOLIDAY >= TO_DATE(''2020-01-01 00:00:00'', ''yyyy-mm-dd HH24:MI:SS'') AND HOLIDAY <= TO_DATE(''2020-12-31 23:59:59'', ''yyyy-mm-dd HH24:MI:SS'')
                              AND ENABLED = 1
                              AND CO_EVENT_DESC=''Holiday'' and CO_MODULE_CODE = ''eventCal'') ORDER BY estart';
DBMS_OUTPUT.PUT_LINE(sqlstr||SQLSTR1);

  OPEN OUTCUR FOR sqlstr||SQLSTR1;
  RETURN OUTCUR;
END GET_MKTEVENT;