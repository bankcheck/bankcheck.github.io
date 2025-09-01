CREATE OR REPLACE FUNCTION "NHS_LIS_TXNRMDER"(
	i_slpno     IN VARCHAR2,
	i_isHistory IN VARCHAR2
)
	RETURN types.CURSOR_TYPE
AS
	Outcur Types.Cursor_Type;
Begin
	OPEN OUTCUR FOR
		SELECT Hldid,
			HLSEQ,
			Decode(Hlseq,'0','Responsible Person','1','1st Reminder','2','2nd Reminder','3','3rd Reminder'),
			To_Char(Hlcdate,'DD/MM/YYYY'),
			HLHUSR,
			HLMEDIUM,
			Decode(HLMEDIUM,'0','Email','1','Post','2','Email & Post',''),
			To_Char(Hlhdate,'DD/MM/YYYY'),
			HLRMK,
			HLDEPT,
			HLCUSR
		FROM  HLETRDTL
		WHERE HLKEY= i_slpno
		AND   HLTYPE= 'SLIPRMDER'
		ORDER BY HLSEQ ASC ,HLHDATE DESC;
	RETURN OUTCUR;
END NHS_LIS_TXNRMDER;
/
