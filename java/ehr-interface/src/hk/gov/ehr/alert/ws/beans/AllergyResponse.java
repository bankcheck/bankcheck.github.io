
package hk.gov.ehr.alert.ws.beans;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for allergy-response complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="allergy-response"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="allergyDtoArray" type="{http://ehr.gov.hk/alert/ws/beans}allergyDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "allergy-response", propOrder = {
    "allergyDtoArray"
})
public class AllergyResponse {

    protected List<AllergyDTO> allergyDtoArray;

    /**
     * Gets the value of the allergyDtoArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the allergyDtoArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAllergyDtoArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AllergyDTO }
     * 
     * 
     */
    public List<AllergyDTO> getAllergyDtoArray() {
        if (allergyDtoArray == null) {
            allergyDtoArray = new ArrayList<AllergyDTO>();
        }
        return this.allergyDtoArray;
    }

}
