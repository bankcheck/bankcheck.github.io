CREATE OR REPLACE FUNCTION "HAT_GET_IRSSTATUS"(
	i_action IN VARCHAR2,
	i_staffID IN VARCHAR2,
	i_pirID IN VARCHAR2,
	i_rptSts IN VARCHAR2,
	i_command IN VARCHAR2
)
	RETURN types.cursor_type
AS
	outcur types.cursor_type;
	v_Count NUMBER;
	v_incident_classification PI_REPORT.PIR_INCIDENT_CLASSIFICATION%TYPE;
	v_IsNearMiss PI_REPORT.PIR_NEAR_MISS%TYPE;
	v_deptCodeFlwup PI_REPORT.PIR_DEPT_CODE_FLWUP%TYPE;
	v_hazardousCondition PI_REPORT.PIR_HAZARDOUS_CONDITION%TYPE;
	v_hazardousConditionPI PI_REPORT.PIR_HAZARDOUS_CONDITION_PI%TYPE;
	v_rptSts PI_REPORT.PIR_STATUS%TYPE;
	v_newRptSts PI_REPORT.PIR_STATUS%TYPE;
	v_PxDeptCode PI_REPORT.PIR_DEPT_CODE_FLWUP%TYPE;

	v_IsVisitorBBF NUMBER;
	v_IsStaffIncident NUMBER;
	v_IsMedicationIncident NUMBER;
	v_IsPxIncident NUMBER;
	v_IsPharmacyStaff NUMBER;
	v_IsOshIcn NUMBER;
	v_IsSubHead NUMBER;
	v_IsSeniorPharmacyStaff NUMBER;
BEGIN
	IF GET_CURRENT_STECODE@IWEB = 'TWAH' THEN
		v_PxDeptCode := 'PHAR';
	ELSE
		v_PxDeptCode := '380';
	END IF;

	SELECT PIR_INCIDENT_CLASSIFICATION, PIR_NEAR_MISS, PIR_DEPT_CODE_FLWUP, PIR_HAZARDOUS_CONDITION, PIR_HAZARDOUS_CONDITION_PI, PIR_STATUS
	INTO v_incident_classification, v_IsNearMiss, v_deptCodeFlwup, v_hazardousCondition, v_hazardousConditionPI, v_rptSts
	FROM PI_REPORT
	WHERE PIRID = i_pirID;

	SELECT COUNT(1) INTO v_IsVisitorBBF FROM PI_REPORT_CONTENT WHERE PIRID = i_pirID AND PI_OPTION_ID = '1600';

	v_IsStaffIncident := 0;
	IF v_incident_classification IN ('2', '5', '7', '700') THEN
		v_IsStaffIncident := 1;
	ELSIF GET_CURRENT_STECODE@IWEB = 'TWAH' AND v_IsVisitorBBF > 0 THEN
		v_IsStaffIncident := 1;
	END IF;

	v_IsMedicationIncident := 0;
	IF v_incident_classification IN ('8', '530') THEN
		v_IsMedicationIncident := 1;
	END IF;

	IF v_PxDeptCode = v_deptCodeFlwup THEN
		v_IsPxIncident := 1;
	ELSE
		v_IsPxIncident := 0;
	END IF;

	v_IsPharmacyStaff := 0;
	v_IsOshIcn := 0;
	v_IsSubHead := 0;
	IF i_staffID IS NOT NULL THEN
		SELECT COUNT(1) INTO v_IsPharmacyStaff FROM CO_STAFFS WHERE CO_STAFF_ID = i_staffID AND CO_DEPARTMENT_CODE = v_PxDeptCode;

		SELECT COUNT(1) INTO v_IsOshIcn FROM PI_REPORT_PERSON_LIST WHERE PIR_TYPE IN ('osh', 'icn') AND PIR_STAFF_ID = i_staffID AND ENABLE = '1';

		SELECT COUNT(1) INTO v_IsSubHead FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_SUBHEAD = i_staffID AND CO_DEPARTMENT_CODE = (SELECT PIR_DEPT_CODE_FLWUP FROM PI_REPORT WHERE PIRID = i_pirID);
	END IF;

	IF i_command = 'fu_change_resp_person_osh_icn' OR (v_IsPxIncident > 0 AND v_rptSts = '29') OR (v_IsPxIncident = 0 AND v_rptSts IN ('11', '19')) THEN
		v_newRptSts := '7';
	ELSIF v_rptSts IS NULL OR v_rptSts = '0' THEN
		IF GET_CURRENT_STECODE@IWEB = 'TWAH' AND i_command IN ('create_saveonly', 'update_saveonly') THEN
			-- check if save only for TWAH reporter
			v_newRptSts := '0';
		ELSIF GET_CURRENT_STECODE@IWEB = 'TWAH' AND (v_incident_classification = '530' OR (v_IsNearMiss = '1' AND v_incident_classification = '8')) THEN
			v_newRptSts := '8';
		ELSIF GET_CURRENT_STECODE@IWEB = 'TWAH' AND v_incident_classification in ('8', '530') AND (v_hazardousCondition = 1 OR v_hazardousConditionPI = 1) THEN
			-- medication incident
			v_newRptSts := '8';
		ELSIF v_incident_classification IN ('2', '5', '7', '700') THEN
			-- if staff case, set refer to osh/icn
			v_newRptSts := '11';
		ELSIF v_PxDeptCode = v_deptCodeFlwup OR i_command = 'create_px2' THEN
			-- if medication case, set refer to pharmacy
			IF v_IsPharmacyStaff > 0 AND i_command != 'create_px2' THEN
				v_newRptSts := '8';
			ELSE
				-- check if submit report for nurse, then send to dm/um
				v_newRptSts := '12';
			END IF;
		ELSIF v_IsMedicationIncident > 0 THEN
			v_newRptSts := '12';
		ELSIF GET_CURRENT_STECODE@IWEB = 'TWAH' AND v_IsVisitorBBF > 0 THEN
			-- check if visitor inj but has BBF (option_id 1600)
			v_newRptSts := '11';
		ELSE
			v_newRptSts := '1';
		END IF;
	ELSIF v_rptSts NOT IN ('2', '3', '4', '5') AND GET_CURRENT_STECODE@IWEB = 'TWAH' AND (v_incident_classification = '530' OR (v_IsNearMiss > 0 AND v_incident_classification = '8')) THEN
		IF v_rptSts = '8' THEN
			-- Pending Senior Pharmacist input
			v_newRptSts := '1';
		ELSIF v_rptSts = '1' THEN
			-- Pending Chief Pharmacist input
			v_newRptSts := '14';
		ELSIF v_rptSts = '14' THEN
			SELECT COUNT(1) INTO v_Count
			FROM   pi_report_px_comment
			WHERE  PIRID = i_pirID
			AND    ENABLE = 1
			AND    PIR_RISK_ASS >= 4;

			-- to administrator if SI >= 4
			IF v_Count > 0 THEN
				-- Pending Administrator
				v_newRptSts := '2';
			ELSE
				-- Pending PI
				v_newRptSts := '3';
			END IF;
		ELSE
			-- Pending Senior Pharmacist Acceptance
			v_newRptSts := '8';
		END IF;
	ELSIF v_rptSts IN ('1', '10', '11', '12', '14', '19') THEN
		IF i_command = 'fu_px_submit' OR (v_rptSts = '1' AND (v_IsMedicationIncident > 0 OR v_IsPxIncident > 0)) OR (v_IsStaffIncident > 0 AND v_IsPxIncident > 0 AND v_rptSts = '11') THEN
			-- Wait for Chief Pharmacist Input
			v_newRptSts := '14';
		ELSIF i_command = 'fu_px2pi_submit' THEN
			-- Wait for PI Manager
			v_newRptSts := '3';
		ELSIF v_IsMedicationIncident > 0 AND v_rptSts IN ('12', '19') THEN
			v_newRptSts := '8';
		ELSIF v_isSubHead > 0 THEN
			IF v_rptSts IN ('14', '19') THEN
				IF (v_IsStaffIncident > 0 OR v_IsMedicationIncident > 0) AND v_rptSts = '19' THEN
					v_newRptSts := '8';
				ELSE
					v_newRptSts := '2';
				END IF;
			ELSIF v_rptSts = '1' THEN
				IF v_IsOshIcn > 0 THEN
					v_newRptSts := '2';
				ELSE
					v_newRptSts := '19';
				END IF;
			ELSIF v_rptSts IN ('11', '12') THEN
				v_newRptSts := '19';
			END IF;
		ELSIF v_IsPxIncident > 0 AND v_rptSts NOT IN ('1', '14') THEN
			-- 19022018 all inc type use px flow
			v_newRptSts := '29';
		ELSE
			v_newRptSts := '2';
		END IF;
	ELSIF v_rptSts IN ('2', '8', '9') THEN
		v_newRptSts := '3';
	ELSIF v_rptSts = '3' THEN
		v_newRptSts := '4';
	ELSIF v_rptSts = '4' THEN
		v_newRptSts := '5';
	ELSIF (v_rptSts = '7' AND v_IsOshIcn > 0) OR (v_rptSts = '8' AND v_IsSeniorPharmacyStaff > 0) THEN
		v_newRptSts := '1';
	ELSIF v_rptSts = '29' THEN
		-- 18092018 all inc type use px flow
		v_newRptSts := '7';
	END IF;

	OPEN outcur FOR
		SELECT v_newRptSts
		FROM DUAL;

	RETURN outcur;
END HAT_GET_IRSSTATUS;
/
