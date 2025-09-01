package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.Date;

import org.joda.time.DateTime;
import org.joda.time.LocalDate;

import com.hkah.web.db.helper.FsModelHelper;

public class FsCategoryInPat extends FsCategory {
	protected Date admDate;
	protected Date dischargeDate;
	protected Date docDate;
	protected String icdCode;
	protected String icdName;
	protected String icdCodeRsn;
	protected String icdNameRsn;	
	
	public static FsCategoryInPat createInstance(FsCategoryInPat aFsCategoryInPat, FsCategoryInPat titleSrc) {
		FsCategoryInPat newObj = FsCategoryInPat.newInstance(aFsCategoryInPat);
		newObj.setAdmDate(titleSrc.getAdmDate());
		newObj.setDischargeDate(titleSrc.getDischargeDate());
		newObj.setDocDate(titleSrc.getDocDate());
		newObj.setIcdCode(titleSrc.getIcdCode());
		newObj.setIcdName(titleSrc.getIcdName());
		newObj.setIcdCodeRsn(titleSrc.getIcdCodeRsn());
		newObj.setIcdNameRsn(titleSrc.getIcdNameRsn());
		return newObj;
	}
	
	public static FsCategoryInPat newInstance(FsCategoryInPat aFsCategoryInPat) {
		FsCategoryInPat newObj = new FsCategoryInPat();
		aFsCategoryInPat.setValues(newObj);
		return newObj;
	}
	
	public FsCategoryInPat() {
		super();
	}
	
	public FsCategoryInPat(Date admDate, Date dischargeDate, String icdCode, String icdName) {
		this(admDate, dischargeDate, null, icdCode, icdName, null, null);
	}

	public FsCategoryInPat(Date admDate, Date dischargeDate, Date docDate, String icdCode, String icdName,
			String icdCodeRsn, String icdNameRsn) {
		super();
		this.admDate = admDate;
		this.dischargeDate = dischargeDate;
		this.docDate = docDate;
		this.icdCode = icdCode;
		this.icdName = icdName;
		this.icdCodeRsn = icdCodeRsn;
		this.icdNameRsn = icdNameRsn;		
	}

	public Date getAdmDate() {
		return admDate;
	}

	public String getDisplayAdmDate() {
		if (getAdmDate() != null)
			return FsModelHelper.displayDateFormatMiddleEndianShort.format(getAdmDate());
	
		return null;
	}
	
	public void setAdmDate(Date admDate) {
		this.admDate = admDate;
	}


	public Date getDischargeDate() {
		return dischargeDate;
	}

	public String getDisplayDischargeDate() {
		if (getDischargeDate() != null)
			return FsModelHelper.displayDateFormatMiddleEndianShort.format(getDischargeDate());
	
		return null;
	}

	public void setDischargeDate(Date dischargeDate) {
		this.dischargeDate = dischargeDate;
	}


	public String getIpPeriod() {
		String admDateStr = getDisplayAdmDate();
		String dischDateStr = getDisplayDischargeDate();
		
		return (admDateStr != null ? admDateStr + " - " : "") + (dischDateStr != null ? dischDateStr : "") +
				(getIcdName() != null ? " (" + getIcdName() + ")" : "");
	}
	
	public String getIcdDisplayString() {
		/*
		 * (<span class="icdcode">%fsIcdCode%</span> - <span class="icddesc">%fsIcdName%</span> (<span class="icdcode">%fsIcdCodeRsn%</span> - <span class="icddesc">%fsIcdNameRsn%</span>))
		 */
		String icd = "";
		if ((getIcdCode() != null && !"".equals(getIcdCode())) || 
				(getIcdName() != null && !"".equals(getIcdName()))) {
			icd += "(";
			if (getIcdCode() != null && !"".equals(getIcdCode())) {
				icd += "<span class=\"icdcode\">" + getIcdCode() + "</span>";
			}
			if (getIcdName() != null && !"".equals(getIcdName())) {
				icd += " - <span class=\"icddesc\">" + getIcdName() + "</span>";
			}
			String icdRsn = "";
			if ((getIcdCodeRsn() != null && !"".equals(getIcdCodeRsn())) || 
					(getIcdNameRsn() != null && !"".equals(getIcdNameRsn()))) {
				icdRsn += " (";
				if (getIcdCodeRsn() != null && !"".equals(getIcdCodeRsn())) {
					icd += "<span class=\"icdcode\">" + getIcdCodeRsn() + "</span>";
				}
				if (getIcdNameRsn() != null && !"".equals(getIcdNameRsn())) {
					icd += " - <span class=\"icddesc\">" + getIcdNameRsn() + "</span>";
				}
				icdRsn += ")";
			}
			icd += icdRsn + ")";
		}
		return icd;
	}

	public Date getDocDate() {
		return docDate;
	}

	public String getDisplayDocDate() {
		if (getDocDate() != null)
			return FsModelHelper.displayDateFormatMiddleEndianShort.format(getDocDate());
	
		return null;
	}
	
	public void setDocDate(Date docDate) {
		this.docDate = docDate;
	}

	public String getIcdName() {
		return icdName;
	}

	public void setIcdName(String icdName) {
		this.icdName = icdName;
	}

	public String getIcdCode() {
		return icdCode;
	}

	public void setIcdCode(String icdCode) {
		this.icdCode = icdCode;
	}

	public String getIcdCodeRsn() {
		return icdCodeRsn;
	}

	public void setIcdCodeRsn(String icdCodeRsn) {
		this.icdCodeRsn = icdCodeRsn;
	}

	public String getIcdNameRsn() {
		return icdNameRsn;
	}

	public void setIcdNameRsn(String icdNameRsn) {
		this.icdNameRsn = icdNameRsn;
	}

	public boolean equalsCategory(FsCategoryInPat fsCategoryInPat) {
		if (fsCategoryInPat == null)
			return false;
		
		BigDecimal cid = fsCategoryInPat.getFsCategoryId();
		
		if (this.fsCategoryId != null && cid != null && this.fsCategoryId.compareTo(cid) == 0 && 
				equalsAdmDisch(fsCategoryInPat.getAdmDate(), fsCategoryInPat.getDischargeDate())) {
			return true;
		}
		return false;
	}
	
	public boolean equalsFile(FsFileIndex fsFileIndex) {
		FsFileProfile profile = fsFileIndex.getFsFileProfile();
		BigDecimal cid = null;
		if (profile != null) {
			FsCategory category = profile.getFsCategory();
			cid = category.getFsCategoryId();
		}
		
		if (this.fsCategoryId != null && cid != null && this.fsCategoryId.compareTo(cid) == 0 && 
				equalsAdmDisch(fsFileIndex.getFsAdmDate(), fsFileIndex.getFsDischargeDate())) {
			return true;
		}
		return false;
	}
	
	public boolean equalsAdmDisch(Date aAdmDate, Date aDischargeDate) {
		DateTime admDate = new DateTime(this.getAdmDate() != null ? this.getAdmDate().getTime() : 0);
		DateTime dischargeDate = new DateTime(this.getDischargeDate() != null ? this.getDischargeDate().getTime() : 0); 
		LocalDate admDateL = admDate.toLocalDate();
		LocalDate dischargeDateL = dischargeDate.toLocalDate();
		
		DateTime fAdmDate = new DateTime(aAdmDate != null ? aAdmDate.getTime() : 0);
		DateTime fDischargeDate = new DateTime(aDischargeDate != null ? aDischargeDate.getTime() : 0); 
		LocalDate fAdmDateL = fAdmDate.toLocalDate();
		LocalDate fDischargeDateL = fDischargeDate.toLocalDate();
		
		if (admDateL.compareTo(fAdmDateL) == 0 &&
				dischargeDateL.compareTo(fDischargeDateL) == 0) {
			return true;
		} else {
			return false;
		}
	}
	
	public String getDecodeDisplayFsName() {
		if (getFsName() == null)
			return null;
		
		String undecodeDesc = getFsName();
		String[] split = undecodeDesc.split("%");
		if (split != null) {
			for (int i = 0; i < split.length; i++) {
				String toBeReplace = split[i];
				toBeReplace = "%" + toBeReplace + "%";
				if (i % 2 != 0) {
					if ("%admDate%".equals(toBeReplace)) {
						undecodeDesc = undecodeDesc.replaceAll(toBeReplace, getDisplayAdmDate() != null ? getDisplayAdmDate() : "");
					}
					if ("%dischargeDate%".equals(toBeReplace)) {
						undecodeDesc = undecodeDesc.replaceAll(toBeReplace, getDisplayDischargeDate() != null ? getDisplayDischargeDate() : "");;
					}
					if ("%docDate%".equals(toBeReplace)) {
						undecodeDesc = undecodeDesc.replaceAll(toBeReplace, getDisplayDocDate() != null ? getDisplayDocDate() : "");
					}
					if ("%fsIcds%".equals(toBeReplace)) {
						undecodeDesc = undecodeDesc.replaceAll(toBeReplace, getIcdDisplayString() != null ? getIcdDisplayString() : "");
					}
					if ("%fsIcdCode%".equals(toBeReplace)) {
						undecodeDesc = undecodeDesc.replaceAll(toBeReplace, getIcdCode() != null ? getIcdCode() : "");
					}
					if ("%fsIcdName%".equals(toBeReplace)) {
						undecodeDesc = undecodeDesc.replaceAll(toBeReplace, getIcdName() != null ? getIcdName() : "");
					}
					if ("%fsIcdCodeRsn%".equals(toBeReplace)) {
						undecodeDesc = undecodeDesc.replaceAll(toBeReplace, getIcdCodeRsn() != null ? getIcdCodeRsn() : "");
					}
					if ("%fsIcdNameRsn%".equals(toBeReplace)) {
						undecodeDesc = undecodeDesc.replaceAll(toBeReplace, getIcdNameRsn() != null ? getIcdNameRsn() : "");
					}
					if ("%deptCode%".equals(toBeReplace)) {
					}
				}
			}
		}
		return undecodeDesc;
	}
}
