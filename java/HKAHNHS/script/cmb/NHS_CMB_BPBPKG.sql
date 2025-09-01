create or replace
FUNCTION "NHS_CMB_BPBPKG"
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		SELECT PKGCODE,'P='||PKGCODE||' '||substr(pkgname,INSTR(pkgname,'(',-1), length(pkgname))
		FROM   package
		where pkgcode in ('LAMIN','MICRO','TLIF','ACDF','CTDR','XLIF','PX881','PX882')
		ORDER BY PKGCODE;
	RETURN outcur;
END NHS_CMB_BPBPKG;
/


