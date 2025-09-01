create or replace
FUNCTION NHS_ACT_CREATE_PR (
i_action IN VARCHAR2,
as_reqNo IN VARCHAR2,
as_reqDate VARCHAR2,
as_reqBy VARCHAR2,
as_billTo VARCHAR2,
as_shipTo VARCHAR2,
as_reqRemark VARCHAR2,
aar_prDetails PR_LIST_TAB,
o_errmsg OUT VARCHAR2
)
RETURN NUMBER AS 
o_errcode NUMBER;
reqNo varchar2(12);
ls_serialNum varchar2(8);
ls_year varchar2(4);
ls_transType varchar2(1) := 'I';
ls_approvalBy varchar2(20);
ls_sysDate varchar2(12);
ls_reqDate varchar2(10);
ls_recAddr varchar2(500); 
ls_code varchar2(11); 
ls_itemCreateBy varchar2(20); 
i number;
li_currSerialNum number;
li_count number;
ld_applyQty number;
ld_purQty number;
isPrExist number ;
isPoExist number;
li_approveFlag number;
ls_if_check varchar2(1);
ls_ppoId varchar2(50);
ls_loginGRP varchar2(4);
ls_approveBy varchar2(10);
noOfCompleted number;
ls_itemCreatedBy pms_pur_d.ins_op@tah%TYPE;
ls_itemCreatedDt pms_pur_d.ins_dt@tah%TYPE;
ls_itemModifiedBy pms_pur_d.mod_op@tah%TYPE;
ls_itemModifiedDt pms_pur_d.mod_dt@tah%TYPE;
ls_trackNo varchar2(1000);
PRNO_NOT_FOUND EXCEPTION;
PO_CREATED_ERR EXCEPTION;
BEGIN
    ls_year := SUBSTR(TO_CHAR(SYSDATE,'YYYY'),3,2);
    ls_sysDate := TO_CHAR(SYSDATE,'YYYYMMDDHH24MI');
    ls_reqDate := TO_CHAR(TO_DATE(as_reqDate,'DD/MM/YYYY'),'YYYYMMDD');

    IF TRIM(as_reqNo) IS NOT NULL THEN    
      BEGIN
        SELECT if_check, approve_flag, ppo_id
        INTO ls_if_check, li_approveFlag, ls_ppoId
        FROM pms_pur_m@tah
        WHERE pur_no = as_reqNo;
        
        isPrExist := 1;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE PRNO_NOT_FOUND;
      END;
 
      BEGIN
        SELECT Trim(sub.user_id)
        INTO ls_approveBy
        FROM pms_notice_to@tah pnt, sys_user_basic@tah sub
        WHERE Trim(pnt.staff_no) = Trim(sub.user_alias)
        AND pnt.active = 1 
        AND pnt.area = (SELECT area FROM pn_dept@tah WHERE dept_id = as_billTo)
        AND pnt.type ='RA' 
        AND Trim(pnt.unit) = Trim(as_billTo)
        AND sub.user_id = as_reqBy;
      EXCEPTION
        WHEN OTHERS THEN
        ls_approveBy := null;
      END;        
  
      BEGIN
        SELECT Trim(group_id)
        INTO ls_loginGRP
        FROM sys_group_user_basic@tah
        WHERE user_id = as_reqBy;
      EXCEPTION
        WHEN OTHERS THEN
        ls_loginGRP := null;
      END;       

      IF isPrExist = 1 THEN
        BEGIN
          SELECT 1
          INTO isPoExist
          FROM pms_order_m@tah
          WHERE pur_no = as_reqNo;
        EXCEPTION
          WHEN OTHERS THEN
          isPoExist := 0;
        END;
        
        IF isPoExist = 1 THEN
          RAISE PO_CREATED_ERR;
        ELSE
          IF TRIM(ls_ppoId) IS NOT NULL THEN
            UPDATE pms_pur_m@tah 
            SET  pur_date = ls_reqDate,
                 pur_op = as_reqBy,
                 pur_dept = as_billTo,
                 shipped_to = as_shipTo,
                 remark = as_reqRemark,
                 place = NVL(place,(SELECT rece_addr FROM pn_dept@tah WHERE dept_id = as_billTo)),
                 mod_op = as_reqBy,
                 mod_dt = ls_sysDate
            WHERE pur_no = as_reqNo;
            
            DELETE FROM pms_pur_d@tah
            WHERE pur_no = as_reqNo;            
          ELSE
            IF li_approveFlag = 1 THEN
              IF as_reqBy = ls_approveBy OR ls_loginGRP = 'MGR1' THEN
                UPDATE pms_pur_m@tah 
                SET pur_date = ls_reqDate,
                    pur_op = as_reqBy,
                    pur_dept = as_billTo,
                    shipped_to = as_shipTo,                    
                    remark = as_reqRemark,
                    place = NVL(place,(SELECT rece_addr FROM pn_dept@tah WHERE dept_id = as_billTo)),
                    mod_op = as_reqBy,
                    mod_dt = ls_sysDate,						 
                    approve_date = ls_sysDate,
                    send_approve_flag = 1,
                    send_approve_date = ls_sysDate
                WHERE pur_no = as_reqNo;

                DELETE FROM pms_pur_d@tah
                WHERE pur_no = as_reqNo;                
              ELSE
                UPDATE pms_pur_m@tah 
                SET  pur_date = ls_reqDate,
                     pur_op = as_reqBy,
                     pur_dept = as_billTo,
                     shipped_to = as_shipTo,                     
                     remark = as_reqRemark,
                     place = NVL(place,(SELECT rece_addr FROM pn_dept@tah WHERE dept_id = as_billTo)),
                     mod_op = as_reqBy,
                     mod_dt = ls_sysDate,
                     approve_flag = 0,
                     send_approve_flag = 0
                WHERE pur_no = as_reqNo;
                
                DELETE FROM pms_pur_d@tah
                WHERE pur_no = as_reqNo;                
                
                o_errmsg := 'PLEASE APPROVAL AGAIN';
              END IF;
            ELSE
              IF as_reqBy = ls_approveBy OR ls_loginGRP = 'MGR1' THEN
                UPDATE pms_pur_m@tah 
                SET pur_date = ls_reqDate,
                    pur_op = as_reqBy,
                    pur_dept = as_billTo,
                    shipped_to = as_shipTo,                    
                    remark = as_reqRemark,
                    place = NVL(place,(SELECT rece_addr FROM pn_dept@tah WHERE dept_id = as_billTo)),
                    mod_op = as_reqBy,
                    mod_dt = ls_sysDate,
                    approve_flag = 1,
                    approve_date = ls_sysDate,
                    approve_by = as_reqBy,
                    send_approve_flag = 1,
                    send_approve_date = ls_sysDate
                WHERE pur_no = as_reqNo;
                
                DELETE FROM pms_pur_d@tah
                WHERE pur_no = as_reqNo;                
              ELSE
                UPDATE pms_pur_m@tah 
                SET  pur_date = ls_reqDate,
                     pur_op = as_reqBy,
                     pur_dept = as_billTo,
                     remark = as_reqRemark,
                     shipped_to = as_shipTo,                     
                     place = NVL(place,(SELECT rece_addr FROM pn_dept@tah WHERE dept_id = as_billTo)),
                     mod_op = as_reqBy,
                     mod_dt = ls_sysDate,
                     approve_flag = 0,
                     send_approve_flag = 0
                WHERE pur_no = as_reqNo;
                
                DELETE FROM pms_pur_d@tah
                WHERE pur_no = as_reqNo;
              END IF;              
            END IF;
          END IF;
        END IF;              
      END IF;
      
      FOR i in 1..aar_prDetails.COUNT LOOP
        ls_code := aar_prDetails(i).code;
        ld_purQty := TO_NUMBER(aar_prDetails(i).pur_qty);
        IF TRIM(aar_prDetails(i).ins_op) IS NOT NULL THEN
          ls_itemCreatedBy := aar_prDetails(i).ins_op;
        ELSE
          ls_itemCreatedBy := as_reqBy;
        END IF;
        
        IF TRIM(aar_prDetails(i).ins_dt) IS NOT NULL THEN
          ls_itemCreatedDt := aar_prDetails(i).ins_dt;       
        ELSE
          ls_itemCreatedDt := ls_sysDate;              
        END IF;
        
        IF TRIM(aar_prDetails(i).mod_op) IS NOT NULL THEN
          IF TRIM(aar_prDetails(i).mod_op) = 'Y' THEN
            ls_itemModifiedBy := as_reqBy;
            ls_itemModifiedDt := ls_sysDate;
          ELSE
            ls_itemModifiedBy := aar_prDetails(i).mod_op;
            ls_itemModifiedDt := aar_prDetails(i).mod_dt;            
          END IF;
        ELSE
          ls_itemModifiedBy := as_reqBy;
          ls_itemModifiedDt := ls_sysDate;         
        END IF;
          
        SELECT (ld_purQty*pms_qty)/(DECODE(unit_flag,'1',1,'0',pack_qty))
        INTO ld_applyQty
        FROM ivs_goods@tah
        WHERE code_no = ls_code;
        
        INSERT INTO pms_pur_d@tah (
        pur_no
        ,code
        ,ver_no
        ,add_code
        ,remark
        ,ins_op
        ,ins_dt
        ,mod_op
        ,mod_dt
        ,pur_qty
        ,add_qty
        ,apply_qty
        ,if_check
        ,remain_trans
        ,completed) VALUES (
        as_reqNo
        ,aar_prDetails(i).code
        ,aar_prDetails(i).ver_no
        ,NULL                                                                                                                                                                                
        ,aar_prDetails(i).remark
        ,ls_itemCreatedBy
        ,ls_itemCreatedDt
        ,ls_itemModifiedBy
        ,ls_itemModifiedDt
        ,ld_purQty
        ,0
        ,ld_applyQty
        ,NULL
        ,ld_purQty
        ,'N');    
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
  
      SELECT rece_addr
      INTO ls_recAddr
      FROM pn_dept@tah
      WHERE Trim(dept_id) = as_billTo;
   
      INSERT INTO pms_pur_m@tah (
      pur_no,
      pur_date,
      pur_op,
      pur_source,
      pur_dept,
      patient_id,
      floor,
      bed_no,
      pur_mark,
      remark,
      place,
      if_check,
      ins_op,
      ins_dt,
      mod_op,
      mod_dt,
      flow_type,
      budget_no,
      approve_flag,
      approve_by,
      approve_date,
      ppo_id,
      send_approve_flag,
      send_approve_date,
      cancel_flag,
      shipped_to
      ) VALUES (
      ls_serialNum,
      ls_reqDate,
      as_reqBy,
      '1',
      as_billTo,
      NULL,
      NULL,
      NULL,
      NULL,
      as_reqRemark,
      ls_recAddr,
      'N',
      as_reqBy,
      ls_sysDate,
      as_reqBy,
      ls_sysDate,
      '1',
      NULL,
      0,
      ls_approvalBy,
      NULL,
      NULL,
      0,
      NULL,
      'N',
      as_shipTo);
  
      FOR i in 1..aar_prDetails.COUNT LOOP
        ls_code := aar_prDetails(i).code;
        ld_purQty := TO_NUMBER(aar_prDetails(i).pur_qty);
        
        SELECT (ld_purQty*pms_qty)/(DECODE(unit_flag,'1',1,'0',pack_qty))
        INTO ld_applyQty
        FROM ivs_goods@tah
        WHERE code_no = ls_code;
        
        INSERT INTO pms_pur_d@tah (
        pur_no
        ,code
        ,ver_no
        ,add_code
        ,remark
        ,ins_op
        ,ins_dt
        ,mod_op
        ,mod_dt
        ,pur_qty
        ,add_qty
        ,apply_qty
        ,if_check
        ,remain_trans
        ,completed) VALUES (
        ls_serialNum
        ,aar_prDetails(i).code
        ,aar_prDetails(i).ver_no
        ,NULL                                                                                                                                                                                
        ,aar_prDetails(i).remark
        ,as_reqBy
        ,ls_sysDate
        ,as_reqBy
        ,ls_sysDate
        ,ld_purQty
        ,0
        ,ld_applyQty
        ,NULL
        ,ld_purQty
        ,'N');    
      END LOOP; 
     
      o_errcode := 0;     
      o_errmsg := ls_serialNum;         
    END IF;

  RETURN o_errcode;
EXCEPTION
WHEN PO_CREATED_ERR THEN
	ROLLBACK;
  o_errcode := -1;
  o_errmsg := 'CANNOT UPDATE PR AFTER PO CREATED';
  RETURN o_errcode;  
WHEN PRNO_NOT_FOUND THEN
	ROLLBACK;
  o_errcode := -1;
  o_errmsg := 'NO SUCH PR NO';
  RETURN o_errcode;  
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line(SQLCODE||' -ERROR- '||SQLERRM);
  o_errcode := -1;  
  o_errmsg := '[RETURN MSG]:'||SQLERRM;
  RETURN o_errcode;
END;