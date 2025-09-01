create or replace
procedure ORD_ADD_REMOVE_BILL_CHARGE
-- ******************************COPYRIGHT NOTICE*******************************
-- All rights reserved.  This material is confidential and proprietary to Excel
-- Technology International (Hong Kong) Limited and no part of this material
-- should be reproduced, published in any form by any means, electronic or
-- mechanical including photocopy or any information storage or retrieval system
-- nor should the material be disclosed to third parties without the express
-- written authorization of Excel Technology International (Hong Kong) Limited.

-- ****************************PROGRAM DESCRIPTION*******************************
-- Program Name   : ORD_ADD_REMOVE_BILL_CHARGE
-- Nature         : Application
-- Description    : Interface Program to Add and Remove Bill Charges
-- Creation Date  : 2008/06/23
-- Creator        : Alex KH Lee
-- ****************************MODIFICATION HISTORY******************************
-- Modify Date    : 2008/12/24
-- Modifier       : Alex KH Lee
-- CR / SIR No.   : SIR_HAT_2008121801
-- Description    : Handle All Patient Type
-- ******************************************************************************
-- Modify Date    : 2009/08/03, By CK Hung
-- Description    : Enabled DocCode Checking
-- ******************************************************************************
-- Modify Date    : 2017/01/10, By Johnny Ho
-- Description    : Use Itemchg with effective date
-- ******************************************************************************
    (
    v_billtype       varchar2, v_stntdate     date,     v_slpno      varchar2, v_acmcode varchar2,
    v_bill_1  in out number,   v_doccode_1    varchar2, v_itmcode_1  varchar2, v_qty_1   integer,  v_stat_1  varchar2, v_ref_no_1  varchar2, v_stnseq_1  in out varchar2,
    v_bill_2  in out number,   v_doccode_2    varchar2, v_itmcode_2  varchar2, v_qty_2   integer,  v_stat_2  varchar2, v_ref_no_2  varchar2, v_stnseq_2  in out varchar2,
    v_bill_3  in out number,   v_doccode_3    varchar2, v_itmcode_3  varchar2, v_qty_3   integer,  v_stat_3  varchar2, v_ref_no_3  varchar2, v_stnseq_3  in out varchar2,
    v_bill_4  in out number,   v_doccode_4    varchar2, v_itmcode_4  varchar2, v_qty_4   integer,  v_stat_4  varchar2, v_ref_no_4  varchar2, v_stnseq_4  in out varchar2,
    v_bill_5  in out number,   v_doccode_5    varchar2, v_itmcode_5  varchar2, v_qty_5   integer,  v_stat_5  varchar2, v_ref_no_5  varchar2, v_stnseq_5  in out varchar2,
    v_bill_6  in out number,   v_doccode_6    varchar2, v_itmcode_6  varchar2, v_qty_6   integer,  v_stat_6  varchar2, v_ref_no_6  varchar2, v_stnseq_6  in out varchar2,
    v_bill_7  in out number,   v_doccode_7    varchar2, v_itmcode_7  varchar2, v_qty_7   integer,  v_stat_7  varchar2, v_ref_no_7  varchar2, v_stnseq_7  in out varchar2,
    v_bill_8  in out number,   v_doccode_8    varchar2, v_itmcode_8  varchar2, v_qty_8   integer,  v_stat_8  varchar2, v_ref_no_8  varchar2, v_stnseq_8  in out varchar2,
    v_bill_9  in out number,   v_doccode_9    varchar2, v_itmcode_9  varchar2, v_qty_9   integer,  v_stat_9  varchar2, v_ref_no_9  varchar2, v_stnseq_9  in out varchar2,
    v_bill_10 in out number,   v_doccode_10   varchar2, v_itmcode_10 varchar2, v_qty_10  integer,  v_stat_10 varchar2, v_ref_no_10 varchar2, v_stnseq_10 in out varchar2,
    v_bill_11 in out number,   v_doccode_11   varchar2, v_itmcode_11 varchar2, v_qty_11  integer,  v_stat_11 varchar2, v_ref_no_11 varchar2, v_stnseq_11 in out varchar2,
    v_bill_12 in out number,   v_doccode_12   varchar2, v_itmcode_12 varchar2, v_qty_12  integer,  v_stat_12 varchar2, v_ref_no_12 varchar2, v_stnseq_12 in out varchar2,
    v_bill_13 in out number,   v_doccode_13   varchar2, v_itmcode_13 varchar2, v_qty_13  integer,  v_stat_13 varchar2, v_ref_no_13 varchar2, v_stnseq_13 in out varchar2,
    v_bill_14 in out number,   v_doccode_14   varchar2, v_itmcode_14 varchar2, v_qty_14  integer,  v_stat_14 varchar2, v_ref_no_14 varchar2, v_stnseq_14 in out varchar2,
    v_bill_15 in out number,   v_doccode_15   varchar2, v_itmcode_15 varchar2, v_qty_15  integer,  v_stat_15 varchar2, v_ref_no_15 varchar2, v_stnseq_15 in out varchar2,
    v_status  out    number,   v_sts_desc out varchar2
    ) is

    v_isvalid            boolean;
    v_inpddate           inpat.inpddate%type;
    v_i                  number(3);
    v_cpsid              conpceset.cpsid%type;
    v_stnid              sliptx.stnid%type;
    v_stnseq             slip.slpseq%type;
    v_j                  number(5);
    v_flag               number(5);

-- Comment: Slip Record Locking will be performed by previous level program.
--    v_is_slip_locked     boolean;

-- Comment: Define Type:v_stnseq_type
    TYPE v_stnseq_type is VARRAY(15) of varchar2(255);
    v_stnseq_list        v_stnseq_type := v_stnseq_type('', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

-- Comment: Define Type:v_bill_type
    TYPE v_bill_type is VARRAY(15) of NUMBER(5);
    v_bill               v_bill_type := v_bill_type(v_bill_1, v_bill_2, v_bill_3, v_bill_4, v_bill_5, v_bill_6, v_bill_7, v_bill_8, v_bill_9, v_bill_10, v_bill_11, v_bill_12, v_bill_13, v_bill_14, v_bill_15);
    v_bqty               v_bill_type := v_bill_type(v_qty_1,  v_qty_2,  v_qty_3,  v_qty_4,  v_qty_5,  v_qty_6,  v_qty_7,  v_qty_8,  v_qty_9,  v_qty_10,  v_qty_11,  v_qty_12,  v_qty_13,  v_qty_14,  v_qty_15);

-- Comment: Define Type:Entry
    type entry is table of spt_itemchg%rowtype index by binary_integer;
    entrylist            entry;

    rs_slip              slip%rowtype;

-- Comment: Define Cursor:Package_Cursor
    cursor package_cursor (v_slptype varchar2, v_pkgcode varchar2) is
        select distinct ic.itmcode
          from itemchg ic, item i
         where ic.pkgcode = v_pkgcode
           and ic.itctype = v_slptype
           and ic.cpsid is null
           and ic.itmcode = i.itmcode
         order by 1;

    v_pkgitmcode         item.itmcode%type;
    v_pkgrlvl            package.pkgrlvl%type;
    rs_sliptx            sliptx%rowtype;

-- Comment: Define Cursor:SlipTx_Cursor
    cursor sliptx_cursor (v_pkgcode varchar2) is
        select stnseq
          from sliptx
         where slpno = v_slpno
           and pkgcode = v_pkgcode
           and stnsts = 'N'
           and usrid = GET_CURRENT_USRID()
         order by 1;

-- Comment: Define Exception Handling
    e_invalid_billno      exception;
    e_addentry_error      exception;
    e_invalid_billtype    exception;
    e_invalid_doccode     exception;
    e_invalid_itmpkgcode  exception;
    e_invalid_stat        exception;
    e_slip_lock_by_other  exception;
    e_is_not_current_ip   exception;
    e_is_not_active_slip  exception;
    e_invalid_bill_line   exception;
    e_invalid_usrid       exception;
    e_reverse_entry       exception;
    v_error_code          number;
    v_error_message       varchar2(255);

begin
    v_status := 2;
    dbms_output.put_line ('[ Begin  ]');
    v_error_message := '';

-- Comment: Slip Record Locking will be performed by previous level program.
--    v_is_slip_locked := false;

-- Comment: Validate the First set of Bill Info
    if v_bill_1 is null then
        v_status := 2;
  	    v_error_message := 'The first bill no is blank';
	      raise e_invalid_billno;
    end if;
    if v_bill(1) is null then
        v_status := 2;
        v_error_message := 'The first bill is blank';
        raise e_invalid_billno;
    end if;
    v_j :=0;
    v_flag := 0;
    for v_j in 1..15 loop
        if v_bill(v_j) is not null then
            v_flag := v_flag +1;
        end if;
    end loop;
    v_j:=0;
    if v_flag <15 then
        for v_j in v_flag+1 .. 15 loop
            if v_bill(v_j) is not null then
                v_status := 2;
                v_error_message := 'At least one bill no is invalid blank';
                raise e_invalid_billno;
            end if;
        end loop;
    end if;

-- Comment: Validate Bill Type
    if not (v_billtype = 'A' or v_billtype = 'C') then
        v_error_message := 'Invalid Bill Type:' || v_billtype;
        raise e_invalid_billtype;
    end if;

-- Comment: Validate the Patient Type is InPat or Not
-- Start SIR_HAT_2008121801, Alex KH Lee, 2008/12/24
--    begin
--        select inpddate into v_inpddate from reg r, inpat i where r.inpid = i.inpid and r.slpno = v_slpno;
--        if not v_inpddate is null then
--            v_error_message := 'Patient is not current In-patient.';
--            raise e_is_not_current_ip;
--        end if;
--    exception
--        when NO_DATA_FOUND then
--            v_error_message := 'Patient is not In-patient.';
--            raise e_is_not_current_ip;
--    end;
-- End SIR_HAT_2008121801, Alex KH Lee, 2008/12/24

-- Comment: Retrieve Slip Info
    select * into rs_slip from slip where slpno = v_slpno;
    if rs_slip.SLPSTS <> 'A' then
        v_error_message := 'Slip :' || v_slpno || ' is not active slip.';
        raise e_is_not_active_slip;
    end if;

-- Comment: Retrieve CPS
    begin
        select cpsid into v_cpsid from slip s, arcode a where s.arccode = a.arccode and s.slpno = v_slpno;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line ('SLIP NO CPS');
        when others then
            v_error_message := SQLERRM;
    end;

-- Comment: Assign EntryList
    entrylist(1)  := CREATE_ITM_CHG (v_bill_1,  v_doccode_1,  v_itmcode_1,  v_stat_1,  v_ref_no_1,  0, 'N');
    entrylist(2)  := CREATE_ITM_CHG (v_bill_2,  v_doccode_2,  v_itmcode_2,  v_stat_2,  v_ref_no_2,  0, 'N');
    entrylist(3)  := CREATE_ITM_CHG (v_bill_3,  v_doccode_3,  v_itmcode_3,  v_stat_3,  v_ref_no_3,  0, 'N');
    entrylist(4)  := CREATE_ITM_CHG (v_bill_4,  v_doccode_4,  v_itmcode_4,  v_stat_4,  v_ref_no_4,  0, 'N');
    entrylist(5)  := CREATE_ITM_CHG (v_bill_5,  v_doccode_5,  v_itmcode_5,  v_stat_5,  v_ref_no_5,  0, 'N');
    entrylist(6)  := CREATE_ITM_CHG (v_bill_6,  v_doccode_6,  v_itmcode_6,  v_stat_6,  v_ref_no_6,  0, 'N');
    entrylist(7)  := CREATE_ITM_CHG (v_bill_7,  v_doccode_7,  v_itmcode_7,  v_stat_7,  v_ref_no_7,  0, 'N');
    entrylist(8)  := CREATE_ITM_CHG (v_bill_8,  v_doccode_8,  v_itmcode_8,  v_stat_8,  v_ref_no_8,  0, 'N');
    entrylist(9)  := CREATE_ITM_CHG (v_bill_9,  v_doccode_9,  v_itmcode_9,  v_stat_9,  v_ref_no_9,  0, 'N');
    entrylist(10) := CREATE_ITM_CHG (v_bill_10, v_doccode_10, v_itmcode_10, v_stat_10, v_ref_no_10, 0, 'N');
    entrylist(11) := CREATE_ITM_CHG (v_bill_11, v_doccode_11, v_itmcode_11, v_stat_11, v_ref_no_11, 0, 'N');
    entrylist(12) := CREATE_ITM_CHG (v_bill_12, v_doccode_12, v_itmcode_12, v_stat_12, v_ref_no_12, 0, 'N');
    entrylist(13) := CREATE_ITM_CHG (v_bill_13, v_doccode_13, v_itmcode_13, v_stat_13, v_ref_no_13, 0, 'N');
    entrylist(14) := CREATE_ITM_CHG (v_bill_14, v_doccode_14, v_itmcode_14, v_stat_14, v_ref_no_14, 0, 'N');
    entrylist(15) := CREATE_ITM_CHG (v_bill_15, v_doccode_15, v_itmcode_15, v_stat_15, v_ref_no_15, 0, 'N');
    for v_i in 1..entrylist.count loop
        if entrylist(v_i).s_bn is not null then
            if v_billtype = 'A' then
-- Comment: Validate State
                if not (entrylist(v_i).s_st = 'Y' or entrylist(v_i).s_st = 'N') then
                    v_error_message := 'Invalid Stat Indicator:' || entrylist(v_i).s_st;
                    raise e_invalid_stat;
                end if;
-- uncommented by ck on [20090803]
-- Comment: Doctor Code will be checked in function CIS_ADD_ENTRY. by excel.
                v_isvalid := IS_VALID_DOCCODE (entrylist(v_i).s_dc);
                if not v_isvalid then
                    v_error_message := 'Invalid Doctor Code:' || entrylist(v_i).s_dc;
                    raise e_invalid_doccode;
                end if;

-- Comment: Validate Item Code
                v_isvalid := IS_VALID_ITMCODE (rs_slip.SLPTYPE, entrylist(v_i).s_ic, null, '');
                if not v_isvalid then
                    v_isvalid := IS_VALID_PKGCODE(rs_slip.SLPTYPE, entrylist(v_i).s_ic,'');
                    if v_isvalid then
                        entrylist(v_i).s_ip := 'Y';
                    else
                        v_status := 2;
                        v_error_message := 'Invalid Item or Package Code:' || entrylist(v_i).s_ic;
                        raise e_invalid_itmpkgcode;
                    end if;
                end if;
            end if;

            if v_billtype = 'C' then
                begin
                    select * into rs_sliptx from sliptx where slpno = v_slpno and stnseq = entrylist(v_i).s_bn;
                exception
                    when NO_DATA_FOUND then
                        v_error_message := 'Bill Line No' || v_i || ':' || entrylist(v_i).s_bn || ' does not exists.';
                        v_status := 2;
                        raise e_invalid_bill_line;
                end;

-- Comment: Validate UsrID
                if not rs_sliptx.USRID = GET_CURRENT_USRID() then
                    v_error_message := 'Entry is not created by user:' || GET_CURRENT_USRID();
                    v_status := 2;
                    raise e_invalid_usrid;
                end if;

-- Comment: Validate Item Code
                v_isvalid := IS_VALID_ITMCODE (rs_slip.SLPTYPE, entrylist(v_i).s_ic, null, '');
                if v_isvalid then
                    v_error_message := 'Bill Line No' || v_i || ':' || entrylist(v_i).s_bn || ' is not a lab item.';
                    v_status := 2;
                    raise e_invalid_bill_line;
                end if;
                if rs_sliptx.PKGCODE is null then
                    entrylist(v_i).s_ic := rs_sliptx.ITMCODE;
                else
                    entrylist(v_i).s_ic := rs_sliptx.PKGCODE;
                    entrylist(v_i).s_ip := 'Y';
                end if;
            end if;
        end if;
    end loop;

-- Comment: Slip Record Locking will be performed by previous level program.
--    v_isvalid := RECORDLOCK ('Slip',v_slpno, v_error_message);
--    if not v_isvalid then
--        v_status := 2;
--        raise e_slip_lock_by_other;
--    end if;
--    commit;
--    v_is_slip_locked := true;

-- Comment: Begin Add Charge
    if v_billtype = 'A' then
        for v_i in 1..entrylist.count loop
            if entrylist(v_i).s_bn is not null then
                dbms_output.put_line ('Add Entry:' || v_i);
                if entrylist(v_i).s_ip = 'Y' then
                    dbms_output.put_line ('  Add Package:' || entrylist(v_i).s_ic);
                    select pkgrlvl into v_pkgrlvl from package where pkgcode = entrylist(v_i).s_ic;
                    open package_cursor (rs_slip.SLPTYPE, entrylist(v_i).s_ic);
                    loop
                        fetch package_cursor into v_pkgitmcode;
                            exit when package_cursor%NOTFOUND;
                        dbms_output.put_line ('      Item:' || v_pkgitmcode);
                        v_isvalid := CIS_ADD_ENTRY (rs_slip, entrylist(v_i).s_ic, v_pkgitmcode, entrylist(v_i).s_st, v_pkgrlvl, entrylist(v_i).s_dc,
                                                    v_acmcode, v_stntdate, 0, v_bqty(v_i), 'N', entrylist(v_i).s_rn, v_cpsid,
                                                    v_stnid, v_stnseq, v_error_message);
                        if not v_isvalid then
                            v_status := 2;
                            v_error_message := v_error_message;
                            raise e_addentry_error;
                        end if;
                        if entrylist(v_i).s_sn = 0 then
                            entrylist(v_i).s_sn := v_stnseq;
                        end if;
                        if length(v_stnseq_list(v_i)) > 0 then
                            v_stnseq_list(v_i) := v_stnseq_list(v_i) || ',';
                        end if;
                        v_stnseq_list(v_i) := v_stnseq_list(v_i) || v_stnseq;
                    end loop;
                    close package_cursor;
                else
                    dbms_output.put_line ('  Add Item:' || entrylist(v_i).s_ic);
                    v_isvalid := CIS_ADD_ENTRY (rs_slip,null, entrylist(v_i).s_ic, entrylist(v_i).s_st, null, entrylist(v_i).s_dc,
                                                v_acmcode, v_stntdate, 0, v_bqty(v_i), 'N', entrylist(v_i).s_rn, v_cpsid,
                                                v_stnid, v_stnseq, v_error_message);
                    if not v_isvalid then
                        v_status := 2;
                        v_error_message := 'add entry error';
                        raise e_addentry_error;
                    end if;
                    entrylist(v_i).s_sn := v_stnseq;
                    if length(v_stnseq_list(v_i)) > 0 then
                        v_stnseq_list(v_i) := v_stnseq_list(v_i) || ',';
                    end if;
                    v_stnseq_list(v_i) := v_stnseq_list(v_i) || v_stnseq;
                end if;
            end if;
        end loop;
    end if;
    if v_billtype = 'C' then
        for v_i in 1..entrylist.count loop
            if entrylist(v_i).s_bn is not null then
                dbms_output.put_line ('REVERSE_ENTRY:');
                if entrylist(v_i).s_ip = 'Y' then
                    dbms_output.put_line ('  Package:' || entrylist(v_i).s_ic);
                    open sliptx_cursor (entrylist(v_i).s_ic);
                    loop
                        fetch sliptx_cursor into v_stnseq;
                            exit when sliptx_cursor%NOTFOUND;
                        v_isvalid := REVERSE_ENTRY (rs_slip, v_stnseq, v_error_message);
                        if not v_isvalid then
                            v_status := 2;
                            raise e_reverse_entry;
                        end if;
                    end loop;
                    close sliptx_cursor;
                else
                    dbms_output.put_line ('  Single:' || entrylist(v_i).s_ic);
                    v_isvalid := REVERSE_ENTRY (rs_slip, entrylist(v_i).s_bn, v_error_message);
                    if not v_isvalid then
                        v_status := 2;
                        raise e_reverse_entry;
                    end if;
                end if;
            end if;
        end loop;
    end if;
    v_isvalid := UPDATE_SLIP (v_slpno);

-- Comment: Slip Record Locking will be performed by previous level program.
--    v_isvalid := RECORDUNLOCK ('Slip',v_slpno);
--    commit;

    if v_billtype = 'A' then
        if entrylist(1).s_sn <> 0 then
            v_bill_1 := entrylist(1).s_sn;
            v_stnseq_1 := v_stnseq_list(1);
        end if;
        if entrylist(2).s_sn <> 0 then
            v_bill_2 := entrylist(2).s_sn;
            v_stnseq_2 := v_stnseq_list(2);
        end if;
        if entrylist(3).s_sn <> 0 then
            v_bill_3 := entrylist(3).s_sn;
            v_stnseq_3 := v_stnseq_list(3);
        end if;
        if entrylist(4).s_sn <> 0 then
            v_bill_4 := entrylist(4).s_sn;
            v_stnseq_4 := v_stnseq_list(4);
        end if;
        if entrylist(5).s_sn <> 0 then
            v_bill_5 := entrylist(5).s_sn;
            v_stnseq_5 := v_stnseq_list(5);
        end if;
        if entrylist(6).s_sn <> 0 then
            v_bill_6 := entrylist(6).s_sn;
            v_stnseq_6 := v_stnseq_list(6);
        end if;
        if entrylist(7).s_sn <> 0 then
            v_bill_7 := entrylist(7).s_sn;
            v_stnseq_7 := v_stnseq_list(7);
        end if;
        if entrylist(8).s_sn <> 0 then
            v_bill_8 := entrylist(8).s_sn;
            v_stnseq_8 := v_stnseq_list(8);
        end if;
        if entrylist(9).s_sn <> 0 then
            v_bill_9 := entrylist(9).s_sn;
            v_stnseq_9 := v_stnseq_list(9);
        end if;
        if entrylist(10).s_sn <> 0 then
            v_bill_10 := entrylist(10).s_sn;
            v_stnseq_10 := v_stnseq_list(10);
        end if;
        if entrylist(11).s_sn <> 0 then
            v_bill_11 := entrylist(11).s_sn;
            v_stnseq_11 := v_stnseq_list(11);
        end if;
        if entrylist(12).s_sn <> 0 then
            v_bill_12 := entrylist(12).s_sn;
            v_stnseq_12 := v_stnseq_list(12);
        end if;
        if entrylist(13).s_sn <> 0 then
            v_bill_13 := entrylist(13).s_sn;
            v_stnseq_13 := v_stnseq_list(13);
        end if;
        if entrylist(14).s_sn <> 0 then
            v_bill_14 := entrylist(14).s_sn;
            v_stnseq_14 := v_stnseq_list(14);
        end if;
        if entrylist(15).s_sn <> 0 then
            v_bill_15 := entrylist(15).s_sn;
            v_stnseq_15 := v_stnseq_list(15);
        end if;
    end if;
    v_status := 1;
    dbms_output.put_line ('[  End  ]');
exception
    when e_invalid_billno then
        v_sts_desc := v_error_message;
    when e_invalid_billtype then
        v_sts_desc := v_error_message;
    when e_is_not_current_ip then
        v_sts_desc := v_error_message;
    when e_is_not_active_slip then
        v_sts_desc := v_error_message;
    when e_invalid_doccode then
        v_sts_desc := v_error_message;
    when e_invalid_itmpkgcode then
        v_sts_desc := v_error_message;
    when e_invalid_stat then
        v_sts_desc := v_error_message;
    when e_invalid_usrid then
        v_sts_desc := v_error_message;
    when e_invalid_bill_line then
        v_sts_desc := v_error_message;
    when e_slip_lock_by_other then
        v_sts_desc := v_error_message;
    when e_reverse_entry then
        v_sts_desc := v_error_message;
    when e_addentry_error then
        v_sts_desc := v_error_message;
-- Comment: Record Locking will be performed by previous level program.
--    rollback;
--        if v_is_slip_locked then
--            v_isvalid := RECORDUNLOCK ('Slip',v_slpno);
--        end if;
--        commit;

    when others then
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        dbms_output.put_line ('ERR: ' || v_error_code || ',' || v_error_message);
        v_sts_desc := v_error_message ;
        v_status := 2;
-- Comment: Record Locking will be performed by previous level program.
--        rollback;
--        if v_is_slip_locked then
--            v_isvalid := RECORDUNLOCK ('Slip',v_slpno);
--        end if;
--        commit;

end;