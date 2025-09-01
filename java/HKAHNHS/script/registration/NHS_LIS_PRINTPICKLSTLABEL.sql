create or replace FUNCTION NHS_LIS_PRINTPICKLSTLABEL
(V_PATNO DOCTOR_EXTRA.DOCCODE%TYPE)
  RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
  SELECT
  h.patno||'/'||h.mrhvollab as MedRecID,
  l.mrldesc as location,
  h.mrhvollab as volNumber, 
  doc.docfname||' '||doc.docgname as docName
  FROM medrechdr h,medrecdtl d, medrecloc l,doctor doc
  WHERE h.patno=V_PATNO
  AND d.doccode=doc.doccode (+)
  AND h.mrhvollab =(
    select max(MRH.mrhvollab) as maxvol 
    FROM MedRecHdr MRH, MEDRECMED M
    WHERE MRH.MrmID = m.MrmID
    AND M.MRMID = 1
    AND MRH.mrhsts='N' 
    AND MRH.patno=h.patno)
  AND h.mrdid=d.mrdid
  AND nvl(d.mrlid_r,d.mrlid_l) = l.mrlid;  
   RETURN OUTCUR;
END NHS_LIS_PRINTPICKLSTLABEL;
/