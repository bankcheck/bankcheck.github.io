create or replace
FUNCTION "NHS_GET_SLIPMERGE"
(
	v_SLIPNO VARCHAR2,
  V_STNID VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  memAllSlpNo VARCHAR2(2000);
  slipNO VARCHAR2(15);
  memAllDr VARCHAR2(2000);

CURSOR c_getAllSlpNo IS
SELECT slpno 
from slipmerge
WHERE seqid = (
  SELECT MAX(seqid) 
  FROM slipmerge 
  WHERE slpno = v_SLIPNO)
ORDER BY slpno;
  
BEGIN
  OPEN c_getAllSlpNo;
  LOOP
  FETCH c_getAllSlpNo INTO slipNO;
  EXIT WHEN c_getAllSlpNo%NOTFOUND;
    IF memAllSlpNo IS NULL OR memAllSlpNo = '' THEN
      memAllSlpNo := slipNO;
    ELSE
      IF slipNO IS NOT NULL AND slipNO <> '' THEN
        memAllSlpNo := memAllSlpNo||','||slipNO;      
      END IF;
    END IF;
  END LOOP;
  CLOSE c_getAllSlpNo;

  IF V_STNID IS NOT NULL THEN
    memAllDr := NHS_GET_PRTSUPPDR(V_STNID);
    OPEN OUTCUR FOR
    SELECT memAllSlpNo, memAllDr FROM dual;
  ELSE
    OPEN OUTCUR FOR
    SELECT memAllSlpNo FROM dual;  
  END IF;

  RETURN OUTCUR;
END NHS_GET_SLIPMERGE;
/