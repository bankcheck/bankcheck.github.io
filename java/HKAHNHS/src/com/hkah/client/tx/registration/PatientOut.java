package com.hkah.client.tx.registration;

public class PatientOut extends Patient {

	/**
	 * This method initializes
	 */
	public PatientOut() {
	}

	@Override
	protected void initAfterReady() {
		setParameter("START_TYPE", REG_TYPE_OUTPATIENT);
		super.initAfterReady();
	}
}