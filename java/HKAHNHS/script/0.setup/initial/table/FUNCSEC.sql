-- HKAH
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(650, 'ehrView', 'regPatReg', 'Registration -> Patient Registration -> eHR View', 'HKAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(665, 'ehrInfoCreate', 'regPatReg', 'Registration -> Patient Registration -> eHR Edit (create PMI)', 'HKAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(651, 'ehrInfoEdit', 'regPatReg', 'Registration -> Patient Registration -> eHR Edit (PMI)', 'HKAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(652, 'ehrNoEdit', 'regPatReg', 'Registration -> Patient Registration -> eHR No. Edit', 'HKAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(653, 'ehrSendPmiMatch', 'regPatReg', 'Registration -> Patient Registration -> eHR send match msg', 'HKAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(609, 'mnuRpWeekBill', '', 'Reprint Weekly Bill', 'HKAH');

insert into Role(rolid, rolnam, roldesc, stecode) values(seq_, 'EHR SUPER ADMIN', 'EHR SUPER ADMIN', 'HKAH');
insert into Role(rolid, rolnam, roldesc, stecode) values(94, 'EHR INFO', 'EHR PMI INFO OPERATOR', 'HKAH');
insert into Role(rolid, rolnam, roldesc, stecode) values(95, 'EHR SUPER ADMIN', 'EHR SUPER ADMIN', 'HKAH');
insert into Role(rolid, rolnam, roldesc, stecode) values(96, 'EHR SEND PMI ADMIN', 'EHR SEND PMI MATCH ADMIN', 'HKAH');
insert into Role(rolid, rolnam, roldesc, stecode) values(97, 'WeeklyBillViewer', 'Reprint the weekly bills', 'HKAH');

insert into RoleFuncSec(rfsid, rolid, fscid) values(3388, 94, 650);
insert into RoleFuncSec(rfsid, rolid, fscid) values(3389, 94, 651);
insert into RoleFuncSec(rfsid, rolid, fscid) values(3390, 95, 650);
insert into RoleFuncSec(rfsid, rolid, fscid) values(3391, 95, 651);
insert into RoleFuncSec(rfsid, rolid, fscid) values(3392, 95, 652);
insert into RoleFuncSec(rfsid, rolid, fscid) values(3394, 95, 654);
insert into RoleFuncSec(rfsid, rolid, fscid) values(3393, 96, 653);
insert into RoleFuncSec(rfsid, rolid, fscid) values(3400, 97, 609);

insert into UsrRole(uroid, usrid, rolid, stecode) values(1190, 'HKAH', 95, 'HKAH');
insert into UsrRole(uroid, usrid, rolid, stecode) values(1191, 'HKAH', 96, 'HKAH');
insert into UsrRole(uroid, usrid, rolid, stecode) values(1219, 'HKAH', 97, 'HKAH');

COMMIT;

-- TWAH
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(650, 'ehrView', 'regPatReg', 'Registration -> Patient Registration -> eHR View', 'TWAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(651, 'ehrInfoEdit', 'regPatReg', 'Registration -> Patient Registration -> eHR Info Edit', 'TWAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(652, 'ehrNoEdit', 'regPatReg', 'Registration -> Patient Registration -> eHR No. Edit', 'TWAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(653, 'ehrSendPmiMatch', 'regPatReg', 'Registration -> Patient Registration -> eHR send match msg', 'TWAH');
INSERT INTO FUNCSEC(FSCID, FSCKEY, FSCPARENT, FSCDESC, STECODE) VALUES(640, 'mnuRpWeekBill', '', 'Reprint Weekly Bill', 'TWAH');

insert into Role(rolid, rolnam, roldesc, stecode) values(360, 'EHR INFO', 'EHR PMI INFO OPERATOR', 'TWAH');
insert into Role(rolid, rolnam, roldesc, stecode) values(361, 'EHR ENROL ADMIN', 'EHR ENROLLMENT ADMIN', 'TWAH');
insert into Role(rolid, rolnam, roldesc, stecode) values(362, 'EHR SEND PMI ADMIN', 'EHR SEND PMI MATCH ADMIN', 'TWAH');
insert into Role(rolid, rolnam, roldesc, stecode) values(363, 'WeeklyBillViewer', 'Reprint the weekly bills', 'TWAH');

insert into RoleFuncSec(rfsid, rolid, fscid) values(2349, 360, 650);
insert into RoleFuncSec(rfsid, rolid, fscid) values(2345, 360, 651);
insert into RoleFuncSec(rfsid, rolid, fscid) values(2346, 361, 650);
insert into RoleFuncSec(rfsid, rolid, fscid) values(2347, 361, 651);
insert into RoleFuncSec(rfsid, rolid, fscid) values(2348, 361, 652);
insert into RoleFuncSec(rfsid, rolid, fscid) values(2349, 362, 653);
insert into RoleFuncSec(rfsid, rolid, fscid) values(2443, 363, 640);

insert into UsrRole(uroid, usrid, rolid, stecode) values(2319, 'TWAH', 361, 'TWAH');
insert into UsrRole(uroid, usrid, rolid, stecode) values(2320, 'TWAH', 362, 'TWAH');
insert into UsrRole(uroid, usrid, rolid, stecode) values(2460, 'TWAH', 363, 'TWAH');
COMMIT;