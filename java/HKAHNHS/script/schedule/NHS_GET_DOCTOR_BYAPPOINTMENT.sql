CREATE OR REPLACE FUNCTION NHS_GET_DOCTOR_BYAPPOINTMENT (
	v_SpecCode VARCHAR2,
	v_DocCode  VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_Count NUMBER;
	V_REMARK VARCHAR(500) := '';
BEGIN
	IF GET_CURRENT_STECODE = 'HKAH' THEN
		IF v_DocCode IS NOT NULL THEN
			IF v_DocCode IN ('1893', '1863', '2249', '2423') THEN
				OPEN OUTCUR FOR
					SELECT 'Please refer to ' || D.DOCCODE || ', DR. ' || D.DOCFNAME || ' ' || D.DOCGNAME || ' is By Appointment Doctor.'
					FROM   DOCTOR D
					WHERE  D.DOCSTS = -1
					AND    D.DOCCODE IN ('8410', '8409', '8412', '8413')
					AND    D.MSTRDOCCODE = v_DocCode
					AND    D.MSTRDOCCODE IN ('1893', '1863', '2249', '2423');
			ELSIF v_DocCode IN ('2248') THEN
				OPEN OUTCUR FOR
					SELECT 'Please refer to ' || D.DOCCODE || ' for Booking.'
					FROM   DOCTOR D
					WHERE  D.DOCSTS = -1
					AND    D.DOCCODE IN ('8411')
					AND    D.MSTRDOCCODE = v_DocCode
					AND    D.MSTRDOCCODE IN ('2248');
			ELSE
				SELECT COUNT(1) INTO v_Count
				FROM   DOCTOR D
				LEFT JOIN TEMPLATE T ON D.DOCCODE = T.DOCCODE
				WHERE  D.DOCSTS = -1
				AND    D.DOCCODE = v_DocCode
				GROUP BY D.ISPOSTSCHEDULE, D.DOCCODE
				HAVING D.Ispostschedule = -1 AND COUNT(T.DOCCODE) = 0;

				IF v_Count > 0 THEN
					IF v_DocCode = '1822' THEN
						V_REMARK := '<br />Do not see patient below 12-year-old.';
						IF sysdate < to_date('26/05/2022 00:00:00', 'dd/mm/yyyy hh24:mi:ss') THEN
							V_REMARK := V_REMARK || '<br />No booking on every Wednesday & Thursday afternoon from 10 Mar – 31 May 2022.';
						END IF;
					END IF;
					
					OPEN OUTCUR FOR
						SELECT 'DR. ' || D.DOCFNAME || ' ' || D.DOCGNAME || ' (' || D.DOCCODE || ') is By Appointment Doctor. ' || V_REMARK
						FROM   DOCTOR D
						WHERE  D.DOCSTS = -1
						AND    D.DOCCODE = v_DocCode;
				END IF;
			END IF;
		END IF;
	END IF;

	RETURN OUTCUR;
END NHS_GET_DOCTOR_BYAPPOINTMENT;
/
