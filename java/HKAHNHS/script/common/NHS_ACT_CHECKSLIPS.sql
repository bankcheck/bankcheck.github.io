CREATE OR REPLACE FUNCTION "NHS_ACT_CHECKSLIPS" (
	v_action   IN VARCHAR2,
	v_mainslip IN VARCHAR2,
	v_slpnos   IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	i_count   NUMBER;
	i_seqno   slipmerge.seqid%TYPE;
	s_seqno   slipmerge.seqid%TYPE;
	o_errcode   NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO i_count
	FROM   SLIP
	WHERE  slpno = v_mainslip;

	IF i_count = 0 THEN
		o_errcode := -1;
		o_errmsg := 'No exist Slip No ['||v_mainslip||']';
		RETURN o_errcode;
	END IF;

	SELECT COUNT(1) INTO i_count
	FROM SLIPMERGE
	WHERE SLPNO = v_mainslip;

	IF i_count = 0 THEN
		i_seqno := -1;
	ELSE
		SELECT SEQID INTO i_seqno
		FROM SLIPMERGE
		WHERE SLPNO = v_mainslip;
	END IF;

	FOR SLIPS IN (
		SELECT REGEXP_SUBSTR(v_slpnos, '[^,]+', 1, LEVEL) AS SLIP, ROWNUM
		FROM DUAL
		CONNECT BY REGEXP_SUBSTR(v_slpnos, '[^,]+', 1, LEVEL) IS NOT NULL)
	LOOP
		IF LENGTH(TRIM(SLIPS.SLIP)) > 0 THEN
			SELECT COUNT(1) INTO i_count
			FROM SLIP
			WHERE slpno = TRIM(SLIPS.SLIP);

			IF i_count = 0 THEN
				o_errcode := -1;
				o_errmsg := 'No exist Slip No ['||SLIPS.SLIP||']';
				RETURN o_errcode;
			END IF;

			SELECT COUNT(1) INTO i_count
			FROM SLIPMERGE
			WHERE SLPNO = TRIM(SLIPS.SLIP);

			IF i_count = 0 THEN
				s_seqno := -1;
			ELSE
				SELECT SEQID INTO s_seqno
				FROM SLIPMERGE
				WHERE SLPNO = TRIM(SLIPS.SLIP);
			END IF;

			IF s_seqno <> -1 AND s_seqno <> i_seqno THEN
				o_errcode := -2;
				o_errmsg := 'Slip No ['||SLIPS.SLIP||'] has been merged!';
				RETURN o_errcode;
			END IF;
		END IF;
	END LOOP;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
	o_ERRMSG := SQLERRM || o_errmsg;

	RETURN -999;
END NHS_ACT_CHECKSLIPS;
/
