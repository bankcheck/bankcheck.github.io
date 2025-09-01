/*
 * Created on February 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.tag;

import java.util.Iterator;
import java.util.Vector;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.hkah.web.tag.type.ComboBoxOption;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboBoxTag extends TagSupport {

	protected String property = null;
	protected Vector customContent = null;
	protected Vector options = null;

	protected String onblur = null;
	protected String onchange = null;
	protected String onclick = null;
	protected String ondbclick = null;
	protected String onfocus = null;
	protected String onkeydown = null;
	protected String onkeyup = null;
	protected String onmousedown = null;
	protected String onmouseup = null;

	protected String errorOption = null;

	public int doStartTag() throws JspException {
		try {
			JspWriter out = pageContext.getOut();

			out.print("<select name=\"" + property + "\"");

			if (onblur != null) {
				out.print(" onblur=\"" + onblur + "\"");
			}
			if (onchange != null) {
				out.print(" onchange=\"" + onchange + "\"");
			}
			if (onclick != null) {
				out.print(" onclick=\"" + onclick + "\"");
			}
			if (ondbclick != null) {
				out.print(" ondbclick=\"" + ondbclick + "\"");
			}
			if (onfocus != null) {
				out.print(" onfocus=\"" + onfocus + "\"");
			}
			if (onkeydown != null) {
				out.print(" onkeydown=\"" + onkeydown + "\"");
			}
			if (onkeyup != null) {
				out.print(" onkeyup=\"" + onkeyup + "\"");
			}
			if (onmousedown != null) {
				out.print(" onmousedown=\"" + onmousedown + "\"");
			}
			if (onmouseup != null) {
				out.print(" onmouseup=\"" + onmouseup + "\"");
			}

			out.println(">");

			if (customContent != null && customContent.size() > 0) {
				if (options == null)
					options = new Vector();
				options.addAll(0, customContent);
			}

			if (options != null && options.size() > 0) {
				Iterator iterator = options.iterator();
				while (iterator.hasNext()) {
					ComboBoxOption option = (ComboBoxOption) iterator.next();
					if (option.getValue() == null) {
						option.setValue(option.getText());
					}
					out.print("	<option value=\"" + option.getValue() + "\"");
					String selectedOption = this.pageContext.getRequest().getParameter(property);
					if (selectedOption != null
						&& selectedOption.equals(option.getValue())) {
						out.print(" selected=\"selected\"");
					}
					out.println(">" + option.getText() + "</option>");
				}
			}
			out.println("</select>");

		} catch (Exception ex) {
			throw new JspException("IO problems");
		}

		return SKIP_BODY;
	}

	/**
	 * @return customContent
	 */
	public Vector getCustomContent() {
		return customContent;
	}

	/**
	 * @param customContent 的設定的 customContent
	 */
	public void setCustomContent(Vector customContent) {
		this.customContent = customContent;
	}

	/**
	 * @return errorOption
	 */
	public String getErrorOption() {
		return errorOption;
	}

	/**
	 * @param errorOption 的設定的 errorOption
	 */
	public void setErrorOption(String errorOption) {
		this.errorOption = errorOption;
	}

	/**
	 * @return onblur
	 */
	public String getOnblur() {
		return onblur;
	}

	/**
	 * @param onblur 的設定的 onblur
	 */
	public void setOnblur(String onblur) {
		this.onblur = onblur;
	}

	/**
	 * @return onchange
	 */
	public String getOnchange() {
		return onchange;
	}

	/**
	 * @param onchange 的設定的 onchange
	 */
	public void setOnchange(String onchange) {
		this.onchange = onchange;
	}

	/**
	 * @return onclick
	 */
	public String getOnclick() {
		return onclick;
	}

	/**
	 * @param onclick 的設定的 onclick
	 */
	public void setOnclick(String onclick) {
		this.onclick = onclick;
	}

	/**
	 * @return ondbclick
	 */
	public String getOndbclick() {
		return ondbclick;
	}

	/**
	 * @param ondbclick 的設定的 ondbclick
	 */
	public void setOndbclick(String ondbclick) {
		this.ondbclick = ondbclick;
	}

	/**
	 * @return onfocus
	 */
	public String getOnfocus() {
		return onfocus;
	}

	/**
	 * @param onfocus 的設定的 onfocus
	 */
	public void setOnfocus(String onfocus) {
		this.onfocus = onfocus;
	}

	/**
	 * @return onkeydown
	 */
	public String getOnkeydown() {
		return onkeydown;
	}

	/**
	 * @param onkeydown 的設定的 onkeydown
	 */
	public void setOnkeydown(String onkeydown) {
		this.onkeydown = onkeydown;
	}

	/**
	 * @return onkeyup
	 */
	public String getOnkeyup() {
		return onkeyup;
	}

	/**
	 * @param onkeyup 的設定的 onkeyup
	 */
	public void setOnkeyup(String onkeyup) {
		this.onkeyup = onkeyup;
	}

	/**
	 * @return onmousedown
	 */
	public String getOnmousedown() {
		return onmousedown;
	}

	/**
	 * @param onmousedown 的設定的 onmousedown
	 */
	public void setOnmousedown(String onmousedown) {
		this.onmousedown = onmousedown;
	}

	/**
	 * @return onmouseup
	 */
	public String getOnmouseup() {
		return onmouseup;
	}

	/**
	 * @param onmouseup 的設定的 onmouseup
	 */
	public void setOnmouseup(String onmouseup) {
		this.onmouseup = onmouseup;
	}

	/**
	 * @return options
	 */
	public Vector getOptions() {
		return options;
	}

	/**
	 * @param options 的設定的 options
	 */
	public void setOptions(Vector options) {
		this.options = options;
	}

	/**
	 * @return property
	 */
	public String getProperty() {
		return property;
	}

	/**
	 * @param property 的設定的 property
	 */
	public void setProperty(String property) {
		this.property = property;
	}
}