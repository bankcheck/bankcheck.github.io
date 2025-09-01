package com.hkah.shared.constants;

public interface ConstantsMessage {
	public final static String ERROR_DAYEND = "Generation of Dayend Report has been failed during the night! Some functions will be disabled. Please contant system administrator!";
	public final static String ERROR_DISABLE = "The function is disabled due to the failure of the dayend process!";

	public final static String MSG_INVALID_PATIENTNO = "Patient number not exist.";
	public final static String MSG_PATIENTNO_EXIST = "Patient number already exist.";
	public final static String MSG_PATIENT_MERGED = "Patient is already merged.";

	public final static String MSG_SAVE_PATIENT = "Save Patient information before move to Registration.";
	public final static String MSG_SAVE_REG = "Save Registration information before move to Patient.";

	// System Message
	public final static String MSG_UNSAVEDATA_WARNING = "Unsaved data present ! Close anyway ?";
	public final static String MSG_CANCEL_WARNING = "Are you sure to cancel all unsaved operations ?";
	public final static String MSG_NO_RECORD_FOUND = "No record found.";
	public final static String MSG_UNABLE_TOUNLOCK = "Unable to release lock!";
	public final static String MSG_CONTINUE = "Do you want to continue?";

	// Transaction Message
	public final static String MSG_INP_NO_ACTIVE_SLIP = "The last active slip for IP can't be closed when the IP hasn't been discharged! Please create a new slip for this IP!";
	public final static String MSG_TRANSACTION_DATE = "Invalid date.";
	public final static String MSG_TRANSACTION_DATE_FORMAT = "Please enter the transaction date with the format of dd/mm/yyyy.";
	public final static String MSG_FUTURE_TRANSACTION_DATE = "The Transaction Date is greater than today. Do you want to proceed?";
	public final static String MSG_ITEM_CODE = "Invalid item code.";
	public final static String MSG_ITEM_PKG_CODE = "Invalid item/package code.";
	public final static String MSG_PATIENT_NO = "Invalid patient number.";
	public final static String MSG_SLIP_NO = "Invalid slip number.";
	public final static String MSG_SLIP_AMOUNT = "Please enter a numeric amount.";
	public final static String MSG_ALL_FIELD = "Please enter all the fields.";
	public final static String MSG_MOVE_ITEM_TO_PKGTX = "Do you want to move the charge to pkgtx?";
	public final static String MSG_MOVE_PACKAGE_TO_PKGTX = "Do you want to move the whole package to pkgtx?";
	public final static String MSG_MOVE_SUCCEED = "Move Succeed.";
	public final static String MSG_MOVE_FAIL = "Move Fail.";

	public final static String MSG_NUMERIC_DISCOUNT = "Please enter a positive numeric discount.";
	public final static String MSG_INVALID_ACMCDE = "Invalid acm. code.";
	public final static String MSG_INVALID_OAMT = "Invalid Outstanding Amt.";
	public final static String MSG_POSITIVE_AMOUNT = "Please enter a positive integer amount.";
	public final static String MSG_NEGATIVE_AMOUNT = "Please enter a negative integer amount.";
	public final static String MSG_NUMERIC_AMOUNT = "Please enter a numeric amount.";
	public final static String MSG_MAXADJUST_AMOUNT = "Adjusted amount should not be larger than the original amount.";
	public final static String MSG_CREDIT_PERCENTAGE = "Please enter a positive credit percentage.";
	public final static String MSG_DOCTOR_CODE = "Invalid doctor code.";
	public final static String MSG_ITMPKG_CODE = "Invalid item/pkg code.";
	public final static String MSG_PKG_CODE = "Invalid package code.";
	public final static String MSG_ITMCHARGE_RATE = "Invalid item charge rate.";
	public final static String MSG_MOVEITM_TOSLIPTX = "Do you want to move the item to charge the patient?";
	public final static String MSG_MOVEPKG_TOSLIPTX = "Do you want to move the whole package to charge to the patient?";
	public final static String MSG_CANCEL_ITEM = "Do you want to cancel the transaction with the item code?";
	public final static String MSG_CANCEL_ITEM_SUCCESS = "Cancel item successfully.";
	public final static String MSG_CANCEL_ITEM_FAIL = "Cancel item failed.";
	public final static String MSG_CANCEL_PACKAGE = "Do you want to cancel all the Slips with the package code?";
	public final static String MSG_CANCEL_PACKAGE_SUCCESS = "Cancel package successfully.";
	public final static String MSG_CANCEL_PACKAGE_FAIL = "Cancel package failed.";
	public final static String MSG_CLOSE_SLIP = "Do you want to close the slip?";
	public final static String MSG_CLOSE_SLIP_SUCCESS = "Slip close succeeded.";
	public final static String MSG_CLOSE_SLIP_FAIL = "Slip close failed.";
	public final static String MSG_TXN_NOREFUNDITM = "Refund item can not be added.";
	public final static String MSG_NUMERIC_DISCOUNTOFF = "Discount should be numeric and < 100.";
	public final static String MSG_PAYAR_CODE = "Invalid paycode/arccode.";
	public final static String MSG_GLC_CODE = "Invalid glccode.";
	public final static String MSG_CASHIER_CLOSED = "Cashier already closed the session, payment can not be cancelled.";
	public final static String MSG_CHG_ARCOMPANY = "The amount for the charged item will not reflect the changes of AR Company. Please cancel the existing charges and re-add again!";
	public final static String MSG_INTEGER_AMOUNT = "Please enter an integer amount.";
	public final static String MSG_REV_DOC_FEE_SUCCESS = "Reverse doctor fee succeeded.";
	public final static String MSG_REV_DOC_FEE_FAIL = "Reverser doctor fee failed.";

	// Transaction Modification
	public final static String MSG_SAMESLIP_NO = "From and to slip no can not be the same.";
	public final static String MSG_SAMEPKG_NO = "From and to package can not be the same.";
	public final static String MSG_CREDIT_ITEM = "You should select a credit item.";
	public final static String MSG_SLIPTX_UPDATE_SUCCESS = "Sliptx update successfully.";
	public final static String MSG_TRANSFER_SAME_PATIENT = "DI registered exam can only transfer to the same patient.";
	public final static String MSG_MOVE_REGISTERED_EXAM_SEQ_REQUIRED = "Transaction sequence should be numeric and item should be not registered.";

	// Appointment Message
	public final static String MSG_24_HOUR = "Can not confirm appointment 24 hours ago.";
	public final static String MSG_DUP_APP = "Appointment already exists for this patient";
	public final static String MSG_DUP_SLOT = "Appointment is already made. Continue?";
	public final static String MSG_SCH_WRONG = "No backdate booking is allowed.";
	public final static String MSG_BOOKING_MADE = "Appointment successfully made.";
	public final static String MSG_BOOKING_CHANGED = "Appointment successfully changed.";
	public final static String MSG_NO_DATE = "Please enter the time only.";
	public final static String MSG_DATE_REQUIRED = "The start date must be entered.";
	public final static String MSG_ADDSCH_NOTSAME = "The date range must be within the same day.";
	public final static String MSG_BOOKING_NOINFO = "Missing patient name/phone.";
	public final static String MSG_GENERATE_FAIL = "Schedule generation failed.";
	public final static String MSG_GENERATE_SUCCESS = "Schedule successfully generated.";
	public final static String MSG_BLOCK_FAIL = "Schedule block failed.";
	public final static String MSG_BLOCK_SUCCESS = "Schedule block successfully.";
	public final static String MSG_BLOCK_CONFIRM = "Appointment(s) exist, proceed for blocking ?";
	public final static String MSG_UNBLOCK_CONFIRM = "Are you sure to UNBLOCK the selected schedule ?";
	public final static String MSG_UNBLOCK_FAIL = "Schedule unblock failed.";
	public final static String MSG_UNBLOCK_SUCCESS = "Schedule unblock successfully.";
	public final static String MSG_SLOTSEARCH_FAIL = "Slot search function failed.";
	public final static String MSG_ADDSCH_SAMEDATE = "Date range incorrect.";
	public final static String MSG_ADDSCH_PASSDATE = "Creation of schedule with passed date is not allowed.";
	public final static String MSG_ADDSCH_SUCCESS = "Schedule successfully added.";
	public final static String MSG_ADDSCH_FAIL = "Schedule add failed.";
	public final static String MSG_CANCELAPT_CONFIRM = "Are you sure to cancel the selected appointment ?<br /><span style='color: #FF0000'>Reminder: Same day cancellation, please call the specific Doctor if</span><br />1. No more appt<br />2. 1st appt is cancelled";
	public final static String MSG_CANCELAPT_FAIL = "Cancel appointment failed.";
	public final static String MSG_CANCELAPT_INVALID = "Can't cancel the selected record.";
	public final static String MSG_CANCELAPT_SUCCESS = "Appointment record successfully cancelled.";
	public final static String MSG_APPOINTMENT_CANCELLED = "The selected appointment is cancelled.";
	public final static String MSG_APPOINTMENT_CONFIRMED = "The selected appointment is confirmed.";
	public final static String MSG_INVALID_TIME = "The time of the schedule is invalid.";
	public final static String MSG_SCH_BLOCKED = "Schedule already blocked.";
	public final static String MSG_SCH_UNBLOCK = "Schedule is not currently blocked.";
	public final static String MSG_SCH_DUPSCH = "Duplicated schedule.";
	public final static String MSG_APP_EXIST = "Appointment already exists within the date range! Block the Appointment?";
	public final static String MSG_PHONE_NO_EXCEED = "Phone Number is too long.";
	public final static String MSG_SCH_SESSION_EXCEED = "Session exceed doctor schedule.";
	public final static String MSG_APP_BLOCKED = "Selected appointment is blocked for further action.";
	public final static String MSG_APP_CANCELLED = "Selected appointment is cancelled.";
	public final static String MSG_APP_REGISTERED = "Selected appointment has been registered.";
	public final static String MSG_PASTDATENOTALLOWED = "Update on passed date is not allowed";

	// Patient Registration Message
	public final static String MSG_PATIENT_DEATH = "Current patient is dead, Continue?";
	public final static String MSG_INVALID_REGDATE = "Invalid date format.";
	public final static String MSG_EXIST_HKID = "HKID is already existed.";
	public final static String MSG_PATIENT_RECORD = "No patient record is selected.";
	public final static String MSG_UNSAVE_PATIENT = "Please save the patient record first.";
	public final static String MSG_MISSED_SLIPNO = "Slip No. not specified yet.";
	public final static String MSG_CURRENT_INPATIENT = "The patient was already admitted as inpatient.";
	public final static String MSG_WRONG_LOCCODE = "Invalid Location Code.";
	public final static String MSG_WRONG_DOCCODE = "Invalid Doctor Code.";
	public final static String MSG_WRONG_BEDCODE = "Invalid Bed Code.";
	public final static String MSG_BEDCODE_AVAILABLE = "Bed not available or wrong sex.";
	public final static String MSG_CANCEL_REGISTRATION = "Do you want to cancel the current registration and booking?";
	public final static String MSG_CANCEL_REGISTRATION_FAILED = "Can't cancel the selected registration !";
	public final static String MSG_CONFIRM_DISCHARGE = "Update the discharge information ?";
	public final static String MSG_INVALID_DATE = "Invalid Date Value.";
	public final static String MSG_REQUIRE_INPAT = "Only Inpatient user can access this function.";
	public final static String MSG_REQUIRE_OUTPAT = "Only Outpatient user can access this function.";
	public final static String MSG_REQUIRE_DAYCASE = "Only Daycase user can access this function.";
	public final static String MSG_WRONG_SDSCODE = "Invalid Disease Code.";
	public final static String MSG_WRONG_SRSNCODE = "Invalid Reason Code.";
	public final static String MSG_FAILED_INPATTRANSFER = "Transfer to inpatient failed.";
	public final static String MSG_CANCELLED_REGISTRATION = "The selected registration is cancelled.";
	public final static String MSG_COMMIT_FAIL = "Registration Save Failed.";
	public final static String MSG_BED_UNAVAILABLE = "The selected bed is unavailable";
	public final static String MSG_BED_WRONG_SEX = "Room's sex and patient's sex is not match, continue assign the selected bed ?";
	public final static String MSG_BED_UNCLEAN = "The room is unclean, continue assign the selected bed ?";
	public final static String MSG_SPLITSLIP_SUCCESS = "New slip successfully created.";
	public final static String MSG_SPLITSLIP_FAILED = "New slip creation failed.";
	public final static String MSG_DISCHARGE_DATE = "Discharge date should be larger than admission date.";
	public final static String MSG_ADMISSION_DATE = "Please enter the Birthday with the format of dd/mm/yyyy.";
	public final static String MSG_BIRTHDAY_DATE = "Birthday should not be future date.";

	public final static String MSG_ADD_MEDICAL_RECORD_VOLUME = "Add a new volume for the patient?";
	public final static String MSG_ADD_PATIENT_MEDICAL_RECORD = "<html>No medical record exists for the patient,<br> Add a new one?</html>";
	public final static String MSG_PRINT_MEDICAL_RECORD_LABEL = "Print medical record label?";
	public final static String MSG_TODAY_MEDICAL_RECORD_VOLUME = "A new volume has already created for today.";

	// Admission Form
	public final static String MSG_ADM_FRM_PRINT_SUCCESS = "Admission Form Printing is successful.";
	public final static String MSG_ADM_FRM_PRINT_FAIL = "Admission Form Printing is fails.";
	public final static String MSG_ADM_FRM_NO_PATIENT_RECORD = "Patient record does not exist.";

	// New Born
	public final static String MSG_CONFIRM_PATIENT_NEWBORN = "Record the patient as new born baby?";
	public final static String MSG_CONFIRM_PATIENT_NB_BIRTHDAY = "New born baby's birthday is not today. continue?";
	public final static String MSG_CONFIRM_PATIENT_NB_NO_DOB = "Patient without date of birth, continue?";

	// New Slip
	public final static String MSG_PATIENT_FNAME = "Please enter the patient family name.";
	public final static String MSG_PATIENT_LNAME = "Please enter the patient given name.";

	// Cashier Management Message
	public final static String MSG_CSH_ALREADYLOGON = "The current cashier was already logged on at another machine.";
	public final static String MSG_MISSING_PAYERRECIPIENT = "Payer/Recipient Field Missing.";
	public final static String MSG_MISSING_PAYMENTTYPE = "Payment Type Field Missing.";
	public final static String MSG_MISSING_REFERENCE = "Reference Field Missing.";
	public final static String MSG_MISSING_AMOUNT = "Amount Field Missing.";
	public final static String MSG_CASHTX_INVALIDPAYOUT = "Payout amount must specify in negative value.";
	public final static String MSG_CASHTX_INVALIDRECEIVE = "Receive amount must specify in positive value.";
	public final static String MSG_CASHTX_INVALIDPAYTYPE = "Payment type is not valid.";
	public final static String MSG_NOT_CASHIER = "Only cashier can perform this operation.";
	public final static String MSG_CASHIER_CLOSE = "Cashier Close ? ";
	public final static String MSG_DIFFERENT_CASHIER = "Can't void transaction made by another cashier.";
	public final static String MSG_NOT_EPS = "EPS can not be voided.";
	public final static String MSG_CASHTX_VOID = "Are you sure you want to void this transaction ?";
	public final static String MSG_VOID_FAILED = "Can't void the transaction.";
	public final static String MSG_PATIENT_TRANSACTION = "Can't void the patient related transaction.";
	public final static String MSG_CASH_WRONG_ARCODE = "Invalid PayCode.";
	public final static String MSG_CASH_WRONG_ARCODE1 = "Invalid ArCode.";
	public final static String MSG_INVALID_PAYMENTTYPE = "Invalid Payment Type.";
	public final static String MSG_SPECTRA_FAILURE = "Hardware Failure or Card Machine is not connected.";
	public final static String MSG_CANCELLED_CASHTX = "The selected transaction is already cancelled.";
	public final static String MSG_CASHTX_SUCCESS = "Transaction Success.";
	public final static String MSG_CASHTX_FAILED = "Transaction Failed.";
	public final static String MSG_CASHIER_CLOSE_COMPLETE = "Cashier Successfully Closed.";
	public final static String MSG_CARDINFO_CONFIRM = "Is all the credit card information is correct ?";
	public final static String MSG_EPSINFO_CONFIRM = "Is all the EPS information is correct ?";
	public final static String MSG_CARD_FORCE_COMMIT = "<html>Failed to complete the transaction with card machine.<br>Continue to complete the transaction manually ?</html>";
	public final static String MSG_CARD_FORCE_VOID = "<html>Failed to void the card machine transaction.<br>Continue to void transaction seperately ?</html>";
	public final static String MSG_CARD_TRACE_NO = "Please remember to void the card machine with Trace No = ";

	// Search Function Message
	public final static String MSG_INPUT_CRITERIA = "Please enter at least 1 criteria.";
	public final static String MSG_INPUT_CRITERIA_3 = " Please enter at least 3 criteria.";
	public final static String MSG_MORE_CRITERIA = "Please enter more criteria.";

	// Deposit Message
	public final static String MSG_DEPOSIT_TRANSFER = "Do you want to transfer the deposit to slpno?";
	public final static String MSG_DEPOSIT_REFUND = "Do you want to refund the deposit?";
	public final static String MSG_DEPOSIT_WRITEOFF = "Do you want to writeoff the deposit?";
	public final static String MSG_DEPOSIT_TRANSFER_SUCCESS = "Deposit successfully transfered. ";
	public final static String MSG_DEPOSIT_TRANSFER_FAIL = "Deposit transfer failed.";
	public final static String MSG_DEPOSIT_REFUND_SUCCESS = "Deposit successfully refunded.";
	public final static String MSG_DEPOSIT_REFUND_FAIL = "Deposit refund failed.";
	public final static String MSG_DEPOSIT_WRITEOFF_SUCCESS = "Deposit successfully write-offed.";
	public final static String MSG_DEPOSIT_WRITEOFF_FAIL = "Deposit writeoff failed.";
	public final static String MSG_DEPOSIT_ITMCODE_NOTFOUND = "No deposit such item code in the itemchg table.";

	//Bill
	public final static String MSG_BILL_TRANSFER = "Do you want to make the transfer:";
	public final static String MSG_BILL_TRANSFER_FAIL = "App Payment transfer failed.";
	public final static String MSG_BILL_ISCREATEBILL = "There is Bill exist for this Slip, Continue to Create Bill?";
	public final static String MSG_BILL_UNSETTLEDBILL = "There is Bill exist with unsettled payment. Please settle before posting new Bill";
	public final static String MSG_BILL_ISClOSEBILL = "Are you sure to close Bill?";
	public final static String MSG_BILL_CARDTYPEEMPTY = "Please select a card type.";
	// AR
	public final static String MSG_AR_SUCCEED = "Credit Allocation successfully cancelled.";
	public final static String MSG_AR_CANCEL = "Cancel the transaction?";
	public final static String MSG_AR_CODE = "Invalid payer code.";
	public final static String MSG_ALLOWED_AMOUNT = "Amount to allocate must not exceed the allowable amount to allocate of the selected payment record.";
	public final static String MSG_ALLOCATED_AMOUNT = "Amount allocated should not exceed the outstanding amount.";
	public final static String MSG_SAVE_CREDIT_ALLOCATION = "Save changes before move to another payment?";
	public final static String MSG_AR_ADJUST_TYPE = "Please select the adjust type.";
	public final static String MSG_AR_REFID = "Please enter a numeric reference.";
	public final static String MSG_AR_DESC = "Please enter the description.";
	public final static String MSG_ARADJUST_SUCCESS = "AR successfully adjusted.";
	public final static String MSG_ARCHARGE_SUCCESS = "AR charge successfully added.";
	public final static String MSG_AR_CLOSE_NOENTRY = "No AR entry.";
	public final static String MSG_CASHIER_CLOSE_NOENTRY = "No cashier entry.";
	public final static String MSG_ARCARD_CONFIRM = "Do you want to select this card?";

	// Payment
	public final static String MSG_PAYMENT_SUCCESS = "Payment successfully added.";
	public final static String MSG_PAYMENT_FAILED = "Payment transaction failed.";

	// Refund
	public final static String MSG_REFUND_SUCCESS = "Refund succeed.";
	public final static String MSG_REFUND_FAILED = "Refund failed.";

	// Report Message
	public final static String MSG_ERR_NOCSRENDDATE = "Please supply End Date.";
	public final static String MSG_ERR_NOCSRENDTIME = "Please supply End Time.";
	public final static String MSG_ERR_NODOCCODE_OPTION = "Please select Doctor Option.";
	public final static String MSG_ERR_NOSICKCODE_OPTION = "Please select Sick Code Option.";
	public final static String MSG_ERR_NOREADMITDAY = "Please supply Readmit Day.";
	public final static String MSG_ERR_NOITMGRP = "Please supply Item Group.";
	public final static String MSG_NO_RECEIPT = "Please supply receipt no.";
	public final static String MSG_PRINT_RECEIPT = "Print a receipt for this payment?";
	public final static String MSG_SAVE_FIRST = "Please save all the data first!!";
	public final static String MSG_BILL_REPORT = "Please select either Original Report or Copy Report.";
	public final static String MSG_ERR_CANNOT_CONTINUE = "Cannot continue to print report.";
	public final static String MSG_ERR_GENERAL = "Fail to print report:";
	public final static String MSG_ERR_NOSITECODE = "Please supply Site Code.";
	public final static String MSG_ERR_NOSTARTDATE = "Please supply Start Date.";
	public final static String MSG_ERR_NOENDDATE = "Please supply End Date.";
	public final static String MSG_ERR_NOPATNO = "Please supply Patient Number.";
	public final static String MSG_ERR_NOCSHCODE = "Please supply Cashier ID.";
	public final static String MSG_ERR_NODOCCODE = "Please supply Doctor Code.";
	public final static String MSG_ERR_NOPKGCODE = "Please supply Package Code.";
	public final static String MSG_ERR_NOARCCODE = "Please supply Arc Code.";
	public final static String MSG_ERR_NOCAPTUREDATE = "Please supply Capture Date.";
	public final static String MSG_ERR_NOAPPDATE = "Please supply Appointment Date.";
	public final static String MSG_ERR_NORECORDSELECTED = "Please select a record.";
	public final static String MSG_ERR_INVALIDCSHSID = "Invalid/Lack of Cashier Code.";
	public final static String MSG_ERR_INVALIDDATE = "Invalid date: ";
	public final static String MSG_ERR_NOPERCENT = "Please supply percentage.";
	public final static String MSG_ERR_NOSLIPNO = "Please supply slip no.";
	public final static String MSG_ERR_NOPATNAME = "Patient name not supplied.";
	public final static String MSG_ERR_NOPATCNAME = "Patient Chinese name not supplied.";
	public final static String MSG_ERR_NODOCNAME = "Doctor name not supplied.";
	public final static String MSG_ERR_NODOCCNAME = "Doctor Chinese name not supplied.";
	public final static String MSG_ERR_NOITMCODE = "Item code not supplied.";
	public final static String MSG_ERR_NOSTNAMT = "Sliptx amount not supplied.";
	public final static String MSG_ERR_NORPTPARAMETER = "Report parameter(s) not set yet or error occur when adding parameter(s) to Report Queue.  ABORT TO PRINT.";
	public final static String MSG_ERR_NORPTINQUEUE = "No report in Report Queue.  ABORT TO PRINT.";
	public final static String MSG_ERR_NOISCONFIRM = "System does not sure if Doctor Fee Transaction Listing and and Doctor Fee Payable reports are confirmed or not.";
	public final static String MSG_ERR_NOAPPOINTMENTTIME = "INTERNAL ERROR: No appointment time (possibly rptLabelB)";
	public final static String MSG_ERR_NOLABELNOTE = "INTERNAL ERROR: No Label note inputed.";

	public final static String MSG_INVALID_SLPNO = "Slip No. cannot be found in DataBase.";
	public final static String MSG_ERR_NOTALLBABY = "Not all supplymentary Slip(s) are baby slip of ";
	public final static String MSG_ERR_UNABLE2MERGESLIP = "Cannot merge the slips.  ";
	public final static String MSG_ERR_NOTIPSLIP = "Current slip is not a In-Patient Slip.";
	public final static String MSG_ERR_NO_NOOFREPORT2BEPRINTED = "No of report(s) needed not specified.";
	public final static String MSG_ASK2PRINTAUDITSMY = "Would you like to print Cashier Audit Report?";
	public final static String MSG_RPTPRINTED = "The selected report(s) have been printed.";
	public final static String MSG_CONFIRMDOCFEEPAYABLE = "Doctor Fee Transaction Listing and Doctor Fee Payable reports are confirmed?";
	public final static String MSG_HOWMANYLABEL2PRINT = "How many label(s) to be printed?";
	public final static String MSG_UNABLE2LOCKRPT = "Unable to lock report.  Abort to print report.";

	// Slip
	public final static String MSG_CREATESLIP_SUCCESS = "Slip successfully created.";
	public final static String MSG_CREATESLIP_FAIL = "Slip create failed.";
	public final static String MSG_CANCEL_SLIP = "Do you want to cancel the selected slip?";
	public final static String MSG_OPEN_SLIP = "Do you want to reopen the selected slip?";
	public final static String MSG_CANCEL_SLIP_HAS_DETAILS = "Slip has details.  Do you want to cancel the selected slip?";
	public final static String MSG_UPDATED = "Slip has been updated.  Please refresh the screen!";

	// Maintenance
	public final static String MSG_PAYREFUND_CODE_DELETE = "Payment or refund item can only be edited.";
	public final static String MSG_DEPARTMENT_CODE = "Invalid department code.";
	public final static String MSG_DEPARTMENT_SERVICES_CODE = "Invalid department services code.";
	public final static String MSG_WARD_CODE = "Invalid ward code.";
	public final static String MSG_ROOM_CODE = "Invalid room code.";
	public final static String MSG_USER_ID = "Invalid user id.";
	public final static String MSG_DUPLICATE_RECORD = "Record exists.";
	public final static String MSG_DEPARTMENT_SERVICES_CODE_EMPTY = "Department services code cannot be empty.";

	// Ar Maintenance
	public final static String MSG_AR_GLCCODE = "Invalid GlcCode.";

	// Spectra
	public final static String MSG_S9000_INITERROR = "Communication Error.";

	// Calculate Discount
	public final static String MSG_CALCULATE_DISCOUNT = "Discount successfully calculated.";

	// Locking
	public final static String MSG_ARCODE_LOCK = "ArCode is locked by other user.";
	public final static String MSG_SCHEDULE_LOCK = "Schedule is locked by other user.";
	public final static String MSG_TEMPLATE_LOCK = "Schedule template is locked by other user.";
	public final static String MSG_BED_LOCK = "Bed is locked.";
	public final static String MSG_BOOKING_LOCK = "Appointment record is locked by other user.";
	public final static String MSG_OT_APP_LOCK = "OT Appointment record is locked by [user].";

	// Security
	public final static String MSG_NO_ROLE_SELECTED = "No role is selected.";
	public final static String MSG_PASSWORD_NOTMATCH = "Password not match, please retry.";
	public final static String MSG_REQUIRE_DBA_PRIVILEGE = "Can't save user record, you may not have the required privilege to save the record.";

	// Budget
	public final static String MSG_ITC_TYPE = "Itc Type should be I/O/D.";
	public final static String MSG_PACKAGE_TYPE = "Please select the package type.";
	public final static String MSG_ITEM_CATEGORY = "Please select the item category.";
	public final static String MSG_MOVE_BUDGET_TO_FEES = "Do you want to move budget to fees?";
	public final static String MSG_MOVE_FEES_TO_BUDGET = "Do you want to move fees to budget?";
	public final static String MSG_MOVE_BUDGET_TO_FEES_FAILS = "Move budget to fees fails.";
	public final static String MSG_MOVE_BUDGET_TO_FEES_SUCCESS = "Move budget to fees succeeds.";
	public final static String MSG_MOVE_FEES_TO_BUDGET_FAILS = "Move fees to budget fails.";
	public final static String MSG_MOVE_FEES_TO_BUDGET_SUCCESS = "Move fees to budget succeeds.";

	public final static String MSG_EMPTY_CHARGES = "Item charge and credit item charge tables are empty.";
	public final static String MSG_EMPTY_BUDGET = "Budget and credit budget tables are empty.";

	// Departmental Package
	public final static String MSG_DEPARTMENT_PACKAGE = "Deparmental users can only add their corresponding package.";

	// Quick Charge
	public final static String MSG_VISIT_PKGCODE = "Please select the visit.";
	public final static String MSG_CREDIT_CHARGES = "Credit charges can not post to reference file.";

	// Refund
	public final static String MSG_NO_REFUND_ITEM = "Invalid refund item/glcode.";

	// Archive
	public final static String MSG_ARCHIVE_DATE = "Invalid date.";
	public final static String MSG_ARCHIVE = "Do you want to archive the tables.";
	public final static String MSG_ARCHIVE_FINISH = "Archive finished.";
	public final static String MSG_ARCHIVE_FAIL = "Archive failed.";

	// Item Charge
	public final static String MSG_INVALID_ITEM = "Invalid item charge type!";
	public final static String MSG_WRONG_KEY = "Itc Type, Pkg Code and Acm. Code should be a key.";
	public final static String MSG_LACK_ITEM = "Please enter the Itc Type!";

	// User Maintenance
	public final static String MSG_CURRENT_USER = "Can not delete current user.";
	public final static String MSG_DOCTOR_INACTIVE = "Inactive doctor.";

	// Pre-Booking
	public final static String MSG_PB_FAIL = "Save Pre-Booking Failed.";
	public final static String MSG_Share_Fix = "Please input either Share % and Fix Amt!";

	// Discharge
	public final static String MSG_NO_DIST_DESTINATION = "Please enter Discharge Destination.";

	// App browse
	public final static String MSG_POS_INTEGER = "Please enter an positive integer.";

	// OT
	public final static String MSG_NO_OT_MISC_TYPE = "Please enter the OT Misc Type.";
	public final static String MSG_END_DT_FOLLOW_START_DT = "End Date/Time should not be earlier than or the same as Start Date/Time.";
	public final static String MSG_SAME_APP_DATE = "Appointment time range should be at the same day.";
	public final static String MSG_OVERLAP_APP_PERIOD = "Appointment period is overlapped! Continue?";
	public final static String MSG_CANCEL_OT_APP = "Do you want to cancel the OT appointment?";
	public final static String MSG_REOPEN_OT_APP = "Do you want to reopen the OT appointment?";
	public final static String MSG_DOC_TERMINATION = " surgery date > admission expiry date, continue to save?";
	public final static String MSG_DOC_TERMINATION_OKONLY = " surgery date > admission expiry date";
	public final static String MSG_PB_APP_CANC = "The Pre-booking Appointment is cancelled";
	public final static String MSG_NEW_OTAPP_LINK_PB = "New OT appointment will be linked up with this existing Pre-booking record";

	public final static String MSG_DOCTOR_INACTION = "The current doctor is inactive or invalid.";

	public final static String MSG_SLIP_LOCK = "Slip is locked by other user.";

	public final static String MSG_PBA_SYSTEM = "PBA - [Patient Business Administration System]";
}