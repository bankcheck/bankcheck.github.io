
package hk.gov.ehr.alert.ws.beans.download;

import javax.xml.bind.annotation.XmlRegistry;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the hk.gov.ehr.alert.ws.beans.download package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {


    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: hk.gov.ehr.alert.ws.beans.download
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link DownloadStatusDTO }
     * 
     */
    public DownloadStatusDTO createDownloadStatusDTO() {
        return new DownloadStatusDTO();
    }

    /**
     * Create an instance of {@link DownloadPatientDTO }
     * 
     */
    public DownloadPatientDTO createDownloadPatientDTO() {
        return new DownloadPatientDTO();
    }

    /**
     * Create an instance of {@link DownloadAdrDTO }
     * 
     */
    public DownloadAdrDTO createDownloadAdrDTO() {
        return new DownloadAdrDTO();
    }

    /**
     * Create an instance of {@link DownloadReactionDTO }
     * 
     */
    public DownloadReactionDTO createDownloadReactionDTO() {
        return new DownloadReactionDTO();
    }

    /**
     * Create an instance of {@link DownloadAllergyDTO }
     * 
     */
    public DownloadAllergyDTO createDownloadAllergyDTO() {
        return new DownloadAllergyDTO();
    }

    /**
     * Create an instance of {@link DownloadManifestDTO }
     * 
     */
    public DownloadManifestDTO createDownloadManifestDTO() {
        return new DownloadManifestDTO();
    }

    /**
     * Create an instance of {@link EhrPatientAdrAndAllergyDownloadResult }
     * 
     */
    public EhrPatientAdrAndAllergyDownloadResult createEhrPatientAdrAndAllergyDownloadResult() {
        return new EhrPatientAdrAndAllergyDownloadResult();
    }

}
