create or replace
FUNCTION NHS_CMB_PMWEEK (
	i_siteCode IN VARCHAR2,
	i_year IN VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  Open Outcur For
      SELECT PMP_WEEK, PMP_WEEK_DISPLAY
      FROM PMP_WEEK
      WHERE ROWNUM < 100
      AND   PMP_SITE_CODE = i_siteCode
      AND   PMP_YEAR = i_year
      ORDER BY PMP_WEEK;
      RETURN outcur;
END NHS_CMB_PMWEEK;