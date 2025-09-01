
package hk.gov.ehr.alert.ws.beans;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the hk.gov.ehr.alert.ws.beans package. 
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

    private final static QName _GetPatientAdrRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAdrRequest");
    private final static QName _GetPatientAdrResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAdrResponse");
    private final static QName _GetPatientAdrLogRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAdrLogRequest");
    private final static QName _GetPatientAdrLogResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAdrLogResponse");
    private final static QName _GetExistingPatientAdrLogRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getExistingPatientAdrLogRequest");
    private final static QName _GetExistingPatientAdrLogResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getExistingPatientAdrLogResponse");
    private final static QName _GetPatientAllergyRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAllergyRequest");
    private final static QName _GetPatientAllergyResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAllergyResponse");
    private final static QName _GetPatientAllergyLogRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAllergyLogRequest");
    private final static QName _GetPatientAllergyLogResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAllergyLogResponse");
    private final static QName _GetExistingPatientAllergyLogRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getExistingPatientAllergyLogRequest");
    private final static QName _GetExistingPatientAllergyLogResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getExistingPatientAllergyLogResponse");
    private final static QName _GetPatientAlertRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAlertRequest");
    private final static QName _GetPatientAlertResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAlertResponse");
    private final static QName _HasMigrateDataRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "hasMigrateDataRequest");
    private final static QName _HasMigrateDataResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "hasMigrateDataResponse");
    private final static QName _HasStructuredMigrateDataRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "hasStructuredMigrateDataRequest");
    private final static QName _HasStructuredMigrateDataResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "hasStructuredMigrateDataResponse");
    private final static QName _HasFreeTextMigrateDataRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "hasFreeTextMigrateDataRequest");
    private final static QName _HasFreeTextMigrateDataResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "hasFreeTextMigrateDataResponse");
    private final static QName _GetPatientSummaryByPatientRefKeyRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientSummaryByPatientRefKeyRequest");
    private final static QName _GetPatientSummaryByPatientRefKeyResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientSummaryByPatientRefKeyResponse");
    private final static QName _GetPatientAllergyLogByPeriodRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAllergyLogByPeriodRequest");
    private final static QName _GetPatientAllergyLogByPeriodResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAllergyLogByPeriodResponse");
    private final static QName _GetPatientAdrLogByPeriodRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAdrLogByPeriodRequest");
    private final static QName _GetPatientAdrLogByPeriodResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientAdrLogByPeriodResponse");
    private final static QName _UpdatePatientAllergyRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "updatePatientAllergyRequest");
    private final static QName _UpdatePatientAllergyResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "updatePatientAllergyResponse");
    private final static QName _HandlePatientAlertRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "handlePatientAlertRequest");
    private final static QName _HandlePatientAlertResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "handlePatientAlertResponse");
    private final static QName _InsertNkdaRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "insertNkdaRequest");
    private final static QName _InsertNkdaResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "insertNkdaResponse");
    private final static QName _GetPatientLogRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientLogRequest");
    private final static QName _GetPatientLogResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "getPatientLogResponse");
    private final static QName _HandleLocalEMRDownloadPatientAdrAndAllergyRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "handleLocalEMRDownloadPatientAdrAndAllergyRequest");
    private final static QName _HandleLocalEMRDownloadPatientAdrAndAllergyResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "handleLocalEMRDownloadPatientAdrAndAllergyResponse");
    private final static QName _HandlePmiPatientLogUpdateRequest_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "handlePmiPatientLogUpdateRequest");
    private final static QName _HandlePmiPatientLogUpdateResponse_QNAME = new QName("http://ehr.gov.hk/alert/ws/beans", "handlePmiPatientLogUpdateResponse");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: hk.gov.ehr.alert.ws.beans
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link AdrRequest }
     * 
     */
    public AdrRequest createAdrRequest() {
        return new AdrRequest();
    }

    /**
     * Create an instance of {@link AdrResponse }
     * 
     */
    public AdrResponse createAdrResponse() {
        return new AdrResponse();
    }

    /**
     * Create an instance of {@link AdrLogRequest }
     * 
     */
    public AdrLogRequest createAdrLogRequest() {
        return new AdrLogRequest();
    }

    /**
     * Create an instance of {@link AdrLogResponse }
     * 
     */
    public AdrLogResponse createAdrLogResponse() {
        return new AdrLogResponse();
    }

    /**
     * Create an instance of {@link AllergyRequest }
     * 
     */
    public AllergyRequest createAllergyRequest() {
        return new AllergyRequest();
    }

    /**
     * Create an instance of {@link AllergyResponse }
     * 
     */
    public AllergyResponse createAllergyResponse() {
        return new AllergyResponse();
    }

    /**
     * Create an instance of {@link AllergyLogRequest }
     * 
     */
    public AllergyLogRequest createAllergyLogRequest() {
        return new AllergyLogRequest();
    }

    /**
     * Create an instance of {@link AllergyLogResponse }
     * 
     */
    public AllergyLogResponse createAllergyLogResponse() {
        return new AllergyLogResponse();
    }

    /**
     * Create an instance of {@link AlertRequest }
     * 
     */
    public AlertRequest createAlertRequest() {
        return new AlertRequest();
    }

    /**
     * Create an instance of {@link AlertResponse }
     * 
     */
    public AlertResponse createAlertResponse() {
        return new AlertResponse();
    }

    /**
     * Create an instance of {@link HasMigrateDataRequest }
     * 
     */
    public HasMigrateDataRequest createHasMigrateDataRequest() {
        return new HasMigrateDataRequest();
    }

    /**
     * Create an instance of {@link HasMigrateDataResponse }
     * 
     */
    public HasMigrateDataResponse createHasMigrateDataResponse() {
        return new HasMigrateDataResponse();
    }

    /**
     * Create an instance of {@link HasStructMigrateDataRequest }
     * 
     */
    public HasStructMigrateDataRequest createHasStructMigrateDataRequest() {
        return new HasStructMigrateDataRequest();
    }

    /**
     * Create an instance of {@link HasStructMigrateDataResponse }
     * 
     */
    public HasStructMigrateDataResponse createHasStructMigrateDataResponse() {
        return new HasStructMigrateDataResponse();
    }

    /**
     * Create an instance of {@link HasFreeMigrateDataRequest }
     * 
     */
    public HasFreeMigrateDataRequest createHasFreeMigrateDataRequest() {
        return new HasFreeMigrateDataRequest();
    }

    /**
     * Create an instance of {@link HasFreeMigrateDataResponse }
     * 
     */
    public HasFreeMigrateDataResponse createHasFreeMigrateDataResponse() {
        return new HasFreeMigrateDataResponse();
    }

    /**
     * Create an instance of {@link SummaryRequest }
     * 
     */
    public SummaryRequest createSummaryRequest() {
        return new SummaryRequest();
    }

    /**
     * Create an instance of {@link SummaryResponse }
     * 
     */
    public SummaryResponse createSummaryResponse() {
        return new SummaryResponse();
    }

    /**
     * Create an instance of {@link PatientLogByPeriodRequest }
     * 
     */
    public PatientLogByPeriodRequest createPatientLogByPeriodRequest() {
        return new PatientLogByPeriodRequest();
    }

    /**
     * Create an instance of {@link UpdatePatientAllergyRequest }
     * 
     */
    public UpdatePatientAllergyRequest createUpdatePatientAllergyRequest() {
        return new UpdatePatientAllergyRequest();
    }

    /**
     * Create an instance of {@link ResponseBean }
     * 
     */
    public ResponseBean createResponseBean() {
        return new ResponseBean();
    }

    /**
     * Create an instance of {@link HandlePatientAlertRequest }
     * 
     */
    public HandlePatientAlertRequest createHandlePatientAlertRequest() {
        return new HandlePatientAlertRequest();
    }

    /**
     * Create an instance of {@link InsertNkdaRequest }
     * 
     */
    public InsertNkdaRequest createInsertNkdaRequest() {
        return new InsertNkdaRequest();
    }

    /**
     * Create an instance of {@link InsertNkdaResponse }
     * 
     */
    public InsertNkdaResponse createInsertNkdaResponse() {
        return new InsertNkdaResponse();
    }

    /**
     * Create an instance of {@link LogRequest }
     * 
     */
    public LogRequest createLogRequest() {
        return new LogRequest();
    }

    /**
     * Create an instance of {@link LogResponse }
     * 
     */
    public LogResponse createLogResponse() {
        return new LogResponse();
    }

    /**
     * Create an instance of {@link LocalEMRDownloadRequestBean }
     * 
     */
    public LocalEMRDownloadRequestBean createLocalEMRDownloadRequestBean() {
        return new LocalEMRDownloadRequestBean();
    }

    /**
     * Create an instance of {@link LocalEMRDownloadResponseBean }
     * 
     */
    public LocalEMRDownloadResponseBean createLocalEMRDownloadResponseBean() {
        return new LocalEMRDownloadResponseBean();
    }

    /**
     * Create an instance of {@link PmiPatientLogUpdateRequestBean }
     * 
     */
    public PmiPatientLogUpdateRequestBean createPmiPatientLogUpdateRequestBean() {
        return new PmiPatientLogUpdateRequestBean();
    }

    /**
     * Create an instance of {@link PmiPatientLogUpdateResponseBean }
     * 
     */
    public PmiPatientLogUpdateResponseBean createPmiPatientLogUpdateResponseBean() {
        return new PmiPatientLogUpdateResponseBean();
    }

    /**
     * Create an instance of {@link AuditDTO }
     * 
     */
    public AuditDTO createAuditDTO() {
        return new AuditDTO();
    }

    /**
     * Create an instance of {@link AllergenDTO }
     * 
     */
    public AllergenDTO createAllergenDTO() {
        return new AllergenDTO();
    }

    /**
     * Create an instance of {@link ManifestBean }
     * 
     */
    public ManifestBean createManifestBean() {
        return new ManifestBean();
    }

    /**
     * Create an instance of {@link AdrCommonReactionDTO }
     * 
     */
    public AdrCommonReactionDTO createAdrCommonReactionDTO() {
        return new AdrCommonReactionDTO();
    }

    /**
     * Create an instance of {@link AdrDTO }
     * 
     */
    public AdrDTO createAdrDTO() {
        return new AdrDTO();
    }

    /**
     * Create an instance of {@link AdrLogDTO }
     * 
     */
    public AdrLogDTO createAdrLogDTO() {
        return new AdrLogDTO();
    }

    /**
     * Create an instance of {@link AdrStringLogDTO }
     * 
     */
    public AdrStringLogDTO createAdrStringLogDTO() {
        return new AdrStringLogDTO();
    }

    /**
     * Create an instance of {@link AllergyDTO }
     * 
     */
    public AllergyDTO createAllergyDTO() {
        return new AllergyDTO();
    }

    /**
     * Create an instance of {@link AllergyLogDTO }
     * 
     */
    public AllergyLogDTO createAllergyLogDTO() {
        return new AllergyLogDTO();
    }

    /**
     * Create an instance of {@link AllergyStringLogDTO }
     * 
     */
    public AllergyStringLogDTO createAllergyStringLogDTO() {
        return new AllergyStringLogDTO();
    }

    /**
     * Create an instance of {@link AlertDTO }
     * 
     */
    public AlertDTO createAlertDTO() {
        return new AlertDTO();
    }

    /**
     * Create an instance of {@link AlertStringLogDTO }
     * 
     */
    public AlertStringLogDTO createAlertStringLogDTO() {
        return new AlertStringLogDTO();
    }

    /**
     * Create an instance of {@link LogDTO }
     * 
     */
    public LogDTO createLogDTO() {
        return new LogDTO();
    }

    /**
     * Create an instance of {@link AdrTermDTO }
     * 
     */
    public AdrTermDTO createAdrTermDTO() {
        return new AdrTermDTO();
    }

    /**
     * Create an instance of {@link AllergyTermDTO }
     * 
     */
    public AllergyTermDTO createAllergyTermDTO() {
        return new AllergyTermDTO();
    }

    /**
     * Create an instance of {@link PmiPatientLogDTO }
     * 
     */
    public PmiPatientLogDTO createPmiPatientLogDTO() {
        return new PmiPatientLogDTO();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AdrRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAdrRequest")
    public JAXBElement<AdrRequest> createGetPatientAdrRequest(AdrRequest value) {
        return new JAXBElement<AdrRequest>(_GetPatientAdrRequest_QNAME, AdrRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AdrResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAdrResponse")
    public JAXBElement<AdrResponse> createGetPatientAdrResponse(AdrResponse value) {
        return new JAXBElement<AdrResponse>(_GetPatientAdrResponse_QNAME, AdrResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AdrLogRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAdrLogRequest")
    public JAXBElement<AdrLogRequest> createGetPatientAdrLogRequest(AdrLogRequest value) {
        return new JAXBElement<AdrLogRequest>(_GetPatientAdrLogRequest_QNAME, AdrLogRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AdrLogResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAdrLogResponse")
    public JAXBElement<AdrLogResponse> createGetPatientAdrLogResponse(AdrLogResponse value) {
        return new JAXBElement<AdrLogResponse>(_GetPatientAdrLogResponse_QNAME, AdrLogResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AdrLogRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getExistingPatientAdrLogRequest")
    public JAXBElement<AdrLogRequest> createGetExistingPatientAdrLogRequest(AdrLogRequest value) {
        return new JAXBElement<AdrLogRequest>(_GetExistingPatientAdrLogRequest_QNAME, AdrLogRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AdrLogResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getExistingPatientAdrLogResponse")
    public JAXBElement<AdrLogResponse> createGetExistingPatientAdrLogResponse(AdrLogResponse value) {
        return new JAXBElement<AdrLogResponse>(_GetExistingPatientAdrLogResponse_QNAME, AdrLogResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AllergyRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAllergyRequest")
    public JAXBElement<AllergyRequest> createGetPatientAllergyRequest(AllergyRequest value) {
        return new JAXBElement<AllergyRequest>(_GetPatientAllergyRequest_QNAME, AllergyRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AllergyResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAllergyResponse")
    public JAXBElement<AllergyResponse> createGetPatientAllergyResponse(AllergyResponse value) {
        return new JAXBElement<AllergyResponse>(_GetPatientAllergyResponse_QNAME, AllergyResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AllergyLogRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAllergyLogRequest")
    public JAXBElement<AllergyLogRequest> createGetPatientAllergyLogRequest(AllergyLogRequest value) {
        return new JAXBElement<AllergyLogRequest>(_GetPatientAllergyLogRequest_QNAME, AllergyLogRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AllergyLogResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAllergyLogResponse")
    public JAXBElement<AllergyLogResponse> createGetPatientAllergyLogResponse(AllergyLogResponse value) {
        return new JAXBElement<AllergyLogResponse>(_GetPatientAllergyLogResponse_QNAME, AllergyLogResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AllergyLogRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getExistingPatientAllergyLogRequest")
    public JAXBElement<AllergyLogRequest> createGetExistingPatientAllergyLogRequest(AllergyLogRequest value) {
        return new JAXBElement<AllergyLogRequest>(_GetExistingPatientAllergyLogRequest_QNAME, AllergyLogRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AllergyLogResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getExistingPatientAllergyLogResponse")
    public JAXBElement<AllergyLogResponse> createGetExistingPatientAllergyLogResponse(AllergyLogResponse value) {
        return new JAXBElement<AllergyLogResponse>(_GetExistingPatientAllergyLogResponse_QNAME, AllergyLogResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AlertRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAlertRequest")
    public JAXBElement<AlertRequest> createGetPatientAlertRequest(AlertRequest value) {
        return new JAXBElement<AlertRequest>(_GetPatientAlertRequest_QNAME, AlertRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AlertResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAlertResponse")
    public JAXBElement<AlertResponse> createGetPatientAlertResponse(AlertResponse value) {
        return new JAXBElement<AlertResponse>(_GetPatientAlertResponse_QNAME, AlertResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link HasMigrateDataRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "hasMigrateDataRequest")
    public JAXBElement<HasMigrateDataRequest> createHasMigrateDataRequest(HasMigrateDataRequest value) {
        return new JAXBElement<HasMigrateDataRequest>(_HasMigrateDataRequest_QNAME, HasMigrateDataRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link HasMigrateDataResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "hasMigrateDataResponse")
    public JAXBElement<HasMigrateDataResponse> createHasMigrateDataResponse(HasMigrateDataResponse value) {
        return new JAXBElement<HasMigrateDataResponse>(_HasMigrateDataResponse_QNAME, HasMigrateDataResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link HasStructMigrateDataRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "hasStructuredMigrateDataRequest")
    public JAXBElement<HasStructMigrateDataRequest> createHasStructuredMigrateDataRequest(HasStructMigrateDataRequest value) {
        return new JAXBElement<HasStructMigrateDataRequest>(_HasStructuredMigrateDataRequest_QNAME, HasStructMigrateDataRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link HasStructMigrateDataResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "hasStructuredMigrateDataResponse")
    public JAXBElement<HasStructMigrateDataResponse> createHasStructuredMigrateDataResponse(HasStructMigrateDataResponse value) {
        return new JAXBElement<HasStructMigrateDataResponse>(_HasStructuredMigrateDataResponse_QNAME, HasStructMigrateDataResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link HasFreeMigrateDataRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "hasFreeTextMigrateDataRequest")
    public JAXBElement<HasFreeMigrateDataRequest> createHasFreeTextMigrateDataRequest(HasFreeMigrateDataRequest value) {
        return new JAXBElement<HasFreeMigrateDataRequest>(_HasFreeTextMigrateDataRequest_QNAME, HasFreeMigrateDataRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link HasFreeMigrateDataResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "hasFreeTextMigrateDataResponse")
    public JAXBElement<HasFreeMigrateDataResponse> createHasFreeTextMigrateDataResponse(HasFreeMigrateDataResponse value) {
        return new JAXBElement<HasFreeMigrateDataResponse>(_HasFreeTextMigrateDataResponse_QNAME, HasFreeMigrateDataResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link SummaryRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientSummaryByPatientRefKeyRequest")
    public JAXBElement<SummaryRequest> createGetPatientSummaryByPatientRefKeyRequest(SummaryRequest value) {
        return new JAXBElement<SummaryRequest>(_GetPatientSummaryByPatientRefKeyRequest_QNAME, SummaryRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link SummaryResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientSummaryByPatientRefKeyResponse")
    public JAXBElement<SummaryResponse> createGetPatientSummaryByPatientRefKeyResponse(SummaryResponse value) {
        return new JAXBElement<SummaryResponse>(_GetPatientSummaryByPatientRefKeyResponse_QNAME, SummaryResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PatientLogByPeriodRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAllergyLogByPeriodRequest")
    public JAXBElement<PatientLogByPeriodRequest> createGetPatientAllergyLogByPeriodRequest(PatientLogByPeriodRequest value) {
        return new JAXBElement<PatientLogByPeriodRequest>(_GetPatientAllergyLogByPeriodRequest_QNAME, PatientLogByPeriodRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AllergyLogResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAllergyLogByPeriodResponse")
    public JAXBElement<AllergyLogResponse> createGetPatientAllergyLogByPeriodResponse(AllergyLogResponse value) {
        return new JAXBElement<AllergyLogResponse>(_GetPatientAllergyLogByPeriodResponse_QNAME, AllergyLogResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PatientLogByPeriodRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAdrLogByPeriodRequest")
    public JAXBElement<PatientLogByPeriodRequest> createGetPatientAdrLogByPeriodRequest(PatientLogByPeriodRequest value) {
        return new JAXBElement<PatientLogByPeriodRequest>(_GetPatientAdrLogByPeriodRequest_QNAME, PatientLogByPeriodRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AdrLogResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientAdrLogByPeriodResponse")
    public JAXBElement<AdrLogResponse> createGetPatientAdrLogByPeriodResponse(AdrLogResponse value) {
        return new JAXBElement<AdrLogResponse>(_GetPatientAdrLogByPeriodResponse_QNAME, AdrLogResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link UpdatePatientAllergyRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "updatePatientAllergyRequest")
    public JAXBElement<UpdatePatientAllergyRequest> createUpdatePatientAllergyRequest(UpdatePatientAllergyRequest value) {
        return new JAXBElement<UpdatePatientAllergyRequest>(_UpdatePatientAllergyRequest_QNAME, UpdatePatientAllergyRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ResponseBean }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "updatePatientAllergyResponse")
    public JAXBElement<ResponseBean> createUpdatePatientAllergyResponse(ResponseBean value) {
        return new JAXBElement<ResponseBean>(_UpdatePatientAllergyResponse_QNAME, ResponseBean.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link HandlePatientAlertRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "handlePatientAlertRequest")
    public JAXBElement<HandlePatientAlertRequest> createHandlePatientAlertRequest(HandlePatientAlertRequest value) {
        return new JAXBElement<HandlePatientAlertRequest>(_HandlePatientAlertRequest_QNAME, HandlePatientAlertRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ResponseBean }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "handlePatientAlertResponse")
    public JAXBElement<ResponseBean> createHandlePatientAlertResponse(ResponseBean value) {
        return new JAXBElement<ResponseBean>(_HandlePatientAlertResponse_QNAME, ResponseBean.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link InsertNkdaRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "insertNkdaRequest")
    public JAXBElement<InsertNkdaRequest> createInsertNkdaRequest(InsertNkdaRequest value) {
        return new JAXBElement<InsertNkdaRequest>(_InsertNkdaRequest_QNAME, InsertNkdaRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link InsertNkdaResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "insertNkdaResponse")
    public JAXBElement<InsertNkdaResponse> createInsertNkdaResponse(InsertNkdaResponse value) {
        return new JAXBElement<InsertNkdaResponse>(_InsertNkdaResponse_QNAME, InsertNkdaResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link LogRequest }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientLogRequest")
    public JAXBElement<LogRequest> createGetPatientLogRequest(LogRequest value) {
        return new JAXBElement<LogRequest>(_GetPatientLogRequest_QNAME, LogRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link LogResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "getPatientLogResponse")
    public JAXBElement<LogResponse> createGetPatientLogResponse(LogResponse value) {
        return new JAXBElement<LogResponse>(_GetPatientLogResponse_QNAME, LogResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link LocalEMRDownloadRequestBean }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "handleLocalEMRDownloadPatientAdrAndAllergyRequest")
    public JAXBElement<LocalEMRDownloadRequestBean> createHandleLocalEMRDownloadPatientAdrAndAllergyRequest(LocalEMRDownloadRequestBean value) {
        return new JAXBElement<LocalEMRDownloadRequestBean>(_HandleLocalEMRDownloadPatientAdrAndAllergyRequest_QNAME, LocalEMRDownloadRequestBean.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link LocalEMRDownloadResponseBean }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "handleLocalEMRDownloadPatientAdrAndAllergyResponse")
    public JAXBElement<LocalEMRDownloadResponseBean> createHandleLocalEMRDownloadPatientAdrAndAllergyResponse(LocalEMRDownloadResponseBean value) {
        return new JAXBElement<LocalEMRDownloadResponseBean>(_HandleLocalEMRDownloadPatientAdrAndAllergyResponse_QNAME, LocalEMRDownloadResponseBean.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PmiPatientLogUpdateRequestBean }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "handlePmiPatientLogUpdateRequest")
    public JAXBElement<PmiPatientLogUpdateRequestBean> createHandlePmiPatientLogUpdateRequest(PmiPatientLogUpdateRequestBean value) {
        return new JAXBElement<PmiPatientLogUpdateRequestBean>(_HandlePmiPatientLogUpdateRequest_QNAME, PmiPatientLogUpdateRequestBean.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link PmiPatientLogUpdateResponseBean }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ehr.gov.hk/alert/ws/beans", name = "handlePmiPatientLogUpdateResponse")
    public JAXBElement<PmiPatientLogUpdateResponseBean> createHandlePmiPatientLogUpdateResponse(PmiPatientLogUpdateResponseBean value) {
        return new JAXBElement<PmiPatientLogUpdateResponseBean>(_HandlePmiPatientLogUpdateResponse_QNAME, PmiPatientLogUpdateResponseBean.class, null, value);
    }

}
