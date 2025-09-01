package com.hkah.client.layout.combobox;

public class ComboARCardColour extends ComboBoxBase {
	private final static String BLACK_DISPLAY = "Black";
	private final static String BLUE_DISPLAY = "Blue";
	private final static String GOLD_DISPLAY = "Gold";
	private final static String GREEN_DISPLAY = "Green";
	private final static String GREY_DISPLAY = "Grey";
	private final static String ORANGE_DISPLAY = "Orange";
	private final static String PASTEL_BLUE_DISPLAY = "Pastel Blue";
	private final static String RED_DISPLAY = "Red";
	private final static String SILVER_DISPLAY = "Silver";
	private final static String WHITE_DISPLAY = "White";
	private final static String YELLOW_DISPLAY = "Yellow";
	
	private final static String BLACK_VALUE = "Black";
	private final static String BLUE_VALUE = "Blue";
	private final static String GOLD_VALUE = "Gold";
	private final static String GREEN_VALUE = "Green";
	private final static String GREY_VALUE = "Grey";
	private final static String ORANGE_VALUE = "Orange";
	private final static String PASTEL_BLUE_VALUE = "Pastel Blue";
	private final static String RED_VALUE = "Red";
	private final static String SILVER_VALUE = "Silver";
	private final static String WHITE_VALUE = "White";
	private final static String YELLOW_VALUE = "Yellow";
	
	public ComboARCardColour() {
		super();
		setMinListWidth(200);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(BLACK_DISPLAY, BLACK_VALUE);
		addItem(BLUE_DISPLAY, BLUE_VALUE);
		addItem(GOLD_DISPLAY, GOLD_VALUE);
		addItem(GREEN_DISPLAY, GREEN_VALUE);
		addItem(GREY_DISPLAY, GREY_VALUE);
		addItem(ORANGE_DISPLAY, ORANGE_VALUE);
		addItem(PASTEL_BLUE_DISPLAY, PASTEL_BLUE_VALUE);
		addItem(RED_DISPLAY, RED_VALUE);
		addItem(SILVER_DISPLAY, SILVER_VALUE);
		addItem(WHITE_DISPLAY, WHITE_VALUE);
		addItem(YELLOW_DISPLAY, YELLOW_VALUE);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
	}
}
