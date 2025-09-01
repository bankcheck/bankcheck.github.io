CREATE OR REPLACE FUNCTION NHS_ACT_INSERTMISADDR(
  v_action		IN VARCHAR2,
  v_Tabname   IN VARCHAR2,
  v_Tabid     IN VARCHAR2,
  v_Marpayee  IN VARCHAR2,
  v_Maradd1   IN VARCHAR2,
  v_Maradd2   IN VARchAR2,
  v_Maradd3   IN VARCHAR2,
  v_Marreason IN VaRCHAR2,
  v_Country   IN VARCHAR2,
  o_errmsg		OUT VARCHAR2
) return  NUMBER AS
   o_errcode	NUMBER;
   v_noOfRec  NUMBER;
   v_marid      NUMBER;
begin

  if v_action='ADD' then
    select seq_Misaddref.NEXTVAL into v_marid from dual;
    select count(1) into v_noOfRec from Misaddref where marid=v_marid;
    WHILE v_noOfRec>0 loop
      select seq_Misaddref.NEXTVAL into v_marid from dual;
      select count(1) into v_noOfRec from Misaddref where marid=v_marid;
    end loop;
    insert into Misaddref(
                       MARID,
                       TABNAME,
                       TABID,
                       MARPAYEE,
                       MARADD1,
                       MARADD2,
                       MARADD3,
                       MARREASON,
                       COUNTRY
                      )values(
                       v_marid,
                       v_Tabname,
                       to_number(v_Tabid),
                       v_Marpayee,
                       v_Maradd1,
                       v_Maradd2,
                       v_Maradd3,
                       v_Marreason,
                       v_Country
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
end NHS_ACT_INSERTMISADDR;
/
