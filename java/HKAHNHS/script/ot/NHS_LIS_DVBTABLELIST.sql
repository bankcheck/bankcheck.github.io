CREATE OR REPLACE FUNCTION NHS_LIS_DVBTABLELIST (
	OTAID_sql IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SQLSTR VARCHAR2(3000);
BEGIN
	SQLSTR := '
		select  '''' as allergy,a.otaid,
			to_char(a.otaosdate,''dd/mm/yyyy hh24:mi''),
			decode(trunc(otaosdate)-trunc(otaoedate),
			0,
			to_char(otaoedate,''HH24:MI''),
			to_char(otaoedate,''dd/mm/yyyy hh24:mi'')) as otaoedate,
			Decode(pat.PMcid,null,null,0,null,''M'') as Merged,
			a.patno,
			a.otafname,
			a.otagname,
			a.otafname || '' '' || a.otagname as name,
			a.otatel,
			trunc(months_between(sysdate,a.otabdate)/12) as Age,
			p.otpdesc,
			c.otcdesc as Meth,
			a.DOCCODE_S,
			sd.docfname || '' '' || sd.docgname as sdrname,
			ad.docfname || '' '' || ad.docgname as adrname,
			ed.docfname || '' '' || ed.docgname as edrname,
			decode(a.otasts,''N'',''Normal'',''F'',''Confirmed'') as Status,
			a.otarmk,
			a.otasts,
			C.OTCDESC AS OTPDESC_RM
		from  ot_proc p, ot_app a, ot_code c, doctor SD, doctor AD, doctor ED, patient pat
		where a.otpid = p.otpid
		and   a.otcid_am = c.otcid
		and   a.doccode_s = sd.doccode(+)
		and   a.doccode_a = ad.doccode
		and   a.doccode_e = ed.doccode(+)
		and   a.patno = pat.patno(+) ';

	SQLSTR := SQLSTR || OTAID_sql ||' order by a.otaosdate';
	OPEN OUTCUR FOR SQLSTR;
	RETURN OUTCUR;
END NHS_LIS_DVBTABLELIST;
/
