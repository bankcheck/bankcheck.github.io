create or replace
FUNCTION "NHS_ACT_DHBIRTHUNCONFIRM"(V_ACTION  IN VARCHAR2,
                                    V_USER    IN VARCHAR2,
                                    v_DHSENDQUEUE IN DHSENDQUEUE_TAB,                                    
                                    O_ERRMSG  OUT VARCHAR2)

 RETURN NUMBER AS
  O_ERRCODE NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  FOR I IN 1..v_DHSENDQUEUE.COUNT LOOP
    IF v_DHSENDQUEUE(I).CHKBOXVAL = 'Y' THEN
      UPDATE DHBIRTHDTL
      SET RECSTATUS = 'N', 
          CONFIRMBY = NULL, 
          CONFIRMDATE = NULL
      WHERE BBPATNO = v_DHSENDQUEUE(I).BBPATNO;      
  
      INSERT INTO DHBIRTHHISTORY
      VALUES
        (SEQ_DHHISTORY.NEXTVAL,
         v_DHSENDQUEUE(I).BBPATNO,
         'Un-confirm',
         V_USER,
         SYSDATE,
         NULL,
         NULL);      
    END IF;
  END LOOP;    
  RETURN O_ERRCODE;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := substr(SQLERRM, 1, 200);
	ROLLBACK;
	RETURN o_errcode;  
END NHS_ACT_DHBIRTHUNCONFIRM;
/