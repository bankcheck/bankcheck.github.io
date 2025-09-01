
  CREATE OR REPLACE FORCE VIEW "HKAH"."SMS_JUST_ADMIT" ("BEDCODE", "WRDCODE", "WRDNAME", "ROMCODE", "PATNO", "REGID", "PATFNAME", "SEC_DR1M", "SEC_DR1M_SMSTEL", "SEC_DR1M_SMSTEL2", "SEC_DR2M", "SEC_DR2M_SMSTEL", "SEC_DR2M_SMSTEL2", "SEC_DR3M", "SEC_DR3M_SMSTEL", "SEC_DR3M_SMSTEL2", "SEC_DR4M", "SEC_DR4M_SMSTEL", "SEC_DR4M_SMSTEL2", "SEC_DR5M", "SEC_DR5M_SMSTEL", "SEC_DR5M_SMSTEL2", "SEC_DR6M", "SEC_DR6M_SMSTEL", "SEC_DR6M_SMSTEL2", "SEC_DR7M", "SEC_DR7M_SMSTEL", "SEC_DR7M_SMSTEL2") AS 
  select
  ip.bedcode,
  w.wrdcode,
  w.wrdname,
  r.romCode,
  p.patno,
  ho.regid,
  p.patfname,
  
  case when (SEC_DR1_SMS = 'Y' and SEC_DR1_SMS_SENT is null and (de1.SMSTYPE in ('3','4'))) then ho.SEC_DR1M else null end SEC_DR1M,
  case when (SEC_DR1_SMS = 'Y' and SEC_DR1_SMS_SENT is null and (de1.SMSTYPE in ('3','4'))) then de1.smstel else null end SEC_DR1M_smstel,
  case when (SEC_DR1_SMS = 'Y' and SEC_DR1_SMS_SENT is null and (de1.SMSTYPE in ('3','4'))) then de1.smstel2 else null end SEC_DR1M_smstel2,
  --ho.SEC_DR1_SMS_SENT,
  
  case when (SEC_DR2_SMS = 'Y' and SEC_DR2_SMS_SENT is null and (de2.SMSTYPE in ('3','4'))) then ho.SEC_DR2M else null end SEC_DR2M,
  case when (SEC_DR2_SMS = 'Y' and SEC_DR2_SMS_SENT is null and (de2.SMSTYPE in ('3','4'))) then de2.smstel else null end SEC_DR2M_smstel,
  case when (SEC_DR2_SMS = 'Y' and SEC_DR2_SMS_SENT is null and (de2.SMSTYPE in ('3','4'))) then de2.smstel2 else null end SEC_DR2M_smstel2,
  --ho.SEC_DR2_SMS_SENT,
  
  case when (SEC_DR3_SMS = 'Y' and SEC_DR3_SMS_SENT is null and (de3.SMSTYPE in ('3','4'))) then ho.SEC_DR3M else null end SEC_DR3M,
  case when (SEC_DR3_SMS = 'Y' and SEC_DR3_SMS_SENT is null and (de3.SMSTYPE in ('3','4'))) then de3.smstel else null end SEC_DR3M_smstel,
  case when (SEC_DR3_SMS = 'Y' and SEC_DR3_SMS_SENT is null and (de3.SMSTYPE in ('3','4'))) then de3.smstel2 else null end SEC_DR3M_smstel2,
  --ho.SEC_DR3_SMS_SENT,
  
  case when (SEC_DR4_SMS = 'Y' and SEC_DR4_SMS_SENT is null and (de4.SMSTYPE in ('3','4'))) then ho.SEC_DR4M else null end SEC_DR4M,
  case when (SEC_DR4_SMS = 'Y' and SEC_DR4_SMS_SENT is null and (de4.SMSTYPE in ('3','4'))) then de4.smstel else null end SEC_DR4M_smstel,
  case when (SEC_DR4_SMS = 'Y' and SEC_DR4_SMS_SENT is null and (de4.SMSTYPE in ('3','4'))) then de4.smstel2 else null end SEC_DR4M_smstel2,
  --ho.SEC_DR4_SMS_SENT,
  
  case when (SEC_DR5_SMS = 'Y' and SEC_DR5_SMS_SENT is null and (de5.SMSTYPE in ('3','4'))) then ho.SEC_DR5M else null end SEC_DR5M,
  case when (SEC_DR5_SMS = 'Y' and SEC_DR5_SMS_SENT is null and (de5.SMSTYPE in ('3','4'))) then de5.smstel else null end SEC_DR5M_smstel,
  case when (SEC_DR5_SMS = 'Y' and SEC_DR5_SMS_SENT is null and (de5.SMSTYPE in ('3','4'))) then de5.smstel2 else null end SEC_DR5M_smstel2,
  --ho.SEC_DR5_SMS_SENT,
  
  case when (SEC_DR6_SMS = 'Y' and SEC_DR6_SMS_SENT is null and (de6.SMSTYPE in ('3','4'))) then ho.SEC_DR6M else null end SEC_DR6M,
  case when (SEC_DR6_SMS = 'Y' and SEC_DR6_SMS_SENT is null and (de6.SMSTYPE in ('3','4'))) then de6.smstel else null end SEC_DR6M_smstel,
  case when (SEC_DR6_SMS = 'Y' and SEC_DR6_SMS_SENT is null and (de6.SMSTYPE in ('3','4'))) then de6.smstel2 else null end SEC_DR6M_smstel2,
  --ho.SEC_DR6_SMS_SENT,
  
  case when (SEC_DR7_SMS = 'Y' and SEC_DR7_SMS_SENT is null and (de7.SMSTYPE in ('3','4'))) then ho.SEC_DR7M else null end SEC_DR7M,
  case when (SEC_DR7_SMS = 'Y' and SEC_DR7_SMS_SENT is null and (de7.SMSTYPE in ('3','4'))) then de7.smstel else null end SEC_DR7M_smstel,
  case when (SEC_DR7_SMS = 'Y' and SEC_DR7_SMS_SENT is null and (de7.SMSTYPE in ('3','4'))) then de7.smstel2 else null end SEC_DR7M_smstel2
  --ho.SEC_DR7_SMS_SENT
from
(
  select
    regid,
    create_date,
    (select nvl(mstrdoccode,doccode) from doctor@iweb where doccode = SEC_DR1) SEC_DR1M,
    SEC_DR1_SMS,
    SEC_DR1_SMS_SENT,
    (select nvl(mstrdoccode,doccode) from doctor@iweb where doccode = SEC_DR2) SEC_DR2M,
    SEC_DR2_SMS,
    SEC_DR2_SMS_SENT,
    (select nvl(mstrdoccode,doccode) from doctor@iweb where doccode = SEC_DR3) SEC_DR3M,
    SEC_DR3_SMS,
    SEC_DR3_SMS_SENT,
    (select nvl(mstrdoccode,doccode) from doctor@iweb where doccode = SEC_DR4) SEC_DR4M,
    SEC_DR4_SMS,    
    SEC_DR4_SMS_SENT,
    (select nvl(mstrdoccode,doccode) from doctor@iweb where doccode = SEC_DR5) SEC_DR5M,
    SEC_DR5_SMS,    
    SEC_DR5_SMS_SENT,
    (select nvl(mstrdoccode,doccode) from doctor@iweb where doccode = SEC_DR6) SEC_DR6M,
    SEC_DR6_SMS,
    SEC_DR6_SMS_SENT,
    (select nvl(mstrdoccode,doccode) from doctor@iweb where doccode = SEC_DR7) SEC_DR7M,
    SEC_DR7_SMS,    
    SEC_DR7_SMS_SENT
  FROM NX_HANDOVER@CIS
    left join doctor_extra@iweb de1 on SEC_DR1 = de1.doccode
    left join doctor_extra@iweb de2 on SEC_DR2 = de2.doccode
    left join doctor_extra@iweb de3 on SEC_DR3 = de3.doccode
    left join doctor_extra@iweb de4 on SEC_DR4 = de4.doccode
    left join doctor_extra@iweb de5 on SEC_DR5 = de5.doccode
    left join doctor_extra@iweb de6 on SEC_DR6 = de6.doccode
    left join doctor_extra@iweb de7 on SEC_DR7 = de7.doccode
  where 1=1
    and 
    (
      --(SEC_DR1_SMS_SENT is null) or -- TEST
      (SEC_DR1_SMS = 'Y' and SEC_DR1_SMS_SENT is null) or
      (SEC_DR2_SMS = 'Y' and SEC_DR2_SMS_SENT is null) or
      (SEC_DR3_SMS = 'Y' and SEC_DR3_SMS_SENT is null) or
      (SEC_DR4_SMS = 'Y' and SEC_DR4_SMS_SENT is null) or
      (SEC_DR5_SMS = 'Y' and SEC_DR5_SMS_SENT is null) or
      (SEC_DR6_SMS = 'Y' and SEC_DR6_SMS_SENT is null) or
      (SEC_DR7_SMS = 'Y' and SEC_DR7_SMS_SENT is null)
    )
) ho
  join reg@iweb r on ho.regid = r.regid
  join inpat@iweb ip on r.inpid = ip.inpid
  join patient@iweb p on r.patno = p.patno
  left join bed@iweb b on ip.bedcode = b.bedcode
  left join room@iweb r on b.romcode = r.romcode
  left join ward@iweb w on r.wrdcode = w.wrdcode
/*  
  left join doctor_extra@iweb de1 on ho.SEC_DR1M = de1.doccode
  left join doctor_extra@iweb de2 on ho.SEC_DR2M = de2.doccode
  left join doctor_extra@iweb de3 on ho.SEC_DR3M = de3.doccode
  left join doctor_extra@iweb de4 on ho.SEC_DR4M = de4.doccode
  left join doctor_extra@iweb de5 on ho.SEC_DR5M = de5.doccode
  left join doctor_extra@iweb de6 on ho.SEC_DR6M = de6.doccode
  left join doctor_extra@iweb de7 on ho.SEC_DR7M = de7.doccode
*/
  left join (select m.doccode,m.smstel,smstel2,h.HPSTATUS AS SMSTYPE
            from DOCTOR_EXTRA@IWEB m, HPSTATUS@IWEB h 
            where m.doccode=h.HPKEY and h.HPSTATUS in ('4') AND h.HPACTIVE = -1 and h.HPTYPE = 'DSMSTYPE') de1 on ho.SEC_DR1M = de1.doccode
  left join (select m.doccode,m.smstel,smstel2,h.HPSTATUS AS SMSTYPE
            from DOCTOR_EXTRA@IWEB m, HPSTATUS@IWEB h 
            where m.doccode=h.HPKEY and h.HPSTATUS in ('4') AND h.HPACTIVE = -1 and h.HPTYPE = 'DSMSTYPE') de2 on ho.SEC_DR2M = de2.doccode
  left join (select m.doccode,m.smstel,smstel2,h.HPSTATUS AS SMSTYPE
            from DOCTOR_EXTRA@IWEB m, HPSTATUS@IWEB h 
            where m.doccode=h.HPKEY and h.HPSTATUS in ('4') AND h.HPACTIVE = -1 and h.HPTYPE = 'DSMSTYPE') de3 on ho.SEC_DR3M = de3.doccode
  left join (select m.doccode,m.smstel,smstel2,h.HPSTATUS AS SMSTYPE
            from DOCTOR_EXTRA@IWEB m, HPSTATUS@IWEB h 
            where m.doccode=h.HPKEY and h.HPSTATUS in ('4') AND h.HPACTIVE = -1 and h.HPTYPE = 'DSMSTYPE') de4 on ho.SEC_DR4M = de4.doccode
  left join (select m.doccode,m.smstel,smstel2,h.HPSTATUS AS SMSTYPE
            from DOCTOR_EXTRA@IWEB m, HPSTATUS@IWEB h 
            where m.doccode=h.HPKEY and h.HPSTATUS in ('4') AND h.HPACTIVE = -1 and h.HPTYPE = 'DSMSTYPE') de5 on ho.SEC_DR5M = de5.doccode
  left join (select m.doccode,m.smstel,smstel2,h.HPSTATUS AS SMSTYPE
            from DOCTOR_EXTRA@IWEB m, HPSTATUS@IWEB h 
            where m.doccode=h.HPKEY and h.HPSTATUS in ('4') AND h.HPACTIVE = -1 and h.HPTYPE = 'DSMSTYPE') de6 on ho.SEC_DR6M = de6.doccode
  left join (select m.doccode,m.smstel,smstel2,h.HPSTATUS AS SMSTYPE
            from DOCTOR_EXTRA@IWEB m, HPSTATUS@IWEB h 
            where m.doccode=h.HPKEY and h.HPSTATUS in ('4') AND h.HPACTIVE = -1 and h.HPTYPE = 'DSMSTYPE') de7 on ho.SEC_DR7M = de7.doccode
order by ho.create_date;
/