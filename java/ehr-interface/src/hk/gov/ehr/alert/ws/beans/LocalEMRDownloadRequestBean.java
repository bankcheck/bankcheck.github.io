
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import hk.gov.ehr.alert.ws.beans.common.EhrPatientDTO;


/**
 * <p>Java class for localEMRDownloadRequestBean complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="localEMRDownloadRequestBean"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="source" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="ehrPatientDTO" type="{http://ehr.gov.hk/alert/ws/beans/common}ehrPatientDTO"/&gt;
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
@XmlType(name = "localEMRDownloadRequestBean", propOrder = {
    "source",
    "ehrPatientDTO",
    "auditDTO"
})
public class LocalEMRDownloadRequestBean {

    @XmlElement(required = true)
    protected String source;
    @XmlElement(required = true)
    protected EhrPatientDTO ehrPatientDTO;
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
     * Gets the value of the ehrPatientDTO property.
     * 
     * @return
     *     possible object is
     *     {@link EhrPatientDTO }
     *     
     */
    public EhrPatientDTO getEhrPatientDTO() {
        return ehrPatientDTO;
    }

    /**
     * Sets the value of the ehrPatientDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link EhrPatientDTO }
     *     
     */
    public void setEhrPatientDTO(EhrPatientDTO value) {
        this.ehrPatientDTO = value;
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
