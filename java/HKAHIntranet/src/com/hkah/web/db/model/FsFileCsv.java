package com.hkah.web.db.model;

import java.util.ArrayList;
import java.util.Date;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.ForwardScanningDB;
import com.hkah.web.db.helper.FsModelHelper;

public class FsFileCsv implements Cloneable {
	protected String patientCode;
	protected Date docCreationDate;
	protected String formCode;
	protected String filePath;
	protected String fileDocType;
	protected String regID;
	protected Integer docSeqNo;
	protected Date admDate;
	protected Date dischargeDate;
	
	protected boolean imported;
	protected Date importDate;
	protected String paramStr;
	protected boolean diffPatCodeFromBatch;
	protected Boolean invalidFormCode = null;
	protected Integer replaceCode;
	protected String labNum;
	protected String stationId;
	protected String invalidCode;	
	
	public FsFileCsv() {
		super();
	}

	public FsFileCsv(String patientCode, Date docCreationDate,
			String formCode, String filePath, String fileDocType, String regID,
			Integer docSeqNo, Date admDate, Date dischargeDate, 
			Integer replaceCode, String labNum) {
		super();
		this.patientCode = patientCode;
		this.docCreationDate = docCreationDate;
		this.formCode = formCode;
		this.filePath = filePath;
		this.fileDocType = fileDocType;
		this.regID = regID;
		this.docSeqNo = docSeqNo;
		this.admDate = admDate;
		this.dischargeDate = dischargeDate;
		this.replaceCode = replaceCode;
		this.labNum = labNum;
	}

	public String getPatientCode() {
		return patientCode;
	}

	public void setPatientCode(String patientCode) {
		this.patientCode = patientCode;
	}

	public Date getDocCreationDate() {
		return docCreationDate;
	}
	
	public String getDocCreationDateDisplay() {
		return DateTimeUtil.formatDate(this.getDocCreationDate());
	}

	public void setDocCreationDate(Date docCreationDate) {
		this.docCreationDate = docCreationDate;
	}

	public String getFormCode() {
		return formCode;
	}

	public void setFormCode(String formCode) {
		this.formCode = formCode;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFileDocType() {
		return fileDocType;
	}

	public void setFileDocType(String fileDocType) {
		this.fileDocType = fileDocType;
	}

	public String getRegID() {
		return regID;
	}

	public void setRegID(String regID) {
		this.regID = regID;
	}

	public Integer getDocSeqNo() {
		return docSeqNo;
	}

	public void setDocSeqNo(Integer docSeqNo) {
		this.docSeqNo = docSeqNo;
	}

	public Date getAdmDate() {
		return admDate;
	}
	
	public String getAdmDateDisplay() {
		return DateTimeUtil.formatDate(this.getAdmDate());
	}

	public void setAdmDate(Date admDate) {
		this.admDate = admDate;
	}

	public Date getDischargeDate() {
		return dischargeDate;
	}
	
	public String getDischargeDateDisplay() {
		return DateTimeUtil.formatDate(this.getDischargeDate());
	}
	
	public void setDischargeDate(Date dischargeDate) {
		this.dischargeDate = dischargeDate;
	}

	public Integer getReplaceCode() {
		return replaceCode;
	}

	public void setReplaceCode(Integer replaceCode) {
		this.replaceCode = replaceCode;
	}

	public String getLabNum() {
		return labNum;
	}

	public void setLabNum(String labNum) {
		this.labNum = labNum;
	}

	public boolean isImported() {
		return imported;
	}

	public void setImported(boolean imported) {
		this.imported = imported;
	}

	public Date getImportDate() {
		return importDate;
	}

	public void setImportDate(Date importDate) {
		this.importDate = importDate;
	}

	public String getParamStr() {
		return paramStr;
	}

	public void setParamStr(String paramStr) {
		this.paramStr = paramStr;
	}
	
	public String getStationId() {
		return stationId;
	}

	public void setStationId(String stationId) {
		this.stationId = stationId;
	}

	public boolean isPatientCodeValid() {
		String patientCode = getPatientCode();
		String pattern = "^[T]?\\d{5,}$";
		// Valid patient code (HKAH/TWAH)  should be consist of numbers only (except testing data (i.e. Txxxxxx)
		if (patientCode != null && !patientCode.isEmpty()) {
			return patientCode.matches(pattern);
		} else {
			// bypass patient code validation if the batch is referral lab forms
			if (isReferralLab()) {
				return true;
			} else {
				return false;
			}
		}
	}
	
	public boolean isPatientDateValid() {
		if(!isAdmissionDateValid() || !isDischargeDateValid()){
			return false;
		}else{
			return true;
		}
	}
	
	public boolean isAdmissionDateValid(){
		String patientType = getFileDocType();	
		if(patientType != null){
			if(patientType.equals("I") && getRegID() != null){		
				if(getAdmDate() == null){
					return false;
				}				
			}
		}
			return true;
	}
	
	public boolean isDischargeDateValid(){
		String patientType = getFileDocType();	
		if(patientType != null){
			if(patientType.equals("I") && getRegID() != null){		
				if(getDischargeDate() == null){
					return false;
				}				
			}
		}
			return true;
	}
	
	public boolean isFormCodeValid() {
		// false if form code cannot map with FS_FORM or FS_FORM_ALIAS to get a mapped category (including unknown cat)
		// HKAH: including unknown cat
		// exclude HIS
		if (invalidFormCode == null) {
			String cat = ForwardScanningDB.getMatchedCategoryId(this);
			boolean isInValid = cat == null || 
				(ConstantsServerSide.isHKAH() && FsModelHelper.HKAH_UNKNOWN_CAT_ID.toPlainString().equals(cat));
			setInvalidFormCode(isInValid);
		}
		return !isInvalidFormCode();
	}
	
	public boolean isFormBelongsTo(String formCode, String pattype) {
		if (formCode != null) {
			ArrayList r = ForwardScanningDB.getAllFormatListByFormCode(formCode, pattype);
			if (r != null) {
				for (int j = 0; j < r.size(); j++) {
					ReportableListObject row = (ReportableListObject) r.get(j);
					String master = row.getValue(0);
					String alias =  row.getValue(1);
					if (getFormCode() != null && 
							(getFormCode().equals(master) || getFormCode().equals(alias))) {
						return true;
					}
				}
			}
		}
		return false;
	}
	
	public boolean isPattypeValid() {
		return FsModelHelper.pattypes.containsKey(getFileDocType());
	}
	
	public boolean isValidated() {
		return isPatientDateValid() && isPatientCodeValid() && isFormCodeValid() && isPattypeValid();
	}

	public boolean isDiffPatCodeFromBatch() {
		return diffPatCodeFromBatch;
	}

	public void setDiffPatCodeFromBatch(boolean diffPatCodeFromBatch) {
		this.diffPatCodeFromBatch = diffPatCodeFromBatch;
	}
	
	public boolean isReferralLab() {
		return getLabNum() != null && !getLabNum().isEmpty();
	}

	public Boolean isInvalidFormCode() {
		return invalidFormCode;
	}

	public void setInvalidFormCode(Boolean invalidFormCode) {
		this.invalidFormCode = invalidFormCode;
	}
	
	public String getInvalidCode() {
		return invalidCode;
	}
	
	public void addInvalidCode(String invalidCode) {
		if (this.invalidCode == null) {
			this.invalidCode = "";
		}
		if (!this.invalidCode.isEmpty()) {
			this.invalidCode += ";";
		}
		this.invalidCode += invalidCode;
	}
	
	public void removeInvalidCode(String invalidCode) {
		if (this.invalidCode != null) {
			this.invalidCode = this.invalidCode.replaceAll(invalidCode, "");
			this.invalidCode = this.invalidCode.replaceAll(";;", ";");
		}
	}
	
	public boolean containsInvalidCode(String invalidCode) {
		boolean ret = false;
		if (this.invalidCode != null) {
			ret = this.invalidCode.contains(invalidCode);
		}
		return ret;
	}
	
	public boolean isRegIDValid() {
		// false if it cannot map valid patno, admission date, discharge date from table REG and INPAT
		return !containsInvalidCode(FsModelHelper.INVCODE_REGID);
	}
}
