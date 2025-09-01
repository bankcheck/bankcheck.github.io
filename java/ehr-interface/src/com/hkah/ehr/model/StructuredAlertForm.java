package com.hkah.ehr.model;

public class StructuredAlertForm {
	// Service Information
	//private String systemLogin = null;	// system config
	private String sourceSystem = null;
	
	// User Information
	private String login = null;
	private String loginName = null;
	private String userRank = null;
	private String userRankDesc = null;
	private String userRight = null;
	//private String hospitalCode = null;	// system config
	//private String hospitalName = null;	// system config
	private String actionCode = null;
	
	// Patient Information
	//private String mrnDisplayLabelP = null;	// system config
	//private String mrnDisplayLabelE = null;	// system config
	//private String mrnDisplayType = null;	// system config
	
	private String patno = null;
	private String regid = null;
	
	private String mrnPatientIdentity = null;
	private String mrnPatientEncounterNo = null;
	private String ehrno = null;
	private String doctype = null;
	private String docnum = null;
	private String nation = null;
	private String engSurName = null;
	private String engGivenName = null;
	private String chiName = null;
	private String oname = null;
	private String sex = null;
	private String dob = null;
	private String age = null;
	private String deathDate = null;
	private String marital = null;
	private String religion = null;
	private String phoneH = null;
	private String phoneM = null;
	private String phoneOf = null;
	private String phoneOt = null;
	private String residentialAddress = null;
	private String photoContent = null;
	private String photoContentType = null;
	
	// Patient Admission Information
	private String showRegInfo = null;
	private String inMethod = null;
	private String admD = null;
	private String disD = null;
	private String attdoc = null;
	private String condoc = null;
	private String spec = null;
	private String classNum = null;
	private String ward = null;
	private String bed = null;
	private String details = null;
	
	public String getSourceSystem() {
		return sourceSystem;
	}
	public void setSourceSystem(String sourceSystem) {
		this.sourceSystem = sourceSystem;
	}
	public String getLogin() {
		return login;
	}
	public void setLogin(String login) {
		this.login = login;
	}
	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public String getUserRank() {
		return userRank;
	}
	public void setUserRank(String userRank) {
		this.userRank = userRank;
	}
	public String getUserRankDesc() {
		return userRankDesc;
	}
	public void setUserRankDesc(String userRankDesc) {
		this.userRankDesc = userRankDesc;
	}
	public String getUserRight() {
		return userRight;
	}
	public void setUserRight(String userRight) {
		this.userRight = userRight;
	}
	public String getActionCode() {
		return actionCode;
	}
	public void setActionCode(String actionCode) {
		this.actionCode = actionCode;
	}
	public String getPatno() {
		return patno;
	}
	public void setPatno(String patno) {
		this.patno = patno;
	}
	public String getRegid() {
		return regid;
	}
	public void setRegid(String regid) {
		this.regid = regid;
	}
	public String getMrnPatientIdentity() {
		return mrnPatientIdentity;
	}
	public void setMrnPatientIdentity(String mrnPatientIdentity) {
		this.mrnPatientIdentity = mrnPatientIdentity;
	}
	public String getMrnPatientEncounterNo() {
		return mrnPatientEncounterNo;
	}
	public void setMrnPatientEncounterNo(String mrnPatientEncounterNo) {
		this.mrnPatientEncounterNo = mrnPatientEncounterNo;
	}
	public String getEhrno() {
		return ehrno;
	}
	public void setEhrno(String ehrno) {
		this.ehrno = ehrno;
	}
	public String getDoctype() {
		return doctype;
	}
	public void setDoctype(String doctype) {
		this.doctype = doctype;
	}
	public String getDocnum() {
		return docnum;
	}
	public void setDocnum(String docnum) {
		this.docnum = docnum;
	}
	public String getNation() {
		return nation;
	}
	public void setNation(String nation) {
		this.nation = nation;
	}
	public String getEngSurName() {
		return engSurName;
	}
	public void setEngSurName(String engSurName) {
		this.engSurName = engSurName;
	}
	public String getEngGivenName() {
		return engGivenName;
	}
	public void setEngGivenName(String engGivenName) {
		this.engGivenName = engGivenName;
	}
	public String getChiName() {
		return chiName;
	}
	public void setChiName(String chiName) {
		this.chiName = chiName;
	}
	public String getOname() {
		return oname;
	}
	public void setOname(String oname) {
		this.oname = oname;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getDob() {
		return dob;
	}
	public void setDob(String dob) {
		this.dob = dob;
	}
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = age;
	}
	public String getDeathDate() {
		return deathDate;
	}
	public void setDeathDate(String deathDate) {
		this.deathDate = deathDate;
	}
	public String getMarital() {
		return marital;
	}
	public void setMarital(String marital) {
		this.marital = marital;
	}
	public String getReligion() {
		return religion;
	}
	public void setReligion(String religion) {
		this.religion = religion;
	}
	public String getPhoneH() {
		return phoneH;
	}
	public void setPhoneH(String phoneH) {
		this.phoneH = phoneH;
	}
	public String getPhoneM() {
		return phoneM;
	}
	public void setPhoneM(String phoneM) {
		this.phoneM = phoneM;
	}
	public String getPhoneOf() {
		return phoneOf;
	}
	public void setPhoneOf(String phoneOf) {
		this.phoneOf = phoneOf;
	}
	public String getPhoneOt() {
		return phoneOt;
	}
	public void setPhoneOt(String phoneOt) {
		this.phoneOt = phoneOt;
	}
	public String getResidentialAddress() {
		return residentialAddress;
	}
	public void setResidentialAddress(String residentialAddress) {
		this.residentialAddress = residentialAddress;
	}
	public String getPhotoContent() {
		return photoContent;
	}
	public void setPhotoContent(String photoContent) {
		this.photoContent = photoContent;
	}
	public String getPhotoContentType() {
		return photoContentType;
	}
	public void setPhotoContentType(String photoContentType) {
		this.photoContentType = photoContentType;
	}
	public String getShowRegInfo() {
		return showRegInfo;
	}
	public void setShowRegInfo(String showRegInfo) {
		this.showRegInfo = showRegInfo;
	}
	public String getInMethod() {
		return inMethod;
	}
	public void setInMethod(String inMethod) {
		this.inMethod = inMethod;
	}
	public String getAdmD() {
		return admD;
	}
	public void setAdmD(String admD) {
		this.admD = admD;
	}
	public String getDisD() {
		return disD;
	}
	public void setDisD(String disD) {
		this.disD = disD;
	}
	public String getAttdoc() {
		return attdoc;
	}
	public void setAttdoc(String attdoc) {
		this.attdoc = attdoc;
	}
	public String getCondoc() {
		return condoc;
	}
	public void setCondoc(String condoc) {
		this.condoc = condoc;
	}
	public String getSpec() {
		return spec;
	}
	public void setSpec(String spec) {
		this.spec = spec;
	}
	public String getClassNum() {
		return classNum;
	}
	public void setClassNum(String classNum) {
		this.classNum = classNum;
	}
	public String getWard() {
		return ward;
	}
	public void setWard(String ward) {
		this.ward = ward;
	}
	public String getBed() {
		return bed;
	}
	public void setBed(String bed) {
		this.bed = bed;
	}
	public String getDetails() {
		return details;
	}
	public void setDetails(String details) {
		this.details = details;
	}
}
