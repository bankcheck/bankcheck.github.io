package com.hkah.client.layout;

import com.extjs.gxt.ui.client.Style;
import com.extjs.gxt.ui.client.widget.ProgressBar;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.ui.RootPanel;

public class ContinousProgressBar extends ProgressBar {
	private boolean stopProgress = true;
	private Timer timer = null;

	public ContinousProgressBar() {
		setBounds(10, 10, 200, Style.DEFAULT);
		timer = new Timer() {
			int counter = 0;

			@Override
			public void run() {
				if (stopProgress) {
					RootPanel.get("loading").setVisible(false);
					updateProgress(0.0, "  ");
					counter = 0;
					return;
				}

				if (counter == 10) {
					counter = 0;
				}

				counter++;
				updateProgress(counter / 10.0, "  ");
				this.schedule(100);
			}
		};
	}

	public void start() {
		if (stopProgress) {
			RootPanel.get("loading").setVisible(true);
			updateProgress(0.0, "  ");
			timer.schedule(100);
			stopProgress = false;
		}
	}
	
	
	public void start(String text) {
		if (stopProgress) {
            DOM.setInnerText(RootPanel.get("systemname").getElement(), text);
			RootPanel.get("loading").setVisible(true);
			updateProgress(0.0, text);
			timer.schedule(100);
			stopProgress = false;
		}
	}	

	public void stop() {
		stopProgress = true;
	}
}