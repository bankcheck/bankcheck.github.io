create or replace
trigger TRIG_CASHTX_STECODE_AMC2
BEFORE INSERT or UPDATE of STECODE 
on CASHTX FOR EACH ROW

BEGIN
	IF  :new.STECODE = 'AMC2' THEN 
		:new.STECODE := 'HKAH'; 
  	end if;
end;