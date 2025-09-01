
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Java class for pmiPatientLogDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="pmiPatientLogDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ehrNo" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="eventCode" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="action" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="trxDtm" type="{http://www.w3.org/2001/XMLSchema}dateTime"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "pmiPatientLogDTO", propOrder = {
    "ehrNo",
    "eventCode",
    "action",
    "trxDtm"
})
public class PmiPatientLogDTO {

    @XmlElement(required = true)
    protected String ehrNo;
    @XmlElement(required = true)
    protected String eventCode;
    protected String action;
    @XmlElement(required = true)
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar trxDtm;

    /**
     * Gets the value of the ehrNo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEhrNo() {
        return ehrNo;
    }

    /**
     * Sets the value of the ehrNo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEhrNo(String value) {
        this.ehrNo = value;
    }

    /**
     * Gets the value of the eventCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEventCode() {
        return eventCode;
    }

    /**
     * Sets the value of the eventCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEventCode(String value) {
        this.eventCode = value;
    }

    /**
     * Gets the value of the action property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAction() {
        return action;
    }

    /**
     * Sets the value of the action property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAction(String value) {
        this.action = value;
    }

    /**
     * Gets the value of the trxDtm property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getTrxDtm() {
        return trxDtm;
    }

    /**
     * Sets the value of the trxDtm property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setTrxDtm(XMLGregorianCalendar value) {
        this.trxDtm = value;
    }

}
