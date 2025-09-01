
package hk.gov.ehr.alert.ws.beans;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Java class for adrDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="adrDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="adrSeqNo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="patientKey" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="drugCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="drugDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="shortDrugDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenDTO" type="{http://ehr.gov.hk/alert/ws/beans}allergenDTO" minOccurs="0"/&gt;
 *         &lt;element name="serverity" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="additionInfo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="hospitalCode" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="sourceSystem" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="user" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userHosp" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userRank" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userRankDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="adrCommonReactionDTO" type="{http://ehr.gov.hk/alert/ws/beans}adrCommonReactionDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="deleteReason" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateBy" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateDate" type="{http://www.w3.org/2001/XMLSchema}dateTime" minOccurs="0"/&gt;
 *         &lt;element name="updateUser" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateRank" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateRankDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateHosp" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="freeText" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
 *         &lt;element name="migrateData" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
 *         &lt;element name="adrType" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="adrTermDTO" type="{http://ehr.gov.hk/alert/ws/beans}adrTermDTO" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "adrDTO", propOrder = {
    "adrSeqNo",
    "patientKey",
    "drugCode",
    "drugDesc",
    "shortDrugDesc",
    "allergenDTO",
    "serverity",
    "additionInfo",
    "hospitalCode",
    "sourceSystem",
    "userId",
    "user",
    "userHosp",
    "userRank",
    "userRankDesc",
    "adrCommonReactionDTO",
    "deleteReason",
    "updateBy",
    "updateDate",
    "updateUser",
    "updateRank",
    "updateRankDesc",
    "updateHosp",
    "freeText",
    "migrateData",
    "adrType",
    "adrTermDTO"
})
public class AdrDTO {

    protected String adrSeqNo;
    protected String patientKey;
    protected String drugCode;
    protected String drugDesc;
    protected String shortDrugDesc;
    protected AllergenDTO allergenDTO;
    protected String serverity;
    protected String additionInfo;
    @XmlElement(required = true)
    protected String hospitalCode;
    protected String sourceSystem;
    protected String userId;
    protected String user;
    protected String userHosp;
    protected String userRank;
    protected String userRankDesc;
    protected List<AdrCommonReactionDTO> adrCommonReactionDTO;
    protected String deleteReason;
    protected String updateBy;
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar updateDate;
    protected String updateUser;
    protected String updateRank;
    protected String updateRankDesc;
    protected String updateHosp;
    protected boolean freeText;
    protected boolean migrateData;
    @XmlElement(required = true)
    protected String adrType;
    protected AdrTermDTO adrTermDTO;

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
     * Gets the value of the shortDrugDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getShortDrugDesc() {
        return shortDrugDesc;
    }

    /**
     * Sets the value of the shortDrugDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setShortDrugDesc(String value) {
        this.shortDrugDesc = value;
    }

    /**
     * Gets the value of the allergenDTO property.
     * 
     * @return
     *     possible object is
     *     {@link AllergenDTO }
     *     
     */
    public AllergenDTO getAllergenDTO() {
        return allergenDTO;
    }

    /**
     * Sets the value of the allergenDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link AllergenDTO }
     *     
     */
    public void setAllergenDTO(AllergenDTO value) {
        this.allergenDTO = value;
    }

    /**
     * Gets the value of the serverity property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getServerity() {
        return serverity;
    }

    /**
     * Sets the value of the serverity property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setServerity(String value) {
        this.serverity = value;
    }

    /**
     * Gets the value of the additionInfo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAdditionInfo() {
        return additionInfo;
    }

    /**
     * Sets the value of the additionInfo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAdditionInfo(String value) {
        this.additionInfo = value;
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
     * Gets the value of the userId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUserId() {
        return userId;
    }

    /**
     * Sets the value of the userId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUserId(String value) {
        this.userId = value;
    }

    /**
     * Gets the value of the user property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUser() {
        return user;
    }

    /**
     * Sets the value of the user property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUser(String value) {
        this.user = value;
    }

    /**
     * Gets the value of the userHosp property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUserHosp() {
        return userHosp;
    }

    /**
     * Sets the value of the userHosp property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUserHosp(String value) {
        this.userHosp = value;
    }

    /**
     * Gets the value of the userRank property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUserRank() {
        return userRank;
    }

    /**
     * Sets the value of the userRank property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUserRank(String value) {
        this.userRank = value;
    }

    /**
     * Gets the value of the userRankDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUserRankDesc() {
        return userRankDesc;
    }

    /**
     * Sets the value of the userRankDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUserRankDesc(String value) {
        this.userRankDesc = value;
    }

    /**
     * Gets the value of the adrCommonReactionDTO property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the adrCommonReactionDTO property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAdrCommonReactionDTO().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AdrCommonReactionDTO }
     * 
     * 
     */
    public List<AdrCommonReactionDTO> getAdrCommonReactionDTO() {
        if (adrCommonReactionDTO == null) {
            adrCommonReactionDTO = new ArrayList<AdrCommonReactionDTO>();
        }
        return this.adrCommonReactionDTO;
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
     * Gets the value of the updateBy property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUpdateBy() {
        return updateBy;
    }

    /**
     * Sets the value of the updateBy property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUpdateBy(String value) {
        this.updateBy = value;
    }

    /**
     * Gets the value of the updateDate property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getUpdateDate() {
        return updateDate;
    }

    /**
     * Sets the value of the updateDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setUpdateDate(XMLGregorianCalendar value) {
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
     * Gets the value of the freeText property.
     * 
     */
    public boolean isFreeText() {
        return freeText;
    }

    /**
     * Sets the value of the freeText property.
     * 
     */
    public void setFreeText(boolean value) {
        this.freeText = value;
    }

    /**
     * Gets the value of the migrateData property.
     * 
     */
    public boolean isMigrateData() {
        return migrateData;
    }

    /**
     * Sets the value of the migrateData property.
     * 
     */
    public void setMigrateData(boolean value) {
        this.migrateData = value;
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
     * Gets the value of the adrTermDTO property.
     * 
     * @return
     *     possible object is
     *     {@link AdrTermDTO }
     *     
     */
    public AdrTermDTO getAdrTermDTO() {
        return adrTermDTO;
    }

    /**
     * Sets the value of the adrTermDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link AdrTermDTO }
     *     
     */
    public void setAdrTermDTO(AdrTermDTO value) {
        this.adrTermDTO = value;
    }

}
