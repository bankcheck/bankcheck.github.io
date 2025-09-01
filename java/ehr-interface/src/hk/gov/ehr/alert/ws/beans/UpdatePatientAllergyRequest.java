
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for updatePatientAllergy-request complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="updatePatientAllergy-request"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="allergyDTO" type="{http://ehr.gov.hk/alert/ws/beans}allergyDTO"/&gt;
 *         &lt;element name="auditDTO" type="{http://ehr.gov.hk/alert/ws/beans}auditDTO"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "updatePatientAllergy-request", propOrder = {
    "allergyDTO",
    "auditDTO"
})
public class UpdatePatientAllergyRequest {

    @XmlElement(required = true)
    protected AllergyDTO allergyDTO;
    @XmlElement(required = true)
    protected AuditDTO auditDTO;

    /**
     * Gets the value of the allergyDTO property.
     * 
     * @return
     *     possible object is
     *     {@link AllergyDTO }
     *     
     */
    public AllergyDTO getAllergyDTO() {
        return allergyDTO;
    }

    /**
     * Sets the value of the allergyDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link AllergyDTO }
     *     
     */
    public void setAllergyDTO(AllergyDTO value) {
        this.allergyDTO = value;
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

}
