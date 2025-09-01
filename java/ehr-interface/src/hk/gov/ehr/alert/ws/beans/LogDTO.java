
package hk.gov.ehr.alert.ws.beans;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for logDTO complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="logDTO"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="allergyStringLogDTOArray" type="{http://ehr.gov.hk/alert/ws/beans}allergyStringLogDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="adrStringLogDTOArray" type="{http://ehr.gov.hk/alert/ws/beans}adrStringLogDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="alertStringLogDTOArray" type="{http://ehr.gov.hk/alert/ws/beans}alertStringLogDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "logDTO", propOrder = {
    "allergyStringLogDTOArray",
    "adrStringLogDTOArray",
    "alertStringLogDTOArray"
})
public class LogDTO {

    protected List<AllergyStringLogDTO> allergyStringLogDTOArray;
    protected List<AdrStringLogDTO> adrStringLogDTOArray;
    protected List<AlertStringLogDTO> alertStringLogDTOArray;

    /**
     * Gets the value of the allergyStringLogDTOArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the allergyStringLogDTOArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAllergyStringLogDTOArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AllergyStringLogDTO }
     * 
     * 
     */
    public List<AllergyStringLogDTO> getAllergyStringLogDTOArray() {
        if (allergyStringLogDTOArray == null) {
            allergyStringLogDTOArray = new ArrayList<AllergyStringLogDTO>();
        }
        return this.allergyStringLogDTOArray;
    }

    /**
     * Gets the value of the adrStringLogDTOArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the adrStringLogDTOArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAdrStringLogDTOArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AdrStringLogDTO }
     * 
     * 
     */
    public List<AdrStringLogDTO> getAdrStringLogDTOArray() {
        if (adrStringLogDTOArray == null) {
            adrStringLogDTOArray = new ArrayList<AdrStringLogDTO>();
        }
        return this.adrStringLogDTOArray;
    }

    /**
     * Gets the value of the alertStringLogDTOArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the alertStringLogDTOArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAlertStringLogDTOArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AlertStringLogDTO }
     * 
     * 
     */
    public List<AlertStringLogDTO> getAlertStringLogDTOArray() {
        if (alertStringLogDTOArray == null) {
            alertStringLogDTOArray = new ArrayList<AlertStringLogDTO>();
        }
        return this.alertStringLogDTOArray;
    }

}
