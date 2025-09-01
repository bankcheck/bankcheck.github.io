CREATE OR REPLACE FUNCTION "NHS_GET_NEXT_XJOBNO"
RETURN VARCHAR2
IS
	v_Count       NUMBER;
	v_VarSeq      NUMBER;
	v_CurrDate    VARCHAR2(10);
	v_ParamYear   VARCHAR2(4);
	v_CurrYear    VARCHAR2(4);
	v_XJobNo      VARCHAR2(13);
	DI_JOBSEQ     VARCHAR2(5) := 'DISEQ';
	JOB_NO_PREFIX VARCHAR2(2) := 'DI';
BEGIN
	SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') INTO v_CurrDate FROM DUAL;

	SELECT COUNT(1) INTO v_Count FROM SysParam WHERE ParCde = DI_JOBSEQ;
	IF v_Count = 0 THEN
		INSERT INTO SysParam (ParCde, Param1, Param2) VALUES (DI_JOBSEQ, v_CurrDate, '1');
		v_VarSeq := 1;
	ELSE
		SELECT TO_CHAR(TO_DATE(Param1, 'DD/MM/YYYY'), 'YYYY'), TO_NUMBER(Param2) INTO v_ParamYear, v_VarSeq FROM SysParam WHERE ParCde = DI_JOBSEQ;
		SELECT TO_CHAR(SYSDATE, 'YYYY') INTO v_CurrYear FROM DUAL;

		IF v_ParamYear != v_CurrYear OR v_VarSeq IS NULL THEN
			v_VarSeq := 1;
		ELSE
			v_VarSeq := v_VarSeq + 1;
		END IF;

		UPDATE SysParam
		SET
		    Param1 = v_CurrDate,
			Param2 = v_VarSeq
		WHERE ParCde = DI_JOBSEQ;

	END IF;

	SELECT JOB_NO_PREFIX || TO_CHAR(SYSDATE, 'YY') || LPAD((v_VarSeq), 5, '0') INTO v_XJobNo FROM DUAL;

	RETURN v_XJobNo;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN NULL;
END;
/
