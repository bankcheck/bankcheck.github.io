create or replace
FUNCTION NHS_GET_TAH_FUNC_AUTH 
(v_SYSCODE VARCHAR2, v_FUNCCODE VARCHAR2, v_PROGID VARCHAR2, v_staffId VARCHAR2, v_computerName VARCHAR2)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
  v_userId VARCHAR2(30);
  v_funcPriorityPos NUMBER;
  v_keepLog NUMBER(1);
  v_funcPriority VARCHAR2(100);
  o_errcode NUMBER(1);
  o_errmsg VARCHAR2(1000);
  v_trackCode VARCHAR2(1000);
BEGIN
  IF v_staffId = 'MIS' AND TRIM(v_SYSCODE) <> '001' THEN 
    RETURN outcur;
  END IF;
  
  IF SUBSTR(UPPER(v_staffId),1,2) = 'AR' AND TRIM(v_SYSCODE) <> '001' THEN 
    RETURN outcur;
  END IF;
v_trackCode:='0001';
  SELECT TRIM(user_id)
  INTO v_userId
  FROM sys_user_basic@tah
  WHERE TRIM(user_alias) = v_staffId OR TRIM(user_id) = v_staffId;
v_trackCode:='0002';
  SELECT function_priority_position,keep_log
  INTO v_funcPriorityPos,v_keepLog
  FROM sys_function_basic@tah
  WHERE TRIM(system_id) = v_SYSCODE
  AND TRIM(program_id) = v_PROGID
  AND TRIM(function_id) = v_FUNCCODE;
v_trackCode:='0003';
  SELECT function_priority
  INTO v_funcPriority
  FROM sys_user_prog_priority@tah
  WHERE TRIM(system_id) = v_SYSCODE
  AND	TRIM(user_id) = v_userId
  AND	TRIM(program_id) = v_PROGID;
v_trackCode:='0004';
  IF SUBSTR(v_funcPriority,v_funcPriorityPos,1) = '1' THEN
    o_errcode := 1;  
    o_errmsg := 'VALID';
    OPEN outcur FOR
    SELECT o_errcode, o_errmsg FROM dual; 
    RETURN outcur;
  ELSE
    o_errcode := -1;  
    o_errmsg := 'INVALID';
    OPEN outcur FOR
    SELECT o_errcode, o_errmsg FROM dual;   
    RETURN outcur;
  END IF;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
  IF v_keepLog = 1 THEN
    INSERT INTO sys_login_fail_log@tah (
    OP_DATE, 
    TERMINAL, 
    USER_ID, 
    SYSTEM_ID, 
    PROGRAM_ID, 
    FUNCTION_ID)
    VALUES(  
    SYSDATE,
    v_computerName,
    v_userId,
    v_SYSCODE,
    v_PROGID,
    v_FUNCCODE);
  END IF;  
	dbms_output.put_line(SQLCODE||' -ERROR- '||SQLERRM);
  o_errcode := -1;  
  o_errmsg := '[RETURN MSG]:'||SQLERRM;
  OPEN outcur FOR 
  SELECT o_errcode, o_errmsg||v_trackCode FROM dual;
  RETURN outcur;
END NHS_GET_TAH_FUNC_AUTH;