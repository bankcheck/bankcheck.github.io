package com.hkah.client.layout.combobox;

import java.util.HashMap;
import java.util.Map;

import com.hkah.shared.constants.ConstantsVariable;

public class ComboLaboratory extends ComboBoxBase {

	private Map<String,String> types=new HashMap<String,String>();
	String[] typeNames = new String[] {
			"PROFILE TESTS","HEMATOLOGY&COAGULATION","HORMONES","BIOCHEMISTRY","ALLERGEN TESTS","IMMUNOLOGY",
			"MICROBLOLOGY","URINE RECEIVED Y/N","STOOL RECEIVED Y/N","THERAPEUTIC DRUGS"
	};

	public String[] typeNos = new String[] {
			"P","HE","HO","B","A","I","M","U","S","T"
	};

	public ComboLaboratory() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		this.setSelectedIndex(0);
		for (int i = 0; i < typeNos.length; i++) {
			types.put(typeNos[i],typeNames[i]);
			addItem(typeNos[i], typeNames[i]);
		}
	}

	public String getValue(String key) {
		return types.get(key);
	}

	public String getKey(String value) {
		for (int i = 0; i < typeNos.length; i++) {
			if (types.get(typeNos[i]).equals(value)) {
				return typeNos[i];
			}
		}
		return "";
	}
}