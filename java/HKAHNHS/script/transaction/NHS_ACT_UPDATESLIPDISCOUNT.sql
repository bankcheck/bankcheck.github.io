CREATE OR REPLACE FUNCTION NHS_ACT_UPDATESLIPDISCOUNT( v_action    IN VARCHAR2,
  v_slpno     IN VARCHAR2,
  OldDoctor   IN VARCHAR2,
  NewDoctor   IN VARCHAR2,
  OldHospital IN VARCHAR2,
  NewHospital IN VARCHAR2,
  OldSpecial  IN VARCHAR2,
  NewSpecial  IN VARCHAR2,
  i_usrid	  IN VARCHAR2,
  o_errmsg		OUT VARCHAR2
) return  NUMBER AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
  rs_slip slip%ROWTYPE;
begin
   o_errcode:=0;
    o_errmsg:='OK';
  if v_action='MOD' then
      if NewDoctor is not null then
        if NewDoctor<>OldDoctor then
           o_errcode:=nhs_act_updateentrydiscount('MOD',v_slpno,OldDoctor,NewDoctor,'D',i_usrid,o_errmsg);
           if o_errcode=-1 then
             rollback;
             return o_errcode;
           end if;
        end if;
      end if;

      if NewHospital is not null then
        if NewHospital<>OldHospital then
           o_errcode:=nhs_act_updateentrydiscount('MOD',v_slpno,OldHospital,NewHospital,'H',i_usrid,o_errmsg);

            if o_errcode=-1 then
             rollback;
             return o_errcode;
           end if;
        end if;
      end if;

       if NewSpecial is not null then
        if NewSpecial<>OldSpecial then
           o_errcode:=nhs_act_updateentrydiscount('MOD',v_slpno,OldSpecial,NewSpecial,'S',i_usrid,o_errmsg);

            if o_errcode=-1 then
             rollback;
             return o_errcode;
           end if;
        end if;
      end if;

     select * into rs_slip from slip where slpno=v_slpno;

     if NewDoctor is not null then
       rs_slip.slpddisc:=to_number(NewDoctor);
     end if;
     if NewHospital is not null then
       rs_slip.slphdisc:=to_number(NewHospital);
     end if;
     if NewSpecial is not null then
       rs_slip.slpsdisc:=to_number(NewSpecial);
     end if;
     update slip set slpddisc=rs_slip.slpddisc,slphdisc=rs_slip.slphdisc,slpsdisc=rs_slip.slpsdisc
            where slpno=v_slpno;
  else
      o_errcode:=-1;
      o_errmsg:='Parameter error.';
  end if;
  return o_errcode;
end NHS_ACT_UPDATESLIPDISCOUNT;
/
