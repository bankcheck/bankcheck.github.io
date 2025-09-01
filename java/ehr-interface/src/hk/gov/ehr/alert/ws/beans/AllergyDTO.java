
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
 * <p>Java class for allergyDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="allergyDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="allergySeqNo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="patientKey" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="displayName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="shortDisplayName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenType" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergenDTO" type="{http://ehr.gov.hk/alert/ws/beans}allergenDTO" minOccurs="0"/&gt;
 *         &lt;element name="allergenCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="certainty" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="additionInfo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="hospitalCode" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="sourceSystem" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="createDate" type="{http://www.w3.org/2001/XMLSchema}dateTime" minOccurs="0"/&gt;
 *         &lt;element name="userId" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="user" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userHosp" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userRank" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userRankDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="deleteReason" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateBy" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateDate" type="{http://www.w3.org/2001/XMLSchema}dateTime" minOccurs="0"/&gt;
 *         &lt;element name="updateUser" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateRank" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateRankDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="updateHosp" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="manifestBean" type="{http://ehr.gov.hk/alert/ws/beans}manifestBean" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="migrateData" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
 *         &lt;element name="version" type="{http://www.w3.org/2001/XMLSchema}int" minOccurs="0"/&gt;
 *         &lt;element name="allergyTermDTO" type="{http://ehr.gov.hk/alert/ws/beans}allergyTermDTO" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "allergyDTO", propOrder = {
    "allergySeqNo",
    "patientKey",
    "displayName",
    "shortDisplayName",
    "allergenType",
    "allergenDTO",
    "allergenCode",
    "certainty",
    "additionInfo",
    "hospitalCode",
    "sourceSystem",
    "createDate",
    "userId",
    "user",
    "userHosp",
    "userRank",
    "userRankDesc",
    "deleteReason",
    "updateBy",
    "updateDate",
    "updateUser",
    "updateRank",
    "updateRankDesc",
    "updateHosp",
    "manifestBean",
    "migrateData",
    "version",
    "allergyTermDTO"
})
public class AllergyDTO {

    protected String allergySeqNo;
    protected String patientKey;
    protected String displayName;
    protected String shortDisplayName;
    protected String allergenType;
    protected AllergenDTO allergenDTO;
    protected String allergenCode;
    protected String certainty;
    protected String additionInfo;
    @XmlElement(required = true)
    protected String hospitalCode;
    protected String sourceSystem;
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar createDate;
    protected String userId;
    protected String user;
    protected String userHosp;
    protected String userRank;
    protected String userRankDesc;
    protected String deleteReason;
    protected String updateBy;
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar updateDate;
    protected String updateUser;
    protected String updateRank;
    protected String updateRankDesc;
    protected String updateHosp;
    protected List<ManifestBean> manifestBean;
    protected boolean migrateData;
    protected Integer version;
    protected AllergyTermDTO allergyTermDTO;

    /**
     * Gets the value of the allergySeqNo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergySeqNo() {
        return allergySeqNo;
    }

    /**
     * Sets the value of the allergySeqNo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergySeqNo(String value) {
        this.allergySeqNo = value;
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
     * Gets the value of the displayName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDisplayName() {
        return displayName;
    }

    /**
     * Sets the value of the displayName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDisplayName(String value) {
        this.displayName = value;
    }

    /**
     * Gets the value of the shortDisplayName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getShortDisplayName() {
        return shortDisplayName;
    }

    /**
     * Sets the value of the shortDisplayName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setShortDisplayName(String value) {
        this.shortDisplayName = value;
    }

    /**
     * Gets the value of the allergenType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenType() {
        return allergenType;
    }

    /**
     * Sets the value of the allergenType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenType(String value) {
        this.allergenType = value;
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
     * Gets the value of the allergenCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergenCode() {
        return allergenCode;
    }

    /**
     * Sets the value of the allergenCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergenCode(String value) {
        this.allergenCode = value;
    }

    /**
     * Gets the value of the certainty property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCertainty() {
        return certainty;
    }

    /**
     * Sets the value of the certainty property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCertainty(String value) {
        this.certainty = value;
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
     * Gets the value of the createDate property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getCreateDate() {
        return createDate;
    }

    /**
     * Sets the value of the createDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setCreateDate(XMLGregorianCalendar value) {
        this.createDate = value;
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
     * Gets the value of the manifestBean property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the manifestBean property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getManifestBean().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link ManifestBean }
     * 
     * 
     */
    public List<ManifestBean> getManifestBean() {
        if (manifestBean == null) {
            manifestBean = new ArrayList<ManifestBean>();
        }
        return this.manifestBean;
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
     * Gets the value of the version property.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Sets the value of the version property.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setVersion(Integer value) {
        this.version = value;
    }

    /**
     * Gets the value of the allergyTermDTO property.
     * 
     * @return
     *     possible object is
     *     {@link AllergyTermDTO }
     *     
     */
    public AllergyTermDTO getAllergyTermDTO() {
        return allergyTermDTO;
    }

    /**
     * Sets the value of the allergyTermDTO property.
     * 
     * @param value
     *     allowed object is
     *     {@link AllergyTermDTO }
     *     
     */
    public void setAllergyTermDTO(AllergyTermDTO value) {
        this.allergyTermDTO = value;
    }

}
