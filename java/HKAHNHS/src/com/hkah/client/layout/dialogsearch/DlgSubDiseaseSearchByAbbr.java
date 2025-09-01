package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.util.Rectangle;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;

public class DlgSubDiseaseSearchByAbbr extends DialogSearchBase {

	public DlgSubDiseaseSearchByAbbr(SearchTriggerField textfField) {
		super(textfField, 780, 450);
	}

	@Override
	protected boolean isSearchFieldsEmpty() {
		// TODO Auto-generated method stub
		return getAbbreviationField().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return null;
	}

	@Override
	public int acceptTableColumn() {
		return 1;
	}

	private BasePanel searchPanel = null;
	private BasePanel ParaPanel = null;
	private BasePanel ListPanel = null;
	private JScrollPane sickScrollPanel = null;
	private LabelSmallBase abbreviationLabel = null;
	private TextString abbreviationField = null;

	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(800, 175);
			searchPanel.add(getParaPanel(),null);
			searchPanel.add(getListPanel(), null);
		}
		return searchPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setLocation(15, 15);
			ParaPanel.setSize(734, 40);
			ParaPanel.add(getAbbreviationLabel(), null);
			ParaPanel.add(getAbbreviationField(), null);
		}
		return ParaPanel;
	}

	private LabelSmallBase getAbbreviationLabel() {
		if (abbreviationLabel == null) {
			abbreviationLabel = new LabelSmallBase("Abbreviation");
			abbreviationLabel.setBounds(5, 5, 40, 20);
		}
		return abbreviationLabel;
	}

	private TextString getAbbreviationField() {
		if (abbreviationField == null) {
			abbreviationField = new TextString() {
				@Override
				protected void onReleased() {
					searchAction(false);
				}
			};
			abbreviationField.setBounds(90, 5, 150, 20);
		}
		return abbreviationField;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setBounds(new Rectangle(15, 70, 734, 280));
			ListPanel.add(getSickScrollPane());
		}
		return ListPanel;
	}

	protected JScrollPane getSickScrollPane() {
		if (sickScrollPanel == null) {
			sickScrollPanel = new JScrollPane();
			sickScrollPanel.setViewportView(getListTable());
			sickScrollPanel.setBounds(0, 0, 734, 280);
		}
		return sickScrollPanel;
	}

	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Abbreviation",
				"Sub-disease Code",
				"Sub-disease Description"
		};
	}

	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				120,
				250,
				250
		};
	}

	@Override
	protected void initAfterReady() {
	}

	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getAbbreviationField().getText().trim()
		};
	}

	@Override
	public String getTxCode() {
		return "SUBDISEASEBYABBR";
	}

	@Override
	public String getTitle() {
		return "Search Sub-disease Code";
	}

	@Override
	public TextBase getDefaultFocusComponent() {
		return getAbbreviationField();
	}
}