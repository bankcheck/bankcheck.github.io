CREATE OR REPLACE FUNCTION "NHS_LIS_USER"
(V_USRID USR.USRID%TYPE,
 V_USRNAME USR.USRNAME%TYPE )
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
    SELECT
        U.USRID,
        U.USRPWD,
        u.usrname,
        DECODE(U.USRSTS,-1,'Y','N'),
        DECODE(U.USRINP,-1,'Y','N'),
        DECODE(U.USROUT,-1,'Y','N'),
        DECODE(U.USRDAY,-1,'Y','N'),
        DECODE(U.USRPBO,-1,'Y','N'),
        U.DPTCODE,
        E.STECODE,
        DECODE(U.ISUSING,-1,'Y','N')
    FROM USR U, usersite E
    WHERE U.USRID=E.USRID
    AND ( U.USRID LIKE '%' || v_USRID || '%')
    AND ( U.usrname LIKE '%' || v_usrname || '%')
    ORDER BY U.USRID ASC;
  RETURN OUTCUR;
END NHS_LIS_USER;
/


