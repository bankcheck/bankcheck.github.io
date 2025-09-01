package com.hkah.client;

import com.extjs.gxt.ui.client.Style.LayoutRegion;
import com.extjs.gxt.ui.client.widget.Viewport;
import com.extjs.gxt.ui.client.widget.layout.BorderLayout;
import com.extjs.gxt.ui.client.widget.layout.BorderLayoutData;
import com.extjs.gxt.ui.client.widget.menu.MenuBar;
import com.google.gwt.user.client.Window.Location;
import com.google.gwt.user.client.ui.RootPanel;
import com.hkah.client.common.Factory;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.registration.OBBook;
import com.hkah.client.tx.registration.Patient;
import com.hkah.client.tx.schedule.AppointmentBrowse;
import com.hkah.client.tx.schedule.DoctorAppointment;
import com.hkah.client.tx.transaction.TransactionSearch;

/**
 * Entry point classes define <code>onModuleLoad()</code>.
 */
//public class MainFrame extends Window implements ConstantsVariable {
public class SinglePanel extends MainFrame {

	@Override
	public void loadModule() {
		super.loadModule();

		String moduleCode = Location.getParameter("moduleCode");
		Factory.getInstance().getValueObjectPerPanel().put("PS_PatNo", Location.getParameter("patno"));
		MasterPanel panel = null;
		if ("doctor.appointment".equals(moduleCode)) {
			panel = new DoctorAppointment();
		} else if ("appointment.browse".equals(moduleCode)) {
			panel = new AppointmentBrowse();
		} else if ("transaction.search".equals(moduleCode)) {
			panel = new TransactionSearch();
		} else if ("patient".equals(moduleCode)) {
			panel = new Patient();
		} else if ("obbooking".equals(moduleCode)) {
			panel = new OBBook();
		}
		if (panel != null) {
			panel.disableCloseButton();
			Factory.getInstance().showPanel(this, panel, false,false);
		}
	}

	protected void initComponent() {
		Viewport viewport = new Viewport();
		final BorderLayout borderLayout = new BorderLayout();
		viewport.setLayout(borderLayout);

		BorderLayoutData mainContentsLayoutData = new BorderLayoutData(LayoutRegion.CENTER);
		mainContentsLayoutData.setCollapsible(false);
		mainContentsLayoutData.setFloatable(true);
		viewport.add(getBodyPanel(), mainContentsLayoutData);

		RootPanel.get().add(viewport);
	}

	public MenuBar getMenuBar() {
		if (menuBar == null) {
			menuBar = new MenuBar();
		}
		return menuBar;
	}
}