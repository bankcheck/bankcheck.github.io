create or replace
FUNCTION NHS_RPT_RPTMAINBEDSMY
(
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate varchar2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
    SELECT *
    FROM (
            SELECT WARD, ROOM, ACMCODE, TYPE, NOOFBED, SUM (NOOFDAY) NOOFDAY, 'Official' as description
            From (
                  select a.wrdcode ward,a.romcode room,a.acmcode acmcode,a.bedoff type, a.days noofday, count (*) as noofbed
                  From (
                          select a.wrdcode,a.romcode,a.acmcode,a.bedoff, sum(a.days) as days
                          from (
                                SELECT r.wrdcode, b.romcode, r.acmcode, b.bedoff, count(*) as temp  ,
                                        sum(to_date(to_char(bh.bhsedate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS') - to_date(to_char(bh.bhsdate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS')) as days
                                From bedhist bh, bed b, room r, reg rg
                                Where bh.bhsdate > = to_date (v_StartDate,'DD/MM/YYYY')
                                and bh.bhsedate < to_date (v_EndDate,'DD/MM/YYYY') + 1
                                and bh.bhsedate is not null
                                AND b.bedcode= bh.bedcode
                                AND b.stecode= v_SteCode
                                AND b.romcode= r.romcode
                                and rg.regsts = 'N'
                                and rg.regtype = 'I'
                                and bh.regid = rg.regid
                                GROUP BY R.WRDCODE , B.ROMCODE, B.BEDOFF, R.ACMCODE
                                 
                                UNION
                                 
                                SELECT r.wrdcode, b.romcode, r.acmcode, b.bedoff, count(*) as temp  ,
                                       sum(to_date(v_EndDate,'DD/MM/YYYY') - to_date(to_char(bh.bhsdate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS')) as days
                                From bedhist bh, bed b, room r, reg rg
                                Where bh.bhsdate > = to_date (v_StartDate,'DD/MM/YYYY')
                                and bh.bhsdate <  to_date (v_EndDate,'DD/MM/YYYY') + 1
                                AND BH.BHSEDATE IS NULL
                                AND b.bedcode= bh.bedcode
                                AND b.stecode= v_SteCode
                                AND b.romcode= r.romcode
                                and rg.regsts = 'N'
                                and rg.regtype = 'I'
                                and bh.regid = rg.regid
                                GROUP BY R.WRDCODE , B.ROMCODE, B.BEDOFF, R.ACMCODE
                                  
                                UNION
                                  
                                SELECT r.wrdcode, b.romcode, r.acmcode, b.bedoff, count(*) as temp  ,
                                       sum(to_date( v_EndDate, 'DD-MM-YYYY') -  to_date(to_char(bh.bhsdate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS')) as days
                                From bedhist bh, bed b, room r, reg rg
                                Where bh.bhsdate > = to_date (v_StartDate,'DD/MM/YYYY')
                                and bh.bhsdate < to_date (v_EndDate,'DD/MM/YYYY') + 1
                                and bh.bhsedate >= to_date (v_EndDate,'DD/MM/YYYY') + 1
                                and bh.bhsedate is not null
                                AND b.bedcode= bh.bedcode
                                AND b.stecode= v_SteCode
                                AND b.romcode= r.romcode
                                and rg.regsts = 'N'
                                and rg.regtype = 'I'
                                and bh.regid = rg.regid
                                Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                                 
                                UNION
                                  
                                SELECT r.wrdcode, b.romcode, r.acmcode, b.bedoff, count(*) as temp  ,
                                       sum(to_date(to_char(bh.bhsedate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS') - to_date(v_StartDate, 'DD-MM-YYYY')) as days
                                FROM BEDHIST BH, BED B, ROOM R, REG RG
                                Where bh.bhsdate < to_date (v_StartDate,'DD/MM/YYYY')
                                and bh.bhsedate >= to_date (v_StartDate,'DD/MM/YYYY')
                                and bh.bhsedate < to_date (v_EndDate,'DD/MM/YYYY') + 1
                                and bh.bhsedate is not null
                                AND b.bedcode= bh.bedcode
                                AND b.stecode= v_SteCode
                                AND b.romcode= r.romcode
                                and rg.regsts = 'N'
                                and rg.regtype = 'I'
                                and bh.regid = rg.regid
                                Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                                
                                Union
      
                                SELECT r.wrdcode, b.romcode, r.acmcode, b.bedoff, count(*) as temp  ,
                                       sum(to_date( v_EndDate, 'DD-MM-YYYY') - to_date(v_StartDate,'DD/MM/YYYY')) as days
                                From bedhist bh, bed b, room r, reg rg
                                Where bh.bhsdate < to_date (v_StartDate,'DD/MM/YYYY')
                                and bh.bhsedate is null
                                AND b.bedcode= bh.bedcode
                                AND b.stecode= v_SteCode
                                AND b.romcode= r.romcode
                                and rg.regsts = 'N'
                                and rg.regtype = 'I'
                                and bh.regid = rg.regid
                                Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                                 
                                Union
      
                                SELECT r.wrdcode, b.romcode, r.acmcode, b.bedoff, count(*) as temp  ,
                                       sum(to_date( v_EndDate, 'DD-MM-YYYY') - to_date( v_StartDate, 'DD-MM-YYYY')) as days
                                From bedhist bh, bed b, room r, reg rg
                                Where bh.bhsdate < to_date (v_StartDate,'DD/MM/YYYY')
                                and bh.bhsedate >  to_date (v_EndDate,'DD/MM/YYYY')
                                and bh.bhsedate is not null
                                AND b.bedcode= bh.bedcode
                                AND b.stecode= v_SteCode
                                AND b.romcode= r.romcode
                                and rg.regsts = 'N'
                                and rg.regtype = 'I'
                                and bh.regid = rg.regid
                                Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                          ) a
                          Group By a.wrdcode , a.romcode, a.AcmCode, a.bedoff
                ) a, room r , bed b
                Where a.romcode = b.romcode
                And b.romcode = r.romcode
                Group By a.wrdcode , a.romcode, a.AcmCode, a.bedoff, a.Days
        )
        Where type <> 0
        Group By ward, room, acmcode, type, noofbed
        ORDER BY WARD, ROOM, ACMCODE, TYPE
    )
    UNION ALL
    SELECT *
    FROM (
          SELECT WARD, ROOM, ACMCODE, TYPE, NOOFBED, SUM (NOOFDAY) NOOFDAY, 'Unofficial' as description
          From (
                select a.wrdcode ward,a.romcode room,a.acmcode acmcode,a.bedoff type, a.days noofday, count (*) as noofbed
                From (
                      select a.wrdcode,a.romcode,a.acmcode,a.bedoff, sum(a.days) as days
                      from (
                            SELECT R.WRDCODE, B.ROMCODE, R.ACMCODE, B.BEDOFF, COUNT(*) AS TEMP  ,
                                   sum(to_date(to_char(bh.bhsedate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS') - to_date(to_char(bh.bhsdate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS')) as days
                            From bedhist bh, bed b, room r, reg rg
                            Where bh.bhsdate > = to_date (v_StartDate,'DD/MM/YYYY')
                            and bh.bhsedate < to_date (v_EndDate,'DD/MM/YYYY') + 1
                            and bh.bhsedate is not null
                            AND b.bedcode= bh.bedcode
                            AND b.stecode= v_SteCode
                            AND b.romcode= r.romcode
                            and rg.regsts = 'N'
                            and rg.regtype = 'I'
                            and bh.regid = rg.regid
                            Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                           
                            Union

                            SELECT R.WRDCODE, B.ROMCODE, R.ACMCODE, B.BEDOFF, COUNT(*) AS TEMP  ,
                                   sum(to_date(v_EndDate,'DD/MM/YYYY') - to_date(to_char(bh.bhsdate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS')) as days
                            From bedhist bh, bed b, room r, reg rg
                            Where bh.bhsdate > = to_date (v_StartDate,'DD/MM/YYYY')
                            and bh.bhsdate <  to_date (v_EndDate,'DD/MM/YYYY') + 1
                            and bh.bhsedate is null
                            AND b.bedcode= bh.bedcode
                            AND b.stecode= v_SteCode
                            AND b.romcode= r.romcode
                            and rg.regsts = 'N'
                            and rg.regtype = 'I'
                            AND BH.REGID = RG.REGID
                            GROUP BY R.WRDCODE , B.ROMCODE, B.BEDOFF, R.ACMCODE
                           
                            Union
                            
                            SELECT R.WRDCODE, B.ROMCODE, R.ACMCODE, B.BEDOFF, COUNT(*) AS TEMP  ,
                                   sum(to_date( v_EndDate, 'DD-MM-YYYY') -  to_date(to_char(bh.bhsdate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS')) as days
                            From bedhist bh, bed b, room r, reg rg
                            Where bh.bhsdate > = to_date (v_StartDate,'DD/MM/YYYY')
                            and bh.bhsdate < to_date (v_EndDate,'DD/MM/YYYY') + 1
                            and bh.bhsedate >= to_date (v_EndDate,'DD/MM/YYYY') + 1
                            and bh.bhsedate is not null
                            AND b.bedcode= bh.bedcode
                            AND b.stecode= v_SteCode
                            AND b.romcode= r.romcode
                            and rg.regsts = 'N'
                            and rg.regtype = 'I'
                            and bh.regid = rg.regid
                            Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                           
                            Union

                            SELECT R.WRDCODE, B.ROMCODE, R.ACMCODE, B.BEDOFF, COUNT(*) AS TEMP  ,
                                   sum(to_date(to_char(bh.bhsedate,'DD/MM/YYYY')|| ' 00:00','DD/MM/YYYY HH24:MI:SS') - to_date(v_StartDate, 'DD-MM-YYYY')) as days
                            FROM BEDHIST BH, BED B, ROOM R, REG RG
                            Where bh.bhsdate < to_date (v_StartDate,'DD/MM/YYYY')
                            and bh.bhsedate >= to_date (v_StartDate,'DD/MM/YYYY')
                            and bh.bhsedate < to_date (v_EndDate,'DD/MM/YYYY') + 1
                            and bh.bhsedate is not null
                            AND b.bedcode= bh.bedcode
                            AND b.stecode= v_SteCode
                            AND b.romcode= r.romcode
                            and rg.regsts = 'N'
                            and rg.regtype = 'I'
                            AND BH.REGID = RG.REGID
                            Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                           
                            Union

                            SELECT R.WRDCODE, B.ROMCODE, R.ACMCODE, B.BEDOFF, COUNT(*) AS TEMP  ,
                                   sum(to_date( v_EndDate, 'DD-MM-YYYY') - to_date(v_StartDate,'DD/MM/YYYY')) as days
                            From bedhist bh, bed b, room r, reg rg
                            Where bh.bhsdate < to_date (v_StartDate,'DD/MM/YYYY')
                            and bh.bhsedate is null
                            AND b.bedcode= bh.bedcode
                            AND b.stecode= v_SteCode
                            AND b.romcode= r.romcode
                            and rg.regsts = 'N'
                            and rg.regtype = 'I'
                            and bh.regid = rg.regid
                            Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                           
                            Union

                            SELECT R.WRDCODE, B.ROMCODE, R.ACMCODE, B.BEDOFF, COUNT(*) AS TEMP  ,
                                   sum(to_date( v_EndDate, 'DD-MM-YYYY') - to_date( v_StartDate, 'DD-MM-YYYY')) as days
                            From bedhist bh, bed b, room r, reg rg
                            Where bh.bhsdate < to_date (v_StartDate,'DD/MM/YYYY')
                            and bh.bhsedate >  to_date (v_EndDate,'DD/MM/YYYY')
                            and bh.bhsedate is not null
                            AND b.bedcode= bh.bedcode
                            AND b.stecode= v_SteCode
                            AND b.romcode= r.romcode
                            and rg.regsts = 'N'
                            and rg.regtype = 'I'
                            and bh.regid = rg.regid
                            Group By r.wrdcode , b.romcode, b.bedoff, r.AcmCode
                      ) a
               Group By a.wrdcode , a.romcode, a.AcmCode, a.bedoff
             ) a, room r , bed b
            Where a.romcode = b.romcode
            And b.romcode = r.romcode
            GROUP BY A.WRDCODE , A.ROMCODE, A.ACMCODE, A.BEDOFF, A.DAYS
  )
  Where type= 0
  GROUP BY WARD, ROOM, ACMCODE, TYPE, NOOFBED
  ORDER BY WARD, ROOM, ACMCODE, TYPE
  );

RETURN OUTCUR;
END NHS_RPT_RPTMAINBEDSMY;
/