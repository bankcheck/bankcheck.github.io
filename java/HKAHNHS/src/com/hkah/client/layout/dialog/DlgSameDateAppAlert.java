/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.ContentPanel;
import com.google.gwt.user.client.Window;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.client.common.Factory;
import com.hkah.shared.constants.ConstantsTx;
/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgSameDateAppAlert extends DialogBase {

    private final static int m_frameWidth = 700;
    private final static int m_frameHeight = 410;

	private final static String OK_COMMAND = "OK";
	private final static String CANCEL_COMMAND = "Cancel";

	private BasePanel dialogTopPanel = null;
	private BasePanel dialogBtmPanel = null;
	private BasePanel ContentPanel = null;
	private ButtonBase ButtonBase_Ok = null;
	private ButtonBase ButtonBase_Cancel = null;
	private LabelBase Label_PatNo1 = null;
	private LabelBase Label_PatNo2 = null;	
	private LabelBase Label_PatName1 = null;
	private LabelBase Label_PatName2 = null;	
	private LabelBase Label_DocName1 = null;
	private LabelBase Label_DocName2 = null;	
	private LabelBase Label_AppTime1 = null;
	private LabelBase Label_AppTime2 = null;	
	private LabelBase Label_DocLoc1 = null;	
	private LabelBase Label_DocLoc2 = null;	

	private String memPatno = null;
	private String memDocName = null;
	private String memPatName = null;	
	private String memAppTime = null;
	private String memDocLoc = null;	
	private BufferedTableList appListTable = null;
	private JScrollPane appListScrollPane = null;
	

	public DlgSameDateAppAlert(MainFrame owner) {
        super(owner, null, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Same date Appointment");

		getContentPane().add(getDialogTopPanel());
		getContentPane().add(getDialogBtmPanel());		
		setClosable(false);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/
	
	public void showDialog(String patno, String bkgDate) {		
		getAppListTable().removeAllRow();
		QueryUtil.executeMasterBrowse(getUserInfo(), "SHOWSAMEDTAPP",
				new String[] { patno,bkgDate },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getAppListTable().setListTableContent(mQueue);
					setVisible(true);
				}else{
					setVisible(false);
				}
			}
		});
	}
	
	public void showDialog(String patno, String patName, String docName, String appTime,
			String docLoc, boolean okOnly) {
		memDocName = docName;
		memPatno = patno;
        memPatName = patName;
        memAppTime = appTime;
        memDocLoc = docLoc;
 
		Label_PatNo2.setText(memPatno);		
		Label_PatName2.setText(memPatName);
		Label_DocName2.setText(memDocName);		
		Label_AppTime2.setText(memAppTime);
		Label_DocLoc2.setText(memDocLoc);		
		setVisible(true);	
	}

	public void post(String source, String actCode, String actId) {}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setEtchedBorder();
			dialogTopPanel.setBounds(6, 8, 655, 300);		
			dialogTopPanel.add(getContentPanel(), null);			
/*			
			dialogTopPanel.add(getLabel_PatNo1(), null);
			dialogTopPanel.add(getLabel_PatNo2(), null);			
			dialogTopPanel.add(getLabel_PatName1(), null);
			dialogTopPanel.add(getLabel_PatName2(), null);			
			dialogTopPanel.add(getLabel_DocName1(), null);
			dialogTopPanel.add(getLabel_DocName2(), null);			
			dialogTopPanel.add(getLabel_AppTime1(), null);
			dialogTopPanel.add(getLabel_AppTime2(), null);			
			dialogTopPanel.add(getLabel_DocLoc1(), null);			
			dialogTopPanel.add(getLabel_DocLoc2(), null);
*/
		}
		return dialogTopPanel;
	}

	public BasePanel getDialogBtmPanel() {
		if (dialogBtmPanel == null) {
			dialogBtmPanel = new BasePanel();
			dialogBtmPanel.setEtchedBorder();
			dialogBtmPanel.setBounds(6, 10, 655, 50);
			dialogBtmPanel.add(getButtonBase_Ok(), null);
		}
		return dialogBtmPanel;
	}
	
	private JScrollPane getAppListScrollPane() {
		if (appListScrollPane == null) {
			appListScrollPane = new JScrollPane();
			appListScrollPane.setBounds(5, 5, 640, 290);
			appListScrollPane.setViewportView(getAppListTable());
		}
		return appListScrollPane;
	}	
	
	protected BufferedTableList getAppListTable() {
		if (appListTable == null) {
			appListTable = new BufferedTableList(getAppListColumnNames(), getAppListColumnWidths());
		}
		return appListTable;
	}

	private int[] getAppListColumnWidths() {
		return new int[] {
				0,
				70,
				110,
				80,
				80,
				80,
				110,
				80
		};
	}

	private String[] getAppListColumnNames() {
		return new String[] {
				EMPTY_VALUE,
				"Doctor Code",
				"Doctor Name",
				"App. Date",
				"App. Time",
				"Patient NO.",
				"Patinet Name",
				"Location"
		};
	}		

	public LabelBase getLabel_PatNo1() {
		if (Label_PatNo1 == null) {
			Label_PatNo1 = new LabelBase();
			Label_PatNo1.setText("Patient NO.:");
			Label_PatNo1.setBounds(5, 5, 100, 20);
		}
		return Label_PatNo1;
	}
	
	public LabelBase getLabel_PatNo2() {
		if (Label_PatNo2 == null) {
			Label_PatNo2 = new LabelBase();
			Label_PatNo2.setText("");
			Label_PatNo2.setBounds(105, 5, 250, 20);
		}
		return Label_PatNo2;
	}	
	
	public LabelBase getLabel_PatName1() {
		if (Label_PatName1 == null) {
			Label_PatName1 = new LabelBase();
			Label_PatName1.setText("Patient Name:");
			Label_PatName1.setBounds(5, 30, 100, 20);
		}
		return Label_PatName1;
	}
	
	public LabelBase getLabel_PatName2() {
		if (Label_PatName2 == null) {
			Label_PatName2 = new LabelBase();
			Label_PatName2.setText("");
			Label_PatName2.setBounds(105, 30, 250, 20);
		}
		return Label_PatName2;
	}	
	
	public LabelBase getLabel_DocName1() {
		if (Label_DocName1 == null) {
			Label_DocName1 = new LabelBase();
			Label_DocName1.setText("Doctor Name:");
			Label_DocName1.setBounds(5, 55, 100, 40);
		}
		return Label_DocName1;
	}
	
	public LabelBase getLabel_DocName2() {
		if (Label_DocName2 == null) {
			Label_DocName2 = new LabelBase();
			Label_DocName2.setText("");
			Label_DocName2.setBounds(105, 55, 250, 40);
		}
		return Label_DocName2;
	}	
	
	public LabelBase getLabel_AppTime1() {
		if (Label_AppTime1 == null) {
			Label_AppTime1 = new LabelBase();
			Label_AppTime1.setText("Appointment Time:");
			Label_AppTime1.setBounds(5, 100, 100, 20);
		}
		return Label_AppTime1;
	}
	
	public LabelBase getLabel_AppTime2() {
		if (Label_AppTime2 == null) {
			Label_AppTime2 = new LabelBase();
			Label_AppTime2.setText("");
			Label_AppTime2.setBounds(105, 100, 250, 20);
		}
		return Label_AppTime2;
	}	
	
	public LabelBase getLabel_DocLoc1() {
		if (Label_DocLoc1 == null) {
			Label_DocLoc1 = new LabelBase();
			Label_DocLoc1.setText("Location:");
			Label_DocLoc1.setBounds(5, 125, 100, 20);
		}
		return Label_DocLoc1;
	}
	
	public LabelBase getLabel_DocLoc2() {
		if (Label_DocLoc2 == null) {
			Label_DocLoc2 = new LabelBase();
			Label_DocLoc2.setText("");
			Label_DocLoc2.setBounds(105, 125, 250, 20);
		}
		return Label_DocLoc2;
	}	

	public BasePanel getContentPanel() {
		if (ContentPanel == null) {
			ContentPanel = new BasePanel();
			ContentPanel.add(getAppListScrollPane(), null);
		}
		return ContentPanel;
	}

	public ButtonBase getButtonBase_Ok() {
		if (ButtonBase_Ok == null) {
			ButtonBase_Ok = new ButtonBase() {
				@Override
				public void onClick() {
					dispose();
				}
			};
			ButtonBase_Ok.setText(OK_COMMAND);
			ButtonBase_Ok.setBounds(255, 15, 80, 20);

		}
		return ButtonBase_Ok;
	}

	public ButtonBase getButtonBase_Cancel() {
		if (ButtonBase_Cancel == null) {
			ButtonBase_Cancel = new ButtonBase();
			ButtonBase_Cancel.setText(CANCEL_COMMAND);
			ButtonBase_Cancel.setBounds(180, 11, 80, 20);
		}
		return ButtonBase_Cancel;
	}


	/**
	* Opens a new windows with a specified URL..
	*
	* @param name String with the name of the window.
	* @param url String with your URL.
	*/
	public static void openNewWindow(String url) {
		Window.open(url, "_blank", null);
	}

	public DlgSameDateAppAlert getThis() {
		return this;
	}
}