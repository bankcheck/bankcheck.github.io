CREATE OR REPLACE FUNCTION "NHS_ACT_CONTRACTUAL_HISTORY"
(V_ACTION		in varchar2,
V_ACHID     in varchar2,
V_ARCCODE   in varchar2,
V_CPSID     in varchar2,
V_ACHSDATE  in varchar2,
V_ACHEDATE  in varchar2,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
o_errcode		NUMBER;
  V_NOOFREC number;
BEGIN
  o_errcode := 0;
  O_ERRMSG := 'OK';
  select COUNT(1) into V_NOOFREC from ARCCPSHIST where ACHID = V_ACHID;

	IF v_ACTION = 'ADD' OR v_ACTION = 'MOD' THEN
    IF v_NOOFREC > 0 THEN
			UPDATE ARCCPSHIST
			set
				ARCCODE    = V_ARCCODE,
				CPSID    = V_CPSID,
				ACHSDATE  = TO_DATE(V_ACHSDATE, 'DD/MM/YYYY'),
				ACHEDATE = To_DATE(v_ACHEDATE, 'DD/MM/YYYY')
			 WHERE ACHID = v_ACHID;
		ELSE
			 INSERT INTO ARCCPSHIST
      (
        ACHID,
        ARCCODE,
        CPSID,
        ACHSDATE,
        ACHEDATE
      ) values (
        SEQ_ARCCPSHIST.NEXTVAL,
        V_ARCCODE,
        TO_NUMBER(V_CPSID),
        TO_DATE(V_ACHSDATE,'DD/MM/YYYY'),
        TO_DATE(V_ACHEDATE,'DD/MM/YYYY')
      );
		END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		O_ERRCODE := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
	RETURN o_errcode;
END NHS_ACT_CONTRACTUAL_HISTORY;
/
