CREATE OR REPLACE FUNCTION NHS_ACT_UPDATEENTRYDISCOUNT(
  v_action    IN VARCHAR2,
  v_slpno     IN VARCHAR2,
  OldDisc     IN VARCHAR2,
  NewDisc     IN VARCHAR2,
  DiscType    IN VARCHAR2,
  i_usrid     IN VARCHAR2,
  o_errmsg	  OUT VARCHAR2
) return  NUMBER AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
  v_stnid   NUMBER;
  rs_sliptx sliptx%ROWTYPE;

  captureDate DATE;
begin
    o_errcode:=0;
    o_errmsg:='OK';
  if v_action='MOD' then
     captureDate:=sysdate;
    for rs_sliptx IN (Select *   from Sliptx
                                    where SlpNo=v_slpno
                                    and StnType='D'---SLIPTX_TYPE_DEBIT
                                    and (StnSts='N' or StnSts='A')--SLIPTX_STATUS_NORMAL(N),SLIPTX_STATUS_ADJUST(A)
                                    and StnDisc=to_number(OldDisc)
                                    and ItmType=DiscType
                                    and (stncpsflag is null or stncpsflag ='S')-- SLIPTX_CPS_STA(S)
                                    ) loop
        o_errcode:=nhs_act_reverseentry('ADD',v_slpno,to_char(rs_sliptx.stnid),to_char(captureDate,'dd/mm/yyyy hh24:mi:ss'),to_char(rs_sliptx.stntdate,'dd/mm/yyyy hh24:mi:ss'),'1',i_usrid,o_errmsg);
        if o_errcode=-1 then
          rollback;
          return o_errcode;
        end if;

        o_errcode:=nhs_act_addentry(
                                         'ADD',
                                          v_slpno,
                                          rs_sliptx.itmcode,
                                          DiscType,
                                          rs_sliptx.stntype,
                                          to_char(rs_sliptx.stnoamt),
                                          to_char(rs_sliptx.stnbamt),
                                          rs_sliptx.doccode,
                                          to_char(rs_sliptx.stnrlvl),
                                          rs_sliptx.acmcode,
                                          NewDisc,
                                          rs_sliptx.pkgcode,
                                          to_char(capturedate,'dd/mm/yyyy hh24:mi:ss'),
                                          to_char(rs_sliptx.stntdate,'dd/mm/yyyy hh24:mi:ss'),
                                          rs_sliptx.stndesc,
                                          rs_sliptx.stnsts,
                                          rs_sliptx.glccode,
                                          '',
                                          '0',
                                          '',
                                          to_char(rs_sliptx.dixref),
                                          to_char(nvl(rs_sliptx.stnid,'1')),
                                          rs_sliptx.stncpsflag,
                                          '',
                                          to_char(rs_sliptx.unit),
                                          rs_sliptx.stndesc1,
                                          rs_sliptx.irefno,
                                           i_usrid,
                                          o_errmsg
                                          );

                     if o_errcode=-1 then
                        rollback;
                        return o_errcode;
                      end if;
        update sliptx set transver=(select transver from sliptx where stnid=rs_sliptx.stnid) where stnid=o_errcode;
    end loop;

  else
     o_errcode:=-1;
     o_errmsg:='Parameter error.';
  end if;

  return o_errcode;
end NHS_ACT_UPDATEENTRYDISCOUNT;
/
