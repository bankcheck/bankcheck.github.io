package com.hkah.client.tx.registration;

public class PatientDayCase extends Patient {

	/**
	 * This method initializes
	 */
	public PatientDayCase() {
	}

	@Override
	protected void initAfterReady() {
		setModifyButtonEnabled(false);
		setParameter("START_TYPE", REG_TYPE_DAYCASE);
		super.initAfterReady();
	}
}