ALTER TABLE AC_FUNCTION
 DROP PRIMARY KEY CASCADE;
DROP TABLE AC_FUNCTION CASCADE CONSTRAINTS;

CREATE TABLE AC_FUNCTION
(
 AC_FUNCTION_ID VARCHAR2(50 BYTE) NOT NULL,
 AC_GROUP_ID VARCHAR2(30 BYTE) NOT NULL,
 AC_INTRANET_ONLY NUMBER(*,0) DEFAULT 0,	-- 0 for all, 1 for intranet only
 AC_CREATED_DATE DATE DEFAULT SYSDATE,
 AC_CREATED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 AC_MODIFIED_DATE DATE DEFAULT SYSDATE,
 AC_MODIFIED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 AC_ENABLED NUMBER(*,0) DEFAULT 1,
 PRIMARY KEY (AC_FUNCTION_ID)
);
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('general', 'function.todo.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('general', 'function.user.create');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.user.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.user.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.user.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.user.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.ssoUser.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.ssoUser.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.ssoUser.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.ssoUser.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.ssoUser.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staff.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staff.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staff.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staff.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staff.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staffEducation.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staffEducation.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staffEducation.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staffEducation.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.staffEducation.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.accessControl.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.accessControl.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.accessControl.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.function.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.function.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.function.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.function.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.function.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.hospital');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.education');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.humanResource');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.marketing');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.infectionControl');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.osh');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.nursing');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.pi');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.accreditation');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.news.type.physician');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.yearOfEmployee.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.yearOfEmployee.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.yearOfEmployee.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.yearOfEmployee.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.yearOfEmployee.list');

-- added by ck. lastest 20091016, 1112.
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.inpatientBed.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.bed.occupancy.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.mis.census.ipd');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.mis.census.opd');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.mis.census.ot');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.mis.census.lab');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.mis.census.year');
-- end of ck script

--add by cherry
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.colonoscopy.report');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.ot.cancelled.appointment.report');


INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.meetingRoom.booking.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.meetingRoom.booking.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.meetingRoom.booking.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.meetingRoom.booking.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.meetingRoom.booking.list');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.doctor.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.doctor.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.doctor.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.doctor.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.doctor.list');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.admission.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.admission.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.admission.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.admission.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.admission.list');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.newHATS.run');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('document', 'function.documentManagement.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('document', 'function.documentManagement.upload');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('document', 'function.documentManagement.admin');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.course.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.course.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.course.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.course.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.course.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.course.admin');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classSchedule.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classSchedule.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classSchedule.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classSchedule.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classSchedule.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classSchedule.admin');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.educationRecord.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classEnrollment.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classEnrollment.admin');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.classAttendance.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.eLesson.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.eLesson.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.eLesson.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.eLesson.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.eLesson.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.eLesson.admin');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.eLesson.report');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.question.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.question.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.question.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.question.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.question.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.answer.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.answer.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.answer.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.answer.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.answer.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.evaluation.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ce.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ce.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ce.cancel');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ce.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ce.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ce.reject');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ce.approve');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceApproval.list');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceApproval.view');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceApproval.update');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceApproval.create');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceApproval.delete');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceClaim.list');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceClaim.view');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceClaim.update');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceClaim.create');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceClaim.delete');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceClaim.admin');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceBudget.list');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceBudget.view');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceBudget.update');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceBudget.create');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceBudget.delete');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('education', 'function.ceBudget.admin');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('intranet', 'function.hospitalIntranet.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('intranet', 'function.physicianIntranet.view');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('eleave', 'function.eleave.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('eleave', 'function.eleave.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('eleave', 'function.eleave.cancel');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('eleave', 'function.eleave.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('eleave', 'function.eleave.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('eleave', 'function.eleave.admin');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID, AC_INTRANET_ONLY) VALUES ('paperclip', 'function.paperclip.list', 1);

--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activity.create');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activity.update');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activity.delete');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activity.view');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activity.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activityHistory.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activityHistory.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activityHistory.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activityHistory.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.activityHistory.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.affiliation.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.affiliation.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.affiliation.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.affiliation.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.affiliation.list');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.appeal.create');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.appeal.update');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.appeal.delete');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.appeal.view');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.appeal.list');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.campaign.create');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.campaign.update');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.campaign.delete');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.campaign.view');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.campaign.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.member.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.member.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.member.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.member.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.member.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.membership.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.membership.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.membership.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.membership.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.membership.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.pledge.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.pledge.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.pledge.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.pledge.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.pledge.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.enrollment');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.promotion');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.promotion.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.promotion.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.promotion.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.promotion.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.event.promotion.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.eventType.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.eventType.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.eventType.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.eventType.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.eventType.list');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.fund.create');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.fund.update');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.fund.delete');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.fund.view');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.fund.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHobby.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHobby.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHobby.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHobby.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHobby.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHospital.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHospital.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHospital.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHospital.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.interestHospital.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordIndividual.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordIndividual.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordIndividual.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordIndividual.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordIndividual.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordFamily.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordFamily.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordFamily.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordFamily.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.medicalRecordFamily.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.client.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.client.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.client.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.client.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.client.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.client.approval');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.client.export');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.client.import');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.questionnaire.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.questionnaire.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.questionnaire.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.questionnaire.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.questionnaire.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relationship.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relationship.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relationship.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relationship.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relationship.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relative.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relative.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relative.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relative.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.relative.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.donation.list');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.seminar.create');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.seminar.update');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.seminar.delete');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.seminar.view');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.seminar.list');
--INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.seminar.enrollment');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalGroup.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalGroup.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalGroup.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalGroup.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalGroup.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalFigure.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalFigure.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalFigure.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalFigure.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('crm', 'function.crm.physicalFigure.list');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.client.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.client.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.client.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.client.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.client.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.task.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.task.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.task.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.task.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.ghc.task.list');
-- Call Back
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.callList.client.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.callBackHist.client.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.callList.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('ghc', 'function.callBackHist.update');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('pmp', 'function.projectSummary.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('pmp', 'function.projectSummary.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('pmp', 'function.projectSummary.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('pmp', 'function.projectSummary.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('pmp', 'function.projectSummary.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('pmp', 'function.projectSummary.supervisor');

-- Health Assessment
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('haa', 'function.haa.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('haa', 'function.haa.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('haa', 'function.haa.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('haa', 'function.haa.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('haa', 'function.haa.list');

-- Information Page
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.delete');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.departmentalReport');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.healthAssessment');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.inPatient');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.keyPI');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.nursing');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.others');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.outPatient');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.riskManagement');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.accreditation');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans.2007');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans.2008');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans.2009');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans.2010');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans.annual');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans.business');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans.medical');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.admin.plans.meeting');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.adventist.corner');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.application');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.briefRoom.execOrder');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.briefRoom.minutes');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.briefRoom.survey');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.corporate');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.crisisAndDisaster');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.donoation');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.fees');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.benefits');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.calendar');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.contactHR');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.directory');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.evaluation');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.forms');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.jobs');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.news');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.payroll');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.policies');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.hr.training');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.informedConsent');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.marketing');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.minutes');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.newsletter');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.nursing');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.physician');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.policy.chap');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.regulations');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('admin', 'function.info.type.roster');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.admltr.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.admltr.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.admltr.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.admltr.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.admltr.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.dr.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.dr.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.dr.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.dr.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('nurob', 'function.nurob.dr.list');

-- Forward Scanning
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.admin');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.import.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.importLog.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.importLog.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.importLog.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.file.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.file.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.file.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.file.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.file.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.file.approve');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.file.approve.his');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.category.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.category.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.category.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.category.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.category.view');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.form.list');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.form.create');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.form.update');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.form.delete');
INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('forwardScanning', 'function.fs.form.view');

INSERT INTO AC_FUNCTION (AC_GROUP_ID, AC_FUNCTION_ID) VALUES ('di', 'function.di.payrollReport');