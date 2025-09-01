package com.hkah.client.tx.registration;

public class PatientUrgentCare extends Patient {

	/**
	 * This method initializes
	 */
	public PatientUrgentCare() {
	}

	@Override
	protected void initAfterReady() {
		setModifyButtonEnabled(false);
		setParameter("START_TYPE", REG_CAT_URGENTCARE);
		super.initAfterReady();
	}
}