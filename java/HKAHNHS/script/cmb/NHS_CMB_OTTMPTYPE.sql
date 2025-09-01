create or replace
FUNCTION "NHS_CMB_OTTMPTYPE" (
	V_DOCCODES	IN VARCHAR2
)
  RETURN Types.CURSOR_type
AS
  Outcur Types.Cursor_Type;
  Sqlstr	Varchar2(2000);
Begin
  SQLSTR := 'select ''0'' Doccode, ''General Templates'', '' '' docname from dual ';
  Sqlstr := Sqlstr || 'union ';
  SQLSTR := SQLSTR || 'select DocCode, ''Tailor Made Template - '' || DocCode || '' '' || docfname || '' '' || docgname, docfname || '' '' || docgname as docname from doctor ';
	
  If V_Doccodes Is Not Null Then
  	SQLSTR := SQLSTR || 'where DOCCODE IN (' || V_DOCCODES || ') ';
  END IF;
  SQLSTR := SQLSTR || 'order by docname';
	
   OPEN OUTCUR FOR SQLSTR;
   RETURN OUTCUR;
END NHS_CMB_OTTMPTYPE;
/


