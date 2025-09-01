CREATE OR REPLACE FUNCTION "NHS_ACT_TXNRMDER2" (
	i_Action      IN VARCHAR2,
	i_HLDID       IN VARCHAR2,
	i_slpNo       IN VARCHAR2,
	i_RMDERRESP   IN VARCHAR2,
	i_RMDERTYPE   IN VARCHAR2,
	I_Rmderusr    IN VARCHAR2,
	i_CREATEDATE  IN VARCHAR2,
	I_Sentdate    IN VARCHAR2,
	I_Rmdermed    IN VARCHAR2,
	I_RmderRmk    IN VARCHAR2,
	i_MODIFYUSER  IN VARCHAR2,
	i_dept        IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	V_Hkdid Integer;
	v_NOOFREC NUMBER;
BEGIN
	o_errcode := -1;
	O_Errmsg := 'OK';

	If I_Hldid Is Not Null  And I_Action = 'DEL' Then
		DELETE FROM Hletrdtl
		WHERE  HLTYPE = 'SLIPRMDER'
		AND    Hldid = I_Hldid
		AND    Hlkey = I_Slpno;
	End If;

	Select Count(1) Into V_Noofrec From Hletrdtl Where Hltype = 'SLIPRMDER' And Hlkey = I_Slpno And Hlseq = '0';

	If (I_Rmderresp Is Not Null  And I_Rmdertype Is Null) THEN
		IF V_Noofrec = 0  THEN
			SELECT SEQ_HLETRDTL.NEXTVAL INTO v_HKDID FROM DUAL;
			INSERT INTO HLETRDTL (
				HLTYPE,
				HLDID,
				HLKEY,
				HLSEQ,
				HLHDATE,
				HLHUSR,
				HLMEDIUM,
				Hlcusr,
				HLCDATE
			) VALUES (
				'SLIPRMDER',
				v_HKDID,
				i_slpNo,
				'0',
				'',
				i_RMDERRESP,
				'',
				I_Modifyuser,
				Sysdate
			);
		ELSE
			UPDATE HLETRDTL
			SET
				Hlhdate = Nvl2(I_Sentdate,To_Date(I_Sentdate, 'DD/MM/YYYY'),Null),
				HLCDATE = Nvl2(i_CREATEDATE,To_Date(i_CREATEDATE, 'DD/MM/YYYY'),Sysdate),
				Hlhusr = i_RMDERRESP
			WHERE   HLTYPE = 'SLIPRMDER'
			And     Hlkey = I_Slpno
			And     Hlseq = '0';
		END IF;
	END IF;

	IF (i_CREATEDATE IS NOT NULL OR TRIM(i_RMDERUSR) IS NOT NULL)
			And I_Hldid Is  Null  And I_Action = 'ADD' Then
		For Rmders In (
			SELECT REGEXP_SUBSTR(REPLACE(i_slpNo,'''',''), '[^,]+', 1, LEVEL) AS RMDER
			FROM   DUAL
			CONNECT BY REGEXP_SUBSTR(REPLACE(i_slpNo,'''',''), '[^,]+', 1, LEVEL) IS NOT NULL)
		Loop
			IF LENGTH(TRIM(RMDERS.RMDER)) > 0 THEN
				SELECT SEQ_HLETRDTL.NEXTVAL INTO v_HKDID FROM DUAL;
				INSERT INTO HLETRDTL (
					HLTYPE,
					HLDID,
					HLKEY,
					HLSEQ,
					HLHDATE,
					HLHUSR,
					Hlmedium,
					HLRMK,
					Hlcusr,
					HLCDATE,
					HLDEPT
				) VALUES (
					'SLIPRMDER',
					V_Hkdid,
					TRIM(RMDERS.RMDER),
					I_Rmdertype,
					NVL2(I_Sentdate,TO_DATE(I_Sentdate, 'DD/MM/YYYY'),null),
					i_RMDERUSR,
					I_Rmdermed,
					I_RmderRmk,
					I_Modifyuser,
					Nvl2(I_Createdate,To_Date(I_Createdate, 'DD/MM/YYYY'),Sysdate),
					Substr(I_Dept,1,3)
				);
			End If;
		END LOOP;
	END IF;

	IF i_RMDERUSR IS NOT NULL OR TRIM(i_RMDERUSR) IS NOT NULL
			AND i_hldid is not null  AND i_Action = 'MOD' THEN
		UPDATE HLETRDTL
		SET
			HLHDATE = NVL2(I_Sentdate,TO_DATE(I_Sentdate, 'DD/MM/YYYY'),null),
			Hlhusr = I_Rmderusr,
			Hlmedium = I_Rmdermed,
			HLRMK = I_RmderRmk,
			HLCDATE = Nvl2(i_CREATEDATE,To_Date(i_CREATEDATE, 'DD/MM/YYYY'),Sysdate)
		WHERE   HLTYPE = 'SLIPRMDER'
		AND     HLDID = i_hldid
		AND     HLKEY = i_slpno
		AND     HLSEQ = i_rmdertype;
	END IF;

	o_errcode := 0;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	O_ERRMSG :=SQLERRM;
	RETURN -999;
END NHS_ACT_TXNRMDER2;
/
