create or replace FUNCTION "NHS_ACT_TEMPLATE" (
	i_action IN VARCHAR2,
	i_Userid IN Varchar2,
	i_Table  IN TEMPLATE_OBJ_TAB,
	o_errMsg OUT VARCHAR2
)
	RETURN NUMBER
As
	o_errCode NUMBER;
	v_noOfRec NUMBER;
	v_noOfRec1 NUMBER;
	v_noOfRec2 NUMBER;
	v_TemID1 NUMBER;
	v_TemDay1 NUMBER;
	v_TemLen1 NUMBER;
	v_TemSTime1 DATE;
	v_TemETime1 DATE;
	v_DOCLOCID NUMBER;
  v_RMID TEMPLATE.RMID%TYPE;
	err_rec_exist Exception;
	err_update exception;
	err_time_overlap exception;
	err_delete Exception;
	err_access_right Exception;
Begin
	o_errCode := 0;
	o_errMsg := 'OK';

	-- check access right
	SELECT COUNT(1) INTO v_noOfRec2 FROM USRACCESSDOC WHERE USRID = i_Userid;

	FOR I In 1..i_Table.Count
	LOOP
		IF v_noOfRec2 > 0 THEN
			SELECT COUNT(1) INTO v_noOfRec
			FROM   doctor
			WHERE  docsts = -1
			AND    DOCCODE = i_Table(i).COLUMN10
			AND   (DOCCODE IN (SELECT DOCCODE FROM USRACCESSDOC WHERE USRID = i_Userid AND SPCCODE = 'ALL')
			OR     SPCCODE IN (SELECT SPCCODE FROM USRACCESSDOC WHERE USRID = i_Userid  AND DOCCODE = 'ALL'));

			IF v_noOfRec = 0 THEN
				raise err_access_right;
			END IF;
		END IF;

		v_TemID1 := NULL;
		IF i_Table(I).COLUMN09 IS NOT NULL THEN
			v_TemID1 := TO_NUMBER(i_Table(i).COLUMN09);
		END IF;

		v_TemDay1 := TO_NUMBER(i_Table(i).COLUMN02);
		v_TemLen1 := TO_NUMBER(i_Table(i).COLUMN04);
		v_TemSTime1 := TO_DATE(i_Table(i).COLUMN05, 'HH24:MI');
		v_TemETime1 := TO_DATE(i_Table(i).COLUMN06, 'HH24:MI');
		v_DOCLOCID := TO_NUMBER(i_Table(i).COLUMN08);
    v_RMID := i_Table(i).COLUMN11;
    
		IF v_TemID1 IS NULL THEN
			-- INSERT
			SELECT SEQ_TEMPLATE.NEXTVAL INTO v_TemID1 FROM DUAL;

			SELECT count(1) INTO v_noOfRec FROM TEMPLATE
			WHERE DOCCODE = i_Table(i).COLUMN10 AND TEMDAY = v_TemDay1
			AND (
					(
						TO_DATE(TO_CHAR(TEMSTIME,'hh24:mi'),'hh24:mi') <= v_TemSTime1 AND TO_DATE(TO_CHAR(TEMETIME,'hh24:mi'),'hh24:mi') >= v_TemSTime1
					)
				OR
					(
						TO_DATE(TO_CHAR(TEMSTIME,'hh24:mi'),'hh24:mi') <= v_TemSTime1 AND TO_DATE(TO_CHAR(TEMETIME,'hh24:mi'),'hh24:mi') >= v_TemSTime1
					)
				OR
					(
						TO_DATE(TO_CHAR(TEMSTIME,'hh24:mi'),'hh24:mi') <= v_TemETime1 AND TO_DATE(TO_CHAR(TEMETIME,'hh24:mi'),'hh24:mi') >= v_TemSTime1
					)
				);

			IF v_noOfRec = 0 THEN
				o_errCode := i_Table.COUNT;
				INSERT INTO TEMPLATE(
					TEMID,
					DOCCODE,
					TEMDAY,
					TEMLEN,
					TEMSTIME,
					TEMETIME,
					DOCPRACTICE,
					DOCLOCID,
					STECODE,
          RMID
				) VALUES(
					v_TemID1,
					i_Table(i).COLUMN10,
					v_TemDay1,
					v_TemLen1,
					v_TemSTime1,
					v_TemETime1,
					i_Table(i).COLUMN07,
					v_DOCLOCID,
					GET_CURRENT_STECODE,
          v_RMID
				);
				o_errCode := v_TemID1;
			ELSE
				raise err_rec_exist;
			END IF;
		ELSIF v_TemID1 > 0 THEN
			-- UPDATE
			SELECT count(1) INTO v_noOfRec FROM TEMPLATE WHERE TEMID = v_TemID1;

			IF v_noOfRec > 0 THEN
				SELECT count(1) INTO v_noOfRec1 FROM TEMPLATE
				WHERE DOCCODE = i_Table(i).COLUMN10 AND TEMDAY = v_TemDay1
				AND (
					(
						TO_DATE(TO_CHAR(TEMSTIME, 'hh24:mi'),'hh24:mi') <= v_TemSTime1 AND TO_DATE(TO_CHAR(TEMETIME, 'hh24:mi'), 'hh24:mi') >= v_TemSTime1
					)
					OR
					(
						TO_DATE(TO_CHAR(TEMSTIME, 'hh24:mi'),'hh24:mi') <= v_TemSTime1 AND TO_DATE(TO_CHAR(TEMETIME, 'hh24:mi'), 'hh24:mi') >= v_TemSTime1
					)
					OR
					(
						TO_DATE(TO_CHAR(TEMSTIME, 'hh24:mi'),'hh24:mi') <= v_TemETime1 AND TO_DATE(TO_CHAR(TEMETIME, 'hh24:mi'), 'hh24:mi') >= v_TemSTime1
					)
				)
				AND temid <> v_Temid1;

				IF v_noOfRec1 > 0 then
					raise err_time_overlap;
				ELSE
					UPDATE TEMPLATE
					SET
						TEMDAY = v_TemDay1,
						TEMLEN = v_TemLen1,
						TEMSTIME = v_TemSTime1,
						TEMETIME = v_TemETime1,
						DOCPRACTICE = i_Table(i).COLUMN07,
						DOCLOCID = v_DOCLOCID,
            RMID = v_RMID
					WHERE TEMID = v_TemID1;
				END IF;
			ELSE
				raise err_update;
			END IF;
		ELSIF v_TemID1 < 0 THEN
			v_TemID1 := -v_TemID1;
			-- DELETE
			SELECT count(1) INTO v_noOfRec FROM TEMPLATE WHERE TEMID = v_TemID1;
			IF v_noOfRec > 0 THEN
				DELETE FROM TEMPLATE WHERE TEMID = v_TemID1;
			ELSE
				raise err_delete;
			END IF;
		END IF;
	END LOOP;

	RETURN o_errCode;
EXCEPTION
WHEN err_rec_exist THEN
	ROLLBACK;
	o_errCode := -2;
	o_errMsg := 'Record already exists.';
	RETURN o_errCode;
WHEN err_update THEN
	ROLLBACK;
	o_errCode := -3;
	o_errMsg := 'Fail to update template due to record not exist.';
	RETURN o_errCode;
WHEN err_time_overlap THEN
	ROLLBACK;
	o_errCode := -4;
	o_errMsg := 'Fail to delete template due to time overlap with other.';
	RETURN o_errCode;
WHEN err_delete THEN
	ROLLBACK;
	o_errCode := -5;
	o_errMsg := 'Fail to delete template due to record not exist.';
	RETURN o_errCode;
WHEN err_access_right THEN
	ROLLBACK;
	o_errCode := -6;
	o_errMsg := 'Fail to update template due to no user rights to updat selected doctor.';
	RETURN o_errCode;
WHEN OTHERS THEN
	ROLLBACK;
	o_errCode := -1;
	o_errMsg := 'Fail to save template due to ' || SQLERRM || '.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_errCode;
END NHS_ACT_TEMPLATE;
/