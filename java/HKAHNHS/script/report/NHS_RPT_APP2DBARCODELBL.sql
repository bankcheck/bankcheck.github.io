create or replace
FUNCTION "NHS_RPT_APP2DBARCODELBL"
(
    V_Patno Varchar2,
    V_Sltid Varchar2,
    V_Schid Varchar2 
)
return types.cursor_type
As
    V_bkgid  Varchar2(100);
    Outcur Types.Cursor_Type;
Begin
Select Bkgid  Into V_bkgid 
From Booking Where Patno= V_Patno
And Schid= V_Schid And Sltid = V_Sltid And Bkgsts  = 'N';

open outcur for
    Select 
      B.Patno,
      Decode(Nvl(B.Patno,'Non'),
      B.Patno,
      p.patfname || ' '|| p.patgname,
      'Non',
      B.Bkgpname) As Patname,
      Decode(Nvl(B.Patno,'Non'),
      B.Patno,
      DECODE(NVL(p.patcname,''),'','',p.patcname, ',  '|| P.Patcname),
      'Non',
      Decode(Nvl(B.Bkgpcname,''),'','',B.Bkgpcname,',  '||B.Bkgpcname)) As Patcname,      
       TO_CHAR(b.bkgsdate,'dd Mon yyyy (Dy) HH12:MIAM','NLS_DATE_LANGUAGE=AMERICAN') AS appointDate,
       D.Docfname|| ' '|| D.Docgname As Doctorname,
      '<BT>AL</BT><CAPTURE>'|| TO_CHAR(b.bkgcdate,'dd/mm/yyyy hh24:mi:ss')
      || '</CAPTURE><CBY>'
      || b.usrid
      || '</CBY><PRINT>'
      || TO_CHAR(sysdate,'dd/mm/yyyy hh24:mi:ss')
      ||'</PRINT><PBY></PBY><ID>'
      || b.bkgid
      ||'</ID>' As Barcode
    FROM booking b,
      Schedule S,
      Doctor D,
      patient p
    WHERE b.patno = p.patno(+)
    AND b.schid   = s.schid
    And S.Doccode = D.Doccode
    And B.Bkgid   = V_bkgid
    AND b.bkgsts  = 'N';
  Return Outcur;
end NHS_RPT_APP2DBARCODELBL;
/
