create or replace
FUNCTION "NHS_ACT_SCHEDULE" (
	v_action      IN VARCHAR2,
	v_SCHID       IN VARCHAR2,
	v_DOCCODE     IN SCHEDULE.DOCCODE@IWEB%TYPE,
	v_TEMSTIME    IN VARCHAR2,
	v_TEMETIME    IN VARCHAR2,
	v_SCHSDATE    IN VARCHAR2,
	v_SCHEDATE    IN VARCHAR2,
	v_TEMLEN      IN VARCHAR2,
	v_weekDay     IN VARCHAR2,
	v_DOCPRACTICE IN SCHEDULE.DOCPRACTICE@IWEB%TYPE,
	v_susrid      IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
RETURN  NUMBER
AS
	v_noOfRec NUMBER;
	v_SCHID1 NUMBER;
	v_TEMLEN1 NUMBER;
	v_TEMSTIME1 DATE;
	v_TEMETIME1 DATE;
	v_SCHSDATE1 DATE;
	v_SCHEDATE1 DATE;
	v_date DATE;
	v_STECODE VARCHAR2(20);
	v_SCHNSLOT NUMBER;
	v_H NUMBER;
	v_M NUMBER;
	v_date1 DATE;
	v_date2 DATE;
	v_SLTID NUMBER;
BEGIN
	v_noOfRec := -1;
	o_errmsg := 'OK';
	v_STECODE := 'HKAH';
	--transfer
	v_SCHID1 := to_number(v_SCHID);
	v_TEMLEN1 := to_number(v_TEMLEN);
	v_TEMSTIME1 := to_date(v_TEMSTIME,'hh24:mi');
	v_TEMETIME1 := to_date(v_TEMETIME,'hh24:mi');
	v_SCHSDATE1 := to_date(((v_SCHSDATE||' '||v_TEMSTIME)),'dd/mm/yyyy hh24:mi');
	v_SCHEDATE1 := to_date(((v_SCHEDATE||' '||v_TEMETIME)),'dd/mm/yyyy hh24:mi');

	--add schedule
	FOR i In 0..to_number(to_char(v_SCHEDATE1,'ddd')) - to_number(to_char(v_SCHSDATE1,'ddd'))  LOOP
		v_date :=  to_date(to_char(v_SCHSDATE1+i,'dd/mm/yyyy hh24:mi'),'dd/mm/yyyy hh24:mi');
		IF v_weekDay = to_char(v_date,'D') THEN
			SELECT count(1) INTO v_noOfRec
			FROM   SCHEDULE@IWEB WHERE doccode = v_DOCCODE
			and    to_char(SCHSDATE,'dd/mm/yyyy hh24:mi') <= to_char(v_date,'dd/mm/yyyy hh24:mi')
			and    to_char(SCHEDATE,'dd/mm/yyyy hh24:mi') >= to_char(v_date,'dd/mm/yyyy hh24:mi');

			IF v_noOfRec<=0 THEN
				v_H := to_number(to_char(v_TEMETIME1,'hh24')) - to_number(to_char(v_TEMSTIME1,'hh24'));
				v_M := to_number(to_char(v_TEMETIME1,'mi')) - to_number(to_char(v_TEMSTIME1,'mi'));
				v_SCHNSLOT := floor((v_H*60+v_M)/v_TEMLEN);

				SELECT SEQ_SCHEDULE.NEXTVAL@IWEB into v_SCHID1 from dual;

				INSERT INTO SCHEDULE@IWEB(
					SCHID,
					DOCCODE,
					STECODE,
					SCHSDATE,
					SCHEDATE,
					SCHLEN,
					SCHNSLOT,
					SCHCNT,
					SCHSTS,
					DOCPRACTICE,
					USRID_C
				) VALUES(
					v_SCHID1,
					v_DOCCODE,
					v_STECODE,
					to_date(to_char(v_date,'dd/mm/yyyy hh24:mi'),'dd/mm/yyyy hh24:mi'),
					to_date(to_char((v_date+(v_SCHNSLOT*v_TEMLEN1-1)/(24*60)),'dd/mm/yyyy hh24:mi'),'dd/mm/yyyy hh24:mi'),
					v_TEMLEN1,
					v_SCHNSLOT,
					0,
					'N',
					v_DOCPRACTICE,
					v_susrid
				);

				--add slot
				v_date1 := to_date(((to_char(v_date,'dd/mm/yyyy')||' '||v_TEMSTIME)),'dd/mm/yyyy hh24:mi');
				v_date2 := to_date(((to_char(v_date,'dd/mm/yyyy')||' '||v_TEMETIME)),'dd/mm/yyyy hh24:mi');

				WHILE v_date2 - v_date1 > 0 LOOP
					select seq_slot.NEXTVAL@IWEB into v_SLTID from dual;
					INSERT INTO SLOT@IWEB(
						SCHID,
						SLTID,
						SLTCNT,
						SLTSTIME
					) VALUES(
						v_SCHID1,
						v_SLTID,
						0,
						v_date1
					);

					v_date1 := to_date(to_char((v_date1+v_TEMLEN1/(24*60)),'dd/MM/yyyy hh24:mi'),'dd/MM/yyyy hh24:mi');
				END LOOP;
				v_noOfRec := 0;
			ELSE
				o_errmsg := 'Duplicated schedule.';
			END IF;
		END IF;
	END LOOP;
	return v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	v_noOfRec := -1;
	o_errmsg := 'Fail to generate schedule.';
	return v_noOfRec;
	ROLLBACK;
	END NHS_ACT_SCHEDULE;