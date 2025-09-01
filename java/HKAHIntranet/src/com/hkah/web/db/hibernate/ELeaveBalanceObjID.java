package com.hkah.web.db.hibernate;


import java.io.Serializable;

public class ELeaveBalanceObjID implements Serializable {
		public String staffID;
		public int year;
		public ELeaveBalanceObjID() {
			super();
		}
		public ELeaveBalanceObjID(String staffID, int year) {
			super();
			this.staffID = staffID;
			this.year = year;
		}
		public String getStaffID() {
			return staffID;
		}
		public void setStaffID(String staffID) {
			this.staffID = staffID;
		}
		public int getYear() {
			return year;
		}
		public void setYear(int year) {
			this.year = year;
		}
		
		public boolean equals(Object other) {
			if ((this == other))
				return true;
			if ((other == null))
				return false;
			if (!(other instanceof ELeaveBalanceObjID))
				return false;
			ELeaveBalanceObjID castOther = (ELeaveBalanceObjID) other;

			return ((this.getStaffID() == castOther.getStaffID()) || (this
					.getStaffID() != null
					&& castOther.getStaffID() != null && this.getStaffID()
					.equals(castOther.getStaffID())))
					&& ((this.getYear() == castOther.getYear()));
		}

		public int hashCode() {
			int result = 17;

			result = 37
					* result
					+ (getStaffID() == null ? 0 : this.getStaffID()
							.hashCode());
			result = 37
					* result
					+ this.getYear();
			return result;
		}
}