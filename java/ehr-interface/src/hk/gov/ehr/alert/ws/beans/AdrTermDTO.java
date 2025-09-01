
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for adrTermDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="adrTermDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="adrSeqNo" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="termId" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
 *         &lt;element name="termDesc" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "adrTermDTO", propOrder = {
    "adrSeqNo",
    "termId",
    "termDesc"
})
public class AdrTermDTO {

    @XmlElement(required = true)
    protected String adrSeqNo;
    protected int termId;
    @XmlElement(required = true)
    protected String termDesc;

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
     * Gets the value of the termId property.
     * 
     */
    public int getTermId() {
        return termId;
    }

    /**
     * Sets the value of the termId property.
     * 
     */
    public void setTermId(int value) {
        this.termId = value;
    }

    /**
     * Gets the value of the termDesc property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTermDesc() {
        return termDesc;
    }

    /**
     * Sets the value of the termDesc property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTermDesc(String value) {
        this.termDesc = value;
    }

}
