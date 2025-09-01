
package hk.gov.ehr.epis.transform.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import org.hl7.v3.ClinicalNoteDetail;


/**
 * <p>Java class for EpisRecord complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="EpisRecord"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="patientKey" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element ref="{urn:hl7-org:v3}clinicalNoteDetail"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "EpisRecord", propOrder = {
    "patientKey",
    "clinicalNoteDetail"
})
public class EpisRecord {

    @XmlElement(required = true)
    protected String patientKey;
    @XmlElement(namespace = "urn:hl7-org:v3", required = true)
    protected ClinicalNoteDetail clinicalNoteDetail;

    /**
     * Gets the value of the patientKey property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPatientKey() {
        return patientKey;
    }

    /**
     * Sets the value of the patientKey property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPatientKey(String value) {
        this.patientKey = value;
    }

    /**
     * Gets the value of the clinicalNoteDetail property.
     * 
     * @return
     *     possible object is
     *     {@link ClinicalNoteDetail }
     *     
     */
    public ClinicalNoteDetail getClinicalNoteDetail() {
        return clinicalNoteDetail;
    }

    /**
     * Sets the value of the clinicalNoteDetail property.
     * 
     * @param value
     *     allowed object is
     *     {@link ClinicalNoteDetail }
     *     
     */
    public void setClinicalNoteDetail(ClinicalNoteDetail value) {
        this.clinicalNoteDetail = value;
    }

}
