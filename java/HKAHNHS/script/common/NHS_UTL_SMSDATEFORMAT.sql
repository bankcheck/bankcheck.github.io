CREATE OR REPLACE FUNCTION "NHS_UTL_SMSDATEFORMAT" (
	i_Language IN VARCHAR2,
	i_SMSDate IN DATE
)
	RETURN VARCHAR2
AS
	outcur Types.cursor_type;
	v_SMSDate VARCHAR2(100);
	v_SMSTIME_YYYY VARCHAR2(10);
	v_SMSTIME_MON VARCHAR2(10);
	v_SMSTIME_DD VARCHAR2(10);
	v_SMSTIME_DAY VARCHAR2(10);
	v_SMSTIME_HH VARCHAR2(10);
	v_SMSTIME_MI VARCHAR2(10);
	v_SMSTIME_AM VARCHAR2(10);
	v_COUNT NUMBER;
BEGIN
	IF i_Language = 'zh-HK' OR i_Language = 'zh-CN' THEN
		SELECT TO_CHAR(i_SMSDate, 'YYYY', 'NLS_DATE_LANGUAGE = ''Traditional Chinese'''),
			TO_CHAR(i_SMSDate, 'MM', 'NLS_DATE_LANGUAGE = ''Traditional Chinese'''),
			TO_CHAR(i_SMSDate, 'DD', 'NLS_DATE_LANGUAGE = ''Traditional Chinese'''),
			TO_CHAR(i_SMSDate, 'Day', 'NLS_DATE_LANGUAGE = ''Traditional Chinese'''),
			TO_CHAR(i_SMSDate, 'HH', 'NLS_DATE_LANGUAGE = ''Traditional Chinese'''),
			TO_CHAR(i_SMSDate, 'MI', 'NLS_DATE_LANGUAGE = ''Traditional Chinese'''),
			TO_CHAR(i_SMSDate, 'AM', 'NLS_DATE_LANGUAGE = ''Traditional Chinese''')
		INTO v_SMSTIME_YYYY, v_SMSTIME_MON, v_SMSTIME_DD, v_SMSTIME_DAY, v_SMSTIME_HH, v_SMSTIME_MI, v_SMSTIME_AM
		FROM DUAL;

		IF v_SMSTIME_MI = '00' THEN
			v_SMSDate := NHS_UTL_ERRORMESSAGE('MOBILEFORMAT', 'DATE_NOMINUTE', i_Language);
		ELSE
			v_SMSDate := NHS_UTL_ERRORMESSAGE('MOBILEFORMAT', 'DATE', i_Language);
		END IF;
	ELSIF i_Language = 'jp' THEN
		SELECT TO_CHAR(i_SMSDate, 'YYYY', 'NLS_DATE_LANGUAGE = ''Japanese'''),
			TO_CHAR(i_SMSDate, 'MM', 'NLS_DATE_LANGUAGE = ''Japanese'''),
			TO_CHAR(i_SMSDate, 'DD', 'NLS_DATE_LANGUAGE = ''Japanese'''),
			TO_CHAR(i_SMSDate, 'Day', 'NLS_DATE_LANGUAGE = ''Japanese'''),
			TO_CHAR(i_SMSDate, 'HH', 'NLS_DATE_LANGUAGE = ''Japanese'''),
			TO_CHAR(i_SMSDate, 'MI', 'NLS_DATE_LANGUAGE = ''Japanese'''),
			TO_CHAR(i_SMSDate, 'AM', 'NLS_DATE_LANGUAGE = ''Japanese''')
		INTO v_SMSTIME_YYYY, v_SMSTIME_MON, v_SMSTIME_DD, v_SMSTIME_DAY, v_SMSTIME_HH, v_SMSTIME_MI, v_SMSTIME_AM
		FROM DUAL;

		IF v_SMSTIME_MI = '00' THEN
			v_SMSDate := NHS_UTL_ERRORMESSAGE('MOBILEFORMAT', 'DATE_NOMINUTE', i_Language);
		ELSE
			v_SMSDate := NHS_UTL_ERRORMESSAGE('MOBILEFORMAT', 'DATE', i_Language);
		END IF;
	ELSE
		SELECT TO_CHAR(i_SMSDate, 'YYYY', 'NLS_DATE_LANGUAGE = ''American'''),
			TO_CHAR(i_SMSDate, 'Mon', 'NLS_DATE_LANGUAGE = ''American'''),
			TO_CHAR(i_SMSDate, 'DD', 'NLS_DATE_LANGUAGE = ''American'''),
			TO_CHAR(i_SMSDate, 'Dy', 'NLS_DATE_LANGUAGE = ''American'''),
			TO_CHAR(i_SMSDate, 'HH24', 'NLS_DATE_LANGUAGE = ''American'''),
			TO_CHAR(i_SMSDate, 'MI', 'NLS_DATE_LANGUAGE = ''American'''),
			''
		INTO v_SMSTIME_YYYY, v_SMSTIME_MON, v_SMSTIME_DD, v_SMSTIME_DAY, v_SMSTIME_HH, v_SMSTIME_MI, v_SMSTIME_AM
		FROM DUAL;

		v_SMSDate := NHS_UTL_ERRORMESSAGE('MOBILEFORMAT', 'DATE', 'en');
	END IF;

	v_SMSDate := REPLACE(v_SMSDate, '{0}', v_SMSTIME_YYYY);
	v_SMSDate := REPLACE(v_SMSDate, '{1}', v_SMSTIME_MON);
	v_SMSDate := REPLACE(v_SMSDate, '{2}', v_SMSTIME_DD);
	v_SMSDate := REPLACE(v_SMSDate, '{3}', v_SMSTIME_DAY);
	v_SMSDate := REPLACE(v_SMSDate, '{4}', v_SMSTIME_HH);
	v_SMSDate := REPLACE(v_SMSDate, '{5}', v_SMSTIME_MI);
	v_SMSDate := REPLACE(v_SMSDate, '{6}', v_SMSTIME_AM);

	RETURN v_SMSDate;

END NHS_UTL_SMSDATEFORMAT;
/
