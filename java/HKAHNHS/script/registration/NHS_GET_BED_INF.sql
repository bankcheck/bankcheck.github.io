CREATE OR REPLACE FUNCTION "NHS_GET_BED_INF" (
	v_BedCode IN Bed.BedCode%TYPE
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	open outcur for
		SELECT B.BedSts, D.DptName, W.WrdName, A.AcmCode, A.AcmName,
			decode(H.HPSTATUS, 'W', 'WINDOW', 'NW', 'NON-WINDOW', H.HPSTATUS), B.EXTPHONE
		FROM   Bed B, Room R, Ward W, Dept D, Acm A, HPSTATUS H
		WHERE  B.RomCode = R.RomCode
		AND    R.AcmCode = A.AcmCode
		AND    R.WrdCode = W.WrdCode
		AND    W.DptCode = D.DptCode
		AND    B.BEDCODE = H.HPKEY(+)
		AND    B.BedCode = v_BedCode;
	RETURN outcur;
 END NHS_GET_BED_INF;
/
