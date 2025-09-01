/*
 * Created on September 28, 2011
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.services;

import java.util.Map;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;

/**
 * The client side stub for the RPC service.
 */
@RemoteServiceRelativePath("fileioutilservice")
public interface FileIOUtilService extends RemoteService{
	public Map<Integer, String> getARCardName(String arcCard, String filePath);
	public Map<String, String> listFile(String filePath, String[] fileExts, boolean recursive);
}