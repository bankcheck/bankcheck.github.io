CREATE OR REPLACE FUNCTION "NHS_GET_TXNRMDER"(
	i_slpno In Varchar2
)
	RETURN types.CURSOR_TYPE
AS
	Outcur Types.Cursor_Type;
Begin
	OPEN OUTCUR FOR
		select HLKEY,HLSEQ, to_char(MAX_HLHDATE,'DD/MM/YYYY'),
			MAX_HLHUSR,MAX_HLHRMK
			from
				(select
				HLTYPE,HLKEY,HLSEQ,
				max(HLHDATE) keep (dense_rank last order by HLCDATE NULLS first) MAX_HLHDATE,
				max(HLHUSR) keep (dense_rank last order by HLCDATE NULLS first) MAX_HLHUSR,
				max(HLRMK) keep (dense_rank last order by HLCDATE NULLS first) MAX_HLHRMK
			from HLETRDTL
			group by HLTYPE,HLKEY,HLSEQ)
		Where HLKEY= i_slpno
		and HLTYPE= 'SLIPRMDER';
	RETURN OUTCUR;

END NHS_GET_TXNRMDER;
/
