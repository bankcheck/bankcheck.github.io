
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for adrStringLogDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="adrStringLogDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="adrSeqNo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="patientKey" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="trxType" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="trxDtm" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="drugCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="drugDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="severity" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="remark" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="hospitalCode" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="sourceSystem" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="createDate" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="createUserId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="createUser" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="createHosp" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="createRank" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="createRankDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="deleteReason" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateUserId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateDate" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateUser" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateRank" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateRankDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateHosp" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="reaction" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="adrType" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="displayNameType" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "adrStringLogDTO", propOrder = {
    "adrSeqNo",
    "patientKey",
    "trxType",
    "trxDtm",
    "drugCode",
    "drugDesc",
    "severity",
    "remark",
    "hospitalCode",
    "sourceSystem",
    "createDate",
    "createUserId",
    "createUser",
    "createHosp",
    "createRank",
    "createRankDesc",
    "deleteReason",
    "updateUserId",
    "updateDate",
    "updateUser",
    "updateRank",
    "updateRankDesc",
    "updateHosp",
    "reaction",
    "adrType",
    "displayNameType"
})
public class AdrStringLogDTO {

    protected String adrSeqNo;
    protected String patientKey;
    protected String trxType;
    protected String trxDtm;
    protected String drugCode;
    protected String drugDesc;
    protected String severity;
    protected String remark;
    @XmlElement(required = true)
    protected String hospitalCode;
    protected String sourceSystem;
    protected String createDate;
    protected String createUserId;
    protected String createUser;
    protected String createHosp;
    protected String createRank;
    protected String createRankDesc;
    protected String deleteReason;
    protected String updateUserId;
    protected String updateDate;
    protected String updateUser;
    protected String updateRank;
    protected String updateRankDesc;
    protected String updateHosp;
    protected String reaction;
    @XmlElement(required = true)
    protected String adrType;
    protected String displayNameType;

    /**
     * Gets the value of the adrSeqNo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAdrSeqNo() {
        return adrSeqNo;
    }

    /**
     * Sets the value of the adrSeqNo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAdrSeqNo(String value) {
        this.adrSeqNo = value;
    }

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
     * Gets the value of the trxType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTrxType() {
        return trxType;
    }

    /**
     * Sets the value of the trxType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTrxType(String value) {
        this.trxType = value;
    }

    /**
     * Gets the value of the trxDtm property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTrxDtm() {
        return trxDtm;
    }

    /**
     * Sets the value of the trxDtm property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTrxDtm(String value) {
        this.trxDtm = value;
    }

    /**
     * Gets the value of the drugCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDrugCode() {
        return drugCode;
    }

    /**
     * Sets the value of the drugCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDrugCode(String value) {
        this.drugCode = value;
    }

    /**
     * Gets the value of the drugDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDrugDesc() {
        return drugDesc;
    }

    /**
     * Sets the value of the drugDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDrugDesc(String value) {
        this.drugDesc = value;
    }

    /**
     * Gets the value of the severity property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSeverity() {
        return severity;
    }

    /**
     * Sets the value of the severity property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSeverity(String value) {
        this.severity = value;
    }

    /**
     * Gets the value of the remark property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRemark() {
        return remark;
    }

    /**
     * Sets the value of the remark property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRemark(String value) {
        this.remark = value;
    }

    /**
     * Gets the value of the hospitalCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHospitalCode() {
        return hospitalCode;
    }

    /**
     * Sets the value of the hospitalCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHospitalCode(String value) {
        this.hospitalCode = value;
    }

    /**
     * Gets the value of the sourceSystem property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSourceSystem() {
        return sourceSystem;
    }

    /**
     * Sets the value of the sourceSystem property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSourceSystem(String value) {
        this.sourceSystem = value;
    }

    /**
     * Gets the value of the createDate property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCreateDate() {
        return createDate;
    }

    /**
     * Sets the value of the createDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCreateDate(String value) {
        this.createDate = value;
    }

    /**
     * Gets the value of the createUserId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCreateUserId() {
        return createUserId;
    }

    /**
     * Sets the value of the createUserId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCreateUserId(String value) {
        this.createUserId = value;
    }

    /**
     * Gets the value of the createUser property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCreateUser() {
        return createUser;
    }

    /**
     * Sets the value of the createUser property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCreateUser(String value) {
        this.createUser = value;
    }

    /**
     * Gets the value of the createHosp property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCreateHosp() {
        return createHosp;
    }

    /**
     * Sets the value of the createHosp property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCreateHosp(String value) {
        this.createHosp = value;
    }

    /**
     * Gets the value of the createRank property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCreateRank() {
        return createRank;
    }

    /**
     * Sets the value of the createRank property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCreateRank(String value) {
        this.createRank = value;
    }

    /**
     * Gets the value of the createRankDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCreateRankDesc() {
        return createRankDesc;
    }

    /**
     * Sets the value of the createRankDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCreateRankDesc(String value) {
        this.createRankDesc = value;
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
     * Gets the value of the updateUserId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUpdateUserId() {
        return updateUserId;
    }

    /**
     * Sets the value of the updateUserId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUpdateUserId(String value) {
        this.updateUserId = value;
    }

    /**
     * Gets the value of the updateDate property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUpdateDate() {
        return updateDate;
    }

    /**
     * Sets the value of the updateDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUpdateDate(String value) {
        this.updateDate = value;
    }

    /**
     * Gets the value of the updateUser property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUpdateUser() {
        return updateUser;
    }

    /**
     * Sets the value of the updateUser property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUpdateUser(String value) {
        this.updateUser = value;
    }

    /**
     * Gets the value of the updateRank property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUpdateRank() {
        return updateRank;
    }

    /**
     * Sets the value of the updateRank property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUpdateRank(String value) {
        this.updateRank = value;
    }

    /**
     * Gets the value of the updateRankDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUpdateRankDesc() {
        return updateRankDesc;
    }

    /**
     * Sets the value of the updateRankDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUpdateRankDesc(String value) {
        this.updateRankDesc = value;
    }

    /**
     * Gets the value of the updateHosp property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUpdateHosp() {
        return updateHosp;
    }

    /**
     * Sets the value of the updateHosp property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUpdateHosp(String value) {
        this.updateHosp = value;
    }

    /**
     * Gets the value of the reaction property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getReaction() {
        return reaction;
    }

    /**
     * Sets the value of the reaction property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setReaction(String value) {
        this.reaction = value;
    }

    /**
     * Gets the value of the adrType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAdrType() {
        return adrType;
    }

    /**
     * Sets the value of the adrType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAdrType(String value) {
        this.adrType = value;
    }

    /**
     * Gets the value of the displayNameType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDisplayNameType() {
        return displayNameType;
    }

    /**
     * Sets the value of the displayNameType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDisplayNameType(String value) {
        this.displayNameType = value;
    }

}
