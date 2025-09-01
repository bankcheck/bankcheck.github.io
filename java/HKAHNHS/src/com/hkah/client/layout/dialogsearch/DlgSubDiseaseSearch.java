package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.util.Rectangle;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgSubDiseaseSearch extends DialogSearchBase {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SUBDISEASE_SEARCH_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SUBDISEASE_SEARCH_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Sub-Disease",
			"Sub-Disease Name",
			"Sick Code",
			"Sick Description",
			};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				120,
				250,
				80,
				250
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;
	private BasePanel ParaPanel = null;
	private LabelSmallBase sdsCodeDesc = null;
	private TextString sdsCode = null;
	private LabelSmallBase sdsNameDesc = null;
	private TextString sdsName = null;
	private LabelSmallBase sickCodeDesc = null;
	private TextString sickCode = null;
	private BasePanel ListPanel = null;
	private JScrollPane sickScrollPanel = null;

	public DlgSubDiseaseSearch(SearchTriggerField textField) {
		super(textField, 780, 500);
	}

	@Override
	protected void initAfterReady() {
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getSdsCode();
	}

	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getSdsCode().getText().trim(),
				getSdsName().getText().trim(),
				getSickCode().getText().trim()};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getSdsCode().isEmpty()
			&& getSdsName().isEmpty()
			&& getSickCode().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	/***************************************************************************
	* Layout Method
	**************************************************************************/

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
			ParaPanel.setLocation(15, 25);
			ParaPanel.setHeading("Sub Disease Information");
			ParaPanel.setSize(734, 80);
			ParaPanel.add(getSdsCodeDesc(),null);
			ParaPanel.add(getSdsCode(),null);
			ParaPanel.add(getSdsNameDesc(),null);
			ParaPanel.add(getSdsName(),null);
			ParaPanel.add(getSickCodeDesc(),null);
			ParaPanel.add(getSickCode(),null);
		}
		return ParaPanel;
	}

	public LabelSmallBase getSdsCodeDesc() {
		if (sdsCodeDesc == null) {
			sdsCodeDesc = new LabelSmallBase();
			sdsCodeDesc.setText("Sub-Disease Code");
			sdsCodeDesc.setBounds(5,20, 120, 20);
		}
		return sdsCodeDesc;
	}

	public TextString getSdsCode() {
		if (sdsCode == null) {
			 sdsCode = new TextString();
			 sdsCode.setBounds(130,20, 120, 20);
		}
		return sdsCode;
	}

	public LabelSmallBase getSdsNameDesc() {
		if (sdsNameDesc == null) {
			sdsNameDesc = new LabelSmallBase();
			sdsNameDesc.setText("Sub-Disease Name");
			sdsNameDesc.setBounds(255,20, 120, 20);
		}
		return sdsNameDesc;
	}

	public TextString getSdsName() {
		if (sdsName == null) {
			sdsName = new TextString();
			sdsName.setBounds(380,20, 120, 20);
			}
		return sdsName;
	}

	public LabelSmallBase getSickCodeDesc() {
		 if (sickCodeDesc == null) {
			 sickCodeDesc = new LabelSmallBase();
			 sickCodeDesc.setText("Sick Code");
			 sickCodeDesc.setBounds(5,45, 120, 20);
			}

		return sickCodeDesc;
	}

	public TextString getSickCode() {
		if (sickCode == null) {
			sickCode = new TextString();
			sickCode.setBounds(130,45, 120, 20);
		}
		return sickCode;
	}

	/**
	 * This method initializes sickScrollPanel
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getSickScrollPane() {
		if (sickScrollPanel == null) {
			sickScrollPanel = new JScrollPane();
			sickScrollPanel.setViewportView(getListTable());
			sickScrollPanel.setBounds(0, 0, 734, 280);
		}
		return sickScrollPanel;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setHeading("Sub Disease List");
			ListPanel.setBounds(new Rectangle(15, 140, 734, 280));
			ListPanel.add(getSickScrollPane());
		}
		return ListPanel;
	}
}