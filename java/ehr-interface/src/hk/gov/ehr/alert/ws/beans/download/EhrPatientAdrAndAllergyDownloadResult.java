
package hk.gov.ehr.alert.ws.beans.download;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ehrPatientAdrAndAllergyDownloadResult complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ehrPatientAdrAndAllergyDownloadResult"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="downloadStatusDTO" type="{http://ehr.gov.hk/alert/ws/beans/download}downloadStatusDTO"/&gt;
 *         &lt;element name="downloadPatientDTO" type="{http://ehr.gov.hk/alert/ws/beans/download}downloadPatientDTO" minOccurs="0"/&gt;
 *         &lt;sequence&gt;
 *           &lt;element name="downloadAdrDTOArray" type="{http://ehr.gov.hk/alert/ws/beans/download}downloadAdrDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;/sequence&gt;
 *         &lt;sequence&gt;
 *           &lt;element name="downloadAllergyDTOArray" type="{http://ehr.gov.hk/alert/ws/beans/download}downloadAllergyDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;/sequence&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ehrPatientAdrAndAllergyDownloadResult", propOrder = {
    "downloadStatusDTO",
    "downloadPatientDTO",
    "downloadAdrDTOArray",
    "downloadAllergyDTOArray"
})
public class EhrPatientAdrAndAllergyDownloadResult {

    @XmlElement(required = true)
    protected DownloadStatusDTO downloadStatusDTO;
    protected DownloadPatientDTO downloadPatientDTO;
    protected List<DownloadAdrDTO> downloadAdrDTOArray;
    protected List<DownloadAllergyDTO> downloadAllergyDTOArray;

    /**
     * Gets the value of the downloadStatusDTO property.
     * 
     * @return
     *     possible object is
     *     {@link DownloadStatusDTO }
     *     
     */
    public DownloadStatusDTO getDownloadStatusDTO() {
        return downloadStatusDTO;
    }

    /**
     * Sets the value of the downloadStatusDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link DownloadStatusDTO }
     *     
     */
    public void setDownloadStatusDTO(DownloadStatusDTO value) {
        this.downloadStatusDTO = value;
    }

    /**
     * Gets the value of the downloadPatientDTO property.
     * 
     * @return
     *     possible object is
     *     {@link DownloadPatientDTO }
     *     
     */
    public DownloadPatientDTO getDownloadPatientDTO() {
        return downloadPatientDTO;
    }

    /**
     * Sets the value of the downloadPatientDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link DownloadPatientDTO }
     *     
     */
    public void setDownloadPatientDTO(DownloadPatientDTO value) {
        this.downloadPatientDTO = value;
    }

    /**
     * Gets the value of the downloadAdrDTOArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the downloadAdrDTOArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getDownloadAdrDTOArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link DownloadAdrDTO }
     * 
     * 
     */
    public List<DownloadAdrDTO> getDownloadAdrDTOArray() {
        if (downloadAdrDTOArray == null) {
            downloadAdrDTOArray = new ArrayList<DownloadAdrDTO>();
        }
        return this.downloadAdrDTOArray;
    }

    /**
     * Gets the value of the downloadAllergyDTOArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the downloadAllergyDTOArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getDownloadAllergyDTOArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link DownloadAllergyDTO }
     * 
     * 
     */
    public List<DownloadAllergyDTO> getDownloadAllergyDTOArray() {
        if (downloadAllergyDTOArray == null) {
            downloadAllergyDTOArray = new ArrayList<DownloadAllergyDTO>();
        }
        return this.downloadAllergyDTOArray;
    }

}
