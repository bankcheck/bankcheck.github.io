
package hk.gov.ehr.alert.ws.beans.download;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for downloadAdrDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="downloadAdrDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ehrNo" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="recordKey" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="episodeNo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="hciId" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="hciLongName" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="hciShortName" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="causativeAgentRtName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="causativeAgentRtId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="causativeAgentRtDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="causativeAgentLtCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="causativeAgentLtDesc" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="causativeAgentTermId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="causativeAgentEhrDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="causativeAgentVtmTermId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="causativeAgentVtmEhrDesc" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="levelOfSeverityCode" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="levelOfSeverityDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="levelOfSeverityLtDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="downloadReactionDTOArray" type="{http://ehr.gov.hk/alert/ws/beans/download}downloadReactionDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="deleteReason" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="causativeAgentRemark" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="adrNote" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
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
@XmlType(name = "downloadAdrDTO", propOrder = {
    "ehrNo",
    "recordKey",
    "episodeNo",
    "hciId",
    "hciLongName",
    "hciShortName",
    "causativeAgentRtName",
    "causativeAgentRtId",
    "causativeAgentRtDesc",
    "causativeAgentLtCode",
    "causativeAgentLtDesc",
    "causativeAgentTermId",
    "causativeAgentEhrDesc",
    "causativeAgentVtmTermId",
    "causativeAgentVtmEhrDesc",
    "levelOfSeverityCode",
    "levelOfSeverityDesc",
    "levelOfSeverityLtDesc",
    "downloadReactionDTOArray",
    "deleteReason",
    "causativeAgentRemark",
    "adrNote",
    "ehrDisplayDataLevel",
    "recordCreationInstName",
    "recordUpdateInstName",
    "transactionType",
    "transactionDtm",
    "lastUpdateDtm"
})
public class DownloadAdrDTO {

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
    protected String causativeAgentRtName;
    protected String causativeAgentRtId;
    protected String causativeAgentRtDesc;
    protected String causativeAgentLtCode;
    @XmlElement(required = true)
    protected String causativeAgentLtDesc;
    protected String causativeAgentTermId;
    protected String causativeAgentEhrDesc;
    protected String causativeAgentVtmTermId;
    @XmlElement(required = true)
    protected String causativeAgentVtmEhrDesc;
    @XmlElement(required = true)
    protected String levelOfSeverityCode;
    protected String levelOfSeverityDesc;
    protected String levelOfSeverityLtDesc;
    protected List<DownloadReactionDTO> downloadReactionDTOArray;
    protected String deleteReason;
    protected String causativeAgentRemark;
    protected String adrNote;
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
     * Gets the value of the causativeAgentRtName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentRtName() {
        return causativeAgentRtName;
    }

    /**
     * Sets the value of the causativeAgentRtName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentRtName(String value) {
        this.causativeAgentRtName = value;
    }

    /**
     * Gets the value of the causativeAgentRtId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentRtId() {
        return causativeAgentRtId;
    }

    /**
     * Sets the value of the causativeAgentRtId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentRtId(String value) {
        this.causativeAgentRtId = value;
    }

    /**
     * Gets the value of the causativeAgentRtDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentRtDesc() {
        return causativeAgentRtDesc;
    }

    /**
     * Sets the value of the causativeAgentRtDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentRtDesc(String value) {
        this.causativeAgentRtDesc = value;
    }

    /**
     * Gets the value of the causativeAgentLtCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentLtCode() {
        return causativeAgentLtCode;
    }

    /**
     * Sets the value of the causativeAgentLtCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentLtCode(String value) {
        this.causativeAgentLtCode = value;
    }

    /**
     * Gets the value of the causativeAgentLtDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentLtDesc() {
        return causativeAgentLtDesc;
    }

    /**
     * Sets the value of the causativeAgentLtDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentLtDesc(String value) {
        this.causativeAgentLtDesc = value;
    }

    /**
     * Gets the value of the causativeAgentTermId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentTermId() {
        return causativeAgentTermId;
    }

    /**
     * Sets the value of the causativeAgentTermId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentTermId(String value) {
        this.causativeAgentTermId = value;
    }

    /**
     * Gets the value of the causativeAgentEhrDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentEhrDesc() {
        return causativeAgentEhrDesc;
    }

    /**
     * Sets the value of the causativeAgentEhrDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentEhrDesc(String value) {
        this.causativeAgentEhrDesc = value;
    }

    /**
     * Gets the value of the causativeAgentVtmTermId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentVtmTermId() {
        return causativeAgentVtmTermId;
    }

    /**
     * Sets the value of the causativeAgentVtmTermId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentVtmTermId(String value) {
        this.causativeAgentVtmTermId = value;
    }

    /**
     * Gets the value of the causativeAgentVtmEhrDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentVtmEhrDesc() {
        return causativeAgentVtmEhrDesc;
    }

    /**
     * Sets the value of the causativeAgentVtmEhrDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentVtmEhrDesc(String value) {
        this.causativeAgentVtmEhrDesc = value;
    }

    /**
     * Gets the value of the levelOfSeverityCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLevelOfSeverityCode() {
        return levelOfSeverityCode;
    }

    /**
     * Sets the value of the levelOfSeverityCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLevelOfSeverityCode(String value) {
        this.levelOfSeverityCode = value;
    }

    /**
     * Gets the value of the levelOfSeverityDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLevelOfSeverityDesc() {
        return levelOfSeverityDesc;
    }

    /**
     * Sets the value of the levelOfSeverityDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLevelOfSeverityDesc(String value) {
        this.levelOfSeverityDesc = value;
    }

    /**
     * Gets the value of the levelOfSeverityLtDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLevelOfSeverityLtDesc() {
        return levelOfSeverityLtDesc;
    }

    /**
     * Sets the value of the levelOfSeverityLtDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLevelOfSeverityLtDesc(String value) {
        this.levelOfSeverityLtDesc = value;
    }

    /**
     * Gets the value of the downloadReactionDTOArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the downloadReactionDTOArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getDownloadReactionDTOArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link DownloadReactionDTO }
     * 
     * 
     */
    public List<DownloadReactionDTO> getDownloadReactionDTOArray() {
        if (downloadReactionDTOArray == null) {
            downloadReactionDTOArray = new ArrayList<DownloadReactionDTO>();
        }
        return this.downloadReactionDTOArray;
    }

    /**
     * Gets the value of the deleteReason property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDeleteReason() {
        return deleteReason;
    }

    /**
     * Sets the value of the deleteReason property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDeleteReason(String value) {
        this.deleteReason = value;
    }

    /**
     * Gets the value of the causativeAgentRemark property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausativeAgentRemark() {
        return causativeAgentRemark;
    }

    /**
     * Sets the value of the causativeAgentRemark property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausativeAgentRemark(String value) {
        this.causativeAgentRemark = value;
    }

    /**
     * Gets the value of the adrNote property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAdrNote() {
        return adrNote;
    }

    /**
     * Sets the value of the adrNote property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAdrNote(String value) {
        this.adrNote = value;
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
