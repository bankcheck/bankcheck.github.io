
package hk.gov.ehr.saam.transform.ws;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import hk.gov.ehr.hepr.ws.Response;
import org.hl7.v3.CausativeAgent;


/**
 * <p>Java class for AdrRecordResponse complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="AdrRecordResponse"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="response" type="{http://ehr.gov.hk/hepr/ws}response"/&gt;
 *         &lt;element name="causative_agent" type="{urn:hl7-org:v3}causative_agent" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "AdrRecordResponse", propOrder = {
    "response",
    "causativeAgent"
})
public class AdrRecordResponse {

    @XmlElement(required = true)
    protected Response response;
    @XmlElement(name = "causative_agent")
    protected List<CausativeAgent> causativeAgent;

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
     * Gets the value of the causativeAgent property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the causativeAgent property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getCausativeAgent().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link CausativeAgent }
     * 
     * 
     */
    public List<CausativeAgent> getCausativeAgent() {
        if (causativeAgent == null) {
            causativeAgent = new ArrayList<CausativeAgent>();
        }
        return this.causativeAgent;
    }

}
