CREATE OR REPLACE FUNCTION "NHS_UTL_HKID_CHKDIGIT"(
	i_HKID IN VARCHAR2
)
	RETURN VARCHAR2
AS
	v_HKID_CHKDIGIT VARCHAR2(20);
BEGIN
	SELECT
		11 - mod
		(
		324
		+ decode(SUBSTR (i_HKID, 1, 1), '1', 1, '2', 2, '3', 3, '4', 4, '5', 5, '6', 6, '7', 7, '8', 8, '9', 9, 'A', 10, 'B', 11, 'C', 12, 'D', 13, 'E', 14, 'F', 15, 'G', 16, 'H', 17, 'I', 18, 'J', 19, 'K', 20, 'L', 21, 'M', 22, 'N', 23, 'O', 24, 'P', 25, 'Q', 26, 'R', 27, 'S', 28, 'T', 29, 'U', 30, 'V', 31, 'W', 32, 'X', 33, 'Y', 34, 'Z', 35, 0 ) * 8
		+ to_number(substr(i_HKID, 2, 1)) * 7
		+ to_number(substr(i_HKID, 3, 1)) * 6
		+ to_number(substr(i_HKID, 4, 1)) * 5
		+ to_number(substr(i_HKID, 5, 1)) * 4
		+ to_number(substr(i_HKID, 6, 1)) * 3
		+ to_number(substr(i_HKID, 7, 1)) * 2
		, 11) INTO v_HKID_CHKDIGIT
	FROM DUAL;

	IF v_HKID_CHKDIGIT = '10' THEN
		RETURN 'A';
	ELSIF v_HKID_CHKDIGIT = '11' THEN
		RETURN '0';
	ELSE
		RETURN v_HKID_CHKDIGIT;
	END IF;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_HKID_CHKDIGIT;
/
