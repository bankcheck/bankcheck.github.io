create or replace
function NHS_RPT_BILLSUMMARY(V_SLPNO in varchar2)
  return types.CURSOR_TYPE as
  OUTCUR types.CURSOR_TYPE;
begin
  open OUTCUR for

    select SLPNO, PATNO,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNTYPE in ('C')
            ) as SLPCAMT,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNTYPE in ('S', 'P')
            ) as SLPPAMT,
            (
                select To_Char(NVL(SUM(STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D')
                and ITMTYPE = 'H'
            ) as HOSCHG,
            (
                select To_Char(NVL(SUM(STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D')
                and ITMTYPE =  'D'
            ) as DOCCHG,
            (
                select To_Char(NVL(SUM(STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D')
                and ITMTYPE = 'O'
            ) as OTHCHG,
            (
                select To_Char(NVL(SUM(STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D')
                and ITMTYPE = 'S'
            ) as SPECHG,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
                and ITMTYPE = 'H'
            ) as HOSNET,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
                and ITMTYPE = 'D'
            ) as DOCNET,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
                and ITMTYPE = 'O'
            ) as OTHNET,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
                and ITMTYPE = 'S'
            ) as SPENET,
            (
                select To_Char(NVL(SUM(STNNAMT - STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
                and ITMTYPE = 'H'
            ) as HOSDISC,
            (
                select To_Char(NVL(SUM(STNNAMT - STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
                and ITMTYPE = 'D'
            ) as DOCDISC,
            (
                select To_Char(NVL(SUM(STNNAMT - STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
                and ITMTYPE = 'O'
            ) as OTHDISC,
            (
                select To_Char(NVL(SUM(STNNAMT - STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
                and ITMTYPE = 'S'
            ) as SPEDISC,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE = 'C'
                and ITMTYPE = 'H'
            ) as HOSCRED,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE = 'C'
                and ITMTYPE = 'D'
            ) as DOCCRED,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE = 'C'
                and ITMTYPE = 'O'
            ) as OTHCRED,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE = 'C'
                and ITMTYPE = 'S'
            ) as SPECRED,
            (
                select To_Char(NVL(SUM(STNNAMT - STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
            ) as DISCOUNT,
            (
                select To_Char(NVL(SUM(STNBAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D')
            ) as TOTCHG,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNSTS in ('N', 'A')
                and STNTYPE in ('D', 'C')
            ) as SLPDAMT,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNTYPE in ( 'I','O','X')
            ) as DEPOSIT,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNTYPE = 'P'
            ) as ARPAY,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNTYPE = 'S'
            ) as SELFPAY,
            (
                select To_Char(NVL(SUM(STNNAMT),0), '999,999,999,999')
                from SLIPTX
                where SLPNO = S.SLPNO
                and STNTYPE = 'R'
            ) as REFUND,
            To_Char(NVL(SLPCAMT+SLPDAMT+SLPPAMT,0), '999,999,999,999') as BALANCE
    from SLIP S
    where S.SLPNO = V_SLPNO;
  return OUTCUR;
end NHS_RPT_BILLSUMMARY;
/
