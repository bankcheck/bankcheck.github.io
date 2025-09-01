create or replace
FUNCTION "NHS_ACT_UPDATEPKGCODE" (
	v_action  IN VARCHAR2,
	v_SlipNo  IN VARCHAR2,
	v_PtnID   IN VARCHAR2,
	v_PkgCode IN VARCHAR2,
	V_OPTION  IN VARCHAR2,
  v_dptCode IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := -1;
	o_errmsg := 'OK';

	IF V_ACTION = 'MOD' THEN
    --LookUpPkgCode
    SELECT COUNT(1) INTO V_NOOFREC 
    FROM PACKAGE
    WHERE PKGCODE = V_PKGCODE
    AND PKGTYPE <> 'N'
    AND (v_dptCode IS NULL OR DPTCODE = v_dptCode);
    
    IF V_NOOFREC = 0 THEN
      O_ERRMSG := 'No record found.';
      O_ERRCODE := -100;
    ELSE
      SELECT COUNT(1) INTO v_noOfRec FROM PkgTx WHERE PtnID = TO_NUMBER(v_PtnID);
    
      IF v_noOfRec = 0 then
        o_errcode := -1;
        o_errmsg := 'No record found.';
      ELSE
          -- update PkgTx based on v_option
          IF v_option = 'Y' then
            UPDATE PkgTx SET PkgCode = v_PkgCode
            WHERE Slpno = v_SlipNo AND PkgCode = (SELECT PkgCode FROM PkgTx WHERE PtnID = TO_NUMBER(v_PtnID));
          ELSE
            UPDATE PkgTx SET PkgCode = v_PkgCode
            WHERE Slpno = v_SlipNo AND PtnID = TO_NUMBER(v_PtnID);
          END IF;
          o_errcode := 0;
      END IF;
    END IF;
	END IF;

	--o_errcode := 0;
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg := SQLERRM;
	RETURN o_errcode;
end NHS_ACT_UPDATEPKGCODE;
/