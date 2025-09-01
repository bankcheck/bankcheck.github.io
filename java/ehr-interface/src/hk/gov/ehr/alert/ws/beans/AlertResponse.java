
package hk.gov.ehr.alert.ws.beans;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for alert-response complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="alert-response"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="alertDtoArray" type="{http://ehr.gov.hk/alert/ws/beans}alertDTO" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "alert-response", propOrder = {
    "alertDtoArray"
})
public class AlertResponse {

    protected List<AlertDTO> alertDtoArray;

    /**
     * Gets the value of the alertDtoArray property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the alertDtoArray property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAlertDtoArray().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AlertDTO }
     * 
     * 
     */
    public List<AlertDTO> getAlertDtoArray() {
        if (alertDtoArray == null) {
            alertDtoArray = new ArrayList<AlertDTO>();
        }
        return this.alertDtoArray;
    }

}
