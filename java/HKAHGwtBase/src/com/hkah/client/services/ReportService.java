package com.hkah.client.services;

import java.util.Map;

import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;
@RemoteServiceRelativePath("reportservice")
public interface ReportService extends RemoteService{
	
	public String print(UserInfo ui, String prtName, Map<String, String> rptparam, String patcname, 
			String[] dbparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName, String[][] sub_dbparam, 
			String[][] sub_columnName, boolean[][] sub_isNumericColumn,
			int noOfCopies, boolean showPrintBox, boolean showPDF, boolean reversePageOrder, 
			String paperSize, String printPath, String fileName, String rptServer, String fileType);	
	
	public String print(UserInfo ui, String[] rptName, Map<String, Map<String, String>>map, String[] patcname, 
   			String[][] inParamArray, String[][] columnNameArray, boolean[] isNumericColumn,
   			Map<Integer, String[]>subRptNameMap, Map<Integer, String[][]> sub_dbParamMap, Map<Integer,String[][]> sub_colNameMap, 
   			Map<Integer, boolean[][]>isNumericColMap, int[] noOfCopies,
   			boolean showPrintBox, boolean showPDF, boolean reversePageOrder, 
   			String paperSize, String printPath, String fileName, String rptServer, String fileType);	
		
	public MessageQueue getDocFeeRptList(String path, String[] exts);
}