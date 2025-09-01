create or replace
trigger TRIG_SLIP_STECODE_AMC2
BEFORE INSERT or UPDATE of STECODE 
on SLIP FOR EACH ROW

BEGIN
	IF  :new.STECODE = 'AMC2' THEN 
		:new.STECODE := 'HKAH'; 
  	end if;
end;