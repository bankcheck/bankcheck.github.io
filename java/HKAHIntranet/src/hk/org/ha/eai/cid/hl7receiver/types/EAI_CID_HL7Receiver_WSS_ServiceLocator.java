/**
 * EAI_CID_HL7Receiver_WSS_ServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package hk.org.ha.eai.cid.hl7receiver.types;

public class EAI_CID_HL7Receiver_WSS_ServiceLocator extends org.apache.axis.client.Service implements hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSS_Service {

    public EAI_CID_HL7Receiver_WSS_ServiceLocator() {
    }


    public EAI_CID_HL7Receiver_WSS_ServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public EAI_CID_HL7Receiver_WSS_ServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for EAI_CID_HL7Receiver_WSSSoapHttpPort
    private java.lang.String EAI_CID_HL7Receiver_WSSSoapHttpPort_address = "https://eai-igw-hkp.ha.org.hk:32262/eai_reverseproxy/eai_common_receiver/receiver/cidhl7eai/upload";

    public java.lang.String getEAI_CID_HL7Receiver_WSSSoapHttpPortAddress() {
        return EAI_CID_HL7Receiver_WSSSoapHttpPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String EAI_CID_HL7Receiver_WSSSoapHttpPortWSDDServiceName = "EAI_CID_HL7Receiver_WSSSoapHttpPort";

    public java.lang.String getEAI_CID_HL7Receiver_WSSSoapHttpPortWSDDServiceName() {
        return EAI_CID_HL7Receiver_WSSSoapHttpPortWSDDServiceName;
    }

    public void setEAI_CID_HL7Receiver_WSSSoapHttpPortWSDDServiceName(java.lang.String name) {
        EAI_CID_HL7Receiver_WSSSoapHttpPortWSDDServiceName = name;
    }

    public hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSS_PortType getEAI_CID_HL7Receiver_WSSSoapHttpPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(EAI_CID_HL7Receiver_WSSSoapHttpPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getEAI_CID_HL7Receiver_WSSSoapHttpPort(endpoint);
    }

    public hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSS_PortType getEAI_CID_HL7Receiver_WSSSoapHttpPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSSSoapHttpPortBindingStub _stub = new hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSSSoapHttpPortBindingStub(portAddress, this);
            _stub.setPortName(getEAI_CID_HL7Receiver_WSSSoapHttpPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setEAI_CID_HL7Receiver_WSSSoapHttpPortEndpointAddress(java.lang.String address) {
        EAI_CID_HL7Receiver_WSSSoapHttpPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSS_PortType.class.isAssignableFrom(serviceEndpointInterface)) {
                hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSSSoapHttpPortBindingStub _stub = new hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSSSoapHttpPortBindingStub(new java.net.URL(EAI_CID_HL7Receiver_WSSSoapHttpPort_address), this);
                _stub.setPortName(getEAI_CID_HL7Receiver_WSSSoapHttpPortWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("EAI_CID_HL7Receiver_WSSSoapHttpPort".equals(inputPortName)) {
            return getEAI_CID_HL7Receiver_WSSSoapHttpPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://hl7receiver.cid.eai.ha.org.hk/types/", "EAI_CID_HL7Receiver_WSS");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://hl7receiver.cid.eai.ha.org.hk/types/", "EAI_CID_HL7Receiver_WSSSoapHttpPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("EAI_CID_HL7Receiver_WSSSoapHttpPort".equals(portName)) {
            setEAI_CID_HL7Receiver_WSSSoapHttpPortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
