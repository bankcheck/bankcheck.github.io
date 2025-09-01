create or replace
FUNCTION f_cts_password (
as_docCode varchar2,
ai_ctsRecordSeq varchar2)
RETURN varchar2 
IS
	ls_pwd varchar2(100);
	ls_docCode varchar2(100);
	li_len number;
  li_count number;

	CURSOR c_password IS
	select cts_no
	from cts_record;

BEGIN

FOR cts_password in c_password
LOOP
	li_len := LENGTH(as_docCode);
	ls_docCode := SUBSTR(as_docCode,2,li_len-1);
  ls_pwd := null; 
	FOR i IN REVERSE 1..li_len
	LOOP
  IF i = 2 THEN
			IF (SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2) >= 65 AND SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2) <= 90) OR
		 (SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2) >= 97 AND SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2) <= 122) THEN
				ls_pwd := ls_pwd||UPPER(CHR(SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2)));
			ELSE
				ls_pwd := ls_pwd||TO_CHAR(MOD(SUBSTR(TO_CHAR(ai_ctsRecordSeq),-2,2),7));	
			END IF;
  ELSE
      IF li_len = 1 THEN
        ls_pwd := substr(to_char(sysdate,'yyyymmddhhmissSSSSS'), -4, 4);
      ELSE
          ls_pwd := ls_pwd||MOD(SUBSTR(ls_docCode, i-1, 1), 7);
      END IF;
		END IF;
	END LOOP;
  
	IF length(trim(ls_pwd))<4 THEN
		ls_pwd := ls_pwd||substr(to_char(sysdate,'yyyymmddhhmissSSSSS'), length(trim(ls_pwd))-4, 4-length(trim(ls_pwd)));   
	END IF;
  
    SELECT COUNT(password)
    INTO li_count
    FROM cts_record
    WHERE password = ls_pwd;
  
  	EXIT WHEN li_count = 0;

END LOOP;

	RETURN ls_pwd;
EXCEPTION
WHEN OTHERS THEN
      raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
      RETURN NULL;      
END f_cts_password;