create or replace
FUNCTION NHS_ACT_RECORDLOCKBED (
	i_action       IN VARCHAR2,
	i_LockType     IN VARCHAR2,
	i_LockKey      IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_usrid        IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
RETURN NUMBER AS
	o_errcode NUMBER;
	v_record NUMBER;
	v_lockusrid VARCHAR2(10);
	v_lockmac VARCHAR2(20);
  i NUMBER;
  insertSqlCode NUMBER;
  LOCKRETRYMAX NUMBER := 5;
  LOCKRETRYDELAY NUMBER := 1000;
BEGIN
	o_errmsg := 'OK';
	o_errcode := 0;
  
    SELECT count(1) 
    INTO v_record 
    FROM rlock@IWEB 
    WHERE RLKTYPE = i_LockType 
    AND RLKKEY = i_LockKey;
    
    IF v_record = 0 THEN
      RETURN 0;
    ELSE
      WHILE i <= LOCKRETRYMAX
      LOOP
        insertSqlCode := -1;
        INSERT into rlock@IWEB(
        RLKID,
        USRID,
        RLKTYPE,
        RLKKEY,
        RLKDATE,
        RLKMAC,
        STECODE
        ) VALUES (
        seq_rlock.NEXTVAL@IWEB,
        i_usrid ,
        i_LockType,
        i_LockKey,
        sysdate,
        i_ComputerName,
        GET_CURRENT_STECODE@IWEB
        );
      
      insertSqlCode := SQLCODE;
  
      SELECT count(1) 
      INTO v_record 
      FROM rlock@IWEB 
      WHERE RLKTYPE = i_LockType 
      AND RLKKEY = i_LockKey;
          
      IF v_record=0 OR insertSqlCode != 0 THEN
        DBMS_LOCK.SLEEP(dbms_random.value(0,1)*LOCKRETRYDELAY);
        i := i +1 ;
      ELSE      
        EXIT;
      END IF;
    END LOOP;
    
    IF i > LOCKRETRYMAX THEN
      RETURN 999; 
    ELSE
      RETURN 1;     
    END IF;
  END IF;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -999;
END NHS_ACT_RECORDLOCKBED;