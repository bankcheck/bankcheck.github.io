create or replace procedure ris_auto_match_loop
is
	l_cnt_processed number(5) ;
	l_slpno ris_auto_match_log.slpno%type ;
	l_stnid ris_auto_match_log.stnid%type ;
	l_ris_rtn_code varchar2(10) ;
	l_ris_rtn_msg varchar2(200) ;
begin
	for r in ( select * from ris_auto_match_log where status = 'LOG' ) loop
		select count(1) into l_cnt_processed from ris_auto_match_log where accessno = r.accessno and status = 'LOG' AND examcode not like 'AMC2%';
		if l_cnt_processed = 1 then
			ris_auto_match_body(
				r.accessno, -- Accession Number
--				r.log_date,
				r.logno,
				r.patno, -- Patient ID
--				r.orderdate,     -- Order Create Date
				-- version 20120205 : update sliptx.stntdate by logdate ( e.g. exam date ) instead of order date
				to_date(to_char(r.log_date,'YYYYMMDD'),'YYYYMMDD'),     -- Exam Date
				r.doccode, -- Primary Physican Code
				r.read_doc,
				r.examcode, -- Exam Code, i.e. Package Code in Hats
				r.examname, -- Exam Description
				r.billcode1,
				r.billcode2,
				r.billcode3,
				r.billcode4,
				-- version : 20121024
				r.billcode5,
				r.billcode6,
				-- version : 20121024
				r.arccode, -- AR Code (Discount Code) , if p_arccode have value then p_discount should not have value
				r.discount,
				-- version : 20130123
				r.pattype
			) ;
		else
			-- forward to AMC2
			INSERT INTO RIS_AUTO_MATCH_LOG@AMC2HAT (
				LOGNO, ACCESSNO, PATNO, DOCCODE, ORDERDATE, EXAMCODE, EXAMNAME, BILLCODE1, BILLCODE2, BILLCODE3, BILLCODE4, BILLCODE5, BILLCODE6, ARCCODE, DISCOUNT, LOG_DATE, ERROR_CODE, ERROR_MESSAGE, ACTION_CODE, ACTION_MESSAGE, STATUS, SLPNO, STNID, PATTYPE, READ_DOC
			)
			SELECT LOGNO, ACCESSNO, PATNO, DOCCODE, ORDERDATE, EXAMCODE, EXAMNAME, BILLCODE1, BILLCODE2, BILLCODE3, BILLCODE4, BILLCODE5, BILLCODE6, ARCCODE, DISCOUNT, LOG_DATE, ERROR_CODE, ERROR_MESSAGE, ACTION_CODE, ACTION_MESSAGE, STATUS, SLPNO, STNID, PATTYPE, READ_DOC
			FROM   RIS_AUTO_MATCH_LOG
			WHERE  accessno = r.accessno
			AND    logno = r.logno
			AND    examcode like 'AMC2%';

			update ris_auto_match_log set status = 'BYPASS' where accessno = r.accessno and logno = r.logno and status = r.status ;
		end if ;

		begin
			-- use rownum = 1 just for safty, because in fact just one record will be found for MATCHED
			select slpno, stnid into l_slpno, l_stnid from
			( select slpno, stnid from ris_auto_match_log where accessno = r.accessno and status = 'MATCHED' order by logno desc )
			where rownum = 1 ;
		exception when others then
			null ;
		end ;
		-- 20121213 : done by ris_auto_match_body
		-- spectra.p_his_update_stnid@ris( r.accessno, l_slpno, l_stnid, l_ris_rtn_code, l_ris_rtn_msg ) ;
	end loop ;
end ;
/
