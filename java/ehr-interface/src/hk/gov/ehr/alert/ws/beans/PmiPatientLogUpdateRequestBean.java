
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import hk.gov.ehr.alert.ws.beans.download.EhrPatientAdrAndAllergyDownloadResult;


/**
 * <p>Java class for pmiPatientLogUpdateRequestBean complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="pmiPatientLogUpdateRequestBean"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="source" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="pmiPatientLogDTO" type="{http://ehr.gov.hk/alert/ws/beans}pmiPatientLogDTO"/&gt;
 *         &lt;element name="ehrPatientAdrAndAllergyDownloadResult" type="{http://ehr.gov.hk/alert/ws/beans/download}ehrPatientAdrAndAllergyDownloadResult" minOccurs="0"/&gt;
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
@XmlType(name = "pmiPatientLogUpdateRequestBean", propOrder = {
    "source",
    "pmiPatientLogDTO",
    "ehrPatientAdrAndAllergyDownloadResult",
    "auditDTO"
})
public class PmiPatientLogUpdateRequestBean {

    @XmlElement(required = true)
    protected String source;
    @XmlElement(required = true)
    protected PmiPatientLogDTO pmiPatientLogDTO;
    protected EhrPatientAdrAndAllergyDownloadResult ehrPatientAdrAndAllergyDownloadResult;
    @XmlElement(required = true)
    protected AuditDTO auditDTO;

    /**
     * Gets the value of the source property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSource() {
        return source;
    }

    /**
     * Sets the value of the source property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSource(String value) {
        this.source = value;
    }

    /**
     * Gets the value of the pmiPatientLogDTO property.
     * 
     * @return
     *     possible object is
     *     {@link PmiPatientLogDTO }
     *     
     */
    public PmiPatientLogDTO getPmiPatientLogDTO() {
        return pmiPatientLogDTO;
    }

    /**
     * Sets the value of the pmiPatientLogDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link PmiPatientLogDTO }
     *     
     */
    public void setPmiPatientLogDTO(PmiPatientLogDTO value) {
        this.pmiPatientLogDTO = value;
    }

    /**
     * Gets the value of the ehrPatientAdrAndAllergyDownloadResult property.
     * 
     * @return
     *     possible object is
     *     {@link EhrPatientAdrAndAllergyDownloadResult }
     *     
     */
    public EhrPatientAdrAndAllergyDownloadResult getEhrPatientAdrAndAllergyDownloadResult() {
        return ehrPatientAdrAndAllergyDownloadResult;
    }

    /**
     * Sets the value of the ehrPatientAdrAndAllergyDownloadResult property.
     * 
     * @param value
     *     allowed object is
     *     {@link EhrPatientAdrAndAllergyDownloadResult }
     *     
     */
    public void setEhrPatientAdrAndAllergyDownloadResult(EhrPatientAdrAndAllergyDownloadResult value) {
        this.ehrPatientAdrAndAllergyDownloadResult = value;
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
