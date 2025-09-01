
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for insertNkda-request complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="insertNkda-request"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="refKey" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="userId" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="user" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userRank" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="userRankDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="hospitalCode" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="sourceSystem" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "insertNkda-request", propOrder = {
    "refKey",
    "userId",
    "user",
    "userRank",
    "userRankDesc",
    "hospitalCode",
    "sourceSystem"
})
public class InsertNkdaRequest {

    @XmlElement(required = true)
    protected String refKey;
    @XmlElement(required = true)
    protected String userId;
    protected String user;
    protected String userRank;
    protected String userRankDesc;
    @XmlElement(required = true)
    protected String hospitalCode;
    protected String sourceSystem;

    /**
     * Gets the value of the refKey property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRefKey() {
        return refKey;
    }

    /**
     * Sets the value of the refKey property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRefKey(String value) {
        this.refKey = value;
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

}
