CREATE OR REPLACE FUNCTION "HAT_ACT_STAFF_AMC2" (
	i_action   IN VARCHAR2,
	i_staff_id  IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	o_errcode NUMBER;
BEGIN
	o_errcode := -1;
	
	IF i_action = 'ADD' THEN
		insert into co_staffs@amc2_portal
		select * from co_staffs where co_staff_id = i_staff_id;
		
		insert into co_users@amc2_portal
		select * from co_users where co_staff_id = i_staff_id;
	
		insert into sso_user@amc2_portal
		select * from sso_user@sso where STAFF_NO = i_staff_id;
		
		/*
		insert into sso_user_mapping@amc_portal
		select * from sso_user_mapping@sso where SSO_USER_ID = i_staff_id;
		*/
		
		o_errcode := 0;
	END IF;

	RETURN o_errcode;
END HAT_ACT_STAFF_AMC2;
/