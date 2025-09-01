package com.hkah.web.db.hibernate;

import java.io.Serializable;

public class ELeaveApprovedObjID implements Serializable {
		public int eleaveID;
		public int eleaveApprovedID;
		public ELeaveApprovedObjID() {
			super();
		}
		public ELeaveApprovedObjID(int eleaveID, int eleaveApprovedID) {
			super();
			this.eleaveID = eleaveID;
			this.eleaveApprovedID = eleaveApprovedID;
		}
		public int getEleaveID() {
			return eleaveID;
		}
		public void setEleaveID(int eleaveID) {
			this.eleaveID = eleaveID;
		}
		public int getEleaveApprovedID() {
			return eleaveApprovedID;
		}
		public void setEleaveApprovedID(int eleaveApprovedID) {
			this.eleaveApprovedID = eleaveApprovedID;
		}
		public boolean equals(Object other) {
			if ((this == other))
				return true;
			if ((other == null))
				return false;
			if (!(other instanceof ELeaveApprovedObjID))
				return false;
			ELeaveApprovedObjID castOther = (ELeaveApprovedObjID) other;

			return (this.getEleaveID() == castOther.getEleaveID() && 
					this.getEleaveApprovedID() == castOther.getEleaveApprovedID());
		}

		public int hashCode() {
			int result = 17;

			result = 37
					* result
					+ this.getEleaveID();
			result = 37
					* result
					+ this.getEleaveApprovedID();
			return result;
		}
}