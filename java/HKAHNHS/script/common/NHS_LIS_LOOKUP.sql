CREATE OR REPLACE FUNCTION "NHS_LIS_LOOKUP" (
 	v_table      IN VARCHAR2,
 	v_result     IN VARCHAR2,
 	v_criteria   IN VARCHAR2
 )
	RETURN Types.cursor_type
AS
	outcur Types.cursor_type;
	sqlbuf VARCHAR2(500);
	v_tableName VARCHAR2(100);
	appear INTEGER := 1;
	startIndex INTEGER := 1;
	commaIndex INTEGER;
	spaceIndex INTEGER;
BEGIN
	sqlbuf := 'select ' || v_result || ' from ';
	commaIndex := INSTR(v_table, ',', 1, 1);
	IF commaIndex > 0 THEN
		-- handle multiple table
		WHILE commaIndex > 0
		LOOP
			v_tableName := TRIM(SUBSTR(v_table, startIndex, commaIndex - startIndex));

			-- handle db abb name
			spaceIndex := INSTR(v_tableName, ' ', 1, 1);
			IF spaceIndex > 0 THEN
				sqlbuf := sqlbuf || SUBSTR(v_tableName, 1, spaceIndex - 1) || '' || SUBSTR(v_tableName, spaceIndex);
			ELSE
				sqlbuf := sqlbuf || TRIM(v_tableName) || '';
			END IF;
			sqlbuf := sqlbuf || ',';
			startIndex := commaIndex + 1;

			commaIndex := INSTR(v_table, ',', startIndex, 1);
		END LOOP;

		-- last part
		v_tableName := TRIM(SUBSTR(v_table, startIndex));
		-- handle db abb name
		spaceIndex := INSTR(v_tableName, ' ', 1, 1);
		IF spaceIndex > 0 THEN
			sqlbuf := sqlbuf || SUBSTR(v_tableName, 1, spaceIndex - 1) || '' || SUBSTR(v_tableName, spaceIndex);
		ELSE
			sqlbuf := sqlbuf || TRIM(v_tableName) || '';
		END IF;
	ELSE
		IF INSTR(v_table, '@', 1, 1) = 0 THEN
			sqlbuf := sqlbuf || v_table || '';
		END IF;
	END IF;
	sqlbuf := sqlbuf || ' where ' || v_criteria;

	OPEN outcur for sqlbuf;
	RETURN outcur;

end NHS_LIS_LOOKUP;
/
