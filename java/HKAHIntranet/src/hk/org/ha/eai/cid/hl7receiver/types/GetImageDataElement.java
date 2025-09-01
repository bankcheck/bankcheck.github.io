/**
 * GetImageDataElement.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package hk.org.ha.eai.cid.hl7receiver.types;

public class GetImageDataElement  implements java.io.Serializable {
    private java.lang.String inHL7XML;

    public GetImageDataElement() {
    }

    public GetImageDataElement(
           java.lang.String inHL7XML) {
           this.inHL7XML = inHL7XML;
    }


    /**
     * Gets the inHL7XML value for this GetImageDataElement.
     * 
     * @return inHL7XML
     */
    public java.lang.String getInHL7XML() {
        return inHL7XML;
    }


    /**
     * Sets the inHL7XML value for this GetImageDataElement.
     * 
     * @param inHL7XML
     */
    public void setInHL7XML(java.lang.String inHL7XML) {
        this.inHL7XML = inHL7XML;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GetImageDataElement)) return false;
        GetImageDataElement other = (GetImageDataElement) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.inHL7XML==null && other.getInHL7XML()==null) || 
             (this.inHL7XML!=null &&
              this.inHL7XML.equals(other.getInHL7XML())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getInHL7XML() != null) {
            _hashCode += getInHL7XML().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GetImageDataElement.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://hl7receiver.cid.eai.ha.org.hk/types/", "getImageDataElement"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("inHL7XML");
        elemField.setXmlName(new javax.xml.namespace.QName("http://hl7receiver.cid.eai.ha.org.hk/types/", "inHL7XML"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
