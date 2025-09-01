/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboOTTmpType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ot.OTLogBook;
import com.hkah.client.util.FileUtil;
import com.hkah.shared.model.MessageQueue;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgOTTemplate extends DialogBase {

    private final static int m_frameWidth = 550;
    private final static int m_frameHeight = 340;

	private BasePanel dialogTopPanel = null;
	private LabelBase tmpTypeDesc = null;
	private ComboOTTmpType oTTmpType = null;
	private TableList tmpNameListTable = null;
	private JScrollPane tmpNameScrollPane = null;
	private LabelBase rptDescDesc = null;
	private TextString rptDesc = null;
	private OTLogBook oTLogBook = null;
	private String tPath = null;
	public static String TMP_FILE_EXT = "doc";
	public static String TMP_VAL_GENERAL = "0";
	public static String TMP_SUBKEY_GENERAL = "\\General";

	public DlgOTTemplate(MainFrame owner, OTLogBook oTLogBook) {
        super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
        this.oTLogBook = oTLogBook;
        initialize();
	}

	public String getTPath() {
		return tPath;
	}

	public void setTPath(String tPath) {
		this.tPath = tPath;
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Selecting OT Dr. Procedure Template");

		// change label
		getButtonById(OK).setText("Select");

		setContentPane(getDialogTopPanel());
		addListener(Events.Hide, new Listener<BaseEvent>() {
			@Override
			public void handleEvent(BaseEvent be) {
				dlgClose();
			}
		});
	}

	private void showTemplate(String subKey) {
		if (TMP_VAL_GENERAL.equals(subKey)) {
			subKey = TMP_SUBKEY_GENERAL;
		}
		
		FileUtil.listFile(getTPath() + "\\" + subKey, new String[]{TMP_FILE_EXT}, false,
				new AsyncCallback<Map<String, String>>() {
			@Override
			public void onSuccess(Map<String, String> result) {
				getTmpNameListTable().removeAllRow();
				Iterator<String> itr = result.keySet().iterator();
				while (itr.hasNext()) {
					String fullPath = itr.next();
					getTmpNameListTable().addRow(new String[]{result.get(fullPath), fullPath});
				}
			}

			@Override
			public void onFailure(Throwable caught) {
				getTmpNameListTable().removeAllRow();
			}
		});
	}

	public void resetTmpTypeList() {
		List<String> docs = new ArrayList<String>();
		if (oTLogBook != null) {
			docs.add(oTLogBook.getPrimarySur().getText());
			for (int i = 0; i < oTLogBook.getSecSurTable().getRowCount(); i++) {
				docs.add(oTLogBook.getSecSurTable().getRowContent(i)[4]);
			}
		}
		getOTTmpType().initContent(docs.toArray(new String[docs.size()]));
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		if (getRptDesc().getText().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input report description.");
			return;
		}

		if (getTmpNameListTable().getSelectedRow() < 0) {
			Factory.getInstance().addErrorMessage("Please select a template.");
			return;
		}

		super.doOkAction();
		post();
	}

	protected void post() {
		// for child class implement
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(MessageQueue mQueue) {
		getTmpNameListTable().setListTableContent(mQueue);
		setVisible(true);
		getButtonById(OK).focus();
	}

	protected void dlgClose() {};

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 345, 540);
			dialogTopPanel.add(getTmpTypeDesc(), null);
			dialogTopPanel.add(getOTTmpType(), null);
			dialogTopPanel.add(getTmpNameScrollPane(), null);
			dialogTopPanel.add(getRptDescDesc(), null);
			dialogTopPanel.add(getRptDesc(), null);

		}
		return dialogTopPanel;
	}

	public LabelBase getTmpTypeDesc() {
		if (tmpTypeDesc == null) {
			tmpTypeDesc = new LabelBase();
			tmpTypeDesc.setText("Template Type");
			tmpTypeDesc.setBounds(10, 5, 120, 20);
		}
		return tmpTypeDesc;
	}

	public ComboOTTmpType getOTTmpType() {
		if (oTTmpType == null) {
			oTTmpType = new ComboOTTmpType() {
				@Override
				protected void resetContentPost() {
					super.resetContentPost();
					if (getKeySize() > 0) {
						setSelectedIndex(0);
						showTemplate(getText());
					}
				}

				@Override
				public void onSelected() {
					showTemplate(getText());
				};
			};
			oTTmpType.setBounds(130, 5, 380, 20);
		}
		return oTTmpType;
	}

	public TableList getTmpNameListTable() {
		if (tmpNameListTable == null) {
			tmpNameListTable = new TableList(getTmpNameColumnNames(), getTmpNameColumnWidths());
		}
		return tmpNameListTable;
	}

	public JScrollPane getTmpNameScrollPane() {
		if (tmpNameScrollPane == null) {
			tmpNameScrollPane = new JScrollPane();
			tmpNameScrollPane.setBounds(5, 35, 505, 175);
			tmpNameScrollPane.setViewportView(getTmpNameListTable());
		}
		return tmpNameScrollPane;
	}

	private int[] getTmpNameColumnWidths() {
		return new int[] { 500, 0 };
	}

	private String[] getTmpNameColumnNames() {
		return new String[] { "Template Name", "FULL_PATH" };
	}

	public LabelBase getRptDescDesc() {
		if (rptDescDesc == null) {
			rptDescDesc = new LabelBase();
			rptDescDesc.setText("Report Description");
			rptDescDesc.setBounds(10, 220, 120, 20);
		}
		return rptDescDesc;
	}

	public TextString getRptDesc() {
		if (rptDesc == null) {
			rptDesc = new TextString();
			rptDesc.setBounds(130, 220, 380, 20);
		}
		return rptDesc;
	}
}