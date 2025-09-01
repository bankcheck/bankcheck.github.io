package com.systematic;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.ParseException;
import java.util.Locale;

import org.springframework.format.Formatter;

public class FrancoBigDecimalFormatter implements Formatter<BigDecimal> {

	@Override
	public String print(BigDecimal object, Locale locale) {
		return "$" + object.setScale(2, RoundingMode.HALF_UP).toString();
	}

	@Override
	public BigDecimal parse(String text, Locale locale) throws ParseException { //
		return null;
	}

}
