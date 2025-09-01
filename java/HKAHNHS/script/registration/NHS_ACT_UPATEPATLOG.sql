create or replace FUNCTION      NHS_ACT_UPATEPATLOG (
	V_Action    In Varchar2,
	V_Patno    In Varchar2,
	V_Oldpatfname    In Varchar2,
	V_Newpatfname    In Varchar2,
  V_Oldpatgname In Varchar2,
	V_Newpatgname    In Varchar2,
  V_OldpatCname    In Varchar2,
	V_Newpatcname    In Varchar2,
  V_Oldpatdob    In Varchar2,
	V_Newpatdob    In Varchar2,
  V_Oldpatsex In Varchar2,
  V_NEWPATSEX IN VARCHAR2,
  V_Oldpatdoctype    In Varchar2,
	V_Newpatdoctype    In Varchar2,
  V_Oldpatdocid    In Varchar2,
	V_Newpatdocid    In Varchar2,
  V_OldpatdocA1type    In Varchar2,
	V_NewpatdocA1type    In Varchar2,
  V_OldpatdocA1id    In Varchar2,
	V_NewpatdocA1id    In Varchar2,
  V_OldpatdocA2type    In Varchar2,
	V_NewpatdocA2type    In Varchar2,
  V_OldpatdocA2id    In Varchar2,
	V_NewpatdocA2id    In Varchar2,
  V_Usrid In Varchar2,
  V_SECDUSRID IN VARCHAR2,
	i_ErrMsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	O_ERRCODE NUMBER;
	O_ERRMSG VARCHAR2(100);
BEGIN
	O_ERRCODE := 0;
	O_ERRMSG := 'OK';

	Insert Into PATIENT_UPDATE_LOG
  (Pulid,Patno, 
  Oldpatfname, Newpatfname, 
  Oldpatgname, Newpatgname,
  OLDPATCNAME, NEWPATCNAME,
  Oldpatbdate, Newpatbdate,
  OLDPATSEX, NEWPATSEX,
  OLDPATDOCTYPE, NEWPATDOCTYPE,
  Oldpatidno, Newpatidno,
  OLDPATDOCA1TYPE, NEWPATDOCA1TYPE,
  OLDPATA1IDNO,NEWPATA1IDNO,
  OLDPATDOCA2TYPE, NEWPATDOCA2TYPE,
  OLDPATA2IDNO,NEWPATA2IDNO, 
  USRID, SECDUSRID,PULDATE)
	Values (Seq_Patient_Update_Log.Nextval, V_Patno, 
  V_Oldpatfname, V_Newpatfname,
  V_Oldpatgname, V_Newpatgname,
  V_Oldpatcname, V_Newpatcname,
  To_Date(V_Oldpatdob,'dd/mm/yyyy'), 
  to_date(V_Newpatdob,'dd/mm/yyyy'),
  V_OLDPATSEX, V_NEWPATSEX,
  V_Oldpatdoctype, V_Newpatdoctype,
  V_Oldpatdocid, V_Newpatdocid,
  V_OldpatdocA1type, V_NewpatdocA1type,
  V_OldpatdocA1id, V_NewpatdocA1id,
  V_OldpatdocA2type, V_NewpatdocA2type,
  V_OldpatdocA2id, V_NewpatdocA2id,
  V_Usrid, V_SECDUSRID, SYSDATE);

	RETURN O_ERRCODE;
EXCEPTION
WHEN OTHERS THEN
	Rollback;
	O_ERRMSG := 'Fail to record Patient Change Log.';
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	Return O_ERRCODE;
END NHS_ACT_UPATEPATLOG;
/