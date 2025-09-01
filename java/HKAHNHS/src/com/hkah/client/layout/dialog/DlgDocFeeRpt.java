/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.services.ReportServiceAsync;
import com.hkah.client.util.DownloadUtil;
import com.hkah.shared.model.MessageQueue;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgDocFeeRpt extends DialogBase {

    private final static int m_frameWidth = 550;
    private final static int m_frameHeight = 340;

	private BasePanel dialogTopPanel = null;
	private LabelBase fileExtDesc = null;
	private TextString fileExt = null;
	private TableList docFeeRptListTable = null;
	private JScrollPane docFeeRptScrollPane = null;
	private String tPath = null;
	
	public static String FILE_TYPE = "Adobe PDF";
	public static String TMP_FILE_EXT = "pdf";

	public DlgDocFeeRpt(MainFrame owner) {
        super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
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
		setTitle("Open Doctor Fee Reports");

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

	public void getFileListContent(String path) {
		Factory.getInstance().showMask();
		((ReportServiceAsync) Registry
				.get(AbstractEntryPoint.REPORT_SERVICE)).getDocFeeRptList(
						path, new String[]{TMP_FILE_EXT}, new AsyncCallback<MessageQueue>() {
							@Override
							public void onSuccess(MessageQueue result) {
								if (result.success()) {
									getFileListContentPost(result);
								} else {
									Factory.getInstance().addErrorMessage(
											"Fail to load doctor fee report list:<br />" + result.getReturnMsg());
								}
								Factory.getInstance().hideMask();
							}

							@Override
							public void onFailure(Throwable caught) {
								Factory.getInstance().addErrorMessage(
										"Error loading doctor fee report list.");
								Factory.getInstance().hideMask();
							}
						 });
		
	}
	
	private void getFileListContentPost(MessageQueue mq) {
		getDocFeeRptListTable().setListTableContent(mq);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		openReport();
		//post();
	}

	protected void post() {
		// for child class implement
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String path) {
		getFileListContent(path);
		//getDocFeeRptListTable().setListTableContent(mQueue);
		setVisible(true);
		getButtonById(OK).focus();
	}

	protected void dlgClose() {};

	private void openReport() {
		if (getDocFeeRptListTable().getSelectedRow() < 0) {
			Factory.getInstance().addErrorMessage("Please select a report.");
			return;
		}
		DownloadUtil.download(false, getDocFeeRptListTable().getSelectedRowContent()[3], null,
				"fullscreen=yes,resizable=yes,location=no"
				);
	}
	
	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 345, 540);
			dialogTopPanel.add(getTmpTypeDesc(), null);
			dialogTopPanel.add(getFileExt(), null);
			dialogTopPanel.add(getDocFeeRptScrollPane(), null);

		}
		return dialogTopPanel;
	}

	public LabelBase getTmpTypeDesc() {
		if (fileExtDesc == null) {
			fileExtDesc = new LabelBase();
			fileExtDesc.setText("Report File Type");
			fileExtDesc.setBounds(10, 5, 120, 20);
		}
		return fileExtDesc;
	}
	
	public TextString getFileExt() {
		if (fileExt == null) {
			fileExt = new TextString(false);
			fileExt.setValue(FILE_TYPE);
			fileExt.setBounds(160, 5, 100, 20);
			fileExt.setReadOnly(true);
		}
		return fileExt;
	}

	public TableList getDocFeeRptListTable() {
		if (docFeeRptListTable == null) {
			docFeeRptListTable = new TableList(getTmpNameColumnNames(), getTmpNameColumnWidths()) {
				@Override
				public void doubleClick() {
					openReport();
				};
			};
		}
		return docFeeRptListTable;
	}

	public JScrollPane getDocFeeRptScrollPane() {
		if (docFeeRptScrollPane == null) {
			docFeeRptScrollPane = new JScrollPane();
			docFeeRptScrollPane.setBounds(5, 35, 505, 175);
			docFeeRptScrollPane.setViewportView(getDocFeeRptListTable());
		}
		return docFeeRptScrollPane;
	}

	private int[] getTmpNameColumnWidths() {
		return new int[] { 300, 100, 100, 0 };
	}

	private String[] getTmpNameColumnNames() {
		return new String[] { "File", "Create Date", "Size", "FILE_PATH" };
	}
}