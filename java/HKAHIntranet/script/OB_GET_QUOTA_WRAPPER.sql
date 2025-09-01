create or replace
FUNCTION OB_GET_QUOTA_WRAPPER ( i_doccode IN VARCHAR2, i_edc IN VARCHAR2 )
RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
	v_quota_daily INTEGER;
	v_quota_month INTEGER;
	v_quota_period INTEGER;
	v_ml_remind_quota_month INTEGER;
	v_mlC1_remind_quota_month INTEGER;
	v_mlC2_remind_quota_month INTEGER;
	v_hk_remind_quota_month INTEGER;
	v_ml_remind_quota_year INTEGER;
	v_mlC1_remind_quota_year INTEGER;
	v_mlC2_remind_quota_year INTEGER;
	v_hk_remind_quota_year INTEGER;
	v_ml_quota_month INTEGER;
	v_hk_quota_month INTEGER;
	v_ml_quota_year INTEGER;
	v_hk_quota_year INTEGER;
	v_overall_ml_remind_quota_year INTEGER;
	v_return BOOLEAN;
BEGIN
	v_return := OB_GET_QUOTA (i_doccode, i_edc,
			v_quota_daily, v_quota_month, v_quota_period,
			v_ml_remind_quota_month, v_mlC1_remind_quota_month, v_mlC2_remind_quota_month,
			v_hk_remind_quota_month,
			v_ml_remind_quota_year, v_mlC1_remind_quota_year, v_mlC2_remind_quota_year,
			v_hk_remind_quota_year,
			v_ml_quota_month, v_hk_quota_month,
			v_ml_quota_year, v_hk_quota_year,
			v_overall_ml_remind_quota_year);

	-- output
	OPEN OUTCUR FOR
		SELECT v_quota_daily, v_quota_month, v_quota_period,
		       v_ml_remind_quota_month, v_mlC1_remind_quota_month, v_mlC2_remind_quota_month,
		       v_hk_remind_quota_month,
		       v_ml_remind_quota_year, v_mlC1_remind_quota_year, v_mlC2_remind_quota_year,
		       v_hk_remind_quota_year,
		       v_ml_quota_month, v_hk_quota_month,
		       v_ml_quota_year, v_hk_quota_year,
		       v_overall_ml_remind_quota_year
	FROM DUAL;
  RETURN OUTCUR;
END OB_GET_QUOTA_WRAPPER;
/
