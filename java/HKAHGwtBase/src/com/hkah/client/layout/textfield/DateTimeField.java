package com.hkah.client.layout.textfield;

import java.util.Date;

import com.extjs.gxt.ui.client.widget.form.DateField;
import com.extjs.gxt.ui.client.widget.form.MultiField;
import com.extjs.gxt.ui.client.widget.form.Time;
import com.extjs.gxt.ui.client.widget.form.TimeField;
import com.hkah.client.util.DateTimeUtil;

public class DateTimeField extends MultiField<Date> {
    private final TimeField timeField;
    private final DateField dateField;
    
    public final static int DATE_FIELD_WIDTH = 100;
    public final static int TIME_FIELD_WIDTH = 60;
    
    public DateTimeField() {
    	this(DATE_FIELD_WIDTH, TIME_FIELD_WIDTH);
    }

    public DateTimeField(int dateFieldWidth, int timeFieldWidth) {
        super();    
        dateField = new TextDate();
        dateField.setWidth(dateFieldWidth);
        add(dateField);
        timeField = new TimeField();
        timeField.setWidth(timeFieldWidth);
        add(timeField);
    }
    
	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
	    setSize(width, height);
	}
    
    @Override
    public Date getValue() {
        Date result = dateField.getValue();
        if (result == null) {
            return null;
        }
        return new Date(result.getTime() + 
        		timeField.getValue().getDate().getTime());
    }
    
    public String getText() {
        String ret = "00/00/0000 00:00";
        try {
        	Date date = dateField.getValue();
        	Date time = timeField.getValue().getDate();
        	
        	date.setHours(time.getHours());
        	date.setMinutes(time.getMinutes());
        	date.setSeconds(time.getSeconds());
        	
	        ret = DateTimeUtil.formatDateTimeWithoutSecond(date);
        } catch (Exception ex) {
        }
        
        return ret;
    }


    @Override
    public void setValue(Date value) {
    	if (value == null) {
    		dateField.setValue(null);
    		timeField.setValue(null);
    	} else {
	        dateField.setValue(
	        		new Date(value.getYear(), value.getMonth(), value.getDate()));
	        timeField.setValue(
	        		new Time(value.getHours(), value.getMinutes()));
    	}
    }
}
