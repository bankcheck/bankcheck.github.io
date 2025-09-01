CREATE OR REPLACE FUNCTION NHS_CMB_CALREFITEMDEPT (
	i_slpno IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		SELECT DISTINCT d.dptcode, d.dptname
		FROM   dept d, pkgtx p
		WHERE  d.dptcode = SUBSTR(p.glccode, 1, 4)
		AND    p.slpno = i_slpno
		AND    p.glccode IS NOT NULL
		ORDER BY d.dptcode;

	RETURN outcur;
END NHS_CMB_CALREFITEMDEPT;
/
