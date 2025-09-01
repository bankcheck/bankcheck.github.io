CREATE OR REPLACE FUNCTION "NHS_GET_PATIENT_NEWREG" (
	i_PatNo	   IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	outcur TYPES.CURSOR_TYPE;
	rtnCursor1 TYPES.CURSOR_TYPE;
	rtnCursor2 TYPES.CURSOR_TYPE;
	rtnCursor3 TYPES.CURSOR_TYPE;
	v_Death DATE;
	v_inpddate DATE;
	v_PatNo VARCHAR2(10);
	v_Count1 NUMBER := 0;
	v_Count2 NUMBER := 0;
	TYPE rt_fill IS record (
		FillMedicalRecord NUMBER,
		MRLocation MEDRECLOC.MRLDESC%TYPE,
		MediaType VARCHAR2(10),
		IsAuto NUMBER,
		IsSameDate NUMBER,
		MrhVolLab VARCHAR2(5)
	);
	rtnTypeFill rt_fill;
BEGIN
	SELECT Death INTO v_Death
	FROM   Patient
	WHERE  PatNo = i_PatNo;

	rtnCursor1 := NHS_GET_INPDDATE(i_PatNo, 'Y');
	LOOP
		FETCH rtnCursor1 INTO v_inpddate;
		EXIT WHEN rtnCursor1%NOTFOUND;
		v_Count1 := v_Count1 + 1;
	END LOOP;

	rtnCursor2 := NHS_GET_INPDDATE(i_PatNo, 'N');
	LOOP
		FETCH rtnCursor2 INTO v_PatNo;
		EXIT WHEN rtnCursor2%NOTFOUND;
		v_Count2 := v_Count2 + 1;
	END LOOP;

	rtnCursor3 := NHS_GET_MEDREC_FILL(i_PatNo);
	LOOP
		FETCH rtnCursor3 INTO rtnTypeFill;
		EXIT WHEN rtnCursor3%NOTFOUND;
	END LOOP;

	OPEN outcur FOR
		SELECT
			DECODE(v_Death, NULL, 'N', 'Y'),
			DECODE(v_Count1, 0, 'N', 'Y'),
			DECODE(v_Count2, 0, 'N', 'Y'),
			rtnTypeFill.MRLocation,
			rtnTypeFill.MediaType
		FROM DUAL;

	RETURN outcur;
END NHS_GET_PATIENT_NEWREG;
/
