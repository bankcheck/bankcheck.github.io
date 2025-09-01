package com.hkah.client.util;

public class Crypt {

	public static String xorString(String input) {
		char in[] = input.toCharArray();
		char out[] = new char[in.length];
		for (int i = 0; i < in.length; i++) {
			out[i] = (char) (in[i] ^ 127);
		}
		return new String(out);
	}
}