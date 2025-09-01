package com.hkah.client;

/**
 * Entry point classes define <code>onModuleLoad()</code>.
 */
public class MainFrame extends MainFrameBase {

	protected String m_title = null;

	@Override
	protected MainFrame getMainFrame() {
		return this;
	}

	@Override
	protected String getTitle() {
		// return project title
		return null;
	}
}