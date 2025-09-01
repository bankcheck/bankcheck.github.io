
package hk.gov.ehr.alert.ws.beans.common;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ehrPatientDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ehrPatientDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ehrNo" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="hkid" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="docType" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="docNum" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="personEngSurName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="personEngGivenName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="personEngFullName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="sex" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="birthDate" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ehrPatientDTO", propOrder = {
    "ehrNo",
    "hkid",
    "docType",
    "docNum",
    "personEngSurName",
    "personEngGivenName",
    "personEngFullName",
    "sex",
    "birthDate"
})
public class EhrPatientDTO {

    @XmlElement(required = true)
    protected String ehrNo;
    protected String hkid;
    protected String docType;
    protected String docNum;
    protected String personEngSurName;
    protected String personEngGivenName;
    protected String personEngFullName;
    @XmlElement(required = true)
    protected String sex;
    @XmlElement(required = true)
    protected String birthDate;

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
     * Gets the value of the hkid property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHkid() {
        return hkid;
    }

    /**
     * Sets the value of the hkid property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHkid(String value) {
        this.hkid = value;
    }

    /**
     * Gets the value of the docType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDocType() {
        return docType;
    }

    /**
     * Sets the value of the docType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDocType(String value) {
        this.docType = value;
    }

    /**
     * Gets the value of the docNum property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDocNum() {
        return docNum;
    }

    /**
     * Sets the value of the docNum property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDocNum(String value) {
        this.docNum = value;
    }

    /**
     * Gets the value of the personEngSurName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPersonEngSurName() {
        return personEngSurName;
    }

    /**
     * Sets the value of the personEngSurName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPersonEngSurName(String value) {
        this.personEngSurName = value;
    }

    /**
     * Gets the value of the personEngGivenName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPersonEngGivenName() {
        return personEngGivenName;
    }

    /**
     * Sets the value of the personEngGivenName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPersonEngGivenName(String value) {
        this.personEngGivenName = value;
    }

    /**
     * Gets the value of the personEngFullName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPersonEngFullName() {
        return personEngFullName;
    }

    /**
     * Sets the value of the personEngFullName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPersonEngFullName(String value) {
        this.personEngFullName = value;
    }

    /**
     * Gets the value of the sex property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSex() {
        return sex;
    }

    /**
     * Sets the value of the sex property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSex(String value) {
        this.sex = value;
    }

    /**
     * Gets the value of the birthDate property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBirthDate() {
        return birthDate;
    }

    /**
     * Sets the value of the birthDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBirthDate(String value) {
        this.birthDate = value;
    }

}
