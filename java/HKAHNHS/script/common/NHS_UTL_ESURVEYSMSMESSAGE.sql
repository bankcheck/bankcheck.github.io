create or replace FUNCTION NHS_UTL_ESURVEYSMSMESSAGE(
    i_Language IN VARCHAR2,
	i_SMSID    IN VARCHAR2,
    i_regID    IN NUMBER
)
    RETURN VARCHAR2 
AS 
    v_SURVEY_MSG VARCHAR2(1000);
BEGIN
    /* check if language is not chinese or english */
    IF i_Language != 'en' AND i_Language != 'zh-HK' THEN
        v_SURVEY_MSG := NHS_UTL_SMSMESSAGE('en', i_SMSID, null, null);
    ELSE
        v_SURVEY_MSG := NHS_UTL_SMSMESSAGE(i_Language, i_SMSID, null, null);
    END IF;

    v_SURVEY_MSG := REPLACE(v_SURVEY_MSG, '{0}', NHS_UTL_GETESURVEYLINK(i_regID));
    
    RETURN  v_SURVEY_MSG;
END NHS_UTL_ESURVEYSMSMESSAGE;