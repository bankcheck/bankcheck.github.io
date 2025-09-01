
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for handlePatientAlert-request complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="handlePatientAlert-request"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="alertDTO" type="{http://ehr.gov.hk/alert/ws/beans}alertDTO"/&gt;
 *         &lt;element name="auditDTO" type="{http://ehr.gov.hk/alert/ws/beans}auditDTO"/&gt;
 *         &lt;element name="actionType" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "handlePatientAlert-request", propOrder = {
    "alertDTO",
    "auditDTO",
    "actionType"
})
public class HandlePatientAlertRequest {

    @XmlElement(required = true)
    protected AlertDTO alertDTO;
    @XmlElement(required = true)
    protected AuditDTO auditDTO;
    @XmlElement(required = true)
    protected String actionType;

    /**
     * Gets the value of the alertDTO property.
     * 
     * @return
     *     possible object is
     *     {@link AlertDTO }
     *     
     */
    public AlertDTO getAlertDTO() {
        return alertDTO;
    }

    /**
     * Sets the value of the alertDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link AlertDTO }
     *     
     */
    public void setAlertDTO(AlertDTO value) {
        this.alertDTO = value;
    }

    /**
     * Gets the value of the auditDTO property.
     * 
     * @return
     *     possible object is
     *     {@link AuditDTO }
     *     
     */
    public AuditDTO getAuditDTO() {
        return auditDTO;
    }

    /**
     * Sets the value of the auditDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link AuditDTO }
     *     
     */
    public void setAuditDTO(AuditDTO value) {
        this.auditDTO = value;
    }

    /**
     * Gets the value of the actionType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getActionType() {
        return actionType;
    }

    /**
     * Sets the value of the actionType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setActionType(String value) {
        this.actionType = value;
    }

}
