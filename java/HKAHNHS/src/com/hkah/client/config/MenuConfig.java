/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.config;

import java.util.HashMap;

import com.hkah.client.layout.panel.BasePanel;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class MenuConfig {

	private static HashMap<String, String> resource = new HashMap<String, String>();
	private static HashMap<String, BasePanel> resourceClass = new HashMap<String, BasePanel>();
	private static HashMap<String, String> resourceVariable = new HashMap<String, String>();
	public static final String NO_SUB_MENU_NAME = "";

	static {
		putMenu("menu.no", "18");
		putMenu("menu.1.name", "<u>F</u>ile", "mnuFile");
		putMenu("menu.1.dest", "#submenu.1");
		putMenu("menu.1.mnemonic", "F");
		putMenu("submenu.1.no", "6");
		putMenu("submenu.1.1.name", "Change Password", "mnuChangePassword");
		putMenu("submenu.1.3.name", "System Reload", "mnuReload");
		putMenu("submenu.1.5.name", "Close", "mnuClose");
		putMenu("submenu.1.6.name", "E<u>x</u>it", "mnuExit");

		putMenu("menu.2.name", "Ad<u>m</u>in", "mnuAdmin");
		putMenu("menu.2.dest", "#submenu.2");
		putMenu("menu.2.mnemonic", "m");
		putMenu("submenu.2.no", "9");

		putMenu("submenu.2.1.name", "S<u>e</u>curity", "mnuSecurity");
		putMenu("submenu.2.1.dest", "#submenu.2.1");
		putMenu("submenu.2.1.no", "8");
		putMenu("submenu.2.1.mnemonic", "e");
		putMenu("submenu.2.1.1.name", "<u>U</u>ser", "mnuUser");
		putPanel("submenu.2.1.1.dest", new com.hkah.client.tx.admin.security.User());
		putMenu("submenu.2.1.1.mnemonic", "U");
		putMenu("submenu.2.1.2.name", "<u>R</u>ole", "mnuRole");
		putPanel("submenu.2.1.2.dest", new com.hkah.client.tx.admin.security.Role());
		putMenu("submenu.2.1.2.mnemonic", "R");
		putMenu("submenu.2.1.3.name", "Role <u>A</u>ssignment", "mnuRoleAssign");
		putPanel("submenu.2.1.3.dest", new com.hkah.client.tx.admin.security.RoleAssignment());
		putMenu("submenu.2.1.3.mnemonic", "A");
		putMenu("submenu.2.1.4.name", "U<u>s</u>er Assignment", "mnuUserAssign");
		putPanel("submenu.2.1.4.dest", new com.hkah.client.tx.admin.security.UserAssignment());
		putMenu("submenu.2.1.4.mnemonic", "s");
		putMenu("submenu.2.1.5.name", "<u>F</u>unction Security", "mnuFuncSec");
		putPanel("submenu.2.1.5.dest", new com.hkah.client.tx.admin.security.FunctionSecurity());
		putMenu("submenu.2.1.5.mnemonic", "F");
		putMenu("submenu.2.1.6.name", "R<u>o</u>le Alert Assignment", "mnuAltAssign");
		putPanel("submenu.2.1.6.dest", new com.hkah.client.tx.admin.security.RoleAlertAssignment());
		putMenu("submenu.2.1.6.mnemonic", "O");
		putMenu("submenu.2.1.7.name", "<u>D</u>epartment Service Role Assignment", "mnu_ds_role");
		putPanel("submenu.2.1.7.dest", new com.hkah.client.tx.admin.security.DeptServiceRoleAssign());
		putMenu("submenu.2.1.7.mnemonic", "D");
		putMenu("submenu.2.1.8.name", "Department <u>C</u>harge", "mnu_dept_chrg");
		putPanel("submenu.2.1.8.dest", new com.hkah.client.tx.admin.security.DepartmentCharge());
		putMenu("submenu.2.1.8.mnemonic", "C");

		putMenu("submenu.2.2.name", "<u>S</u>ystem Code Table", "mnuSysCode");
		putMenu("submenu.2.2.dest", "#submenu.2.2");
		putMenu("submenu.2.2.mnemonic", "S");
		putMenu("submenu.2.2.no", "22");
		putMenu("submenu.2.2.1.name", "<u>S</u>ite", "mnuSite");
		putPanel("submenu.2.2.1.dest", new com.hkah.client.tx.admin.syscodetable.Site());
		putMenu("submenu.2.2.1.mnemonic", "S");
		putMenu("submenu.2.2.2.name", "Dis<u>t</u>rict", "mnuDist");
		putPanel("submenu.2.2.2.dest", new com.hkah.client.tx.admin.syscodetable.District());
		putMenu("submenu.2.2.2.mnemonic", "t");
		putMenu("submenu.2.2.3.name", "Patient <u>L</u>ocation", "mnuLoc");
		putPanel("submenu.2.2.3.dest", new com.hkah.client.tx.admin.syscodetable.Location());
		putMenu("submenu.2.2.3.mnemonic", "L");
		putMenu("submenu.2.2.4.name", "<u>A</u>ccomodation", "mnuAcm");
		putPanel("submenu.2.2.4.dest", new com.hkah.client.tx.admin.syscodetable.Accomodation());
		putMenu("submenu.2.2.4.mnemonic", "A");
		putMenu("submenu.2.2.5.name", "<u>P</u>rivilege", "mnuPrivil");
		putPanel("submenu.2.2.5.dest", new com.hkah.client.tx.admin.syscodetable.Privilege());
		putMenu("submenu.2.2.5.mnemonic", "P");
		putMenu("submenu.2.2.6.name", "S<u>p</u>ecialty", "mnuSpecial");
		putPanel("submenu.2.2.6.dest", new com.hkah.client.tx.admin.syscodetable.Specialty());
		putMenu("submenu.2.2.6.mnemonic", "p");
		putMenu("submenu.2.2.7.name", "<u>D</u>octor", "mnuDoctor");
		putPanel("submenu.2.2.7.dest", new com.hkah.client.tx.admin.syscodetable.Doctor());
		putMenu("submenu.2.2.7.mnemonic", "D");
		putMenu("submenu.2.2.8.name", "D<u>e</u>stination", "mnuDest");
		putPanel("submenu.2.2.8.dest", new com.hkah.client.tx.admin.syscodetable.Destination());
		putMenu("submenu.2.2.8.mnemonic", "e");
		putMenu("submenu.2.2.9.name", "Sic<u>k</u>", "mnuSick");
		putPanel("submenu.2.2.9.dest", new com.hkah.client.tx.admin.syscodetable.Sick());
		putMenu("submenu.2.2.9.mnemonic", "k");
		putMenu("submenu.2.2.10.name", "Department Ser<u>v</u>ice", "mnuDeptServ");
		putPanel("submenu.2.2.10.dest", new com.hkah.client.tx.admin.syscodetable.DepartmentService());
		putMenu("submenu.2.2.10.mnemonic", "v");
		putMenu("submenu.2.2.11.name", "S<u>u</u>b Disease", "mnuDisease");
		putPanel("submenu.2.2.11.dest", new com.hkah.client.tx.admin.syscodetable.SubDisease());
		putMenu("submenu.2.2.11.mnemonic", "u");
		putMenu("submenu.2.2.12.name", "<u>R</u>eason", "mnuReason");
		putPanel("submenu.2.2.12.dest", new com.hkah.client.tx.admin.syscodetable.Reason());
		putMenu("submenu.2.2.12.mnemonic", "R");
		putMenu("submenu.2.2.13.name", "Su<u>b</u> Reason", "mnuSubReason");
		putPanel("submenu.2.2.13.dest", new com.hkah.client.tx.admin.syscodetable.SubReason());
		putMenu("submenu.2.2.13.mnemonic", "b");
		putMenu("submenu.2.2.14.name", "Sour<u>c</u>e", "mnuSource");
		putPanel("submenu.2.2.14.dest", new com.hkah.client.tx.admin.syscodetable.Source());
		putMenu("submenu.2.2.14.mnemonic", "c");
		putMenu("submenu.2.2.15.name", "T<u>i</u>tle", "mnuTitle");
		putPanel("submenu.2.2.15.dest", new com.hkah.client.tx.admin.syscodetable.Title());
		putMenu("submenu.2.2.15.mnemonic", "i");
		putMenu("submenu.2.2.16.name", "<u>M</u>otherlang", "mnuMotherlang");
		putPanel("submenu.2.2.16.dest", new com.hkah.client.tx.admin.syscodetable.MotherLang());
		putMenu("submenu.2.2.16.mnemonic", "M");
		putMenu("submenu.2.2.17.name", "C<u>o</u>untry", "mnuCountry");
		putPanel("submenu.2.2.17.dest", new com.hkah.client.tx.admin.syscodetable.Country());
		putMenu("submenu.2.2.17.mnemonic", "o");
		putMenu("submenu.2.2.18.name", "<u>Q</u>ualification", "mnuQual");
		putPanel("submenu.2.2.18.dest", new com.hkah.client.tx.admin.syscodetable.Qualification());
		putMenu("submenu.2.2.18.mnemonic", "Q");
		putMenu("submenu.2.2.19.name", "Custom Report", "mnuCusRptCde");
		putPanel("submenu.2.2.19.dest", new com.hkah.client.tx.admin.syscodetable.CustomReport());
		putMenu("submenu.2.2.20.name", "Race", "mnuRace");
		putPanel("submenu.2.2.20.dest", new com.hkah.client.tx.admin.syscodetable.Race());
		putMenu("submenu.2.2.21.name", "Reminding Letter Schedule", "mnuREMLTRSCH");
		putPanel("submenu.2.2.21.dest", new com.hkah.client.tx.admin.syscodetable.RemindingLetterSchedule());
		putMenu("submenu.2.2.22.name", "Religious", "mnuReligious");
		putPanel("submenu.2.2.22.dest", new com.hkah.client.tx.admin.syscodetable.Religious());

		putMenu("submenu.2.3.name", "<u>C</u>ode Table", "mnuCodeTable");
		putMenu("submenu.2.3.dest", "#submenu.2.3");
		putMenu("submenu.2.3.mnemonic", "C");
		putMenu("submenu.2.3.no", "24");
		putMenu("submenu.2.3.1.name", "<u>A</u>cc. Receivable", "mnuAcc");
		putPanel("submenu.2.3.1.dest", new com.hkah.client.tx.admin.codetable.AccountReceivable());
		putMenu("submenu.2.3.1.mnemonic", "A");
		putMenu("submenu.2.3.2.name", "Pay<u>m</u>ent Code", "mnuPay");
		putPanel("submenu.2.3.2.dest", new com.hkah.client.tx.admin.codetable.Payment());
		putMenu("submenu.2.3.2.mnemonic", "m");
		putMenu("submenu.2.3.3.name", "<u>D</u>epartment", "mnuDept");
		putPanel("submenu.2.3.3.dest", new com.hkah.client.tx.admin.codetable.Department());
		putMenu("submenu.2.3.3.mnemonic", "D");
		putMenu("submenu.2.3.4.name", "<u>W</u>ard", "mnuWard");
		putPanel("submenu.2.3.4.dest", new com.hkah.client.tx.admin.codetable.Ward());
		putMenu("submenu.2.3.4.mnemonic", "W");
		putMenu("submenu.2.3.5.name", "<u>G</u>L Code", "mnuGLCode");
		putPanel("submenu.2.3.5.dest", new com.hkah.client.tx.admin.codetable.GLCode());
		putMenu("submenu.2.3.5.mnemonic", "G");
		putMenu("submenu.2.3.6.name", "<u>I</u>tem", "mnuItem");
		putPanel("submenu.2.3.6.dest", new com.hkah.client.tx.admin.codetable.Item());
		putMenu("submenu.2.3.6.mnemonic", "I");
		putMenu("submenu.2.3.7.name", "Item <u>C</u>harge", "mnuItemChg");
		putPanel("submenu.2.3.7.dest", new com.hkah.client.tx.admin.codetable.ItemCharge());
		putMenu("submenu.2.3.7.mnemonic", "C");
		putMenu("submenu.2.3.8.name", "C<u>r</u>edit Item Charge", "mnuCreditItemChg");
		putPanel("submenu.2.3.8.dest", new com.hkah.client.tx.admin.codetable.CreditItemCharge());
		putMenu("submenu.2.3.8.mnemonic", "R");
		putMenu("submenu.2.3.9.name", "Item B<u>u</u>dgeting", "mnuIBudgeting");
		putPanel("submenu.2.3.9.dest", new com.hkah.client.tx.admin.codetable.ItemBudgeting());
		putMenu("submenu.2.3.9.mnemonic", "u");
		putMenu("submenu.2.3.10.name", "<u>P</u>ackage", "mnuPack");
		putPanel("submenu.2.3.10.dest", new com.hkah.client.tx.admin.codetable.Package());
		putMenu("submenu.2.3.10.mnemonic", "P");
		putMenu("submenu.2.3.11.name", "Credit Pac<u>k</u>age", "mnuCreditPkg");
		putPanel("submenu.2.3.11.dest", new com.hkah.client.tx.admin.codetable.CreditPackage());
		putMenu("submenu.2.3.11.mnemonic", "k");
		putMenu("submenu.2.3.12.name", "Package Budgeting", "mnuPBudge<u>t</u>ing");
		putPanel("submenu.2.3.12.dest", new com.hkah.client.tx.admin.codetable.PackageBudgeting());
		putMenu("submenu.2.3.12.mnemonic", "t");
		putMenu("submenu.2.3.13.name", "R<u>o</u>om", "mnuRoom");
		putPanel("submenu.2.3.13.dest", new com.hkah.client.tx.admin.codetable.Room());
		putMenu("submenu.2.3.13.mnemonic", "o");
		putMenu("submenu.2.3.14.name", "<u>B</u>ed", "mnuBed");
		putPanel("submenu.2.3.14.dest", new com.hkah.client.tx.admin.codetable.Bed());
		putMenu("submenu.2.3.14.mnemonic", "B");
		putMenu("submenu.2.3.15.name", "<u>C</u>ashier", "mnuCash");
		putPanel("submenu.2.3.15.dest", new com.hkah.client.tx.admin.codetable.Cashier());
		putMenu("submenu.2.3.15.mnemonic", "C");
		putMenu("submenu.2.3.16.name", "Cash Reference", "mnuCashRef");
		putPanel("submenu.2.3.16.dest", new com.hkah.client.tx.admin.codetable.CashReference());
		putMenu("submenu.2.3.17.name", "Credit Card Rate", "mnuCardRate");
		putPanel("submenu.2.3.17.dest", new com.hkah.client.tx.admin.codetable.CreditCardRate());
		putMenu("submenu.2.3.18.name", "Media T<u>y</u>pe", "mnuMedia");
		putPanel("submenu.2.3.18.dest", new com.hkah.client.tx.admin.codetable.MediaType());
		putMenu("submenu.2.3.18.mnemonic", "y");
		putMenu("submenu.2.3.19.name", "Medical Chart <u>L</u>ocation", "mnuLocate");
		putPanel("submenu.2.3.19.dest", new com.hkah.client.tx.admin.codetable.MedicalChartLocation());
		putMenu("submenu.2.3.19.mnemonic", "L");
		putMenu("submenu.2.3.20.name", "Patient Categor<u>y</u>", "mnuPatCat");
		putPanel("submenu.2.3.20.dest", new com.hkah.client.tx.admin.codetable.PatientCategory());
		putMenu("submenu.2.3.20.mnemonic", "y");
		putMenu("submenu.2.3.21.name", "Al<u>e</u>rt", "mnuAlert");
		putPanel("submenu.2.3.21.dest", new com.hkah.client.tx.admin.codetable.Alert());
		putMenu("submenu.2.3.21.mnemonic", "e");
		putMenu("submenu.2.3.22.name", "Call Chart Purpose", "m_mntcallchartpurpose");
		putPanel("submenu.2.3.22.dest", new com.hkah.client.tx.admin.codetable.CallChartPurpose());
		putMenu("submenu.2.3.23.name", "Education Level", "mnuEduLvl");
		putPanel("submenu.2.3.23.dest", new com.hkah.client.tx.admin.codetable.EducationLevel());
		putMenu("submenu.2.3.24.name", "Doctor Extra", "mnuDocExtra");
		putPanel("submenu.2.3.24.dest", new com.hkah.client.tx.admin.codetable.DoctorExtra());
//		putMenu("submenu.2.3.24.name", "Public Holiday", "");
//		putPanel("submenu.2.3.24.dest", new com.hkah.client.tx.admin.codetable.PublicHoliday());
//		putMenu("submenu.2.3.24.name", "Booking Source", "");
//		putPanel("submenu.2.3.24.dest", new com.hkah.client.tx.admin.codetable.EducationLevel());
//		putMenu("submenu.2.3.25.name", "Admission Type", "");
//		putPanel("submenu.2.3.25.dest", new com.hkah.client.tx.admin.codetable.EducationLevel());
//		putMenu("submenu.2.3.26.name", "SMS Content", "");
//		putPanel("submenu.2.3.26.dest", new com.hkah.client.tx.admin.codetable.EducationLevel());
//		putMenu("submenu.2.3.27.name", "AR Card Link", "");
//		putPanel("submenu.2.3.27.dest", new com.hkah.client.tx.admin.codetable.EducationLevel());
//		putMenu("submenu.2.3.28.name", "Supplementary Category", "");
//		putPanel("submenu.2.3.28.dest", new com.hkah.client.tx.admin.codetable.EducationLevel());
//		putMenu("submenu.2.3.29.name", "Supplementary Code", "");
//		putPanel("submenu.2.3.29.dest", new com.hkah.client.tx.admin.codetable.EducationLevel());

		putMenu("submenu.2.4.name", "<u>T</u>ools");
		putMenu("submenu.2.4.mnemonic", "T");
//		putMenu("submenu.2.4.dest", "#submenu.2.4");
//		putMenu("submenu.2.4.no", "3");
//		putMenu("submenu.2.4.1.name", "<u>C</u>ommand Prompt", "");
//		putPanel("submenu.2.4.1.dest", new com.hkah.client.tx.admin.codetable.AccountReceivable());
//		putMenu("submenu.2.4.1.mnemonic", "C");
//		putMenu("submenu.2.4.2.name", "<u>S</u>QL Plus", "");
//		putPanel("submenu.2.4.2.dest", new com.hkah.client.tx.admin.codetable.AccountReceivable());
//		putMenu("submenu.2.4.2.mnemonic", "S");
//		putMenu("submenu.2.4.3.name", "<u>E</u>xplorer", "");
//		putPanel("submenu.2.4.3.dest", new com.hkah.client.tx.admin.codetable.AccountReceivable());
//		putMenu("submenu.2.4.3.mnemonic", "E");

		putMenu("submenu.2.5.name", "<u>B</u>udgeting", "mnuBudgeting");
		putMenu("submenu.2.5.mnemonic", "B");
		putMenu("submenu.2.5.dest", "#submenu.2.5");
		putMenu("submenu.2.5.no", "2");
		putMenu("submenu.2.5.1.name", "Move <u>f</u>ees to budgeting", "mnuMoveFeesToBudget");
		putPanel("submenu.2.5.1.dest", new com.hkah.client.tx.admin.budgeting.FeesBudget());
		putMenu("submenu.2.5.1.mnemonic", "f");
		putMenu("submenu.2.5.2.name", "Move bu<u>d</u>geting to fees", "mnuMoveBudgetToFees");
		putPanel("submenu.2.5.2.dest", new com.hkah.client.tx.admin.budgeting.BudgetFees());
		putMenu("submenu.2.5.2.mnemonic", "d");

		putMenu("submenu.2.6.name", "<u>D</u>ayend User", "mntDayend");
		putPanel("submenu.2.6.dest", new com.hkah.client.tx.admin.DayendUser());
		putMenu("submenu.2.6.mnemonic", "D");
		putMenu("submenu.2.7.name", "<u>R</u>elease Lock", "mnuRlock");
		putPanel("submenu.2.7.dest", new com.hkah.client.tx.admin.ReleaseLock());
		putMenu("submenu.2.7.mnemonic", "R");
		putMenu("submenu.2.8.name", "System <u>P</u>arameter", "mnuSysParam");
		putPanel("submenu.2.8.dest", new com.hkah.client.tx.admin.SystemParameter());
		putMenu("submenu.2.8.mnemonic", "P");
		putMenu("submenu.2.9.name", "Pr<u>i</u>nter", "mnuPrinter");
		putPanel("submenu.2.9.dest", new com.hkah.client.tx.admin.Printer());
		putMenu("submenu.2.9.mnemonic", "i");

		putMenu("menu.3.name", "<u>S</u>chedule", "mnuSchedule");
		putMenu("menu.3.mnemonic", "S");
		putMenu("menu.3.dest", "#submenu.3");
		putMenu("submenu.3.no", "7");
		putMenu("submenu.3.1.name", "<u>D</u>octor Appointment", "mnuAppoint");
		putPanel("submenu.3.1.dest", new com.hkah.client.tx.schedule.DoctorAppointment());
		putMenu("submenu.3.1.mnemonic", "D");
		putMenu("submenu.3.2.name", "<u>A</u>ppointment Browse", "mnuAppSearch");
		putPanel("submenu.3.2.dest", new com.hkah.client.tx.schedule.AppointmentBrowse());
		putMenu("submenu.3.2.mnemonic", "A");
		putMenu("submenu.3.3.name", "CP <u>L</u>ab Appointment Browse", "mnuCPLabAppoint");
		putPanel("submenu.3.3.dest", new com.hkah.client.tx.schedule.DeptAppointmentBrowse("CPLAB"));
		putMenu("submenu.3.3.mnemonic", "L");
		putMenu("submenu.3.4.name", "<u>W</u>ell Baby Appointment", "mnuWBabyAppoint");
		putPanel("submenu.3.4.dest", new com.hkah.client.tx.schedule.WellBabyAppointmentBrowse());
		putMenu("submenu.3.4.mnemonic", "W");
		putMenu("submenu.3.5.name", "D<u>e</u>ntal Appointment", "mnuDentalAppoint");
		putPanel("submenu.3.5.dest", new com.hkah.client.tx.schedule.DentalAppointmentBrowse());
		putMenu("submenu.3.5.mnemonic", "e");
		putMenu("submenu.3.6.name", "Rehab A<u>p</u>pointment", "mnuRehabAppoint");
		putPanel("submenu.3.6.dest", new com.hkah.client.tx.schedule.RehabAppointmentBrowse());
		putMenu("submenu.3.6.mnemonic", "P");
		putMenu("submenu.3.7.name", "Appointment Browse(R<u>M</u>)", "mnuAppSearch");
		putPanel("submenu.3.7.dest", new com.hkah.client.tx.schedule.AppointmentBrowseByRoom());
		putMenu("submenu.3.7.mnemonic", "M");

		putMenu("menu.4.name", "<u>R</u>egistration", "mnuReg");
		putMenu("menu.4.dest", "#submenu.4");
		putMenu("menu.4.mnemonic", "R");
		putMenu("submenu.4.no", "14");
		putMenu("submenu.4.1.name", "Patient <u>R</u>egistration", "mnuPatReg");
		putPanel("submenu.4.1.dest", new com.hkah.client.tx.registration.Patient());
		putMenu("submenu.4.1.mnemonic", "R");
		putMenu("submenu.4.2.name", "<u>I</u>npatient", "mnuInpat");
		putPanel("submenu.4.2.dest", new com.hkah.client.tx.registration.PatientIn());
		putMenu("submenu.4.2.mnemonic", "I");
		putMenu("submenu.4.3.name", "<u>D</u>ay Case", "mnuDayCase");
		putPanel("submenu.4.3.dest", new com.hkah.client.tx.registration.PatientDayCase());
		putMenu("submenu.4.3.mnemonic", "D");
		putMenu("submenu.4.4.name", "Urgent <u>C</u>are", "mnuUrgentCare");
		putPanel("submenu.4.4.dest", new com.hkah.client.tx.registration.PatientUrgentCare());
		putMenu("submenu.4.4.mnemonic", "C");
		putMenu("submenu.4.5.name", "<u>P</u>riority (Non-UC)", "mnuPriority");
		putPanel("submenu.4.5.dest", new com.hkah.client.tx.registration.PatientPriority());
		putMenu("submenu.4.5.mnemonic", "P");
		putMenu("submenu.4.6.name", "<u>W</u>alk-In", "mnuWalkIn");
		putPanel("submenu.4.6.dest", new com.hkah.client.tx.registration.PatientWalkIn());
		putMenu("submenu.4.6.mnemonic", "W");
		putMenu("submenu.4.7.name", "Registration <u>S</u>earch", "mnuRegSearch");
		putPanel("submenu.4.7.dest", new com.hkah.client.tx.registration.RegistrationSearch());
		putMenu("submenu.4.7.mnemonic", "S");
		putMenu("submenu.4.8.name", "<u>M</u>other-Baby Browse", "mnuMBLink");
		putPanel("submenu.4.8.dest", new com.hkah.client.tx.registration.MomBabySearch());
		putMenu("submenu.4.8.mnemonic", "M");
		putMenu("submenu.4.9.name", "<u>B</u>ed Reservation", "mnuBedReserve");
		putPanel("submenu.4.9.dest", new com.hkah.client.tx.registration.BedReservation());
		putMenu("submenu.4.9.mnemonic", "B");
		putMenu("submenu.4.10.name", "<u>U</u>pdate Inpat. RegID", "mnuUpdateLink");
		putPanel("submenu.4.10.dest", new com.hkah.client.tx.registration.UpdInpatRegID());
		putMenu("submenu.4.10.mnemonic", "U");
		putMenu("submenu.4.11.name", "Patient Status <u>V</u>iew", "mnuPatStsView");
		putPanel("submenu.4.11.dest", new com.hkah.client.tx.registration.PatientStatView());
		putMenu("submenu.4.11.mnemonic", "V");
		putMenu("submenu.4.12.name", "Home Leave", "mnuRegHomeLeave");
		putPanel("submenu.4.12.dest", new com.hkah.client.tx.registration.HomeLeave());
		putMenu("submenu.4.13.name", "OB Booking", "mnuBooking");
		putPanel("submenu.4.13.dest", new com.hkah.client.tx.registration.OBBook());
		putMenu("submenu.4.14.name", "Doctor Profile", "mnuDrProfile");
		putPanel("submenu.4.14.dest", new com.hkah.client.tx.registration.DoctorProfile());

		putMenu("menu.5.name", "<u>T</u>ransaction", "mnuTran");
		putMenu("menu.5.dest", "#submenu.5");
		putMenu("menu.5.mnemonic", "T");
		putMenu("submenu.5.no", "8");
		putMenu("submenu.5.1.name", "<u>S</u>lip Search", "mnuSlip");
		putPanel("submenu.5.1.dest", new com.hkah.client.tx.transaction.SlipSearch());
		putMenu("submenu.5.1.mnemonic", "S");
		putMenu("submenu.5.2.name", "Sl<u>i</u>p Search By AR", "mnuSlipByAR");
		putPanel("submenu.5.2.dest", new com.hkah.client.tx.transaction.SlipSearchByAR());
		putMenu("submenu.5.3.name", "<u>Q</u>uick Charge Entry", "mnuQuick");
		putPanel("submenu.5.3.dest", new com.hkah.client.tx.transaction.QuickCharge());
		putMenu("submenu.5.3.mnemonic", "Q");
		putMenu("submenu.5.4.name", "<u>T</u>ransaction Detail", "mnuTransDetail");
		putPanel("submenu.5.4.dest", new com.hkah.client.tx.transaction.TransactionSearch());
		putMenu("submenu.5.4.mnemonic", "T");
		putMenu("submenu.5.5.name", "<u>D</u>eposit", "mnuDeposit");
		putPanel("submenu.5.5.dest", new com.hkah.client.tx.transaction.Deposit());
		putMenu("submenu.5.5.mnemonic", "D");
		putMenu("submenu.5.6.name", "<u>L</u>og", "mnuLog");
		putPanel("submenu.5.6.dest", new com.hkah.client.tx.transaction.TelLog());
		putMenu("submenu.5.6.mnemonic", "L");
		putMenu("submenu.5.7.name", "Misc & O/S", "mnuDischargeCheck");
		putPanel("submenu.5.7.dest", new com.hkah.client.tx.report.DichargeCheck());
		putMenu("submenu.5.8.name", "Mobile Bills", "mnuMobBills");
		putPanel("submenu.5.8.dest", new com.hkah.client.tx.transaction.MobileBills());
		

		putMenu("menu.6.name", "<u>A</u>cc. Receivable", "mnuAccount");
		putMenu("menu.6.dest", "#submenu.6");
		putMenu("menu.6.mnemonic", "A");
		putMenu("submenu.6.no", "1");
		putMenu("submenu.6.1.name", NO_SUB_MENU_NAME);
		putPanel("submenu.6.1.dest", new com.hkah.client.tx.accreceivable.AccReceivable());

		putMenu("menu.7.name", "<u>C</u>ashier", "mnuCashier");
		putMenu("menu.7.dest", "#submenu.7");
		putMenu("menu.7.mnemonic", "C");
		putMenu("submenu.7.no", "7");
		putMenu("submenu.7.1.name", "<u>S</u>ign On", "mnuSignOn");
		putMenu("submenu.7.1.mnemonic", "S");
		putPanel("submenu.7.1.dest", new com.hkah.client.tx.cashier.CashierSignOn());
		putMenu("submenu.7.2.name", "Sign <u>O</u>ff", "mnuSignOff");
		putMenu("submenu.7.2.mnemonic", "O");
		putPanel("submenu.7.2.dest", new com.hkah.client.tx.cashier.CashierSignOff());
		putMenu("submenu.7.3.name", "Cashier <u>C</u>lose", "mnuCashClose");
		putMenu("submenu.7.3.mnemonic", "C");
		putPanel("submenu.7.3.dest", new com.hkah.client.tx.cashier.CashierSignClose());
		putMenu("submenu.7.4.name", "<u>P</u>ayment and Receive", "mnuCashPayRec");
		putPanel("submenu.7.4.dest", new com.hkah.client.tx.cashier.PaymentAndReceipt());
		putMenu("submenu.7.4.mnemonic", "P");
		putMenu("submenu.7.5.name", "Cashier <u>H</u>istory", "mnuCashHistory");
		putPanel("submenu.7.5.dest", new com.hkah.client.tx.cashier.CashierHistory());
		putMenu("submenu.7.5.mnemonic", "H");
		putMenu("submenu.7.6.name", "Cashier S<u>e</u>ssion History", "mnuCashHistory");
		putPanel("submenu.7.6.dest", new com.hkah.client.tx.cashier.CashierSessionHistory());
		putMenu("submenu.7.6.mnemonic", "E");
		putMenu("submenu.7.7.name", "<u>B</u>alance Display", "mnuCshBalance");
		putMenu("submenu.7.7.mnemonic", "B");
		putPanel("submenu.7.7.dest", new com.hkah.client.tx.cashier.CashierBalance());

		putMenu("menu.8.name", "Re<u>p</u>ort", "mnuReport");
		putMenu("menu.8.mnemonic", "p");
		putMenu("menu.8.dest", "#submenu.8");
		putMenu("submenu.8.no", "9");
		putMenu("submenu.8.1.name", "<u>M</u>anagement Report", "mnuManReport");
		putPanel("submenu.8.1.dest", new com.hkah.client.tx.report.ManagementReport());
		putMenu("submenu.8.1.mnemonic", "M");
		putMenu("submenu.8.2.name", "<u>A</u>R Related Reports", "mnuARReport");
		putPanel("submenu.8.2.dest", new com.hkah.client.tx.report.ARReports());
		putMenu("submenu.8.2.mnemonic", "A");
		putMenu("submenu.8.3.name", "<u>D</u>ay End Report", "mnuGenReport");
		putPanel("submenu.8.3.dest", new com.hkah.client.tx.report.DayEndReport());
		putMenu("submenu.8.4.name", "<u>R</u>eprint Day End Report", "mnuReprint");
		putPanel("submenu.8.4.dest", new com.hkah.client.tx.report.ReprintDayendReports());
		putMenu("submenu.8.4.mnemonic", "R");
		putMenu("submenu.8.5.name", "<u>R</u>eprint Day End Report (Selected Reports)", "mnuReprintSelected");
		putPanel("submenu.8.5.dest", new com.hkah.client.tx.report.ReprintDayendSelectedReports());
		putMenu("submenu.8.5.mnemonic", "S");
//		putMenu("submenu.8.6.name", "<u>W</u>eekly Bill", "mnuRpWeekBill");
//		putPanel("submenu.8.6.dest", new com.hkah.client.tx.report.ReprintWeeklyBill());
//		putMenu("submenu.8.6.mnemonic", "W");
		putMenu("submenu.8.6.name", "<u>W</u>eekly Bill", "mnuRptCvLtr");
		putPanel("submenu.8.6.dest", new com.hkah.client.tx.report.ReprintCoverLetter());
		putMenu("submenu.8.6.mnemonic", "W");
		putMenu("submenu.8.7.name", "<u>C</u>SR Reorder Report", "mnuCSR");
		putPanel("submenu.8.7.dest", new com.hkah.client.tx.report.CSRReorderReport());
		putMenu("submenu.8.7.mnemonic", "C");
		putMenu("submenu.8.8.name", "Custom");
		putMenu("submenu.8.8.dest", "#submenu.8.8");
		putMenu("submenu.8.8.no", "3");
		putMenu("submenu.8.8.1.name", "HATS Query", "mnuHATSQuery");
		putPanel("submenu.8.8.1.dest", new com.hkah.client.tx.report.HatsQuery());
		putMenu("submenu.8.8.2.name", "Lab Summary Report", "mnuLabSummaryReport");
		putPanel("submenu.8.8.2.dest", new com.hkah.client.tx.report.LabSummaryReport());
		putMenu("submenu.8.8.3.name", "NEW HATS Query", "mnuNewHATSQuery");
		putPanel("submenu.8.8.3.dest", new com.hkah.client.tx.report.NewHatsQuery());
		putMenu("submenu.8.9.name", "AR EDI", "mnuAREDI");
		putPanel("submenu.8.9.dest", new com.hkah.client.tx.report.AREDI());

		putMenu("menu.9.name", "M<u>e</u>d. Record", "mnuMedicalRec");
		putMenu("menu.9.dest", "#submenu.9");
		putMenu("menu.9.mnemonic", "E");
		putMenu("submenu.9.no", "4");
		putMenu("submenu.9.1.name", "<u>D</u>ischarge Patients", "mnuDisPat");
		putPanel("submenu.9.1.dest", new com.hkah.client.tx.medrecord.DischagePatient());
		putMenu("submenu.9.1.mnemonic", "D");
		putMenu("submenu.9.2.name", "<u>D</u>aycase Patient", "mnuDisdaycasePat");
		putPanel("submenu.9.2.dest", new com.hkah.client.tx.medrecord.DischageDCPatient());
		putMenu("submenu.9.2.mnemonic", "D");
		putMenu("submenu.9.3.name", "Medical <u>C</u>hart", "mnuMedChart");
		putPanel("submenu.9.3.dest", new com.hkah.client.tx.medrecord.MedicalChart());
		putMenu("submenu.9.3.mnemonic", "C");
		putMenu("submenu.9.4.name", "Medical Record <u>M</u>erge", "mnuMedRecMerge");
		putPanel("submenu.9.4.dest", new com.hkah.client.tx.medrecord.MedicalChartMerge());
		putMenu("submenu.9.4.mnemonic", "M");

		putMenu("menu.10.name", "<u>O</u>T", "mnuOT");
		putMenu("menu.10.mnemonic", "O");
		putMenu("menu.10.dest", "#submenu.10");
		putMenu("submenu.10.no", "6");
		putMenu("submenu.10.1.name", "OT <u>M</u>isc Code Table", "mnuOTCodeTable");
		putPanel("submenu.10.1.dest", new com.hkah.client.tx.ot.OTMiscCodeTable());
		putMenu("submenu.10.1.mnemonic", "M");
		putMenu("submenu.10.2.name", "OT <u>P</u>rocedure Code", "mnuOTProc");
		putPanel("submenu.10.2.dest", new com.hkah.client.tx.ot.OTProcedureCode());
		putMenu("submenu.10.2.mnemonic", "P");
		putMenu("submenu.10.3.name", "OT <u>A</u>ppointment Browse", "mnuOTAppBrowse");
		putPanel("submenu.10.3.dest", new com.hkah.client.tx.ot.OTAppointmentBrowse());
		putMenu("submenu.10.3.mnemonic", "A");
		putMenu("submenu.10.4.name", "OT <u>L</u>og Browse", "mnuOTLogBrowse");
		putPanel("submenu.10.4.dest", new com.hkah.client.tx.ot.OTLogBrowser());
		putMenu("submenu.10.4.mnemonic", "L");
		putMenu("submenu.10.5.name", "OT Log <u>B</u>ook", "mnuOTLogBook");
		putPanel("submenu.10.5.dest", new com.hkah.client.tx.ot.OTLogBook());
		putMenu("submenu.10.5.mnemonic", "B");
		putMenu("submenu.10.6.name", "OT AuditTrail Report", "mnu_otaudit");
		putPanel("submenu.10.6.dest", new com.hkah.client.tx.ot.OTAuditTrailReport());

		putMenu("menu.11.name", "SCM", "mnuSCM");
		putMenu("menu.11.dest", "#submenu.11");
		putMenu("submenu.11.no", "2");
		putMenu("submenu.11.1.name", "Commission Contract", "mnu_CC");
		putPanel("submenu.11.1.dest", new com.hkah.client.tx.scm.CommissionContract());
		putMenu("submenu.11.2.name", "Referral Contract Formula", "mnuRefContract");
		putPanel("submenu.11.2.dest", new com.hkah.client.tx.scm.ReferralContractFormula());

		putMenu("menu.12.name", "E-<u>B</u>irth", "mnuEBirth");
		putMenu("menu.12.dest", "#submenu.12");
		putMenu("menu.12.mnemonic", "B");
		putMenu("submenu.12.no", "4");
		putMenu("submenu.12.1.name", "Birth <u>L</u>og", "mnuBirthLog");
		putPanel("submenu.12.1.dest", new com.hkah.client.tx.birth.BirthLog());
		putMenu("submenu.12.1.mnemonic", "L");
		putMenu("submenu.12.2.name", "Send <u>Q</u>ueue", "mnuBirthSendQueue");
		putPanel("submenu.12.2.dest", new com.hkah.client.tx.birth.SendQueue());
		putMenu("submenu.12.2.mnemonic", "Q");
		putMenu("submenu.12.3.name", "<u>D</u>H Birth Log", "mnuDHBirthLog");
		putPanel("submenu.12.3.dest", new com.hkah.client.tx.birth.DHBirthLog());
		putMenu("submenu.12.3.mnemonic", "D");
		putMenu("submenu.12.4.name", "D<u>H</u> Send Queue", "mnuDHSendQueue");
		putPanel("submenu.12.4.dest", new com.hkah.client.tx.birth.DHSendQueue());
		putMenu("submenu.12.4.mnemonic", "H");

		putMenu("menu.13.name", "Call / Trf Cht", "mnuPrtCallChart");
		putMenu("menu.13.dest", "#submenu.13");
		putMenu("menu.13.mnemonic", "C");
		putMenu("submenu.13.no", "1");
		putMenu("submenu.13.1.name", NO_SUB_MENU_NAME);
		putPanel("submenu.13.1.dest", new com.hkah.client.tx.print.PrtCallChart());

		putMenu("menu.14.name", "Patient Car<u>d</u>", "mnuPrtCallChart");
		putMenu("menu.14.dest", "#submenu.14");
		putMenu("menu.14.mnemonic", "D");
		putMenu("submenu.14.no", "1");
		putMenu("submenu.14.1.name", NO_SUB_MENU_NAME);
		putPanel("submenu.14.1.dest", new com.hkah.client.tx.print.PrintPatientCard());

		putMenu("menu.15.name", "Insurance", "mnuInsCd");
		putMenu("menu.15.dest", "#submenu.15");
		putMenu("submenu.15.no", "3");
		putMenu("submenu.15.1.name", "<u>A</u>cc. Receivable", "mnuAccDtl");
		putPanel("submenu.15.1.dest", new com.hkah.client.tx.insuranceCard.AccountReceivableDetail());
		putMenu("submenu.15.2.name", "Insurance Program", "mnuInsurProg");
		putPanel("submenu.15.2.dest", new com.hkah.client.tx.insuranceCard.ARCardLink());
		putMenu("submenu.15.3.name", "Insurance Panel Dr.", "mnuInsurPanelDr");
		putPanel("submenu.15.3.dest", new com.hkah.client.tx.insuranceCard.PanelDoctor());

		putMenu("menu.16.name", "Change Ptr", "mnuChgPtr");
		putMenu("menu.16.dest", "#submenu.16");
		putMenu("submenu.16.no", "1");
		putMenu("submenu.16.1.name", NO_SUB_MENU_NAME);
		putPanel("submenu.16.1.dest", new com.hkah.client.tx.print.ChangePrinterSet());

		putMenu("menu.17.name", "DI", "mnuDIMain");
		putMenu("menu.17.dest", "#submenu.17");
		putMenu("submenu.17.no", "3");
		putMenu("submenu.17.1.name", "Registration (Hospital)", "mnuDIReg");
		putPanel("submenu.17.1.dest", new com.hkah.client.tx.di.DIECGExamReg());
		putMenu("submenu.17.2.name", "Exam Report", "mnuDIReport");
		putPanel("submenu.17.2.dest", new com.hkah.client.tx.di.DIECGExamReport());
		putMenu("submenu.17.3.name", "Pending Exam", "mnuDIPending");
		putPanel("submenu.17.3.dest", new com.hkah.client.tx.di.DIECGPendExam());

		putMenu("menu.18.name", "E.C.G.", "mnuECG");
		putMenu("menu.18.dest", "#submenu.18");
		putMenu("submenu.18.no", "2");
		putMenu("submenu.18.1.name", "E.C.G. Queue");
		putPanel("submenu.18.1.dest", new com.hkah.client.tx.di.DIECGQueue());
		putMenu("submenu.18.2.name", "Report Queue");
		putPanel("submenu.18.2.dest", new com.hkah.client.tx.di.DIECGQueueReport());
	}

	private static void putMenu(String key, String value) {
		putMenu(key, value, null);
	}

	private static void putMenu(String key, String value, String variable) {
		resource.put(key, value);
		if (variable != null) {
			resourceVariable.put(key, variable);
		}
	}

	private static void putPanel(String key, BasePanel panel) {
		resourceClass.put(key, panel);
	}

	public static String get(String key) {
		String result = null;
		try {
			result = resource.get(key);
		} catch (Exception ex) {
		}
		return result;
	}

	public static BasePanel getPanel(String key) {
		return resourceClass.get(key);
	}

	public static String getMenuVariable(String key) {
		return resourceVariable.get(key);
	}
}