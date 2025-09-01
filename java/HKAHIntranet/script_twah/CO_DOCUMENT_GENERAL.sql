ALTER TABLE CO_DOCUMENT_GENERAL
 DROP PRIMARY KEY CASCADE;
DROP TABLE CO_DOCUMENT_GENERAL CASCADE CONSTRAINTS;

CREATE TABLE CO_DOCUMENT_GENERAL
(
 CO_SITE_CODE VARCHAR2(10 BYTE) NOT NULL ENABLE,
 CO_MODULE_CODE VARCHAR2(20 BYTE) NOT NULL ENABLE,	-- education, lmc
 CO_KEY_ID NUMBER(*,0) NOT NULL ENABLE,
 CO_DOCUMENT_ID NUMBER(*,0) DEFAULT 1,
 CO_DIRECTORY VARCHAR2(200 BYTE) NOT NULL,
 CO_DOCUMENT_DESC VARCHAR2(200 BYTE) NOT NULL,
 CO_CREATED_DATE DATE DEFAULT SYSDATE,
 CO_CREATED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CO_MODIFIED_DATE DATE DEFAULT SYSDATE,
 CO_MODIFIED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CO_ENABLED NUMBER(*,0) DEFAULT 1,
 PRIMARY KEY (CO_SITE_CODE, CO_MODULE_CODE, CO_KEY_ID, CO_DOCUMENT_ID)
);

SET DEFINE OFF;
--------------------------
-- Staff Education (TWAH)
--------------------------
----------------------------------
-- Hospital Education Policies
----------------------------------
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 1, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-201, Credential Committee.lnk.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 2, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-103, Professional Registration Policy.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 3, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-102, Orientation Policy.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 4, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-327, Internship Student Guidelines.lnk.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 5, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-328, Volunteer Services Policy.lnk.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 6, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-301, Job Description.lnk.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 7, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-105, Training and In-service Program.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 8, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-104, Continuous Education.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 9, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-302, Performance Appraisal.lnk.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 10, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-332, Staff Development Policy.lnk.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 11, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-108, Employee Scholarship Loan.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 12, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'MSO-502, CE Allowance for MS.doc');
--INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
--  VALUES ('twah', 13, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-301, Job Description.lnk.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 14, 'education.hep', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\00 Hospital Policies - Staff Education', 'SQE-101, Recruitment and Retention Plan.doc');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)  
  VALUES ('twah', 224, 'education.hep', 1, '\\necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\08.1 NCHK', 'CNE NCHK 100610 ... list_e.pdf');


----------------------------------
-- In-service Education Calendar
----------------------------------
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 15, 'education.is_cal', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\01 In-service Education - Calenda', 'TWAH-HR-SE Calendar 2010-01.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 16, 'education.is_cal', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\01 In-service Education - Calenda', 'TWAH-HR-SE Calendar 2010-02.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 17, 'education.is_cal', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\01 In-service Education - Calenda', 'TWAH-HR-SE Calendar 2010-03.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 18, 'education.is_cal', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\01 In-service Education - Calenda', 'TWAH-HR-SE Calendar 2010-04.pdf');

----------------------------------------------
-- Mandatory In-service Education: Information
----------------------------------------------
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 19, 'education.is_info', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\02 In-service Education', 'SQE-105, Training and In-service Program.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 20, 'education.is_info', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\02 In-service Education', '0.0 TWAH-HR-SE MIE Staff Category 100205 Revised 中英版.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 21, 'education.is_info', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\02 In-service Education', '0.0 TWAH-HR-SE MIE Guidelines 100205 Revised 中英版.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 22, 'education.is_info', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\02 In-service Education', '0.0 TWAH-HR-SE MIE Program 100205 Revised 中英版.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 23, 'education.is_info', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\02 In-service Education', 'In Service Training Record 2009.xls');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 24, 'education.is_info', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\02 In-service Education', 'In Service Training Record 2009.xls');

----------------------------------------------
-- Continuing External Education
----------------------------------------------

INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 40, 'education.cee', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\10 Continuing External Education', 'TWAH-HR-SE External Education 090116 CPR.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 41, 'education.cee', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\10 Continuing External Education', 'TWAH-HR-SE External Education 090116 First Aid Training.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) 
  VALUES ('twah', 42, 'education.cee', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\10 Continuing External Education', 'TWAH-HR-SE External Education 090116 First Aid Training.pdf');

----------------------------------------------
-- Evidence-based Practice
----------------------------------------------
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 64, 'education.ebp', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 100131 Evidence-based Nursing (ACHS) Definition.pdf');

----------------------------------------------
-- Literature Search Based
----------------------------------------------

----------------------------------------------
-- The Nursing Council of Hong Kong
----------------------------------------------

----------------------------------------------
-- In-service Eduction Review
----------------------------------------------
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 128, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'Outline TWAH-HR-SE 090123 CE-O Pain Series 1-5 Pain Concept & JCI Perspective Certificate.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 129, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O Pain Series 1-5(1) 090109 Pain & JCI Perspective Mr Peter CHUK.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 130, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O Pain Series 1-5(2) 090203 Epideral Anaglesia Dr T.F. CHAN.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 131, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O Pain Series 1-5(3) 090320 Pharmacologic Measures for Pain Relief Ms Edwina YUNG.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 132, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O Pain Series 1-5(4) 090619 Non-pharmacologic Measures for Pain Relief Mr William YEUNG Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 133, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O Pain Series 1-5(5) 090605 JCI Requirement - Pain Assessment & Management Ms Terry TAM.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 134, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O Pain Series 1-5(5) 090605 Pain Assessment & Management Mr Peter CHUK Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 135, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 081009 Safety IV Cathter Training Program\MPEGAV\AVSEQ01.DAT');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 136, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 070112 Management of Panic Disorder Dr NG Fung Shing.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 137, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 071123 Drug-induced Diseases - Reporting and Monitoring of ADR Clara WONG.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 138, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 080205 Pain relief - what you need to know pain relief Dr CHAN Tsun Fai.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 139, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 080930 Melamine Contamination of Food Dr Charles Wong.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 140, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 081118 Pain Management - A pharmacologic approach Dr T.F.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 141, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 090421 Intravenous Sedation Dr David T.H. LIM.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 142, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 090522 Administration of Medication in TWAH 1 Nursing Peter Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 143, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 090522 Administration of Medication in TWAH 2  Inattentional Blindness Anna Speech.ppt');
--INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
--  VALUES ('twah', 144, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', '');
--INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
--  VALUES ('twah', 145, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', '');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 146, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 090522 Administration of Medication in TWAH 3 MAR German Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 147, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 090522 Administration of Medication in TWAH 4 CAK&EDK Suzanne Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 148, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 090805 090807 Introcan Safety B. Braun Medical (H.K.) Ltd.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 149, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 100210 Evidence-based Practice (ACHS) Mr Peter CHUK.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 150, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-MC 100305 Blood Tranfusion Management & Safety (ACHS) Mr Peter CHUK Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 151, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC 071027 Ventilator Care in HDU Dr CHAN Tsun Fai.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 152, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC 080214 CPR Program Ms Margaret Pang.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 153, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC 081212 Hypertensive Emergency Mr Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 154, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'Outline TWAH-HR-SE 081216 CE-CC Critical Care Essentials 1-11 090625 Revised CNE 11.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 155, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(1) 090220 Assessing the Critically Ill Patient Mr Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 156, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(2) 090311 Fluids and Electrolytes Dr C.U.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 157, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(2) 090311 F&E A&B Immbalances Mr Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 158, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(3) 090227 Hemodynamic Monitoringing Mr Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 159, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(4) 090313 Shock & Management Mr Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 160, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(4) 090313 Shock & Management Dr Stephen C.S. CHAN CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 161, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(5) 090327 Acute Coronary Syndromes Dr W.H. CHAN CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 162, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(6) 090612 Heart Failure Dr C.F. CHOW CNE Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 163, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(6) 090612 Heart Failure Mr Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 164, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(7) 090417 Respiratory Failure Mr Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 165, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(9) 090529 Non-invasive Positive Pressure Ventilation Dr C.H. LEE CNE.pdf');
--INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
--  VALUES ('twah', 166, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', '');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 167, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-CC CCE 1-11(11) 090427 ICU Syndromes & Psychosocial Nursing Mr Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 168, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-MC 071012 Dementia Dr CHUNG Tin Hei.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 169, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-MC 100224 Acute Stroke Attack Dr Sally YIU.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 170, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-MC 100301 Palliative Care (ACHS) Judith Thalia Peter (Speech).pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 171, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OR 070613 3M Sterilization education program Module 1.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 172, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OR 070613 3M Sterilization education program Module 2.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 173, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OR 070613 3M Sterilization education program Module 3.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 174, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OR 070613 滅菌工作的品管概念.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 175, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OR 070911 071023 Instrument Reprocessing - Cidex OPA Johnson&Johnson.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 176, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OC 070419 Puerperium Management.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 177, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OC 090803 Postnatal Care & Baby Massage Ms Sharon CHAN CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 178, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OC 090814 Breast Feeding & Baby Massage Ms Sharon CHAN CNE.pdf');
--INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
--  VALUES ('twah', 179, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', '');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 180, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-OC 091127 Amniotic Fluid Embolism Dr Peter LO.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 181, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-PC 100312 Pediatric Nutrition Ms Priscilla LAU.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 182, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'PI 051216 泛險失講座 Ms Cathy YU & Mr William YEUNG.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 183, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 080328 Fall Assessment and Intervention.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 184, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-O 080401 Fall Assessment - Things you need to know about medications Ms Suzanne LEE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 185, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'ME 080415 Teamwork–What does it mean Jeri MARTIN.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 186, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'ME 081231 On-the-Job Coaching Peter CHUK CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 187, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'ME 091007 Racial Discrimination on Employment Mr Peter CHUK.pdf');
--INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
--  VALUES ('twah', 188, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', '');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 189, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CS 080107 Telephone Call & Customer Service.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 190, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'IC 070713 Prevention of Needle Stick Injury.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 191, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'IC 080210 PRESEPT Disinfectant Tablets Peter Tang Johnson&Johnson.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 192, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 070518 On Mood Disorders Mr John SO.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 193, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 070518 Stress management Mr John SO.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 194, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 071210 辦公室安全健康需知.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 195, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 080415 醫療氣體之安全使用.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 196, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 090525&27 090706 091028&30 醫療氣體之安全使用 HKO2 Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 197, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 090525&27 090706 091028&30 醫療氣體之安全使用 HKO2 Video.DAT');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 198, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 091019&27 Emergency Preparedness Program ACHS Ms Ruby WONG 2 sessions.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 199, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 090727 Workplace Violence Mr John CHAN.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 200, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 090727 Workplace Violence Ms Ruby WONG.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 201, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 100303 Magnetic Resonance Imaging - Work Safety Mr IP & Mr LEE Speech.ppt');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 202, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-SC 060713 Common Breast Conditions.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 203, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-SC 081024 Advances in Minimally Invasive Prostatectomy Chan Lung Wai CNE.pdf');
INSERT INTO CO_DOCUMENT_GENERAL (CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC)
  VALUES ('twah', 204, 'education.is_review', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'CE-SC 091113 Update in the Management of Urinary Stones Dr CHAN Lung Wai CNE.pdf');

----------------------------------------------
-- Mandatory In-service Education: Content
----------------------------------------------
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 209, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '01 SHARE Review 2009 e-learning Chinese TWAH 100414..ppt');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 209, 'education.is_content', 2, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '01 SHARE Review 2009 e-learning English&Chinese HKAH 100414 Q&A.xls');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 210, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '02 Basic Infection Control (e-learning Chinese) TWAH 100427.pdf');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 210, 'education.is_content', 2, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '02 Basic Infection Control (e-learning English&Chinese) TWAH 100427 Q&A.xls');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 211, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '02 Basic Infection Control (e-learning Chinese) TWAH 100427.pdf');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 211, 'education.is_content', 2, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '02 Basic Infection Control (e-learning English&Chinese) TWAH 100427 Q&A.xls');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 212, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '03A Manual Handling (e-learning English HKAH 100423 Bed-to-Chair with 1 assistant 20mins.AVI');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 213, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '03A Manual Handling Speech (e-learning Chinese) HKAH 100423 Q&A 20mins.PPT');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 214, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '03B Manual Handling (e-learning Chinese) TWAH 100423.pdf');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 216, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\13 e-learning TWAH', '04 CPR (Adult) (e-learning Chinese) TWAH 100505.pdf');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 217, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 090525&27 090706 091028&30 醫療氣體之安全使用 HKO2 Video.DAT');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 218, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 090525&27 090706 091028&30 醫療氣體之安全使用 HKO2 Speech.ppt');
-- INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 219, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', 'OSH 090525&27 090706 091028&30 醫療氣體之安全使用 HKO2 Video.DAT');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 220, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', '06 Fire Safety (Fire Service Department) (e-learning Chineses) TWAH 090309.pdf');
INSERT INTO CO_DOCUMENT_GENERAL(CO_SITE_CODE, CO_KEY_ID, CO_MODULE_CODE, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC) VALUES('twah', 221, 'education.is_content', 1, '\\Necftserver\public\TW_Intranet\Dept\Staff_Education\Info for Browsing\04 In-service Education - Notes', '06 Fire Safety 防火角式 (e-learning Chineses) TWAH 090821.pdf');
