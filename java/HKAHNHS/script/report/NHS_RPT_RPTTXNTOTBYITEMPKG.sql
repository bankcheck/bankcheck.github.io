CREATE OR REPLACE FUNCTION NHS_RPT_RPTTXNTOTBYITEMPKG
( v_SDate VARCHAR2,
  v_EDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
SELECT   pkg.pkgcode as packcode, pkg.pkgname as packname, sc.stename,
                  substr(st.glccode, 1,4) as dept, st.itmcode, it.itmname,
                 0 as itmcnt ,  sum(st.stnnamt) as itmamt
        FROM   sliptx st, item it, site sc, slip sp, package pkg
        WHERE   st.stncdate >= to_date(v_SDate, 'DD/MM/YYYY') and st.stncdate < to_date(v_EDate, 'DD/MM/YYYY')+1 and
                     st.itmcode= it.itmcode and
                     sp.slpno= st.slpno and
                    sp.stecode= v_SteCode and
                     sp.stecode= sc.stecode and
                     st.PkgCode = pkg.PkgCode and
                     it.itmcode <> 'REF'
        GROUP BY    pkg.pkgcode, pkg.pkgname, sc.stename , substr(st.GlcCode, 1, 4),
                   st.ItmCode, it.ItmName
union all
SELECT     pkg.pkgcode as packcode, pkg.pkgname as packname, sc.stename,
                  substr(st.glccode, 1,4) as dept, st.itmcode, it.itmname,
                 sum(st.unit) as itmcnt ,  0 as itmamt

         FROM sliptx st, item it, site sc, slip sp, package pkg
          WHERE   st.stncdate >= to_date(v_SDate, 'DD/MM/YYYY') and st.stncdate < to_date(v_EDate, 'DD/MM/YYYY')+1 and
                     st.stnsts= 'N' and
                     st.itmcode= it.itmcode and
                     sp.slpno= st.slpno and
                    sp.stecode= v_SteCode and
                     sp.stecode= sc.stecode and
                     st.pkgcode= pkg.pkgcode and
                     it.itmcode <> 'REF'
         GROUP BY  pkg.pkgcode, pkg.pkgname, sc.stename , substr(st.GlcCode, 1, 4),
                   st.ItmCode, it.ItmName
union all
        SELECT          cpkg.pkgcode as packcode, cpkg.pkgname as packname, sc.stename,
                          substr(st.glccode, 1,4) as dept, st.itmcode, it.itmname,
                         0 as itmcnt, sum(st.stnnamt) as itmamt
                 FROM  sliptx st, slip sp, item it, site sc, creditpkg cpkg
                   where  st.stncdate >= to_date(v_SDate, 'DD/MM/YYYY') and st.stncdate < to_date(v_EDate, 'DD/MM/YYYY')+1 and
                     sp.slpno = st.slpno and
                    sp.stecode= v_SteCode and
                     st.itmcode= it.itmcode and
                          sp.stecode= sc.stecode and
                          st.pkgcode= cpkg.pkgcode and
                          st.itmcode <> 'REF'
                GROUP BY   cpkg.pkgcode, cpkg.pkgname, sc.stename , substr(st.GlcCode, 1, 4),
                           st.ItmCode, it.ItmName
union all
        SELECT    cpkg.pkgcode as packcode, cpkg.pkgname as packname, sc.stename,
                  substr(st.glccode, 1,4) as dept, st.itmcode, it.itmname,
                 sum(st.unit) as itmcnt, 0 as itmamt
           FROM   sliptx st, slip sp, item it, site sc, creditpkg cpkg
           WHERE   st.stncdate >= to_date(v_SDate, 'DD/MM/YYYY') and st.stncdate < to_date(v_EDate, 'DD/MM/YYYY')+1 and
                    st.stnsts= 'N' and
                     sp.slpno = st.slpno and
                    sp.stecode= v_SteCode and
                     st.itmcode= it.itmcode and
                        sp.stecode= sc.stecode and
                        st.pkgcode= cpkg.pkgcode and
                        st.itmcode <> 'REF'
         GROUP BY   cpkg.pkgcode, cpkg.pkgname, sc.stename , substr(st.GlcCode, 1, 4),
                   st.ItmCode, it.ItmName
          ORDER BY   packcode, dept, itmcode;
  RETURN outcur;
END NHS_RPT_RPTTXNTOTBYITEMPKG;
/
