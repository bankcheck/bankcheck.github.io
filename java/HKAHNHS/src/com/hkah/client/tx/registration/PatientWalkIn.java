package com.hkah.client.tx.registration;

public class PatientWalkIn extends Patient {

	/**
	 * This method initializes
	 */
	public PatientWalkIn() {
	}

	@Override
	protected void initAfterReady() {
		setModifyButtonEnabled(false);
		setParameter("START_TYPE", REG_CAT_WALKIN);
		super.initAfterReady();
	}
}