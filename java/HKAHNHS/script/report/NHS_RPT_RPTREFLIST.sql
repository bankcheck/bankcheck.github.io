CREATE OR REPLACE FUNCTION NHS_RPT_RPTREFLIST (
	v_SDate   VARCHAR2,
	v_EDate   VARCHAR2,
	v_SteCode VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
	SELECT
	     st.itmcode,
	     decode(ct.ctxmeth,null,'Unknown',decode(ct.ctxmeth,'C','Cash','Q','Cheque','D','Credit Card','E','EPS','U','CUP Card','T','Octopus','R','WECHAT/ALI PAY','O','Other')) as ctxmeth,
	     sp.patno, st.slpno,
	     decode(sp.slpfname,null,pt.patfname||' '||pt.patgname,sp.slpfname||' '||sp.slpgname) as slpfname,
	     st.stnnamt, st.usrid, sc.stecode,
	     sc.stename,
	     decode(sp.slptype,'O','Out Patient','I','In Patient','Day Case') as slptype,
	     st.stnsts,to_char(st.stncdate,'dd/mm/yyyy')stncdate
	FROM sliptx st, slip sp, patient pt, site sc, cashtx ct
	WHERE st.stncdate >= to_date(v_SDate, 'DD/MM/YYYY')
	and   st.stncdate < to_date(v_EDate, 'DD/MM/YYYY') + 1
	and   st.itmcode = 'REF'
	and   st.slpno = sp.slpno
	and   sp.patno = pt.patno(+)
	and   sp.stecode= v_SteCode
	and   sp.stecode = sc.stecode
	and   ct.ctxid(+) = st.stnxref
	ORDER BY ct.ctxmeth, sp.slptype, st.itmcode;
  RETURN outcur;
END NHS_RPT_RPTREFLIST;
/
