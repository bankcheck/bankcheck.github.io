package com.hkah.client.tx.registration;

public class PatientPriority extends Patient {

	/**
	 * This method initializes
	 */
	public PatientPriority() {
	}

	@Override
	protected void initAfterReady() {
		setModifyButtonEnabled(false);
		setParameter("START_TYPE", REG_CAT_PRIORITY);
		super.initAfterReady();
	}
}