CREATE OR REPLACE FUNCTION NHS_ACT_ARENTRY(
v_action		  IN VARCHAR2,
v_ArcCode     IN VARCHAR2,
v_PatNo       IN VARCHAR2,
v_SlpNo       IN VARChAR2,
v_AtxAmt      IN VARCHAR2,
v_AtxSAmt     IN VARCHAR2,
v_AtxTDate    IN VARCHAR2,
v_AtxCDate    IN VARCHAR2,
v_AtxRefID    IN VARCHAR2,
v_AtxTType    IN VARCHAR2,
v_AtxSts      IN VARCHAR2,
v_AtxDesc     IN VARCHAR2,
UsrId         IN VARCHAR2,
o_errmsg    OUT VARCHAR2
)
  RETURN NUMBER
AS
  o_errcode NUMBER;
  v_AtxID   NUMBER;
  v_noOfRec NUMBER;
  rs_ArTx   ArTx%ROWTYPE;
begin
   o_errmsg:='OK';
   o_errcode:=0;
   if v_action='ADD' then
    select seq_artx.NEXTVAL into v_AtxID from dual;
    select count(1) into v_noOfRec from artx where AtxID=v_AtxID;
    WHILE v_noOfRec>0 loop
       select seq_artx.NEXTVAL into v_AtxID from dual;
       select count(1) into v_noOfRec from artx where AtxID=v_AtxID;
    end loop;
    rs_ArTx.Atxid:=v_AtxID;
    rs_ArTx.Arccode:=v_ArcCode;
    rs_ArTx.Patno:=v_PatNo;
    rs_ArTx.Slpno:=v_SlpNo;
    rs_ArTx.Atxamt:=to_number(v_AtxAmt);
    rs_ArTx.Atxsamt:=to_number(v_AtxSAmt);
    if v_AtxTDate is null then
       rs_ArTx.Atxtdate:=sysdate;
    else
      if length(v_AtxTDate)=10 then
        rs_ArTx.Atxtdate:=to_date(v_AtxTDate,'dd/mm/yyyy');
      else
        rs_ArTx.Atxtdate:=to_date(v_AtxTDate,'dd/mm/yyyy hh24:mi:ss');
      end if;
    end if;
     if v_AtxCDate is null then
       rs_ArTx.Atxcdate:=sysdate;
    else
      if length(v_AtxCDate)=10 then
        rs_ArTx.Atxcdate:=to_date(v_AtxCDate,'dd/mm/yyyy');
      else
        rs_ArTx.Atxcdate:=to_date(v_AtxCDate,'dd/mm/yyyy hh24:mi:ss');
      end if;
    end if;
    if v_AtxRefID is not null then
       rs_ArTx.Atxrefid:=to_number(v_AtxRefID);
    end if;
       rs_ArTx.Atxttype:=v_AtxTType;
       rs_ArTx.Atxsts:=v_AtxSts;
       rs_ArTx.Atxdesc:=v_AtxDesc;
       rs_ArTx.Usrid:=UsrId;
       insert into artx(
                        ATXID ,
                        ARCCODE,
                        PATNO,
                        SLPNO,
                        ATXAMT,
                        ATXSAMT,
                        ATXTDATE,
                        ATXCDATE,
                        ATXDESC,
                        ATXTTYPE,
                        ATXREFID,
                        ATXSTS,
                        ARPID,
                        USRID
                   )values(
                        rs_ArTx.ATXID ,
                        rs_ArTx.ARCCODE,
                        rs_ArTx.PATNO,
                        rs_ArTx.SLPNO,
                        rs_ArTx.ATXAMT,
                        rs_ArTx.ATXSAMT,
                        rs_ArTx.ATXTDATE,
                        rs_ArTx.ATXCDATE,
                        rs_ArTx.ATXDESC,
                        rs_ArTx.ATXTTYPE,
                        rs_ArTx.ATXREFID,
                        rs_ArTx.ATXSTS,
                        rs_ArTx.ARPID,
                        rs_ArTx.USRID
                   );
         if SQl%rowcount=0 then
          rollback;
           o_errmsg:='Insert Fail.';
           o_errcode:=-1;
           return o_errcode;
         end if;

         update ArCode set ArcAmt = ArcAmt +to_number(v_AtxAmt),ArcUAmt = ArcUAmt + 0  where ArcCode=v_ArcCode;
         if SQl%rowcount=0 then
           rollback;
           o_errmsg:='update Fail.';
           o_errcode:=-1;
           return o_errcode;
         end if;
         o_errcode:=v_AtxID;
   else
     o_errmsg:='parameter error.';
     o_errcode:=-1;
   end if;

  return o_errcode;
end NHS_ACT_ARENTRY;
/
