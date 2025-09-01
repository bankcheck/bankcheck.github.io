
package hk.gov.ehr.alert.ws.beans.download;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for downloadManifestDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="downloadManifestDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="allergicReactionCode" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergicReactionDesc" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="allergicReactionLtDesc" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "downloadManifestDTO", propOrder = {
    "allergicReactionCode",
    "allergicReactionDesc",
    "allergicReactionLtDesc"
})
public class DownloadManifestDTO {

    protected String allergicReactionCode;
    protected String allergicReactionDesc;
    @XmlElement(required = true)
    protected String allergicReactionLtDesc;

    /**
     * Gets the value of the allergicReactionCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergicReactionCode() {
        return allergicReactionCode;
    }

    /**
     * Sets the value of the allergicReactionCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergicReactionCode(String value) {
        this.allergicReactionCode = value;
    }

    /**
     * Gets the value of the allergicReactionDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergicReactionDesc() {
        return allergicReactionDesc;
    }

    /**
     * Sets the value of the allergicReactionDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergicReactionDesc(String value) {
        this.allergicReactionDesc = value;
    }

    /**
     * Gets the value of the allergicReactionLtDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAllergicReactionLtDesc() {
        return allergicReactionLtDesc;
    }

    /**
     * Sets the value of the allergicReactionLtDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAllergicReactionLtDesc(String value) {
        this.allergicReactionLtDesc = value;
    }

}
