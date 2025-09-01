package com.hkah.client.tx.registration;

public class PatientIn extends Patient {

	/**
	 * This method initializes
	 */
	public PatientIn() {
	}

	@Override
	protected void initAfterReady() {
		setParameter("START_TYPE", REG_TYPE_INPATIENT);
		super.initAfterReady();
	}
}