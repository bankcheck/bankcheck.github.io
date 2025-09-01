create or replace FUNCTION "NHS_ACT_PATALERT" (
	v_action  IN VARCHAR2,
	v_AltID   IN VARCHAR2,
	v_PatNo   IN VARCHAR2,
	v_UsrID   IN VARCHAR2,
	v_PalDate IN VARCHAR2,
	v_PalID   IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
  v_alt PatAltLink.AltID%type;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'ADD' OR v_action = 'MOD' THEN

		SELECT COUNT(1) INTO v_noOfRec FROM PatAltLink WHERE PatNo = v_PatNo AND AltID = v_AltID AND UsrID_C IS NULL;
		IF v_noOfRec = 0 THEN
			o_errcode := SEQ_PatAltLink.NEXTVAL;

			INSERT INTO PatAltLink (
				PalID,
				PatNo,
				AltID,
				PalDate,
				UsrID_A
			) VALUES (
				o_errcode,
				v_PatNo,
				v_AltID,
				SYSDATE,
				v_UsrID
			);
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'DEL' THEN
    		BEGIN
	      		SELECT DISTINCT R.ALTID
				INTO v_alt
				FROM USRROLE U, ROLALTLINKEDIT R
				WHERE U.ROLID = R.ROLID
				AND U.USRID = v_UsrID
				AND R.ALTID IN (
					SELECT ALTID FROM PatAltLink
					WHERE PalID = v_PalID);

     			IF v_alt IS NOT NULL THEN
        			SELECT PalID INTO v_noOfRec FROM PatAltLink WHERE PalID = v_PalID AND UsrID_C IS NULL;
        			IF v_noOfRec > 0 THEN
          				UPDATE PatAltLink
          				SET
						UsrID_C = v_UsrID,
						PalCDate = SYSDATE
					WHERE PalID = v_PalID;
        			ELSE
          				o_errcode := -1;
          				o_errmsg := 'Fail to delete due to record not exist.';
        			END IF;
      			ELSE
          			o_errcode := -2;
          			o_errmsg := 'No access right to delete alert!';
      			END IF;
		EXCEPTION
		WHEN OTHERS THEN
			o_errcode := -2;
			o_errmsg := 'No access right to delete alert!';
    		END;
	END IF;
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := 'Fail to generate patient alert.' || SQLERRM || '[' || v_PalID || ']';
	dbms_output.put_line('An ERROR was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);

	return -1;
END "NHS_ACT_PATALERT";
/
