create or replace
FUNCTION OB_GET_QUOTA (
i_doccode IN VARCHAR2,
i_edc IN VARCHAR2,
o_quota_daily OUT INTEGER,
o_quota_month OUT INTEGER,
o_quota_period OUT INTEGER,
o_ml_remind_quota_month OUT INTEGER,
o_mlC1_remind_quota_month OUT INTEGER,
o_mlC2_remind_quota_month OUT INTEGER,
o_hk_remind_quota_month OUT INTEGER,
o_ml_remind_quota_year OUT INTEGER,
o_mlC1_remind_quota_year OUT INTEGER,
o_mlC2_remind_quota_year OUT INTEGER,
o_hk_remind_quota_year OUT INTEGER,
o_ml_quota_month OUT INTEGER,
o_hk_quota_month OUT INTEGER,
o_ml_quota_year OUT INTEGER,
o_hk_quota_year OUT INTEGER,
o_overall_ml_remind_quota_year OUT INTEGER
)
RETURN BOOLEAN
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_ward_code VARCHAR2(10);
	v_count INTEGER;
	v_doc_type VARCHAR2(10);
	v_edc DATE;
	v_max_effective_date DATE;
	v_doctor_type VARCHAR2(2);

	v_all_patient_month INTEGER;
	v_ml_patient_month INTEGER;
	v_hk_patient_month INTEGER;
	v_all_tentative_month INTEGER;
	v_ml_tentative_month INTEGER;
	v_hk_tentative_month INTEGER;
	v_all_patient_year INTEGER;
	v_ml_patient_year INTEGER;
	v_hk_patient_year INTEGER;
	v_all_tentative_year INTEGER;
	v_ml_tentative_year INTEGER;
	v_hk_tentative_year INTEGER;

	v_quota_c1_ratio DECIMAL;
	v_quota_daily_max INTEGER;
	v_quota_month_max INTEGER;
	v_quota_year_china_max INTEGER;
	v_quota_period_max INTEGER;

	v_search_year VARCHAR2(4);
	v_search_month VARCHAR2(2);
	v_search_day VARCHAR2(2);
	v_search_day_from VARCHAR2(2);
	v_search_day_to VARCHAR2(2);
	v_search_day_next_month DATE;
BEGIN
	-- set default to waiting
	o_quota_daily := 0;
	o_quota_month := 0;
	o_quota_period := 0;
	o_ml_remind_quota_month := -999;
	o_mlC1_remind_quota_month := -999;
	o_mlC2_remind_quota_month := -999;
	o_hk_remind_quota_month := -999;
	o_ml_remind_quota_year := -999;
	o_mlC1_remind_quota_year := -999;
	o_mlC2_remind_quota_year := -999;
	o_hk_remind_quota_year := -999;
	o_ml_quota_month := 0;
	o_hk_quota_month := 0;
	o_ml_quota_year := 0;
	o_hk_quota_year := 0;
	v_all_patient_month := 0;
	v_ml_patient_month := 0;
	v_hk_patient_month := 0;
	v_all_tentative_month := 0;
	v_ml_tentative_month := 0;
	v_hk_tentative_month := 0;
	v_all_patient_year := 0;
	v_ml_patient_year := 0;
	v_hk_patient_year := 0;
	v_all_tentative_year := 0;
	v_ml_tentative_year := 0;
	v_hk_tentative_year := 0;
	o_overall_ml_remind_quota_year := 0;

    v_edc := TO_DATE(i_edc, 'dd/MM/YYYY');
	v_search_year := TO_CHAR(v_edc, 'YYYY');
	v_search_month := TO_CHAR(v_edc, 'MM');
	v_search_day := TO_CHAR(v_edc, 'dd');

	-- default daily quota
	v_quota_c1_ratio := 0.7;
	v_quota_daily_max := 6;
	v_quota_month_max := 110;
	v_quota_year_china_max := 450;
	v_quota_period_max := 37;

	-- get ward code
	SELECT PARAM1 INTO v_ward_code FROM SYSPARAM@IWEB WHERE PARCDE = 'obwardcode';

	-- check if doctor quota is available
	BEGIN
		SELECT COUNT(1) INTO v_count FROM OB_DOCTOR_QUOTA WHERE OB_DOCTOR_CODE = i_doccode AND OB_ENABLED = 1 AND OB_EFFECTIVE_DATE <= v_edc;

		-- check doctor quota
		IF v_count > 0 THEN
			IF v_count > 1 THEN
				SELECT MAX(OB_EFFECTIVE_DATE) INTO v_max_effective_date FROM OB_DOCTOR_QUOTA
				WHERE  OB_DOCTOR_CODE = i_doccode
				AND    OB_ENABLED = 1
				AND    OB_EFFECTIVE_DATE <= v_edc;

				-- get doctor quota
				SELECT OB_DOCTOR_TYPE, OB_DOCTOR_ML_QUOTA_MONTH, OB_DOCTOR_HK_QUOTA_MONTH, OB_DOCTOR_ML_QUOTA_YEAR, OB_DOCTOR_HK_QUOTA_YEAR
				INTO   v_doctor_type, o_ml_quota_month, o_hk_quota_month, o_ml_quota_year, o_hk_quota_year
				FROM   OB_DOCTOR_QUOTA
				WHERE  OB_DOCTOR_CODE = i_doccode
				AND    OB_ENABLED = 1
				AND    OB_EFFECTIVE_DATE <= v_edc
				AND    OB_EFFECTIVE_DATE = v_max_effective_date;
			ELSE
				-- get doctor quota
				SELECT OB_DOCTOR_TYPE, OB_DOCTOR_ML_QUOTA_MONTH, OB_DOCTOR_HK_QUOTA_MONTH, OB_DOCTOR_ML_QUOTA_YEAR, OB_DOCTOR_HK_QUOTA_YEAR
				INTO   v_doctor_type, o_ml_quota_month, o_hk_quota_month, o_ml_quota_year, o_hk_quota_year
				FROM   OB_DOCTOR_QUOTA
				WHERE  OB_DOCTOR_CODE = i_doccode
				AND    OB_ENABLED = 1
				AND    OB_EFFECTIVE_DATE <= v_edc;
			END IF;


			-- calculate doctor usage
			SELECT COUNT(1) INTO v_count
			FROM   BEDPREBOK@IWEB B
			WHERE (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%')
			AND    B.BPBHDATE >= TO_DATE('01/01/' || v_search_year || ' 00:00:00','DD/MM/YYYY HH24:MI:SS')
			AND    B.BPBHDATE <= TO_DATE('31/12/' || v_search_year || ' 23:59:59','DD/MM/YYYY HH24:MI:SS')
			AND    B.BPBSTS != 'D'
	  		AND    B.WRDCODE = v_ward_code
			AND    B.FORDELIVERY = '-1'
			AND    B.DOCCODE = i_doccode;

			IF v_count > 0 THEN
				SELECT  SUM(DECODE(TO_CHAR(B.BPBHDATE, 'MM'), v_search_month, 1, 0)), SUM(DECODE(TO_CHAR(B.BPBHDATE, 'MM'), v_search_month, DECODE(B.PATDOCTYPE, 'L', 1, 'C', 1, 0), 0)), SUM(1), SUM(DECODE(B.PATDOCTYPE, 'L', 1, 'C', 1, 0))
				INTO    v_all_patient_month, v_ml_patient_month, v_all_patient_year, v_ml_patient_year
				FROM    BEDPREBOK@IWEB B
				WHERE  (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%')
				AND		B.BPBHDATE >= TO_DATE('01/01/' || v_search_year || ' 00:00:00','DD/MM/YYYY HH24:MI:SS')
				AND		B.BPBHDATE <= TO_DATE('31/12/' || v_search_year || ' 23:59:59','DD/MM/YYYY HH24:MI:SS')
				AND		B.BPBSTS != 'D'
				AND		B.WRDCODE = v_ward_code
				AND		B.FORDELIVERY = '-1'
				AND		B.DOCCODE = i_doccode;
			END IF;

			-- calculate hk patient
			v_hk_patient_month := v_all_patient_month - v_ml_patient_month;
			v_hk_patient_year := v_all_patient_year - v_ml_patient_year;
		END IF;
	END;

	-- check tentatively book
	BEGIN
		SELECT COUNT(1) INTO v_count
		FROM   OB_BOOKINGS B, BOOKING@IWEB BK
		WHERE  B.OB_BKG_ID = BK.BKGID
		AND    B.OB_EXPECTED_DELIVERYDATE >= TO_DATE('01/01/' || v_search_year || ' 00:00:00','DD/MM/YYYY HH24:MI:SS')
		AND    B.OB_EXPECTED_DELIVERYDATE <= TO_DATE('31/12/' || v_search_year || ' 23:59:59','DD/MM/YYYY HH24:MI:SS')
		AND    B.OB_BOOKING_STATUS = 'T'
  		AND    B.OB_HOLD_EXPIRY_DATE > SYSDATE
		AND    B.OB_DOCTOR_CODE = i_doccode
		AND    BK.BKGSTS IN ('N', 'F')
		AND    BK.BKGSDATE > SYSDATE;

		IF v_count > 0 THEN
			SELECT  SUM(DECODE(TO_CHAR(B.OB_EXPECTED_DELIVERYDATE, 'MM'), v_search_month, 1, 0)), SUM(DECODE(TO_CHAR(B.OB_EXPECTED_DELIVERYDATE, 'MM'), v_search_month, DECODE(B.OB_DOC_TYPE, 'L', 1, 'C', 1, 0), 0)), SUM(1), SUM(DECODE(B.OB_DOC_TYPE, 'L', 1, 'C', 1, 0))
			INTO    v_all_tentative_month, v_ml_tentative_month, v_all_tentative_year, v_ml_tentative_year
			FROM    OB_BOOKINGS B, BOOKING@IWEB BK
			WHERE  B.OB_BKG_ID = BK.BKGID
			AND    B.OB_EXPECTED_DELIVERYDATE >= TO_DATE('01/01/' || v_search_year || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
			AND    B.OB_EXPECTED_DELIVERYDATE <= TO_DATE('31/12/' || v_search_year || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
			AND    B.OB_BOOKING_STATUS = 'T'
	  		AND    B.OB_HOLD_EXPIRY_DATE >= SYSDATE
			AND    B.OB_DOCTOR_CODE = i_doccode
			AND    BK.BKGSTS IN ('N', 'F')
			AND    BK.BKGSDATE > SYSDATE;
		END IF;

		-- calculate hk patient
		v_hk_tentative_month := v_all_tentative_month - v_ml_tentative_month;
		v_hk_tentative_year := v_all_tentative_year - v_ml_tentative_year;
	END;

	-- check daily quota
	BEGIN
		-- check bed prebook
		SELECT COUNT(1) INTO v_count
		FROM   BEDPREBOK@IWEB B
		WHERE (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%')
		AND    B.BPBHDATE >= TO_DATE(i_edc || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BPBHDATE <= TO_DATE(i_edc || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BPBSTS != 'D'
		AND    B.WRDCODE = v_ward_code
		AND    B.FORDELIVERY = '-1';

		-- calculate daily quota left
		IF v_count < v_quota_daily_max THEN
			o_quota_daily := v_quota_daily_max - v_count;
		END IF;
	END;

	-- check month quota
	BEGIN
		-- check bed prebook
		SELECT COUNT(1) INTO v_count
		FROM   BEDPREBOK@IWEB B
		WHERE (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%')
		AND    TO_CHAR(B.BPBHDATE, 'MM') = v_search_month
		AND    B.BPBHDATE >= TO_DATE('01/01/' || v_search_year || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BPBHDATE <= TO_DATE('31/12/' || v_search_year || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BPBSTS != 'D'
		AND    B.WRDCODE = v_ward_code
		AND    B.FORDELIVERY = '-1';

		-- calculate month quota left
		IF v_count < v_quota_month_max THEN
			o_quota_month := v_quota_month_max - v_count;
		END IF;
	END;

	-- check year china quota
	BEGIN
		-- check bed prebook
		SELECT COUNT(1) INTO v_count
		FROM   BEDPREBOK@IWEB B
		WHERE (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%')
		AND    B.BPBHDATE >= TO_DATE('01/01/' || v_search_year || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BPBHDATE <= TO_DATE('31/12/' || v_search_year || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BPBSTS != 'D'
		AND    B.WRDCODE = v_ward_code
		AND    B.FORDELIVERY = '-1'
		AND    B.PATDOCTYPE IN ('L', 'C');

		-- calculate month quota left
		IF v_count < v_quota_year_china_max THEN
			o_overall_ml_remind_quota_year := v_quota_year_china_max - v_count;
		END IF;
	END;

	-- check period quota
	BEGIN
		IF v_search_day >= 1 AND v_search_day <= 10 THEN
			v_search_day_from := '01';
			v_search_day_to := '10';
		ELSIF v_search_day >= 11 AND v_search_day <= 20 THEN
			v_search_day_from := '11';
			v_search_day_to := '20';
		ELSE
			v_search_day_from := '21';
			v_search_day_next_month := TO_DATE('01/' || v_search_month || '/' || v_search_year, 'DD/MM/YYYY');
			SELECT TO_CHAR(ADD_MONTHS(v_search_day_next_month, 1) - 1, 'dd') INTO v_search_day_to FROM DUAL;
		END IF;

		-- check bed prebook
		SELECT COUNT(1) INTO v_count
		FROM   BEDPREBOK@IWEB B
		WHERE (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%')
		AND    TO_CHAR(B.BPBHDATE, 'MM') = v_search_month
		AND    B.BPBHDATE >= TO_DATE(v_search_day_from || '/' || v_search_month || '/' || v_search_year || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BPBHDATE <= TO_DATE(v_search_day_to || '/' || v_search_month || '/' || v_search_year || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BPBSTS != 'D'
		AND    B.WRDCODE = v_ward_code
		AND    B.FORDELIVERY = '-1';

		-- calculate period quota left
		IF v_count < v_quota_period_max THEN
			o_quota_period := v_quota_period_max - v_count;
		END IF;
	END;

	-- output
	-- quota minus tentative hold
	IF o_ml_quota_month = -999 THEN
		o_ml_remind_quota_month := -999;
	ELSE
		o_ml_quota_month := o_ml_quota_month - v_ml_tentative_month;
		o_ml_remind_quota_month := o_ml_quota_month - v_ml_patient_month;
	END IF;
	IF o_hk_quota_month = -999 THEN
		o_hk_remind_quota_month := -999;
	ELSE
		o_hk_quota_month := o_hk_quota_month - v_hk_tentative_month;
		o_hk_remind_quota_month := o_hk_quota_month - v_hk_patient_month;
	END IF;
	IF o_ml_quota_year = -999 THEN
		o_ml_remind_quota_year := -999;
	ELSE
		o_ml_quota_year := o_ml_quota_year - v_ml_tentative_year;
		o_ml_remind_quota_year := o_ml_quota_year - v_ml_patient_year;
	END IF;
	IF o_hk_quota_year = -999 THEN
		o_hk_remind_quota_year := -999;
	ELSE
		o_hk_quota_year := o_hk_quota_year - v_hk_tentative_year;
		o_hk_remind_quota_year := o_hk_quota_year - v_hk_patient_year;
	END IF;

	-- use hong kong quota
	IF o_hk_remind_quota_month != -999 AND o_ml_remind_quota_month != -999 AND o_hk_remind_quota_month + o_ml_remind_quota_month < 0 THEN
		o_hk_remind_quota_month := 0;
		o_ml_remind_quota_month := 0;
	ELSIF o_hk_remind_quota_month < 0 AND o_hk_remind_quota_month != -999 THEN
		o_ml_remind_quota_month := o_ml_remind_quota_month + o_hk_remind_quota_month;
		o_hk_remind_quota_month := 0;
	ELSIF o_ml_remind_quota_month < 0 AND o_ml_remind_quota_month != -999 THEN
		o_hk_remind_quota_month := o_ml_remind_quota_month + o_hk_remind_quota_month;
		o_ml_remind_quota_month := 0;
	END IF;

	IF o_hk_remind_quota_year != -999 AND o_ml_remind_quota_year < 0 AND o_hk_remind_quota_year + o_ml_remind_quota_year < 0 THEN
		o_hk_remind_quota_year := 0;
		o_ml_remind_quota_year := 0;
	ELSIF o_hk_remind_quota_year < 0 AND o_hk_remind_quota_year != -999 THEN
		o_ml_remind_quota_year := o_ml_remind_quota_year + o_hk_remind_quota_year;
		o_hk_remind_quota_year := 0;
	ELSIF o_ml_remind_quota_year < 0 AND o_ml_remind_quota_year != -999 THEN
		o_hk_remind_quota_year := o_ml_remind_quota_year + o_hk_remind_quota_year;
		o_ml_remind_quota_year := 0;
	END IF;

	-- calculate c1 c2 quota
	IF o_ml_remind_quota_month > 0 THEN
		o_mlC1_remind_quota_month := o_ml_remind_quota_month * v_quota_c1_ratio;
		o_mlC2_remind_quota_month := o_ml_remind_quota_month - o_mlC1_remind_quota_month;
	END IF;

	IF o_ml_remind_quota_year > 0 THEN
		o_mlC1_remind_quota_year := o_ml_remind_quota_year * v_quota_c1_ratio;
		o_mlC2_remind_quota_year := o_ml_remind_quota_year - o_mlC1_remind_quota_year;
	END IF;

	IF o_overall_ml_remind_quota_year <= 0 THEN
		-- transfer all the quota from mainland to hk
		o_hk_remind_quota_month := o_hk_remind_quota_month + o_ml_remind_quota_month;
		o_ml_remind_quota_month := 0;
		o_mlC1_remind_quota_month := 0;
		o_mlC2_remind_quota_month := 0;
		IF o_hk_remind_quota_year != -999 AND o_ml_remind_quota_year != -999 THEN
			o_hk_remind_quota_year := o_hk_remind_quota_year + o_ml_remind_quota_year;
			o_ml_remind_quota_year := 0;
			o_mlC1_remind_quota_year := 0;
			o_mlC2_remind_quota_year := 0;
		END IF;
	END IF;

	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END OB_GET_QUOTA;
/