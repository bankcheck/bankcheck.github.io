package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
//import com.hkah.client.layout.dialogsearch.DlgARCodeSimpleSearch;
import com.hkah.client.layout.dialogsearch.DlgARCardSearch;

public class TextARCodeSimpleSearch extends SearchTriggerField {

//	private DlgARCodeSimpleSearch dlgARCodeSimpleSearch = null;
	private DlgARCardSearch dlgARCardSearch = null;
	String showActive = "0";

	public TextARCodeSimpleSearch() {
		super();
	}
	
	public TextARCodeSimpleSearch(String showActive) {
		super();
		this.showActive = showActive;		
	}	

	public TextARCodeSimpleSearch(boolean showSearchTrigger) {
		super(!showSearchTrigger, true);	// all upper case
	}
	/*
	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgARCodeSimpleSearch == null) {
			dlgARCodeSimpleSearch = new DlgARCodeSimpleSearch(this);
		}
		return dlgARCodeSimpleSearch;
	}
*/
	public void post(String ArcCode, String ARCardType, String ARCardName, String ARCardDesc, String ARCardCode) {
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgARCardSearch == null) {
			dlgARCardSearch = new DlgARCardSearch(this,showActive){
				@Override
				protected void acceptPostAction() {
					String actid = this.getListTable().getSelectedRowContent()[0];
					String arCode = this.getListTable().getSelectedRowContent()[1];
					String arcName = this.getListTable().getSelectedRowContent()[2];
					String actCode = this.getListTable().getSelectedRowContent()[3];
					String actDesc = this.getListTable().getSelectedRowContent()[4];
			  
					post(arCode, actid, arcName, actDesc, actCode);					
				}
			};			
		}
		return dlgARCardSearch;
	}	
	
}