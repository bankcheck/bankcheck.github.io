CREATE OR REPLACE FUNCTION NHS_ACT_ARCANCELENTRY(
	v_action    IN VARCHAR2,
	v_stnid     IN VARCHAR2,
	dCaptureDt  IN VARCHAR2,
	CashierCode IN VARCHAR2,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode   NUMBER;
	AtxAmount   NUMBER;
	v_noOfRec   NUMBER;
	v_AtxID     NUMBER;
	rs_Artx     Artx%ROWTYPE;

	ARTX_STATUS_REVERSE VARCHAR2(1) := 'R';
	ARTX_STATUS_CANCEL VARCHAR2(1) := 'C';
BEGIN
	o_errmsg := 'OK';
	o_errcode := 0;

	IF v_action = 'ADD' THEN
		IF v_stnid IS NULL THEN
			o_errmsg := 'v_stnid is null.';
			o_errcode:=-1;
			RETURN o_errcode;
		END IF;

		SELECT COUNT(1) INTO v_noOfRec FROM Artx WHERE AtxID = TO_NUMBER(v_stnid);
		IF v_noOfRec > 0 THEN
			SELECT * INTO rs_Artx FROM Artx WHERE AtxID = TO_NUMBER(v_stnid);
			IF rs_Artx.AtxSAmt <> 0 THEN
				o_errmsg := 'rs_Artx.AtxSAmt <> 0.';
				o_errcode := -1;
				RETURN o_errcode;
			END IF;

			SELECT SEQ_ARTX.NEXTVAL INTO v_AtxID FROM DUAL;
			rs_Artx.Atxid := v_AtxID;
			rs_Artx.Atxamt := -rs_Artx.Atxamt;
			AtxAmount := rs_Artx.Atxamt;
			rs_Artx.Atxsts := ARTX_STATUS_REVERSE;

			IF dCaptureDt IS NULL THEN
				rs_Artx.Atxcdate := SYSDATE;
			ELSE
				IF length(dCaptureDt)=10 THEN
					rs_Artx.Atxcdate := TO_DATE(dCaptureDt,'dd/mm/yyyy');
				ELSE
					rs_Artx.Atxcdate := TO_DATE(dCaptureDt,'dd/mm/yyyy HH24:MI:SS');
				END IF;
			END IF;

			INSERT INTO Artx(
				ATXID,
				ARCCODE,
				PATNO,
				SLPNO,
				ATXAMT,
				ATXSAMT,
				ATXTDATE,
				ATXCDATE,
				ATXDESC,
				ATXTTYPE,
				ATXREFID,
				ATXSTS,
				ARPID,
				USRID
			) VALUES (
				rs_Artx.ATXID,
				rs_Artx.ARCCODE,
				rs_Artx.PATNO,
				rs_Artx.SLPNO,
				rs_Artx.ATXAMT,
				rs_Artx.ATXSAMT,
				rs_Artx.ATXTDATE,
				rs_Artx.ATXCDATE,
				rs_Artx.ATXDESC,
				rs_Artx.ATXTTYPE,
				rs_Artx.ATXREFID,
				rs_Artx.ATXSTS,
				rs_Artx.ARPID,
				rs_Artx.USRID
			);
			IF SQL%rowcount = 0 THEN
				o_errmsg := 'insert fail.';
				o_errcode := -1;
				RETURN o_errcode;
			END IF;

			-- SetAREntry TransactionID, ARTX_STATUS_CANCEL
			UPDATE ArTx SET AtxSts = ARTX_STATUS_CANCEL WHERE AtxID = TO_NUMBER(v_stnid);

			-- UPDATEARBalance rs.Fields("ArcCode"), AtxAmount, 0
			UPDATE ArCode SET ArcAmt = ArcAmt + AtxAmount, ArcUAmt = ArcUAmt + 0 WHERE ArcCode = rs_Artx.ArcCode;

			-- UPDATECashierAR CurrentUser.CashierCode, AtxAmount
			UPDATE Cashier SET CSHOTHER = CSHOTHER + AtxAmount WHERE CSHCODE = CashierCode;
		ELSE
			o_errmsg := 'no record found.';
			o_errcode := -1;
		END IF;
	ELSE
		o_errmsg := 'parameter error.';
		o_errcode := -1;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg := SQLERRM;
	RETURN -999;

END NHS_ACT_ARCANCELENTRY;
/
