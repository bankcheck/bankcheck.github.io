DROP TABLE ARCARDTERM;
CREATE TABLE ARCARDTERM 
(
	"CARDID" 				VARCHAR2(20 BYTE) NOT NULL,
	"TYPE"					VARCHAR2(3 BYTE),
	"CONTACT_DETAILS"		VARCHAR2(255 BYTE),
	"CONTACT_PHONE"			VARCHAR2(255 BYTE),
	"FAX"					VARCHAR2(20 BYTE),
	"OFC_HOUR"				VARCHAR2(50 BYTE),
	"TIME_LIMIT"			VARCHAR2(25 BYTE),
	"LIMIT"					NUMBER(8),
	"PRE_AUTHOURISE"		NUMBER(1),
	"GUARANTEE"				NUMBER(1),
	"ACKNOWLEDGE"			NUMBER(1),
	"NAME_LIST"				VARCHAR2(500 BYTE),
	"EXCLUSION"				VARCHAR2(500 BYTE),
	"VOUCHER"				VARCHAR2(500 BYTE),
	"TERMS"					VARCHAR2(500 BYTE),
	"ALERT"					VARCHAR2(2000 BYTE),
	"REMARKS"				VARCHAR2(2000 BYTE),
	"LASTDATE"				DATE DEFAULT SYSDATE,
	"LASTMODIFY"			VARCHAR2(20 BYTE),
	"PRE_AUTHORISE_FORM" 	VARCHAR2(500 BYTE),
	"CLAIM_FORM"			VARCHAR2(500 BYTE),
	"ACKNOWLEDGE_FORM"		VARCHAR2(500 BYTE),
	"PRE_AUTHORISATION"		NUMBER(1),
	"PRE_AUTHORISATION_MEMO"	VARCHAR2(500 BYTE),
	"ACTID"					NUMBER(22),
	"CONTACT_EMAIL"			VARCHAR2(100),
	"EXCLUSIONREMARKS"		VARCHAR2(2000),
	"BILLREMARKS"			VARCHAR2(2000),
	"POLICYSAMPLE"			VARCHAR2(500)	
);
/




SET DEFINE OFF

INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AAIHK', 'Out', 'Tel: 	(852) 3723 3000
Fax: (852) 3529 1027 - Operations Dept
Operation Team: 
ops@aa-international.com.hk
Ms. Anna Yue (Operation Manager)
annayue@aa-international.com.hk', ' 	(852) 3723 3000', ' (852) 3723 3010', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Assistance Alliance Int''l (HK) Ltd\LOG sample.pdf', '', '', '', '', 'Correspondence address:
Suite 702, 101 King''s Road, North Point, HK  
Attn: Operations Department', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AAIHK', 'In', 'Tel: 	(852) 3723 3000
Fax: (852) 3529 1027 - Operations Dept
Operation Team: 
ops@aa-international.com.hk
Ms. Anna Yue (Operation Manager)
annayue@aa-international.com.hk', ' 	(852) 3723 3000', ' (852) 3723 3010 HO', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Assistance Alliance Int''l (HK) Ltd\LOG sample.pdf', '', '', '', '', 'Correspondence address:
Suite 702, 101 King''s Road, North Point, HK  
Attn: Operations Department', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ABC1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ABC1', 'In', 'Mandy Lee', '2598-5382', '', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Insurance\General Exclusions - sample.pdf', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ABC2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ABC2', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'do not accept', 'H:\Insurance\General Exclusions - sample.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AC', 'In', '24/7 Tel: +86 400 120 4955 / +86 400 120 3304
assistance.asia@assistcard.com

Billing Issues:
head of financial team Gustavo Scayola gustavo.scayola@assistcard.com
Karina Andino karina.andino@assistcard.com', 'Tel: +86 400 120 4955', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assist Card\GUARANTEE OF PAYMENT for China.pdf', '', '', '', '- Sign Assist card consent form (refer to "Claim Form" column)
- for billing: Discharge summary & medication breakdown are required.', '- re-active direct billing service 10-Nov-2014rita 
- E-billing changed to :    billing.asia@assistcard.com AND
assistance.asia@assistcard.com
- original bill can be posted to Shanghai office upon ACSC request.
  Address: Suite 4611B-4613, Tower II, P', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assist Card\Consent Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AC', 'Out', '24/7 Tel: +86 400 120 4955 / +86 400 120 3304
assistance.asia@assistcard.com

Billing Issues:
head of financial team Gustavo Scayola gustavo.scayola@assistcard.com
Karina Andino karina.andino@assistcard.com', '+86 400 120 4955', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assist Card\GUARANTEE OF PAYMENT for China.pdf', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assist Card\Medical Report.pdf', '', '- Sign Assist card consent form (refer to "Claim Form" column)
- for billing: Discharge summary & medication breakdown are required.', '- re-active direct billing service 10-Nov-2014rita
- E-billing changed to :   billing.asia@assistcard.com AND
assistance.asia@assistcard.com
- original bill can be posted to Shanghai office upon ACSC request.
  Address: Suite 4611B-4613, Tower II, Pla', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assist Card\Consent Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ACC', 'In', '', '61-2930-1100', '61-2930-1130', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', 'OCCASIONAL CASE
Refer to Manager for any new case
Letter of Guarantee to be approved by Manager', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ACC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ACEI', 'In', '', '65-6535-5833', '65-6535-5052', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ACEI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ACEI2', 'Out', 'PRESTIGE : 28680612
PRESTIGE Ms. Kau : 25215592
EAJ Toll Free: 800-963010 (Singapore)
EAJ Tel: +81-3-3811-8301
EAJ Fax: +81-3-3811-8156
EAJ E-mail: claims@emergency.co.jp', '', 'PRESTIGE : 2801 4062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- outpatient case : handle by PIHK and use PIHK insurance claim form (2-pages).
- DO NOT ACCEPT if the ACE policy with AMEX credit card number on it.
- inpatient case : Confirmed with PIHK-Ms. Kau, handle by EAJ.
- If EAJ guarantee, please ask EAJ to f', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\PIHK.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ACEI2', 'In', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '- outpatient case : handle by PIHK
- inpatient case : Confirmed with PIHK-Ms. Kau, handle by EAJ.
- please ask EAJ to fax us the ACE Insurance claim form.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\ACE Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ACEI3', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- outpatient case : handle by PIHK
- NOT Cover the following (refer to exclusion comparison table) :
Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive vaccine.
- DO NOT ACCEPT if the ACE policy with AMEX credit card numb', 'Accept ACE policy for outpatient ONLY:
 1. Policy / Certificate / Card in White paper sheet
 2. Sickness / Accident Coverage in JAPANESE Yen (Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provide', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form OTAI 20130326.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ACEI3', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- inpatient case :  handle by EAJ. (Confirmed with PIHK-Ms. Kau)
- please ask EAJ to fax us the ACE Insurance claim form.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AET', 'In', 'Mr. Hugh Hurlbut
1-813-775-0105 HurlbutH@aetna.com', '1-813-775-0190(collect)
1-800-231-7729', '1-860-975-0610', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', '', 'Clients are members and dependents of Pacific No.1 & No.2 Schemes and Mediplan scheme', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AET', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIA1', 'In', '', '2881-3496', '2894-9813', '', 'No Limit', 100000.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\AIA_American Intl Assurance\American Int''l Assurance.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Light Blue Card\Voucher.pdf', '', 'EXCEPT "Maternity" coverge, Need to check with insurance to confirm coverage for each policy', '1. Accept either Card or LOG. 
2. Medical card guarantee limit up to HK$100K
3. For Morgan Stanley policyholder, guarantee limit up to HK$200K including Maternity. Cover for 1st 7 days of Baby. (Cert No. start with 0000015604, 0000017443 & 0000017447)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Light Blue Card\Claim Form 20110513.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIA1', 'Out', '', 'Customer Service Hotline 28813514', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Light Blue Card\Voucher.pdf', '', '- Check card expiry date
- Card embossed with wordings HOSP-YES
- Card embossed with "NIL" (NIL=no coverage)', '- AIA Confirmed - no need to ask patient to pay the exclusions shown at the back of the AIA Card.
- Pre-natal/Post-natal Treatment maybe covered depending on card holder''s coverage. Check with AIA if necessary.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIA2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIA2', 'In', 'Hotline: 2232 8870
Mon-Fri 0845-1900 (except PH)', '2881 3333', '', '', '', 100000.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\AIA\Individual policy\LOG Sample.pdf', '', '', '', '1. Cover up to HK$100,000.  For exceeding, pls contact AIA to check will they revise LOG.  If during non-office hours, patient have to self-pay the exceeded portion.
2. Room type pls refer to LOG.  If patient requests upgrade, patient shall pay the diffe', '1. Claims submission - separate from exisitng corporate members
(Send to 11/F, AIA Financial Centre.  Refer to LOG)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Individual policy\Claim Form 20140505.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIA3', 'In', '', '', '', '', '', 0.0, -1.0, 0.0, 0.0, '', '', '', '', 'do not accept', '- promotion package price for :  xxxxx (date - date)
- Inpatient only', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIA3', 'Out', '', '', '', '', '', 0.0, -1.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\AIA\Light Purple Card (Super Good Health Network Card) (Sept 2014)\Light Purple Card - Super Good Health Network Card (Sept 2014).bmp', '', '', '', 'do not accept', '- promotion package price for :  xxxxx (date - date), Inpatient only
- For outpatient appointmment & Pre-Authorization for admission, please refer workflow H:\.......', to_date(''), '', '', '', '', -1.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIA4', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\AIA\Light Green Card (Network Surgery Card_self pay)\Light Green card (Network Surgery Card_self pay) Sept 2014.bmp', '', '', '', 'do not accept', '- promotion package price for :  xxxxx (date - date)
- for Inpatient only', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIA4', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'do not accept', '- promotion package price for :  xxxxx (date - date)
- self pay
- please pass the claim form to patient
- refer workflow H:\................', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIAHS1', 'In', 'Service Hotline
T: 2200 6388', '2200-6388', '2219-7830', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Gold Card\Voucher.pdf', '', '', 'LOG is required.  If no specific amount states on LOG, we assume only cover $100,000.  If excceed, ask further LOG.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Gold Card\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIAHS1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIAHS2', 'In', 'Network Service Hotline: 2200 6388', '2200 6388 (Hotline)', '2219 7830', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Gold Card\Voucher.pdf', '', 'DO NOT accept: HOSP INPAT NIL = No credit facility for inpatient.
Accept Card:
1. Card without any printing is eligible for In-patient, Outpatient and Maternity Services.
2. HOSP INPAT YES = Credit facility for inpatient services. 
3. HOSP MAT YES = C', '- card without expiry date but shows ''Member Since''
- For identification to perform IVRS eligibility check at 2200 6388
- To get Authorization over the phone: IVRS Code 25746
- Total expenses >100,000HKD, seek further approval via Hotline. (verbal conf', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Gold Card\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIAHS2', 'Out', 'Network Service Hotline: 2200 6388', '2200 6388 (Hotline)', '2219 7830', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Gold Card\Voucher.pdf', '', 'Accept card :
HOSP OPD YES = Credit facility for outpatient services at hospital is provided.
HOSP MAT YES = Credit facility for maternity services at hospital is provided for both outpatient & inpatient services.
DO NOT ACCEPT :
HOSP OPD NIL = Credit', '- card without expiry date but shows ''Member Since''
- NO NEED to collect Co-payment from patient for out-patient.
- NO NEED to get "Transaction Code" on voucher.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIAHS3', 'Out', 'Network Service Hotline: 2200 6388', '2200 6388 (Hotline)', '2219 7830', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Gold Card\Voucher.pdf', '', 'Only accept Card shows: < HOSP OPD NIL, HOSP INPAT YES >
DO NOT ACCEPT if card shows <HOSP OPD NIL, HOSP INPAT NIL>
Only cover MRI, CT, PET Scan.  NOT cover any outpatient consultation, x-ray, U/S etc.', '- Perform IVRS eligibility check at 2200 6388, Hospital code is 25746
- mark Authorization Code on voucher.
- No need to collect co-payment.
- Total expenses >100,000HKD, seek further approval via Hotline. (verbal confirm acceptable)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIAHS3', 'In', 'Network Service Hotline: 2200 6388', '2200 6388 (Hotline)', '2219 7830', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Gold Card\Voucher.pdf', '', '- For identification to perform IVRS eligibility check at 2200 6388
- To get Authorization over the phone: IVRS Code 25746
DO NOT accept: HOSP INPAT NIL = No credit facility for inpatient.
Accept Card:  HOSP INPAT YES  = Credit facility for inpatient s', '- Claim form (Green colour) and Claim voucher (with Authorize code) are needed
- Authorization IVRS Code for admission is required.
- Total expenses >100,000HKD, seek further approval via Hotline. (verbal confirm)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\Gold Card\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIAHS4', 'Out', 'Network Service Hotline: 2200 6388', '2200 6388 (Hotline)', '2219 7830', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\New Gold Card (with expriy date from 1 Apr 2014)\Voucher.pdf', '', '- check card expiry date
- Accept Card:  "HOSPYES: OPD, INPAT, MAT"  (i.e. Cover out-pt, in-pt & maternity)', '- Perform IVRS eligibility check at 2200 6388, Hospital code is 25746
- mark Authorization Code on voucher.
- IVRS eligibility check ONLY for outpatient surgical procedure, MRI, CT, PET scan.
- Total expenses >100,000HKD, seek further approval via Hotl', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIAHS4', 'In', 'Network Service Hotline: 2200 6388', '2200 6388 (Hotline)', '2219 7830', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\New Gold Card (with expriy date from 1 Apr 2014)\Voucher.pdf', '', '- check card expiry date
- Accept Card:  HOSPYES:OPD,INPAT,MAT (i.e. Cover outpt, inpt & maternity)', '- For identification to perform IVRS eligibility check at 2200 6388
- To get Authorization over the phone: IVRS Code 25746
- Total expenses >100,000HKD, seek further approval via Hotline. (verbal confirm)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIA\New Gold Card (with expriy date from 1 Apr 2014)\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIG', 'In', 'For inquiry: 
Ms Carolyn Wing-Kam Lam, LAU 
Tel:2832-1957 Fax:2834-8962
Or 
Ms Peggy Lai-Kit, Au 
Tel:2832-6573 Fax:28348962', '2832-6573
2832-1956', '', '', 'No Limit', 100000.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIG', 'Out', '', '', '', '', '', NULL, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIGJAP', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIGJAP', 'Out', '2832 1880 (check coverage),
2832 1956 (customer service hotline)', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\AIU.jpg', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIGJAP2', 'Out', '2832 1880 (check coverage),
2832 1956 (customer service hotline)', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\AIU.jpg', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIGJAP2', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIGJAP3', 'Out', '2832 1880 (check coverage),
2832 1956 (customer service hotline)', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\AIU.jpg', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIGJAP3', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIOI', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- NOT Cover the following refer to exclusion comparison table):
Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive vaccine.
Accept Policy / Certificate / Card :
 - Policy / Certificate in Paper sheet
 - Coverage in Japan', '- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.
- Forenamed: AIOI (AIOI merged with NISSAY DOWA) (effecitve 1-Oct-2010)

- DO NOT Accept Policy', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form OTAI 20130326.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIOI', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limited to Standard class', '- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.
Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co L', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form OTAI 20130326.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form - standard room.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIOI-1', 'In', 'Emergency Alarm Centre (Shanghai): +86-21-6440-1243 (japanese/mandarin).
hongkong@wellbemedic.com
JOJO@WELLBEMEDIC.COM', 'Mon-Fri : 2573 3667
JoJo Cheung', '28345206', '', '', 0.0, 0.0, -1.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\wellbe exclusion.doc', '', '', 'DO NOT ACCEPT', 'Pls refer to Prestige (AR: PIHK)  (as per telcon w/Jojo on 28/1/2014) NH

- 2 patient''s signatures are required on the 3-pages-set claim form.
- Entitle for Semi-Private room.
- If patient requests private or higher class, please show patient Well Be''', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Voucher - IPD\Well Be (HK) Ltd - claim form (mar 2010).doc', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\WellBe.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIOI-1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'Outpatient cases, please refer to PIHK.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIU', 'IN', 'AIU Assistance Center (24/7)
Tel: (81) 98-941 2212
Fax: (81) 98-863 9164
Email: jp.assistance@travelguard.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIU\Policy Card or Cert sample.pdf', '', '', '', 'Copy Insurance card/Cert & passport with page of last departure date from Japan.', 'AIU Insurance Company Ltd - Japan Head Office 
- Only Accept policy card/cert in Japanese Yen Dollar and with AIU logo.
- LOG is required.  Sample:
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIU\AIU IN-PATIENT GOP.pd', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIU\AIU Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIU', 'Out', 'AIU Assistance Center (24/7)
Tel: (81) 98-941 2212
Fax: (81) 98-863 9164
Email: jp.assistance@travelguard.com', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIU\Policy Card or Cert sample.pdf', '', '', '', '- Copy Insurance card/Cert & passport with page of last departure date from Japan
- NOT Cover 180 days.', 'AIU Insurance Company Ltd - Japan Head Office 
- Only Accept policy card/cert in Japanese Yen Dollar and AIU logo.
- With "SICKNESS MED, ACCIDENT MED"  OR "MED. & RES. EXP" expense covers.
- Check policy valid date.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AIU\AIU Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIUJAP', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIUJAP', 'Out', '2832 1880 (check coverage)
2832 1956 (customer service hotline)', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\AIU.jpg', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIUJAP2', 'Out', '2832 1880 (check coverage)
2832 1956 (customer service hotline)', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:Patient Account\Insurance Card Program\Voucher - OPD\AIU.jpg', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIUJAP2', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIUJAP3', 'Out', '2832 1880 (check coverage)
2832 1956 (customer service hotline)', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\AIU.jpg', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AIUJAP3', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Agreement terminated in 2008.  DO NOT Accept Policy / Certificate / Card.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AJIN', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AJIN', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '', '- Accept card in yellow color with Prestige logo
- covered / non-covered item, refer to exclusion comparison table', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ALA', 'In', 'Email:alacarte@allianzworldwidecare.com', '353-1629-7140', '353-1630-1306', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '', '', '', '', '', 'Acknowledge Admission needed if there is no Pre-Authorisation.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ALA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do not accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ALC', 'In', 'By email: InternationalProviderServices@aetna.com
By Phone: Toll-free number printed on the member card', 'Tel: 1-800-231-7729', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Aetna\Card Procedure (HK)2015_insurance programme.doc', '', '', '', '- 29 March 2010, to accept Aetna''s VOB.', '- Card policy no. starts with: Wxxxxx.  Card shows Aetna logo and "Aetna Global Benefits" or "Aetna International"
- Fax bill to 1-860-975-0610 separately, not group invoices. (no need to mail bill)', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Aetna\Pre-certification Medical form.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ALC', 'Out', 'Email: InternationalProviderServices@aetna.com
or call Toll free number on the card', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '1. Member must present card + LOA.  Otherwise, he/she is required to self-pay.', '1. Card must shows Aetna logo and "Aetna International" 
2. Member ID number starts with a "W", no expiry date
3. Collect excess, deductible if any.
4. Accept e-billing: InternationalProviderServices@aetna.com  OR upload by Provider Portal.', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Aetna\Pre-certification Medical form.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AMA', 'In', 'opschina@asiamedassist.org
Tel: +91 (124) 4688444  (24/7)
Fax: +91 (124) 4014728  (24/7)', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Asia Medical Assistance Co. Ltd\GOP sample.pdf', '', '', '', '1. Pls copy passport for billing purpose.
2. If expenses exceed LOG coverage, may try to ask further guarantee.', '1. Billing should send by email AND by post. (pls refer to LOG)
2. No claim form is needed.
3. No medical report is needed even it is stated in the email/LOG', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AMA', 'Out', 'opschina@asiamedassist.org
Tel: +91 (124) 4688444  (24/7)
Fax: +91 (124) 4014728  (24/7)', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Asia Medical Assistance Co. Ltd\GOP sample.pdf', '', '', '', '1. Pls copy passport for billing purpose.
2. If expenses exceed LOG coverage, may try to ask further guarantee.', '1. Billing should send by email AND by post. (pls refer to LOG)
2. No claim form is needed. 
3. No medical report is needed even it is stated in the email/LOG.
4. Sign HKAH consent', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AMCG', 'In', 'Health Unit :', 'Health Unit: 28412309', 'Health Unit:25240798', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'For UC Contact during non-office hours:
Rena Brescia, FSHP:9023-4945
Dr Anvid Carlson, MD:9196-1953
Sharon Tang, RN: 9460-0602
Elaine Johnsen, RN:9819-9676
Joey Yeung (Med Sec):6531-6368', 'Covered for semi-private room only.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AMCG', 'Out', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '- guarantee letter is needed.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AMP', 'In', '', '2542-2882', '2851-9977', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AMP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AOHK', 'In', 'ops-shanghai@assistance-online.com.cn
24 Hrs Hotline: +86 21 6854 1008
Fax: +86 21 6854 1009', '6553 8409 call will diverted to Shanghai 24Hr call center
86-21 61049500', '86-21 61049484', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assistance Online\LOG sample.pdf', '', '', '', '', '86 21 61049500 (number in China) 7/3/leo
Claims Dept: 
Asia OPS Center Shanghai
Zendai Cube Edifice, 6/F, Unit 602
58, Changliu Road, Pudong District, 
Shanghai, 200135  PR of China', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assistance Online\Medical report.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AOHK', 'Out', 'ops-shanghai@assistance-online.com.cn
24 Hrs Hotline: +86 21 6854 1008
Fax: +86 21 6854 1009', '6553 8409 call will diverted to Shanghai 24Hr call center
86-21 61049500', '86-21 61049484', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assistance Online\LOG sample.pdf', '', '', '', '- HKAH consent is required
- Patient shall bring along LOG', 'Claims Dept: 
Asia OPS Center Shanghai
Zendai Cube Edifice, 6/F, Unit 602
58, Changliu Road, Pudong District, 
Shanghai, 200135  PR of China', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Assistance Online\Medical report.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Aon-Heineken', 'Out', 'Munadel Khadr (Senior Analist)
Tel: +31 (0) 10 448 8202
email: munadel.khadr@aonhewitt.com / heinekenexpat@aon.nl', '', '', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Aon Hewitt\Name List.pdf', '', 'H:\Patient Account\Insurance Card Program\Aon Hewitt\DB agreement Aon Hewitt with Hong Kong Adventist Hospital.pdf', '', 'DO NOT ACCEPT', '- only cover for David Tulloch and his family members. (see name list)
- e-billing send to ronald.enderman@aonhewitt.com Tel: +31 (0) 10 448 8238  Fax: +31 (0) 10 448 8724
- cover up to HK$39,000 per case (All outpatient services).  If excess, further g', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Aon-Heineken', 'In', 'Munadel Khadr (Senior Analist)
Tel: +31 (0) 10 448 8202
email: munadel.khadr@aonhewitt.com / heinekenexpat@aon.nl', '', '', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Aon Hewitt\Name List.pdf', '', 'H:\Patient Account\Insurance Card Program\Aon Hewitt\DB agreement Aon Hewitt with Hong Kong Adventist Hospital.pdf', '', 'DO NOT ACCEPT', '- only cover for David Tulloch and his family members. (see name list)
- e-billing send to ronald.enderman@aonhewitt.com Tel: +31 (0) 10 448 8238  Fax: +31 (0) 10 448 8724
-  cover up to HK$39,000 per case.  If excess, further guarantee is required.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AONC', 'In', 'Ms. Ho - 2861-6492
Tel: +852 2861 6666
Fax: +852 2861 6672', '2861-6555', '2243-8573', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', 'Former Named Inchape Insurance Services', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AONC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('APR', 'In', '', '33-2-5445-5664', '33-2-5445-5680', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'OCCASIONAL CASE
Refer to Manager for any new case
Letter of Guarantee to be approved by manager', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('APR', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ARAMCO', 'In', 'Ms. Brenda Law (852) 2588 9338
email: brenda.law@aramco.com
Khalid Al-Znide (852) 2588 9303
email: khalid.znide@aramco.com', '(852) 2802 0100', '(852) 2802 3600', '', '', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\Aramco Overseas Company\Name List as at 24 Jun 2010.pdf', '', 'H:\Patient Account\Insurance Card Program\HKAH consent form.pdf', '', 'DO NOT ACCEPT', '- with effect from 14 June 2011, all admin & claims are handle by Vanbreda.  Please refer to Vanbreda Int''l.

- LOG will remain valid for the duration of member''s employment.  
Sample of LOG  H:\Patient Account\Insurance Card Program\Aramco Overseas Co', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ARAMCO', 'Out', 'Ms. Brenda Law (852) 2588 9338
email: brenda.law@aramco.com
Khalid Al-Znide (852) 2588 9303
email: khalid.znide@aramco.com', '(852) 2802 0100', '(852) 2802 3600', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Aramco Overseas Company\Name List as at 24 Jun 2010.pdf', '', 'H:\Patient Account\Insurance Card Program\HKAH consent form.pdf', '', 'DO NOT ACCEPT', '- with effect from 14 June 2011, all admin & claims are handle by Vanbreda.  Please refer to Vanbreda Int''l.

- HKAH consent form is required for Outpaient case.
- LOG will remain valid for the duration of member''s employment.  
Sample of LOG  H:\Pati', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ASA', 'Out', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '2734 9333', '2735 2256', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Card face\Asahi Fire & Marine card sample.doc', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 'Accept Policy / Certificate / Card if :
 - Policy / Card in paper sheet and OVERSEAS TRAVEL ACCIDENT INSURANCE wordings.
 - Policy / Certificate in Paper sheet
 - Coverage in Japanese Yen Dollar (yen)', 'May cover for pre-existing symptoms if patient obtains a letter from JIA.  Sample attached:
H:\Patient Account\Insurance Card Program\JI Accident\Letter for treatment of pre-existing symptoms.pdf
DO NOT Accept Policy / Certificate / Card if :
 1. Sickn', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ASA', 'In', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '', 'Fax +852 2735-2256', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\Card face\Asahi Fire & Marine card sample.doc', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 'do not accept', '- Outpatient case handled by JIA and use JIA form.
- Inpatient case handled by Wellbe and use Well Be form.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ASH', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ASH', 'In', '', '44-2075574100', '44-2075574141', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'do not accept', '- Bill was paid by T/T however settlement was postponed and they have tried to turn the liability to the company insurance until we have put in a lot of effort.
- Strongly advise not to accept for any hospital services.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ASI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ASI', 'In', 'email: medical@afh.hk', '3606 9346', '2899 2426', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Asia Insurance\Claim Form 20110923.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AUCC', 'Out', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'if the payment method on the guarantee is USD, do not accept and please have it revise to HKD.', 'no agreement, case to be approved case by case.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AUCC', 'In', '', '61-2-9202-8222', '61-2-9202-8220', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'if the payment method on the guarantee is USD, do not accept and please have it revise to HKD.', '- Non-contract: Please refer to supervisor for any new case before waiving deposit for patient.
- Need advance payment by Bank Transfer and Balance settle in 14 days.
- Gtd Fax is needed', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AUCG', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AUCG', 'In', '', '2827-8881', '2585-4457', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AWC', 'Out', 'enquiry: client.services@allianzworldwidecare.com
Submission of treatment guarantee forms only:
medical.services@allianzworldwidecare.com
Claim enquiry:
clinic.claims@allianzworldwidecare.com', '+353 1629-7140
+353 1630-1301
toll free : 800 901 705', '+353 1630-1306', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '', '', '', '', '- Pre-authorization is required.
- Treatment Guarantee Form is required at least 5 days before a planned procedure.  ( refer  http://www.allianzworldwidecare.com/treatment-guarantee  )', 'For exclusions, refer to Letter of Guaranttee
- E-billing at clinic.claims@allianzworldwidecare.com and c c chloe.jiang@allianzhealth.cn', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Allianz Worldwide Care\Claim Form for Non UW Groups EN Nov12.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AWC', 'In', 'enquiry: client.services@allianzworldwidecare.com
LOG: 
medical.services@allianzworldwidecare.com
Claim enquiry:
clinic.claims@allianzworldwidecare.com

submission of treatment guarantee forms only:
medical.services@allianzworldwidecare.com', '+353 1629-7140
+353 1630-1301
toll free : 800 901 705', '+353 1630-1306', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\AWC_AllianzWorldwideInsurance.tif', '', '', '', '- Treatment Guarantee Form is required at least 5 days before a planned procedure.  ( refer  http://www.allianzworldwidecare.com/treatment-guarantee  )
- No Acknowledge Admission needed if Pre-authorisation was obtained.
- E-billing at clinic.claims@all', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Allianz Worldwide Care\Pre-Auth Form.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Allianz Worldwide Care\Claim Form for Non UW Groups EN Nov12.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AXAC1', 'Out', 'CS Hotline: 2519 1166', '2519 1166', '2598 6502', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\AXA China Region\AXAC exclusion.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AXA China Region\Voucher.pdf', '', ' 1. Card embossed with "OPD" wordings 
 2. Card embossed with "PV &/or SP" = Cover Inpatient & All Outpatient - both GP & SP (except maternity)
 3 Card embossed with "CB" = Cover Inpatient & Outpatient maternity (Including both GP & SP)', '-  Check expiry date
-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
-  Do Not pass blank voucher without amount for patient to sign
-  Patient has to countersign the voucher i', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AXAC1', 'In', 'CS Hotline: 2519 1166', '2519 1166', '2598 6502', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\AXAC_ChinaRegionInsurance.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AXA China Region\Voucher.pdf', '', '- Maternity Care is not covered unless "CB" wordings are shown on the card
- Maternity cover for baby only if baby discharges together with mother.', 'Only accept "embossed" card.  Paper card NOT accepted.
with "HOSPITAL" or "Hosp. & CB/PV/SP" wordings
Or
Presentation of Guarantee Letter
-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-1', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AXA China Region\Claim-_Hosp Claim Form-MP_EBC001-1308.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AXAC2', 'Out', 'CS Hotline: 2519 1166', '2519 1166', '2598 6502', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\AXA China Region\AXAC exclusion.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AXA China Region\Voucher.pdf', '', '1. If no "Hospital / Hosp", not entitle for direct billing
2. Card embossed with "Hospital / Hosp" = Inpatient only
3. Card embossed with "Hospital / Hosp + PV &/or SP" = Cover Inpatient & All Outpatient - both GP & SP (except maternity)
4. Card emboss', '-  Check expiry date
-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
-  Do Not pass blank voucher without amount for patient to sign
-  Patient has to countersign the voucher i', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AXAC2', 'In', 'CS Hotline: 2519 1166', '2519 1166', '2598 6502', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\AXAC_ChinaRegionInsurance.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AXA China Region\Voucher.pdf', '', '- Maternity Care is not covered unless "CB" wordings are shown on the card
- Maternity cover for baby only if baby discharges together with mother.', 'Only accept "embossed" card.  Paper card NOT accepted.
with "HOSPITAL" or "Hosp. & CB/PV/SP" wordings
Or
Presentation of Guarantee Letter
-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-1', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AXA China Region\Claim-_Hosp Claim Form-MP_EBC001-1308.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AXAG1', 'In', 'Health Service Team Hotline:
Mon-Fri  0900-1730
Tel: 2867 8686  Fax: 3160 4267
healthcare@axa-insurance.com.hk

After office hour contact UCMG: 
Tel: 3010 0210', '2830 1681 Ms. Alice Mok', '2537-3437', '', 'No Limit', 150000.0, -1.0, -1.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\AXAG_AXAGeneralInsurance.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AXA\HK GI\Voucher.pdf', '', 'Patient may present with Ltr of Gtd and UCMG Approved form as well as Medical Card. (UCMG provides hotline service to AXAG after office hours)', '1. Policy no. e.g: AB123456 12345-67
-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
2. With "AXA General Insurance" at card bottom', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\AXAg.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AXAG1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AXAG2', 'Out', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('AXAG2', 'In', 'Health Service Team Hotline:
Mon-Fri  0900-1730
Tel: 2867 8686  Fax: 3160 4267
healthcare@axa-insurance.com.hk

After office hour contact UCMG: 
Tel: 3010 0210', '2830-1681 Ms. Alice Mok', '2537-3437', '', 'No Limit', 150000.0, -1.0, -1.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\AXAG_AXAGeneralInsurance.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\AXA\HK GI\Voucher.pdf', '', 'Patient may present with Ltr of Gtd and UCMG Approved form as well as Medical Card.  (UCMG provides hotline service to AXAG after office hours)', 'Policy no. e.g: AB123456 12345-67
-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\AXAg.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BANG', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BANG', 'In', '', '2827-4278', '2827-1916', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BATC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BATC', 'In', 'IFC', '2918-2888', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', 'Guarantee Letter is Needed', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BC', 'Out', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- Only accept card face with "Inpatient & Outpatient" wordings & "H" code (see highlighted in Yellow).
- DO NOT accept if card only shows "Outpatient" and without "H" code.
- DO NOT accept if card only with "Hospital" wordings (Hospital = admission)', '- DO NOT pass bank voucher (without amount) for patient to sign
- Patient has to countersign the voucher if the amount has been revised
- Imprint insurnace card clearly on voucher
- Suggest xerox copy the insurance card for billing purpose', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BC', 'In', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', 'No Limit', 100000.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BC_BlueCross.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- Card face printed with "In-paitent & Outpatient" or "Hospital" wordings represents Inpatient credit service & also card printed with "H" code (see highlighted in Yellow)
- or Letter of Guarantee
- check expiry date', '- Not cover Dental & related surgery.
- No credit service for Maternity (25 Feb 2014 NH)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BC1', 'Out', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- Card Embossed with "VIP" wordings
- Check card expiry date.', '1. DO NOT pass blank voucher (without amount) to patient to sign
2. Patient has to countersign the voucher if the amount has been revised', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BC1', 'In', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BC_BlueCross.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- Card Embossed with "VIP" wordings', '- Not cover Dental & related surgery.
- No credit service for Maternity (25 Feb 2014 NH)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BCBS', 'In', '', '2851-0620', '2851 0910', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\IPA\Sample - IPA HK LOG.pdf', '', '', '', 'DO NOT ACCEPT', 'Patient have to self-pay.  Pls collect deposit.
IPA will not issue LOG for Blue Cross Blue Shield.  (Verbal confirmed by Humphrey on 29 Apr 2013 (NH)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BCBS', 'Out', '', '2851-0620', '2851 0910', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'Arrangement for Inpatient only', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BCCPCE', 'Out', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- VIP card embossed with wordings CPCE
- Check card expiry date.', '- DO NOT pass blank voucher ( without amount ) to patient to sign.
- Patient has to countersign the voucher if the amount has been revised', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BCCPCE', 'In', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BC_BlueCross.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- VIP card embossed with wordings CPCE', '- Not cover Dental & related surgery.
- No credit service for Maternity (25 Feb 2014 NH)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BCEOS', 'Out', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- Card embossed with "EC" wordings
- Check card expiry date.', '- DO NOT pass blank voucher without amount for patient to sign
- Patient has to countersign the voucher if the amount has been revised.
- Imprint insurance card clearly on voucher', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BCEOS', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BCPOLY', 'In', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BC_BlueCross.tif', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- VIP card embossed with wordings POLYU', '- Not cover Dental & related surgery.
- No credit service for Maternity (25 Feb 2014 NH)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BCPOLY', 'Out', 'Provider Network''s Hotline: 3608 2798
CS Hotline: 3608 2988
cs@bluecross.com.hk', '3608-2888 / 36082988', '3608-2989 / 36082938', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Blue Cross\Voucher.pdf', '', '- VIP card embossed with wordings POLYU
- Check card expiry date.', '- DO NOT pass blank voucher ( without amount ) to patient to sign.
- Patient has to countersign the voucher if the amount has been revised', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BOC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BOC', 'In', 'Billing -  Ms FUNG Bee Biar
Beebiar_ysfung@bocgroup.com
Admission : Claims Manager- Ms Leung
(852) 2867 0888

Julia Kwan-Manager/Medical Ins Dept', '28670888 (main)
2236 6142 (Mr Fung / Ivy Chan)', '2521 8672', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '- ''Group Medical Card'' plastic card
- card embossed with the word "HOSPITAL"
- the card expriy date EXP dd/mm/yy"
- accept for Inpatient Only', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Bank of China\BOC_Claim Form 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BOC2', 'In', 'Billing -  Ms FUNG Bee Biar
Beebiar_ysfung@bocgroup.com
Admission : Claims Manager- Ms Leung
(852) 2867 0888

Julia Kwan-Manager/Medical Ins Dept', '28670888 (main)
2236 6142 (Mr Fung / Ivy Chan)', '2521 8672', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '- ''Group Medical Card'' plastic card
- card embossed with the word "HOSP"
- the card expriy date EXP dd/mm/yy"
- accept for Inpatient Only', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Bank of China\BOC_Claim Form 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BOC2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BOC3', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BOC3', 'In', 'Billing -  Ms FUNG Bee Biar
Beebiar_ysfung@bocgroup.com
Admission : Claims Manager- Ms Leung
(852) 2867 0888

Julia Kwan-Manager/Medical Ins Dept', '28670888 (main)
2236 6142 (Mr Fung / Ivy Chan)', '2521 8672', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '- ''Group Medical Card'' plastic card printed with red colour ''Medpass'' icon
- card embossed with the word "HOSP" or "HOSPITAL"
- the card expriy date EXP dd/mm/yy"
- accept for Inpatient Only', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Bank of China\BOC_Claim Form 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BOEIN', 'In', '7/FL, South Tower
Cathay Pacific City,
8 Scenic Rd
Lantau Island HK', '2747-8945', '2363-8259', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BOEIN', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BRCG', 'In', '', '2901-3173 
2901-3151', '2901-3007', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Please pay attention to entitement stated on the guaranttee.', '-Guarantee Letter is needed
-Guarantee Letter covers up to 3rd Class only', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BRCG', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BREC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BREC', 'In', '', '2810-0229', '2825-8800', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BS', 'In', '', '2369-2869', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAC', 'Out', 'Agreement & Billing
Ms. Monique Cheung
Provider Relations Manager
Email: moniquec@bupa.com.hk', '25175153', '39736905', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Bupa Asia\Bupa Asia Limited - For Coach Staff Redemption letter 20140721.pdf', '', '', '', 'For outpatient Health Assessment case only - Platinum Executive Physical Examination :
Male : HK$6,103 (DGP05)
Female: HK$6,783 (DGP06)', '- Company will issue Redemption letter to all eligible staff of Coach to enjoy the offer.
- Please verify the HKID on the LOG with client.
- Please collect the redemption letter with member''s signature & redemption date.
- All additional tests need to ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAC', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'For outpatient Health Assessment case only - Platinum Executive Physical Examination.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAI', 'In', 'Pre Authorization (hongkong):
Tel: 2517-5323 press "1"
Fax: 2517-5326
Customer Service: (for members)
Tel: 2517-5511 press "2" (forward to UK)
+44 1273-323563 (U.K.)
Pre-Auth emergency contact:
+44 1273-718428
servicepartner@bupa-intl.com', 'UK Fax: 44-1273-820517', '2517-5326 Pre-Auth', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '\\hkim\pa share\Patient Account\Insurance Card Program\BUPAI & ihid\BupaI card faces.doc', '', '', '', '- Pay attention to Doctor''s Portion in LOG. Refer GTD to Manager.
- Both BUPAI & IHID are use the same Pre-authorization Form.', '1. LOG sample & Consent Form:
H:\Patient Account\Insurance Card Program\BUPAI & ihid\LOG sample & Consent Form.pdf
2. IHID merged with BUPAI for case handling. Therefore, please be awared the HK office telephone system has changed to have optional choic', to_date(''), '', 'H:\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Aug 2014.pdf', 'H:\Patient Account\Insurance Card Program\BUPAI & ihid\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAI', 'Out', 'Pre Authorization (hongkong):
Tel: 2517-5323 press "1"
Fax: 2517-5326
Customer Service: (for members)
Tel: 2517-5511 press "2" (forward to UK)
+44 1273-323563 (U.K.)
Pre-Auth emergency contact:
+44 1273-718428
servicepartner@bupa-intl.com', 'UK Fax: +44 1273-820517', '2517-5326 Pre-Auth', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\BUPAI & ihid\BupaI card faces.doc', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\BUPAI no Agreement.jpg', '', '', '18/10/2006 According to BUPA Asia (verbally)
1. Authorization needs to be requested within 72 hours of service.
2. If after 72 hours, patient has to pay and claim after. No authorization will be released to the Hospital.', '- BUPAI not cover outpatient Pharmacy.
- 21/10/2005 BUPA International does not currently have an agreement for outpatient settlement with the hospital, patient needs to pay for treatment at the point of service.
- As per BUPAI, all outpatient should se', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Feb 2014.pdf', 'H:\Patient Account\Insurance Card Program\BUPAI & ihid\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAI4', 'In', 'Pre Authorization (hongkong):
Tel: 2517-5323 press "1"
Fax: 2517-5326
Customer Service: (for members)
Tel: 2517-5511 press "2" (forward to UK)
+44 1273-323563 (U.K.)
Pre-Auth emergency contact:
+44 1273-718428
servicepartner@bupa-intl.com', 'UK Fax: 44-1273-820517', '2517-5326 Pre-Auth', '', '', 0.0, -1.0, -1.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\General Exclusions 20120808.doc', '', '', '- Pay attention to Doctor''s Portion in LOG. Refer GTD to Manager.
- Both BUPAI & IHID are use the same Pre-authorization Form.', '1. LOG sample & Consent Form:
H:\Patient Account\Insurance Card Program\BUPAI & ihid\LOG sample & Consent Form.pdf
2. IHID merged with BUPAI for case handling. Therefore, please be awared the HK office telephone system has changed to have optional choic', to_date(''), '', 'H:\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Aug 2014.pdf', 'H:\Patient Account\Insurance Card Program\BUPAI & ihid\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAI4', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do not accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAI5', 'Out', 'Pre Authorization (hongkong):
Tel: 2517-5323 press "1"
Fax: 2517-5326
Customer Service: (for members)
Tel: 2517-5511 press "2" (forward to UK)
+44 1273-323563 (U.K.)
Pre-Auth emergency contact:
+44 1273-718428
servicepartner@bupa-intl.com', 'UK Fax: 44-1273-820517', '2517-5326 Pre-Auth', '', '', 0.0, 0.0, -1.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\BUPAI no Agreement.jpg', '', '', '18/10/2006 According to BUPA Asia (verbally)
1. Authorization needs to be requested within 72 hours of service.
2. If after 72 hours, patient has to pay and claim after. No authorization will be released to the Hospital.', '- BUPAI not cover outpatient Pharmacy.
- 21/10/2005 BUPA International does not currently have an agreement for outpatient settlement with the hospital, patient needs to pay for treatment at the point of service.
- As per BUPAI, all outpatient should se', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Feb 2014.pdf', 'H:\Patient Account\Insurance Card Program\BUPAI & ihid\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAI5', 'In', 'Pre Authorization (hongkong):
Tel: 2517-5323 press "1"
Fax: 2517-5326
Customer Service: (for members)
Tel: 2517-5511 press "2" (forward to UK)
+44 1273-323563 (U.K.)
Pre-Auth emergency contact:
+44 1273-718428
servicepartner@bupa-intl.com', 'UK Fax: 44-1273-820517', '2517-5326 Pre-Auth', '', '', 0.0, -1.0, -1.0, -1.0, '', '', '', '', 'Entitlement: SEMI PRIVATE ROOM
- Pay attention to Doctor''s Portion in LOG. Refer GTD to Manager.
- Both BUPAI & IHID are use the same Pre-authorization Form.', '1. LOG sample & Consent Form:
H:\Patient Account\Insurance Card Program\BUPAI & ihid\LOG sample & Consent Form.pdf
2. IHID merged with BUPAI for case handling. Therefore, please be awared the HK office telephone system has changed to have optional choic', to_date(''), '', 'H:\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Aug 2014.pdf', 'H:\Patient Account\Insurance Card Program\BUPAI & ihid\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS1', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '1. Collect the cost exceeding HK$1 million and other service items not covered.
2. When total billed amount reaches HK$250,000 during the hosptialisation period.  Pls notify: Provider Relations Hotline at 2517 5233

Upon member request, we can help the', '- DO NOT pass blank voucher to patient to sign
- ''HOSPITAL+CLINICAL'' = direct billing for Inpatient & Outpatient
- ''HOSPITAL'' = direct billing for Inpatient
- "MA" for maternity treatment.  Not cover baby charges.
- Not cover Speech Therapy.
- send o', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS1', 'Out', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '- Pls tick GP / SP consultation on voucher.
Accept Card :
- Card embossed with "Hospital & Clinical".   DO NOT accept only with "Hospital"
- w/ MA Wordings, cover Maternity service (exlcuding baby charges)', '- DO NOT pass blank voucher ( without amount ) to patient to sign.
- Patient has to countersign the voucher if the amount has been revised.
- For billing purpose, marked Provider Code "322" on each claim vouch
- Not cover Speech Therapy.
- send out bi', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS2', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', 'When total billed amount reaches HK$250,000 during the hosptialisation period.  Pls notify: Provider Relations Hotline at 2517 5233
- Card and Claim Voucher and form will remain effective as long as the card''s expiry date is still valid. 5/6/2008', '- DO NOT pass blank voucher to patient to sign
- ''HOSPITAL+CLINICAL'' = direct billing for Inpatient & Outpatient
- ''HOSPITAL'' = direct billing for Inpatient
- "MA" for maternity treatment.  Not cover baby charges.
- Not cover Speech Therapy.
- send o', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS2', 'Out', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '- Pls tick GP / SP consultation on voucher.
Accept Card :
- Card embossed with "Hospital & Clinical".   DO NOT accept only with "Hospital"
- w/ MA Wordings, cover Maternity service (exlcuding baby charges)', '- Not cover Speech Therapy.
- send out bill within 90days', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS3', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '1. Collect the cost exceeding HK$1 million and other service items not covered.
2. When total billed amount reaches HK$250,000 during the hosptialisation period.  Pls notify Provider Relations Hotline at 2517 5233

Upon member request, we can help the ', '- DO NOT pass blank voucher to patient to sign
- ''HOSPITAL+CLINICAL'' = direct billing for Inpatient & Outpatient
- ''HOSPITAL'' = direct billing for Inpatient
- "MA" for maternity treatment.  Not cover baby charges.
- Not cover Speech Therapy.
- send o', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS3', 'Out', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '- Pls tick GP / SP consultation on voucher.
Accept Card :
- Card embossed with "Hospital & Clinical".   DO NOT accept only with "Hospital"
- w/ MA Wordings, cover Maternity service (exlcuding baby charges)', '- DO NOT pass blank voucher ( without amount ) to patient to sign.
- Patient has to countersign the voucher if the amount has been revised.
- For billing purpose, marked Provider Code "322" on each claim vouch
- Not cover Speech Therapy.
-- send out b', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS4', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', 'Limit up to $400,000
1. Collect the cost exceeding HK$400,000 and other service items not covered.
2. When total billed amount reaches HK$250,000 during the hosptialisation period.  Pls notify Provider Relations Hotline at 2517 5233', 'PLUS-HOSP - Hospital cover card - For Inpatient treatment and day case surgical procedure
PLUS-C & H - Clinical & Hospital cover card - For inpatient treatment and day case surgical procedure', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS4', 'Out', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '- Pls tick GP / SP consultation on voucher.
Accept Card embosed with :
"Hospital & Clinical" / "Clinical" + "OP"  or
"Hospital & Clinical" / "Clinical" + "MA"  or
"Hospital & Clinical" / "Clinical" +"MA/OP"  
     -OP Wording ---> Outpatient service', '- DO NOT pass blank voucher (without amount ) to patient to sign
- Patient has to countersign the voucher if the amount has been revised
- For billing pupose, marked provide Code "322" on each claim voucher
- Not cover Speech Therapy.
- send out bill ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS5', 'Out', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '- Pls tick GP / SP consultation on voucher.
Accept Card :
- Card embossed with "Hospital & Clinical".   DO NOT accept only with "Hospital"
- w/ MA Wordings, cover Maternity service (exlcuding baby charges)', '- DO NOT pass blank voucher ( without amount ) to patient to sign.
- Patient has to countersign the voucher if the amount has been revised.
- For billing purpose, marked Provider Code "322" on each claim vouch
- Not cover Speech Therapy.
-- send out b', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPAS5', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '1. Collect the cost exceeding HK$1 million and other service items not covered.
2. When total billed amount reaches HK$250,000 during the hosptialisation period.  Pls notify Provider Relations Hotline at 2517 5233

Upon member request, we can help the ', '- DO NOT pass blank voucher to patient to sign
- ''HOSPITAL+CLINICAL'' = direct billing for Inpatient & Outpatient
- ''HOSPITAL'' = direct billing for Inpatient
- "MA" for maternity treatment.  Not cover baby charges.
- Not cover Speech Therapy.
- send o', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASG1', 'Out', '', '25175175
25175388', 'Fax : 25401123', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do not Accept', 'Silver & Green color card
New Bupa logo effective 2nd june 2008
Card and Claim Voucher and form will remain effective as long as the card''s expiry date is still valid. 5/6/2008', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASG1', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Bupa Asia\New GOP Format (for Silver, Green card).pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', 'When total billed amount reaches HK$250,000 during the hosptialisation period.  Pls notify Provider Relations Hotline at 2517 5233
- Card and Claim Voucher and form will remain effective as long as the card''s expiry date is still valid. 5/6/2008', '- Hospital has to collect the cost exceeding the approved guarantee amount.  Do not ask for further guarantee.
- DO NOT pass blank voucher to patient to sign
- BUPA Healthcare Card and a letter of  Guarantee of Payment (GOP) are required upon admission ', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Bupa Healthcare Pre-auth Form.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASG2', 'Out', '', '25175175
25175388', 'Fax : 25401123', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do not Accept', 'Silver & Green color card
New Bupa logo effective 2nd june 2008
Card and Claim Voucher and form will remain effective as long as the card''s expiry date is still valid. 5/6/2008', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASG2', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Bupa Asia\New GOP Format (for Silver, Green card).pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', 'When total billed amount reaches HK$250,000 during the hosptialisation period.  Pls notify : Provider Relations Hotline at 2517 5233', '- Hospital has to collect the cost exceeding the approved guarantee amount.  Do not ask for further guarantee.
- DO NOT pass blank voucher to patient to sign
- BUPA Healthcare Card and a letter of  Guarantee of Payment (GOP) are required upon admission ', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Bupa Asia\Pre-Admission Form bupa_individual_hospitalisation. July 2014.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASHN1', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '-  When total billed amount reaches HK$250,000 during the hosptialisation period. Pls notify Provider Relations Hotline at 2517 5233', '- DO NOT pass blank voucher to patient to sign
The Card embossed with: 
- "Hospital" for Day case and In-patient service
- "Hospital & Clinical" for Day case and In-patient services
- "MA" for maternity treatment.  Not cover baby charges.
- Not cover', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASHN1', 'Out', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '- Pls tick GP / SP consultation on voucher.
Accept Card embosed with :
"Hospital & Clinical" / "Clinical" + "OP"  or
"Hospital & Clinical" / "Clinical" + "MA"  or
"Hospital & Clinical" / "Clinical" +"MA/OP"  
     -OP Wording ---> Outpatient service', '- DO NOT pass blank voucher (without amount ) to patient to sign
- Patient has to countersign the voucher if the amount has been revised
- For billing pupose, marked provide Code "322" on each claim voucher
- Not cover Speech Therapy.
- send out bill ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASHN2', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '-  When total billed amount reaches HK$250,000 during the hosptialisation period. Pls notify:  Provider Relations Hotline at 2517 5233', '- DO NOT pass blank voucher to patient to sign
The Card embossed with: 
- "Hospital" for Day case and In-patient service
- "Hospital & Clinical" for Day case and In-patient services
- "MA" for maternity treatment.  Not cover baby charges.
- Not cover', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASHN2', 'Out', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '- Pls tick GP / SP consultation on voucher.
Accept Card embosed with :
"Hospital & Clinical" / "Clinical" + "OP"  or
"Hospital & Clinical" / "Clinical" + "MA"  or
"Hospital & Clinical" / "Clinical" +"MA/OP"  
     -OP Wording ---> Outpatient service', '- DO NOT pass blank voucher (without amount ) to patient to sign
- Patient has to countersign the voucher if the amount has been revised
- For billing pupose, marked provide Code "322" on each claim voucher
- Not cover Speech Therapy.
- send out bill ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASHN3', 'Out', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '- Pls tick GP / SP consultation on voucher.
Accept Card embosed with :
"Hospital & Clinical" / "Clinical" + "OP"  or
"Hospital & Clinical" / "Clinical" + "MA"  or
"Hospital & Clinical" / "Clinical" +"MA/OP"  
     -OP Wording ---> Outpatient service', '- DO NOT pass blank voucher (without amount ) to patient to sign
- Patient has to countersign the voucher if the amount has been revised
- For billing pupose, marked provide Code "322" on each claim voucher
- Not cover Speech Therapy.
- send out bill ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('BUPASHN3', 'In', 'Pre-Auth
T: 2517 5789  F: 3973 6966 / 2540 1123
email: preauth@bupa.com.hk
Provider Relations 
T: 2517 5233  F: 3973 6980', '2517 5175', '2548 1848', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\BUPAS_BupaAsia200912.jpg', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Voucher - Nov 2013 (ALL products).pdf', '', '-  When total billed amount reaches HK$250,000 during the hosptialisation period. Pls notify Provider Relations Hotline at 2517 5233', '- DO NOT pass blank voucher to patient to sign
The Card embossed with: 
- "Hospital" for Day case and In-patient service
- "Hospital & Clinical" for Day case and In-patient services
- "MA" for maternity treatment.  Not cover baby charges.
- Not cover', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Bupa Asia\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CALTE', 'In', 'Ms Pamela Poon
Mr Eddy Yuk Tak WU, HR Manager', '2582-6548
2582-6127', '2802-8750', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, 'H:\INPATIENT_INSURANCE RECORD\IPD_Insurance Name List & Void List\Name List_Caltex', '', '', '', '', 'Gtd Letter
Check Name List for Deposit waive', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CALTE', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CC', 'In', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CC', 'Out', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CCC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CCC', 'In', '', '2525-6385', '2845-2610', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CEAL', 'In', 'Ms. Olive Yiu - Marketing Manager 9372 7251 
tpm_medicare@yahoo.com.hk', '(852) 3622 5838', '(852) 3620 3768', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '- Agreement signed for both In + Out patient', '- For outpatient case, HKAH consent is required if there is no consent part shown on the insurance''s designated document (if any).', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CEAL', 'Out', 'MS. OLIVE YIU-MARKETING MANAGER 93727251 TPM_MEDICARE@YAHOO.COM.HK', '(852) 36225838', '(852) 36203768', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '- Agreement signed for both In + Out patient', '- HKAH consent is required if there is no consent part shown on the insurance''s designated document (if any).', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CEGA', 'Out', 'T: +44 (0) 1243 621000
F: +44 (0) 1243 773169
email: assistance@cegagroup.com

James Walker
Global Network Development Manager
T:  +44 (0)1243 621000 ext 1681  
James.Walker@cegagroup.com', '+44 (0) 1243 621000', '+44 (0) 1243 773169', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CEGA Group Services Limited\GOP sample.pdf', '', '', '', '1. LOG is a must
2. Please add charges of XXADM HK$110 to Inpatient''s final bill and each  Outpatient bill (no need to mentioned on bill it is bank charges).   No need to revised Guarantee for $110 admin fee.', '1. Accept e-billing to procurement@cegagroup.com
2. HKAH consent', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CEGA', 'In', 'T: +44 (0) 1243 621000
F: +44 (0) 1243 773169
email: assistance@cegagroup.com

James Walker
Global Network Development Manager
T:  +44 (0)1243 621000 ext 1681  
James.Walker@cegagroup.com', '+44 (0) 1243 621000', '+44 (0) 1243 773169', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CEGA Group Services Limited\GOP sample.pdf', '', '', '', '1. LOG is a must
2. Please add charges of XXADM HK$110 to Inpatient''s final bill and each  Outpatient bill (no need to mentioned on bill it is bank charges).  No need to revised Guarantee for $110 admin fee.', '1. Accept e-billing to procurement@cegagroup.com', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CEGA1', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Former Name: Cega Air Ambulance Limited', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CEGA1', 'Out', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CGC', 'In', 'First Line of Contact
Ms. Constance Yu
Tel: 2867 7301
Fax: 2867 7399
Mobile: 9441 2744
Email: hkong-ag@international.gc.ca

Second line of Contact:
Cathy Hurdle 6793-8557', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '17 March 2015 Update: NO MORE NAME LIST. 
Please call the Consulate for gurantee letter', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CGC', 'Out', 'First line of contact:
Ms. Constance Yu
Tel: 2867 7301
Fax: 2867 7399
Mobile: 9441 2744
Second line of contact:
Cathy Hurdle 6793-8557', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '17 March 2015 Update: NO MORE NAME LIST. Please call the Consulate for gurantee letter.
- Consent is required', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGHK', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGHK', 'In', 'CS Hotline: 2560 1990', '2539-9222', '2886-3722', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Cigna HK\Voucher.pdf', '', 'Coverage excludes Day Case Treatment', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Cigna HK\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGIN', 'In', '24/7 Tel: 1-302-797-3100
AT&T Direct to Cigna: #8009-61111 then dial 800 441 2668
email: cghbprovider@cigna.com
UK Tel: +44 1475 492197
UK Fax: +44 1475 492424', '1-302-797-3100', '1-302-797-3150', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '', '', '', '', '- CIGNA Secure Mail:  Login: hkahpsr@hkah.org.hk  Password: Inpatient1
- Attend to the deductible show on the fax
- e-billing (no need original) : bills@cigna.com', '<Patient has to sign below form>
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CIGNA Int''l\Assignment of Benefits for GOP.pdf', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\Assignment of Benefits for GOP.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGIN', 'Out', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'do not accept', '- Accept Guarantee Of Payment case by case (Contract mainly for Inpatient)
- <Patient has to sign below forms>
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CIGNA Int''l\Assignment of Benefits for GOP.pdf
- HKAH consent,', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\Assignment of Benefits for GOP.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGNACMC', 'In', 'Email: cignacmb@cigna.com AND cignacmc.care@cigna.com
24/7 Hotline: +86 21 6086 3160
Or details contact can found in membership card.', '', '+86 21 6086 3199', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\CMC\LOG sample.doc', '', '', '', '- CIGNA Secure Mail:  Login: hkahpsr@hkah.org.hk; Password: Inpatient1', 'Invoice please send to:
CIGNA International, CIGNA Global Health Options, 1 Knowe Road, Greenock, Scotland, PA15 4RJ    (or according to LOG instruction)', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\CMC\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGNACMC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGNACMC2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGNACMC2', 'In', 'Email: cignacmb@cigna.com AND cignacmc.care@cigna.com
24/7 Hotline: +86 21 6086 3160
Or details contact can found in membership card.', '', '+86 21 6086 3199', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\CMC\LOG sample.doc', '', '', '', '- CIGNA Secure Mail:  Login: hkahpsr@hkah.org.hk; Password: Inpatient1', 'Invoice please send to:
CIGNA International, CIGNA Global Health Options, 1 Knowe Road, Greenock, Scotland, PA15 4RJ   (or according to LOG instruction', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\CMC\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGUS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGUS', 'In', '', '1-415-954-1403', '1-415-982-2831', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGVI', 'Out', 'LOG/ Eligibility/ Benefits:
Tel: +603 2178 1411
Fax: +603 2178 1499
Email: authorization@cigna.com', '+603 2178 1411', '+603 2178 1499', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\Cigna_VI\Guideline of Cigna Card- Cigna_VI.doc', 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\Cigna_VI\VI becomes CIGIN - Exclusions.pdf', '', '', ' can use e-billing, not req''d to submit original invoice. please send e-billing to bills@cigna.com', '- "Outpatient Direct Payment" shown at the back of the card.
- consent is required
- check "Only Valid in" at back of card e.g. W/W = worldwide, W/W EXCL USA = worldwide excluding USA
- copy both sides of insurance card (because % shown at the back of ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIGVI', 'In', 'LOG/ Eligibility/ Benefits:
Tel: +603 2178 1411
Fax: +603 2178 1499
Email: authorization@cigna.com', '+603 2178 1411', '+603 2178 1499', '', '', 0.0, -1.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\Cigna_VI\Guideline of Cigna Card- Cigna_VI.doc', 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\Cigna_VI\VI becomes CIGIN - Exclusions.pdf', '', '', 'can use e-billing, not req''d to submit original invoice. e-billing to bills@cigna.com', '1. Inform Cigna for admission and provide cost estimation by filling the Cost Estimate Form and email to authorization@cigna.com
2. Please send e-billing to bills@cigna.com, please also send the discharge report', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CIGNA Int''l\Cigna_VI\Cost Estimate Form.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIM', 'Out', 'Office Hours:
   Mon-Fri (except PH)
   0900-1230
   1400-1645', '28614262 / 2529 0382 / 28614261', '2143 6176', 'Mon- Fri 0900-1230, 1400 - 1745', 'No Limit', 7800.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\cim_200902.doc', '', 'Accept Card:
- Plastic Card in Pastel Blue Colour
- Card with Fluorescent cross with Yellow Edge
- Maximum cover US$1,000 (HKD $ 7,800) per day
- Hospital can demand the policy holder to pay the difference if the bil(s) amount for the servcie date is ', '- Hospital could not monitor the patient on "CIM Withdrawal List"
- Please ask patient to complete "SECTION 1: THE PATIENT" part on claim form
- Xerox insurance card for billing purpose
- Patient has to sign on Statement for filling record
- Pre-natal', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CIM', 'In', 'Office Hours:
   Mon-Fri (except PH)
   0900-1230
   1400-1645', '28614262 / 2529 0382 / 28614261', '21436176', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '', '', '', '', '', '1. Different Claim Form for In-patient and Out-patient
2. Pre-Auth Form
H:\Patient Account\Insurance Card Program\Cosmos Insurance Management Ltd\Cosmos Insurance Management Ltd.doc', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\CIM\cim_200902.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CLI', 'In', 'Ms. Cheung Mei Wa (guarantee) : Tel: 28317936 mwcheung@chinalife.com.hk
Fax: 25733308 (phone before faxing)', '2545-8111', '2544-4395 (main)', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '- Claim Form is needed.
- Patient should notify insurance prior admission.
- LOG with insurance company chop.
- LOG passed from patient to HKAH during admission.  Patient needs to sign on the LOG ''INDEMNITY'' part.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\CLI claim form (June 2010).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CLI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\CLI claim form (June 2010).pdf', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CLP', 'In', '', '2678-8111', '2760-4448', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CLP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNGBG', 'IN', 'T: +1-905-669-7353
Details pls refer to membership card
email: gbgcare@managingwithcare.com', '+1 905 669 4920', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', '', '', '- Insurance card must has CMN or europ assistance Logo
- copy Insurance card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', '', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNGBG', 'Out', 'T: +1-905-669-7353
Details pls refer to membership card
email: gbgcare@managingwithcare.com', '+1 905 669 4920', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', '- Insurance card must has CMN or Europ Assistance Logo
- copy card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', '-	LOG is a MUST.  Otherwise, patient has to self-pay.', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', '', '', -1.0, 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNGen', 'Out', 'T: +1-905-669-7353
Details pls refer to membership card
email: globalservice@generalihealth.com  or  medical@generalihealth.com', '+1 905 669 7353', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', '- Insurance card must has CMN or Europ Assistance Logo
- copy card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', '-	LOG is a MUST.  Otherwise, patient has to self-pay.', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', '', '', -1.0, 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNGen', 'IN', 'T: +1-905-532-3648
Details pls refer to membership card
email: globalservice@generalihealth.com  or  medical@generalihealth.com', '+1 905 762 5193', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', '', '', '- Insurance card must has CMN or europ assistance Logo
- copy Insurance card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', '', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNGen1', 'Out', 'T: +1-905-532-3648
Details pls refer to membership card
email: globalservice@generalihealth.com  or  medical@generalihealth.com', '+1 905 532 3648', '+1 905 762 5194', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', '- Insurance card must has CMN or Europ Assistance Logo
- copy card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', '- LOG is a MUST.  Otherwise, patient has to self-pay.', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', '', '', -1.0, 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNGen1', 'IN', 'T: +1-905-532-3648
Details pls refer to membership card
email: globalservice@generalihealth.com  or  medical@generalihealth.com', '+1 905 532 3648', '+1 905 762 5194', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', '', '', '- Insurance card must has CMN or europ assistance Logo
- copy Insurance card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', '', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNHCC', 'Out', 'T: +1-905-669-7353
Details pls refer to membership card
email: service@hccmis.com', '+1 800 605 2282 (toll free)', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', 'DO NOT ACCEPT', '(Terminated from 10 Feb 2014) NH
- Insurance card must has CMN or europ assistance Logo
- copy Insurance card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', '', '', -1.0, 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNHCC', 'IN', 'T: +1-905-669-7353
Details pls refer to membership card
email: service@hccmis.com', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', '', '', 'DO NOT ACCEPT', '(Terminated from 10 Feb 2014) NH
- Insurance card must has CMN or europ assistance Logo
- copy Insurance card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNHCI', 'Out', 'T: +1-905-669-7353
Details pls refer to membership card
email: claims@healthcareinternational.com', '+1 888 548 9794 (toll free)', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', '- Insurance card must has CMN or Europ Assistance Logo
- copy card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', '-	LOG is a MUST.  Otherwise, patient has to self-pay.', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', '', '', -1.0, 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CMNHCI', 'IN', 'T: +1-905-669-7353
Details pls refer to membership card
email: claims@healthcareinternational.com', '+1 888 548 9794 (toll free)', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\CMN Inc\LOG sample Jun 2013.pdf', '', '', '', '- Insurance card must has CMN or europ assistance Logo
- copy Insurance card for billing purpose.
- CMN Inc. - Subsid of Europ Asst. Co. (Division of the Generali Group)', '', to_date(''), '', 'H:\Patient Account\Insurance Card Program\CMN Inc\Pre-Authorization Form.pdf', 'H:\Patient Account\Insurance Card Program\CMN Inc\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('COC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('COC', 'In', '', '2599-1333', '2506-1425', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Patient needs to settle the bill
Once confirmed with ID, 5% offered to Hospital Portion. Patient must settle the bill upon discharge.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CP', 'In', '', '2830-1833', '2882-8031', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'VIP Room needs further approval
Covers any class entitlement except VIP (unless approved by company)', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CS', 'In', '1. CS Dept +1 671 477-9808
Recbecca Balajadia ext. 7998
rbalajadia@calvos.com
2. Provider Relations
Alexy Dacanay ext. 7958
adacanay@calvos.com', '+1 671 477 9808', '+1 671 477 4141', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Calvo''s SelectCare\Sample LOG (w cal illustration).pdf', '', '', '', '', '1. Coverage limited to semi-private or LOG specify.
2. Claims send to: P.O. Box FJ, Hagatna, Guam 96932  Attn: Claims Department', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('CS', 'Out', '1. CS Dept +1 671 477-9808
Recbecca Balajadia ext. 7998
rbalajadia@calvos.com
2. Provider Relations
Alexy Dacanay ext. 7958
adacanay@calvos.com', '+1 671 477 9808', '+1 671 477 4141', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Calvo''s SelectCare\Sample LOG (w cal illustration).pdf', '', '', '', '', '1. Sign HKAH consent form
2. Claims send to: P.O. Box FJ, Hagatna, Guam 96932  Attn: Claims Department', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DAIW', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DAIW', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '- Accept card in yellow color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DAIWA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DAIWA', 'In', 'Gary Tang
Head of Human Resources and Administration', '2525-0121', '2845-1621', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Check Name List', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DAIWI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DAIWI', 'In', 'Lawrence Chow Senior Manager', '2525-0121', '2918-0770', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Please check name list', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DALI', 'Out', 'For obtain LOG:
wilmclaims.metlifeexpat@alico.com

Provider relations:
provider.metlifeexpat@alico.com

Nilesh Chaudhary - Medical Network Development Specialist
email:  nilesh.chaudhary@alico.com', '+1 302 661 8674 (CS)
+1-302-594-2393 (Nilesh Tel)', 'Fax: +1 302 571 9213', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Delaware (DELAM)\LOG samples.pdf', '', '', '', '- LOG shows "DelamLife" / "Alico" / "Atlas" / "MetLife" are accepted.
- Accept case by case (Contract mainly for Inpatient)', '- HKAH consent is required.  Please write ''Metlife/MSH CHINA'' on the consent form.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DALI', 'In', 'For obtain LOG:
wilmclaims.metlifeexpat@alico.com

Provider relations:
provider.metlifeexpat@alico.com

Nilesh Chaudhary - Medical Network Development Specialist
email:  nilesh.chaudhary@alico.com', '+1 302 661 8674 (CS)
+1-302-594-2393 (Nilesh Tel)', 'Fax: +1 302 571 9213', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Delaware (DELAM)\LOG samples.pdf', '', '', '', '- Attach "Atlas Claim Submission" Form for billing.
- LOG shows "DelamLife" / "Alico" / "Atlas" / "MetLife" are accepted.
- Delaware American Life Insurance Co (DELAM) - mbr co. of American Life Ins Co.', '<Claim cover>: H:\Patient Account\Insurance Card Program\Delaware (DELAM)\Claim submission cover.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DALI1', 'Out', 'TPA Team  Hotline: +86 21 6187 1591
Fax: +86 21 6160 0153
For LOG, email: Asia.MetLifeExpat@mshasia.com AND 
medical@mshasia.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\MSH China\LOG Samples.pdf', '', '', '', '', '- Contact MSH China for LOG (contact details refer to card face)
- HKAH consent is required.  Please write ''Metlife/MSH China'' on consent form.
- LOG''s currency may under HKD / USD / RMB
- Send bill to MSH China', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DALI1', 'In', 'TPA Team  Hotline: +86 21 6187 1591
Fax: +86 21 6160 0153
For LOG, email: Asia.MetLifeExpat@mshasia.com AND 
medical@mshasia.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\MSH China\LOG Samples.pdf', '', '', '', '', '- Contact MSH China for LOG (contact details refer to card face)
- Send bill to MSH China', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DAP', 'In', 'Mr Steven Ma', '2866-6995', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DAP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DEC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DEC', 'In', '', '2805-3111', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '-Forenach name of company Digital Equipment Corporation
-No such company name has registered in PCCW   3/3/09/leo', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DEN1', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance card for Billing
- If insurance card without name, can', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Denmark Claim Form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DEN1', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
- Former Name: Eur', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Denmark Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DEN2', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Card shows NHC Global A+E, NHC Global Corporate or NHC Global Private all acceptable.
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance card for Billing
- If insurance card without', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Nordic Claim Form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DEN2', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Card shows NHC Global A+E, NHC Global Corporate or NHC Global Private all acceptable.
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
- Former', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Nordic Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DETP', 'In', 'Fax : 25881979
Tel: 25071756 Ms. Sandra Lee (for LOG)', '2511-4261 main line', '2907-8560', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DETP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '20-7-2009 fax, changed name to Dragages Hong Kong Limited.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DF', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DF', 'In', '', '2299-1888
2299-3004', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DHI', 'In', '', '2230-9958', '', '', 'No Limit', 100000.0, 0.0, -1.0, 0.0, '', '', '', '', 'The maximum amount is 100,000 including Dr''s fees. Need to inform insurance company when bill round up to 70,000.00. 

Excludes Physical Check up/ Dental Treatment/ Eye Reflection', 'Either guarantee letter or Insurance card is accepted.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\DAOHENG.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DHI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DHI2', 'In', '', '2230-9958', '', '', 'No Limit', 100000.0, 0.0, -1.0, 0.0, '', '', '', '', 'The maximum amount is 100,000 including Dr''s fees. Need to inform insurance company when bill round up to 70,000.00. 

Excludes Physical Check up/ Dental Treatment/ Eye Reflection', '', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\DAOHENG.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DHI2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DHI3', 'In', '', '2230-9958', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'The maximum amount is 100,000 including Dr''s fees. Need to inform insurance company when bill round up to 70,000.00. 

Excludes Physical Check up/ Dental Treatment/ Eye Reflection', '', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\DAOHENG.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DHI3', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\DAOHENG.doc', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DKV1', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 160114 - DKV or GLOBALITY.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service.
- Only accept card that carries "Euro-Center China (HK) Co Ltd" at the back.
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance ca', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\DKV - Globality Claim Form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DKV1', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 160114 - DKV or GLOBALITY.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service.
- Only accept card that carries "Euro-Center China (HK) Co Ltd" at the back.
- Copy Insurance card for Billing
- Only cover Semi-pri', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\DKV - Globality Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DKV2', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 160114 - DKV or GLOBALITY.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service.
- Only accept card that carries "Euro-Center China (HK) Co Ltd" at the back.
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance ca', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\DKV - Globality Claim Form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DKV2', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 160114 - DKV or GLOBALITY.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service.
- Only accept card that carries "Euro-Center China (HK) Co Ltd" at the back.
- Copy Insurance card for Billing
- Only cover Semi-pri', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\DKV - Globality Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DKV3', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 160114 - DKV or GLOBALITY.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service
- Accept card with wording ''GLOBALITES''''on the front and ''GLOBALITE CHINA'''' on the back side
- For "YouGenio World" product, it must show ''YouGenio World Top'' which is a', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\DKV - Globality Claim Form (new).pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DKV3', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 160114 - DKV or GLOBALITY.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service.
- Accept card with wording "GLOBALITES" on the front and "GLOBALITE CHINA" on the backside
- Copy Insurance card for Billing
- Forme', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\DKV - Globality Claim Form (new).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DKVSIE', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 160114 - DKV or GLOBALITY.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown.
- Check Customer policy list before provide service.
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance card for Billing
- If insurance card without name, can provide direct billing ', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\DKV - Siemens Claim Form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DKVSIE', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 160114 - DKV or GLOBALITY.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service.
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
- Former Name: Euro-Center China (HK) Co Lt', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\DKV - Siemens Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DOHM', 'In', '+853 28710474 (tel)
+853 28710277 (fax)

tel :+853 28313731 (hosp main)', '+853 83908083 (account Ms. Leung)', '+853 28713144 (a/c)', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Guarantee Letter is needed', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DOHM', 'Out', '+853 28710474 (tel)
+853 28710277 (fax)

tel :+853 28313731 (hosp main)', '+853 83908083 (account Ms. Leung)', '+853 28713144 (a/c)', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DRKA', 'Out', 'Tel:  +49 211 271120 20
Fax: +49 211 301805 27
ecc@grcassistance.com

Marlon Schildt (Legal & key a/cs)
m.schildt@drkassistance.com
Sebastian Hugot  (Dir.of Mkt)
s.hugot@drkassistance.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\DRK Assistance - German Red Corss\DRK Assistance LOG sample.pdf', '', '', '- sign HKAH consent form', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DRKA', 'In', 'Tel:  +49 211 271120 20
Fax: +49 211 301805 27
ecc@grcassistance.com

Marlon Schildt (Legal & key a/cs)
m.schildt@drkassistance.com
Sebastian Hugot  (Dir.of Mkt)
s.hugot@drkassistance.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\DRK Assistance - German Red Corss\DRK Assistance LOG sample.pdf', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DRV', 'In', 'Hotline: 2810 9718
Fax: 2808 4066', '', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'OCCASIONAL CASE
Refer to Manager for any new case
Letter of Guarantee to be approved by Manager', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('DRV', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EAJ', 'Out', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept Policy/ Certificate if:
1. No sickness Coverage
2. No accident Coverage
3. Sickness/ Coverage in HK $
4. Suggest Xerox Copy the insurance Card for Billing purpose.', ' Accept Policy/ Certificate if:
1. Policy/ Certificate in Paper Sheet
2. Printed with "Overseas Travel Accident Insurance" wordings
3. Policy/ Certificate issued from Japan
4. Coverage in Japanese Yen Dollar', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\Sompo Japan Nipponkoa Insurance Inc (1-Sept-2014).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EAJ', 'In', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', 'Policy cert is from Sompo Japan Insurance Inc', '- Copy valid insurance policy
- Try to ask patient to fill all parts of claim form.
- Make sure the coverage category on policy is correct (e.g. SICKNESS, or INJURY).
- Medical Report is required for all IP cases.
- Acknowledge admission form:
H:\Pat', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\Sompo Japan Nipponkoa Insurance Inc (1-Sept-2014).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EAJ1', 'Out', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept Policy/ Certificate if:
1. No sickness Coverage
2. No accident Coverage
3. Sickness/ Coverage in HK $
4. Suggest Xerox Copy the insurance Card for Billing purpose.', ' Accept Policy/ Certificate if:
1. Policy/ Certificate in Paper Sheet
2. Printed with "Overseas Travel Accident Insurance" wordings
3. Policy/ Certificate issued from Japan
4. Coverage in Japanese Yen Dollar', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\Sompo Japan Nipponkoa Insurance Inc (1-Sept-2014).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EAJ1', 'In', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', '', '- Copy valid insurance policy
- Try to ask patient to fill all parts of claim form.
- Make sure the coverage category on policy is correct (e.g. SICKNESS, or INJURY).
- Medical Report is required for all IP cases.
- Acknowledge admission form:
H:\Pat', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\Sompo Japan Nipponkoa Insurance Inc (1-Sept-2014).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EC', 'In', 'New Contact point in PR China:
Email: BEIJING@euro-center.com
Tel:  86 10 64620486
Fax: 86 10 84511176
8/F. Bld. C. East Lake Villas, 35 Dongzhimenwai Dajie, Dongcheng District, Beijing 100027 PR China', 'Thai: 66-2-216-8943/44', 'Thai: 66-2-216-8945', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Firm: Borealis A/S
Policy No. 83075410-7/530751011-5
HK Agent: Abercombie & Kent HK Ltd (tel: 2865-7818, Fax 2866-0556)', '- Contract signed with Euro Center (Thailand)
- By Guarantee Letter', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EC', 'Out', 'New Contact point in PR China:
Email: BEIJING@euro-center.com
Tel:  86 10 64620486
Fax: 86 10 84511176
8/F. Bld. C. East Lake Villas, 35 Dongzhimenwai Dajie, Dongcheng District, Beijing 100027 PR China', 'Thai: (66) 2216 8943', 'Thai: (66) 2216 8945', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Main contract signed with Euro Centre (Thailand).', '1. Letter Of Guarantee (issued from Euro Centre Beijing or Thailand office)
2. Refer to Letter of Guarantte for Coverage
3. Patient has to sign HKAH''s consent form and sign on Statement', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EC1', 'Out', '', '(66)22168943
     (Bangkok)', '(66)22168945', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EC1', 'In', '', '(66) 2 216 8943', '(66) 2 216 8945', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EDP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EDP', 'In', '', '86-755-336-6566', '86-755-336-5791', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ELIC', 'In', '', '2776-3081', '2776-7683', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ELIC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ERICS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ERICS', 'In', '', '2590-2388', '2590-9550', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EURO', 'In', '', '31-7136-46200', '31-7136-41350', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Case Reference 372672-KEUR Nina on 7/09/04-08/09/2004 Dr Darren Man', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EURO', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EURO', 'In', '', '31-7136-46200', '31-7136-41350', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'OCCASIONAL CASE
Refer to Manager for any new case
Letter of Guarantee to be approved by Manager', 'No Contract', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EURO', 'In', '', '', '', '-', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EUROP', 'In', '', '44-1444-442800', '44-1444-410164', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'OCCASIONAL CASE
Refer to Manager for any new case
Letter of Guarantee to be approved by Manager
Case Reference 374497 - SHILLABEER Lauren Evelyn Ng
Admitted 23/01/2005 to 04/02/2005
Dr Yvonne Ou', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('EUROP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FA', 'In', 'Email: 
Billing contact: help@faops.com
Admission contact: 
assistance@firstassistance.co.nz
intlnetwork@firstassistance.co.nz', '(64)93561656', '(64)95251278', '', '', 0.0, -1.0, -1.0, 0.0, '', '', '', '', '- No longer manage pre-authorisation or assistance for InterGlobal, pls email to assistance@interglobalpmi.com (11/9/2011)
- InterGlobal Ltd and First Rescue and Emergency (NZ) Limited T/A First Assistance.
- Send bill according to LOG', '- Contact FA within 24 hours of admission through Phone/Fax/Email whenever possible & practical
- Contract for In-patient only
- July 2009 for information only: FA is paying HKD to our HKD bank account.', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\First Assistance\0000 IGA pre-auth _HKG 2013.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FALCO', 'In', '', '2232-2888', '2232-2899', '', 'No Limit', 200000.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Falcon Insurance Co (HK) Ltd\Authorized Signors of LOG.pdf', '', '', '', '', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Falcon Insurance Co (HK) Ltd\Hospital_Claim_Form_2012.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FALCO', 'Out', '', '2232 2888', '2232 2899', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Falcon Insurance Co (HK) Ltd\Authorized Signors of LOG.pdf', '', '', '', 'For billing :
- Diagnosis shown on bill
- Send xerox copy of letter of guarantee to Falcon.', '- Contract for Inpatient only
- Sign HKAH consent form.
- Check coverage with FALCON for Health Examination, Pre-natal/ Post-natal, Well Baby.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FANUC', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '- Accept card in yellow color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FANUC', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FIN1', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance card for Billing
- If insurance card without name, can provide direct billing as usual, but pls also copy client''s passport. If any d', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Finland Claim Form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FIN1', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
- Former Name: Euro-Center China (HK) Co Ltd', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Finland Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FIN2', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance card for Billing
- If insurance card without name, can provide direct billing as usual, but pls also copy client''s passport. If any d', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Finland Claim Form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FIN2', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
- Former Name: Euro-Center China (HK) Co Ltd', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Finland Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FINNISH', 'In', '', '2369-7052', '2367-2325', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'OCCASIONAL CASE
Refer to Manager for any new case
Letter of Guarantee to be approved by Manager', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FINNISH', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FORITS2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FORTIS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FORTIS', 'In', 'Ms Alison Wong
Manager - Group Insurance Department
Alison_Wong@hk.fortis.hk', '2591 8602', '2831 9802', '', '', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\Fortis.doc', '', 'Forenamed Pacific Century Insurance', '- If card embossed with ''HOSP Y", accept for hospital admission
- If card embossed with "CB", accept for maternity care', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\Fortis.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FORTIS2', 'In', 'Ms Alison Wong
Manager - Group Insurance Department
Alison_Wong@hk.fortis.hk', '(852) 2591 8602', '(852) 2831 9802', '', '', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\Fortis.doc', '', '', 'Accept Card for Admission, with or without HOSP Y embossed on card,  however OPD only accept card marked with PV or SPV.
1) PV:  General Practitioner''s visit
2) SPV:  Specialist''s visit *
3) DEN:  Dentist''s visit
4) CB:  Maternity benefit (for hospita', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\Fortis.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FORTIS2', 'Out', 'Ms Alison Wong
Manager - Group Insurance Department
Alison_Wong@hk.fortis.hk', '(852) 2591 8602', '*852) 28319802', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Please note that Apple Card is not accepted.', 'Accept Card for Admission, with or without HOSP Y embossed on card,  however OPD only accept card marked with PV or SPV.
1) PV:  General Practitioner''s visit
2) SPV:  Specialist''s visit *
3) DEN:  Dentist''s visit
4) CB:  Maternity benefit (for hospita', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FUJI', 'In', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '28680612', 'Fax +852 2735-2256', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\Card face\Fuji Fire & Marine card sample.doc', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 'do not accept', '- Outpatient case handled by JIA and use JIA form.
- Inpatient case handled by Wellbe and use Well Be form.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FUJI', 'Out', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '2734 9333', '2735 2256', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Card face\Fuji Fire & Marine card sample.doc', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 'Accept Policy / Certificate / Card if :
   - Policy / Card in paper sheet and OVERSEAS TRAVEL ACCIDENT INSURANCE wordings.
   - Policy / Certificate in Paper sheet
   - Coverage in Japanese Yen Dollar (yen)', 'May cover for pre-existing symptoms if patient obtains a letter from JIA.  Sample attached:
H:\Patient Account\Insurance Card Program\JI Accident\Letter for treatment of pre-existing symptoms.pdf
DO NOT Accept Policy / Certificate / Card if :
 1. Sickn', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FUJITSU', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- 	Cover Physical Therapy (with Dr referral letter)', '- Accept card in white / green color with Prestige logo
- *For Vaccination: refer to the list of claimable items.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FUJITSU', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Accept card in white / green color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FWD', 'Out', 'T: 2850 3030  
F: 2850 3031
Claims Hotline: 2851 5533
healthcare card handling: 2851 5511 during office hours', '', '', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\FWD General Insurance\card sample (outpatient - 1 Sept 2014).pdf.pdf', '', 'H:\Patient Account\Insurance Card Program\FWD General Insurance\voucher_in & out (1 Sept 2014).pdf', '', 'ING become FWD. All ING (old) cards are replaced by FWD card. If the patient shows ING card, pls ask for the FWD card. If no FWD card, pls call 2851 5511 during office hours for verification. Reject ING cards if it''s non-office hours, or when cannot get t', '- accept Silver card embossed with HOPD wording (Outpatient Credit Facility at Hospital)
- not cover Maternity and Mental
- please ask patient to sign voucher (need sign again if amount increased)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('FWD', 'In', 'T: 2850 3030  
F: 2850 3031
Claims Hotline: 2851 5533
healthcare card handling:2851 5511 during office hours', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\FWD General Insurance\FWD Healthcare Card Sample (HS).pdf', '', 'H:\Patient Account\Insurance Card Program\FWD General Insurance\voucher_in & out (1 Sept 2014).pdf', '', '- Not cover Maternity.
- No LOG needed.', 'Check expiry date & coverage on card face:
P/C xx HS500K = credit limit upto HK$500,000
P/C xx HOSP = NO limit
P/C xx "blank" = patient self pay (No credit facility)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\FWD General Insurance\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GAG', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GAG', 'In', 'Hotline: 31876831
Fax: 2387 6831 (obtain LOG)
Josephine Hung 3187-6802
Terry Tsang 2531-8925', '2521 0707', '2521 8018', '', 'No Limit', 100000.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Generali S.p.A\Card sample 1a.pdf', '', '', '', 'If LOG cannot provide before pt. discharge, ask patient to self pay.', '1. Card shows: "HOSP/MOP $0"  means member is entitled to hospitalization credit services.
2. For emergency admission (i.e. Through OPD), pls notify Generali and ask for LOG.
3. Send bill within 60 days', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Generali S.p.A\Claim Form 20131021.pdf', 'H:\Patient Account\Insurance Card Program\Generali S.p.A\Notification of Admission.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GAG1', 'In', 'Hotline: 31876831
Fax: 2387 6831 (obtain LOG)
Josephine Hung 3187-6802
Terry Tsang 2531-8925', '2521 0707', '2521 8018', '', '', 0.0, 0.0, -1.0, -1.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Generali S.p.A\Credit Services workflow comparsion quick reference.pdf', '', '', '', 'If LOG cannot provide before pt. discharge, ask patient to self pay.', '1. Card shows: "Hospitalization benefit only" & pls check expiry date.
2. For emergency admission (i.e. Through OPD), pls notify Generali and ask for LOG.
3. Send bill within 60 days', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Generali S.p.A\Claim Form 20131021.pdf', 'H:\Patient Account\Insurance Card Program\Generali S.p.A\Notification of Admission.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GAG1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GAG2', 'In', 'Hotline: 31876831
Fax: 2387 6831 (obtain LOG)
Josephine Hung 3187-6802
Terry Tsang 2531-8925', '2521 0707', '2521 8018', '', '', 0.0, 0.0, -1.0, -1.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Generali S.p.A\Credit Services workflow comparsion quick reference.pdf', '', '', '', '1. For policy no.: GL-88000499, GM-88000524 & GM-88000525.  If LOG cannot provide before pt. discharge, pls also provide credit service and send bill to Generali.  (Not cover pregnacy and well baby related)', '1. Card shows: "HOSP: Authorization not required" & "HOSP/MOP $0".  Pls check expiry date.
2. Initially cover up to HK$100,000
3. For emergency admission (i.e. Through OPD), pls notify Generali and ask for LOG.
3. Send bill within 60 days', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Generali S.p.A\Claim Form 20131021.pdf', 'H:\Patient Account\Insurance Card Program\Generali S.p.A\Notification of Admission.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GAG2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GD', 'In', '24hr Tel: : +86 10 5815 1188
24hr Fax : +86 10 5815 1128
24hr email : responsecenter@globaldoctor.com.au
Alarm@globaldoctor.com.au', '', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GD', 'Out', '24hr Tel: : +86 10 5815 1188
24hr Fax : +86 10 5815 1128
24hr email : responsecenter@globaldoctor.com.au
Alarm@globaldoctor.com.au', '', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '- By Letter of Guaranttee
- Request patient to sign on HKAH consent form and bill.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GeoBlue', 'Out', 'globalhealth@hthworldwide.com
sbrant@hthworldwide.com (Mr.Shane Brant)', '24hrs +1 610-254-8771', '+1 610-293-0318', '', '', 0.0, 0.0, -1.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\HTH\GeoBlue\GeoBlue LOG.pdf', '', '- Total amount of o/s guaranteed invoice shall no exceed HK$ 1,000,000.00
- Request Medication Breakdown', 'email bill to :  invoices@geo-blue.com  OR
fax to : +1.610.293.0318', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GeoBlue', 'In', 'globalhealth@hthworldwide.com
sbrant@hthworldwide.com (Mr. Shane Brant)', '24hrs +1 610-254-8771', '+1 610-293-0318', '', '', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\HTH\GeoBlue\GeoBlue LOG.pdf', '', '', '', 'Total amount of OUTSTANDING guaranteed invoice shall not exceed HK$ 1,000,000.00', 'email bill to :  invoices@geo-blue.com  OR
fax to : +1.610.293.0318', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL1', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL1', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- Policy No. starts with "LI"
- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL10', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL10', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL11', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL11', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  GP with Meds $xxx/visit - mean only direct billing for Consultation & Medication upto the limit stated on the card.
-  Online checking for member''s eligibility. http://www.g', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL12', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL12', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL13', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL13', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- If back side of card shows "Group: The HongKong & Shanghai Hotels, Limited", please do not reject if any unclear, contact Global Health to clarify.
- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since ', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL14', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do not accept', '', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL14', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL15', 'Out', 'Ms. Rebecca Lai', '2526 0505', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL15', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL2', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL2', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL3', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL3', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL4', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL4', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL5', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- Policy No. starts with Year e.g "2001"
- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL5', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL6', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL6', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  GP with Meds $xxx/visit - mean only direct billing for Consultation & Medication upto the limit stated on the card.
-  Online checking for member''s eligibility. http://www.g', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL7', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL7', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL8', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL8', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL9', 'In', '', '2526 0505 CLAIMS DEPT', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-  Main Contract for Out Patient Only
-  Guarantee Letter for inpatient is needed individually (mentioning 14 days payment terms).
-  Please ask GHAL which claim form to be used (GHAL has various claim forms).
-  Guarantee should mentioned GHAL will se', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GHAL9', 'Out', 'Ms. Rebecca Lai 
21873665 (direct)', '2526 0505 
Claims Dept', '25260769', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Global Health\Appendix B _GlobalHealth GHHK 2010-2 Exclusions.pdf', '', '', '- DO NOT ACCEPT card with ''AIG'' logo, under name of ''AIG General Insurance Company China Limited'' since the card is not issued by Global Health HK but AIG Shanghai (no agreement).', '-  Contract signed for Outpatient only.
-  Card with "OP" / "DB"  wordings.
-  Online checking for member''s eligibility. http://www.globalhealthasia.com
-  regdesk@hkah.org.hk  or  hkahopbill@hkah.org.hk
-  password for the above : a123456 (small lett', to_date(''), '', '', '\\hkim\pa share\Patient Account\Insurance Card Program\Global Health\Appendix__K Provider Claim Form February 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GII', 'In', '24-hours on call +86 135 8582 2586

H:\Patient Account\Insurance Card Program\Aetna\Aetna Contact Details 16 Oct 2012.doc', '24 hours hotline: +852 3071 5022', '+852 2866-2555', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Aetna\Pre-certification Medical form.pdf', '', '', '', '- Card policy no. starts with GHHxxxxxx
- Former Name : GoodHealth (under Aetna Global in 2009). 
- administered by Aetna Global Benefits (Asia Pacific) Limited', '- No agreement.  Refer to Manager for any new case.
- Guarantee letter must be approved before waiving deposit.
- Guarantee Letter for inpatient is needed individually (mentioning 30 days payment terms).
- Guarantee should mentioned Goohdhealth/Aetna A', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Aetna\Pre-certification Medical form.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GII', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Forename :', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GLE', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GLE', 'In', '', '65-4705605', '65-4740963', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'OCCASIONAL CASE
Refer to Manager for any new case
Letter of Guarantee to be approved by Manager', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GMC', 'In', 'To obtain LOG: 
Fax: 65 6849 4092
gmcg.ug32@henner.com

email: gmc.network@henner.com
Tel: +65 6887 2488
Fax: +65 6887 0328', '+33 1 40 82 43 02 (France)', '+33 1 40 82 43 85', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\GMC\Direct Settlement card - inpatient.pdf', '', '', '', '- 	Collect deposit if no LOG (except Emergency hospitalization only and with GMC Direct Settlement Card) - see sample
- Do Not Accept "World Bank" shows on GMC Membership card (effective 1-Jul-2011).', '- Pls accept both GMC and / or Henner logo membership card
- The first 2 days of hospitalization are automatically covered by the GMC Direct Settlement Card (Emergency hospitalization only) - see sample
- 	Use GMC LOG (accept both from France / Singapor', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\GMC\PA Form.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GMC', 'Out', 'To obtain LOG: 
Fax: 65 6849 4092
gmcg.ug32@henner.com

Tel: +65 6887 2488 (Singapore)
Fax: +65 6849 4092 (Singapore)
gmc.medical@henner.com', '+33 1 40 82 43 02 (France)', '+33 1 40 82 43 85', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\GMC\Direct Settlement card - Outpatient.pdf', 'H:\Patient Account\Insurance Card Program\GMC\exclusion + no direct billing for OP medicine (Nov 2014).pdf', '', '', '- According to the contract, see exlcusion, All Medication should pay by patient at upfront even "medication" shows 100% cover.
- Do Not Accept "World Bank" shows on GMC Membership card (effective 1-Jul-2011).
- On the GMC Settlement Card, the meaning o', '- HKAH consent is required.
- Pls accept both GMC and / or Henner logo membership card
- accept "GMC Membership Card" together with "GMC Direct Settlement Card".
- copy both ''GMC Membership Card" and ''GMC Direct Settlement Card" for billing.
- GMC may', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GPT', 'In', '', '2753-7615', '2753-7434', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'OCCASSIONAL CASE
Refer to Manager for any new case
Letter of Guarantee to be approved by Manager', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GPT', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GT', 'In', 'Ms. Ann Cheung Tel: 2218 3132
Mr. Franky Wong (Chief Financial & Admin Officer) Tel: 2218 3138', '2218-3000', '3748-2000', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\IPD_Insurance Name List & Void List\Name List_Grant Thornton\GT_Grant Thornton Name List_26 OCT 2010.pdf', '', '', '', 'do not accept', '- company, no agreement
- Check Name List
- Letter from Grant Thornton, stop direct bill service starting 1-1-2011.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GT', 'Out', 'Ms. Ann Cheung Tel: 2218 3132
Mr. Franky Wong (Chief Financial & Admin Officer) Tel: 2218 3138', '2218-3000', '3748 2000', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\IPD_Insurance Name List & Void List\Name List_Grant Thornton\GT_Grant Thornton Name List_26 OCT 2010.pdf', '', '', '', 'do not accept', '- company, no agreement
- Check Name List
- Letter from Grant Thornton, stop direct bill service starting 1-1-2011.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GTEI', 'In', '', '8620-8760-5551', '8620-8760-5582', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'Cover all expenses.
Check name list.
Ended 31-7-2007', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('GTEI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('H.S.', 'In', 'Operations:
Tel: +86 10 8586 5247
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', '- please adcknowledge admission by phone', '- Copy valid insurance policy
- Make sure the coverage category on policy is correct (e.g. SICKNESS, or INJURY)
- Copy 2 pages of passport (the page with photo + the page with Japan departure date=policy start date).
- As per meeting with EAJ on 6-Aug-', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\EAJ (H.S. Ins claim form _July 2011).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('H.S.', 'Out', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\EAJ (H.S. Ins claim form _July 2011).pdf', '', '', '- Copy valid insurance policy
- Make sure the coverage category on policy is correct (e.g. SICKNESS, or INJURY)
- Copy 2 pages of passport (the page with photo + the page with Japan departure date=policy start date).
- As per meeting with EAJ on 6-Aug-', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HEALIX', 'Out', '1. <For British Gov''t patients>
T: +44 208 481 7800
FCOhealthline@healix.com
2. <For New Zealand Gov''t patients>
T: +64 9 4774410
MFAT@healix.com
3. <For Other patients>
T: +44 20 8481 7749
internationalhealthcare@healix.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Healix\LOG samples.doc', '', '', '', '', '1. HKAH consent is needed
2. No claim form required
3. Accept e-billing. (refer to LOG)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HEALIX', 'In', '1. <For British Gov''t patients>
T: +44 208 481 7800
FCOhealthline@healix.com
2. <For New Zealand Gov''t patients>
T: +64 9 4774410
MFAT@healix.com
3. <For Other patients>
T: +44 20 8481 7749
internationalhealthcare@healix.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Healix\LOG samples.doc', '', '', '', '- Cover semi-private room unless medically necessary.', '1. No claim form required
2. Accept e-billing. (refer to LOG)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HIROSE', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '- Accept card in white / yellow color / green with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HIROSE', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Accept card in white / yellow / green color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HIS', 'Out', 'T: +852 2824 9099
F: +852 2824 9928', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Harrow International School\LOG & Student card sample.pdf', '', '', '', 'For infomation only.  
Normal working hour, the LOG will have the signature of House Master with school chop.  Outside normal working hour, only House Master Signature will be shown at the LOG, while a copy of LOG with school chop will be provided in the', '1. Student card + LOG
2. Further LOG is required if exceed HK$10,000
3. Sign HKAH consent', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HIS', 'In', 'T: +852 2824 9099
F: +852 2824 9928', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Harrow International School\LOG & Student card sample.pdf', '', '', '', 'For infomation only.  
Normal working hour, the LOG will have the signature of House Master with school chop.  Outside normal working hour, only House Master Signature will be shown at the LOG, while a copy of LOG with school chop will be provided in the', '1. Student card + LOG
2. Further LOG is required if exceed HK$10,000', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HITA', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', '- New card might have ISOS logo at right top corner, DO NOT bill ISOS.
Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HITA', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.', '- *For Vaccination: refer to the list of claimable items.
- New card might have ISOS logo at right top corner, DO NOT bill ISOS.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HKE', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HKE', 'In', '', '2843-3141', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HKJC', 'In', '', '2966-8088', '2577-9036', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HKJC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HKM', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HKM', 'In', '', '2339-8150', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', 'Member Valid Pass = Patient''s verified card', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HKRFU', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HKRFU', 'In', '', '2504-8316', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Accept LOG, have Senior or Manager to approve.', 'Member Valid Pass = Pt verified card
A letter will be sent to us for every football match coming.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HMMP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HMMP', 'In', 'Tel no is the same for all HMMP Staff

LOG
Ms. Kitty Tang  (kittytang@hmmp.com.hk)
Ms. Frances Yiu  (francesyiu@hmmp.com.hk)

Claims Settlement Enquiry
Ms. Sandy Chen      (sandychen@hmmp.com.hk)
Ms. Irene Wong      (irenewong@hmmp.com.hk)', '2302-0400
9011-4095', '2302-0500', '', 'No Limit', 200000.0, 0.0, -1.0, 0.0, '', '', '', '', 'Prior approval needed if amount exceeds HK $ 200,000.00 (excluding physician fee)', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HOPE', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '- No contract', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HOPE', 'In', 'Raymond Chan
raymond@hopemed.com.hk
Tel:(852)2165 4111 / (852)5313 3591', '', '(852) 3007 5435', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Background: a colonscopy surgery on 31 Jan 2013, special approval by Brenda to accept their LOG.', '1. No Contract.
2. Accept LOG case by case.  
- If Hope medical sends LOG to us, LOG should refer to Inpatient Manager or Makerting.
- If direct billing requested by patient, pls ask patient to contact Hope Medical.
3. "Please settle bill within 7 - 1', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HS', 'In', 'Ms. Haley Chan 2288 7022
Ms. Linda Lung 2288 9068', '', '', '', 'No Limit', 500000.0, 0.0, -1.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng Bank - Staff plan\Tsf to AXA\Voucher & Claim Form 20130101.pdf', '', 'DO NOT ACCEPT', '1. Billing address: EB Claims, AXA China Region, 19/F AXA Centre, 151 Gloucester Road, Wanchai, HK
2. Pls write down patient name, staff no. and "Dr code: 009" on voucher.

Staff Card or Dependent ID.
Guarantee Letter is needed if no Staff Card or Dep', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HS_AXA', 'In', 'Hotline: 8107 8080
Ms. Haley Chan 2288 7022
Ms. Linda Lung 2288 9068', '', '', '', '', 500000.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng Bank - Staff plan\Tsf to AXA\AXA cards (1 Apr 2013).pdf', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng Bank - Staff plan\Tsf to AXA\Voucher 20130101.pdf', '', '- Only accept "Embossed" card.
- Guarantee Letter is needed if staff or dependent forgets to bring medical card.
- cover upto HK$500,000. Need to notify AXA if over.', '1. Billing address: EB Claims, AXA China Region, 19/F AXA Centre, 151 Gloucester Road, Wanchai, HK
2. Pls write down "Dr code: 9" on voucher.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng Bank - Staff plan\Tsf to AXA\Claim Form 20130101.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HS_AXA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBC', 'Out', 'Hotline: 2519-1280', '25191280', '22887380', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Card Sample_to HKAH (Revised 20121025).pdf', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'Accept Card :
1. Plastic Card in Gold Color
2. Card embossed with expiry date at right upper corner (eg 01/12)', '-Please type both Membership No. in HATS Policy No. Field ....31-10-2014rita
1. DO NOT pass blank voucher (without amount) to patient to sign
2. Patient has to countersign the voucher if the amount has been revised
3. Imprint insurance card clearly on ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBC', 'In', 'Hotline: 25191280', '', '2288-7390', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '- Maternity cover for baby only if baby discharges together with mother.', '-Please type both Membership No.  in HATS Policy No. Field ....31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) cards, need notify HSBC when hospitalization cases', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBC-A', 'In', 'Hotline: 2519 1280 (card back side)', '', '2288-7390', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '- Maternity cover for baby only if baby discharges together with mother.', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBC-A', 'Out', 'Hotline: 2519 1280', '25191280', '22887380', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Card Sample_to HKAH (Revised 20121025).pdf', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'Accept Card :
1. Plastic Card in Gold Color', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
1. DO NOT pass blank voucher (without amount) to patient to sign
2. Patient has to countersign the voucher if the amount has been', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBC-A1', 'Out', 'Hotline: 2519 1280', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Card Sample_to HKAH (Revised 20121025).pdf', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'Accept Card :
1. Plastic Card in Gold Color', '--Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
1. DO NOT pass blank voucher (without amount) to patient to sign
2. Patient has to countersign the voucher if the amount has bee', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBC-A1', 'In', 'Hotline: 2519 1280', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '- Maternity cover for baby only if baby discharges together with mother.', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim form - AXA (former HSBC).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBC1', 'In', 'Tel: 2828-0131', '2828-0131', '2288-7390', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\HSBC Int''l Scheme\HSBC International Scheme (Exclusion List 2012).pdf', 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\HSBC AXA - voucher & claim form.pdf', '', 'DO NOT ACCEPT', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
Acknowledgement Admission Form:
H:\Patient Account\Insurance ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBC1', 'Out', '(852) 2288 6229  (Hotline)', '2828 0131 Medical Service Hotline', '2288 7390', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Card Sample_to HKAH (Revised 20121025).pdf', 'H:\Patient Account\Insurance Card Program\HSBC Int''l Scheme\HSBC International Scheme (Exclusion List 2012).pdf', 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\HSBC AXA - voucher.pdf', '', 'DO NOT ACCEPT', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
-  GP special price applies with AR code HSBC1 (special rate generated automatically, see attached page for the agreed rates).
- ', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCCO', 'In', 'Hotline: 25191281', '25191281', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'The medical card should only be accepted for the following:
1. Inpatient services that a patient who is registered as an inpatient in a hospital and occupying a bed
2. Day Case surgical Center
3. Surgical procedures in hospital', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCCO', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCCO-A1', 'In', 'Hotline: 2519 1281', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'The medical card should only be accepted for the following:
1. Inpatient services that a patient who is registered as an inpatient in a hospital and occupying a bed
2. Day Case surgical Center
3. Surgical procedures in hospital', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim form - AXA (former HSBC).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCCO-A1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCFC', 'In', 'Tel: 28678678', '28678678', '2288-7390', '', 'No Limit', 300000.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '- Private Nurse/ Guest bed/ other personal bills not covered.
- Contact HSBC if over $300,000.', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
1) Check valid date on the card
2) Bill HSBC
3) Complete the Claims voucher and Claim form.
4) Embossed data from Card
5) Full', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCFC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCFC-A', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCFC-A', 'In', 'Tel: 28678678', '28678678', '', '', 'No Limit', 300000.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '- Private Nurse/ Guest bed/ other personal bills not covered.
- Contact HSBC if over $300,000.', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
1) Check valid date on the card
2) Bill HSBC
3) Complete the Claims voucher and Claim form.
4) Embossed data from Card
5) Full', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCFC2', 'In', 'Tel: 28678678 for LOG', '28678678', '2288-7390', '', '', 0.0, 0.0, -1.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '-Not for Urgent Care
-Contact HSBC if over $300,000.
-If no LOG received upon discharged, patient has to pay by him/herself  6/3/09/leo', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
-LOG must needed
-Waive deposit if no LOG upon Admission    6/3/09/leo
- Imprint Medical Voucher and ''First Care'' Claim Form are', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCFC2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCFC2-A', 'In', 'Tel: 2867 8678 for LOG', '2867 8678', '', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Letter of Guarantee Sample for Hospital.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '-Not for Urgent Care
-Contact HSBC if over $300,000.
-If no LOG received upon discharged, patient has to pay by him/herself  6/3/09/leo', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- LOG must needed
- Waive deposit if no LOG upon Admission    6/3/09/leo
- Imprint Medical Voucher and ''First Care'' Claim Form a', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCFC2-A', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCJA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCJA', 'In', '25191281', '25191281', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'The medical card should only be accepted for the following:
1. Inpatient services that a patient who is registered as an inpatient in a hospital and occupying a bed
2. Day Case surgical Center
3. Surgical procedures in hospital', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCJA-A', 'In', '25191281', '25191281', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'The medical card should only be accepted for the following:
1. Inpatient services that a patient who is registered as an inpatient in a hospital and occupying a bed
2. Day Case surgical Center
3. Surgical procedures in hospital', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCJA-A', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCJA-A1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCJA-A1', 'In', 'Hotline: 2519 1281', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'The medical card should only be accepted for the following:
1. Inpatient services that a patient who is registered as an inpatient in a hospital and occupying a bed
2. Day Case surgical Center
3. Surgical procedures in hospital', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim form - AXA (former HSBC).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCKCRC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', '-Do not accept Outpatient/ Urgent Care, except LOG fax already received
- -Imprint HSBC voucher if accept', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCKCRC', 'In', 'Tel: 25191331', '25191331', '28659897', '', '', 0.0, -1.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Letter of Guarantee Sample for Hospital.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'LOG for all cases of Hospitalization
Inform HSBC on KCRC 24 hrs Medical Helpline for
1. Any admission case expenses exceeding $50,000
2. Unavailability of appropriate ward class level to memeber
In case no LOG was received but member shows up, provide', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
-Medical Card & LOG need to be presented upon Admission 
-Please call 24 helpline if no LOG on hand 
-Do not accept Outpatient/ ', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCKCRC-A1', 'In', 'Tel: 25191331', '25191331', '28659897', '', '', 0.0, -1.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Letter of Guarantee Sample for Hospital.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'LOG for all cases of Hospitalization
Inform HSBC on KCRC 24 hrs Medical Helpline for
1. Any admission case expenses exceeding $50,000
2. Unavailability of appropriate ward class level to memeber
In case no LOG was received but member shows up, provide', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
-Medical Card & LOG need to be presented upon Admission 
-Please call 24 helpline if no LOG on hand 
-Do not accept Outpatient/ ', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim form - AXA (former HSBC).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCKCRC-A1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', '-Do not accept Outpatient/ Urgent Care, except LOG fax already received
- -Imprint HSBC voucher if accept', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCMTR', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCMTR', 'In', 'Tel: 2519 1331', '25191331', '28659897', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Letter of Guarantee Sample for Hospital.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'Do not cover for OPD services including RMO attendence before hospitalization.', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- LOG Needed for hospitalization and treatment
- Inform HSBC on 24 hour Medical Helpline 2288 6229 for unavailability of appropri', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCMTR-A1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCMTR-A1', 'In', 'Hotline: 25191331', '25191331', '28659897', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Letter of Guarantee Sample for Hospital.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', 'Do not cover for OPD services including RMO attendence before hospitalization.', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- LOG Needed for hospitalization and treatment
- Inform HSBC on 24 hour Medical Helpline 25191331 for unavailability of appropria', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim form - AXA (former HSBC).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCPC', 'In', 'Tel: 25191308', '', '28659897', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Letter of Guarantee Sample for Hospital.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
-LOG Needed for hospitalization and treatment
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- Notifying HSB', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCPC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCPC-A1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCPC-A1', 'In', 'Tel: 2519 1308', '2519 1308', '28659897', '', '', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Letter of Guarantee Sample for Hospital.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
-LOG Needed for hospitalization and treatment
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- Notifying HSB', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim form - AXA (former HSBC).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCPCCW', 'In', '25191318', '25191318', '28659897', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Letter of Guarantee Sample for Hospital.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- LOG Needed for hospitalization and treatment
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCPCCW', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCS', 'In', '24x7 Medical Service Hotline:3070 5005

email: medicalservice@axa.com.hk', '3070 5005', '2865 9821', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\Local Staff Scheme\Letter of Guarantee Sample for Hospital - local staff.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\Local Staff Scheme\New voucher 20121224.pdf', '', 'No direct billing if patient choose to stay in the room higher than his/her entitled class of ward.', '-Please type both Staff No. and Membership No. in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Send Acknowledgement upon admission by FAX 2865 9821
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', 'H:\INPATIENT\Forms & List\Insurance\Insurance Pre-authorization Form\HSBC Local Staff & Health Plus.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCS', 'Out', '3070 5005 Medical Service 7x24Hotline
medicalservice@axa.com.hk', '3070 5005', '2865 9821', '', 'Non-Office Hour Only', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCStaff20080411.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\Local Staff Scheme\New voucher 20121224.pdf', '', 'Accept card for GP & SP as follow   (except Special Appointment) :
- Mon-Fri  :  1700 to 0900
- Sat        :  after 1300
- Sunday / Public Holiday :  24 hours
** 1. Cover SP consultation provided SP has OPD clinic at that time.  Cover imaging test, la', '-Please type both Staff No. And Membership No. in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
1. DO NOT ACCEPT Follow Up Case / By Appointment Case & Special Appointment
2. Do Not Pass blank voucher without amount for patient t', to_date(''), '', '', '', '', -1.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\Local Staff Scheme\Pre-auth Memo to Doctor (Health Plus card & Local staff scheme) 20150305.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCS1', 'In', '30705005 Medical Service 7x24Hotline
Mon to Fri 9am to 5:30pm (Except PH)
email: medicalservice@axa.com.hk', '30705005', '2865 9821', '', '', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\HSBC Insurance\Local Staff Scheme\Letter of Guarantee Sample for Hospital - local staff.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\Local Staff Scheme\New voucher 20121224.pdf', '', 'For HSBC staffs
No direct billing if patient choose to stay in the room higher than his/her entitled class of ward.', '-Please type both Staff No. and Membership No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Send Acknowledgement upon admission by FAX 2865 9821
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
-', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', 'H:\INPATIENT\Forms & List\Insurance\Insurance Pre-authorization Form\HSBC Local Staff & Health Plus.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCS1', 'Out', '3070 5005 Medical Service 7x24Hotline
Mon to Fri 9am to 5:30pm (Except PH)
email: medicalservice@axa.com.hk', '3070 5005', '2865 9821', '', 'Non-Office Hour Only', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCStaff20080411.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\Local Staff Scheme\New voucher 20121224.pdf', '', '1. NO need to collect any co-payment
2. Accept card for GP & SP as follow   (except Special Appointment) :
- Mon-Fri  :  1700 to 0900
- Sat        :  after 1300
- Sunday / Public Holiday :  24 hours
** 1. Cover SP consultation provided SP has OPD cli', '-Please type both Staff No. and Membership No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
1. DO NOT ACCEPT Follow Up Case / By Appointment Case & Special Appointment
2. Do Not Pass blank voucher without amount for ', to_date(''), '', '', '', '', -1.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\Local Staff Scheme\Pre-auth Memo to Doctor (Health Plus card & Local staff scheme) 20150305.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCSI', 'In', 'Tel: 25191281', '25191281', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCSI', 'Out', '', '2828 0182 Amy Fok', '22887380', '', '', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\HSBC.jpg', '', 'DO NOT ACCEPT', '1. DO NOT pass blank voucher (without amount) to patient to sign
2. Patient has to countersign the voucher if the amount has been revised
3. Imprint insurance card clearly on voucher
4. Covers for Immunization, pre-natal/Post-natal.

Accept Card :
1', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCSI-A', 'In', 'Tel: 2519 1281', '25191281', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim Form - HSBC AXA.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCSI-A', 'Out', '', '2828 0182', '22887380', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCSI-A1', 'In', 'Tel: 2519 1281', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBCKCRC20100111.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Voucher - AXA (former HSBC).pdf', '', '', '-Please type both Policy No. and Cert No. (if any) in HATS Policy No. Field (e.g. 123456H / 8468121-2).......31-10-2014rita
- Imprint Medical Voucher and Claim Form are needed 29-10-2009rita
- For HSBC staff (yellow & blue) and HSBC Premier (green) card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\HSBC Insurance\HSBC tsf to AXA GI\Claim form - AXA (former HSBC).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBCSI-A1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBFCR', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSBFCR', 'In', '', '2828-0131', '2288-7390', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\HSBC_HSBC Insurance.tif', '', '', 'Private nurse/guest bed or other personal bills are not covered.
Acknowledgement Admission needed if no Pre-authorisation.', '1) Check Valid Date on the card
2) Waive Advance Payment upon any admission
3) Present together with Letter of Guarantee (if no LOG , call 22886989)
4) Charge patient directly at the time of discharge (NOT to bill HSBC unless LOG provided)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSGI1', 'Out', '2288 7296 (hotline and voucher/form order)

22887398 Ms Chris Lee', 'hsgicmed@hangseng.com', '22887600', '', '', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\HSGI.doc', '', '- Not cover any Dental services
- cover lab test, imaging & physiotherapy', '- c/o HSBC Insurance (Asia) Ltd', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSGI1', 'In', '2288 7296 (hotline and voucher/form order)
22887398 Ms Chris Lee', 'hsgicmed@hangseng.com', '22887600', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng General Insurance\Voucher.pdf', '', 'For inpatient:
- Imprint Voucher and complete/fill in/ sign Part I& II of Hospitalization Claim Form
- NOT ACCEPT for any Dental services either at outpatient or inpatient.', 'C/O HSBC Insurance (Asia) Ltd

Both In and Out patient', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng General Insurance\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSGI2', 'In', '2288 7296 (hotline and voucher/form order)

22887398 Ms Chris Lee', 'hsgicmed@handseng.com', '22887600', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng General Insurance\Voucher.pdf', '', 'In-patient Only
- Imprint Voucher and complete/fill in/ sign Part I& II of Hospitalization Claim Form
- NOT ACCEPT for any Dental services either at inpatient.', 'C/O  HSBC Insurance (Asia) Ltd', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng General Insurance\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSGI2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSGI3', 'In', '2288 7296 (hotline and voucher/form order)
Ms Chris Lee 22887398
hsgicmed@hanseng.com', '', '22887600', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng General Insurance\Voucher.pdf', '', 'In-patient Only
- Imprint Voucher and complete/fill in/ sign Part I& II of Hospitalization Claim Form
- NOT ACCEPT for any Dental services either at inpatient.', 'C/O HSBC Insurance (Asia) Ltd', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Hang Seng General Insurance\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HSGI3', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HTH', 'In', 'globalhealth@hthworldwide.com
sbrant@hthworldwide.com (Mr. Shane Brant)', '24hrs +1 610-254-8771', '+1 610-293-0318', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', 'Total amount of OUTSTANDING guaranteed invoice shall not exceed HK$ 1,000,000.00', 'email bill to :  invoices@hthworldwide.com  OR
fax to : +1.610.293.0318', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HTH', 'Out', 'globalhealth@hthworldwide.com
sbrant@hthworldwide.com (Mr.Shane Brant)', '24hrs +1 610-254-8771', '+1 610-293-0318', '', 'No Limit', 1000000.0, 0.0, -1.0, 0.0, '', '', '', '', '- email bill to :  invoices@hthworldwide.com  OR  fax to : +1.610.293.0318
- Request Medication Breakdown', '1. Copy card for reference (if any).
2. Refer to Letter of Guarantee for coverage.
3. Total amount of o/s guaranteed invoice shall no exceed HK$ 1,000,000.00
4. Request patient to sign on HKAH''s consent form and bill.
5. We have to contact HTH to conf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HUT', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Billing address would have to be confirmed with patient. As informed, "NO" triplicated form is needed.
As informed, all companies are guaranteed separately. No Authorization form is needed.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('HUT', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IBL', 'Out', 'Doris Yun 2337 4211 / 6476 4006
email: 10keydee@onepost.net', '2337 4211', '2391 9634', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IBL', 'In', 'Doris Yun 2337 4211 / 6476 4006
email: 10keydee@onepost.net', '2337 4211', '2391 9634', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IBM', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IBM', 'In', '', '2825-6222', '2810-0210', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', 'Refer to Manager for any new case', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IF', 'In', '', '358-10-514-5857', '358-10-514-5840/2', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '', '', '', '', '', 'Forenamed Sampo Industrial', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IF', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IGAS', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do not Accept', 'ALERT CASE
Their guarantee fax is not accepted, need to advice them to call other medical agent for help.  6/3/09/leo', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IGAS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IGNZ', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IGNZ', 'In', 'Operation services under InterGlobal Assistance
Telephone: +44 (0)1252 351200 (24 hours)
Fax: +44 (0)1252 351202
Email: assistance@interglobalpmi.com', '+44 (0)1252 351200', '+44 (0)1252 351202', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'No Direct Billing Agreement. Accept LOG case by case', 'Billing method: Post original invoice and the requested doc, see details on LOG
Billing address: 
Claims Department-  In-patient Team
Aetna Global Benefits (UK) Limited
Woolmead House East, The Woolmead
Farnham, Surrey
GU9 7TT, UNITED KINGDOM', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHC', 'In', 'Mr. Roy Chan (Chief Consultant)
Mobile: 9103 7525
email: picc613@yahoo.com.hk

Mr. Justin Chan
justin.chan@ihcgroup.com.hk', '2291 0008', '2291 6287', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\International Health Care Group Limited\Letter of Guarantee.doc', '', '', '', 'DO NOT ACCEPT', '- Use HKAH LOG template
- Collect deposit if no LOG when patient admission or call to check during office hour.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHID', 'Out', 'IHI 24 Hour Emergency : +45 33153300
HK BUPAI : +852 25175323 press 2 for IHI member.', '', 'IHI +45 33322560', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- IHID has merged with BUPAI. Therefore, case handling in office hour will be managed by BUPAI in Hong Kong.  In off hour, case will refer back to IHI in Denmark. However, we will also need to get revise format from BUPAI in Hong Kong instead of the GOP f', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHID', 'In', 'Pre Authorization:
Tel: 2517 5323 press "2 "
Customer Service: (for members)
Tel: 2517 5323 press "4"
IHI 24 Hour Emergency : +45 33153300
email: emergency@ihi.com', '', 'IHI +45 33322560', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\IHID\LOG sample & Consent Form.pdf', '', '', '', '- Ask patient to sign IHID consent Form
- Both BUPAI & IHID are use the same Pre-authorization Form.
- Invoices should send to Bupa (Asia) Ltd', '- IHID has merged with BUPAI. Therefore, case handling in office hour will be managed by BUPAI in Hong Kong.  In off hour, case will refer back to IHI in Denmark. However, we will also need to get revise format from BUPAI in Hong Kong instead of the GOP f', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Feb 2014.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHID1', 'Out', 'IHI 24 Hour Emergency : +45 33153300
HK BUPAI : +852 25175323 press 2 for IHI member.', '', 'IHI +45 33322560', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- IHID has merged with BUPAI. Therefore, case handling in office hour will be managed by BUPAI in Hong Kong.  In off hour, case will refer back to IHI in Denmark. However, we will also need to get revise format from BUPAI in Hong Kong instead of the GOP f', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHID1', 'In', 'Pre Authorization:
Tel: 2517 5323 press "2 "
Customer Service: (for members)
Tel: 2517 5323 press "4"
IHI 24 Hour Emergency : +45 33153300
email: emergency@ihi.com', '', 'IHI +45 33322560', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\IHID\LOG sample & Consent Form.pdf', '', '', '', '- Ask patient to sign IHID consent Form
- Both BUPAI & IHID are use the same Pre-authorization Form.
- Invoices should send to Bupa (Asia) Ltd', '- IHID has merged with BUPAI. Therefore, case handling in office hour will be managed by BUPAI in Hong Kong.  In off hour, case will refer back to IHI in Denmark. However, we will also need to get revise format from BUPAI in Hong Kong instead of the GOP f', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Feb 2014.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHID2', 'Out', 'IHI 24 Hour Emergency : +45 33153300
HK BUPAI : +852 25175323 press 2 for IHI member.', '', 'IHI +45 33322560', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- IHID has merged with BUPAI. Therefore, case handling in office hour will be managed by BUPAI in Hong Kong.  In off hour, case will refer back to IHI in Denmark. However, we will also need to get revise format from BUPAI in Hong Kong instead of the GOP f', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHID2', 'In', 'Pre Authorization: (HK)
Tel: 2517 5323 press "2 "
Fax: 2517-5326
Customer Service: (for members)
Tel: 2517 5323 press "4"
IHI 24 Hour Emergency : +45 33153300
email: emergency@ihi.com', '', 'IHI +45 33322560', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\IHID\LOG sample & Consent Form.pdf', '', '', '', '- Ask patient to sign IHID consent Form
- Both BUPAI & IHID are use the same Pre-authorization Form.
- Invoices should send to Bupa (Asia) Ltd', '- IHID has merged with BUPAI. Therefore, case handling in office hour will be managed by BUPAI in Hong Kong.  In off hour, case will refer back to IHI in Denmark. However, we will also need to get revise format from BUPAI in Hong Kong instead of the GOP f', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Feb 2014.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHID3', 'Out', 'IHI 24 Hour Emergency : +45 33153300
HK BUPAI : +852 25175323 press 2 for IHI member.', '', 'IHI +45 33322560', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- IHID has merged with BUPAI. Therefore, case handling in office hour will be managed by BUPAI in Hong Kong.  In off hour, case will refer back to IHI in Denmark. However, we will also need to get revise format from BUPAI in Hong Kong instead of the GOP f', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IHID3', 'In', 'Pre Authorization:
Tel: 2517 5323 press "2 "
Customer Service: (for members)
Tel: 2517 5323 press "4"
IHI 24 Hour Emergency : +45 33153300
email: emergency@ihi.com', '', 'IHI +45 33322560', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\IHID\LOG sample & Consent Form.pdf', '', '', '', '- Ask patient to sign IHID consent Form
- Both BUPAI & IHID are use the same Pre-authorization Form.
- Invoices should send to Bupa (Asia) Ltd', '- IHID has merged with BUPAI. Therefore, case handling in office hour will be managed by BUPAI in Hong Kong.  In off hour, case will refer back to IHI in Denmark. However, we will also need to get revise format from BUPAI in Hong Kong instead of the GOP f', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\BUPAI & ihid\Pre-Auth Form Feb 2014.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IMA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IMA', 'In', '7.30am to 7.45pm (French time) Monday to Friday
Tel: +33 5 49 34 79 71
Fax: +33 5 49 34 75 66
email: frais_medicaux@ima.eu

24/7 Emergency
Tel: +33 5 49 75 75 75
Fax: +33 5 49 34 75 66
email: DAS@ima.eu', '+33 5 49 34 79 71', '+33 5 49 34 75 66', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '', '', '', '', '- Normally cover 2nd Class.  If patient requests for private room, they can contact IMA.
- An Estimated cost is needed for guarantee approval', '', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\IMA\Quote for Request of Payment of Medical.doc', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IMG', 'In', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IMG', 'Out', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IMS', 'In', 'info@ims-hk.com', '2851-7218', '2815-4472', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\IMS\LOG sample.pdf', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\IMS_IncorporatedMedicalSystem.tif', '', '', '', '- DO NOT ACCEPT guarantee letter using letter head ''INSURANCE MANAGEMENT SYSTEM LTD''.
- physical check up is not cover (prior approval is required)', to_date(''), '', 'H:\Patient Account\Insurance Card Program\IMS\Pre-Auth Form.pdf', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\IMS.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IMS', 'Out', '2851 4551 Amy Fung / 2851 7218
CUSTOMER SERVICE
2851 7218 Grace Yeung', '', '2815 4472', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\IMS_IncorporatedMedicalSystem.tif', '', '', '1. Plastic Card in White Colour
2. Card Shown "Out-patient" Wordings', '- Check coverage with IMS for Health Examinations, Immunization and Well baby clinic.
- All guarantee should issued by INCORPORATED  MEDICAL SYSTEM LTD.
- DO NOT ACCEPT guarantee letter using letter head ''INSURANCE MANAGEMENT SYSTEM LTD''.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\IMS.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('INC', 'In', 'Ms. Ho - 2861-6492', '2861-6555', '2243-8573', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Refer to AON Consulting', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('INC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ING', 'In', 'healthcare card handling: 2851 5511 during office hours', '2850-3030
2850-3061', '', '', 'No Limit', 200000.0, -1.0, 0.0, 0.0, '', '', 'refer to FWD', '', 'Membership card limit cover to $200,000.  If over, obtain prior approval from ING', 'ING become FWD. All ING cards are replaced by FWD card. If the patient shows ING card, pls ask for the FWD card. If no FWD card, pls call 2851 5511 during office hours for verification. Reject ING cards if it''s non-office hours, or when cannot get through', to_date(''), '', '', 'refer to FWD', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ING', 'Out', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'Outpatient = use AR code : UMP and use UMP voucher (not ING)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ING1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ING1', 'In', 'Claims Hotline: 2851 5533
Healthcare card handling: 2851 5511 during office hours', 'T: 2850 3030  
F: 2850 3031', '', '', '', 0.0, 0.0, 0.0, 0.0, 'refer to FWD', '', 'refer to FWD', '', '- Use ING voucher.
- Not cover Materity.
- No LOG needed.', 'ING become FWD. All ING cards are replaced by FWD card. If the patient shows ING card, pls ask for the FWD card. If no FWD card, pls call 2851 5511 during office hours for verification. Reject ING cards if it''s non-office hours, or when cannot get through', to_date(''), '', '', 'refer to FWD', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IPA', 'In', '', '2851-0620', '2851-0910', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\IPA\Sample - IPA HK LOG.pdf', 'H:Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\IPA_InterPartnerAssistance.tif', '', '', '', '', to_date(''), '', '', '', 'H:\Patient Account\Insurance Card Program\IPA\IPA.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IPA', 'Out', '', '2851 0620', '2851 0910', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Accept:
 1. Policy / Certificate in Paper sheet
 2. Coverage in Japanese Yen Dollar', '- Suggest xerox copy cover page ( showing the policy / certificate name of Sumitomo Marine & Fire Insurance ) for billing purpose.

DO NOT Accept Policy / Certificate if :
1. Coverage in HK$
2. No sickness coverage in Japanese Yen Dollar 
3. No accid', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IPA1', 'Out', 'For GOP & Pre-auth, please contact:
Tel: +44 (0) 1892 503 915  or
+44 (0) 1737 815 197
Fax: +44 (0) 1892 503 787
Email: direct.settlement@axa-ppp.co.uk
Emergency contact IPA HK 
T: +852 2861 9287', 'IPA HK (Medical Team)
2851 0620', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\PPP International\Card samples.pdf', '', '', '', '1. Accept 4 types of card.  Refer to card samples link.
2. Only cover GP (include medication), Lab test, X-ray and Ultrasound.
3. SP, Dental, Rehab treatment - Self Pay
4. DI (e.g CT, MRI) & Minor Surgery - GOP is required (issue by AXA PPP Internation', '1. Patient has to sign HKAH consent (consent for IPA & PPP) and Invoice.
2. Copy membership card for billing.  Invoice send to IPA HK office
3. No claim form needed
4. When patient cannot show medical card, collect payment from patient. If patient insi', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\PPP International\Pre-auth Form to PPP (for outpatient).doc', '', '', -1.0, 'H:\Patient Account\Insurance Card Program\PPP International\IPA_PPPI - Pre-auth Memo to Doctor 20130801.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('IPA1', 'In', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Do Not Accept', 'Inpatient case, please refer to AXA PPP International directly (AR code: PPPI)
GOP is needed. 
*** Temporarily refuse to accept PPPI LOG until further notice
Ask PPPI to contact IPA HK. No need to explain what reason. (21 Nov 2013 NH)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ISOS', 'In', '', '2528-9900', '2528-9933', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ISOS', 'Out', '', '2528 9900', '2528 9933', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\ISOS.tiff', '', 'Accept
1. Policy / Certificate in Paper sheet
2. Coverage in Japanese Yen Dollar', 'Do Not Accept
1. Sickness / Coverage in HK$.
2. No sickness coverage in Japanese Yen Dollar
3. No accident coverage in Japanese Yen Dollar', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ISOSAIU', 'In', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '25289998 HK', '2528 9933 HK', '', '', 0.0, -1.0, -1.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\Exclusions.pdf', '', '', 'DO NOT ACCEPT', 'Contact AIU Japan. 


AIU Insurance Company Ltd., send bill to ISOS.  Lapsed from 19 Dec 2013', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\New Claim Form eff from 1 Jan 2013.pdf', 'H:\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\ISOS Japan.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ISOSAIU', 'Out', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '25289998 HK', '25289933 HK', '', '', 0.0, 0.0, 0.0, 0.0, '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\Exclusions.pdf', '', '', 'DO NOT ACCEPT', 'Contact AIU Japan



- Coverage in Japanese Yen Dollar 
DO NOT Accept Policy / Certificate / Card if:
1. Sickness / Coverage in HK$.
2. No sickness coverage
3. No accident coverage

If policy is a Multiple Trip Insurance policy, check the consul', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\New Claim Form eff from 1 Jan 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ISOSU', 'In', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '25289998 HK', '2528 9933', '', '', 0.0, -1.0, -1.0, 0.0, '', '', '', '', 'Various insurance', 'Pre-Auth / Acknowledge Admission Form:
H:\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\ISOS Japan.doc', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ISOSU', 'Out', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011 (Singapore)
Billing Fax: 3071 3012
HK Hotline: 2528 9900', '25289998 HK', '25289933', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '1. Accept by Letter of Guarantee
2. Refer to Letter of Guarantee for Coverage', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ISUZU', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ISUZU', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Class could be revised if obtained physician report
- Notify of Admission is Needed.', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ITOCHU', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ITOCHU', 'In', 'Ms. Can Lo
Tel: 2861 9705
Fax: 2865 1218
email: can.lo@itochu.com.hk', '', '', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\ITOCHU Hong Kong Ltd\Letter of Guarantee.doc', '', '', '', '', 'use HKAH LOG template', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JAI', 'In', '', '1-305-263-8888
Fax:1-305-263-7579', '1-800-344-0525', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'ended 31-12-2007.
Pay attention to Co-payment
Tried the Tel. No. but not complete, if going to chase the right no. in HK. PCCW in Charge $12.00. Hold.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JAI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JAIC', 'In', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '25289998 HK', '2528 9933', '', '', 0.0, -1.0, -1.0, -1.0, '', '', '', '', '', 'Pre-Auth / Acknowledge Admission Form:
H:\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\ISOS Japan.doc', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JAIC', 'Out', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '25289998 HK', '25289933 HK', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Accept Policy / Certificate / Card :
- Policy / Certificate in Paper sheet
- Coverage in Japanese Yen Dollar (yen)', 'DO NOT Accept Policy / Certificate / Card if :
1. Sickness / Coverage in HK$.
2. No sickness coverage in Japanese Yen Dollar 
3. No accident coverage in Japanese Yen Dollar', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JCOLS', 'Out', 'Kim Conrad Bertin - Area Medical Advisor 
Tel: 6133 7666
Val Don Hawks - Mission President
Tel: 6030 7640
Billing issues: Financial Secretary 
Office: (852) 2337 7584
Mobile: 9674 6254
FAX: 2546-4148', '2910 2970 Derek Au', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '1. Check card expiry date.
2. Copy HKID/Passport & Medical card for billing.', '1. Starting from Aug 2014, all church members have Aetna Card. Please refer to Aetna. 
2. If the member cannot show Aetna card or Aetna cannot provide letter of authorization/ LOG, we can ask the church for LOG and bill the church.
3. If patient forgets', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JCOLS', 'In', 'Kim Conrad Bertin - Area Medical Advisor 
Tel: 6133 7666
Val Don Hawks - Mission President
Tel: 6030 7640
Billing issues: Financial Secretary 
Office: (852) 2337 7584
Mobile: 9674 6254
FAX: 2546-4148', '2910 2970 Derek Au', '', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', '', '', '', '1. Check card expiry date.
2. Copy HKID/Passport & Medical card for billing.
3. No class limit, also cover for ALL personal expenses.', '1. Starting from Aug 2014, all church members have Aetna Card. Please refer to Aetna. 
2. If the member cannot show Aetna card or Aetna cannot provide letter of authorization/ LOG, we can ask the church for LOG and bill the church.
3. If patient forgets', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JD', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JD', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JIA1', 'In', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '', 'Fax +852 2735-2256', '', '', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\Card face\JI card sample.doc', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 'do not accept', '- Outpatient case handled by JIA and use JIA form.
- Inpatient case handled by Wellbe and use Well Be form.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JIA1', 'Out', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '2734 9333', '2735 2256', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Card face\JI card sample.doc', '', '', '', 'Accept Policy / Certificate / Card with :
 1. JI Logo & "Overseas Travel Accident Insurance" wordings
 2. Policy/ Certificate in Paper with JI Wordings', 'May cover for pre-existing symptoms if patient obtains a letter from JIA.  Sample attached:
H:\Patient Account\Insurance Card Program\JI Accident\Letter for treatment of pre-existing symptoms.pdf
DO NOT Accept Policy/ Certificate/ Card if :
 1. Sicknes', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JSR', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Class could be revised if obtained physician report
- Notify of Admission is Needed.', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JSR', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '', '- accept +180days case.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JSS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('JSS', 'In', '', '2840-8888', '2524-8001', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('KIRIN', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Not cover Physical Therapy and Dental check up', '- Accept card in white / green color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('KIRIN', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limited to Semi-private class (2 beds).
- Accept card in white / green color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('KUCG', 'Out', '9196-2268 (Emergency)', '2832-7866', '2832-7028 / 25727444', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Consulate General of The State of Kuwait\Name List_Kuwait_20141231.pdf', '', '', '', '1-6-2014 to 31-12-2014 name list:
H:\Patient Account\Insurance Card Program\Consulate General of The State of Kuwait\Name List_Kuwait_20140808.pdf', '- Check Name List
- HKAH consent form is required
- Please ask patient to sign on bill (we need to send patient''s signature to KUCG)
- For OP Billing : DO NOT send diagnosis label.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('KUCG', 'In', '9218-4960 Ms Josephine Cheung  (Emergency) (Revised Date:17/11/2011)', '2832-7866 
Miss Josephine Leung', '2832-7028 / 25727444', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Consulate General of The State of Kuwait\Name List_Kuwait_20141231.pdf', '', '', '', '1-6-2014 to 31-12-2014 name list:
H:\Patient Account\Insurance Card Program\Consulate General of The State of Kuwait\Name List_Kuwait_20140808.pdf', '- Check Name List
- HKAH consent form is required (for OP case)
- Please ask patient to sign on bill (we need to send patient''s signature to KUCG)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('KYOEI', 'Out', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '25294401', '25292509 main', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '- Accept Policy / Certificate / Card in Japanese Yen Dollars with Sickness benefit.
- Bill to TOKIO Marine, use TOKIO Marine claim form.', 'DO NOT Accept if :
1. Sickness / Coverage in HK$.
2. No sickness coverage in Japanese Yen Dollar 
3. No accident coverage in Japanese Yen Dollar', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Tokio Marine\KYOEI form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('KYOEI', 'In', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '2529-4401 Tokio Marine', '25292509 main', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', '', '', '', 'Accept Policy / Certificate / Card in Japanese Yen Dollars with Sickness benefit.', 'Main Contract: Tokio Marine
DO NOT Accept if :
1. Sickness / Coverage in HK$.
2. No sickness coverage in Japanese Yen Dollar 
3. No accident coverage in Japanese Yen Dollar', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Tokio Marine\KYOEI form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('LII', 'Out', '', '2892 3888', '', '', 'No Limit', 250000.0, 0.0, -1.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Voucher.pdf', '', 'Separate agreement signed for Health Assessment. LOG is needed and sample as below:
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Health Assessment\LOG sample.pdf', '- Contract mainly for Inpatient
- Letter of Guarantee is required.
- ask patient to sign HKAH consent.
- Refer to Letter of Guarantee for coverage.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Outpatient Claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('LII', 'In', '', '2892-3888', '2577-9578', '', 'No Limit', 250000.0, 0.0, -1.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Voucher.pdf', '', '- White Card imprinted with "Hospital Card".
- accept new plastic Blue card (starting 1-July-2009) embossed with "Hospital".', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Inpatient Claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('LII2', 'In', '', '2892-3888', '2577-9578', '', 'No Limit', NULL, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Voucher.pdf', '', '- new Blue plastic card (starting 1-July-2009) embossed with "Hospital".
- old White card can be used until card expired.', '- Accept either LOG or Insurance Card
- Max coverage for insurance card: $200,000
- LOG required for medical check up with guaranteed amt stated on LOG', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Inpatient Claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('LII2', 'Out', '', '2892-3888', '2577-9578', '', 'No Limit', NULL, 0.0, -1.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Voucher.pdf', '', 'Separate agreement signed for Health Assessment. LOG is needed and sample as below:
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Health Assessment\LOG sample.pdf', '- Contract mainly for Inpatient.
- Letter of Guarantee is required.
- ask patient to sign HKAH consent.
- Refer to Letter of Guarantee for coverage.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Liberty International\Outpatient Claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MABS', 'Out', '86 10 84475966', '', '86 10 84475662', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Mondial Assistance (Beijing) Services Co Ltd\LOG samples (Eng_Chi).pdf', '', '', '', 'do not accept', '- contract signed for In patient only.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MABS', 'In', 'Operating Team 
Tel: 86 10 8535 5588
Fax: 86 10 8535 5150
medical.ops@allianz-assistance.com.cn', '86 10 8535 5588', '86 10 8535 5662', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Mondial Assistance (Beijing) Services Co Ltd\LOG samples (Eng_Chi).pdf', '', '', '', '- Former Name: Mondial Assistance (Beijing) Services Co., Ltd
- Invoice fax or email to 86 10 8535 5150 / medical.ops@allianz-assistance.com.cn
- Then mail out original bill.
- List Mondial file number MAC008xxxx on invoice.', '- contract signed for In patient only.
- For outpatient case, please ask patient to sign HKAH consent form.
- Admin procedures: (for reference only) 
H:\Patient Account\Insurance Card Program\Mondial Assistance (Beijing) Services Co Ltd\Admin Procedure', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MACG', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Consulate General of Malaysia\Guarantee letters.doc', '', '', '', 'Courtesy Company, agree to send bill', 'HKAH consent is required', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MACG', 'In', '', '2821-0808', '2865-1628', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Consulate General of Malaysia\Guarantee letters.doc', '', '', '', 'Confirm the staff ID, they could send bill without any guarantee fax on every case. As Confirmed with Mr Chong Chin Hok.', 'No LOG is required.  
Pls contact Consulate office to check the patient eligibility.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MAIG', 'Out', 'HK 24/7 Hotline: +852 3106 7516 
France Hotline: +33 177 680169
France Fax: +33 177 680168
aplus@medical-administrators.com
For emergency, can contact MAI G.M - Mr. Osman Lee 6113 0225', '(852) 3106 7555', '(852) 2529 9200', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Medical Administrators International (MAI)\goldpass card holder for Direct Billing.pdf', '', '', '- Gold card with MAI logo is acceptable. If any unclear, pls contact MAI to clarify.
- Request Medication Breakdown', '- HKAH consent is needed.
- Patient has to sign Claim Form also.
- check policy duration date (expiry date)
- If patient not bring card, please ask patient to pay.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Medical Administrators International (MAI)\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MAIG', 'In', 'HK 24/7 Hotline: +852 3106 7516 
France Hotline: +33 177 680169
France Fax: +33 177 680168
aplus@medical-administrators.com
For emergency, can contact MAI G.M - Mr. Osman Lee 6113 0225', '(852) 3106 7555', '(852) 2529 9200', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Medical Administrators International (MAI)\LOG Sample.pdf', '', '', '', '', 'Cost Estimation Form
H:\Patient Account\Insurance Card Program\Medical Administrators International (MAI)\Cost Estimate Form.pdf', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Medical Administrators International (MAI)\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MAIW', 'In', 'HK 24/7 Hotline: +852 3106 7516 
France Hotline: +33 177 680169
France Fax: +33 177 680168
aplus@medical-administrators.com
For emergency, can contact MAI G.M - Mr. Osman Lee 6113 0225', '(852) 3106 7555', '(852) 2529 9200', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Medical Administrators International (MAI)\LOG Sample.pdf', '', '', '', '', 'Cost Estimation Form
H:\Patient Account\Insurance Card Program\Medical Administrators International (MAI)\Cost Estimate Form.pdf', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Medical Administrators International (MAI)\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MAIW', 'Out', 'Tel: (852) 3516 8181
Fax: (852) 2529 9200
France Hotline: +33 177 680169
France Fax: +33 177 680168
aplus@medical-administrators.com', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'Patient have to self-pay.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MANUL', 'Out', 'Customer Service : 21081388 (for checking guaranteed amount)', 'DBS Card Center 
2573 2272
Manulife 2510 5600 (main)', 'Manulife 2234 5371', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Manulife Mediplus - Outpatient Voucher.pdf', '', 'If obtain "Med code" by DBS hotline
1. Call 2573 2272 DBS card center
2. Merchant code: 002-0-28639599
3. 索取 "Med code" 
Accept Mediplus DBS Credit Card:
 1. Credit Card (Visa/Mastercard) issued by DBS Bank
 2. The Credit Card Holder''s name = pati', 'Steps in Receiving The MediPlus Card:
1. Check the Card
2. Sweep the credit card through DBS Dial Terminal
3. Get Authorisation code from the terminal
4. Use ''Mediplus'' claim voucher (with Manulife and DBS bank name), write down the authorisation (med', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MANUL', 'In', 'DBS Card Center 2573 2272
Manulife 2510 5600 (main)
Customer Service : 21081388 (for checking guaranteed amount)', '2108 1388', 'Manulife 22345371', '', 'No Limit', 250000.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Manulife Mediplus - Inpatient Voucher Dec 2013.pdf', '', 'If obtain "Med code" by DBS hotline
1. Call 2573 2272 DBS card center
2. Merchant code: 002-0-28639599
3. 索取 "Med code"', '- Approval code (''MED'' code) must obtained when patient discharge and mark on voucher.  Use Dao Heng Credit machine (store in the carbinet besides Neville desk). 
- Imprint "Mediplus" voucher.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\DBS - Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MANUL1G', 'Out', 'Customer Service : 21081388 (for checking guaranteed amount)', '2510 5600 (main)', '2234 5371 (main fax)', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\MANULIFE.doc', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Outpatient voucher.pdf', '', 'Accept Card :  
1. Plastic Card in Gold Color (with or without expiry date)
2. Card printed with "Hospital & Outpatient Care" or "Outpatient Care" Wordings
3. HKAH will NOT monitor the gold card embossed ''MA86'', for minor-operation / physio not accepta', '- DO NOT pass blank voucher (without amount) to patient to sign.
- Patient has to countersign the voucher if the amount has been revised
- Imprint insurane card clearly on voucher
- Xerox card for billing purpose

Do not accept card in :
1. Silver C', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MANUL1G', 'In', 'Customer Service : 21081388 (for checking guaranteed amount)', '2510-5600 (main)', '2234-5371 (main fax)', '', 'No Limit', 250000.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\MANULIFE.doc', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Inpatient voucher.pdf', '', '1. Attend to the limit marked on Card: Gold covers for 250K.
2. Please check Void List.
3. Card with "Hospital  & Out-Patient Care" or "Hospital Care".
4. Imprint voucher', 'For City University, there is no limit if "250K" not marked on card.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Claim form 20130130.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MANUL1S', 'Out', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MANUL1S', 'In', 'Customer Service : 21081388 (for checking guaranteed amount)', '25105600 (main)', '2234-5371 (main)', '', 'No Limit', 50000.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Inpatient voucher.pdf', '', '1. Pay attention to coverage. Silver card card marked with "50K" covers for 50,000.00
2. Accept card with "Hospital Care" or "Hospital & Out-Patient Care" wordings', 'For Company Name "City University", there is no limit if "50K" not marked on card.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Claim form 20130130.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MANULI', 'In', '2510-5904 Brenda
Customer Service : 21081388 (for checking guaranteed amount)', '2108-1188 (service)
2510-5600 (main)', '2234-5371 (main fax)', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\MANULIFE.doc', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Inpatient voucher.pdf', '', 'Different limition specified on Guarantee letter
Patient will bring the claim form with guarantee letter for admission', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Manulife\Claim form 20130130.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MANULI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MAPFRE', 'In', 'Mr. Wing Chan 
Tel: 3906 7000
Fax: 3906 7067
ops.hk@mapfre.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\MAPFRE Asistencia Limited\LOG sample.pdf', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MAPFRE', 'Out', 'Mr. Wing Chan 
Tel: 3906 7000
Fax: 3906 7067
ops.hk@mapfre.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\MAPFRE Asistencia Limited\LOG sample.pdf', '', '', '', '', '1. sign HKAH consent form
2. No medical report is needed.  Diagnosis label is enough.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MASA', 'Out', '', '2838 4747 MR. HUI', '2836 5186', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Do not accept', '1. Suggest Xerox copy the insurance card for billing purpose.
2. Request patient to sign on claim document ( if any )
3. Request patient to sign on Statement.
4. Refer to Letter of Guarantee for coverage', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MASA', 'In', '', '2838-4747', '2836-5186', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MAUSA', 'In', 'Pre-Auth Fax: +1 804 673 1510  OR
email: Assistance.Group@allianzassistance.com
24/7 +1 804 673 1177', '+1 804 673 7179', '+1 804 281 5713', '', '', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Mondial Assisatnce USA\Allianz Global Assistance GOP sample (Dec 2012).pdf', '', '', '', 'LOG must states the exchange rate or in HKD', 'From 1 Jan 2013, no longer handle BlueCross BlueShield cases or FEP cases
1. for Blue Card Worldwide program (BCWW)
2. Former name: Mondial Assistance USA c/o World Access Ser Corp
- For DAY CASE, if no LOG received on/before admission, please collect ', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Mondial Assisatnce USA\Allianz Global Assistance.doc', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MAUSA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'do not accept', '- contract signed for In patient only.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MCPPO', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MCPPO', 'In', '', '671-649-5387/8/9
671-649-5390/91', '671-649-5386', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '', '', '', '', 'USD 5.00 Co-payment required for Outpatient services', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MEDILINK', 'Out', 'CS Tel: 800 930 249 email: customerservice@medilink-global.com.cn
Mr Peter Li  (Provider Relations)
Tel: (8610) 8453 9718 ext 113
xin.li@medilink-global.com.cn', '24 hotline: 800 930 249 OR (8610) 6552 5312/5313', '(8610) 8453 9719', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\Medilink Global Card Samples 20120103.pdf', '', '', '', '- Request Medication Breakdown
	- Accept by Guarantee Letter (PRE-NOTIFICATION LETTER) together with Insurance card with "MediLink-Global" logo.
- copy insurance card with MediLink-Global logo for billing purpose
- Outpatient Claim Form is required', '1. LOG sample:
H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\LOG Sample.pdf
2. Cost Estimation Form:
H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\Cost Estimation Form.pdf', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\Pre-authorization Form.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\Medilink OP Claim Form Jan 2013.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\Pre-auth Memo to Doctor (for outpatient 20111011).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MEDILINK', 'In', 'CS Tel: 800 930 249 email: customerservice@medilink-global.com.cn
Mr Peter Li  (Provider Relations)
Tel: (8610) 8453 9718 ext 113
xin.li@medilink-global.com.cn', '24 hotline: 800 930 249 OR (8610) 6552 5312/5313', '(8610) 8453 9719', '', '', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\Medilink Global Card Samples 20120103.pdf', '', '', '', '- Claim form is not required for Inpatient case.
- Medication breakdown is required for billing purpose.
- Copy insurance card with MediLink-Global logo for billing purpose', '1. LOG sample:
H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\LOG Sample.pdf
2. Cost Estimation Form:
H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\Cost Estimation Form.pdf', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Medilink (Beijing) TPA Services Co., Ltd\Pre-authorization Form.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MEID', 'IN', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MEID', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MERC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MERC', 'In', 'Ceylinco Insurance Sri Lanka', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do not Accept', 'ALERT CASE
Previous claim was totally rejected. Gtd fax was received, bill has sent to MIAC for over 2 years and was rejected due to pre-existing illnesses. Tried to contact patient and his insurance company, both won''t acknowledge the debt.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MGS', 'Out', '24 hrs emergency contact
Toll free: 800 96 4421
email: operations@frontiermedex.com

Mr. Harry Cashy - Senior Resource 
Dev. Specialist
Toll Free: +1 800 527 0218
Direct: +1 410 453 6313 
email: Harry.Cashy@Frontiermedex.com', '+1 410 453 6330 (main)', '+1 410 453 6331', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\MEDEX Global Solutions\Sample GOP.pdf', '', '', '', 'DO NOT ACCEPT', '- Former Name:  MEDEX Global Group, Inc. T/A MEDEX Global Solutions
- HKAH consent is needed.
- Invoice can fax to +1 410 453 6301.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MGS', 'In', '24 hrs emergency contact
Toll free: 800 96 4421
email: operations@frontiermedex.com

Mr. Harry Cashy - Senior Resource 
Dev. Specialist
Toll Free: +1 800 527 0218
Direct: +1 410 453 6313 
email: Harry.Cashy@Frontiermedex.com', '+1 410 453 6330 (main)', '+1 410 453 6331', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\MEDEX Global Solutions\Sample GOP.pdf', '', '', '', 'DO NOT ACCEPT', '- Former Name:  MEDEX Global Group, Inc. T/A MEDEX Global Solutions
- contract for IN and OUT.
- Invoice can fax to +1 410 453 6301.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MIC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MIC', 'In', '', '853-28555078', '853-28551074', '', 'No Limit', 60000.0, 0.0, -1.0, 0.0, '', '', '', '', 'Limit up to $80,000.00 including physician charges, any balance over limit amount should be borne by the patient', 'Forenamed Macau life Insurance Co - MLC', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MIT', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- not cover dental check up
- Cover dental treatment 	
- Cover Physical Therapy (with Dr referral letter)', '- Accept card in white / green color with Prestige logo
- *For Vaccination: refer to the list of claimable items.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MIT', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Accept card in white / green color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITA', 'In', '', '2424-6129', '2480-4244', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Do not Accept', '09/08/2007 Ms Wong returned call and asid the contract terminated as instructed by their Admin
Ms Wong 24235121', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITSU', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITSU', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITSUI', 'Out', '28238778 Miss Lisa Yu
Li.Yu@mitsui.com', '', '', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Mitsui & Co (HK) Ltd\Name List as of August 2014.pdf', '', '', '', 'DO NOT ACCEPT', '- HKAH consent is required', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITSUI', 'In', '28238778 Miss Lisa Yu
Li.Yu@mitsui.com', '', '2861-0382', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Mitsui & Co (HK) Ltd\Name List as of August 2014.pdf', '', '', '', 'cover "ALL" expenses', 'check name list.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITSUISU', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', 'NOT Cover the following (refer exclusion comparison table) :
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive vaccine.
Accept Policy / Certificate / Card :
- Policy / Certificate in Paper sheet
- Coverage in Japanese', '- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.
- DO NOT Accept Policy / Certificate / Card if :
1. Sickness / Coverage in HK$.
2. No sickness ', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form OTAI 20130326.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITSUISU', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limited to Standard class
Do Not Accept insurance of ''MITSUI SUMITOMO INSURANCE'' issued in Hong Kong (no agreement with this insurance company).', '- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.
Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co L', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form OTAI 20130326.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form - standard room.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MITSUITOMO', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'ALERT CASE', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MLC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MLC', 'In', '', '2828-8399', '2828-3733', '', 'No Limit', 150000.0, 0.0, -1.0, 0.0, '', '', '', '', 'Limitation excludes Dr''s fees', '', to_date(''), '', '', '\\hkim\PA Share\Patient Account\Insurance Card Program\Voucher - IPD\MLC.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MLUS', 'In', 'Contact person: Carmen Chiang Please send bills to Ms Chiand then forward to USA.', '2536-3888', '2480-4244', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '\\hkim\PA Share\Patient Account\Insurance Card Program\Voucher - IPD\MERRILL.doc', '', 'DO NOT ACCEPT', 'Deductible US $200.00 depends on the policy
ended 31-7-2007.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MLUS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MMA', 'In', '(852) 2919 9137 MR. VINCENT CHU

Customer Service:
ebinfo@massmutualasia.com', '2919-9111 (Main)', '2919-9233', '', 'No Limit', 200000.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Mass Mutual\Voucher.pdf', '', '- Maximum limit HK$200,000 includes Dr''s fees.
- Accept Orange card with or without "Medpass" Logo.', '- DO NOT Accept plastic card in blue color.
- For Inpatient, Card must with "IP" wordings
- For Maternity, Card must with "MAT" wordings', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Mass Mutual\Claim Form 20130124.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MMA', 'Out', '(852) 2919 9137 MR. VINCENT CHU

Customer Service:
ebinfo@massmutualasia.com', '2919-9111 (Main)', '2919 9233', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Mass Mutual\Voucher.pdf', '', '- DO NOT Accept Plastic card in blue color', '- Accept Card in Orange Colour, with or without "Medpass" Logo.
- Card MUST embossed with PHOP wordings
  (PHOP = Private Hospital Outpatient Consultation )', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MOB', 'In', '', '33-142-81-9700', '33-149-95-0767', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', ' (Please refer to MSH China Enterprise Service Co., Ltd.)  
AR code:  MSHC', 'Forenamed: Previnter / European Benefits Administrator
 (Please refer to MSH China Enterprise Service Co., Ltd.)  
AR code:  MSHC', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MOB', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MOFA', 'Out', 'Toll  Free: 1-800-231-7729 (24/7)
press 2 (for medical provider)
email: InternationalProviderClaims@aetna.com', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Aetna\Aetna - MOFA Saudi Arabia\Membership List-MOFA-Hong Kong.xls', '', '', '', 'DO NOT ACCEPT', '<EXPIRED on 20 Jul 2013>

1. No claim form, sign HKAH consent
2. Accept e-billing  InternationalProviderClaims@aetna.com
3. LOG sample:
H:\Patient Account\Insurance Card Program\Aetna\Aetna - Nomura\Letter of Authorization.pdf

1. Cover upto US$500', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MOFA', 'In', 'Toll  Free: 1-800-231-7729 (24/7)
press 2 (for medical provider)
email: InternationalProviderClaims@aetna.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Aetna\Aetna - Nomura\Letter of Authorization.pdf', '', '', '', 'DO NOT ACCEPT', '<EXPIRED on 20 Jul 2013>

1. Pre-Auth Form:
H:\Patient Account\Insurance Card Program\Aetna\Pre-certification Medical form.pdf
2. Accept e-billing  InternationalProviderClaims@aetna.com', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MSHC', 'Out', 'Pre-Auth / LOG:
24 hrs hotline: +86 21 6187 0220 / 
+86 800 820 5102/ +86 21 6187 0330
Fax: +86 21 6160 0209
email: medical@mshasia.com

JoJo Sun 
Tel: +86 20 8336 0116 ext. 802  
email: Jojosun@mshchina.com', '+86 21 6187 0220', '+86 21 6160 0209', '', '', 0.0, 0.0, -1.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\MSH China\MSH Guideline & Card Samples.pdf', '', '', '', '1. Must ask patient to sign on both invoice & claim form.
2. Copy patient''s insurance card (if available).', '1. Card shows "MSH China" logo or "MSH International".  Do not accept if it is only "MSH".
2. If  there is indication "HK OP & IP" at right bottom, no need LOG
3. Check card expiry date.
4. Collect co-pay and deductable if any.  Amount shows on card is', to_date(''), '', 'H:\Patient Account\Insurance Card Program\MSH China\MSH Pre-authorization Form.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\MSH China\Claim Form Dec 2013.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\MSH China\MSHC- Pre-auth Memo to Doctor.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MSHC', 'In', 'Pre-Auth / LOG:
24 hrs hotline: +86 21 6187 0220 / 
+86 800 820 5102/ +86 21 6187 0330
Fax: +86 21 6160 0209
email: medical@mshasia.com

Dr. JoJo Sun 
Tel: +86 20 8336 0116 ext. 802  
email: Jojosun@mshchina.com', '+86 21 6187 0220', '+86 21 6160 0209', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\MSH China\LOG Samples.pdf', '', '\\hkim\pa share\Patient Account\Insurance Card Program\MSH China\MSH Guideline & Card Samples.pdf', '', '** 1. Must ask patient to sign on both invoice & claim form.
   2. Copy patient''s insurance card (if available).
   3. LOG either from "MSH International" & "Mobility Saint Honore" is acceptable.', '- Ask patient for insurance card (if available) to check the identity
- Claims dept: claims@mshasia.com
- Card Sample can refer to "Voucher"', to_date(''), '', 'H:\Patient Account\Insurance Card Program\MSH China\MSH Pre-authorization Form.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\MSH China\Claim Form Dec 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MSIG', 'OUT', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MSIG', 'IN', 'Mon-Fri  0900 to 1730
Roseanna Yim (tel: 2894 0772,  Fax: 2902 9119,  roseanna_yim@hk.msig-asia.com)
Winnie Yip (tel: 2894 0605, fax: 2902 9119,  winnie_yip@hk.msig-asia.com)

After Office Hours:
Mr Gary Kwok  6187 0826
Ms Suki Ko  9703 1786', 'main tel: 2894 0555', 'main fax: 2890 5741', '', '', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\MSIG\Letter of Guarantee.pdf', '', '', '', '- LOG will be issued prior admission, or within 24hours of notificaton of an emergency.', '1. Patient signs ''Letter Of Indemnity''.
H:\Patient Account\Insurance Card Program\MSIG\Letter of Indemnity.pdf
2. Claim form only has 4 pages.
3. Not cover Medical Report, extra meal, newspaper, long-distance call, routine physical check up/test & pers', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\MSIG\InpatientClaimForm_201307.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MSIGP', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', 'NOT Cover the following (refer exlcusion comparison table) :
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive vaccine.', '- Accept card in white / blue color with Prestige logo
-	 Cover Physical Therapy (with Dr referral letter)', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MSIGP', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table Oct 2014.pdf', '', '', '- Limited to Standard class
- Accept card in white / blue color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form - standard room.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MUFG', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MUFG', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary--
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MURATA', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Accept card in white / green color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MURATA', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '- Accept card in white / green color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MYTS', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '-	 Cover Physical Therapy (with Dr referral letter)
NOT Cover the following (refer exlcusion comparison table) :
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive vaccine.', '- Accept card in white / blue color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('MYTS', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limited to Standard class
- Accept card in white / blue color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form - standard room.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NAXIS', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limited to Standard class', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form - standard room.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NAXIS', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- 	Cover Physical Therapy (with Dr referral letter)
NOT Cover the following (refer exclusion comparison table) :
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive vaccine.', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NC', 'In', '', '2827-8813', '2827-8892', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NEC', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NEC', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Not cover Physio', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NESHK', 'In', '', '2859-6333', '2858-6427', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', 'Updated fax number   6/3/09/leo', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NESHK', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NEW', 'In', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '', '2528 9933', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\ISOS.tiff', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NEW', 'Out', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '', '25289933', '', '', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\ISOS.tiff', '', '', 'DO NOT Accept Policy / Certificate / Card if :

Accept Policy / Certificate / Card :
- Policy / Certificate in Paper sheet
- Coverage in Japanese Yen Dollar (yen)

1. Sickness / Coverage in HK$.
2. No sickness coverage in Japanese Yen Dollar 
3. N', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NEWZ', 'In', '', '2525-5044', '', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NEWZ', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NFCL', 'Out', 'Mr. Danny Chow', '3406 6888', '2664 2201', '', '', 0.0, 0.0, 0.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Nissin Group\Consent Forms\Patients with Consent Form.xls', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\CLAIM FORM SAMPLE.pdf', '', '', '1. Check if patient has PERMANANT CONSENT FORM in the name list. 
2. If yes --> nomal registration; if no, ask patient to sign HKAH standard consent form
3. Use the Tokio Marine Claim Form
Billing Team: please pass the HKAH consent form (one visit) to ', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\TMF OTAI claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NFCL', 'In', 'Mr. Danny Chow', '3406 6888', '2664 2201', '', '', 0.0, 0.0, 0.0, -1.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Nissin Group\Consent Forms\Patients with Consent Form.xls', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\CLAIM FORM SAMPLE.pdf', '', 'Maternity, Dietician is NOT covered
DEFAULT GENERAL WARD, In case need involuntary upgrade, still admit the patient but downgrade back to general ward once available.', '1. Check if patient has PERMANANT CONSENT FORM in the name list. 
2. If yes --> nomal registration; if no, ask patient to sign HKAH standard consent form
3. Use the Tokio Marine Claim Form
4. If patient see OP then IP, use claim form for EACH.
Billing', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\TMF OTAI claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NFMCL', 'In', 'Mr. Danny Chow', '3406 6888', '2664 2201', '', '', 0.0, 0.0, 0.0, -1.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Nissin Group\Consent Forms\Patients with Consent Form.xls', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\CLAIM FORM SAMPLE.pdf', '', 'Maternity, Dietician is NOT covered
DEFAULT GENERAL WARD, In case need involuntary upgrade, still admit the patient but downgrade back to general ward once available.', '1. Check if patient has PERMANANT CONSENT FORM in the name list. 
2. If yes --> nomal registration; if no, ask patient to sign HKAH standard consent form
3. Use the Tokio Marine Claim Form
4. If patient see OP then IP, use claim form for EACH.
Billing', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\TMF OTAI claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NFMCL', 'Out', 'Mr. Danny Chow', '3406 6888', '2664 2201', '', '', 0.0, 0.0, 0.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Nissin Group\Consent Forms\Patients with Consent Form.xls', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\CLAIM FORM SAMPLE.pdf', '', '', '1. Check if patient has PERMANANT CONSENT FORM in the name list. 
2. If yes --> nomal registration; if no, ask patient to sign HKAH standard consent form
3. Use the special Tokio Marine Claim Form.
4. Billing Team: please pass the HKAH consent form (on', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\TMF OTAI claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NGFSS', 'In', '', '904-906-2985
904-571-0847', '904-908-5871', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Entitle 2nd class including personal items', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NGFSS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NHI', 'In', 'Request LOG: asiapacclinical@now-health.com
Tel: 2279 7310 (Mon-Fri, 9-6pm)
Tel: 2279 7380 (out of office hr, non emergency)
Tel: 2279 7340 (24hrs emergency by AXA Assistance)

Mr. Kevin Liu 
T: 2279 7316  M: 9266 0577
kevin.liu@now-health.com', '2279 7310', '2279 7330', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Guideline 20140217.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Now Health Exclusion list 20130125.pdf', '', '', '1. Cover Semi-private unless specify in LOG.
2. Submit medication breakdown for billing.', '1. LOG is a must for inpatient.
2. LOG sample
H:\Patient Account\Insurance Card Program\Now Health\Guarantee of Payment-Word doc - Asia Pacific Feb 2012.pdf', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Now Health\Pre-authorisation Form.pdf', 'H:\Patient Account\Insurance Card Program\Now Health\WorldCare provider claim form Asia Sept 2014.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NHI', 'Out', 'Request LOG: asiapacclinical@now-health.com
Tel: 2279 7310 (Mon-Fri, 9-6pm)
Tel: 2279 7380 (out of office hr, non emergency)
Tel: 2279 7340 (24hrs emergency by AXA Assistance)

Mr. Kevin Liu
T: 2279 7316  M: 9266 0577
kevin.liu@now-health.com', '2279 7310', '2279 7330', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Guideline 20140217.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Now Health Exclusion list 20130125.pdf', '', '', '- Card must shows "Out-Patient Direct Billing" in top right corner AND
 "NOW Health International" logo.
- more card 
- Cover Maternity if "Direct billing for Maternity" shows on card
3. Check card expiry date.
4.Outpatient Excess only applies to the', '1. LOG sample:
H:\Patient Account\Insurance Card Program\Now Health\Guarantee of Payment-Word doc - Asia Pacific Feb 2012.pdf', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Pre-authorisation Form.pdf', 'H:\Patient Account\Insurance Card Program\Now Health\WorldCare provider claim form Asia Sept 2014.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Now Health\Now Health - Pre-auth Memo to Doctor 20131203.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NHI1', 'In', 'Request LOG: asiapacclinical@now-health.com
Tel: 2279 7310 (Mon-Fri, 9-6pm)
Tel: 2279 7380 (out of office hr, non emergency)
Tel: 2279 7340 (24hrs emergency by AXA Assistance)

Mr. Kevin Liu 
T: 2279 7316  M: 9266 0577
kevin.liu@now-health.com', '2279 7310', '2279 7330', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Guideline 20140217.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Now Health Exclusion list 20130125.pdf', '', '', '1. Cover Semi-private unless specify in LOG.
2. Submit medication breakdown for billing.', '1. LOG is a must for inpatient.
2. LOG sample
H:\Patient Account\Insurance Card Program\Now Health\Guarantee of Payment-Word doc - Asia Pacific Feb 2012.pdf', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Pre-authorisation Form.pdf', 'H:\Patient Account\Insurance Card Program\Now Health\WorldCare provider claim form Asia Sept 2014.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NHI1', 'Out', 'Request LOG: asiapacclinical@now-health.com
Tel: 2279 7310 (Mon-Fri, 9-6pm)
Tel: 2279 7380 (out of office hr, non emergency)
Tel: 2279 7340 (24hrs emergency by AXA Assistance)

Mr. Kevin Liu
T: 2279 7316  M: 9266 0577
kevin.liu@now-health.com', '2279 7310', '2279 7330', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Guideline 20140217.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Now Health Exclusion list 20130125.pdf', '', '', '<Must have "KPMG" on top left corner>
1. Card must shows "Out-Patient Direct Billing" in top right corner AND
 "NOW Health International" logo.
2. Cover Maternity if "Direct billing for Maternity" shows on card
3. Check card expiry date.
4.Outpatient', '1. LOG sample:
H:\Patient Account\Insurance Card Program\Now Health\Guarantee of Payment-Word doc - Asia Pacific Feb 2012.pdf', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Now Health\Pre-authorisation Form.pdf', 'H:\Patient Account\Insurance Card Program\Now Health\WorldCare provider claim form Asia Sept 2014.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Now Health\Now Health - Pre-auth Memo to Doctor 20131203.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPE', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Accept Card in White and Blue color
- Accept Card printed with Prestige International wordings (even though card expired) or
- Accept Card printed with Prestige logo (started Aug 2009).
- At right top corner, a logo of Nipponkoa is printed.  DO NOT b', '- 3 Aug 2009, as per PIHK, if this old card expired (no matter what expiry date), please provide Cashless (send bill) service.
- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not ', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPE', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical (with Dr referral letter)
Accept Card:
- Card in White and Blue color
- Card printed with Prestige International wordings (even though the card expired) or
- Card printed with Prestige logo (started Aug 2009).', '- 3 Aug 2009, as per PIHK, if this old card expired (no matter what expiry date), please provide Cashless (send bill) service.
- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not ', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPE1', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '2868-0612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- At right top corner, a logo of Nipponkoa is printed.  DO NOT bill Nipponkoa (NIC). Should bill PIHK and use PIHK claim form.
- Limits to Semi-private class (2 beds).
- Accept card in white / yellow color with Prestige logo', '- 3 Aug 2009, as per PIHK, if this old card expired (no matter what expiry date), please provide Cashless (send bill) service.
- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not ', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPE1', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical (with Dr referral letter)
- At right top corner, a logo of Nipponkoa is printed.  DO NOT bill Nipponkoa (NIC). Should bill PIHK and use PIHK claim form.', '- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.
- Accept card in white / yellow color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPI', 'In', 'Ms. Joanna Liu : 2841 9977
Mr. Richard Ho: 2841 9930
Ms. Kato Ayako 2841 9910 (Japanese speaker)', '2524 0036
2521 2482', '2868 4413, 2868 1997', '', 'No Limit', 50000.0, 0.0, 0.0, -1.0, '', '', '', '', 'DO NOT ACCEPT', '- Limit up to $50,000
- Patient must sign on original claim form. Fax copy would not be accepted by ins company.
Entitled up to 2nd & 3rd Class Only
No need to disclose to pt for any covered limit,
Nay exceed of limit, pls contact insurance but pt sho', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Nipponkoa Insurance Company (Asia) Ltd\Claim Form with effect 1 Jul 2013.pdf', 'H:\Patient Account\Insurance Card Program\Nipponkoa Insurance Company (Asia) Ltd\Nipponkoa.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPI', 'Out', 'Ms. Joanna Liu : 2841 9977
Mr. Richard Ho: 2841 9930
Ms. Kato Ayako 2841 9910 (Japanese speaker)', '2524 0036
2521 2482', '2868 4413, 2868 1997', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- Patient must sign on original claim form. Fax copy would not be accepted by ins company.
NOT Cover the following:
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive treatment.
DO NOT Accept Policy / Certificate / Card', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Nipponkoa Insurance Company (Asia) Ltd\Claim Form with effect 1 Jul 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPI1', 'Out', 'Claims Dept:
Mr. Kenix Yu: 2841 9978
Ms Heidi:  2219 5692
Ms. Kato Ayako 2841 9910 (Japanese speaker)', '2831 9980', '2811 5648', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'NOT Cover the following:
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive treatment.', '- Patient must sign 2 signature on original claim form. Fax copy would not be accepted by ins company.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Sompo Japan Nipponkoa (HK) Co Ltd\Claim Form with effect 4 July 2014.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPI1', 'In', 'Claims Dept:
Mr. Kenix Yu: 2841 9978  
Ms Heidi:  2219 5692
Ms. Kato Ayako 2841 9910 (Japanese speaker)', '2831 9980', '2811 5648', '', 'No Limit', 50000.0, 0.0, 0.0, -1.0, '', '', '', '', 'Entitled up to 2nd & 3rd Class Only
No need to disclose to pt for any covered limit,
May exceed of limit, pls contact insurance but pt should not be liable to settle balance until further notice (Fax: 2868 4413)', '- Limit up to $50,000
- Patient must sign 2 signature on original claim form. Fax copy would not be accepted by ins company.
- Acknowledge Admission Form', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Sompo Japan Nipponkoa (HK) Co Ltd\Claim Form with effect 4 July 2014.pdf', 'H:\Patient Account\Insurance Card Program\Sompo Japan Nipponkoa\Sompo Japan Nipponkoa.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPI2', 'Out', 'Claims Dept:
Mr. Kenix Yu: 2841 9978
Ms Heidi:  2219 5692
Ms. Kato Ayako 2841 9910 (Japanese speaker)', '2831 9980', '2811 5648', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Sompo Japan Nipponkoa (HK) Co Ltd\Intergration\Nipponkoa Japan policy sample.pdf', '', '', '', 'NOT Cover the following:
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive treatment.', '- Accept card/cert issued by Japan, coverage in Japanese Yen.  Refer to card/policy sample.
- Patient must sign 2 signature on original claim form. Fax copy would not be accepted by ins company.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Sompo Japan Nipponkoa (HK) Co Ltd\Claim Form with effect 4 July 2014.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NIPI2', 'In', 'Claims Dept:
Mr. Kenix Yu: 2841 9978
Ms Heidi:  2219 5692
Ms. Kato Ayako 2841 9910 (Japanese speaker)', '2831 9980', '2811 5648', '', 'No Limit', 50000.0, 0.0, 0.0, -1.0, 'H:\Patient Account\Insurance Card Program\Sompo Japan Nipponkoa (HK) Co Ltd\Intergration\Nipponkoa Japan policy sample.pdf', '', '', '', 'Entitled up to 2nd & 3rd Class Only
No need to disclose to pt for any covered limit, may exceed limit, pls contact insurance but pt should not be liable to settle balance until further notice (Fax: 2868 4413)', '- Accept card/cert issued by Japan, coverage in Japanese Yen.  Refer to card/policy sample.
- Limit up to $50,000
- Patient must sign 2 signature on original claim form. Fax copy would not be accepted by ins company.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Sompo Japan Nipponkoa (HK) Co Ltd\Claim Form with effect 4 July 2014.pdf', 'H:\Patient Account\Insurance Card Program\Sompo Japan Nipponkoa (HK) Co Ltd\Sompo Japan Nipponkoa.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NISSAJI', 'In', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '', 'Fax +852 2735-2256', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\Card face\Nissay Dowa card sample.doc', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\Well Be (HK) Ltd - claim form (mar 2010).doc', '', 'do not accept', '- Outpatient case handled by JIA and use JIA form.
- Inpatient case handled by Wellbe and use Well Be form.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NISSAJI', 'Out', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '2734 9333', '2735 2256', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Card face\Nissay Dowa card sample.doc', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 'Accept Policy / Certificate / Card if :
- Policy / Card in paper sheet and OVERSEAS TRAVEL ACCIDENT INSURANCE wordings.', '- Forenamed: Nissay Dowa
- AIOI merged with NISSAY DOWA (effecitve 1-Oct-2010) - Invoice send to Prestige.

DO NOT Accept Policy / Certificate / Card if :
1. Sickness / Coverage in HK$.
2. Policy / Certificate / Card without JI wordings.
3. No sickn', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NISSEAJ', 'In', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', '', '', to_date(''), '', '', '', 'H:\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\EAJ.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NISSEAJ', 'Out', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT Accept Policy / Certificate :
- No sickness coverage
- No injury / accident coverage
- Sickness / Coverage in HK$ (policy not issued by Japan).', 'Accept Policy / Certificate :
1. Policy / Certificate in Paper sheet
2. Policy / Certificate issued from Japan
3. Sickness / Injury / Accident Coverage in Japanese Yen Dollar', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NISSHI', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', 'NOT Cover the following (refer exlcusion comparison table) :
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive vaccine.
 Accept Policy / Certificate / Card if:
1. Policy / Certificate / Card in White paper sheet
2. Si', '- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.
- DO NOT Accept Policy / Certificate / Card if:
1. Sickness / Coverage in HK$.
2. No sickness c', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form OTAI 20130326.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NISSHI', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Standard class.
- Notify of Admission is Needed.', '- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.
Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co L', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form OTAI 20130326.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form - standard room.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NITTO', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '- Accept card in white / yellow color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NITTO', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Accept card in white / yellow color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NLH', 'Out', '', '(1) 671 472 3610', '(1) 671 472 6375', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Do not accept', '1. Suggest xerox copy the insurance card for billing purpose.
2. Request patient to sign on claim documents ( if any )
3. Request patient to sign on Statement.
4. Refer to Letter of Guarantee for coverage', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NLH', 'In', 'email: mangao@moylans.net', '1-671-472-3610', '1-671-472-6375', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NOMURA1', 'In', 'Toll  Free: 800-96-1111 then enter
855-806-0519 (24/7)
email: InternationalProviderClaims@aetna.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Aetna\Aetna - Nomura\Normura Letter of Authorization (2015).pdf', '', '', '', 'Accept e-billing  InternationalProviderClaims@aetna.com', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Aetna\Pre-certification Medical form.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NOMURA1', 'Out', 'Toll  Free: 800-96-1111 then enter
855-806-0519 (24/7)
email: InternationalProviderClaims@aetna.com
email (submit claim): InternationalProviderClaims@aetna.com', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Aetna\Aetna - Nomura\Normura Letter of Authorization (2015).pdf', '', '', '1. Check card face with
(i) Aetna Logo (ii) Nomura wording (iii) Aetna International OR Aetna Global Benefits (iv) Policy no. starts with "W".
2. can bill 100% although card shows 90%, no co-payment is required.
3. Patient has to self-pay for: Dental, ', '1. No claim form, sign HKAH consent
2. Accept e-billing  InternationalProviderClaims@aetna.com', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NOR1', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
- Former Name: Euro-Center China (HK) Co Ltd', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Norway Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NOR1', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance card for Billing
- If insurance card without name, can provide direct billing as usual, but pls also copy client''s passport. If any d', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Norway Claim Form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NOVOT', 'Out', 'No release patient info to AR company
Mr. Chris Chong
billing address: 
Novotech Clinical Research (Hong Kong) Limited
Address: Unit 1101, 11/F Fourseas Building, 208-212 Nathan Road, Kowloon, Hong Kon', 'contact insurance coordinator for any queries', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Novotech Clinical Research (Hong Kong) Limited\HKAH Work Flow for Novotech Clinic Research.doc', '', '', '', 'CONTRACT FOR NUCLEAR MEDICINE BONE SCAN ONLY!
NO OTHER OUTPATIENT SERVICES!', 'booking and services will be done at diagostic imaging Department
-.	After the examination, DI will pass NM & PET-CT Request Form to Outpatient Cashier for billing.
- Cashier will update HATS and pass bills to Outpatient Billing Team
- 	Outpatient Bill', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Novotech Clinical Research (Hong Kong) Limited\Sample Request Form -NM & PET-CT Request Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NOVOT', 'In', 'No release patient info to AR company

Mr. Chris Chong', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'do not accept', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NYK', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limited to Standard class
- Accept card in blue color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('NYK', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- 	Cover Physical Therapy (with Dr referral letter)
NOT Cover the following (refer exlcusion comparison table) :
- Well Baby, 180 days, pre-existing, pregnancy, health check up, dental, preventive vaccine.', '- Accept card in blue color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OAP', 'In', '', '2528-3031', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OAP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Okamura', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- 	Cover Physical Therapy (with Dr referral letter)', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Okamura', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OME', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OME', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do not Accept', 'ALERT CASE
Informed by the patient''s insurance concerned the drs fees is much higher than the standard cost in Asia. The limit of benefit is full covered, cannot settle the rest.   6/3/09/leo add DNA', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OMEGA', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'ALERT CASE
Previous bill, doctor''s bill was unsettled due to the insurance''s claims that dr''s fee is much higher than average costs in Asia. The limit of coverage has been exceeded The rest cannot be settled.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OP1', 'In', '', '3923-2888', '2873-5584', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', 'Accept case by case.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OP1', 'Out', '', '3923-2888', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', 'Accept case by case.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OPTEX', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limited to Semi-private class (2 beds).
- Accept card in green color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('OPTEX', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '- Accept card in green color with Prestige logo', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Out', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PAHI1', 'In', 'Hotline:+86 400 8833663....2
+86-95511...7
email: health@pingan.com.cn
claims: Cindy Huang 86-21-38636406', '+86 400 886 6338', '+86 21 5858 5371', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\GOP Sample.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\H440 simplified exclusion list- Final.doc', '', '', '1. Special excluded: Rehabilitation devices, medication exceed 90 days, expenses of remains(遺體).
2. Copy insurance card and discharge summary for billing.
3. Billing address: 19/F, 1333 Lujiazui Ring Rd, Pudong New District, Shanghai, China 200120.', '1. Check card Effective Date and Direct Billing Option
"門診/住院" = Out & In   "住院D" = in only    "無直接結算" = no direct billing
2.	Check member eligibility from provider portal
http://health.pingan.com/partner/login.screen
Username: PA0332      ', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\Pre-authorization Form.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\Claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PAHI1', 'Out', 'Hotline:+86 400 8833663....2
+86-95511...7
email: health@pingan.com.cn
claims: Cindy Huang 86-21-38636406', '+86 400 886 6338', '+86 21 5858 5371', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\GOP Sample.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\H440 simplified exclusion list- Final.doc', '', '', '1. Special excluded: Rehabilitation devices, medication exceed 90 days, expenses of remains(遺體).
2. Copy insurance card for billing.
3. Billing address: 19/F, 1333 Lujiazui Ring Rd, Pudong New District, Shanghai, China 200120.', '1. Check card Effective Date and Direct Billing Option
"門診/住院" = Out & In   "住院D" = in only    "無直接結算" = no direct billing
2. 	Check member eligibility from provider portal
http://health.pingan.com/partner/login.screen
Username: PA0332     ', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\Pre-authorization Form.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\Claim form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Ping An\Pre-auth Memo to Doctor.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PAHI2', 'Out', 'Hotline:+86 400 8833663....2
+86-95511...7
email: health@pingan.com.cn
claims: Cindy Huang 86-21-38636406', '+86 400 886 6338', '+86 21 5858 5371', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\GOP Sample.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\H440 simplified exclusion list- Final.doc', '', '', '1. Special excluded: Rehabilitation devices, medication exceed 90 days, expenses of remains(遺體).
2. Copy insurance card for billing.
3. Billing address: 19/F, 1333 Lujiazui Ring Rd, Pudong New District, Shanghai, China 200120.', '1. Check card Effective Date and Direct Billing Option on top left corner
"DB" = Out & In   "住院DB" =in only  
2. 	Check member eligibility from provider portal
http://health.pingan.com/partner/login.screen
Username: PA0332        Password: 72142565', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Ping An\Pre-auth Memo to Doctor.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\Claim form.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\Ping An\Pre-auth Memo to Doctor.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PAHI2', 'In', 'Hotline:+86 400 8833663....2
+86-95511...7
email: health@pingan.com.cn
claims: Cindy Huang 86-21-38636406', '+86 400 886 6338', '+86 21 5858 5371', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\GOP Sample.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\H440 simplified exclusion list- Final.doc', '', '', '1. Special excluded: Rehabilitation devices, medication exceed 90 days, expenses of remains(遺體).
2. Copy insurance card and discharge summary for billing.
3. Billing address: 19/F, 1333 Lujiazui Ring Rd, Pudong New District, Shanghai, China 200120.', '1. Check card Effective Date and Direct Billing Option on top left corner
"DB" = Out & In   "住院DB" =in only  
2.	Check member eligibility from provider portal
http://health.pingan.com/partner/login.screen
Username: PA0332        Password: 72142565
', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Ping An\Pre-authorization Form.doc', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Ping An\Claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PC', 'In', '', '2892-0086', '3017-7970', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '', '', '\\hkim\PA Share\Patient Account\Insurance Card Program\Voucher - IPD\PREMIERE.doc', '', 'Guarantee payment without limit', 'Fax number updated   6/3/09/leo', to_date(''), '', '', '\\hkim\PA Share\Patient Account\Insurance Card Program\Voucher - IPD\PREMIERE.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PCI', 'In', '2591-8622', '2591-8000
2591-8020', '2831-9802', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'New Card embossed with "Hosp "Y"/CB"
Forenamed Top Glory
(Name changed to Fortis)', 'Cover ALL Expenses
Policy No 203700055 expired 31 Jan 04 will have letter support to extend the expriy date till 31 March 2004. Any query, please contact Kitty Lam at 2591-8002', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PCI', 'Out', '2591 8622  Sandy (Office hour)

2591 8199  C.S. (Non-office hour)', '', '2831 9802', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\PACIFIC CENTURY.jpg', '', '', '1. Card embossed with PV  and/or SPV wordings

 ( PV = General Practitioner in Out-Patient care ) 
 ( SPV = Specialist in Out-Patient care )

 2. Card embossed with CB wordings
 ( CB = Maternity + Out-Patient care must be related to maternity)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Pcross', 'Out', 'c/o International Administrators Ltd
tel: +852 25732278, 25732535
inquiry@ialhk.com', '2892 9633 Aiman', '2573 2917', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PII_exclusion.doc', '', '', 'Accept Card:
 1. Plastic Card in green color with a blue-color cross-sign logo.
 2. Card with "OUTPATIENT COVERAGE CARD" wordings
 3. Valid Thru = expiry date', '- Xerox copy the insurance card for billing purpose.
- Since no claim document for this insurance, need patient to sign HKAH consent form & sign on bill.
- DO NOT accept purple card with "INSURANCE COVERAGE CARD" wordings.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Pcross', 'In', 'c/o International Administrators Ltd
tel: +852 25732278, 25732535
inquiry@ialhk.com', '', '25732917', '', '', 0.0, 0.0, -1.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PII_exclusion.doc', '', '', '', '-  Contract for OPD Only
-  Accept LOG case by case.  
-  "Settle bill within 7 - 14 days" must state on LOG.
-  For admission case, the ''NOTIFICATION OF CLAIM FORM'' can be used for the purpose of acknowledge admission & send bill.  Only 1 form is requ', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\PacificCross200903.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PEC', 'Out', '', '2821-5888', '2861-3578', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PEC', 'In', '', '2821-5888', '2527-7136', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', 'Tel and Fax updated    6/3/09/leo', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PG', 'In', '', '2582-9333', '2802-4267', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Guaranttee letter issued by Cigna US
Bill will be send to Cigna, Balance from reimbursement will be covered by the company
Resubmit for any remaining balance after reimbursed from CIGNA', 'Accept Cigna International Card for Expat staff, entitled to 2nd class
Accept staff card for local staff, entitled to 3rd class
Tel and Fax updated   6/3/09/leo', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PG', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PHHKL', 'Out', 'Hotline: (852) 8206 6628

Ms. Eva Lee - Nurse Manager
Tel: (852) 2810 9188
Ms. Joanna Chan - Claims Dept
Tel: (852) 2815 9898', '(852) 8206 6628', '(852) 2810 9968', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Parkway Healthcare (HK) Ltd\LOG Sample.pdf', '', '', '', '', '1. LOG covers up to HK$150,000.  If expenses exceed, seek for further guarantee.
2. Billing address: 16/F., Hing Wai Building, 36 Queen''s Road Central, Hong Kong
3. HKAH consent is required.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PHHKL', 'In', 'Hotline: (852) 8206 6628

Ms. Eva Lee - Nurse Manager
Tel: (852) 2810 9188
Ms. Joanna Chan - Claims Dept
Tel: (852) 2815 9898', '(852) 8206 6628', '(852) 2810 9968', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Parkway Healthcare (HK) Ltd\LOG Sample.pdf', '', '', '', '', '1. LOG covers up to HK$150,000.  If expenses exceed, seek for further guarantee.
2. Billing address: 16/F., Hing Wai Building, 36 Queen''s Road Central, Hong Kong', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PHIL', 'In', '', '755-691876', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'Cannot chase updated contact information due to it already changed to ''8''digit number. ''6'' digit number cannot follow through PCCW   6/3/09/leo', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PHIL', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PIHK', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '36515790 (1ST PRIO)
28680612 (JAPANESE)', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limited to Standard class
Guarantee applies to various Japanese Insurance. Call Ms Takeishi at 9124-5267/ Mr Wu at 9750-2938 in case of off hours and related to patient without valid policy but pt confirmed that have approval from the insurance.', '- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.
Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co L', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PIHK', 'Out', '36515833 Ms. Kau 91245267
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PII', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PII_exclusion.doc', '\\hkim\PA Share\Patient Account\Insurance Card Program\Voucher - IPD\PI.doc', '', 'DO NOT ACCEPT', '-  01-April-2009, PII changed name to PACIFIC CROSS INSURANCE CO LTD
-  Contract for OPD Only
-  Refer and Approved by AM for each case.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PII', 'Out', 'c/o International Administrators Ltd
25732278 / 25732535
inquiry@ialhk.com', '2892 9633 Aiman', '2573 2917', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '\\hkim\pa share\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PII_exclusion.doc', '', '', ' Accept Card:
 1. Plastic card in Silver color with Blue logo
 2. Card with "OUTPATIENT COVERAGE CARD" wordings
 3. Valid Thru = expiry date', '-  01-April-2009, PACIFIC INTERNATIONAL INSURANCE CO LTD (PII) changed name to PACIFIC CROSS INSURANCE CO LTD.
-  old PII card is still valid until 31-3-2010.
-  Xerox copy the insurance card for billing purpose.
-  Since no claim document for this ins', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PPP', 'Out', 'Customer Service: (GOP & Pre-auth)
Tel: +44 (0) 1892 503 915
Fax: +44 (0) 1892 503 787
Email: direct.settlement@axa-ppp.co.uk', '', '', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\PPP International\PPP - LOG samples.pdf', '', '', '', 'DO NOT ACCEPT', '<Please refer to IPA (AR code: IPA)>

1. Cover GP only, Lab test, X-ray and Ultrasound only
2. Self Pay: Dental, Rehab treatment
3. D.I., Minor Surgery - GOP is required

\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PPP', 'In', 'Customer Service: (GOP & Pre-auth)
Tel: +44 (0) 1892 503 915
Fax: +44 (0) 1892 503 787
Email: direct.settlement@axa-ppp.co.uk', 'Contact AXA PPP directly', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\PPP International\PPP - LOG samples.pdf', '', '', '', 'DO NOT ACCEPT', '- Collect Deposit
Temporarily refuse to accept PPPI LOG until further notice
Ask PPPI to contact IPA HK. No need to explain what reason. (21 Nov 2013 NH)


1. Acknowledge Admission Form:
H:\Patient Account\Insurance Card Program\PPP International\PP', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\PPP International\PPP - Claim Form 20120816.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PRICI', 'In', 'Eve Shum - Manager (eve@nnihk.com)', '2234 6159
2104 3131', '2571-6196', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PRICI_Pricia.tif', '', '', '- Inform Pricia if exceed 200K', '- Claim form in 4-pages-set
- Dr has to sign on both front & back page of Claim Form if total amount >HK$3,000.
- please write the total bill amount on the form.
- please pass the 4th copy (Patient) to patient.  If amount revised, please ask patient to', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Pricia\Claim Form (New) 20121110.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PRICI', 'Out', 'Eve Shum - Manager (eve@nnihk.com)', '2234 6159
2104 3131', '2571 6196', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '- Xerox copy the insurance card for billing purpose.
- In case bill is over HK$3000, doctor needs to complete both front & back of the original claim form
- Covers for Travel Medicines
- Claim form in 4-pages-set
- please write the total bill amount o', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Pricia\Claim Form (New) 20121110.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PRICICO', 'In', 'Eve Shum - Manager (eve@nnihk.com)', '2234 6159
2104 3131', '2571-9196', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PRICI_Pricia.tif', '', '', '- Inform Pricia if exceed 200K
- Accept Card in plastic  OR  laminating card printed with Mitsui Sumitomo (named as MSIG from year 2009)
- expiry :  dd-mmm-yy', '- Claim form in 4-pages-set
- Dr has to sign on both front & back page of Claim Form if total amount >HK$3,000.
- please write the total bill amount on the form.
- please pass the 4th copy (Patient) to patient.  If amount revised, please ask patient to', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Pricia\Claim Form (New) 20121110.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PRICICO', 'Out', 'Eve Shum - Manager (eve@nnihk.com)', '2234 6159
2104 3131', '2571 6196', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '- Accept Card in plastic  OR  laminating card printed with Mitsui Sumitomo (named as MSIG from year 2009)
- expiry :  dd-mmm-yy', '- Xerox copy the insurance card for billing purpose.
- In case bill is over HK$3000, doctor needs to complete both front & back of the original claim form.
- Covers for Travel Medicines
- Claim form in 4-pages-set
- please write the total bill amount ', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Pricia\Claim Form (New) 20121110.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PRICICO2', 'Out', 'Eve Shum - Manager (eve@nnihk.com)', '2234 6159', '2571 6196', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '- Accept Card in plastic  OR  laminating card printed with MSIG (forenamed Mitsui Sumitomo).
- expiry :  dd-mmm-yy', '- Xerox copy the insurance card for billing purpose.
- In case bill is over HK$3000, doctor needs to complete both frong & back of the original claim form
- Covers for Travel Medicines
- Claim form in 4-pages-set
- please write the total bill amount o', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Pricia\Claim Form (New) 20121110.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PRICICO2', 'In', 'Eve Shum - Manager (eve@nnihk.com)', '2234 6159
2104 3131', '2571 6196', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PRICI_Pricia.tif', '', '', '- Inform Pricia if exceed 200K
- Accept Card in plastic  OR  laminating card printed with MSIG (forenamed Mitsui Sumitomo)
- expiry :  dd-mmm-yy', '- Claim form in 4-pages-set
- Dr has to sign on both front & back page of Claim Form if total amount >HK$3,000.
- please write the total bill amount on the form.
- please pass the 4th copy (Patient) to patient.  If amount revised, please ask patient to', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Pricia\Claim Form (New) 20121110.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PRUD', 'In', '', '2977-3888', '2530-5542', '', 'No Limit', 50000.0, 0.0, -1.0, 0.0, '', '', '', '', 'Former: Prudential Assurance Company Ltd', '1. Covers up to 50,000, excess is responsible by patient.
2. Entitles to 2nd or 3rd class', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prudential\Claim Form Jan 2014.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('PRUD', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QBE', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QBE', 'In', '2828-1940 Jenny Ng', '2877-8488', '2877-8366', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\QBE_HK & Shanghai Insurance.tif', '', '', 'New Insurance presented on 2-12-2005', 'Forenamed Hong Kong & Shanghai Insurance', to_date(''), '', '', '\\hkim\PA Share\Patient Account\Insurance Card Program\Voucher - IPD\SHANGHAI.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL1', 'Out', 'Tel: 8205 8205 / 8301 8301
http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24hrs 8203 2203', '2534 0201', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks card images.pdf', 'H:\Patient Account\Insurance Card Program\CIGNALinks\QHCL_LOG Sample.JPG', '', '', '- Request Medication Breakdown
- Not cover BET Pilates, medical report.
- For preventive check-up, ask patient to pay & claim.  Or ask QHMS to issue LOG.
- Ask patient to sign on QHMS guarantee (consent part) or HKAH consent form.  If patient refused t', '- <Workflow>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks workflow 20100826.pdf
- <FAQs>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks FAQs.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL1', 'In', 'Tel: 82058205
http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24hrs 8203 2203', '2534 0201', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Contract for Outpatient only.  Can accept Inpatient case by case.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL2', 'In', 'Tel: 82058205
http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24hrs 8203 2203', '2534 0201', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Contract for Outpatient only.  Can accept Inpatient case by case.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL2', 'Out', 'Tel: 8205 8205 / 8301 8301
http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24hrs 8203 2203', '2534 0201', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks card images.pdf', 'H:\Patient Account\Insurance Card Program\CIGNALinks\QHCL_LOG Sample.JPG', '', '', '- Request Medication Breakdown
- Not cover BET Pilates, medical reports
- For preventive check-up, ask patient to pay & claim.  Or ask QHMS to issue LOG.
- Ask patient to sign on QHMS guarantee (consent part) or HKAH consent form.  If patient refused t', '- <Workflow>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks workflow 20100826.pdf
- <FAQs>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks FAQs.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL3', 'In', 'Tel: 82058205
http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24hrs 8203 2203', '2534 0201', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Contract for Outpatient only.  Can accept Inpatient case by case.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL3', 'Out', 'Tel: 8205 8205 / 8301 8301 
http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24hrs 8203 2203', '2534 0201', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks card images.pdf', 'H:\Patient Account\Insurance Card Program\CIGNALinks\QHCL_LOG Sample.JPG', '', '', '- Request Medication Breakdown
- Not cover BET Pilates, medical reports
- For preventive check-up, ask patient to pay & claim.  Or ask QHMS to issue LOG.
- Ask patient to sign on QHMS guarantee (consent part) or HKAH consent form.  If patient refused t', '- <Workflow>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks workflow 20100826.pdf
- <FAQs>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks FAQs.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL4', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL4', 'Out', 'http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24 hrs 8205 8205', '', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks card images.pdf', 'H:\Patient Account\Insurance Card Program\CIGNALinks\QHCL_LOG Sample.JPG', '', '', '- Ask patient to sign on QHMS guarantee (consent part) or HKAH consent form.  If patient refused to sign, call QHMS at 8205 8205.
- OK to accept paper printed card (due to patient may print it from CIGNA web site)', '- <Workflow>: H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks workflow 20100826.pdf
- <FAQs>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks FAQs.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL5', 'In', 'Tel: 82058205
http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24hrs 8203 2203', '2534 0201', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Contract for Outpatient only.  Can accept Inpatient case by case.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCL5', 'Out', 'Tel: 8205 8205 / 8301 8301 
http://www.qhms.com
https://eservices.qhms.com/qha/en/login.jsp', 'QHMS 24hrs 8203 2203', '2534 0201', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks card images.pdf', 'H:\Patient Account\Insurance Card Program\CIGNALinks\QHCL_LOG Sample.JPG', '', '', '- Request Medication Breakdown
- Not cover BET Pilates, medical reports
- For preventive check-up, ask patient to pay & claim.  Or ask QHMS to issue LOG.
- Ask patient to sign on QHMS guarantee (consent part) or HKAH consent form.  If patient refused t', '- <Workflow>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks workflow 20100826.pdf
- <FAQs>:  H:\Patient Account\Insurance Card Program\CIGNALinks\CIGNAlinks FAQs.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCPA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\CPA.jpg', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCPA', 'Out', 'CPA Provider Hotline: 2851 3870
(for urgent: press "2", then "2")
CPA Member Hotline: 8200 7470
OPD Claims: Eva ( 2975 3264)
IPD Claims: Norine (2975 2336)
QHCPA Email: cpa@qhms.com
QH Finance:  2975 3276
CPA Benefit service centre: 2747 3281', '2851 3870', '2534 0233', '', 'Non-Office Hour Only', 0.0, -1.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\QHCPA\void card 5053470C GEORGE ABRAHAM YOHAN_since 18-5-2014.pdf', 'H:\Patient Account\Insurance Card Program\QHCPA\QHCPA exclusion list (version Feb 2014).pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\QHCPA\Voucher.pdf', '', '- Request Medication and Laboratory Breakdown.
1. For SP, any time, approval from QHCPA is required.
2. Not cover dietitian even medical necessary. 
3. DO NOT Accept Card during following hours since patient should go to CPA''s panel doctor appointed by', '- embossed Silver color font ''CPA'' and ''member number'' 
- when sending bills, please arrange CPA bills and CPSL bills in 2 separate batches for their easy reference before sending them together.
- Mon-Fri  :  after 18:00 - Accept card (GP only, also app', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\QHCPA\Discharge summary.pdf', '', -1.0, 'H:\Patient Account\Insurance Card Program\QHCPA\QHCPA - Pre-auth Memo to Doctor 20150303.doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHCPA', 'In', 'CPA Provider Hotline: 2851 3870
(for urgent: press "2", then "2")
CPA Member Hotline: 8200 7470
OPD Claims: Eva ( 2975 3264)
IPD Claims: Norine (2975 2336)
QHCPA Email: cpa@qhms.com
QH Finance:  2975 3276
CPA Benefit service centre: 2747 3281', '2851 3870', '2534 0233', '', 'No Limit', 150000.0, -1.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\QHCPA\void card 5053470C GEORGE ABRAHAM YOHAN_since 18-5-2014.pdf', 'H:\Patient Account\Insurance Card Program\QHCPA\QHCPA exclusion list (version Feb 2014).pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\QHCPA\Voucher.pdf', '', '- Not cover dietitian even medical necessary. 
Accept 2 Card Types (from 1-Sep-08):
- embossed Silver color font ''CPA'' and ''member number'' or
- embossed Gold color font ''CATHAY PACIFIC SERVIES LTD'' (means CPSL) and ''member number''
- the CPA and CPSL c', '- Claim Voucher and Discharge Summary needed
- Acknowledge Admission is needed if patient come via urgent care.
- submit bill within 45days (Neville email dd 19-12-2013).', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\QHCPA\Discharge summary.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHM', 'Out', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHM', 'In', '', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHM', 'In', '24/7 CS Hotline
T: (305) 821 8430  F: (305) 820 4033
Services21@QHManagement.com / Nellis@QHManagement.com', '(305) 821 8430', '(305) 820 4033', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\QHM\LOG Sample (Pre-authorization Form).pdf', '', '', '', '1. No need to monitor medications.
2. No claim form needed.', '1. PAF (Pre-Authorization Form) = LOG  (Refer the above link)
2. Accept e-billing:  Claims@QHManagement.com', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHM', 'Out', '24/7 CS Hotline
T: (305) 821 8430  F: (305) 820 4033
Services21@QHManagement.com / Nellis@QHManagement.com', '(305) 821 8430', '(305) 820 4033', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\QHM\LOG Sample (Pre-authorization Form).pdf', '', '', '', '1. No need to monitor medications.
2. No claim form needed.', '1. PAF (Pre-Authorization Form) = LOG  (Refer the above link)
2. Sign HKAH consent
3. Accept e-billing:  Claims@QHManagement.com', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHMS', 'In', 'T: 8301 8301 (24H CS Hotline)
T: 8203 2203 (for Cigna card holder)
T: 8205 8205 (for Cigna Link only)
Fax: 2851 2845 (for LOG re-validation)
T: 2851 3837  F: 2521 7971 (for MTR)', '8205 8205', '2534 0201', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '', '', '', '', '', '1. Member presents QHMS Card to Hospital
2. Hosptial calls 24 hour CS hotline to identify member''s eligibility
4. QHMS Issues GOP
5. Hospital receives GOP and admits member
6. Hospital collects co-payment, bills QHMS for remaining balance and attach Q', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\QHMS\Discharge Summary.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('QHMS', 'Out', '', '', '2521 7971', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RAF', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RAF', 'In', '20 B 9 Queen''s Road Central HK', '25251730', '2869-6262', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RC', 'Out', '', 'BJ (86) 10 6583 5995
BJ (86) 10 6583 5997', 'BJ (86) 10 6583 6119', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '- patient sign on HKAH consent form.
- diagnosis on bill and/or other document requested on LOG.
- coverage refer to LOG.
- no matter LOG from Shanghai or Beijing, send bill to Shanghai address.', '- Accept by Letter of Guarantee.
-', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RC', 'In', '', 'BJ +86-10-65835088 (24hours)', 'BJ +86-10-65814696', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '- As per meeting on 7-7-2009, if no LOG upon admission, please collect advance payment from patient.
- 3-May-2010, no matter LOG from Shanghai or Beijing, send bill to Shanghai address.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RENESAS', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- 	Cover Physical Therapy (with Dr referral letter)', '- *For Vaccination: refer to the list of claimable items.
- New card might have ISOS logo at right top corner, DO NOT bill ISOS.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RENESAS', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Cover Normal Delivery only', '- New card might have ISOS logo at right top corner, DO NOT bill ISOS.
Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RICOH', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RICOH', 'In', '', '2893-0022', '2834-5682', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', 'Fax number updated   6/3/2009/leo', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RKCG', 'In', 'Ms. Anara Batyrgaliyeva (Admin Manager)
T: 2548 3841
F: 2548 8361
office@consul-kazakhstan.org.hk', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Consulate General of the Republic of Kazakhstan\LOG sample.pdf', '', '', '', '', 'Contract mainly for Outpatient only.  But still accept LOG case by case.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('RKCG', 'Out', 'Ms. Anara Batyrgaliyeva (Admin Manager)
T: 2548 3841
F: 2548 8361
office@consul-kazakhstan.org.hk', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Consulate General of the Republic of Kazakhstan\LOG sample.pdf', '', '', '', '', '1. Sign HKAH consent form', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SAL', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SAL', 'In', '', '25012160', '2523-5609', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', 'OCCASIONAL CASE
Refer to Manager for any new case
Letter of Guarantee needs to be approved by manager.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SAN', 'In', '', '24910411', '', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SAN', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SAS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SAS', 'In', '', '44-2079027405', '44-2079284748', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', 'Company of Europoint
ALERT CASE
Obtained all medical information from us. After patient left, only received the confirmation and they requested us to send the bill to claims department but did not mentioned that they will cover the cost in full.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SBCM', 'In', '', '2532-8500', '2532-8505', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Physical Exam Inclusive', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SBCM', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SCI', 'In', 'Toll free: 800 690 6295
Tel: +1 317 818 2808
assist@sevencorners.com', '+1 317 818 2808', '+1 317 815 5984', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Seven Corners\LOG sample.pdf', '', '', '', 'DO NOT ACCEPT', '
-- contract Terminated 8-March-2015.


Accept e-billing: assist@sevencorners.com
Card samples:
H:\Patient Account\Insurance Card Program\Seven Corners\Card Samples.pdf
Claim Form is not a must and to be completed by Patient', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Seven Corners\Injury &  Illness Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SCI', 'Out', 'Toll free: 800 690 6295
Tel: +1 317 818 2808
assist@sevencorners.com', '', '', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Seven Corners\LOG sample.pdf', '', 'H:\Patient Account\Insurance Card Program\Seven Corners\Injury &  Illness Claim Form.pdf', '', 'DO NOT ACCEPT', '-- contract terminated on 8-Mar-2015


- by Guarantee Of Payment
Card samples:
H:\Patient Account\Insurance Card Program\Seven Corners\Card Samples.pdf
For Billing:
- diagnosis on bill
- Accept e-billing: assist@sevencorners.com
Claim Form is not', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SECOM', 'In', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '25289998 HK', '2528 9933', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '', '', '', '', '', 'Pre-Auth / Acknowledge Admission Form:
H:\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\ISOS Japan.doc', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\New Claim Form eff from 1 Jan 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SECOM', 'Out', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '2528 9998 HK', '2528 9933 HK', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\Exclusions.pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\ISOS Japan CMS Agreement\New Claim Form eff from 1 Jan 2013.pdf', '', 'If policy is a Multiple Trip Insurance policy, check the consultation date should not more than 90 days after patient latest departure date from Japan.  If so, copy patient''s passport, page with photo & latest departure chop of Japan. (Policy sample:  H:\', '- Coverage in Japanese Yen Dollar 
- Patient needs to sign 2 signatures on form.

DO NOT Accept Policy / Certificate / Card if:
1. Sickness / Coverage in HK$.
2. No sickness coverage
3. No accident coverage', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SINOMED', 'Out', 'E-mail: info@sinomed-assistance.com; sinomedassist@gmail.com
Fax: (852) 30201775 OR (8610) 65511643

Ms. Maria Baranova
Tel: +86 13910514883 
maria@sinomed-assistance.com
Ms. Olga Masyutina
Tel: +86 13683598889
olga.imc.beijing@gmail.com', '+86 10 64651561 - 3', '+86 10 65511643', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Sinomed Pacific Ltd\GOP sample.pdf', '', '', '', 'do not accept', '- DO NOT provide any service if NO passport & policy copy.
- (must need) patient passport/ID copy for billing purpose.
- (must need) policy copy for billing purpose.
- Staff MUST contact SinoMed to obtain further GOP if bill amount > GOP coverage
- $2', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Sinomed Pacific Ltd\Medical report (v201406).doc', '', -1.0, 'H:\Patient Account\Insurance Card Program\Sinomed Pacific Ltd\Pre-auth Memo to Doctor (for outpatient 20121201).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SINOMED', 'In', 'E-mail: info@sinomed-assistance.com; sinomedassist@gmail.com
Fax: (852) 30201775 OR (8610) 65511643

Ms. Maria Baranova
Tel: +86 13910514883 
maria@sinomed-assistance.com
Ms. Olga Masyutina
Tel: +86 13683598889
olga.imc.beijing@gmail.com', '+86 10 64651561 - 3', '+86 10 65511643', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Sinomed Pacific Ltd\GOP sample.pdf', '', '', '', '- Do not provide any credit service if patient cannot provide passport & policy
- cover Standard Room.
- copy patient passport/ID and policy for billing purpose.
- Cost Estimation should provide on the first day of admission or before admission.
- Ema', 'Cost Estimation form:  H:\Patient Account\Insurance Card Program\Sinomed Pacific Ltd\Estimation cost.xls', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Sinomed Pacific Ltd\Medical report (v201406).doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SOJIT', 'In', 'Ms. Mina Hui (A/C) 28792784
Eve Cheng (HR & GA Dept)
D: 2844 1820', '28792888
28441811', '28772800, 25851188', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Sojitz (Hong Kong) Limited\Sojitz Name List (Apr 2015).pdf', '', '', '', '', '-  Forenamed : Nissho Iwai
-  No contract
-  HKAH consent is a must
-  Diagnosis on bill is a must', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SOJIT', 'Out', 'Ms. Mina Hui (A/C) 28792784
Eve Cheng (HR & GA Dept) 
D:2844 1820', '28792888
28441811', '28772800, 25851188', '', '', 0.0, 0.0, 0.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Sojitz (Hong Kong) Limited\Sojitz Name List (Apr 2015).pdf', '', '', '', '', '-  Forenamed : Nissho Iwai
-  No contract
-  HKAH consent is a must
-  Diagnosis on bill is a must', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SOMP', 'In', 'Operations:
Tel: +86 10 8586 6149 (for patient)
Tel: +86 10 8586 5501 (for hospital)
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', '180 days rule applies', '- Copy valid insurance policy
- Try to ask patient to fill all parts of claim form, including Japan''s postal address.
- Make sure the coverage category on policy is correct (e.g. SICKNESS, or INJURY).
- Medical Report is required for all IP cases.
- A', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\Sompo Japan Nipponkoa Insurance Inc (1-Sept-2014).pdf', 'H:\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\EAJ.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SOMP', 'Out', 'Operations:
Tel: +86 10 8586 5501
Fax: +86 10 8586 6426
email: opschina@emergency.co.jp
Claims:
Tel: +81-3-3811-8301
Fax: +81-3-3811-8156
E-mail: claims@emergency.co.jp', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT Accept Policy / Certificate :
- No sickness coverage
- No injury / accident coverage
- Sickness / Coverage in HK$ (policy not issued by Japan).', 'Accept Policy / Certificate :
1. Policy / Certificate in Paper sheet
2. Printed with OVERSEAS TRAVEL ACCIDENT INSURANCE wordings
3. Policy / Certificate issued from Japan
4. Sickness/Injury/Accident Coverage in Japanese Yen Dollar
5. Copy the insuran', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\EAJ - Emergency Assistance Japan\Sompo Japan Nipponkoa Insurance Inc (1-Sept-2014).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Sony', 'In', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '', 'Fax +852 2735-2256', '', '', 0.0, 0.0, -1.0, -1.0, 'H:\Patient Account\Insurance Card Program\Card face\Sony Assurance Inc.doc', '', '', '', 'do not accept', '- Outpatient case handled by JIA and use JIA form.
- Inpatient case handled by Wellbe and use Well Be form.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Sony', 'Out', 'Ms.Miyuki Matsushita 2734-9354, matsushita.m@hk.jtb.cn', '2734 9333', '2735 2256', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Card face\Sony Assurance Inc.doc', '', '', '', 'Accept Policy / Certificate / Card if :
- Policy / Card in paper sheet and OVERSEAS TRAVEL ACCIDENT INSURANCE wordings.', 'May cover for pre-existing symptoms if patient obtains a letter from JIA.  Sample attached:
H:\Patient Account\Insurance Card Program\JI Accident\Letter for treatment of pre-existing symptoms.pdf
DO NOT Accept Policy / Certificate / Card if :
1. Sickne', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\JI Accident\Claim Form (eff from 12 Jan 2011).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Sony_PI', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- 	Cover Physical Therapy (with Dr referral letter)', '', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('Sony_PI', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SOSI', 'In', '	24/7 Hotline:  Tel: +86 10 5869 8633
Fax: +86 10 5869 8258 
Email: ops-beijing@sosi.asia', '+86 10 5869 557', '+86 10 5869 8258', '', '', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\SOS International\Sample GOP.pdf', '', '', '', '- Must have "SOS International" logo.  "if..." logo is optional
- If patient not holding a SOSI insurance card, but the card carries "SOS International" wordings at the back side.  We can contact SOSI to clarify.', '- LOG is required for all Inpatient case.  
- Claim Form not required.
- Please copy both side of insurance card for billing.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SOSI', 'Out', '	24/7 Hotline:  Tel: +86 10 5869 8633
Fax: +86 10 5869 8258 
Email: ops-beijing@sosi.asia', '+86 10 5869 557', '+86 10 5869 8258', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\SOS International\Sample GOP.pdf', '', '', '', '- Must have "SOS International" logo.  "if..." logo is optional
- Claim Form: Doctor is required to complete "Attending Physician" portion only.
- If patient not holding a SOSI insurance card, but the card carries "SOS International" wordings at the bac', '- HKAH consent is required.
- medical report is required.
- Please copy both side of insurance card for billing. 
- 	SOSI Insurance card cover Euro 1,000 /case for simple treatment, vaccinations, Emergency medical treatment, Preventive healthcare & Den', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\SOS International\SOSI Claim form - Out-patient.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SOSI1', 'In', '	24/7 Hotline:  Tel: +86 10 5869 8633
Fax: +86 10 5869 8258 
Email: ops-beijing@sosi.asia', '+86 10 5869 557', '+86 10 5869 8258', '', '', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\SOS International\Sample GOP.pdf', '', '', '', '- Must have "SOS International" logo.  "if..." logo is optional
- If patient not holding a SOSI insurance card, but the card carries "SOS International" wordings at the back side.  We can contact SOSI to clarify.', '- LOG is required for all Inpatient case.  
- Claim Form not required.
- Please copy both side of insurance card for billing.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SOSI1', 'Out', '	24/7 Hotline:  Tel: +86 10 5869 8633
Fax: +86 10 5869 8258 
Email: ops-beijing@sosi.asia', '+86 10 5869 557', '+86 10 5869 8258', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\SOS International\Sample GOP.pdf', '', '', '', '- Must have "SOS International" logo.  "if..." logo is optional
- Claim Form: Doctor is required to complete "Attending Physician" portion only.
- If patient not holding a SOSI insurance card, but the card carries "SOS International" wordings at the bac', '- HKAH consent is required.
- medical report is required.
- Please copy both side of insurance card for billing. 
- 	SOSI Insurance card cover Euro 1,000 /case for simple treatment, vaccinations, Emergency medical treatment, Preventive healthcare & Den', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\SOS International\SOSI Claim form - Out-patient.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUMI', 'In', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '', '2528 9933', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\ISOS.tiff', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUMI', 'Out', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '', '2528 9933', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:Patient Account\Insurance Card Program\Voucher - OPD\ISOS.tiff', '', '', '-Patient needs to sign 2 signatures on form.

Accept Policy / Certificate / Card :
- Policy / Certificate in Paper sheet
- Coverage in Japanese Yen Dollar

DO NOT Accept Policy / Certificate / Card if :
1. Sickness / Coverage in HK$.
2. No sicknes', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUMITO', 'Out', '', '2851 0620', '2851 0910', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Accept Policy / Certificate
1. Policy / Certificate in Paper sheet
2. Coverage in Japanese Yen Dollar', '1. Suggest xerox copy cover page ( showing the policy / certificate name of Sumitomo Marine & Fire Insurance ) for billing purpose.

DO NOT Accept Policy / Certificate
1. Coverage in HK$
2. No sickness coverage in Japanese Yen Dollar
3. No accident c', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUMITO', 'In', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUNL', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUNL', 'In', 'CS Hotline: 3183 2099
Claims: Ms. Anthea Chung 2103 8336/ Ms. Hydie Lau 2103 8335
Admin: Ms. Rosanna Lo 2103 8331/
Ms. Carol Yuen 2103 8330', '3183 2099', '2302 0173', '', 'No Limit', 200000.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Sun Life Financial\Sun Life procedure as of 21Aug2014.pdf', '', '', '', 'Accept cards with Name:
1) Sun Life Privilege Care
2) CMG Asia Privilege Care Card (Platinum Colour)
3) Shun Tak Group
4) Fuji Xerox
5) Eastern Airlines Limited', '1. Cards printed with ''HOSP'' for Inpatient coverage.  No Class Limit but up to $200,000 including Dr''s fees.
2. Photocopy the Sun Life Privilege Care Card
3. No voucher need to be filled.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Sun Life Financial\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUNL1', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUNL1', 'In', 'CS Hotline: 3183 2099
Claims: Ms. Anthea Chung 2103 8336/ Ms. Hydie Lau 2103 8335
Admin: Ms. Rosanna Lo 2103 8331/
Ms. Carol Yuen 2103 8330', '3183 2099', '2302 0173', '', 'No Limit', 200000.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Sun Life Financial\Sun Life procedure as of 21Aug2014.pdf', '', '', '', 'Accept cards with Name:
1) Sun Life Privilege Care
2) CMG Asia Privilege Care Card (Platinum Colour)
3) Shun Tak Group
4) Fuji Xerox
5) Eastern Airlines Limited', '1. Cards printed with ''HOSP'' for Inpatient coverage.  No Class Limit but up to $200,000 including Dr''s fees.
2. Photocopy the Sun Life Privilege Care Card
3. No voucher need to be filled', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Sun Life Financial\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUNL2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SUNL2', 'In', 'CS Hotline: 3183 2099
Claims: Ms. Anthea Chung 2103 8336/ Ms. Hydie Lau 2103 8335
Admin: Ms. Rosanna Lo 2103 8331/
Ms. Carol Yuen 2103 8330', '3183 2099', '2302 0173', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Sun Life Financial\Sun Life procedure as of 21Aug2014.pdf', '', '', '', 'Accept cards with Name:
1) Sun Life Privilege Care
2) CMG Asia Privilege Care Card (Platinum Colour)
3) Shun Tak Group
4) Fuji Xerox
5) Eastern Airlines Limited', '1. Cards printed with ''HOSP'' for Inpatient coverage.  No Class Limit but up to $200,000 including Dr''s fees.
2. Photocopy the Sun Life Privilege card card
3. No voucher need to be filled.', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Sun Life Financial\Claim Form Nov 2013.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE1', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
Claim Form: 
H:\P', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'see Alert Box', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE1', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance card for Billing
- If insurance card without name, can', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'see Alert Box', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE2', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Collect "Deductible" shows on membership card from Patient (if any).
- Copy Insurance card for Billing
- If insurance card without name, can', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'see Alert Box', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE2', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
Claim Form: 
H:\P', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'see Alert Box', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE3', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- If insurance card without name, can provide direct billing as usual, but pls also copy client''s passport. I', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'see Alert Box', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE3', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
Claim Form: 
H:\P', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'see Alert Box', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE4', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
Claim Form: 
H:\P', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'see Alert Box', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE4', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- If insurance card without name, can provide direct billing as usual, but pls also copy client''s passport. I', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'see Alert Box', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE5', 'Out', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Request Medication Breakdown
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- If insurance card without name, can provide direct billing as usual, but pls also copy client''s passport. I', '1. If cost expected to exceed RMB8,000 , MUST get pre-authorization since the RMB8,000 is not the coverage limit.
2. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for outpatient 20110714).doc', 'see Alert Box', '', -1.0, 'H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Memo to Doctor (for outpatient 20110714).doc');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('SWE5', 'In', 'Tel: +86 10 8455 9500
Fax: +86 10 8451 1176
email: beijing@euro-center.com
(or refer to Insurance Card)
24/7 +86 13 50137 9757', '', '', '', '', 0.0, -1.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Updates 251213.doc', '\\hkim\pa share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Exclusions.pdf', '', '', '- Secure message Login: hkahpsr@hkah.org.hk  Paswword: inpatient1
- Check Customer policy list before provide service. (effect from 1 Jan 2013)
- Copy Insurance card for Billing
- Only cover Semi-private ward unless specified in LOG
Claim Form: 
H:\P', '1. LOG Sample
H:\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\LOG Sample.pdf
3. Billing address: 8/F, Building C, East Lake Villas, 35 Dongzhimenwal Dajie, Dongcheng District, Beijing, China 100027', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Euro-Center China (HK) Co Ltd\Pre-auth Form to Euro-Center (for Inpatient 20110510).doc', 'see Alert Box', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TAIUN', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TAIUN', 'In', '', '25377661', '2637-5197', '', 'No Limit', 100000.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TARGET', 'In', '', '23121651', '2312-1849', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Mondial Assistance USA
Medical Agent for Guaranteeing various insurance', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TARGET', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TCI', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TCI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TEJ', 'In', 'ZAMRI A. HAMID  (Mr.)
Operations Executive
Tel			:	+60 4 899 3441 / +60 4 890 1414
Fax			:	+60 4 890 7140', '	+60 4 899 3441
+60 4 890 1414', '	+60 4 890 7140', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '-contract for IP case only
-Generally, NOT cover Guest Meal, Guest Bed, cosmetic treatment, personal item.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TEJ', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TLH', 'Out', 'Ms Sara Tseng', '', '', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '- contract signed for In patient only.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TLH', 'In', 'Ms Sara Tseng 
886 3 494 1234 ext.2193 tsengat@landseed.com.tw', '886 3 492 0808 24hrs', '886 3 494 2211 24hrs', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Official contract expired on 31/1/2013 and HKAH decided not to renew.
We can accept their LOG case by case, pls refer to Senior or Manager if any new case.  (use AR code: MIS1)  
15/3/2013 (NH)', '<LOG sample> H:\Patient Account\Insurance Card Program\Taiwan Landseed Hospital\LOG sample.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TM', 'Out', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180days case.
- Cover Physical Therapy (with Dr referral letter)', '- Accept card in white / yellow color / green with Prestige logo', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TM', 'In', '36515833 Ms. Kau 91245267 sephia.kau@prestigein.com
36515700 Main Line', '28680612', '28014062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- Limits to Semi-private class (2 beds).
- Accept card in white / yellow / green color with Prestige logo', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TMD', 'In', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '34059888/34059723', '25292509 main fax', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\TOKIO_TokioMarine & Fire Insurance.tif', '', '', '- Only cover Standard room unless medical necessity. (verbally cfm by Angela Wong on 23/2/2012 (NH)) 
- Do not accept Certificate shows "Sony Corporation".
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Tokio Marine\Sony ', '3 name of policy are also accepted:
1) Toko Marine & Fire Insurance Co Ltd
2) Tokio Marine & Nichido Fire Insurance Co. Ltd
3) Nichido Fire & Marine Insurance Co Ltd (AR code - NICHI)
4. Claim form only for Cashless bill, not for self pay claim.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Tokio Marine\IN_OUT claim form 20140724 (for cashless claim only).pdf', 'H:\Patient Account\Insurance Card Program\Tokio Marine\Tokio Marine.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TMD', 'Out', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '34059888/34059723', '25292509 main fax', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Accept Policy / Certificate issued by Japan only:
1. Policy / Certificate / White paper
2. Sickness / Accident coverage in Japanese Yen Dollar', 'DO NOT Accept Policy / Certificate :
1. No sickness / accident / injury coverage
2. Certificate shows "Sony Corporation".  
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Tokio Marine\Sony Corporation.pdf
3. Do not acce', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Tokio Marine\IN_OUT claim form 20140724 (for cashless claim only).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOKIO', 'In', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '34059888/34059723', '2529-2509 main fax', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\TOKIO_TokioMarine & Fire Insurance.tif', '', '', '- Only cover Standard room unless medical necessity. (verbally cfm by Angela Wong on 23/2/2012 (NH)) 
Accept Card issued by Japan only:
1. Sickness / Accident coverage in Japanese Yen Dollar', '- Do not accept Policy no. starting ''GTA'' (policy issued by The Tokio Marine and Fire Insurance Co (HK) Ltd. from 1 Aug 2011.
4. Claim form only for Cashless bill, not for self pay claim.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Tokio Marine\IN_OUT claim form 20140724 (for cashless claim only).pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Tokio Marine\Tokio Marine.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOKIO', 'Out', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '34059888/34059723', '25292509 main fax', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Accept Card issued by Japan only:
1. Sickness / Accident coverage in Japanese Yen Dollar', '- Do not accept Policy no. starting ''GTA'' (i.e. HK policy issued by The Tokio Marine and Fire Insurance Co (HK) Ltd.) effect from 1 Aug 2011.
4. Claim form only for Cashless bill, not for self pay claim.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Tokio Marine\IN_OUT claim form 20140724 (for cashless claim only).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOKIO1', 'Out', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '34059888/34059723', '25292509 main fax', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'Accept Card:
- Do not accept Policy no. starting ''GTA'' (policy issued by The Tokio Marine and Fire Insurance Co (HK) Ltd. from 1 Aug 2011.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOKIO1', 'In', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '34059888/34059723', '25292509 main fax', '', '', 0.0, 0.0, 0.0, -1.0, '', '', '', '', 'DO NOT ACCEPT', '- Do not accept Policy no. starting ''GTA'' (policy issued by The Tokio Marine and Fire Insurance Co (HK) Ltd. from 1 Aug 2011.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOKIO2', 'Out', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '34059888/34059723', '2529-2509 main fax', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Tokio Marine\Embossed card sample.bmp', '', '', '', '- Embossed Card
- Accept Card issued by Japan only:
1. Sickness / Accident coverage in Japanese Yen Dollar', '- Do not accept Policy no. starting ''GTA'' (i.e. HK policy issued by The Tokio Marine and Fire Insurance Co (HK) Ltd.) effect from 1 Aug 2011.
4. Claim form only for Cashless bill, not for self pay claim.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Tokio Marine\IN_OUT claim form 20140724 (for cashless claim only).pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOKIO2', 'In', '24HRS Toll Free: 800-966933
Tel : 25294401 main
Fax : 2529 1130 (directly line for Claims Dept.)', '34059888/34059723', '2529-2509 main fax', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\TOKIO_TokioMarine & Fire Insurance.tif', '', '', '- Only cover Standard room unless medical necessity. (verbally cfm by Angela Wong on 23/2/2012 (NH)) 
Accept Card issued by Japan only:
1. Sickness / Accident coverage in Japanese Yen Dollar', '- Do not accept Policy no. starting ''GTA'' (policy issued by The Tokio Marine and Fire Insurance Co (HK) Ltd. from 1 Aug 2011.
4. Claim form only for Cashless bill, not for self pay claim.', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Tokio Marine\IN_OUT claim form 20140724 (for cashless claim only).pdf', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\Tokio Marine\Tokio Marine.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOSHIBA', 'In', 'Ms. Kau: 3651-5833 / 9124-5267
3651-5700 (Main Line)
sephia.kau@prestigein.com', '2868-0612', '2801-4062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '-Limits to Semi-private class (2 beds)', 'Room coverage summary:
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls
-refer exclusion list of Column No. 4', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOSHIBA', 'Out', 'Ms. Kau: 3651-5833 / 9124-5267
3651-5700 (Main Line)
sephia.kau@prestigein.com', '2868-0612', '2801-4062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180 days case
- Cover Physical Therapy (with Dr referral letter)', '-Accept card in yellow color with Prestige logo', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOYOTA', 'Out', 'Ms. Kau: 3651-5833 / 9124-5267
3651-5700 (Main Line)
sephia.kau@prestigein.com', '2868-0612', '2801-4062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180 days case
- Cover Physical Therapy (with Dr referral letter)', '-Accept card in pink color with Prestige logo', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TOYOTA', 'In', 'Ms. Kau: 3651-5833 / 9124-5267
3651-5700 (Main Line)
sephia.kau@prestigein.com', '2868-0612', '2801-4062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '-Limits to Semi-private class (2 beds)', 'Room coverage summary
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TPLI', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TPLI', 'In', '', '21794700
2545-8111', '2854-4223', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'do not accept', '- The credit limit extended to the Company is HK$300K subject to review in future.
- In August 2009, Tai Ping Life said to our Inpatient staff that they do not have billing arrangement with our hospital.', to_date(''), '', '', '\\hkim\PA Share\Patient Account\Insurance Card Program\Voucher - IPD\TAIPING.doc', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TPM', 'Out', 'MS. OLIVE YIU-MARKETING MANAGER 93727251 TPM_MEDICARE@YAHOO.COM.HK', '(852) 36225838', '(852) 36203768', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '- Agreement signed for both In + Out patient', '- HKAH consent is required if there is no consent part shown on the insurance''s designated document (if any).', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TPM', 'In', 'Ms. Olive Yiu - Marketing Manager 9372 7251 
tpm_medicare@yahoo.com.hk', '(852) 3622 5838', '(852) 3620 3768', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '- Agreement signed for both In + Out patient', '- HKAH consent is required if there is no consent part shown on the insurance''s designated document (if any).', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TRICA', 'In', 'Singapore Tricare Call Center
800 905 833 (Toll Free) or
+65 6338 9277 or  
email: sin.tricare@internationalsos.com / providerasiapacific@internationalsos.com', '800 905 833 (Toll Free) press Option 5 for Provider contact.', '+65 6336 0921', '', '', 0.0, 0.0, -1.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\ISOS - Tricare\Exclusions.pdf', '', '', '- Use same claim form for both inpatient & outpatient (Form No.: UB-04, at left bottom corner).
- Remember to mark "Y" in Section 53 (to pay to provider) i.e ASG. BEN and sign in Section 80 i.e Remark by HKAH authorized person (not must be a physician).', '- password for opening Tricare attachment : 01JanU2*!5
- password for opening Tricare attachment : 01JulY2*!4
- password for opening Tricare attachment : 01JanU2*!4
- password for opening Tricare attachment : 01JulY2*!3
- password for opening Tricare ', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\ISOS - Tricare\Claim Form & Instruction.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TRICA', 'Out', 'Singapore Tricare Call Center
800 905 833 (Toll Free) or
+65 6338 9277 or  
email: sin.tricare@internationalsos.com / providerasiapacific@internationalsos.com', '800 905 833 (Toll Free) press Option 5 for Provider contact.', '+65 6336 0921', '', '', 0.0, 0.0, -1.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\ISOS - Tricare\Exclusions.pdf', '', '', '- Request Medication Breakdown
- HKAH Medical Report (due to Tricare always needs, 28-4-2015rita)
- Use same claim form for both inpatient & outpatient (Form No.: UB-04, at left bottom corner).
- Remember to mark "Y" in Section 53 (to pay to provider) ', '- password for opening Tricare attachment : 01JanU2*!5
- password for opening Tricare attachment : 01JulY2*!4
- password for opening Tricare attachment : 01JanU2*!4
- password for opening Tricare attachment : 01JulY2*!3
- password for opening Tricare ', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\ISOS - Tricare\Claim Form & Instruction.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TRYG', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TRYG', 'In', 'email: alarm@tryg.dk', '+45-4468-8100', '+45-4468-8400', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', 'Cover by LOG', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TSCL', 'In', '24/7 Tel: 3723 3098  Fax: 2810 0260
email: info@sp-con.hk', '3723 3097', '2810 0260', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\The Specialist Consortium\LOG Template - (2013-03-25).pdf', '', '', '', '', '1. Provide discharge summary for billing.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TSCL', 'Out', '24/7 Tel: 3723 3098  Fax: 2810 0260
email: info@sp-con.hk', '3723 3097', '2810 0260', '', '', 0.0, 0.0, -1.0, 0.0, '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\The Specialist Consortium\LOG Template - (2013-03-25).pdf', '', '', '', '', '1. Sign HKAH consent form.
2. Pls provide medical report for billing.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TSW', 'In', '', '44-2088478099', '44-1733502293', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Do Not Accept', 'ALERT CASE
Difficult to get authorization from the agent even they promise to send. After patient left they will need more information from others, then delay the LOG.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TSW', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TTTS', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TTTS', 'In', '', '2312-1651', '2312-1849', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TUCG', 'In', 'turconhk@biznetvigator.com
Ms Chan', '2572-1331', '2893-1771', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Insurance Card Program\IPD_Insurance Name List & Void List\Name List_ConsulateGeneral of Turkey_Dec01.tif', '', '', '', 'Cover all expenses + Dental Services but except baby delivery
Copy patient''s passport or ID.', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TUCG', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TYSO', 'Out', 'Mr. Purple Tse - contact number 
T: 8109 2411  F: 8109 2422
purple@tyhealthcare.com
Ms Joe (T: 23852093)
Dr. Terence Chow
ops.hongkong@gmail.com', '2385-0198', '2385-1507/8109-2422', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '- no contract for both IN and OUT.
- Accept case by case if under Guarantee Letter
- Credit card is accepted if settlement made in 7 days upon rec''d the invoice.', 'TY''s own consent is required:
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\TY Solution\Patient Consent.pdf', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('TYSO', 'In', 'Mr. Purple Tse - contact number 
T: 8109 2411  F: 8109 2422
purple@tyhealthcare.com
Ms Joe (T: 23852093)
Dr. Terence Chow
ops.hongkong@gmail.com', '2385-0198', '2385-1507/8109-2422', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', 'Credit card is accepted if settlement made in 7 days upon rec''d the invoice.', 'Patient Consent Form:
\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\TY Solution\Patient Consent.pdf', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\TY Solution\Medical Report.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UA', 'In', 'fax:800-95-4894', '65-6535-5833
800-96-3010', '65-6535-5052', '', 'No Limit', 0.0, -1.0, -1.0, -1.0, '', '', '', '', 'DO NOT ACCEPT', 'TEMPOARILY TERMINATED', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UA', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UAE', 'In', 'Ms. Shirley Chan - Secretary
Tel; +852 3765 9006 (Direct)
Mobile: +852 9493 5211
email: secretary@uaehk.com', '+852 2866 1823', '+852 2866 1690', '', '', 0.0, 0.0, 0.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Consulate General of the United Arab Emirates\Name List as of 27Feb2015.pdf', '', '', '', '- Ask patient to sign HKAH Consent.', '- Check name list:
- Please see attached LOG & Passport copies. (LOG is valid at all times)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UAE', 'Out', 'Ms. Shirley Chan - Secretary
Tel; +852 3765 9006 (Direct)
Mobile: +852 9493 5211
email: secretary@uaehk.com', '+852 2866 1823', '+852 2866 1690', '', '', 0.0, 0.0, 0.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Consulate General of the United Arab Emirates\Name List as of 27Feb2015.pdf', '', '', '', '- Ask patient to sign HKAH consent form', '- Check name list:
  1. Mr. Ahmed Naser Abderlarhim Mohamed ALKHAJA
  2. Mr. Khalid Ali Abdulla Dahmash ALTUNAIJI & his family members
- Please see attached LOG & Passport copies. (LOG is valid at all times)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UFJ', 'Out', '36515833 Ms. Kau
36515700 Main Line', '28680612', '28014062', '', 'Office Hour Only', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PIHK.doc', 'H:Patient Account\Insurance Card Program\Voucher - OPD\PIHK 3.jpg', '', '1. UFJ Bank merged with MUFG.  Please use AR code PIHK  for both UFJ Bank and MUFG card.
2. Please do not use PIUFJ AR code.', '- Accept UFJ Bank card printed with Prestige International.
- Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not need to call PIHK to clarify.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UFJ', 'In', '36515833 Ms. Kau
36515700 Main Line', '28680612', '28014062', '', 'No Limit', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\PIHK.doc', '', '', '- Limits to Semi-private room (2 beds).
- Class could be revised if obtained physician report
- Notify of Admission is Needed.', '1. UFJ Bank merged with MUFG. Please use AR code PIHK  for both UFJ Bank and MUFG card.
2. Please do not use PIUFJ AR code.
3. Aug 2010, confirmed with PIHK, if the benefit of sickness on patient''s policy is blank, cashless can be provided.  We do not n', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UMP1', 'In', 'email: inquiry@ump.com.hk
Provider Relations 2507 6974
Non-office hour: 8208 9208 (24hrs hotline)', '2824 0231', '2511 1152', '', 'No Limit', 200000.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\UMP\Voucher.pdf', '', '(Same as other UMP cards)
- Accept Card with embossment "HOSP"
- Covers for 200,000.00 or 15 days
- Maternity care need to confirmed with UMP', '- Voucher + hospitalization claim form', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\UMP\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UMP1', 'Out', 'email: inquiry@ump.com.hk
T: 2507 6974
Non-office hour: 8208 9208 (24hrs hotline)', '2824 0231', '2511 1152', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - OPD\UMP.jpg', '', 'DO NOT ACCEPT', '1. DO NOT pass blank voucher ( without amount ) to patient to sign.
2. Patient has to countersign the voucher if the amount has been revised.
3. Imprint insurance card clearly on voucher.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UMP2', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UMP2', 'In', 'email: inquiry@ump.com.hk
Provider Relations 2507 6974
Non-office hour: 8208 9208 (24hrs hotline)', '2824 0231', '2511 1152', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\UMP\Voucher.pdf', '', '(Same as other UMP cards)
- Accept Card with embossment "HOSP"
- Covers for 200,000.00 or 15 days
- Maternity care need to confirmed with UMP', '- Voucher + hospitalization claim form', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\UMP\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UMP3', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UMP3', 'In', 'email: inquiry@ump.com.hk
Provider Relations 2507 6974
Non-office hour: 8208 9208 (24hrs hotline)', '2824 0231', '2511 1152', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\UMP\Voucher.pdf', '', '(Same as other UMP cards)
- Accept Card with embossment "HOSP"
- Covers for 200,000.00 or 15 days
- Maternity care need to confirmed with UMP', '- Voucher + hospitalization claim form', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\UMP\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UMP4', 'In', 'email: inquiry@ump.com.hk
Provider Relations 2507 6974
Non-office hour: 8208 9208 (24hrs hotline)', '2824 0231', '2511 1152', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\UMP\Voucher.pdf', '', '(Same as other UMP cards)
- Accept Card with embossment "HOSP"
- Covers for 200,000.00 or 15 days
- Maternity care need to confirmed with UMP', '- Voucher + hospitalization claim form', to_date(''), '', '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\UMP\Claim Form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UMP4', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UNITEDH', 'In', '24/7 Provider Hotline: +1 763 274 7362
email: gsops@uhc.com', '', '+1 813 877 8167', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\UnitedHealth International\United Healthcare LOG (VOB).pdf', '', '', '', 'UHI only issues LOG if card has "Global Solutions" wordings at the bottom of card face
H:\Patient Account\Insurance Card Program\UnitedHealth International\UHI Sample Cards.doc', '1. Accept LOG (=VOB) 
2. Accept e-billing: uhciclaims@uhc.com
3. No claim form is required
4. May cover for new born baby, refer to LOG', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('UNITEDH', 'Out', '24/7 Provider Hotline: +1 763 274 7362
email: gsops@uhc.com', '', '+1 813 877 8167', '', '', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\UnitedHealth International\United Healthcare LOG (VOB).pdf', '', '', '', 'UHI only issues LOG if card has "Global Solutions" wordings at the bottom of card face
H:\Patient Account\Insurance Card Program\UnitedHealth International\UHI Sample Cards.doc', '1. Accept LOG (=VOB)
2. Accept e-billing: uhciclaims@uhc.com
3. No claim form is required (but need to sign HKAH consent)', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('USN', 'In', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011
Billing Fax: 3071 3012', '25289998 HK', '2528 9933', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', '-For US navy case, pt only entitled to 2nd class', '-Guarantee is needed from ISOS on or before patient discharged, or otherwise, patient must need to settle their own', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('USN', 'Out', 'Guarantee: 3122 8001
Billing Hotline: 3071 3011(Singapore)
Billing Fax: 3071 3012
HK Hotline: 2528 9900', '', '25289933', '', '', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '- Request Medication Breakdown
- Accept by LOG', 'Ask patient to sign HKAH consent form.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VHI1', 'In', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VHI1', 'Out', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'Only covers health cheuk up', '1. Verihealth should settle bills before outstanding bills have accumulated to 6. 
2. VHI1 is only for Health Examination, not for general consultation or any other service.

Do not accept card 
1. If over 5 cases are not yet settled by Verihealth, we', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VI', 'In', 'Tel: +603 2178 0550 (Malaysia office)
Fax: +603 2178 1499 
LOG: admissions@vanbreda.com
starting from 2 Feb 2015 
LOG: authorization@cigna.com
Tel: +603 2178 1411', '+32 3217-5730 (24hrs)
(Belgium)', '+32 3217 6620', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Vanbreda International\Guarantee of Payment form.pdf', '', '', '', '- For the payment method to be made by VI to HKAH, if the guarantee shows USD currency, please ask VI to revise to HKD currency.
- can use e-billing, not req''d to submit original invoice.  billing@vanbreda.com
- starting from 2 Feb 2015 please send e-bi', '-Vanbreda becomes Cigna from 2 Feb 2015. PLEASE REFER TO AR CODE CIGVI.
- We will accept the OLD Vanbreda card until 1 September 2015.', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Cost Estimate form (Pre-Auth form).pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VI', 'Out', 'Tel: +603 2178 0550 (Malaysia office)
Fax: +603 2178 1499 
LOG: admissions@vanbreda.com', '+32 3217-5730 (24hrs)
(Belgium)', '+32 3217 6620', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Vanbreda International\Guarantee of Payment form.pdf', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Exclusions for Outpatient.pdf', '', '', '- Claim form is only required for outpatient treatment below HK$1,500 (total medical expenses).
- can use e-billing, not req''d to submit original invoice.  billing@vanbreda.com
- starting from 2 Feb 2015, please send e-billing to bills@cigna.com', '-Vanbreda becomes Cigna from 2 Feb 2015. PLEASE REFER TO AR CODE CIGVI.
-We will accept the OLD Vanbreda card until 1 September 2015. 
-  LOG is NOT required for Outpatient medical expenses >/= HK$1,500.  No co-pay is needed.
-  If total medical expens', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Cost Estimate form (Pre-Auth form).pdf', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Outpatient claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VI_A+', 'In', 'Tel: +603 2178 0550 (Malaysia office)
Fax: +603 2178 1499 
LOG: admissions@vanbreda.com', '+32 3217-5730 (24hrs)
(Belgium)', '+32 3217 6620', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Vanbreda International\Cost Estimate form (Pre-Auth form).pdf', '', '', '', 'DO NOT ACCEPT', 'TERMINATED (Effect from 1 Jan 2012)

Vanbreda only issue LOG for Inpatient >/= HK$1,500 medical expenses.
If <HK$1,500 medical expenses, pls ask patient to pay and claim from Vanbreda.

Pre-Authorization Form:
H:\Patient Account\Insurance Card Progr', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Guarantee of Payment form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VI_A+', 'Out', 'Tel: +603 2178 0550 (Malaysia office)
Fax: +603 2178 1499 
LOG: admissions@vanbreda.com', '+32 3217-5730 (24hrs)
(Belgium)', '+32 3217 6620', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Vanbreda International\Cost Estimate form (Pre-Auth form).pdf', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Exclusions for Outpatient.pdf', '', '', 'DO NOT ACCEPT', 'TERMINATED (Effect from 1 Jan 2012)

-  LOG is required for Outpatient medical expenses >/= HK$1,500. (no matter what the % shown on card).  No need to collect co-pay from patient.
-  If total medical expenses <HK$1,500, we can provide direct billing s', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Outpatient claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VI_Aramco', 'In', 'Tel: +603 2178 0550 (Malaysia office)
Fax: +603 2178 1499 
LOG: aramco@vanbreda.com', '+32 3217-5730 (24hrs)
(Belgium)', '+32 3217 6620', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\Vanbreda International\Guarantee of Payment form.pdf', '', '', '', '- For the payment method to be made by VI to HKAH, if the guarantee shows USD currency, please ask VI to revise to HKD currency.
- can use e-billing, not req''d to submit original invoice.  billing@vanbreda.com
- starting from 2 Feb 2015 please send e-bi', '-Vanbreda becomes Cigna from 2 Feb 2015. PLEASE REFER TO AR CODE CIGVI.
-We will accept the OLD Vanbreda card until 1 September 2015.', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Cost Estimate form (Pre-Auth form).pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VI_Aramco', 'Out', 'Tel: +603 2178 0550 (Malaysia office)
Fax: +603 2178 1499 
LOG: aramco@vanbreda.com', '+32 3217-5730 (24hrs)
(Belgium)', '+32 3217 6620', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Vanbreda International\Guarantee of Payment form.pdf', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Exclusions for Outpatient.pdf', '', '', '- For the payment method to be made by VI to HKAH, if the guarantee shows USD currency, please ask VI to revise to HKD currency.
- Claim form is only required for outpatient treatment below HK$1,500 (total medical expenses).
- can use e-billing, not req', '-Vanbreda becomes Cigna from 2 Feb 2015. PLEASE REFER TO AR CODE CIGVI
We will accept the OLD Vanbreda card until 1 September 2015. 
-  LOG is NOT required for Outpatient medical expenses >/= HK$1,500.  No co-pay is needed.
-  If total medical expenses', to_date(''), '', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Cost Estimate form (Pre-Auth form).pdf', 'H:\Patient Account\Insurance Card Program\Vanbreda International\Outpatient claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VI2', 'In', '32-3-2176865', '', '32-3-2367538', '', '', 0.0, 0.0, -1.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\VANBREDA.doc', '', '', '- Please refer to Vanbreda International for more details: (AR code: VI)
- For the payment method to be made by VI to HKAH, if the guarantee shows USD currency, please ask VI to revise to HKD currency.', '-Vanbreda becomes Cigna from 2 Feb 2015. PLEASE REFER TO AR CODE CIGVI.
-We will accept the OLD Vanbreda card until 1 September 2015.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VI2', 'Out', '32-3-2176865', '', '32-3-2367538', '', '', 0.0, 0.0, -1.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\VANBREDA.doc', '', '- Please refer to Vanbreda International for more details: (AR code: VI)
- For the payment method to be made by VI to HKAH, if the guarantee shows USD currency, please ask VI to revise to HKD currency.', '-Vanbreda becomes Cigna from 2 Feb 2015. PLEASE REFER TO AR CODE CIGVI
We will accept the OLD Vanbreda card until 1 September 2015. 
- By guarantee letter.
- Also accept Check-up service with member ID # starting with "206/".
- Consent is required.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VIL', 'Out', 'Eric 3427 8381 / 6072 0274
Tony Tsui 98017205
Silvia Cheung', '2135 0718
3110 1488', '25294576 / 30054760', '', 'No Limit', 0.0, -1.0, -1.0, 0.0, '', '', '', '', '', '1. Request patient to sign HKAH consent form and on bill.
2. Refer to Letter of Guarantee for Coverage', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VIL', 'In', 'Eric 3427 8381 / 6072 0274
Tony Tsui 98017205
Silvia Cheung', '2135 0718
3110 1488', '25294576 / 30054760', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VTC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('VTC', 'IN', 'LOG - Ms. Juliana Ng Tel: 2836 1019', '2836 1008', '2575 8613', '', '', 0.0, 0.0, -1.0, 0.0, '', '', 'H:\Patient Account\Insurance Card Program\VTC\VTC LOG 20101129.pdf', '', '	If patient requests for a room level higher than HR approval, patient must settle ALL expenses by himself / herself. (mentioned on LOG)', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WAC', 'Out', '', 'Toll Free 
Tel :	800 96 3014', '800 96 4894', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', '- guarantee letter is required
- ask patient to fill-out claim form (faxed from WAA)
- copy required documents mentioned in guarantee letter.', '- agreement signed for both In and Out patient department
- WAA guarantees various insurance companies', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WAC', 'In', '', '65-6535-5833', '65-6535-5052', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', '', '', 'On Behalf of gurantee medical Policy Yasuda Fire & Marine Insurance.
Addition Medical Policy-Sompo Japan/ Nissan Fire & Marine. On behalf of Mother Insurance Mondial Assistance France to operate the guarantee (Susan Yates/ Athenia for BlueCross & Blue Sh', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WAP', 'In', '', '86-755-669-4556', '86-755-669-7407', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', '', 'Checked HATS no business record so far.  Please check and get approval from manager before accepting this company. If accept, need to check what kind of claim document required,  Rita 1-Jun-2010.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WAP', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WATAMI', 'In', 'Ms. Kau: 3651-5833 / 9124-5267
3651-5700 (Main Line)
sephia.kau@prestigein.com', '2868-0612', '2801-4062', '', '', 0.0, 0.0, 0.0, -1.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '-Limits to Semi-private class (2 beds)', 'Room coverage summary:
H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Inpatient room coverage.xls
-refer exclusion list of Column No. 4', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Pre-Auth Form.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WATAMI', 'Out', 'Ms. Kau: 3651-5833 / 9124-5267
3651-5700 (Main Line)
sephia.kau@prestigein.com', '2868-0612', '2801-4062', '', '', 0.0, 0.0, 0.0, 0.0, '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\PIHK Comparison Table (1-1-2015).pdf', '', '', '- accept +180 days case
- Cover Physical Therapy (with Dr referral letter)', '-Accept card in yellow color with Prestige logo', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Prestige International (HK) Co Ltd\Claim Form HC 20130401.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WellBe', 'Out', 'Emergency Alarm Centre (Shanghai):+86-21-6440-1243 (japanese/mandarin)
hongkong@wellbemedic.com
issa@wellbemedic.com
fanny@wellbemedic.com', 'Mon-Fri : 2573 3667 Ms. Issa Chow
Ms. Fanny Wan', '28345206', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Well Be Membership Card (New Design_ 20121105).pdf', '', '', '', 'If no patient name on insurance card (i.e. MUKIMEI), pls copy patient''s paper policy cert (if any) and check the identity.  Otherwise, contact Well Be to verify patient identity.', '- 2 patient''s signatures are required on the 3-pages-set claim form
- contract not mention exclusion
- physical check-up covered (LOG not required)
- Wellbe will pay HKAH first and follow up shortfall with patient by themselve.
- Claim Form Instructio', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Claim Form Jan 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WellBe', 'In', 'Emergency Alarm Centre (Shanghai):+86-21-6440-1243 (japanese/mandarin)
hongkong@wellbemedic.com
issa@wellbemedic.com
fanny@wellbemedic.com', 'Mon-Fri : 2573 3667
Ms. Issa Chow
Ms. Fanny Wan', '28345206', '', '', 0.0, 0.0, -1.0, -1.0, 'h:\patient account\insurance card program\card face\wellbe2.jpg', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\wellbe exclusion.doc', '', '', '- Entitle for Semi-Private room.
-  JIA 01-Jun-2010 fax, all JIA''s inpatient case (JIA, Nissay Dowa, Fuji Fire, Asahi, Sony Assurance) will be handled by Well Be and use Well Be claim form.', '- copy laminating card
- 2 patient''s signatures are required on the 3-pages-set claim form.
- If patient requests private or higher class, please show patient Well Be''s ''Limit for Room Charge'' document (please refer the above link).  If patient still in', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Claim Form Jan 2015.pdf', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\WellBe.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WellBe1', 'In', 'Emergency Alarm Centre (Shanghai):+86-21-6440-1243 (japanese/mandarin)
hongkong@wellbemedic.com
issa@wellbemedic.com
fanny@wellbemedic.com', 'Mon-Fri : 2573 3667
Ms. Issa Chow
Ms. Fanny Wan', '28345206', '', '', 0.0, 0.0, -1.0, -1.0, 'h:\patient account\insurance card program\card face\wellbe2.jpg', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\wellbe exclusion.doc', '', '', '- Entitle for Semi-Private room.
-  JIA 01-Jun-2010 fax, all JIA''s inpatient case (JIA, Nissay Dowa, Fuji Fire, Asahi, Sony Assurance) will be handled by Well Be and use Well Be claim form.', '- copy laminating card
- 2 patient''s signatures are required on the 3-pages-set claim form.
- If patient requests private or higher class, please show patient Well Be''s ''Limit for Room Charge'' document (please refer the above link).  If patient still in', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Claim Form Jan 2015.pdf', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\WellBe.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WellBe1', 'Out', 'Emergency Alarm Centre (Shanghai):+86-21-6440-1243 (japanese/mandarin)
hongkong@wellbemedic.com
issa@wellbemedic.com
fanny@wellbemedic.com', 'Mon-Fri : 2573 3667 Ms. Issa Chow
Ms. Fanny Wan', '28345206', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Well Be Membership Card (New Design_ 20121105).pdf', '', '', '', 'If no patient name on insurance card (i.e. MUKIMEI), pls copy patient''s paper policy cert (if any) and check the identity.  Otherwise, contact Well Be to verify patient identity.', '- 2 patient''s signatures are required on the 3-pages-set claim form
- contract not mention exclusion
- physical check-up covered (LOG not required)
- Wellbe will pay HKAH first and follow up shortfall with patient by themselve.
- Claim Form Instructio', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Claim Form Jan 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WellBe2', 'In', 'Emergency Alarm Centre (Shanghai):+86-21-6440-1243 (japanese/mandarin)
hongkong@wellbemedic.com
issa@wellbemedic.com
fanny@wellbemedic.com', 'Mon-Fri : 2573 3667
Ms. Issa Chow
Ms. Fanny Wan', '28345206', '', '', 0.0, 0.0, -1.0, -1.0, 'h:\patient account\insurance card program\card face\wellbe2.jpg', 'H:\Patient Account\Insurance Card Program\IPD_Insurance Exclusion Detail\wellbe exclusion.doc', '', '', '- Entitle for Semi-Private room.
-  JIA 01-Jun-2010 fax, all JIA''s inpatient case (JIA, Nissay Dowa, Fuji Fire, Asahi, Sony Assurance) will be handled by Well Be and use Well Be claim form.', '- copy laminating card
- 2 patient''s signatures are required on the 3-pages-set claim form.
- If patient requests private or higher class, please show patient Well Be''s ''Limit for Room Charge'' document (please refer the above link).  If patient still in', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Claim Form Jan 2015.pdf', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\WellBe.doc', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WellBe2', 'Out', 'Emergency Alarm Centre (Shanghai):+86-21-6440-1243 (japanese/mandarin)
hongkong@wellbemedic.com
issa@wellbemedic.com
fanny@wellbemedic.com', 'Mon-Fri : 2573 3667 Ms. Issa Chow
Ms. Fanny Wan', '28345206', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Well Be Membership Card (New Design_ 20121105).pdf', '', '', '', 'If no patient name on insurance card (i.e. MUKIMEI), pls copy patient''s paper policy cert (if any) and check the identity.  Otherwise, contact Well Be to verify patient identity.', '- 2 patient''s signatures are required on the 3-pages-set claim form
- contract not mention exclusion
- physical check-up covered (LOG not required)
- Wellbe will pay HKAH first and follow up shortfall with patient by themselve.
- Claim Form Instructio', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Well Be (HK) Ltd\Claim Form Jan 2015.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WFPL', 'In', 'Mr. Danny Chow', '3406 6888', '2664 2201', '', '', 0.0, 0.0, 0.0, -1.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Nissin Group\Consent Forms\Patients with Consent Form.xls', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\CLAIM FORM SAMPLE.pdf', '', 'Maternity, Dietician is NOT covered
DEFAULT GENERAL WARD, In case need involuntary upgrade, still admit the patient but downgrade back to general ward once available.', '1. Check if patient has PERMANANT CONSENT FORM in the name list. 
2. If yes --> nomal registration; if no, ask patient to sign HKAH standard consent form
3. Use the Tokio Marine Claim Form
4. If patient see OP then IP, use claim form for EACH.
Billing', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\TMF OTAI claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WFPL', 'Out', 'Mr. Danny Chow', '3406 6888', '2664 2201', '', '', 0.0, 0.0, 0.0, 0.0, '\\hkim\pa share\Patient Account\Insurance Card Program\Nissin Group\Consent Forms\Patients with Consent Form.xls', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\CLAIM FORM SAMPLE.pdf', '', '', '1. Check if patient has PERMANANT CONSENT FORM in the name list. 
2. If yes --> nomal registration; if no, ask patient to sign HKAH standard consent form
3. Use the Tokio Marine Claim Form
Billing Team: please pass the HKAH consent form (one visit) to ', to_date(''), '', '', 'H:\Patient Account\Insurance Card Program\Nissin Group\TMF OTAI claim form.pdf', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WR', 'In', 'Out-pt & General Enquiry
Tel: +44 1276 486460
In-pt & emergency (24 hrs)
Tel: +44 1243 621155
email: claims@william-russell.com', '+44 1276 486460', '+44 1276 486476', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\William Russell\Letter of Guarantee - 20101018 HKAH (Final).pdf', '', '', '', '', 'Accept e-billing from 4 Feb 2014.
Email: claims.admin@william-russell.com AND 
c.c. to Sukhie.Virdi@william-russell.com', to_date(''), '', 'H:\Patient Account\Insurance Card Program\William Russell\Notification of Admission Form 20121011.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('WR', 'Out', 'Out-pt & General Enquiry
Tel: +44 1276 486460
In-pt & emergency (24 hrs)
Tel: +44 1243 621155
email: claims@william-russell.com', '+44 1276 486460', '+44 1276 486476', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, 'H:\Patient Account\Insurance Card Program\William Russell\Letter of Guarantee - 20101018 HKAH (Final).pdf', '', '', '', 'do not accept', '- Credit Service for In-Patient only.
- HKAH consent is required
- Accept e-billing from 4 Feb 2014.
Email: claims.admin@william-russell.com AND 
c.c. to Sukhie.Virdi@william-russell.com', to_date(''), '', '\\Hkim\im\Patients Accounts\Staff share\Patient Account\Insurance Card Program\William Russell\Outpatient\Out-Patient-Notification-Of-Procedure-2012.pdf', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('YASU', 'Out', '', '', '', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', 'Not Valid
Yasuda Fire already changed name to Sompo many years.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('YASU', 'In', '', '65-67325-810
800-963010', '65-67362-083', '', 'No Limit', 0.0, 0.0, -1.0, -1.0, '', '', 'H:\Patient Account\Insurance Card Program\Voucher - IPD\YASUDA.doc', '', 'DO NOT ACCEPT', '180 day rule applies
Yasuda Fire already changed name to Sompo many years.', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ZC', 'Out', '', '', '', '', '', 0.0, 0.0, 0.0, 0.0, '', '', '', '', 'DO NOT ACCEPT', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ZC', 'In', '', '2161-0222', '2968-2335', '', 'No Limit', 0.0, 0.0, -1.0, 0.0, '', '', '', '', 'Cover "ALL" expenses', '', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ZIM', 'Out', 'Mandy Ng, HR Supervisor 
email: ng.mandy@hk.starcont.com 
T: 2598 5305   F: 2519 8359', '2598-5382', '25839208', '', '', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\ZIM Integrated Shipping Services Ltd\HK Adventist - Updated Name List 29 December 2014.xls', '', '', '', '', '- check name list
- HKAH consent form is required 
- No agreement
- Cover "ALL" expenses', to_date(''), '', '', '', '', 0.0, '');


INSERT INTO ARCARDTERM (CARDID, TYPE, CONTACT_DETAILS, CONTACT_PHONE, FAX, OFC_HOUR, TIME_LIMIT, LIMIT, PRE_AUTHOURISE, GUARANTEE, ACKNOWLEDGE, NAME_LIST, EXCLUSION, VOUCHER, TERMS, ALERT, REMARKS, LASTDATE, LASTMODIFY, PRE_AUTHORISE_FORM, CLAIM_FORM, ACKNOWLEDGE_FORM, PRE_AUTHORISATION, PRE_AUTHORISATION_MEMO) 
VALUES ('ZIM', 'In', 'Mandy Ng, HR Supervisor 
email: ng.mandy@hk.starcont.com 
T: 2598 5305   F: 2519 8359', '2598-5382', '2519 8359', '', 'No Limit', 0.0, 0.0, 0.0, 0.0, 'H:\Patient Account\Insurance Card Program\ZIM Integrated Shipping Services Ltd\HK Adventist - Updated Name List 29 December 2014.xls', '', '', '', '', '- check name list.
- No agreement
- Cover "ALL" expenses', to_date(''), '', '', '', '', 0.0, '');

COMMIT;

