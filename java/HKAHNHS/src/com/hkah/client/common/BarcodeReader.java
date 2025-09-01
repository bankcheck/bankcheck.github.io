package com.hkah.client.common;

import com.extjs.gxt.ui.client.event.BoxComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.hkah.client.tx.MasterPanel;

public class BarcodeReader {
	private MasterPanel owner = null;
	private final static int KEY_INSERT = 45;
	private int inserCnt = 0;
	private StringBuffer sb = new StringBuffer();

	public BarcodeReader(MasterPanel owner) {
		this.owner = owner;
		init();
	}

	private void init() {
		inserCnt = 0;
		sb.setLength(0);

		if (owner != null) {
			owner.addListener(Events.OnKeyPress, new Listener<BoxComponentEvent>() {
				@Override
				public void handleEvent(BoxComponentEvent be) {
					// TODO Auto-generated method stub
					//System.err.println("KeyCode: "+be.getKeyCode());
					if (inserCnt >= 2) {
						if (be.getKeyCode() == 13) {
							be.cancelBubble();
						}

						focus();

						//System.err.println("Char: "+(char)be.getKeyCode());
						sb.append((char)be.getKeyCode());
					}

					//System.err.println("Value: "+sb.toString());
				}
			});

			owner.addListener(Events.OnKeyDown, new Listener<BoxComponentEvent>() {
				@Override
				public void handleEvent(BoxComponentEvent be) {
					// TODO Auto-generated method stub
					//System.err.println("KeyCode: "+be.getKeyCode());
					if (be.getKeyCode() == KEY_INSERT) {
						inserCnt++;
					} else if (be.getKeyCode() == 13) {
						afterScan(sb.toString());
						reset();
					} else {
						if (inserCnt == 1 && sb.length() == 0) {
							reset();
						}
					}

					if (inserCnt == 2) {
						focus();
					}
					
					//System.err.println("Value: "+sb.toString());
				}
			});
		}
	}

	protected void focus() {
		
	}
	
	protected void afterScan(String value) {
	}

	public void reset() {
		inserCnt = 0;
		sb.setLength(0);
	}

	protected boolean checkPrefix(String prefix, String value) {
		return value.toUpperCase().startsWith(prefix.toUpperCase());
	}

	protected String getValue(String prefix, String value) {
		return value.toUpperCase().substring(prefix.toUpperCase().length(), value.length());
	}
}