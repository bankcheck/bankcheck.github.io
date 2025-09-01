package com.hkah.client.layout.textfield;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.extjs.gxt.ui.client.GXT;
import com.extjs.gxt.ui.client.util.DateWrapper;
import com.extjs.gxt.ui.client.util.Format;
import com.extjs.gxt.ui.client.widget.form.DateTimePropertyEditor;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.shared.constants.ConstantsVariable;

public class TextDateTime extends TextDate {
	private final static String FORMAT_DISPLAY_DATE = "dd/MM/yyyy";
	private final static String FORMAT_DISPLAY_DATETIME_WITHOUT_SECOND = "dd/MM/yyyy HH:mm";
	private final static String FORMAT_DISPLAY_DATETIME = "dd/MM/yyyy HH:mm:ss";
	
	private boolean allowMultiDatePatterns = false;
	private List<DateTimePropertyEditor> propertyEditors = new ArrayList<DateTimePropertyEditor>();
	private boolean showTime = false;
	private boolean autoTrimBeforeValidate = true;
	
	public TextDateTime() {
		this(false);
	}
	
	public TextDateTime(boolean allowMultiDatePatterns) {
		this(allowMultiDatePatterns, false);
	}
	
	public TextDateTime(boolean allowMultiDatePatterns, boolean showTime) {
		super();
		this.allowMultiDatePatterns = allowMultiDatePatterns;
		this.showTime = showTime;
		if (allowMultiDatePatterns) {
			initPropertyEditors();
		}
	}
	
	public TextDateTime(boolean allowMultiDatePatterns, boolean showTime, TableList table, int column) {
		super(table, column);
		this.allowMultiDatePatterns = allowMultiDatePatterns;
		this.showTime = showTime;
		if (allowMultiDatePatterns) {
			initPropertyEditors();
		}
	}

	public TextDateTime(TableList table, int column) {
		super(table, column);
	}
	
	public boolean isAutoTrimBeforeValidate() {
		return autoTrimBeforeValidate;
	}

	public void setAutoTrimBeforeValidate(boolean autoTrimBeforeValidate) {
		this.autoTrimBeforeValidate = autoTrimBeforeValidate;
	}

	/* >>> support both (1)date, (2)date time w/o sec and (3)date time patterns ================= <<< */
	private void initPropertyEditors() {
		if (allowMultiDatePatterns) {
			if (getStringLength() > 0) setMaxLength(getStringLength());
			getPropertyEditor().setFormat(DateTimeFormat.getFormat(getDateTimePattern()));
			setPropertyEditor(new DateTimePropertyEditor(getDateTimePattern()));
			this.setMaxLength(50);
			
			String invalidTextPattern = "";
			for (String p : getDateTimePatterns()) {
				DateTimePropertyEditor dtpe = new DateTimePropertyEditor(p);
				propertyEditors.add(dtpe);
				
				DateTimeFormat format = dtpe.getFormat();
				if(!invalidTextPattern.isEmpty()) {
					invalidTextPattern += " or ";
				}
				invalidTextPattern += format.getPattern().toUpperCase();
				
			}
			getMessages().setInvalidText("{0} is not a valid date - it must be in the format of " + invalidTextPattern);
		} else {
			
		}
	}
	
	public boolean isAllowMultiDatePatterns() {
		return allowMultiDatePatterns;
	}

	public List<DateTimePropertyEditor> getPropertyEditors() {
		return propertyEditors;
	}
	
	protected String[] getDateTimePatterns() {
		return new String[]{FORMAT_DISPLAY_DATE, FORMAT_DISPLAY_DATETIME_WITHOUT_SECOND, FORMAT_DISPLAY_DATETIME};
	}

	@Override
	protected String getDateTimePattern() {
		if (allowMultiDatePatterns && !showTime) {
			return FORMAT_DISPLAY_DATE;
		} else {
			return FORMAT_DISPLAY_DATETIME;
		}
	}
	
	@Override
	protected int getStringLength() {
		if (allowMultiDatePatterns) {
			int ret = -1;
			int rawLen = getRawValue().trim().length();
			for (int i = 0; i < getDateTimePatterns().length; i++) {
				if (rawLen == getDateTimePatterns()[i].length()) {
					ret = rawLen;
				}
			}
			if (ret < 0) {
				ret = FORMAT_DISPLAY_DATETIME.length();
			}
			return ret;
		} else {
			return super.getStringLength();
		}
	}
	
	@Override
	public boolean isValid() {
		if (allowMultiDatePatterns) {
			if (super.isValid() && getRawValue().trim().length() == getStringLength()) {
				return parseDate(getRawValue()) != null;
			} else {
				return false;
			}
		} else {
			return super.isValid();
		}
	}
	
	@Override
	protected Date parseDate(String dateStr) {
		if (allowMultiDatePatterns) {
			try {
				for (String p : getDateTimePatterns()) {
					try {
						return DateTimeFormat.getFormat(p).parse(dateStr);
					} catch (Exception ex) {
					}
				}
			} catch (Exception ex) {
			}
			return null;
		} else {
			return super.parseDate(dateStr);
		}
	}
	
	@Override
	public void setText(String value) {
		if (value != null) {
			String datetime = value;
			// without hour, minute and second
			if (DateTimeUtil.isDate(datetime)) {
				datetime = datetime + " 00:00:00";
			} else if (DateTimeUtil.isDateTimeWithoutSecond(datetime)) {
				datetime = datetime + ":00";
			}
			selectedDate = null;
			super.setValue(parseDate(datetime));
		} else {
			super.setValue(null);
		}
	}
	
	@Override
	public String getText() {
		// based on Ext GWT 2.2.5 - Ext for GWT - Field.java
		if (!allowMultiDatePatterns) {
			return super.getText();
		} else {
			try {
				if (!rendered) {
			        return super.getText();
			    }
				String v = getRawValue();
				
				if (showTime) {
					if (DateTimeUtil.isDate(v)) {
						v = v + " 00:00:00";
					} else if (DateTimeUtil.isDateTimeWithoutSecond(v)) {
						v = v + ":00";
					}
				}
				
				if (emptyText != null && v.equals(emptyText)) {
					return ConstantsVariable.EMPTY_VALUE;
				}
				if (v == null || v.equals("")) {
					return ConstantsVariable.EMPTY_VALUE;
				}
				try {
					DateTimePropertyEditor dtpe = null;
					if (v.length() == 10) {
			    		dtpe = getPropertyEditors().get(0);
					} else if (v.length() == 16) {
			    		dtpe = getPropertyEditors().get(1);
			    	} else {
			    		dtpe = getPropertyEditors().get(2);
			    	}
					return dtpe.getFormat().format(dtpe.convertStringValue(v));
				} catch (Exception e) {
			    	  return ConstantsVariable.EMPTY_VALUE;
				}
			} catch (Exception e) {}
			return ConstantsVariable.EMPTY_VALUE;
		}
	}

	@Override
	protected boolean validateValue(String value) {
		if (autoTrimBeforeValidate) {
			value = value == null ? value : value.trim();
			setRawValue(getRawValue() == null ? getRawValue() : getRawValue().trim());
		}
		
		if (!allowMultiDatePatterns) {
			return super.validateValue(value);
		} else {
			
			// based on Ext GWT 2.2.5 - Ext for GWT - support mulitple date patterns
		    if (value.length() < 1) { // if it's blank and textfield didn't flag it then
		        // it's valid
		        return true;
		    }
	
		    boolean[] isInvalid = new boolean[propertyEditors.size()];
	    	Iterator<DateTimePropertyEditor> itr = propertyEditors.iterator();
	    	int i = 0;
	    	boolean isValid = false;
	    	String error = null;
		    while (itr.hasNext() && !isValid) {
		    	DateTimePropertyEditor dtpe = itr.next();
		    	
		    	if (dtpe != null) {
		    		DateTimeFormat format = dtpe.getFormat();
		    		
		    		Date date = null;
		    		
	    			try {
						  date = new DateWrapper(dtpe.convertStringValue(value)).resetTime().asDate();
						
						  if (getMinValue() != null && date.before(getMinValue())) {
						    //String error = null;
						    if (getMessages().getMinText() != null) {
						      error = Format.substitute(getMessages().getMinText(), format.format(getMinValue()));
						    } else {
						      error = GXT.MESSAGES.dateField_minText(format.format(getMinValue()));
						    }
						    isInvalid[i] = false;
						  }
						  if (getMaxValue() != null && date.after(getMaxValue())) {
						    if (getMessages().getMaxText() != null) {
						      error = Format.substitute(getMessages().getMaxText(), format.format(getMaxValue()));
						    } else {
						      error = GXT.MESSAGES.dateField_maxText(format.format(getMaxValue()));
						    }
						    isInvalid[i] = false;
						  }
						
						  if (isFormatValue() && getPropertyEditor().getFormat() != null) {
						    setRawValue(getPropertyEditor().getStringValue(date));
						  }
						  
						  isValid = true;
					} catch (Exception e) {
			    		if (getMessages().getInvalidText() != null) {
			    			error = Format.substitute(getMessages().getInvalidText(), value, format.getPattern().toUpperCase());
				        } else {
				        	error = GXT.MESSAGES.dateField_invalidText(value, format.getPattern().toUpperCase());
				        }
				        
				        isInvalid[i] = false;
					}
		    	}
		    	i++;
		    }
		    
		    if (!isValid) {
			    markInvalid(error);
			    return false;
		    } else {
		    	return true;
		    }
		}
	}
}