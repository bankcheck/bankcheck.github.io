ALTER TABLE CO_DOCUMENT
 DROP PRIMARY KEY CASCADE;
DROP TABLE CO_DOCUMENT CASCADE CONSTRAINTS;

CREATE TABLE CO_DOCUMENT
(
 CO_DOCUMENT_ID NUMBER(*,0) NOT NULL ENABLE,
 CO_DESCRIPTION VARCHAR2(100 BYTE) NULL,
 CO_LOCATION VARCHAR2(200 BYTE) NOT NULL,
 CO_WEB_FOLDER VARCHAR2(1 BYTE) DEFAULT 'Y', -- Y: \\www-server\document folder
 CO_LOCATION_WITH_FILENAME VARCHAR2(1 BYTE) DEFAULT 'Y', -- Y: exactly filename, N: folder name only
 CO_FILE_PREFIX VARCHAR2(50 BYTE) NULL, -- filename prefix
 CO_FILE_SUFFIX VARCHAR2(50 BYTE) NULL, -- filename suffix
 CO_FILE_LAST_MODIFIED NUMBER(*,0),
 CO_CREATED_DATE DATE DEFAULT SYSDATE,
 CO_CREATED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CO_MODIFIED_DATE DATE DEFAULT SYSDATE,
 CO_MODIFIED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 CO_ENABLED NUMBER(*,0) DEFAULT 1,
 CO_HIT_RATE NUMBER(*,0) DEFAULT 0,
 CO_EXTERNAL_LINK VARCHAR2(1 BYTE) DEFAULT 'N',
 PRIMARY KEY (CO_DOCUMENT_ID)
);

SET DEFINE OFF
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(01, 'Power Point for Safety', '/APS_SD.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(02, 'Fall PP', '/Intranet/Portal/Staff Education/Compulsory Class/Continuing Nursing Education Record (CNE)/Fall PP.ppt');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(03, 'Nursing coma patients', '/Intranet/Portal/Staff Education/Compulsory Class/Continuing Nursing Education Record (CNE)/Nursing coma patients.ppt');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(04, 'English PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Medical Gas Safety Class Information/Medical Gas Safety Compulsory Class In-service Eng sheet.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(05, 'Chinese PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Medical Gas Safety Class Information/Medical Gas Safety Compulsory Class In-service Sheet (Chinese).pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(07, 'English PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Manual Handling/Manual Handling.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(08, 'English/Chinese PDF', '/Intranet/Portal/Staff Education/Compulsory Class/OSH/MHO + DSE compulsory class Jan 2009.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(09, 'English/Chinese PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Fire Safety Disaster Class Information/FSD PP.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(10, 'English PDF', '/Intranet/Portal/Staff Education/Compulsory Class/SHARE/SHARE 09.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(11, 'PDF', '/Intranet/news/Background Information on Swine Influenzax.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(12, 'PDF', '/Intranet/news/IMPORTANT Information on Swine Influenza for Staff.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(13, 'PDF', '/Intranet/news/IMPORTANT Information on Swine Influenza for Staff (2) f.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(14, 'English PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Infection Control/IC  You  for Nursing & Allied Health e-learning by Alice.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(15, 'English PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Infection Control/IC & You Ancillary by Alice June 09 Eng.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(16, 'Chinese PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Infection Control/IC & You Ancillary by Alice June 09 Chi.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(17, 'Presentation PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Volunteers/Presentation1.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(18, 'SHARE PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Volunteers/SHARE.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(19, 'Infection Control PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Volunteers/IC e-learning by Alice volunteer.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(20, 'OSH PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Volunteers/OSH for Volunteer 2009.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(21, 'Fire Safety PDF', '/Intranet/Portal/Staff Education/Compulsory Class/Volunteers/Raj''s FSD for Volunteer PP.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(22, 'CPR Notes for Attendees (English) Revised', '/Intranet/Portal/Staff Education/Compulsory Class/CPR/CPR Notes for Attendees _English_ Revised 032011.pdf');	-- updated requested by Hellen 22 Mar 2011
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(23, 'CPR Pre-Test Questions', '/Intranet/Portal/Staff Education/Compulsory Class/CPR/CPR Pre-Test Questions Revised 032011.pdf');	-- updated requested by Hellen 22 Mar 2011
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(24, 'Information to Staff June 19', '/Portal News/Education/Information to Staff June 19 (2).pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(25, 'Important Info - Supervisor', '\\hkim\im\MedicalProgram\2 Operation\1 Operation\Important Info\Supervisor - 090804.xls', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(26, 'Monthly IP Report', '\\hkim\im\Common\Statistics\Hospital Statistics\2010\Ipd_10.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(27, 'Monthly OP Report', '\\hkim\im\Common\Statistics\Hospital Statistics\2010\Outpatient Report_ 2010.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(42, 'Monthly OP (by Doctors)', '\\hkim\im\Common\Statistics\Outpatient report\OD 05- 08\2009\OD06_2009.rtf', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(43, 'Monthly OP (by Doctors & indicating New/ Return Patient)', '\\hkim\im\Common\Statistics\Outpatient report\OD 05- 08\2009\OD07_2009.rtf', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(44, 'Monthly OP (Japanese Patient)', '\\hkim\im\Common\Statistics\Outpatient report\OD 09-11\2009\OD11_2009.rtf', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(45, 'Monthly Health Assessment(by Type of Physical Check)', '\\hkim\im\Common\Statistics\Health Assessment Report\2009\Type of PC_2009.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(46, 'Monthly Health Assessment (by Individual Physician)', '\\hkim\im\Common\Statistics\Health Assessment Report\2009\PC by physician_2009.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(47, 'Monthly Health Assessment (by GP/SP)', '\\hkim\im\Common\Statistics\Health Assessment Report\2009\General Census 2009.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(48, 'Monthly Health Assessment (by Corporate)', '\\hkim\im\Common\Statistics\Health Assessment Report\2009\Corporate Physical Census 2009.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(49, 'Monthly Health Assessment (by Optional Test)', '\\hkim\im\Common\Statistics\Health Assessment Report\2009\Optional Test 2009.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(28, 'Monthly Departmental Report', '\\hkim\im\Common\Statistics\Hospital Statistics\2010\Departmental Report_ 2010.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(29, 'Daily IP', '\\hkim\im\Common\Statistics\Hospital Statistics\2010\daily census 2010.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(50, 'Daily OP (by doctor & shift) ', '\\hkim\im\Common\Statistics\Outpatient report\Daily Census', 'N', 'N', '', '.rtf');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(85, 'Monthly OP (OD 05- 08)', '\\hkim\im\Common\Statistics\Outpatient report\OD 05- 08', 'N', 'N', '', '.rtf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(86, 'Monthly OP (OD 09-11)', '\\hkim\im\Common\Statistics\Outpatient report\OD 09-11', 'N', 'N', '', '.rtf');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(30, 'Infectious Disease', '\\hkim\im\Common\Statistics\Hospital Statistics\2010\Infectious Disease 2010.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(31, 'Drs on Call schedule', '\\hkim\im\Patients Accounts\Staff share\Registration\Drs on Call schedule\On Call Schedule', 'N', 'N', '.xls');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(32, 'PBO - Monthly Incident Report', '\\hkim\im\Common\PBO - Monthly Incident Report', 'N', 'N', 'PBO Monthly Incident Report ', '.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(33, 'Current OB Bed Report', '\\hkim\im\Patients Accounts\Staff share\Immigration\Wednesday Reports\Current Month', 'N', 'N', 'DH ', '.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(34, 'Archive of OB Bed Report', '\\hkim\im\Patients Accounts\Staff share\Immigration\Wednesday Reports', 'N', 'N', 'DH ', '.doc');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(35, 'HKAH - Just Done It', '/Upload/PI/Just Done It', 'N', 'HKAH-Just Done It - ', '.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(36, 'GHC - Reminder Letter', '/Upload/GHC/Reminder Letter.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(37, 'Chinese PDF', '/Intranet/Portal/Staff Education/Compulsory Class/SHARE/SHARE Again Chinese 2009.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(38, 'ACHS Part 1', '/Intranet/Dept/PI/Standards/achs1.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(39, 'ACHS Part 3', '/Intranet/Dept/PI/Standards/achs3.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(40, 'Emergency Backup Schedule', '\\hkim\im\Physician\Emergency Back Up', 'N', 'N', '(', ').xls');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(41, 'DH Duty Roster', '/Upload/Important Information Sharing/DH Duty Roster', 'N', 'DH Duty Roster ', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(51, 'Committee Minutes', '/Upload/Committee Minutes', 'N', '', '.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(52, 'OB REFUNDED CASE (2010)', '\\hkim\PA Share\OB REFUNDED CASE (2010).xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(53, 'Namelist for Mandatory Classes', '\\hkim\im\Staff_Education\Yearly Staff Education Record\2010 & 2011\Namelist for Mandatory Classes 2011.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(54, 'Marketing Year Plan 2011', '\\hkim\im\Market\2011\2011 Year Planner.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(55, 'IP/OP statistic for board meeting', '\\hkim\im\Medical\MR_DATA\STATISTICS\others\RY\2010\IPOP report - 2010.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(56, 'Charity Premiere seating plan', '/Upload/Charity Premiere Seating Plan/Charity Premiere seating plan V1.xls', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(57, 'ACHS �V Introduction presentation', '\\hkim\im\Intranet\Dept\PI\ACHS\TT ACHS 090812 (for PI Intranet).ppt', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(58, 'Criterion Leaders and Members', '\\hkim\im\Intranet\Dept\PI\ACHS\Criterion Leader and Team  0909.doc', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(59, 'Tenancy agreement', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\In-House Doctors', 'N', 'N', 'Tenancy Agreement ', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(60, 'Contract', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\In-House Doctors', 'N', 'N', 'Contract - ', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(61, 'Clinic Schedule', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\In-House Doctors', 'N', 'N', 'Clinic Schedule - ', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(62, 'Master Checklist', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\In-House Doctors\In-house Physician - Checklist.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(78, 'Index', '\\hkim\im\Physician\Contract\Other Information\Index.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(79, 'List of Physicians with contracts', '\\hkim\im\Physician\Contract\Other Information\List of Physicians with contracts - Age.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(291, 'List of Physicians with contracts', '\\hkim\im\Physician\Contract\Other Information\List of Physicians with contracts.xls', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(63, 'Namelist for Special Training', '\\hkim\im\Staff_Education\Yearly Staff Education Record\2010 & 2011\Namelist for Special Training 2011.xls', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(64, 'English PDF', '/Intranet/Portal/Staff Education/Compulsory Class/In-services/MRI Safety/HKAH MRI Safety 091218.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(65, 'Chinese PDF', '/Intranet/Portal/Staff Education/Compulsory Class/In-services/MRI Safety/HKAH MRI Safety Chinese 100115.pdf');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(66, 'Food Services - Daily Menu', '\\hkim\im\Intranet\Dept\FoodServices\Menu\DailyMenu.doc', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(67, 'Hospital Policy', '\\hkim\im\Administration Policy\departmental policy\INDEX.doc', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(68, 'Departmental Policy', '/Intranet/Portal/Policy/HKAH Master Policies.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(69, 'EVSS Package w Requriemnt', '/Intranet/Portal/Fees/EVSS Package w Requriemnt.xls');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(70, 'Bed Class Distribution', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Bed Class Distribution.xls', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(71, 'Fact Sheets', '\\hkim\im\Physician\Informed Consent\Final Version - PDF Files\Fact Sheets', 'N', 'N', '', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(72, 'HSI Sharing Minutes', '\\hkim\im\Common\Swine flu\Crisis Management Committee\2009 HS1 Minutes', 'N', 'N', 'Contingency meeting', '.doc');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(73, 'Informed Consent', '\\hkim\im\Physician\Informed Consent\Final Version - PDF Files\Consent forms', 'N', 'N', '', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(74, 'Registration Form', '\\hkim\im\Patients Accounts\Staff share\PBO\External Form\Registration Form\Registration Form.pdf', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(75, 'Health Care Advisory', '/Upload/Admission at ward/Advisory Chi-Eng.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(76, 'Patient Admission Leaflet', '/Upload/Admission at ward/HKAH Patient Admission Leaflet.pdf');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(80, 'ACHS PP for Ancillary Staff', '/Intranet/Portal/ACHS/TT 100208 ACHS Mandatory Classes (Ancillary).pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(81, 'ACHS PP for La Rue Staff', '/Intranet/Portal/ACHS/TT 1001 ACHS Mandatory Classes (Common).pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(82, 'ACHS PP for Clinical and Allied Health Staff', '/Intranet/Portal/ACHS/Raj''s Teaching materials for ACHS Mandatory Classes for Clincal and Allied Health Staff.pdf');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(91, 'HKAH Floor Plan', '/Intranet/Portal/Corporate/Health Dept - Hosp Area 05052010.xls');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(92, 'TWAH Floor Plan', '/Intranet/Portal/Corporate/Proforma for TWAH 2010.xls');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(93, 'Doctor''s Consultation Charges - Outpatient', '\\hkim\im\Patients Accounts\Staff share\PBO\Hospital Clinic-Hours and Charges\OPD Dr Fee charges Range table', 'N', 'N', 'OPD - OPD Dr''s Fee Range.ppt');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(94, 'Package charges - HKAH', '/Intranet/Portal/Fees/Package charges - HKAH.xls');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(95, 'Packages charge - TWAH', '/Intranet/Portal/Fees/Packages charge- TWAH.xls');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(98, 'Donation Funds & Expenses Analysis', '\\hkim\im\Develop\Donation - Cherry\Donation Analysis\For Rachel\Foundation - Donation Funds & Expenses Analysis.xls', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(99, 'OPD Schedule Checklist Current Year', '\\hkim\im\Patients Accounts\Staff share\Registration\Set up Dr & clinic check list\Set up for $CURRENT_YEAR\Others ($CURRENT_YEAR) - Set Up Doctor & Clinic Schedule Check List', 'N', 'N', '.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(100, 'OPD Schedule Checklist Previous Year', '\\hkim\im\Patients Accounts\Staff share\Registration\Set up Dr & clinic check list\Set up for $PREVIOUS_YEAR\Others ($PREVIOUS_YEAR) - Set Up Doctor & Clinic Schedule Check List', 'N', 'N', '.doc');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(101, 'Patient Satisfaction Survey (with patients�� comments)', '\\hkim\im\Intranet\Dept\PI\Report\Pat Satis Survey', 'N', 'N', 'Pat Satis Survey ', '.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(102, 'Patient Satisfaction survey (quantitative data)', '\\hkim\im\Intranet\Dept\PI\Report\Pat Satis Survey', 'N', 'N', 'Pat Satis Survey ', '.xls');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(103, 'Year End Summary for PSS', '\\hkim\im\Intranet\Dept\PI\Report\Pat Satis Survey', 'N', 'N', 'Year End Summary for PSS ', '.xls');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(131, 'Pulse', '\Intranet\Portal\Newsletter\Pulse', 'N', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(132, 'Staff Newsletter', '\\hkim\im\Intranet\HR\Newsletter\Staff Newsletter', 'N', 'N', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(133, 'Staff Lunch Forum �V News and Issues', '\\hkim\im\Intranet\HR\Newsletter\Staff Lunch Forum', 'N', 'N', '.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(134, 'Phone Directory', '\\hkim\im\Common\PhoneDir\', 'N', 'N', 'Phone Directory.pdf');

-- senior management
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(201, 'Committee Minutes 2009', '\\hkim\im\Ad Council\2009\HKAH AC Minutes 2009', 'N', 'N', 'HKAH AC Minutes', '.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX) VALUES(202, 'Committee Minutes 2010', '\\hkim\im\Ad Council\AC Minutes 2010', 'N', 'N', 'HKAH AC Minutes', '.doc');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(211, 'TWAH - presentation', '\Intranet\Portal\Corporate\LR - TWAH - presentation5.3 - 070401.ppt');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(212, 'TWAH Strategic Plan', '\Intranet\Portal\Corporate\TWAH Strategic Plan FINAL3.doc');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(221, 'HKAH Strategic Plan - executive summary', '\Intranet\Portal\Corporate\HKAH Strategic Plan - executive summary- 071230final2.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(222, 'HKAH Strategic Plan - Chapter 1  - Seven Strategic Elements', '\Intranet\Portal\Corporate\HKAH Strategic Plan - Chapter 1  - Seven Strategic Elements - Final2- 071231.doc');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(224, 'HKAH Strategic Plan - Chapter 3 - Implementation Plan', '\Intranet\Portal\Corporate\HKAH Strategic Plan - Chapter 3 - Implementation Plan Final - 071231rachel.doc');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(234, 'Long Range Strategic Planning Committee Minutes for Dec 15, 2009', '\Intranet\Portal\Corporate\Long Range Strategic Planning Committee Minutes for Dec 15, 2009.2.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(235, 'Long Range Strategic Planning Committee Minutes for June 4, 2009', '\Intranet\Portal\Corporate\Long Range Strategic Planning Committee Minutes for June 4, 2009.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(236, 'LongYear-end Summary Report of Incident 2009', '\Intranet\Portal\Corporate\Year-end Summary Report of Incident 2009 (final).xls');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(238, 'Accreditation', '\\hkim\im\Intranet\Dept\PI\Accreditation', 'N', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(244, 'HKAH Business & Operation Plan', '\\hkim\im\Market\2010\Board\HKAH Business & Operation Plan (2010).pdf', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(245, 'HKAH Long Range Strategic Plan', '\\hkim\im\Market\2010\Board\HKAH Long Range Strategic Plan (2010).pdf', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(246, 'HKAH Medical Program & Marketing Plan', '\\hkim\im\Market\2010\Board\HKAH Medical Program & Marketing Plan (2009-2010).pdf', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(247, 'HKAH Operation Report', '\\hkim\im\Market\2010\Board\HKAH Operation Report (2009).pdf', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(250, 'Crisis Management Committee', '\\hkim\im\Common\Swine flu\Crisis Management Committee', 'N', 'N', '.doc');

-- Department Information
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(257, 'Bio-Medical Engineering', '\\hkim\im\Intranet\Dept\BME\Content for BME.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(258, 'Dental', '\\hkim\im\Intranet\Dept\Dental\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(259, 'Diagnostic Imaging', '\\hkim\im\Intranet\Dept\Diagnostic Imaging\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(260, 'Facility Management Service', '\\hkim\im\Intranet\Dept\FacilityMS\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(261, 'Food Services', '\\hkim\im\Intranet\Dept\FoodServices\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(262, 'Housekeeping', '\\hkim\im\Intranet\Dept\Housekeeping\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(263, 'Information Management', '\\hkim\im\Intranet\Dept\InformationManagement\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(264, 'Infection Control', '\\hkim\im\Intranet\Dept\Infection Control\Content for Infection Control.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(265, 'Laboratory', '\\hkim\im\Intranet\Dept\Laboratory\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(266, 'Materials Management', '\\necftserver\Public\Materials Management\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(267, 'CCIC', '\\hkim\im\Intranet\Dept\Nursing\CCIC\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(268, 'CSR', '\\hkim\im\Intranet\Dept\Nursing\CSR\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(269, 'General Nursing', '\\hkim\im\Intranet\Dept\Nursing\General nursing\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(270, 'HEMO', '\\hkim\im\Intranet\Dept\Nursing\Hemo\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(271, 'ICU', '\\hkim\im\Intranet\Dept\Nursing\ICU\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(272, 'Nusing Administration', '\\hkim\im\Intranet\Dept\Nursing\Nursing Administration\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(273, 'OB', '\\hkim\im\Intranet\Dept\Nursing\OB\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(274, 'OPD', '\\hkim\im\Intranet\Dept\Nursing\OPD\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(275, 'OT', '\\hkim\im\Intranet\Dept\Nursing\OT\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(276, 'Pediatric', '\\hkim\im\Intranet\Dept\Nursing\Pediatric\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(277, 'OSH', '\\hkim\im\Intranet\Dept\OSH\Content for OSH.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(278, 'Performance Improvement', '\\hkim\im\Intranet\Dept\PI\Content for PI.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(279, 'Pharmacy', '\\hkim\im\Intranet\Dept\Pharmacy\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(280, 'Physician Service', '\\hkim\im\Intranet\Physician\main\intranet.html', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(281, 'Rehabilitation', '\\hkim\im\Intranet\Dept\Rehabilitation\index.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(282, 'Staff Education', '\\hkim\im\Intranet\Dept\Staff Education\Content for Staff Education.doc', 'N');

-- Reference library
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(283, 'Brand Promise', '\\hkim\im\Intranet\Library\General\Brand Promise.ppt', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(284, 'Disaster Manual', '\\hkim\im\Intranet\Library\General\Disaster Manual 261008.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(285, 'Doctor Emergency Backup', '\\hkim\im\Intranet\Library\General\doctor_emergency\emergencyBackup.xls', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(286, 'Organization Chart', '\\hkim\im\Intranet\Admin\Org Chart HKAH.pdf', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(287, 'Phone Directory', '\\hkim\im\Intranet\Library\General\phoneDir\content.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(288, 'Committe Minutes', '\\hkim\im\Intranet\Library\AuthenticPersonnel\ContentforCommitteeMinutes.doc', 'N');
--INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(289, 'Statistical Reports', '\\hkim\im\Common\Statistics\Statistical_Report_table_of_content_merge.xls', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER) VALUES(290, 'Physician Service', '\\hkim\im\Intranet\Physician\main\intranet.html', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(294, 'Ordinance - 100511.working', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Ordinance - 100511.working.xls', 'N', 'N');

-- Corporate (Direction & Plans of HKAH)
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(295, 'HKAH Discussion on Strength', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1010 - 1040\1-HKAH Discussion on Strength.ppt', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(296, 'HKAH Discussion on Weakness', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1010 - 1040\2-HKAH Discussion on Weakness.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(297, 'HKAH Discussion on Opportunity', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1010 - 1040\3-HKAH Discussion on Opportunity.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(298, 'HKAH Discussion on Threats', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1010 - 1040\4-HKAH Discussion on Threats.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(299, 'HKAH Discussion on IT, Facilities', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1205 - 1235\1-HKAH Discussion on IT, Facility & Technology.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(300, 'HKAH Discussion on Customer Service', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1205 - 1235\2-HKAH Discussion on Customer Service.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(301, 'HKAH Discussion on Brand', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1205 - 1235\3-HKAH Discussion on Brand.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(302, 'HKAH Discussion on Human Resource', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1205 - 1235\4-HKAH Discussion on Human Resources.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(303, 'Power point presented by Dr. Ken Tsang<br />Sharing of Developments at Neighboring Private Hospital', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\HKAH Sharing by Dr Kenneth Tsang.ppt', 'N', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(304, 'TWAH Discussion on Strength', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1520 - 1600\1-TWAH Discussion on Strength.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(305, 'TWAH Discussion on Weakness', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1520 - 1600\2-TWAH Discussion on Weakness.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(306, 'TWAH Discussion on Opportunity', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1520 - 1600\3-TWAH Discussion on Opportunity.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(307, 'TWAH Discussion on Threats', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\Schedule 1520 - 1600\4-TWAH Discussion on Threat.doc', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(308, 'Power point presented by Dr. Peter Lo<br />Sharing of Developments at Neighboring Private Hospital', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\TWAH Sharing by Dr Peter Lo.ppt', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(309, 'Power point presented by Dr. Chan Lung Wai<br />Sharing of Developments at Neighboring Private Hospital', '\\hkim\im\1 HKAH Physician\AHHK Long Range Planning Strategic Committee - discussion result 100527\TWAH Sharing by Dr Chan Lung Wai.ppt', 'N', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(310, 'HKAH Operation Report (1Q 2010)', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\2010 Business Plan\HKAH Operation Report (1Q 2010).pdf', 'N', 'N');

-- Chaplaincy (policy and resources)
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(311, 'Multi-Faith Group for Healthcare Chaplaincy Resources', '\\hkim\im\Intranet\Dept\Chaplaincy\Multi-Faith Group for Healthcare Chaplaincy Resources', 'N', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(312, 'Chaplaincy and Privacy of Information Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Chaplaincy and Privacy of Information Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(313, 'Chaplaincy Role and Scope of Service', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Chaplaincy Role and Scope of Service.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(314, 'Chaplaincy Services to Employees Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Chaplaincy Services to Employees Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(315, 'Chaplaincy Services to Family and Friends Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Chaplaincy Services to Family and Friends Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(316, 'Chaplaincy Services to Staff Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Chaplaincy Services to Staff Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(317, 'Chaplains Duties', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Chaplains Duties.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(318, 'Chaplains Ethics and Practice Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Chaplains Ethics and Practice Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(319, 'Cultural Diversity Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Cultural Diversity Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(320, 'HKAH Chaplaincy Services - 2010', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\HKAH Chaplaincy Services - 2010.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(321, 'Participation in the Care Process Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Participation in the Care Process Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(322, 'Sabbath Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Sabbath Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(323, 'Spiritual Minutes for Administration Retreat edited', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Spiritual Minutes for Administration Retreat edited.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(324, 'Visitation Infection Control Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Visitation Infection Control Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(325, 'Visitation of Faith Community Leaders Policy', '\\hkim\im\Intranet\Dept\Chaplaincy\Policy\Visitation of Faith Community Leaders Policy.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(326, 'Meetings for MPA', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Meetings for MPA.xls', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(327, 'CE Hours', '\\hkim\im\HR\CEBudget', 'N', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION) VALUES(332, 'Credential Tracking System(CTS) renewal letter', '/upload/CTS/Form/CTS renewal letter.doc');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(333, 'Emergency Dental Services', '\\hkim\im\Dental\Roster for Emergency Dental Services', 'N', 'N', '.xls');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(334, 'Layman CPR notes for Attendees (HCA)', '/Intranet/Portal/Documents/334/2010 Layman CPR _Chinese_ Pre-read Notes.doc.pdf', 'Y', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(335, 'Lecture Powerpoint', '\\www-server\document\Intranet\Portal\Staff Education\PowerPoint', 'N', 'N', '.ppt');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(292, 'New Contracts Current Year', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Contract\New Contracts\$CURRENT_YEAR', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(293, 'Renewed Contracts Current Year', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Contract\Renewed Contracts\$CURRENT_YEAR', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(349, 'New Contracts Previous Year', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Contract\New Contracts\$PREVIOUS_YEAR', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(350, 'Renewed Contracts Previous Year', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Contract\Renewed Contracts\$PREVIOUS_YEAR', 'N', 'N');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(351, 'Billing Agreement Minutes', '/Intranet/Portal/Billing Agreement', 'Y', 'N');

INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(361, 'OPD Privilege Doctors', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Contract\Existing Contracts', 'N', 'N');

----------------------------------------------------------
-- update document links (requested by eve.lee in 2010-06-23)
----------------------------------------------------------
-- informed consent
UPDATE CO_DOCUMENT SET CO_LOCATION = '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Informed Consent\Consent Forms' WHERE CO_DOCUMENT_ID = 73;
UPDATE CO_DOCUMENT SET CO_LOCATION = '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Informed Consent\Fact Sheets' WHERE CO_DOCUMENT_ID = 71;

-- physician
UPDATE CO_DOCUMENT SET CO_LOCATION = '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Other Information\Index.xls' WHERE CO_DOCUMENT_ID = 78;
UPDATE CO_DOCUMENT SET CO_LOCATION = '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Other Information\Physician Date of Birth.xls', CO_DESCRIPTION = 'Physician Date of Birth' WHERE CO_DOCUMENT_ID = 79;
UPDATE CO_DOCUMENT SET CO_LOCATION = '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Other Information\List of Physicians with contracts.xls' WHERE CO_DOCUMENT_ID = 291;

-- roster
UPDATE CO_DOCUMENT SET CO_LOCATION = '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Emergency Back Up', CO_FILE_PREFIX = NULL, CO_FILE_SUFFIX = '.xls' WHERE CO_DOCUMENT_ID = 40;

--corporate minutes
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(336, 'Administrative Council', '\\hkim\im\Ad Council', 'N', 'N', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(337, 'Joint Conference Committee', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Joint Conference Minutes\2009', 'N', 'N', '.pdf');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(338, 'Medical / Dental Executive Committee', '\\hkim\im\1 HKAH Physician\2 Intranet Portal\Medical-Dental Executive Committee Minutes', 'N', 'N','.pdf');
--disaster plan
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(339, 'Department Disaster Plan', '\\www-server\document\Intranet\Portal\Departmental Disaster Plan', 'N', 'N','.doc');

--staff education
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME, CO_FILE_SUFFIX) VALUES(352, 'Compulsory & Nursing Orientation', '/Intranet/Portal/Staff Education/Compulsory Class/Compulsory & Nursing Orientation', 'N', 'N','.pdf');

-- PEM
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(408, 'PEM accountability tool - HK', '\\www-server\PEM\PEM accountability tool - HK.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(409, 'PEM accountability tool - TW', '\\192.168.0.20\PEM\PEM accountability tool - TW.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(410, 'PEM accountability tool - HK (Read Only)', '\\www-server\PEM\PEM accountability tool - HK.doc', 'N', 'Y');
INSERT INTO CO_DOCUMENT(CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, CO_LOCATION_WITH_FILENAME) VALUES(411, 'PEM accountability tool - TW (Read Only)', '\\192.168.0.20\PEM\PEM accountability tool - TW.doc', 'N', 'Y');