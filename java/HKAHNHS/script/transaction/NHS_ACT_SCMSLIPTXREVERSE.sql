CREATE OR REPLACE FUNCTION "NHS_ACT_SCMSLIPTXREVERSE" (
 v_action	   IN VARCHAR2,
 v_stnid     IN VARCHAR2,
 v_stntype   IN VARCHAR2,
 o_errmsg		OUT VARCHAR2
)RETURN NUMBER
AS
 o_errcode		NUMBER;
 v_noOfRec    NUMBER;
 outcur       types.cursor_type;
 sqlbuf       VARCHAR2(500);
 v_sydid     NUMBER;

BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  if v_stntype='A' then--SLIPTX_TYPE_PAYMENT_A
    sqlbuf:='select syd.sydid from sliptx tx, artx d, artx c, specomdtl syd where tx.stnid ='||to_number(v_stnid);
    sqlbuf:=sqlbuf||' and tx.stnxref = d.atxid and d.atxid = c.atxrefid and c.arpid is not null and c.atxsts =''N''';--N ARTX_STATUS_NORMAL
    sqlbuf:=sqlbuf||'  and tx.stntype = syd.stntype and and c.atxid = syd.payref ';
  elsif  v_stntype='S' or v_stntype='C' then--SLIPTX_TYPE_PAYMENT_C or SLIPTX_TYPE_CREDIT
     sqlbuf:= 'select syd.sydid from specomdtl syd where syd.stntype ='''||v_stntype||'''';
     sqlbuf:=sqlbuf||' and syd.payref ='||to_number(v_stnid);---select stnxref from sliptx where stnid = to_number(v_stnid)
  elsif v_stntype='D'  then--SLIPTX_TYPE_DEBIT
    sqlbuf:='select syd.sydid from specomdtl syd where syd.stnid ='||to_number(v_stnid);
  else
    RETURN o_errcode;
  end if;
   sqlbuf:= sqlbuf||' and syd.sydsts in (''N'',''A'')';    ----SLIP_PAYMENT_USER_ALLOCATE(N),SLIP_PAYMENT_AUTO_ALLOCATE(A)
  open outcur for sqlbuf;
  fetch outcur into v_sydid;
  LOOP
    EXIT WHEN outcur%NOTFOUND or o_errcode=-1;
     o_errcode:=NHS_ACT_SCMREVERSE('ADD',to_char(v_sydid),'','1',o_errmsg);
     fetch outcur into v_sydid;
     if o_errcode=-1 then
       rollback;
       RETURN o_errcode;
   end if;
   END LOOP;


  RETURN o_errcode;
end NHS_ACT_SCMSLIPTXREVERSE;
/
