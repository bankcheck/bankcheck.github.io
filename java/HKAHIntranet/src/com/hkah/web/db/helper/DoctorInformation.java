package com.hkah.web.db.helper;

import java.util.Comparator;

public class DoctorInformation implements Comparator<DoctorInformation>{		
	
	public String docCode;
	public String docFName;
	public String docGName;
	public int sumOfBooking;
	
	public DoctorInformation(){}
	
	public DoctorInformation(String docCode, String docFName, String docGName, int sumOfBooking){
		this.docCode = docCode;
		this.docFName = docFName;
		this.docGName = docGName;
		this.sumOfBooking = sumOfBooking;
	}
	

	@Override
	public int compare(DoctorInformation o1, DoctorInformation o2) {
		return (o1.sumOfBooking > o2.sumOfBooking ? -1 : (o1.sumOfBooking==o2.sumOfBooking ? 0 : 1));
	}
}

