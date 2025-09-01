CREATE OR REPLACE FUNCTION "NHS_GET_DOCITMPCT" (
	V_DOCCODE       IN VARCHAR2,
	V_SLPTYPE       IN VARCHAR2,
	V_PCYID         IN VARCHAR2,
	V_DSCCODE       IN VARCHAR2,
	V_ITEMCODE      IN VARCHAR2,
	V_STNTDATE      IN DATE,
	V_STECODE       IN VARCHAR2
)
	RETURN types.CURSOR_TYPE
AS
	Outcur Types.Cursor_Type;

	V_SLPTYPE_2     VARCHAR2(1);
	V_PCYID_2       VARCHAR2(22);
	V_DSCCODE_2     VARCHAR2(10);
	V_ITEMCODE_2    ITEM.ITMCODE%TYPE;

	P_Slptype       VARCHAR2(1);
	P_Pcyid         NUMBER(22);
	P_dsccode       VARCHAR2(10);
	P_Itmcode       VARCHAR2(5);

	V_PCTVALUE      FLOAT(126);
	V_FIXVALUE      FLOAT(126);
Begin
	IF V_SLPTYPE IS NULL THEN
		V_SLPTYPE_2 := '~';
	ELSE
		V_SLPTYPE_2 := V_SLPTYPE;
	END IF;

	IF V_PCYID IS NULL THEN
		V_PCYID_2 := '~';
	ELSE
		V_PCYID_2 := V_PCYID;
	END IF;

	IF V_DSCCODE IS NULL THEN
		V_DSCCODE_2 := '~';
	ELSE
		V_DSCCODE_2 := V_DSCCODE;
	END IF;

	IF V_ITEMCODE IS NULL THEN
		V_ITEMCODE_2 := '~';
	ELSE
		V_ITEMCODE_2 := V_ITEMCODE;
	END IF;

	BEGIN
		Select
		    Dippct, DIPFIX
		INTO V_PCTVALUE, V_FIXVALUE
		From
		(
		   Select
		        Case When P.Slptype Is Null Then 
		            case when Ph.Slptype is not null then Ph.Slptype else '~' end else P.Slptype End Slptype,
		        Case When P.Pcyid Is Null Then
		            case when Ph.Pcyid is not null then to_char(Ph.Pcyid) else '~' end else to_char(P.Pcyid) End Pcyid,
		        Case When Nvl(P.Dsccode,I.Dsccode) Is Null Then
		            case when Nvl(Ph.Dsccode,I.Dsccode) is not null then Nvl(Ph.Dsccode,I.Dsccode) else '~' end else Nvl(P.Dsccode,I.Dsccode) End Dsccode,
		        Case When P.Itmcode Is Null Then
		            case when Ph.Itmcode is not null then Ph.Itmcode else '~' end else P.Itmcode End Itmcode,
		        Case When ph.dippct is not null then ph.dippct else P.Dippct end Dippct,
		        Case When ph.DIPFIX is not null then ph.DIPFIX else p.DIPFIX end DIPFIX
		   From (select * from Docitmpct where doccode = V_DOCCODE And Stecode = V_STECODE) P
		        full join 
		            (select * from Docitmpcthist where doccode = V_DOCCODE
		                and constartdate <= V_STNTDATE and conenddate >= V_STNTDATE
		                and Stecode = V_STECODE
		            ) ph
		            on p.doccode = ph.doccode
		            and p.Slptype = ph.Slptype
		            and p.Pcyid = ph.Pcyid
		            and p.Dsccode = ph.Dsccode
		            and p.Itmcode = ph.Itmcode
		        left join Item I 
		            on p.itmcode = i.itmcode
		            and P.Stecode = I.Stecode 
				Union
			select 
		        'I' Slptype, '~' Pcyid, '~' dsccode, '~' Itmcode, case when dh.docpct_i is not null then dh.docpct_i else d.docpct_i end Docpct_I, Null
		    from Doctor d left join (
		        select * from DOCPCTHIST where doccode = V_DOCCODE and constartdate <= V_STNTDATE and conenddate >= V_STNTDATE
		    ) dh on d.doccode = dh.doccode 
		    where d.doccode = V_DOCCODE
				Union
			select 
		        'O' Slptype, '~' Pcyid, '~' dsccode, '~' Itmcode, case when dh.docpct_o is not null then dh.docpct_o else d.docpct_o end docpct_o, Null
		    from Doctor d left join (
		        select * from DOCPCTHIST where doccode = V_DOCCODE and constartdate <= V_STNTDATE and conenddate >= V_STNTDATE
		    ) dh on d.doccode = dh.doccode 
		    where d.doccode = V_DOCCODE			
				Union
			select 
		        'D' Slptype, '~' Pcyid, '~' dsccode, '~' Itmcode, case when dh.docpct_d is not null then dh.docpct_d else d.docpct_d end docpct_d, Null
		    from Doctor d left join (
		        select * from DOCPCTHIST where doccode = V_DOCCODE and constartdate <= V_STNTDATE and conenddate >= V_STNTDATE
		    ) dh on d.doccode = dh.doccode 
		    where d.doccode = V_DOCCODE
		)
		WHERE
		    (
		        (Slptype = V_SLPTYPE_2 And Pcyid = V_PCYID_2 And Dsccode = V_DSCCODE_2 And Itmcode = V_ITEMCODE_2) or
		        (Slptype = V_SLPTYPE_2 And Pcyid = V_PCYID_2 And Dsccode = V_DSCCODE_2 And Itmcode = '~') or
		        (Slptype = V_SLPTYPE_2 And Pcyid = V_PCYID_2 And Dsccode = '~' And Itmcode = '~') or
		        (Slptype = V_SLPTYPE_2 And Pcyid = '~' And Dsccode = '~' And Itmcode = '~')
		    )
			and rownum = 1
		;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
		begin
			V_PCTVALUE := NULL;
			V_FIXVALUE := NULL;
		end;
	END;

	Open Outcur for
		select V_PCTVALUE, V_FIXVALUE from dual;
	Return Outcur;
END NHS_GET_DOCITMPCT;
/
