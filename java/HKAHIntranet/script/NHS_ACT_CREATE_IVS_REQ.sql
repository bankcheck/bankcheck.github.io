create or replace
FUNCTION NHS_ACT_CREATE_IVS_REQ (
i_action IN VARCHAR2,
as_reqNo IN VARCHAR2,
as_reqDate VARCHAR2,
as_billTo VARCHAR2,
as_shipTo VARCHAR2,
as_suppDept VARCHAR2,
as_allotType VARCHAR2,
as_reqRemark VARCHAR2,
as_reqBy VARCHAR2,
aar_ivsReqDetails IVS_REQ_LIST1_TAB,
o_errmsg OUT VARCHAR2
)
RETURN NUMBER AS 
o_errcode NUMBER;
ls_serialNum varchar2(8);
ls_year varchar2(4);
ls_transType varchar2(1) := 'D';
ls_sysDate varchar2(12);
ls_reqDate varchar2(10);
ls_code varchar2(11);
ls_remarks varchar2(50);
i number;
li_currSerialNum number;
li_count number;
ld_applyQty number;
ld_reqlQty number;
isReqExist number ;
noOfCompleted number;
ls_itemCreatedBy pms_pur_d.ins_op@tah%TYPE;
ls_itemCreatedDt pms_pur_d.ins_dt@tah%TYPE;
ls_itemModifiedBy pms_pur_d.mod_op@tah%TYPE;
ls_itemModifiedDt pms_pur_d.mod_dt@tah%TYPE;
ls_trackNo varchar2(1000);
REQNO_NOT_FOUND EXCEPTION;
BEGIN
    ls_year := SUBSTR(TO_CHAR(SYSDATE,'YYYY'),3,2);
    ls_sysDate := TO_CHAR(SYSDATE,'YYYYMMDDHH24MI');
    ls_reqDate := TO_CHAR(TO_DATE(as_reqDate,'DD/MM/YYYY'),'YYYYMMDD');

    IF TRIM(as_reqNo) IS NOT NULL THEN    
      BEGIN
        SELECT 1
        INTO isReqExist
        FROM ivs_apply_m@tah
        WHERE apply_no = as_reqNo;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE REQNO_NOT_FOUND;
      END;
 
      IF isReqExist = 1 THEN        
        UPDATE ivs_apply_m@tah 
        SET  apply_date = ls_reqDate,
             apply_dept = as_billTo,
             shipped_to = as_shipTo,
             out_dept = as_suppDept,
             remarks = as_reqRemark,
             mod_op = as_reqBy,
             mod_dt = ls_sysDate
        WHERE apply_no = as_reqNo;
        
        DELETE FROM ivs_apply_d@tah
        WHERE apply_no = as_reqNo;                          
      END IF;
      
      FOR i in 1..aar_ivsReqDetails.COUNT LOOP
        ls_code := aar_ivsReqDetails(i).code;
        IF aar_ivsReqDetails(i).apply_qty IS NULL THEN
          ld_applyQty := 0;        
        ELSE
          ld_applyQty := TO_NUMBER(aar_ivsReqDetails(i).apply_qty);
        END IF;
        
        IF aar_ivsReqDetails(i).real_qty IS NULL THEN
          ld_reqlQty := 0;
        ELSE
          ld_reqlQty := TO_NUMBER(aar_ivsReqDetails(i).real_qty);        
        END IF;
        
        IF TRIM(aar_ivsReqDetails(i).ins_op) IS NOT NULL THEN
          ls_itemCreatedBy := aar_ivsReqDetails(i).ins_op;  
        ELSE
          ls_itemCreatedBy := as_reqBy;        
        END IF;

        IF TRIM(aar_ivsReqDetails(i).ins_dt) IS NOT NULL THEN
          ls_itemCreatedDt := aar_ivsReqDetails(i).ins_dt;       
        ELSE
          ls_itemCreatedDt := ls_sysDate;              
        END IF;
        
        IF TRIM(aar_ivsReqDetails(i).mod_op) IS NOT NULL THEN
          IF TRIM(aar_ivsReqDetails(i).mod_op) = 'Y' THEN
            ls_itemModifiedBy := as_reqBy;
            ls_itemModifiedDt := ls_sysDate;
          ELSE
            ls_itemModifiedBy := aar_ivsReqDetails(i).mod_op;    
          END IF;
        ELSE
          ls_itemModifiedBy := as_reqBy;
          ls_itemModifiedDt := ls_sysDate;         
        END IF;
        
        IF TRIM(aar_ivsReqDetails(i).click_label) = 'Y' THEN
          IF INSTR(aar_ivsReqDetails(i).remarks,'[REQUEST LABEL]') > 0 THEN
            ls_remarks := TRIM(aar_ivsReqDetails(i).remarks);
          ELSE
            ls_remarks := TRIM(aar_ivsReqDetails(i).remarks)||' [REQUEST LABEL]';
          END IF;
        ELSE
          dbms_output.put_line('[remarks]'||aar_ivsReqDetails(i).remarks);
        	dbms_output.put_line('[remark lenght]'||INSTR(aar_ivsReqDetails(i).remarks,'[REQUEST LABEL]'));
          IF INSTR(aar_ivsReqDetails(i).remarks,'[REQUEST LABEL]') > 0 THEN
            ls_remarks := SUBSTR(TRIM(aar_ivsReqDetails(i).remarks),1,INSTR(TRIM(aar_ivsReqDetails(i).remarks),'[REQUEST LABEL]',1)-1)||SUBSTR(TRIM(aar_ivsReqDetails(i).remarks),INSTR(TRIM(aar_ivsReqDetails(i).remarks),'[REQUEST LABEL]',1)+LENGTH('[REQUEST LABEL]'));
          ELSE
            ls_remarks := TRIM(aar_ivsReqDetails(i).remarks)||' [REQUEST LABEL]';
          END IF;
        END IF;
          
        INSERT INTO ivs_apply_d@tah (
        apply_no,
        code,
        apply_unit,
        if_close,
        ins_op,
        ins_dt,
        mod_op,
        mod_dt,
        apply_qty,
        real_qty,
        remain_qty,
        seq_no,
        by_pass,
        remarks) VALUES (
        as_reqNo
        ,aar_ivsReqDetails(i).code
        ,aar_ivsReqDetails(i).unit_code
        ,aar_ivsReqDetails(i).if_close
        ,ls_itemCreatedBy
        ,ls_itemCreatedDt
        ,ls_itemModifiedBy
        ,ls_itemModifiedDt        
        ,ld_applyQty
        ,ld_reqlQty
        ,ld_applyQty-ld_reqlQty
        ,aar_ivsReqDetails(i).seq_no
        ,NULL
        ,ls_remarks);    
      END LOOP;
      
      o_errmsg := 1;
      o_errmsg := 'Record Updated';
    ELSE
      SELECT count(*)
      INTO li_count
      FROM pms_inv_no@tah
      WHERE no_year = ls_year
      AND no_type = ls_transType;
    
      IF li_count = 0 OR SQL%ROWCOUNT = 0 THEN
        INSERT INTO pms_inv_no@tah(no_year,no_type,no_serial_num) VALUES (ls_year,ls_transType,1);
        li_currSerialNum := 1;
      ELSE
        SELECT no_serial_num
        INTO   li_currSerialNum
        FROM   pms_inv_no@tah
        WHERE  no_year = ls_year
        AND    no_type = ls_transType
        FOR UPDATE NOWAIT;
        
        li_currSerialNum := li_currSerialNum + 1;
  
        UPDATE pms_inv_no@tah
        SET    no_serial_num = li_currSerialNum
        WHERE  no_year = ls_year
        AND    no_type = ls_transType;
      END IF;
      
      ls_serialNum := ls_transType||ls_year||substr('000000'||li_currSerialNum,-5,5);
           
      INSERT INTO ivs_apply_m@tah (
      apply_no,
      apply_date,
      out_month,
      out_date,
      apply_dept,
      out_dept,
      if_close,
      print_flag,
      block_flag,
      ins_op,
      ins_dt,
      mod_op,
      mod_dt,
      allot_type,
      er_mark,
      remarks,
      shipped_to,
      exp_ship_date
      ) VALUES (
      ls_serialNum,
      ls_reqDate,
      NULL,
      NULL,
      as_billTo,
      as_suppDept,
      'N',
      '0',
      '0',
      as_reqBy,
      ls_sysDate,
      as_reqBy,
      ls_sysDate,
      as_allotType,
      NULL,
      as_reqRemark,
      as_shipTo,
      DECODE(SIGN(SYSDATE-TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')||'1000','YYYYMMDDHH24MI')),1,TO_CHAR(TO_DATE(ls_reqDate,'YYYYMMDD')+1,'YYYYMMDD'),'0',ls_reqDate,'-1',ls_reqDate) 
      );
  
      FOR i in 1..aar_ivsReqDetails.COUNT LOOP
        ls_code := aar_ivsReqDetails(i).code;
        IF aar_ivsReqDetails(i).apply_qty IS NULL THEN
          ld_applyQty := 0;        
        ELSE
          ld_applyQty := TO_NUMBER(aar_ivsReqDetails(i).apply_qty);
        END IF;
        
        IF aar_ivsReqDetails(i).real_qty IS NULL THEN
          ld_reqlQty := 0;
        ELSE
          ld_reqlQty := TO_NUMBER(aar_ivsReqDetails(i).real_qty);        
        END IF;
        
        IF TRIM(aar_ivsReqDetails(i).ins_op) IS NOT NULL THEN
          ls_itemCreatedBy := aar_ivsReqDetails(i).ins_op;  
        ELSE
          ls_itemCreatedBy := as_reqBy;        
        END IF;

        IF TRIM(aar_ivsReqDetails(i).ins_dt) IS NOT NULL THEN
          ls_itemCreatedDt := TO_CHAR(TO_DATE(aar_ivsReqDetails(i).ins_dt,'DD/MM/YYYY HH24MI'),'YYYYMMDDHH24MI');       
        ELSE
          ls_itemCreatedDt := ls_sysDate;              
        END IF;
        
        IF TRIM(aar_ivsReqDetails(i).mod_op) IS NOT NULL THEN
          IF TRIM(aar_ivsReqDetails(i).mod_op) = 'Y' THEN
            ls_itemModifiedBy := as_reqBy;
            ls_itemModifiedDt := ls_sysDate;
          ELSE
            ls_itemModifiedBy := aar_ivsReqDetails(i).mod_op;
            ls_itemModifiedDt := TO_CHAR(TO_DATE(aar_ivsReqDetails(i).mod_dt,'DD/MM/YYYY HH24MI'),'YYYYMMDDHH24MI');            
          END IF;
        ELSE
          ls_itemModifiedBy := as_reqBy;
          ls_itemModifiedDt := ls_sysDate;         
        END IF;
        
        IF TRIM(aar_ivsReqDetails(i).click_label) = 'Y' THEN
          ls_remarks := TRIM(aar_ivsReqDetails(i).remarks)||' [REQUEST LABEL]';
        ELSE
          ls_remarks := TRIM(aar_ivsReqDetails(i).remarks);
        END IF;
          
        INSERT INTO ivs_apply_d@tah (
        apply_no,
        code,
        apply_unit,
        if_close,
        ins_op,
        ins_dt,
        mod_op,
        mod_dt,
        apply_qty,
        real_qty,
        remain_qty,
        seq_no,
        by_pass,
        remarks) VALUES (
        ls_serialNum
        ,aar_ivsReqDetails(i).code
        ,aar_ivsReqDetails(i).unit_code
        ,aar_ivsReqDetails(i).if_close
        ,as_reqBy
        ,ls_sysDate
        ,as_reqBy
        ,ls_sysDate    
        ,ld_applyQty
        ,ld_reqlQty
        ,ld_applyQty-ld_reqlQty
        ,aar_ivsReqDetails(i).seq_no
        ,NULL
        ,ls_remarks); 
      END LOOP; 
     
      o_errcode := 0;     
      o_errmsg := ls_serialNum;         
    END IF;

  RETURN o_errcode;
EXCEPTION 
WHEN REQNO_NOT_FOUND THEN
	ROLLBACK;
  o_errcode := -1;
  o_errmsg := 'NO SUCH REQ NO';
  RETURN o_errcode;  
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line(SQLCODE||' -ERROR- '||SQLERRM);
  o_errcode := -1;  
  o_errmsg := '[RETURN MSG]:'||SQLERRM;
  RETURN o_errcode;
END NHS_ACT_CREATE_IVS_REQ;