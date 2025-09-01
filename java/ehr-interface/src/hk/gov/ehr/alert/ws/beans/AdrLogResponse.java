
package hk.gov.ehr.alert.ws.beans;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for adrLog-response complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="adrLog-response"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="adrLogDtoArray" type="{http://ehr.gov.hk/alert/ws/beans}adrLogDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "adrLog-response", propOrder = {
    "adrLogDtoArray"
})
public class AdrLogResponse {

    protected List<AdrLogDTO> adrLogDtoArray;

    /**
     * Gets the value of the adrLogDtoArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the adrLogDtoArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAdrLogDtoArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AdrLogDTO }
     * 
     * 
     */
    public List<AdrLogDTO> getAdrLogDtoArray() {
        if (adrLogDtoArray == null) {
            adrLogDtoArray = new ArrayList<AdrLogDTO>();
        }
        return this.adrLogDtoArray;
    }

}
