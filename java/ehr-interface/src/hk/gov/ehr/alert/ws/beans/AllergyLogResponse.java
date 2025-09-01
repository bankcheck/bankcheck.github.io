
package hk.gov.ehr.alert.ws.beans;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for allergyLog-response complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="allergyLog-response"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="allergyLogDtoArray" type="{http://ehr.gov.hk/alert/ws/beans}allergyLogDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "allergyLog-response", propOrder = {
    "allergyLogDtoArray"
})
public class AllergyLogResponse {

    protected List<AllergyLogDTO> allergyLogDtoArray;

    /**
     * Gets the value of the allergyLogDtoArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the allergyLogDtoArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAllergyLogDtoArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AllergyLogDTO }
     * 
     * 
     */
    public List<AllergyLogDTO> getAllergyLogDtoArray() {
        if (allergyLogDtoArray == null) {
            allergyLogDtoArray = new ArrayList<AllergyLogDTO>();
        }
        return this.allergyLogDtoArray;
    }

}
