CREATE OR REPLACE FUNCTION "HAT_GET_IRSPERSON"(
	i_pirID   IN VARCHAR2,
	i_rptSts  IN VARCHAR2
)
	RETURN types.cursor_type
AS
	outcur types.cursor_type;
	v_Count NUMBER;
	v_staffID CO_STAFFS.CO_STAFF_ID%TYPE;
	v_incident_classification PI_REPORT.PIR_INCIDENT_CLASSIFICATION%TYPE;
	v_IsNearMiss PI_REPORT.PIR_NEAR_MISS%TYPE;
	v_deptCodeFlwup PI_REPORT.PIR_DEPT_CODE_FLWUP%TYPE;
	v_rptSts PI_REPORT.PIR_STATUS%TYPE;
	v_PIDeptCode PI_REPORT.PIR_DEPT_CODE_FLWUP%TYPE;
	v_PxDeptCode PI_REPORT.PIR_DEPT_CODE_FLWUP%TYPE;
	v_DeptSupervisor CO_DEPARTMENTS.CO_DEPARTMENT_SUPERVISOR%TYPE;
	v_DeptHead CO_DEPARTMENTS.CO_DEPARTMENT_HEAD%TYPE;
	v_DeptSubHead CO_DEPARTMENTS.CO_DEPARTMENT_SUBHEAD%TYPE;

	v_IsMedicationIncident NUMBER;
	v_IsPxIncident NUMBER;
	v_IsNursingStaffReporter NUMBER;
	v_IsPxReportNurse NUMBER;
BEGIN
	IF GET_CURRENT_STECODE@IWEB = 'TWAH' THEN
		v_PIDeptCode := 'PI';
		v_PxDeptCode := 'PHAR';
	ELSE
		v_PIDeptCode := '870';
		v_PxDeptCode := '380';
	END IF;

	SELECT PIR_INCIDENT_CLASSIFICATION, PIR_NEAR_MISS, PIR_DEPT_CODE_FLWUP
	INTO v_incident_classification, v_IsNearMiss, v_deptCodeFlwup
	FROM PI_REPORT
	WHERE PIRID = i_pirID;

	v_rptSts := i_rptSts;

	v_IsMedicationIncident := 0;
	IF v_incident_classification IN ('8', '530') THEN
		v_IsMedicationIncident := 1;
	END IF;

	IF v_PxDeptCode = v_deptCodeFlwup THEN
		v_IsPxIncident := 1;
	ELSE
		v_IsPxIncident := 0;
	END IF;

	IF v_rptSts IN ('1', '14') AND v_IsMedicationIncident > 0 THEN
		-- Medication Report Department Head
		SELECT COUNT(1) INTO v_Count FROM PI_REPORT_PERSON_LIST WHERE PIR_TYPE = 'pharmacyd_dhead' AND ENABLE = '1';
		IF v_Count = 1 THEN
			SELECT PIR_STAFF_ID INTO v_staffID FROM PI_REPORT_PERSON_LIST WHERE PIR_TYPE = 'pharmacyd_dhead' AND ENABLE = '1';
		END IF;
	ELSIF v_rptSts IN ('2', '19', '29') THEN
		v_IsNursingStaffReporter := 0;
		SELECT COUNT(1) INTO v_Count FROM PI_REPORT P JOIN CO_USERS CU ON CU.CO_USERNAME = P.PIR_CREATED_USER OR CU.CO_STAFF_ID = P.PIR_CREATED_USER WHERE PIRID = i_pirID;
		IF v_Count = 1 THEN
			v_IsNursingStaffReporter := 1;
		END IF;

		v_IsPxReportNurse := 0;
		SELECT COUNT(1) INTO v_Count FROM PI_REPORT_FLWUP_DIALOG WHERE PIRID = i_pirID AND ENABLE = 1 AND PIR_WFL_STATUS = '12';
		IF v_Count = 1 THEN
			v_IsPxReportNurse := 1;
		END IF;

		IF v_IsMedicationIncident > 0 OR v_IsPxIncident > 0 THEN
			SELECT CO_DEPARTMENT_SUPERVISOR, CO_DEPARTMENT_HEAD, CO_DEPARTMENT_SUBHEAD
			INTO v_DeptSupervisor, v_DeptHead, v_DeptSubHead
			FROM  CO_DEPARTMENTS
			WHERE CO_DEPARTMENT_CODE = (
				SELECT CO_DEPARTMENT_CODE
				FROM CO_STAFFS
				WHERE CO_STAFF_ID = (SELECT PIR_RESPONSIBLE_PARTY_FLWUP FROM PI_REPORT WHERE PIRID = i_pirID)
			);
		ELSE
			SELECT CD.CO_DEPARTMENT_SUPERVISOR, CD.CO_DEPARTMENT_HEAD, CD.CO_DEPARTMENT_SUBHEAD
			INTO v_DeptSupervisor, v_DeptHead, v_DeptSubHead
			FROM PI_REPORT P
			JOIN CO_DEPARTMENTS CD ON CD.CO_DEPARTMENT_CODE = P.PIR_DEPT_CODE_FLWUP
			WHERE P.PIRID = i_pirID;
		END IF;

		IF v_IsMedicationIncident > 0 OR v_IsPxIncident > 0 THEN
			IF v_rptSts IN ('19', '29') THEN
				IF v_IsNursingStaffReporter > 0 OR v_IsPxReportNurse > 0 THEN
					v_staffID := v_DeptSubHead;
				ELSE
					v_staffID := v_DeptHead;
				END IF;
			ELSE
				SELECT COUNT(1) INTO v_Count FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_CODE = v_PxDeptCode;
				IF v_Count = 1 THEN
					SELECT CO_DEPARTMENT_HEAD INTO v_staffID FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_CODE = v_PxDeptCode;
				END IF;
			END IF;
		ELSE
			IF v_rptSts IN ('19', '29') THEN
				v_staffID := v_DeptSubHead;
			ELSE
				v_staffID := v_DeptSupervisor;
			END IF;
		END IF;
	ELSIF v_rptSts = '3' THEN
		SELECT COUNT(1) INTO v_Count FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_CODE = v_PIDeptCode;
		IF v_Count = 1 THEN
			SELECT CO_DEPARTMENT_HEAD INTO v_staffID FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_CODE = v_PIDeptCode;
		END IF;
	ELSIF v_rptSts = '4' THEN
		SELECT COUNT(1) INTO v_Count FROM PI_REPORT_PERSON_LIST WHERE PIR_TYPE = 'ceo' AND ENABLE = '1';
		IF v_Count = 1 THEN
			SELECT PIR_STAFF_ID INTO v_staffID FROM PI_REPORT_PERSON_LIST WHERE PIR_TYPE = 'ceo' AND ENABLE = '1';
		END IF;
	ELSIF v_rptSts = '7' THEN
		-- OSH/ICN
		v_staffID := '';
	ELSIF v_rptSts = '8' THEN
		SELECT COUNT(1) INTO v_Count FROM PI_REPORT_PERSON_LIST PL LEFT JOIN PI_PERSON_2_INCIDENT_CLASS IC ON PL.PIR_STAFF_ID = IC.PIR_STAFF_ID WHERE PL.PIR_TYPE = 'pharmacy' AND IC.PIR_INCIDENT_CLASS_PI = v_incident_classification;
		IF v_Count = 1 THEN
			SELECT PL.PIR_STAFF_ID INTO v_staffID FROM PI_REPORT_PERSON_LIST PL LEFT JOIN PI_PERSON_2_INCIDENT_CLASS IC ON PL.PIR_STAFF_ID = IC.PIR_STAFF_ID WHERE PL.PIR_TYPE = 'pharmacy' AND IC.PIR_INCIDENT_CLASS_PI = v_incident_classification;
		END IF;
	END IF;

	OPEN outcur FOR
		SELECT v_staffID
		FROM DUAL;

	RETURN outcur;
END HAT_GET_IRSPERSON;
/
