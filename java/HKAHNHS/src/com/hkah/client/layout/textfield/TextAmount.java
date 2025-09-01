/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.textfield;

import com.hkah.shared.constants.ConstantsTransaction;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class TextAmount extends TextNum {

	public TextAmount() {
		super(ConstantsTransaction.MAX_AMOUNT_LIMIT, 0, false, false);
	}

	public TextAmount(boolean allowNegative) {
		super(ConstantsTransaction.MAX_AMOUNT_LIMIT, 0, false, allowNegative);
	}

	public TextAmount(int integralDigitNum) {
		super(integralDigitNum, 0, false, false);
	}

	public TextAmount(int integralDigitNum, boolean allowNegative) {
		super(integralDigitNum, 0, false, allowNegative);
	}
	
	public TextAmount(int integralDigitNum, int decimalDigitNum, boolean allowNegative) {
		super(integralDigitNum, decimalDigitNum, false, allowNegative);
	}
}