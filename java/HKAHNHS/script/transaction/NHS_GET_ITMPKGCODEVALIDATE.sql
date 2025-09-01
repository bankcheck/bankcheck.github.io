CREATE OR REPLACE FUNCTION "NHS_GET_ITMPKGCODEVALIDATE" (
	i_TxMode    IN VARCHAR2,
	i_SlpNo     IN VARCHAR2,
	i_SlpType   IN VARCHAR2,
	i_TxDate    IN varchar2,
	i_ChrgType  IN VARCHAR2,
	i_ChrgCode  IN VARCHAR2,
	i_DocCode   IN VARCHAR2,
	i_AcmCode   IN VARCHAR2,
	i_Unit      IN NUMBER,
	i_Amount    IN NUMBER,
	i_SlpHDisc  IN NUMBER,
	i_SlpDDisc  IN NUMBER,
	i_SlpSDisc  IN NUMBER,
	i_UserID    IN VARCHAR2
)
	RETURN types.cursor_type
AS
	o_outcur types.cursor_type;
	o_errmsg VARCHAR2(1000);
begin
	o_outcur := NHS_UTL_ITMPKGCODEVALIDATE(
		i_TxMode,
		i_TxDate,
		i_SlpNo,
		i_SlpType,
		i_ChrgType,
		i_ChrgCode,
		i_DocCode,
		i_AcmCode,
		i_Unit,
		i_Amount,
		i_SlpHDisc,
		i_SlpDDisc,
		i_SlpSDisc,
		i_UserID,
		o_errmsg);

	RETURN o_outcur;
END NHS_GET_ITMPKGCODEVALIDATE;
/
