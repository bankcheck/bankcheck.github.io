CREATE OR REPLACE FUNCTION "HAT_ACT_CREATEDOCTOR" (
	i_action   IN VARCHAR2,
	i_doccode  IN VARCHAR2,
	i_password IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	v_doccode VARCHAR2(10);
	o_errcode NUMBER;
BEGIN
	o_errcode := 0;

	-- find master doctor code
	SELECT COUNT(1) INTO v_noOfRec
	FROM   doctor@IWEB
	WHERE  doccode = i_doccode
	AND    mstrdoccode is not null;

	IF v_noOfRec = 1 THEN
		SELECT mstrdoccode INTO v_doccode
		FROM   doctor@IWEB
		WHERE  doccode = i_doccode
		AND    mstrdoccode is not null;
	ELSE
		v_doccode := i_doccode;
	END IF;

	-- insert into staff
	SELECT COUNT(1) INTO v_noOfRec
	FROM   doctor@IWEB
	WHERE  doccode = v_doccode
	AND    doccode NOT IN (SELECT substr(co_staff_id, 3) FROM co_staffs WHERE co_staff_id LIKE 'DR%');

	IF v_noOfRec = 1 THEN
		INSERT INTO co_staffs (co_site_code, co_staff_id, co_staffname, co_lastname, co_firstname, co_mark_deleted)
		SELECT LOWER(GET_CURRENT_STECODE@IWEB), 'DR' || doccode, docfname || ' ' || docgname, docfname, docgname, 'Y'
		FROM   doctor@IWEB
		WHERE  doccode = v_doccode
		AND    doccode NOT IN (SELECT substr(co_staff_id, 3) FROM co_staffs WHERE co_staff_id LIKE 'DR%');
	END IF;

	-- insert into user
	SELECT COUNT(1) INTO v_noOfRec
	FROM   doctor@IWEB
	WHERE  doccode = v_doccode
	AND    hkmclicno IS NOT NULL
	AND    hkmclicno NOT IN (SELECT co_username FROM co_users);

	IF v_noOfRec = 1 THEN
		INSERT INTO co_users (co_site_code, co_group_id, co_staff_YN, co_username, co_password, co_lastname, co_firstname, co_staff_id)
		SELECT LOWER(GET_CURRENT_STECODE@IWEB), 'doctor', 'Y', hkmclicno, i_password, docfname, docgname, 'DR' || doccode
		FROM   doctor@IWEB
		WHERE  doccode = v_doccode
		AND    hkmclicno IS NOT NULL
		AND    hkmclicno NOT IN (SELECT co_username FROM co_users);
	END IF;

	-- insert into ac_user_groups
	SELECT COUNT(1) INTO v_noOfRec
	FROM   doctor@IWEB
	WHERE  doccode = v_doccode
	AND    doccode NOT IN (SELECT substr(ac_staff_id, 3) FROM ac_user_groups WHERE ac_staff_id like 'DR%' AND ac_group_id = 'financial.estimation');

	IF v_noOfRec = 1 THEN
		INSERT INTO ac_user_groups (ac_site_code, ac_staff_id, ac_user_id, ac_group_id)
		SELECT LOWER(GET_CURRENT_STECODE@IWEB), 'DR' || doccode, 'DR' || doccode, 'financial.estimation'
		FROM   doctor@IWEB
		WHERE  doccode = v_doccode
		AND    doccode NOT IN (SELECT substr(ac_staff_id, 3) FROM ac_user_groups WHERE ac_staff_id like 'DR%' AND ac_group_id = 'financial.estimation');
	END IF;

	RETURN o_errcode;
END HAT_ACT_CREATEDOCTOR;
/