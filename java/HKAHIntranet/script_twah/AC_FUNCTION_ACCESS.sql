ALTER TABLE AC_FUNCTION_ACCESS
 DROP PRIMARY KEY CASCADE;
DROP TABLE AC_FUNCTION_ACCESS CASCADE CONSTRAINTS;

CREATE TABLE AC_FUNCTION_ACCESS
(
 AC_FUNCTION_ID VARCHAR2(50 BYTE) NOT NULL,
-- AC_USERNAME VARCHAR2(30 BYTE) DEFAULT 'ALL',
 AC_USER_ID VARCHAR2(20 BYTE) DEFAULT 'ALL',
 AC_GROUP_ID VARCHAR2(30 BYTE) DEFAULT 'ALL',
 AC_ACCESS_MODE VARCHAR2(1 BYTE) DEFAULT 'F',	/* [F]ull, [R]ead */
 AC_CREATED_DATE DATE DEFAULT SYSDATE,
 AC_CREATED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 AC_MODIFIED_DATE DATE DEFAULT SYSDATE,
 AC_MODIFIED_USER VARCHAR2(30 BYTE) DEFAULT 'SYSTEM',
 AC_ENABLED NUMBER(*,0) DEFAULT 1,
 PRIMARY KEY (AC_FUNCTION_ID, AC_GROUP_ID, AC_USER_ID)
);
ALTER TABLE AC_FUNCTION_ACCESS ADD (
 CONSTRAINT AC_FUNCTION_ACCESS_R01
 FOREIGN KEY (AC_FUNCTION_ID)
 REFERENCES AC_FUNCTION (AC_FUNCTION_ID));

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.user.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.user.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.user.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.user.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.user.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ssoUser.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ssoUser.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ssoUser.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ssoUser.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ssoUser.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.accessControl.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.accessControl.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.accessControl.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.document.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.document.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.document.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.document.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.document.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.admin', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.educationRecord.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classEnrollment.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classAttendance.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.admin', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.report', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.list', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.cancel', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.reject', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.approve', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.paperclip.list', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.type.hospital', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.type.education', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.type.marketing', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.type.infectionControl', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.type.osh', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.type.nursing', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.news.type.pi', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.cancel', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.list', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.inpatientBed.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.bed.occupancy.view', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.cancel', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.reject', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.approve', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceClaim.admin', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.task.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.task.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.task.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.task.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.task.list', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.doctor.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.doctor.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.doctor.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.doctor.view', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.doctor.list', 'admin');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.create', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.update', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.delete', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.view', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.list', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.create', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.update', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.delete', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.view', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.list', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.educationRecord.list', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classEnrollment.list', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classAttendance.list', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.create', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.update', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.delete', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.view', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.list', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.create', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.update', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.delete', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.view', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.list', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.create', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.update', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.delete', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.view', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.list', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.create', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.update', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.cancel', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.view', 'author');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.list', 'author');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.create', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.update', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.delete', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.view', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.create', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.update', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.delete', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.view', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.educationRecord.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classEnrollment.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classAttendance.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.create', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.update', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.delete', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.view', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.create', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.update', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.delete', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.view', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.create', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.update', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.delete', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.view', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.create', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.update', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.cancel', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.view', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.list', 'officeAdministrator');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.create', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.update', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.cancel', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.view', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.list', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.reject', 'officeAdministrator');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.approve', 'officeAdministrator');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.create', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.update', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.delete', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.view', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.create', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.update', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.delete', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.view', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.educationRecord.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classEnrollment.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classEnrollment.admin', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classAttendance.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.create', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.update', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.delete', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.view', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.create', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.update', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.delete', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.view', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.create', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.update', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.delete', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.view', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.create', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.update', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.cancel', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.view', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.list', 'manager');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.create', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.update', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.cancel', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.view', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.list', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.reject', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.approve', 'manager');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceClaim.admin', 'managerHR');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classEnrollment.list', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.educationRecord.list', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.create', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.update', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.cancel', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.view', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.list', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.create', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.update', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.cancel', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.view', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ce.list', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.create', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.update', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.delete', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.view', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.list', 'staff');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.create', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.update', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.delete', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.view', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.yearOfEmployee.list', 'staff');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.create', 'doctor');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.update', 'doctor');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.delete', 'doctor');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.view', 'doctor');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.projectSummary.list', 'doctor');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.create', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.update', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.delete', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.view', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.create', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.update', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.delete', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.view', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.admin', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.educationRecord.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classEnrollment.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classAttendance.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.create', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.update', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.delete', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.view', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.admin', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.report', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.create', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.update', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.delete', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.view', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.create', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.update', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.delete', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.view', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.create', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.update', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.cancel', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.view', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.list', 'managerEducation');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.evaluation.list', 'managerEducation');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staff.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.staffEducation.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.course.admin', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classSchedule.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.educationRecord.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classEnrollment.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.classAttendance.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eLesson.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.question.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.answer.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.cancel', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.leave.list', 'managerHR');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceApproval.delete', 'managerHR');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceClaim.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceClaim.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceClaim.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceClaim.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceClaim.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceClaim.admin', 'managerHR');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceBudget.list', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceBudget.view', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceBudget.update', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceBudget.create', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceBudget.delete', 'managerHR');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ceBudget.admin', 'managerHR');

----------------------------------------------------------
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activity.create', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activity.update', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activity.delete', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activity.view', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activity.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activityHistory.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activityHistory.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activityHistory.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activityHistory.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.activityHistory.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.affiliation.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.affiliation.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.affiliation.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.affiliation.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.affiliation.list', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.appeal.create', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.appeal.update', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.appeal.delete', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.appeal.view', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.appeal.list', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.campaign.create', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.campaign.update', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.campaign.delete', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.campaign.view', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.campaign.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.member.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.member.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.member.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.member.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.member.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.membership.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.membership.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.membership.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.membership.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.membership.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.pledge.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.pledge.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.pledge.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.pledge.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.pledge.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.event.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.event.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.event.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.event.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.event.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.event.enrollment', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.event.promotion', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.event.promotion.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eventType.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eventType.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eventType.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eventType.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eventType.list', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fund.create', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fund.update', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fund.delete', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fund.view', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fund.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHobby.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHobby.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHobby.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHobby.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHobby.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHospital.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHospital.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHospital.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHospital.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.interestHospital.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordIndividual.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordIndividual.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordIndividual.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordIndividual.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordIndividual.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordFamily.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordFamily.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordFamily.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordFamily.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.medicalRecordFamily.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.client.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.client.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.client.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.client.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.client.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.client.approval', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.client.export', 'crm');
--INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.client.import', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.questionnaire.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.questionnaire.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.questionnaire.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.questionnaire.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.questionnaire.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relationship.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relationship.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relationship.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relationship.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relationship.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relative.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relative.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relative.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relative.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.relative.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.donation.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.seminar.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.seminar.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.seminar.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.seminar.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.seminar.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.seminar.enrollment', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalGroup.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalGroup.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalGroup.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalGroup.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalGroup.list', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalFigure.create', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalFigure.update', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalFigure.delete', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalFigure.view', 'crm');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.crm.physicalFigure.list', 'crm');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.meetingRoom.booking.view', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.meetingRoom.booking.list', 'staff');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.meetingRoom.booking.view', 'meetingRoom.booking');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.meetingRoom.booking.list', 'meetingRoom.booking');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.create', 'ghc2hkah');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.update', 'ghc2hkah');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.delete', 'ghc2hkah');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.view', 'ghc2hkah');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.ghc.client.list', 'ghc2hkah');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eleave.create', 'eleave');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eleave.update', 'eleave');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eleave.delete', 'eleave');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eleave.view', 'eleave');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.eleave.list', 'eleave');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.bed.occupancy.view', 'senior.management');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.admission.create', 'admission.at.ward');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.admission.update', 'admission.at.ward');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.admission.delete', 'admission.at.ward');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.admission.view', 'admission.at.ward');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.admission.list', 'admission.at.ward');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.callList.client.list', 'call.back.patient.appointment');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.callBackHist.client.list', 'call.back.patient.appointment');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.callList.create', 'call.back.patient.appointment');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.callBackHist.update', 'call.back.patient.appointment');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.haa.create', 'haa');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.haa.update', 'haa');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.haa.delete', 'haa');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.haa.view', 'haa');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.haa.list', 'haa');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.info.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.info.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.info.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.info.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.info.view', 'admin');

-- marketing
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.list', 'coty.cheung');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.create', 'coty.cheung');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.update', 'coty.cheung');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.delete', 'coty.cheung');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.view', 'coty.cheung');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.type.marketing', 'coty.cheung');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.list', 'rebecca.leong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.create', 'rebecca.leong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.update', 'rebecca.leong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.delete', 'rebecca.leong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.view', 'rebecca.leong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.type.marketing', 'rebecca.leong');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.list', 'lee.wong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.create', 'lee.wong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.update', 'lee.wong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.delete', 'lee.wong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.view', 'lee.wong');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.info.type.marketing', 'lee.wong');

INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.document.create', 'coty.cheung');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.document.delete', 'coty.cheung');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.document.update', 'coty.cheung');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.document.view', 'coty.cheung');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.dr.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.dr.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.dr.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.dr.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.dr.view', 'admin');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.admltr.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.admltr.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.admltr.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.admltr.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.nurob.admltr.view', 'admin');

----------------------------------------------------------
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.dnt.tk.list', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.dnt.tk.create', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.dnt.tk.update', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.dnt.tk.delete', 'admin');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.dnt.tk.view', 'admin');

-- Forward Scanning
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.admin', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.import.list', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.importLog.list', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.importLog.view', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.importLog.update', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.file.list', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.file.create', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.file.update', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.file.delete', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.file.view', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.file.approve', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.category.list', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.category.create', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.category.update', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.category.delete', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.category.view', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.form.list', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.form.create', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.form.update', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.form.delete', 'forwardScanning');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_GROUP_ID) VALUES ('function.fs.form.view', 'forwardScanning');

--08/03/2012 forward scanning for Medical Record
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs', '21040');	-- Man Ying
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.admin', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.import.list', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.list', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.view', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.update', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.list', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.create', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.update', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.delete', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.view', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.approve', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.list', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.create', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.update', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.delete', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.view', '21040');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs', '09026');	-- Michael
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.admin', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.import.list', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.list', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.view', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.update', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.list', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.create', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.update', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.delete', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.view', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.approve', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.list', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.create', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.update', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.delete', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.view', '09026');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs', '09036');	-- Ryan
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.admin', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.import.list', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.list', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.view', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.importLog.update', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.list', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.create', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.update', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.delete', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.view', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.file.approve', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.list', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.create', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.update', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.delete', '09036');
INSERT INTO AC_FUNCTION_ACCESS (AC_FUNCTION_ID, AC_USER_ID) VALUES ('function.fs.form.view', '09036');