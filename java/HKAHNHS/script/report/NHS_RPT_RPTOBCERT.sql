create or replace
FUNCTION "NHS_RPT_RPTOBCERT" (V_TODATE IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
    SELECT
  ob.certno,
  ob.patname,
  ob.PatCName,
  ob.PatNo,
  TO_CHAR(ob.PATDOB, 'DD/MM/YYYY'),
  decode(ob.patdoctype,'L','Exit-entry Permit','Others'),
  ob.patIDNo,
  decode(ob.isHKSPOUSE,'Y','Yes','N','Unknown'),
  ob.drname,
  ob.drmchkno,
  ob.drtel,
  TO_CHAR(ob.antchkdt1, 'DD/MM/YYYY'),
  TO_CHAR(ob.antchkdt2, 'DD/MM/YYYY'),
  TO_CHAR(ob.antchkdt3, 'DD/MM/YYYY'),
  TO_CHAR(ob.antchkdt4, 'DD/MM/YYYY'),
  TO_CHAR(ob.antchkdt5, 'DD/MM/YYYY'),
  TO_CHAR(ob.antchkdt6, 'DD/MM/YYYY'),
  TO_CHAR(ob.patedc, 'DD/MM/YYYY'),
  TO_CHAR(ob.CISEDATE, 'DD/MM/YYYY'),
  ob.remark,
  Case when (OB.isvalid <> 'Valid') then ob.isvalid
       when (OB.isvalid = 'Valid' and (bpb.bpbsts <> 'F' and bpb.bpbsts <> 'D')) Then 'Valid'
       ELSE 'Invalid'
  END case_valid,
  decode(bpb.bpbsts,'D','C','F','D','') as invalidrsn,
  decode(bpb.bpbsts,'D',TO_CHAR(OB.MODIFY_DATE, 'DD/MM/YYYY'),
                    'F',TO_CHAR(OB.MODIFY_DATE, 'DD/MM/YYYY'),
                    TO_CHAR(ob.canceldate, 'DD/MM/YYYY')),
  ob.repltrsn,
  ob.husname,
  ob.huscname,
  ob.HUSIDNO,
  ob.ishushkpm,
   TO_CHAR(ob.husDOB, 'DD/MM/YYYY'),
  TO_CHAR(ob.patmdate, 'DD/MM/YYYY'),
  ob.patmctno
  FROM obcert ob
    INNER JOIN BEDPREBOK bpb
    ON ob.BOOKINGNO = bpb.BPBNO
    WHERE ob.certno LIKE 'P02-'||substr(V_TODATE,(length(V_TODATE)-3),length(V_TODATE))||'%'
    AND ob.patedc >= to_date('01/01/'
                    ||substr(V_TODATE,(length(V_TODATE)-3),length(V_TODATE))||'','dd/mm/yyyy')
    AND ob.cisedate   >= to_date('23/09/2011','dd/mm/yyyy')
    AND ob.cisedate     < to_date(V_TODATE,'dd/mm/yyyy')
    ORDER BY ob.certno;
  RETURN OUTCUR;
END NHS_RPT_RPTOBCERT;
/
