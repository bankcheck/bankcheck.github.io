
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for auditDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="auditDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="workstationId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="loginId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="hkId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="mrn" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="workstationIpAddress" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "auditDTO", propOrder = {
    "workstationId",
    "loginId",
    "hkId",
    "mrn",
    "workstationIpAddress"
})
public class AuditDTO {

    protected String workstationId;
    protected String loginId;
    protected String hkId;
    protected String mrn;
    protected String workstationIpAddress;

    /**
     * Gets the value of the workstationId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getWorkstationId() {
        return workstationId;
    }

    /**
     * Sets the value of the workstationId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setWorkstationId(String value) {
        this.workstationId = value;
    }

    /**
     * Gets the value of the loginId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLoginId() {
        return loginId;
    }

    /**
     * Sets the value of the loginId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLoginId(String value) {
        this.loginId = value;
    }

    /**
     * Gets the value of the hkId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHkId() {
        return hkId;
    }

    /**
     * Sets the value of the hkId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHkId(String value) {
        this.hkId = value;
    }

    /**
     * Gets the value of the mrn property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMrn() {
        return mrn;
    }

    /**
     * Sets the value of the mrn property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMrn(String value) {
        this.mrn = value;
    }

    /**
     * Gets the value of the workstationIpAddress property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getWorkstationIpAddress() {
        return workstationIpAddress;
    }

    /**
     * Sets the value of the workstationIpAddress property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setWorkstationIpAddress(String value) {
        this.workstationIpAddress = value;
    }

}
