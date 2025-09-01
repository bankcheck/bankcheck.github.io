create or replace
FUNCTION OB_CHECK_QUOTA (
i_doccode IN VARCHAR2,
i_edc IN VARCHAR2,
i_doc_type IN VARCHAR2
)
RETURN NUMBER
AS
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
	v_errcode INTEGER;

	v_return BOOLEAN;
BEGIN
	v_quota_daily := 0;
	v_quota_month := 0;
	v_quota_period := 0;
	v_mlC1_remind_quota_month := 0;
	v_mlC2_remind_quota_month := 0;
	v_mlC1_remind_quota_year := 0;
	v_mlC2_remind_quota_year := 0;
	v_ml_quota_month := 0;
	v_hk_quota_month := 0;
	v_ml_quota_year := 0;
	v_hk_quota_year := 0;
	v_overall_ml_remind_quota_year := 0;

	v_errcode := -999;

	v_return := OB_GET_QUOTA (i_doccode, i_edc,
			v_quota_daily, v_quota_month, v_quota_period,
			v_ml_remind_quota_month, v_mlC1_remind_quota_month, v_mlC2_remind_quota_month,
			v_hk_remind_quota_month,
			v_ml_remind_quota_year, v_mlC1_remind_quota_year, v_mlC2_remind_quota_year,
			v_hk_remind_quota_year,
			v_ml_quota_month, v_hk_quota_month,
			v_ml_quota_year, v_hk_quota_year,
			v_overall_ml_remind_quota_year);

	IF v_return THEN
		IF v_quota_daily = 0 THEN
			v_errcode := -1;
		ELSIF v_quota_month = 0 THEN
			v_errcode := -2;
		ELSIF v_quota_period = -3 THEN
			v_errcode := -3;
		ELSE
			-- check whether the patient is mainland or hk
			IF i_doc_type = 'C' OR i_doc_type = 'L' OR i_doc_type = 'X' THEN
				-- mainland or macau patient
				IF (v_ml_remind_quota_month = -999 OR v_ml_remind_quota_month > 0) AND (v_ml_remind_quota_year = -999 OR v_ml_remind_quota_year > 0) THEN
					-- has quota
					v_errcode := 0;
				END IF;
			ELSE
				-- hk patient or foreigner (type = 9 or D)
				IF
					-- hk quota
					((v_hk_remind_quota_month = -999 OR v_hk_remind_quota_month > 0) AND (v_hk_remind_quota_year = -999 OR v_hk_remind_quota_year > 0)) OR
					-- mainland quota
					((v_ml_remind_quota_month = -999 OR v_ml_remind_quota_month > 0) AND (v_ml_remind_quota_year = -999 OR v_ml_remind_quota_year > 0)) THEN
					v_errcode := 0;
				END IF;
			END IF;
		END IF;
	END IF;

	RETURN v_errcode;
EXCEPTION
	WHEN OTHERS THEN
		RETURN v_errcode;
END OB_CHECK_QUOTA;
/