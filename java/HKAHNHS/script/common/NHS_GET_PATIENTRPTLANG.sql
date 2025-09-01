create or replace
FUNCTION NHS_GET_PATIENTRPTLANG (
  V_SLPNO   IN VARCHAR2,
  V_PATNO   IN VARCHAR2
)
RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
  V_NOOFREC  		NUMBER;
BEGIN
  V_NOOFREC := 0;
  
  SELECT COUNT(1) INTO V_NOOFREC
  FROM DESCRIPTION_MAPPING
  WHERE LANGUAGE = (
                      SELECT MOTHCODE
                      FROM PATIENT
                      WHERE PATNO = V_PATNO OR
                            (
                              PATNO = (
                                        SELECT PATNO
                                        FROM SLIP
                                        WHERE SLPNO = V_SLPNO
                                      )
                            )
                  )
  AND ID = 'LANG';
  
  IF V_NOOFREC = 0 THEN
      OPEN OUTCUR FOR
        SELECT LANGUAGE
        FROM DESCRIPTION_MAPPING
        WHERE ID = 'LANG';
  ELSE
      OPEN OUTCUR FOR
        SELECT MOTHCODE
        FROM PATIENT
        WHERE PATNO = V_PATNO OR
              (
                PATNO = (
                          SELECT PATNO
                          FROM SLIP
                          WHERE SLPNO = V_SLPNO
                        )
              );
  END IF;
        
  RETURN OUTCUR;
END NHS_GET_PATIENTRPTLANG;
/