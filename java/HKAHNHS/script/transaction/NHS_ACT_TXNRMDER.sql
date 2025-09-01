CREATE OR REPLACE FUNCTION "NHS_ACT_TXNRMDER" (
	i_Action  IN VARCHAR2,
	i_slpNo   IN VARCHAR2,
	i_RMDERRESP  IN VARCHAR2,
	i_RMDERUSR1A  IN VARCHAR2,	
	i_RMDERDATE1A  IN VARCHAR2,
	i_RMDERMEDM1A  IN VARCHAR2,
	i_RMDERUSR1B  IN VARCHAR2,
	i_RMDERDATE1B  IN VARCHAR2,
	i_RMDERMEDM1B  IN VARCHAR2,
	i_RMDERUSR2A  IN VARCHAR2,
	i_RMDERDATE2A  IN VARCHAR2,
	i_RMDERMEDM2A  IN VARCHAR2,
	i_RMDERUSR2B  IN VARCHAR2,
	i_RMDERDATE2B  IN VARCHAR2,
	i_RMDERMEDM2B  IN VARCHAR2,
	i_RMDERUSR3A  IN VARCHAR2,
	i_RMDERDATE3A  IN VARCHAR2,
	i_RMDERMEDM3A  IN VARCHAR2,
	i_RMDERUSR3B  IN VARCHAR2,
	i_RMDERDATE3B  IN VARCHAR2,
	i_RMDERMEDM3B  IN VARCHAR2,
	i_RMDERRMK  IN VARCHAR2,
	i_MODIFYUSER  IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
  RETURN NUMBER
AS
	o_errcode NUMBER;
BEGIN
	o_errcode := -1;
	o_errmsg := 'OK';

	IF i_RMDERRESP IS NOT NULL  THEN
			INSERT INTO HLETRDTL
		      (
		        HLTYPE,
		        HLKEY,
		        HLSEQ,
		        HLHDATE,
		        HLHUSR,
		        HLRMK,
		        HLCUSR
		      ) VALUES (
		      	'SLIPRMDER',
		      	i_slpNo,
		        '0',
		        null,
		        i_RMDERRESP,
		        i_RMDERRMK,
		        i_MODIFYUSER
		      );
	END IF;
	
	IF i_RMDERUSR1A IS NOT NULL OR TRIM(i_RMDERDATE1A) IS NOT NULL THEN
			INSERT INTO HLETRDTL
		      (
		        HLTYPE,
		        HLKEY,
		        HLSEQ,
		        HLHDATE,
		        HLHUSR,
		        HLRMK,
		        HLCUSR
		      ) VALUES (
		      	'SLIPRMDER',
		      	i_slpNo,
		        '1A',
		        TO_DATE (i_RMDERDATE1A, 'DD/MM/YYYY'),
		        i_RMDERUSR1A,
		        i_RMDERMEDM1A,
		        i_MODIFYUSER
		      );
	END IF;
	
	IF i_RMDERUSR1B IS NOT NULL OR TRIM(i_RMDERDATE1B) IS NOT NULL THEN
			INSERT INTO HLETRDTL
		      (
		        HLTYPE,
		        HLKEY,
		        HLSEQ,
		        HLHDATE,
		        HLHUSR,
		        HLRMK,
		        HLCUSR
		      ) VALUES (
		      	'SLIPRMDER',
		      	i_slpNo,
		        '1B',
		        TO_DATE (i_RMDERDATE1B, 'DD/MM/YYYY'),
		        i_RMDERUSR1B,
		        i_RMDERMEDM1B,
		        i_MODIFYUSER
		      );
	END IF;
	
	IF i_RMDERUSR2A IS NOT NULL OR TRIM(i_RMDERDATE2A) IS NOT NULL THEN
			INSERT INTO HLETRDTL
		      (
		        HLTYPE,
		        HLKEY,
		        HLSEQ,
		        HLHDATE,
		        HLHUSR,
		        HLRMK,
		        HLCUSR
		      ) VALUES (
		      	'SLIPRMDER',
		      	i_slpNo,
		        '2A',
		        TO_DATE (i_RMDERDATE2A, 'DD/MM/YYYY'),
		        i_RMDERUSR2A,
		        i_RMDERMEDM2A,
		        i_MODIFYUSER
		      );
	END IF;
	IF i_RMDERUSR2B IS NOT NULL OR TRIM(i_RMDERDATE2B) IS NOT NULL THEN
			INSERT INTO HLETRDTL
		      (
		        HLTYPE,
		        HLKEY,
		        HLSEQ,
		        HLHDATE,
		        HLHUSR,
		        HLRMK,
		        HLCUSR
		      ) VALUES (
		      	'SLIPRMDER',
		      	i_slpNo,
		        '2B',
		        TO_DATE (i_RMDERDATE2B, 'DD/MM/YYYY'),
		        i_RMDERUSR2B,
		        i_RMDERMEDM2B,
		        i_MODIFYUSER
		      );
	END IF;
	IF i_RMDERUSR3A IS NOT NULL OR TRIM(i_RMDERDATE3A) IS NOT NULL THEN
			INSERT INTO HLETRDTL
		      (
		        HLTYPE,
		        HLKEY,
		        HLSEQ,
		        HLHDATE,
		        HLHUSR,
		        HLRMK,
		        HLCUSR
		      ) VALUES (
		      	'SLIPRMDER',
		      	i_slpNo,
		        '3A',
		        TO_DATE (i_RMDERDATE3A, 'DD/MM/YYYY'),
		        i_RMDERUSR3A,
		        i_RMDERMEDM3A,
		        i_MODIFYUSER
		      );
	END IF;
	IF i_RMDERUSR3B IS NOT NULL OR TRIM(i_RMDERDATE3B) IS NOT NULL THEN
			INSERT INTO HLETRDTL
		      (	
		        HLTYPE,
		        HLKEY,
		        HLSEQ,
		        HLHDATE,
		        HLHUSR,
		        HLRMK,
		        HLCUSR
		      ) VALUES (
		      	'SLIPRMDER',
		      	i_slpNo,
		        '3B',
		        TO_DATE (i_RMDERDATE3B, 'DD/MM/YYYY'),
		        i_RMDERUSR3B,
		        i_RMDERMEDM3B,
		        i_MODIFYUSER
		      );
	END IF;
	o_errcode := 0;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_ACT_TXNRMDER;
/
