CREATE OR REPLACE FUNCTION NHS_ACT_ADDCASHIER(
  v_action		IN VARCHAR2,
  v_CtxID     IN VARCHAR2,
  v_CshCode   IN VARCHAR2,
  v_CtxSNo    IN VARCHAR2,
  v_CtxType   IN VARCHAR2,
  v_CtxMeth   IN VARchAR2,
  v_CtxAmt    IN VARCHAR2,
  v_CtxName   IN VaRCHAR2,
  v_CtxDesc   IN VARCHAR2,
  v_CtxCDate  IN VARCHAR2,
  v_CtxTDate  IN VARCHAR2,
  v_CshSID    IN VARCHAR2,
  v_CtxSts    IN VARchAR2,
  v_CtnID     IN VARCHAR2,
  v_CtxCat    IN VaRCHAR2,
  v_SteCode   IN VARCHAR2,
  v_SlpNo     IN VARCHAR2,
  o_errmsg		OUT VARCHAR2
) return  NUMBER AS
   o_errcode	NUMBER;
   v_noOfRec  NUMBER;
   v_marid    NUMBER;
   CtxCDate   Date;
   CtxTDATE   Date;
begin
  if v_CtxCDate is null then
    CtxCDate:=null;
  else
    if length(v_CtxCDate)>10 then
     CtxCDate:=to_date(v_CtxCDate,'dd/mm/yyyy hh24:mi:ss');
    else
     CtxCDate:=to_date(v_CtxCDate,'dd/mm/yyyy');
    end if;
  end if;
  if v_CtxTDate is null then
    CtxTDate:=null;
  else
    if length(v_CtxTDate)>10 then
     CtxTDate:=to_date(v_CtxTDate,'dd/mm/yyyy hh24:mi:ss');
    else
     CtxTDate:=to_date(v_CtxTDate,'dd/mm/yyyy');
    end if;
  end if;
  if v_action='ADD' then

    insert into CashTx(
                       CTXID  ,
                       CSHCODE,
                       CTXSNO ,
                       CTXTYPE,
                       CTXMETH,
                       CTXAMT ,
                       CTXNAME,
                       CTXDESC,
                       CTXCDATE,
                       CTXTDATE,
                       CSHSID  ,
                       CTXSTS  ,
                       CTNID   ,
                       CTXCAT  ,
                       SLPNO   ,
                       STECODE
                      )values(
                       to_number(v_CtxID),
                       v_CshCode,
                       v_CtxSNo,
                       v_CtxType,
                       v_CtxMeth,
                       to_number(v_CtxAmt),
                       v_CtxName,
                       v_CtxDesc,
                       CtxCDate,
                       CtxTDate,
                       to_number(v_CshSID),
                       v_CtxSts,
                       to_number(v_CtnID),
                       v_CtxCat,
                       v_SlpNo,
                       v_SteCode
                      );
                      if SQL%ROWCOUNT=1 then
                         o_errcode := 0;
                         o_errmsg := 'OK';
                       else
                         rollback;
                         o_errcode := -1;
                         o_errmsg := 'Insert Fail';
                      end if;
     end if;
  return o_errcode;
end NHS_ACT_ADDCASHIER;
/
