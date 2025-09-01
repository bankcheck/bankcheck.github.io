CREATE OR REPLACE FUNCTION NHS_UTL_BOOKING_MOVE (
	i_DOCCODE_FM	IN VARCHAR2,
	i_DOCCODE_TO	IN VARCHAR2,
	i_FROM_TIME     IN DATE,
	i_TO_TIME	    IN DATE
)
	RETURN NUMBER
IS
	SCH_NORMAL VARCHAR(1) := 'N';
	SCH_CONFIRM VARCHAR(1) := 'F';
	SCH_BLOCK VARCHAR(1) := 'B';
	
	v_SLTID_TO 		SLOT.SLTID%TYPE;
	v_SLTSTIME_TO 	SLOT.SLTSTIME%TYPE;
	v_SCHLEN_TO 	SCHEDULE.SCHLEN%TYPE;
	v_SCHID_TO 		SCHEDULE.SCHID%TYPE;
	
	v_Count NUMBER;
	v_Counter NUMBER := 1;
	v_errmsg VARCHAR2(100);
	o_errcode NUMBER := -1;
BEGIN
	
	dbms_output.put_line('/*');
	dbms_output.put_line('Move normal booking from doccode: ' || i_DOCCODE_FM || ' to ' || i_DOCCODE_TO || ', time: ' || TO_CHAR(i_FROM_TIME, 'DD/MM/YYYY HH24:MI:SS') || ' to ' || TO_CHAR(i_TO_TIME, 'DD/MM/YYYY HH24:MI:SS'));
	dbms_output.put_line('*/');
	
    FOR r IN (
		SELECT s.DOCCODE, L.SLTSTIME, b.*
		FROM   BOOKING B
		 JOIN SCHEDULE S ON B.SCHID = S.SCHID
		 JOIN SLOT L ON B.SLTID = L.SLTID
		WHERE  B.BKGSDATE >= i_FROM_TIME
		AND    B.BKGSDATE <= i_TO_TIME
		AND    B.BKGSTS = SCH_NORMAL
		AND    S.DOCCODE = i_DOCCODE_FM
		ORDER BY BKGSDATE
    ) LOOP
			-- MATCH NEW SLOT
			SELECT COUNT(1) INTO V_COUNT
			FROM SLOT L JOIN SCHEDULE S ON S.SCHID = L.SCHID
			WHERE  
			S.DOCCODE = i_DOCCODE_TO
			--AND S.SCHSDATE = v_SLTSTIME_FM
			AND S.SCHSTS IN (SCH_NORMAL)
			AND L.SLTSTIME = r.SLTSTIME;
			IF V_COUNT = 0 THEN
				dbms_output.put_line('-- ' || v_Counter || ') BKGID=' || r.BKGID || ' CANNOT FIND ' || TO_CHAR(r.SLTSTIME, 'DD/MM/YYYY HH24:MI:SS'));
				
				dbms_output.put_line('  -- SELECT s.doccode, L.SLTSTIME, b.* FROM   BOOKING B JOIN SCHEDULE S ON B.SCHID = S.SCHID JOIN SLOT L ON B.SLTID = L.SLTID WHERE bkgid = ' || r.BKGID || ';');
				dbms_output.put_line('  -- select * from SCHEDULE where schid in (' || r.SCHID || ');');
				dbms_output.put_line('  -- select * from SLOT where schid in (' || r.SCHID || ') and SLTID in (' || r.SLTID || ');');
				dbms_output.put_line('');
			ELSE 
				SELECT L.SLTSTIME, S.SCHLEN, S.SCHID, L.SLTID
					INTO v_SLTSTIME_TO, v_SCHLEN_TO, v_SCHID_TO, v_SLTID_TO
				FROM SLOT L JOIN SCHEDULE S ON S.SCHID = L.SCHID
				WHERE  
				S.DOCCODE = i_DOCCODE_TO
				--AND S.SCHSDATE = v_SLTSTIME_FM
				AND S.SCHSTS IN (SCH_NORMAL)
				AND L.SLTSTIME = r.SLTSTIME
				;
				
				dbms_output.put_line('-- ' || v_Counter || ') BKGID=' || r.BKGID || ' MATCH SCHID=' || v_SCHID_TO || ' SLTID=' || v_SLTID_TO);
				
				dbms_output.put_line('  -- SELECT s.doccode, L.SLTSTIME, b.* FROM   BOOKING B JOIN SCHEDULE S ON B.SCHID = S.SCHID JOIN SLOT L ON B.SLTID = L.SLTID WHERE bkgid = ' || r.BKGID || ';');
				dbms_output.put_line('  -- select * from SCHEDULE where schid in (' || r.SCHID || ', ' || v_SCHID_TO || ');');
				dbms_output.put_line('  -- select * from SLOT where schid in (' || r.SCHID || ', ' || v_SCHID_TO || ') and SLTID in (' || r.SLTID || ', ' || v_SLTID_TO || ');');
				dbms_output.put_line('');
				
				dbms_output.put_line(' update BOOKING set schid = ' || v_SCHID_TO || ', sltid = ' || v_SLTID_TO || ' where bkgid = ' || r.BKGID || ';');
				dbms_output.put_line(' update SCHEDULE set schcnt = schcnt - 1 where schid = ' || r.SCHID || ';');
				dbms_output.put_line(' update SCHEDULE set schcnt = schcnt + 1 where schid = ' || v_SCHID_TO || ';');
				dbms_output.put_line(' update SLOT set SLTCNT = SLTCNT - 1 where schid = ' || r.SCHID || ' AND SLTID = ' || r.SLTID || ';');
				dbms_output.put_line(' update SLOT set SLTCNT = SLTCNT + 1 where schid = ' || v_SCHID_TO || ' AND SLTID = ' || v_SLTID_TO || ';');
				dbms_output.put_line('');
			END IF;
			
			v_Counter := v_Counter + 1;
    END LOOP;
	
	o_errcode := 0;
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_UTL_BOOKING_MOVE;
/
