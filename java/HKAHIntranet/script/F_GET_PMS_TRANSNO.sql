create or replace
FUNCTION F_GET_PMS_TRANSNO (
as_repType varchar2)
RETURN varchar2 
IS
ls_seqNo NUMBER;
ls_sysYr varchar2(2);
ls_repNo varchar2(8);

BEGIN
	ls_sysYr := TO_CHAR(sysdate,'yy');	
	
	CASE as_repType
  	WHEN 'R' THEN 
  		SELECT EPO_REQ_SEQ.NEXTVAL INTO ls_seqNo FROM dual;
  	WHEN 'J' THEN 
  		SELECT EPO_PO_SEQ.NEXTVAL INTO ls_seqNo FROM dual;
  	WHEN 'S' THEN 
  		SELECT FS_REQ_SEQ.NEXTVAL INTO ls_seqNo FROM dual;        
--  WHEN 2 THEN Action2;

--  ELSE ActionOther;
	END CASE;
	
  	ls_repNo := as_repType||ls_sysYr||SUBSTR('0000'||TO_CHAR(ls_seqNo),-5,5);
	dbms_output.put_line('ls_repNo:'||ls_repNo);  	
  	
	RETURN ls_repNo;
EXCEPTION
WHEN OTHERS THEN
      raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
      RETURN NULL;      
END F_GET_PMS_TRANSNO;
/