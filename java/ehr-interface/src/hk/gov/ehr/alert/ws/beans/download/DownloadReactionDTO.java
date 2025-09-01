
package hk.gov.ehr.alert.ws.beans.download;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for downloadReactionDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="downloadReactionDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="adrDesc" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "downloadReactionDTO", propOrder = {
    "adrDesc"
})
public class DownloadReactionDTO {

    @XmlElement(required = true)
    protected String adrDesc;

    /**
     * Gets the value of the adrDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAdrDesc() {
        return adrDesc;
    }

    /**
     * Sets the value of the adrDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAdrDesc(String value) {
        this.adrDesc = value;
    }

}
