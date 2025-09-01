
package hk.gov.ehr.alert.ws.beans.download;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for downloadAllergyDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="downloadAllergyDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ehrNo" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="recordKey" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="episodeNo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="hciId" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="hciLongName" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="hciShortName" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="typeOfAllergenCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="typeOfAllergenDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="typeOfAllergenLtDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenRtName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenRtId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenRtDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenLtCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenLtDesc" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="allergenTermId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenEhrDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenVtmTermId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenVtmEhrDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="levelOfCertaintyCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="levelOfCertaintyDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="levelOfCertaintyLtDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="downloadManifestDTOArray" type="{http://ehr.gov.hk/alert/ws/beans/download}downloadManifestDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="deleteAllergenReason" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenRemark" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergyNote" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="ehrDisplayDataLevel" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="recordCreationInstName" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="recordUpdateInstName" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="transactionType" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="transactionDtm" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="lastUpdateDtm" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "downloadAllergyDTO", propOrder = {
    "ehrNo",
    "recordKey",
    "episodeNo",
    "hciId",
    "hciLongName",
    "hciShortName",
    "typeOfAllergenCode",
    "typeOfAllergenDesc",
    "typeOfAllergenLtDesc",
    "allergenRtName",
    "allergenRtId",
    "allergenRtDesc",
    "allergenLtCode",
    "allergenLtDesc",
    "allergenTermId",
    "allergenEhrDesc",
    "allergenVtmTermId",
    "allergenVtmEhrDesc",
    "levelOfCertaintyCode",
    "levelOfCertaintyDesc",
    "levelOfCertaintyLtDesc",
    "downloadManifestDTOArray",
    "deleteAllergenReason",
    "allergenRemark",
    "allergyNote",
    "ehrDisplayDataLevel",
    "recordCreationInstName",
    "recordUpdateInstName",
    "transactionType",
    "transactionDtm",
    "lastUpdateDtm"
})
public class DownloadAllergyDTO {

    @XmlElement(required = true)
    protected String ehrNo;
    @XmlElement(required = true)
    protected String recordKey;
    protected String episodeNo;
    @XmlElement(required = true)
    protected String hciId;
    @XmlElement(required = true)
    protected String hciLongName;
    @XmlElement(required = true)
    protected String hciShortName;
    protected String typeOfAllergenCode;
    protected String typeOfAllergenDesc;
    protected String typeOfAllergenLtDesc;
    protected String allergenRtName;
    protected String allergenRtId;
    protected String allergenRtDesc;
    protected String allergenLtCode;
    @XmlElement(required = true)
    protected String allergenLtDesc;
    protected String allergenTermId;
    protected String allergenEhrDesc;
    protected String allergenVtmTermId;
    protected String allergenVtmEhrDesc;
    protected String levelOfCertaintyCode;
    protected String levelOfCertaintyDesc;
    protected String levelOfCertaintyLtDesc;
    protected List<DownloadManifestDTO> downloadManifestDTOArray;
    protected String deleteAllergenReason;
    protected String allergenRemark;
    protected String allergyNote;
    @XmlElement(required = true)
    protected String ehrDisplayDataLevel;
    @XmlElement(required = true)
    protected String recordCreationInstName;
    @XmlElement(required = true)
    protected String recordUpdateInstName;
    @XmlElement(required = true)
    protected String transactionType;
    @XmlElement(required = true)
    protected String transactionDtm;
    @XmlElement(required = true)
    protected String lastUpdateDtm;

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
     * Gets the value of the recordKey property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRecordKey() {
        return recordKey;
    }

    /**
     * Sets the value of the recordKey property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRecordKey(String value) {
        this.recordKey = value;
    }

    /**
     * Gets the value of the episodeNo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEpisodeNo() {
        return episodeNo;
    }

    /**
     * Sets the value of the episodeNo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEpisodeNo(String value) {
        this.episodeNo = value;
    }

    /**
     * Gets the value of the hciId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHciId() {
        return hciId;
    }

    /**
     * Sets the value of the hciId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHciId(String value) {
        this.hciId = value;
    }

    /**
     * Gets the value of the hciLongName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHciLongName() {
        return hciLongName;
    }

    /**
     * Sets the value of the hciLongName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHciLongName(String value) {
        this.hciLongName = value;
    }

    /**
     * Gets the value of the hciShortName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHciShortName() {
        return hciShortName;
    }

    /**
     * Sets the value of the hciShortName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHciShortName(String value) {
        this.hciShortName = value;
    }

    /**
     * Gets the value of the typeOfAllergenCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTypeOfAllergenCode() {
        return typeOfAllergenCode;
    }

    /**
     * Sets the value of the typeOfAllergenCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTypeOfAllergenCode(String value) {
        this.typeOfAllergenCode = value;
    }

    /**
     * Gets the value of the typeOfAllergenDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTypeOfAllergenDesc() {
        return typeOfAllergenDesc;
    }

    /**
     * Sets the value of the typeOfAllergenDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTypeOfAllergenDesc(String value) {
        this.typeOfAllergenDesc = value;
    }

    /**
     * Gets the value of the typeOfAllergenLtDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTypeOfAllergenLtDesc() {
        return typeOfAllergenLtDesc;
    }

    /**
     * Sets the value of the typeOfAllergenLtDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTypeOfAllergenLtDesc(String value) {
        this.typeOfAllergenLtDesc = value;
    }

    /**
     * Gets the value of the allergenRtName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenRtName() {
        return allergenRtName;
    }

    /**
     * Sets the value of the allergenRtName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenRtName(String value) {
        this.allergenRtName = value;
    }

    /**
     * Gets the value of the allergenRtId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenRtId() {
        return allergenRtId;
    }

    /**
     * Sets the value of the allergenRtId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenRtId(String value) {
        this.allergenRtId = value;
    }

    /**
     * Gets the value of the allergenRtDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenRtDesc() {
        return allergenRtDesc;
    }

    /**
     * Sets the value of the allergenRtDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenRtDesc(String value) {
        this.allergenRtDesc = value;
    }

    /**
     * Gets the value of the allergenLtCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenLtCode() {
        return allergenLtCode;
    }

    /**
     * Sets the value of the allergenLtCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenLtCode(String value) {
        this.allergenLtCode = value;
    }

    /**
     * Gets the value of the allergenLtDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenLtDesc() {
        return allergenLtDesc;
    }

    /**
     * Sets the value of the allergenLtDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenLtDesc(String value) {
        this.allergenLtDesc = value;
    }

    /**
     * Gets the value of the allergenTermId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenTermId() {
        return allergenTermId;
    }

    /**
     * Sets the value of the allergenTermId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenTermId(String value) {
        this.allergenTermId = value;
    }

    /**
     * Gets the value of the allergenEhrDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenEhrDesc() {
        return allergenEhrDesc;
    }

    /**
     * Sets the value of the allergenEhrDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenEhrDesc(String value) {
        this.allergenEhrDesc = value;
    }

    /**
     * Gets the value of the allergenVtmTermId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenVtmTermId() {
        return allergenVtmTermId;
    }

    /**
     * Sets the value of the allergenVtmTermId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenVtmTermId(String value) {
        this.allergenVtmTermId = value;
    }

    /**
     * Gets the value of the allergenVtmEhrDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenVtmEhrDesc() {
        return allergenVtmEhrDesc;
    }

    /**
     * Sets the value of the allergenVtmEhrDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenVtmEhrDesc(String value) {
        this.allergenVtmEhrDesc = value;
    }

    /**
     * Gets the value of the levelOfCertaintyCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLevelOfCertaintyCode() {
        return levelOfCertaintyCode;
    }

    /**
     * Sets the value of the levelOfCertaintyCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLevelOfCertaintyCode(String value) {
        this.levelOfCertaintyCode = value;
    }

    /**
     * Gets the value of the levelOfCertaintyDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLevelOfCertaintyDesc() {
        return levelOfCertaintyDesc;
    }

    /**
     * Sets the value of the levelOfCertaintyDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLevelOfCertaintyDesc(String value) {
        this.levelOfCertaintyDesc = value;
    }

    /**
     * Gets the value of the levelOfCertaintyLtDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLevelOfCertaintyLtDesc() {
        return levelOfCertaintyLtDesc;
    }

    /**
     * Sets the value of the levelOfCertaintyLtDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLevelOfCertaintyLtDesc(String value) {
        this.levelOfCertaintyLtDesc = value;
    }

    /**
     * Gets the value of the downloadManifestDTOArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the downloadManifestDTOArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getDownloadManifestDTOArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link DownloadManifestDTO }
     * 
     * 
     */
    public List<DownloadManifestDTO> getDownloadManifestDTOArray() {
        if (downloadManifestDTOArray == null) {
            downloadManifestDTOArray = new ArrayList<DownloadManifestDTO>();
        }
        return this.downloadManifestDTOArray;
    }

    /**
     * Gets the value of the deleteAllergenReason property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDeleteAllergenReason() {
        return deleteAllergenReason;
    }

    /**
     * Sets the value of the deleteAllergenReason property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDeleteAllergenReason(String value) {
        this.deleteAllergenReason = value;
    }

    /**
     * Gets the value of the allergenRemark property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenRemark() {
        return allergenRemark;
    }

    /**
     * Sets the value of the allergenRemark property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenRemark(String value) {
        this.allergenRemark = value;
    }

    /**
     * Gets the value of the allergyNote property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergyNote() {
        return allergyNote;
    }

    /**
     * Sets the value of the allergyNote property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergyNote(String value) {
        this.allergyNote = value;
    }

    /**
     * Gets the value of the ehrDisplayDataLevel property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEhrDisplayDataLevel() {
        return ehrDisplayDataLevel;
    }

    /**
     * Sets the value of the ehrDisplayDataLevel property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEhrDisplayDataLevel(String value) {
        this.ehrDisplayDataLevel = value;
    }

    /**
     * Gets the value of the recordCreationInstName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRecordCreationInstName() {
        return recordCreationInstName;
    }

    /**
     * Sets the value of the recordCreationInstName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRecordCreationInstName(String value) {
        this.recordCreationInstName = value;
    }

    /**
     * Gets the value of the recordUpdateInstName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRecordUpdateInstName() {
        return recordUpdateInstName;
    }

    /**
     * Sets the value of the recordUpdateInstName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRecordUpdateInstName(String value) {
        this.recordUpdateInstName = value;
    }

    /**
     * Gets the value of the transactionType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTransactionType() {
        return transactionType;
    }

    /**
     * Sets the value of the transactionType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTransactionType(String value) {
        this.transactionType = value;
    }

    /**
     * Gets the value of the transactionDtm property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTransactionDtm() {
        return transactionDtm;
    }

    /**
     * Sets the value of the transactionDtm property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTransactionDtm(String value) {
        this.transactionDtm = value;
    }

    /**
     * Gets the value of the lastUpdateDtm property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLastUpdateDtm() {
        return lastUpdateDtm;
    }

    /**
     * Sets the value of the lastUpdateDtm property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLastUpdateDtm(String value) {
        this.lastUpdateDtm = value;
    }

}
