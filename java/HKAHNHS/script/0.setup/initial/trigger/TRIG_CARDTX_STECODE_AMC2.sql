create or replace
trigger TRIG_CARDTX_STECODE_AMC2
BEFORE INSERT or UPDATE of STECODE 
on CARDTX FOR EACH ROW

BEGIN
	IF  :new.STECODE = 'AMC2' THEN 
		:new.STECODE := 'HKAH'; 
  	end if;
end;