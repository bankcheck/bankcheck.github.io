package com.hkah.web.db.hibernate;

import java.util.Date;

public class MpaMeeting {
	private Date date;
	private String responsibleBy;
	private String description;
	private String proposedDate;
	private String remarks;
	private String confirmedDate;
	private String confirmedTime;
	/**
	 * @return the date
	 */
	public Date getDate() {
		return date;
	}
	/**
	 * @param date the date to set
	 */
	public void setDate(Date date) {
		this.date = date;
	}
	/**
	 * @return the responsibleBy
	 */
	public String getResponsibleBy() {
		return responsibleBy;
	}
	/**
	 * @param responsibleBy the responsibleBy to set
	 */
	public void setResponsibleBy(String responsibleBy) {
		this.responsibleBy = responsibleBy;
	}
	
	public String[] getResponsibleByIndividual() {
		String[] persons = null;
		if (responsibleBy != null) {
			persons = responsibleBy.split(",");
			for (String person : persons) {
				person = person != null ? person.trim() : person;
			}
		}
		return persons;
	}
	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * @param description the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}
	
	public void appendDescription(String appendDescription) {
		String newDescription = this.description;
		newDescription = (appendDescription != null && appendDescription.length() > 0) ? newDescription + "<br />" + appendDescription : newDescription;
		this.description = newDescription;
	}
	/**
	 * @return the proposedDate
	 */
	public String getProposedDate() {
		return proposedDate;
	}
	/**
	 * @param proposedDate the proposedDate to set
	 */
	public void setProposedDate(String proposedDate) {
		this.proposedDate = proposedDate;
	}
	
	public void appendProposedDate(String appendProposedDate) {
		String newProposedDate = this.proposedDate;
		newProposedDate = (appendProposedDate != null && appendProposedDate.length() > 0) ? newProposedDate + "<br />" + appendProposedDate : newProposedDate;
		this.proposedDate = newProposedDate;
	}
	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}
	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	public void appendRemarks(String appendRemarks) {
		String newRemarks = this.remarks;
		newRemarks = (appendRemarks != null && appendRemarks.length() > 0)  ? newRemarks + "<br />" + appendRemarks : newRemarks;
		this.remarks = newRemarks;
	}
	/**
	 * @return the confirmedDate
	 */
	public String getConfirmedDate() {
		return confirmedDate;
	}
	/**
	 * @param confirmedDate the confirmedDate to set
	 */
	public void setConfirmedDate(String confirmedDate) {
		this.confirmedDate = confirmedDate;
	}
	/**
	 * @return the confirmedTime
	 */
	public String getConfirmedTime() {
		return confirmedTime;
	}
	/**
	 * @param confirmedTime the confirmedTime to set
	 */
	public void setConfirmedTime(String confirmedTime) {
		this.confirmedTime = confirmedTime;
	}
	
	
}
