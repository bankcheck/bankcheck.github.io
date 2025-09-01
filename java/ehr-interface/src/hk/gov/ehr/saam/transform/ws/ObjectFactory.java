
package hk.gov.ehr.saam.transform.ws;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the hk.gov.ehr.saam.transform.ws package. 
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

    private final static QName _GetAllergyRecordByPeriodRequest_QNAME = new QName("http://ehr.gov.hk/saam/transform/ws", "getAllergyRecordByPeriodRequest");
    private final static QName _GetAllergyRecordByPeriodResponse_QNAME = new QName("http://ehr.gov.hk/saam/transform/ws", "getAllergyRecordByPeriodResponse");
    private final static QName _GetAdrRecordByPeriodRequest_QNAME = new QName("http://ehr.gov.hk/saam/transform/ws", "getAdrRecordByPeriodRequest");
    private final static QName _GetAdrRecordByPeriodResponse_QNAME = new QName("http://ehr.gov.hk/saam/transform/ws", "getAdrRecordByPeriodResponse");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: hk.gov.ehr.saam.transform.ws
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link PatientRecordByPeriodRequest }
     * 
     */
    public PatientRecordByPeriodRequest createPatientRecordByPeriodRequest() {
        return new PatientRecordByPeriodRequest();
    }

    /**
     * Create an instance of {@link AllergyRecordResponse }
     * 
     */
    public AllergyRecordResponse createAllergyRecordResponse() {
        return new AllergyRecordResponse();
    }

    /**
     * Create an instance of {@link AdrRecordResponse }
     * 
     */
    public AdrRecordResponse createAdrRecordResponse() {
        return new AdrRecordResponse();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PatientRecordByPeriodRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/saam/transform/ws", name = "getAllergyRecordByPeriodRequest")
    public JAXBElement<PatientRecordByPeriodRequest> createGetAllergyRecordByPeriodRequest(PatientRecordByPeriodRequest value) {
        return new JAXBElement<PatientRecordByPeriodRequest>(_GetAllergyRecordByPeriodRequest_QNAME, PatientRecordByPeriodRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AllergyRecordResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/saam/transform/ws", name = "getAllergyRecordByPeriodResponse")
    public JAXBElement<AllergyRecordResponse> createGetAllergyRecordByPeriodResponse(AllergyRecordResponse value) {
        return new JAXBElement<AllergyRecordResponse>(_GetAllergyRecordByPeriodResponse_QNAME, AllergyRecordResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PatientRecordByPeriodRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/saam/transform/ws", name = "getAdrRecordByPeriodRequest")
    public JAXBElement<PatientRecordByPeriodRequest> createGetAdrRecordByPeriodRequest(PatientRecordByPeriodRequest value) {
        return new JAXBElement<PatientRecordByPeriodRequest>(_GetAdrRecordByPeriodRequest_QNAME, PatientRecordByPeriodRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AdrRecordResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/saam/transform/ws", name = "getAdrRecordByPeriodResponse")
    public JAXBElement<AdrRecordResponse> createGetAdrRecordByPeriodResponse(AdrRecordResponse value) {
        return new JAXBElement<AdrRecordResponse>(_GetAdrRecordByPeriodResponse_QNAME, AdrRecordResponse.class, null, value);
    }

}
