CREATE OR REPLACE FUNCTION NHS_LIS_OTCANCELAPP
(
    v_tempOTAID in varchar2
)
  return types.cursor_type
as
  outcur types.cursor_type;
  sqlstr VARCHAR2(2000);
begin
  sqlstr := 'select
                '''',
                '''',
                a.otaid,
                to_char(a.otaosdate,''dd / mm / yyyy hh24 :mi'')),
                to_char(a.otaoedate,''dd / mm / yyyy hh24 :mi'')),
                Decode(pat.PMcid,null,null,0,null,''M''),
                a.patno,
                a.otafname || '' '' || a.otagname,
                a.otatel,
                trunc(months_between(sysdate,a.otabdate)/12),
                p.otpdesc,
                c.otcdesc,
                sd.docfname || '''' || sd.docgname as sdrname,
                ad.docfname || '' '' || ad.docgname as adrname,
                ed.docfname || '' '' || ed.docgname as edrname,
                decode(a.otasts,''N'',''Normal'',''F'',''Confirmed''),
                a.otarmk,

                decode(trunc(otaosdate)-trunc(otaoedate),
                0,
                a.otafname,
                a.otagname,
                a.DOCCODE_S,
                a.otasts

       from ot_proc p, ot_app a, ot_code c, doctor SD, doctor AD, doctor ED, patient pat
       where a.otpid = p.otpid
       and a.otcid_am = c.otcid
       and a.doccode_s = sd.doccode(+)
       and a.doccode_a = ad.doccode
       and a.doccode_e = ed.doccode(+)
       and a.patno = pat.patno(+)
       and a.otaid in ('|| v_tempOTAID ||')
       order by a.otaosdate';
    open outcur for sqlstr;
  return outcur;
END NHS_LIS_OTCANCELAPP;
/
