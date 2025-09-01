CREATE OR REPLACE PROCEDURE NHS_UTL_SlpPayAllAutoCal (
	pay_tab IN out SPA_pay_tab,
	chg_tab IN out SPA_chg_tab,
	pay_chg IN OUT SPA_pay_chg_row
)
AS
	l_chgtot number(22,4) := 0;
	l_paytot number(22,4) := 0;

	l_diff NUMBER(12,4) := 0;
	l_order NUMBER(5);
	l_sign NUMBER(5);
	TYPE pay_dif_typ is table of NUMBER(12,4);
	TYPE chg_dif_typ is table of NUMBER(12,4);
	pay_dif pay_dif_typ := pay_dif_typ();
	chg_dif chg_dif_typ := chg_dif_typ();

	l_cnt number(8);
	l_temp float(50);
BEGIN
	pay_dif.EXTEND( pay_tab.LAST );
	chg_dif.EXTEND( chg_tab.LAST );

	FOR p IN 1..pay_tab.LAST
	LOOP
		-- l_paytot := l_paytot + ABS( pay_tab(p).stnnamt );
		l_paytot := l_paytot + pay_tab(p).pay_amt;
	END loop;

	FOR c IN 1..chg_tab.LAST LOOP
		l_chgtot := l_chgtot + chg_tab(c).stnnamt;
	END loop;

	IF l_chgtot > l_paytot THEN
		l_diff := 0;
		FOR c IN 1..chg_tab.LAST
		LOOP
			IF chg_tab(c).stnnamt < 0 THEN
				chg_dif(c) := chg_tab(c).stnnamt;
			ELSE
				chg_dif(c) := ROUND( chg_tab(c).stnnamt * l_paytot / l_chgtot );
			END IF;
			l_diff := l_diff + chg_tab(c).stnnamt;
		END LOOP;

		l_diff := l_paytot - l_diff;
		IF l_diff <> 0 THEN
			FOR c IN reverse 1..chg_tab.LAST
			LOOP
				l_diff := l_diff + chg_dif(c) - chg_tab(c).stnnamt;
				IF sign(l_diff) <> sign(chg_tab(c).stnnamt) THEN			-- Sign is dIFferent
					IF ABS(chg_tab(c).stnnamt) >= ABS(l_diff) THEN
						chg_dif(c) := chg_tab(c).stnnamt + l_diff;			-- Absorb all => iDIFf = 0
						l_diff := 0;
					ELSE
						l_diff := l_diff + chg_tab(c).stnnamt;				-- Absorb partial => iDIFf != 0
						chg_tab(c).stnnamt := 0;
					END IF;
				END IF;

				IF l_diff = 0 THEN
					EXIT;
				END IF;
			END LOOP;
		END IF;

		FOR c IN 1..chg_tab.LAST
		LOOP
			chg_tab(c).stnnamt := chg_dif(c);
		END LOOP;
	END IF;

	FOR p IN 1..pay_tab.LAST
	LOOP
		FOR c IN 1..chg_tab.LAST
		LOOP
			IF l_paytot = 0 THEN
				pay_chg(p)(c) := 0;
			ELSE
				l_temp := chg_tab(c).stnnamt * pay_tab(p).pay_amt / l_paytot;
				IF ROUND( l_temp ) - l_temp > 0 THEN
					pay_chg(p)(c) := ROUND( l_temp ) - 1;
				ELSE
					pay_chg(p)(c) := ROUND( l_temp );
				END IF;

				-- pay_chg(p)(c) := ROUND( chg_tab(c).stnnamt * pay_seq(p).pay_amt / l_paytot );
			END IF;
		END LOOP;
	END LOOP;

	FOR p IN 1..pay_tab.LAST
	LOOP
		pay_dif(p) := pay_tab(p).pay_amt;
		FOR c IN 1..chg_tab.LAST
		LOOP
			pay_dif(p) := pay_dif(p) - pay_chg(p)(c);
		END LOOP;
	END LOOP;

	FOR c IN 1..chg_tab.LAST
	LOOP
		chg_dif(c) := chg_tab(c).stnnamt;
		-- FOR p IN 1..pay_seq.LAST
		FOR p IN 1..pay_tab.LAST
		LOOP
			chg_dif(c) := chg_dif(c) - pay_chg(p)(c);
		END LOOP;
	END LOOP;

	dbms_output.put_line( 'Check Point 1' );

	-- stop at line source 5473
	-- need to check function ROUNDDown at line 139
	l_order := 1;
	FOR r IN ( SELECT key FROM table( pay_tab ) ORDER BY ABS(pay_amt) ) LOOP
		FOR i IN 1..pay_tab.LAST LOOP
			IF pay_tab(i).key = r.key THEN
				pay_tab(i).pay_order := l_order;
				EXIT;
			END IF;
		END LOOP;
		l_order := l_order + 1;
	END LOOP;

	FOR c IN reverse 1..chg_tab.LAST
	LOOP
		l_cnt := 1;
		while chg_dif(c) != 0
		LOOP
			IF l_cnt > 40000 THEN
				EXIT;
			ELSE
				-- dbms_output.put_line( 'cd' || c || ':'	|| chg_dif(c) );
				l_cnt := l_cnt + 1;
			END IF;
			FOR p IN reverse 1..pay_tab.LAST
			LOOP
				IF chg_dif(c) = 0 THEN
					EXIT;
				END IF;

				IF sign( chg_dif(c) ) = sign( pay_dif( pay_tab(p).pay_order ) ) THEN
					l_sign := sign( chg_dif( c ) );
					chg_dif(c) := chg_dif(c) - l_sign;
					pay_dif( pay_tab(p).pay_order ) := pay_dif( pay_tab(p).pay_order ) - l_sign;
					pay_chg(pay_tab(p).pay_order)(c) := pay_chg(pay_tab(p).pay_order)(c) + l_sign;
				END IF;
			END LOOP;
		END LOOP;
	END LOOP;
END;
/
