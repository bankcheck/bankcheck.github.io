CREATE OR REPLACE FUNCTION "NHS_ACT_SUBREASON"
(v_action		IN VARCHAR2,
 v_SRSNCODE IN VARCHAR2,
 V_SRSNDESC IN VARCHAR2,
 V_SRSNNEW IN NUMBER,
 V_SRSNTABNUM IN NUMBER,
 V_SRSNROWNUM IN NUMBER,
 V_RSNCODE IN VARCHAR2,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM SREASON WHERE SRSNCODE = v_SRSNCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO SREASON
      VALUES (
        v_SRSNCODE,
        V_RSNCODE,
        V_SRSNDESC,
        V_SRSNNEW,
        V_SRSNTABNUM,
        V_SRSNROWNUM
      );
   -- ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	SREASON
      SET
            RSNCODE=v_SRSNCODE,
            SRSNDESC=V_SRSNDESC,
            SRSNNEW=V_SRSNNEW,
            SRSNTABNUM=V_SRSNTABNUM,
            SRSNROWNUM=V_SRSNROWNUM
      WHERE	SRSNCODE=v_SRSNCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE SREASON  WHERE SRSNCODE=v_SRSNCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_SUBREASON;
/


