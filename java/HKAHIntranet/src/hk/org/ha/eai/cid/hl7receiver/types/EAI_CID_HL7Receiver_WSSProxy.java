package hk.org.ha.eai.cid.hl7receiver.types;

public class EAI_CID_HL7Receiver_WSSProxy implements hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSS_PortType {
  private String _endpoint = null;
  private hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSS_PortType eAI_CID_HL7Receiver_WSS_PortType = null;
  
  public EAI_CID_HL7Receiver_WSSProxy() {
    _initEAI_CID_HL7Receiver_WSSProxy();
  }
  
  public EAI_CID_HL7Receiver_WSSProxy(String endpoint) {
    _endpoint = endpoint;
    _initEAI_CID_HL7Receiver_WSSProxy();
  }
  
  private void _initEAI_CID_HL7Receiver_WSSProxy() {
    try {
      eAI_CID_HL7Receiver_WSS_PortType = (new hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSS_ServiceLocator()).getEAI_CID_HL7Receiver_WSSSoapHttpPort();
      if (eAI_CID_HL7Receiver_WSS_PortType != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)eAI_CID_HL7Receiver_WSS_PortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)eAI_CID_HL7Receiver_WSS_PortType)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (eAI_CID_HL7Receiver_WSS_PortType != null)
      ((javax.xml.rpc.Stub)eAI_CID_HL7Receiver_WSS_PortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSS_PortType getEAI_CID_HL7Receiver_WSS_PortType() {
    if (eAI_CID_HL7Receiver_WSS_PortType == null)
      _initEAI_CID_HL7Receiver_WSSProxy();
    return eAI_CID_HL7Receiver_WSS_PortType;
  }
  
  public hk.org.ha.eai.cid.hl7receiver.types.GetImageDataResponseElement getImageData(hk.org.ha.eai.cid.hl7receiver.types.GetImageDataElement getImageDataElement) throws java.rmi.RemoteException{
    if (eAI_CID_HL7Receiver_WSS_PortType == null)
      _initEAI_CID_HL7Receiver_WSSProxy();
    return eAI_CID_HL7Receiver_WSS_PortType.getImageData(getImageDataElement);
  }
  
  
}