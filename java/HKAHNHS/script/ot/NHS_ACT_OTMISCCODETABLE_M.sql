CREATE OR REPLACE FUNCTION "NHS_ACT_OTMISCCODETABLE_M" (
	v_Action  IN Varchar2,
	v_Stecode IN Varchar2,
	v_Table   IN TEMPLATE_OBJ_TAB,
	o_ERRMSG  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_ERRCODE NUMBER;
	v_Noofrec NUMBER;
	l_Otcord NUMBER;
	l_Otcnum_1 NUMBER;
	l_Otcsts NUMBER;
	l_OTCID NUMBER;
BEGIN
	o_ERRCODE := -1;
	o_ERRMSG  := 'OK';
	l_Otcsts := 0;

  	FOR I IN 1..v_Table.COUNT LOOP
		SELECT Count(1) INTO v_Noofrec FROM Ot_Code WHERE Otcid = v_Table(I).COLUMN08;
    		IF v_Table(I).COLUMN05 = 'Y' THEN
	      		l_Otcsts := -1;
	    	ELSE
	      		l_Otcsts := 0;
	    	END IF;

		l_Otcord := TO_NUMBER(v_Table(I).COLUMN03);
		l_Otcnum_1 := TO_NUMBER(v_Table(I).COLUMN06);
		l_OTCID := TO_NUMBER(v_Table(I).COLUMN08);

	    	IF v_Noofrec = 0 THEN
	    		l_OTCID := Seq_Ot_Code.Nextval;
	     		INSERT INTO OT_CODE (
			        OTCID,
			        Otctype,
			        Otcord,
			        Otcdesc,
			        Otcnum_1,
			        Otcchr_1,
			        Otcsts,
			        STECODE
			) VALUES (
			        l_OTCID,
			        v_Table(I).COLUMN02,
			        l_Otcord,
			        v_Table(I).COLUMN04,
			        l_Otcnum_1,
			        v_Table(I).COLUMN07,
			        l_Otcsts,
			        v_Stecode
			);
	      	ELSE
	      		UPDATE OT_CODE
	      		SET
	        		OTCTYPE  = v_Table(I).COLUMN02,
				OTCORD   = l_Otcord,
				Otcdesc  = v_Table(I).COLUMN04,
				OTCNUM_1 = l_Otcnum_1,
				OTCCHR_1 = v_Table(I).COLUMN07,
				OTCSTS   = l_Otcsts
	        	WHERE Otcid = l_OTCID;
	    	END IF;
  	END LOOP;

	o_ERRCODE := 0;
	RETURN o_ERRCODE;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	o_ERRMSG := 'Fail to insert/update record due to ' || SQLERRM || '.';

	ROLLBACK;

	RETURN o_ERRCODE;
END NHS_ACT_OTMISCCODETABLE_M;
/
