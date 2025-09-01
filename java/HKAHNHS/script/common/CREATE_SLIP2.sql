CREATE OR REPLACE PROCEDURE CREATE_SLIP2 (
	Doctor_Code in slip.doccode%type,
	Patient_No  in slip.patno%type,
	Surname     in slip.slpfname%type,
	Given_Name  in slip.slpgname%type,

	Slip_No     out varchar2,
	Message_Out out varchar2
)
as
	rs_slip     slip%rowtype;
	e_comman    exception;
	v_patno     slip.patno%type;
	v_return    boolean;
begin
	Message_Out := '';

	if Doctor_Code is null then
		Message_Out := 'Missing doctor code.';
		raise e_comman;
	end if;

	if Patient_No is null and (Surname is null or Given_Name is null) then
		Message_Out := 'Missing patient no or patient name.';
		raise e_comman;
	end if;

	if Patient_No is not null then
		begin
			select patno into v_patno from patient where patno = Patient_No;
		exception
		when NO_DATA_FOUND then
			Message_Out := 'Invalid patient no.';
			raise e_comman;
		end;
	end if;

	v_return := IS_VALID_DOCCODE (Doctor_Code);

	if not (v_return) then
		Message_Out := 'Invalid doctor code.';
		raise e_comman;
	end if;

	dbms_output.put_line ('Opd:' || GET_OPD_DEPT_CODE);

	rs_slip.slpno    := GENERATE_SLIP_NO();
	rs_slip.doccode  := Doctor_Code;
	rs_slip.dptcode  := GET_OPD_DEPT_CODE();
	rs_slip.slptype  := 'O';
	rs_slip.slpsts   := 'A';
	rs_slip.slpseq   := 1;
	rs_slip.slppseq  := 1;
	rs_slip.slphdisc := 0;
	rs_slip.slpddisc := 0;
	rs_slip.slpsdisc := 0;
	rs_slip.slppamt  := 0;
	rs_slip.slpcamt  := 0;
	rs_slip.slpdamt  := 0;
	rs_slip.stecode  := GET_CURRENT_STECODE();
	rs_slip.usrid    := GET_CURRENT_USRID();

	insert into slip
	(SLPNO,PATNO,SLPFNAME,SLPGNAME,SLPTYPE,DOCCODE,DPTCODE,SLPSTS,
	SLPHDISC,SLPDDISC,SLPSDISC,SLPSEQ,SLPPSEQ,SLPPAMT,
	SLPCAMT,SLPDAMT,STECODE,USRID) values
	(rs_slip.slpno, Patient_No, Surname, Given_Name, rs_slip.slptype, Doctor_Code, rs_slip.dptcode, rs_slip.slpsts,
	rs_slip.slphdisc, rs_slip.slpddisc, rs_slip.slpsdisc, rs_slip.slpseq, rs_slip.slppseq, rs_slip.slppamt,
	rs_slip.slpcamt, rs_slip.slpdamt, rs_slip.stecode, rs_slip.usrid);

	Slip_No := rs_slip.slpno;

	insert into slip_extra(
		SLPNO,
		SLPDATE
	) values (
		Slip_No,
		SYSDATE
	);
exception
	when e_comman then
	null;
end;
/
