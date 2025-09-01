CREATE OR REPLACE FUNCTION "NHS_GET_REGDISCHARGE" (
 v_regid   IN varchar2
 )
  RETURN Types.cursor_type
AS
  outcur Types.cursor_type;

BEGIN
   dbms_output.put_line('v_regid>>>>'||v_regid);
   open outcur for  select
                    r.patno as rpatno,
                    p.patfname || ' ' || p.patgname as ppatname,
                    p.patcname as ppatcname,
                    p.patsex as ppatsex,
                    i.doccode_a as idoccode_a,
                    a.docfname || ' ' || a.docgname as adocname,
                    a.doccname as adoccname,
                    to_char(r.regdate,'dd/MM/yyyy HH24:MI:SS') as rregdate,
                    r.doccode as rdoccode,
                    d.doccname as ddoccname,
                    d.docfname || ' ' || d.docgname as ddocname,
                    p.patkname as ppatkname,
                    p.patkrela as ppatkrela,
                    p.patkhtel as ppatkhtel,
                    p.patkptel as ppatkptel,
                    p.patkotel as ppatkotel,
                    p.patkmtel as ppatkmtel,
                    i.descode as descode
                    from inpat i, reg r, patient p, doctor d, doctor a
                    where
                    r.regid= to_number(v_regid) and
                    r.inpid= i.inpid (+) and
                    r.patno= p.patno (+) and
                    r.doccode= d.doccode (+) and
                    i.doccode_a= a.doccode (+) ;
   RETURN outcur;
end NHS_GET_REGDISCHARGE;
/
