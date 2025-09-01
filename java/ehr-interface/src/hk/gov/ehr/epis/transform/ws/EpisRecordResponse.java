
package hk.gov.ehr.epis.transform.ws;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import hk.gov.ehr.hepr.ws.Response;


/**
 * <p>Java class for EpisRecordResponse complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="EpisRecordResponse"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="response" type="{http://ehr.gov.hk/hepr/ws}response"/&gt;
 *         &lt;element name="episRecords" type="{http://ehr.gov.hk/epis/transform/ws}EpisRecord" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "EpisRecordResponse", propOrder = {
    "response",
    "episRecords"
})
public class EpisRecordResponse {

    @XmlElement(required = true)
    protected Response response;
    protected List<EpisRecord> episRecords;

    /**
     * Gets the value of the response property.
     * 
     * @return
     *     possible object is
     *     {@link Response }
     *     
     */
    public Response getResponse() {
        return response;
    }

    /**
     * Sets the value of the response property.
     * 
     * @param value
     *     allowed object is
     *     {@link Response }
     *     
     */
    public void setResponse(Response value) {
        this.response = value;
    }

    /**
     * Gets the value of the episRecords property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the episRecords property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getEpisRecords().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link EpisRecord }
     * 
     * 
     */
    public List<EpisRecord> getEpisRecords() {
        if (episRecords == null) {
            episRecords = new ArrayList<EpisRecord>();
        }
        return this.episRecords;
    }

}
