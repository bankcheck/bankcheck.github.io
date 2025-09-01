CREATE OR REPLACE FUNCTION NHS_ACT_TXNSLIPPAYALL_PAY1 (
	v_action          IN VARCHAR2,
	v_para1           IN VARCHAR2,
	aar_slppaydtlList IN SLPPAYDTLLIST_TAB,
	o_errmsg          OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_SPDID VARCHAR2(22);
	v_para VARCHAR2(22);
	i NUMBER;
	
	v_ctnctype	VARCHAR2(10);
	v_crarate	NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'MOD' THEN
		FOR i IN 1..aar_slppaydtlList.COUNT LOOP
			v_SPDID := SEQ_SLPPAYDTL.NEXTVAL;

			-- amc
			if aar_slppaydtlList(i).ctnctype = '?' then
				v_ctnctype := null;
			else
				v_ctnctype := aar_slppaydtlList(i).ctnctype;
			end if;
			
			if aar_slppaydtlList(i).crarate = '?' then
				v_crarate := null;
			else
				v_crarate := aar_slppaydtlList(i).crarate;
			end if;
			-- amc

			IF aar_slppaydtlList(i).STNID IS NOT NULL AND aar_slppaydtlList(i).STNID <> '?' THEN
				INSERT INTO SLPPAYDTL(
					SPDID,
					STNID,
					SLPNO,
					STNTYPE,
					PAYREF,
					SPDAAMT,
					SLPTYPE,
					DOCCODE,
					SPDCDATE,
					CTNCTYPE,
					CRARATE,
					SPDSTS,
					SPDPCT,
					SPDFAMT,
					SPHID,
					SPDPAMT,
					STNNAMT,
					SPDSAMT,
					SPDCAMT,
					PCYID,
					SPDID_R
				) VALUES (
					v_SPDID,
					aar_slppaydtlList(i).STNID,
					aar_slppaydtlList(i).slpno,
					aar_slppaydtlList(i).stntype,
					TO_NUMBER(aar_slppaydtlList(i).payref),
					TO_NUMBER(aar_slppaydtlList(i).spdaamt),
					aar_slppaydtlList(i).slptype,
					aar_slppaydtlList(i).doccode,
					TO_DATE(aar_slppaydtlList(i).spdcdate,'dd/mm/yyyy'),
					v_ctnctype,
					v_crarate,
					'N',
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL
				);

				IF o_errmsg IS NOT NULL THEN
					o_errmsg := o_errmsg||';'||v_SPDID;
				ELSE
					o_errmsg := v_SPDID;
				END IF;

				o_errcode := '999';
			END IF;
		END LOOP;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errcode := -1;
	o_errmsg := '[' || SQLCODE || '][' || SQLERRM || ']:' || o_errmsg;
	RETURN o_errcode;
END NHS_ACT_TXNSLIPPAYALL_PAY1;
/
