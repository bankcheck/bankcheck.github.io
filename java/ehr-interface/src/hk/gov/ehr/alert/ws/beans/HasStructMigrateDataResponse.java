
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for hasStructMigrateData-response complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="hasStructMigrateData-response"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="migrateData" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "hasStructMigrateData-response", propOrder = {
    "migrateData"
})
public class HasStructMigrateDataResponse {

    protected boolean migrateData;

    /**
     * Gets the value of the migrateData property.
     * 
     */
    public boolean isMigrateData() {
        return migrateData;
    }

    /**
     * Sets the value of the migrateData property.
     * 
     */
    public void setMigrateData(boolean value) {
        this.migrateData = value;
    }

}
