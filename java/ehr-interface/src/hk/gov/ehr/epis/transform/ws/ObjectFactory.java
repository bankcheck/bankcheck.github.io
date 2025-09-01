
package hk.gov.ehr.epis.transform.ws;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the hk.gov.ehr.epis.transform.ws package. 
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

    private final static QName _GetEpisRecordByPeriodRequest_QNAME = new QName("http://ehr.gov.hk/epis/transform/ws", "getEpisRecordByPeriodRequest");
    private final static QName _GetEpisRecordByPeriodResponse_QNAME = new QName("http://ehr.gov.hk/epis/transform/ws", "getEpisRecordByPeriodResponse");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: hk.gov.ehr.epis.transform.ws
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link EpisRecordByPeriodRequest }
     * 
     */
    public EpisRecordByPeriodRequest createEpisRecordByPeriodRequest() {
        return new EpisRecordByPeriodRequest();
    }

    /**
     * Create an instance of {@link EpisRecordResponse }
     * 
     */
    public EpisRecordResponse createEpisRecordResponse() {
        return new EpisRecordResponse();
    }

    /**
     * Create an instance of {@link EpisRecord }
     * 
     */
    public EpisRecord createEpisRecord() {
        return new EpisRecord();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link EpisRecordByPeriodRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/epis/transform/ws", name = "getEpisRecordByPeriodRequest")
    public JAXBElement<EpisRecordByPeriodRequest> createGetEpisRecordByPeriodRequest(EpisRecordByPeriodRequest value) {
        return new JAXBElement<EpisRecordByPeriodRequest>(_GetEpisRecordByPeriodRequest_QNAME, EpisRecordByPeriodRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link EpisRecordResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/epis/transform/ws", name = "getEpisRecordByPeriodResponse")
    public JAXBElement<EpisRecordResponse> createGetEpisRecordByPeriodResponse(EpisRecordResponse value) {
        return new JAXBElement<EpisRecordResponse>(_GetEpisRecordByPeriodResponse_QNAME, EpisRecordResponse.class, null, value);
    }

}
