CREATE OR REPLACE FUNCTION "NHS_ACT_CASHIER" (
	i_action       IN VARCHAR2,
	i_CSHCODE      IN VARCHAR2,
	i_CSHSTS       IN VARCHAR2,
	i_USRID        IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_CSHODATE     IN VARCHAR2,
	i_CSHFDATE     IN VARCHAR2,
--	i_CSHRCNT      IN VARCHAR2,
--	i_CSHVCNT      IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_CSHMAC CASHIER.CSHMAC%TYPE;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	-- trim computer name if too big
	IF LENGTH(i_ComputerName) > 20 THEN
		v_CSHMAC := SUBSTR(i_ComputerName, 1, 20);
	ELSE
		v_CSHMAC := i_ComputerName;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec FROM CASHIER WHERE CSHCODE = i_CSHCODE;

	IF i_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO CASHIER (
				CSHCODE,
				CSHSTS,
				USRID,
				CSHMAC,
				CSHODATE,
				CSHFDATE,
				CSHRCNT,
				CSHVCNT,
				CSHSID,
				STECODE,
				CSHADV,
				CSHPAYIN,
				CSHPAYOUT,
				CSHREC,
				CSHCHQ,
				CSHEPS,
				CSHCARD,
				CSHOTHER,
				CSHCRCNT
			) VALUES (
				i_CSHCODE,
				i_CSHSTS,
				i_USRID,
				v_CSHMAC,
				SYSDATE, --temp for on
				SYSDATE, --temp off
				0,
				0,
				0, --sign on id ?
				GET_CURRENT_STECODE,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF i_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	CASHIER
			SET
				CSHSTS   = i_CSHSTS,
				USRID    = i_USRID,
				CSHMAC   = v_CSHMAC--,
--				CSHODATE = TO_DATE(i_CSHODATE,  'DD/MM/YYYY HH24:MI'),
--				CSHFDATE = TO_DATE(i_CSHFDATE,  'DD/MM/YYYY HH24:MI')
--				CSHRCNT  = i_CSHRCNT,
--				CSHVCNT  = i_CSHVCNT
			WHERE	CSHCODE = i_CSHCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF i_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE CASHIER WHERE CSHCODE = i_CSHCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_CASHIER;
/
