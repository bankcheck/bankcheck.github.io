create or replace
FUNCTION      NHS_LIS_IPRPTHIS(V_SLPNO VARCHAR2,V_PRNRPT VARCHAR2)

 Return Types.Cursor_Type 
 AS
  Outcur Types.Cursor_Type;
  Sqlstr Varchar2(2000);
Begin 
    sqlStr := 'SELECT '''',to_char(PRINTDATE,''dd/mm/yyyy hh24:mi''), COPY, PRNSEQ, USR
               FROM IPSTATPRINTHIST
               Where Slpno = '''||V_Slpno||'''';
    If(V_Prnrpt = 'RECEIPT') Then
      sqlStr := sqlStr || ' And Prnrpt = 4';
    Else
      sqlStr := sqlStr || ' And Prnrpt < 4';
    END IF;
      Sqlstr := Sqlstr || ' Order By Printdate Desc';
        Dbms_Output.Put_Line(Sqlstr);

  OPEN OUTCUR FOR sqlStr;   
  RETURN OUTCUR;
END NHS_LIS_IPRPTHIS;
/
