package com.hkah.web.db;

import java.text.*;
import java.util.*;
import com.hkah.web.common.*;
import com.hkah.util.db.*;

public class LabDB {
	public final static String QcDecimal = "4";
	public final static DecimalFormat QcFormat = new DecimalFormat("#.####");		
	
	public static boolean hasPermission(String user, String permission) {
		try  {		
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("select OF_PERMISSION@lis(?,?) from dual ");
			
			ArrayList<ReportableListObject> record =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ user, permission });	
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject)record.get(0);
			
				if ("1".equals(row.getValue(0))) {
					return true;
				} else {
					return false;
				}			
			} else {
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public static ReportableListObject getControlDetail(String testType, String cntlNum, String equipment, String intTcode) {
		ReportableListObject row = null; 
		
		try  {		
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("select s.cntl_name, s.lot_number, p.code, p.short_desc, n.range_hi, n.range_low, s.cntl_desc, t.test_desp, ");
			sqlStr.append(" (n.range_hi + n.range_low) / 2, (n.range_hi - n.range_low) / 4, ");
			sqlStr.append(" n.range_hi + (n.range_hi - n.range_low) / 4, n.range_low - (n.range_hi - n.range_low) / 4  ");
			sqlStr.append(" from labo_qc_norm@lis n ");
			sqlStr.append(" inner join labm_prices@lis p on n.int_tcode = p.int_tcode ");
			sqlStr.append(" inner join labo_qc_sample@lis s on s.test_type = n.test_type and s.cntl_num = n.cntl_num and s.equipment = n.equipment ");
			sqlStr.append(" inner join labm_testtype@lis t on s.test_type = t.test_type ");
			sqlStr.append(" where s.test_type = ? ");
			sqlStr.append(" and s.cntl_num = ? ");
			sqlStr.append(" and s.equipment = ? ");
			sqlStr.append(" and p.int_tcode = ? ");			
	
			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ testType, cntlNum, equipment, intTcode });
			
			if (record.size() > 0) {
				row = (ReportableListObject)record.get(0);
			}
					
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return row;
	}
	
	public static double calMean(ArrayList<Double> data) {	
		double mean = 0;
		
		try {		
			if (data.size() > 0) { 
				double sum = 0;
				
				for (double item: data) {
					sum += item;
				}
							
				mean = sum / data.size();								
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return  mean; 	
	}
	
	public static double calPopSD(ArrayList<Double> data) {	
		double sd = 0;
		
		try {
			if (data.size() > 0) {				
				double mean = calMean(data);
				double squaredDiffSum = 0;
				
				for (double item: data) {
					squaredDiffSum += Math.pow(item - mean, 2);
				}
							
				sd = Math.sqrt(squaredDiffSum / data.size());								
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return sd; 	
	}
	
	public static double calCV(ArrayList<Double> data) {	
		double cv = 0;
		
		try {
			double sd = calPopSD(data);
			double mean = calMean(data);
			cv = sd / mean * 100;
		} catch (Exception e) {
			e.printStackTrace();
		}		
		
		return cv;
	}
	
	public static double calRange(ArrayList<Double> data) {	
		double range = 0;
		
		try {
			if (data.size() > 0) {
				double min = data.get(0);
				double max = data.get(0);
				
				for (double item : data) {								
					if (item > max) {
						max = item;
					}
					if (item < min) {
						min = item;
					}
				}
				
				range = max - min;
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		
		return range;
	}
	
	public static double convertQcResult(String txtResult) {
		double result = 0;
		
		try {		
			if (txtResult != null) {
				//convert non-numeric qc result
				if (txtResult.startsWith(">=") || txtResult.startsWith("<=")) {
					// for >= and <= result
					result = Double.parseDouble(txtResult.substring(2).trim());	   					
				} else if (txtResult.startsWith(">") || txtResult.startsWith("<")) {
					// for > and < result
					result = Double.parseDouble(txtResult.substring(1).trim());	   						   			   					
				} else if (txtResult.startsWith("+") && txtResult.endsWith("+")) {
					// for +, ++, +++ result
					result = txtResult.length();	   		
				} else if (!txtResult.startsWith("+") && txtResult.endsWith("+")) {
					// for 1+, 2+, 3+, 4+ result
					result = Double.parseDouble(txtResult.substring(0, txtResult.indexOf("+")));
				} else if (txtResult.toUpperCase().startsWith("POS")) {
					// for positive result
					result = 1;
				} else if (txtResult.toUpperCase().startsWith("NEG")) {
					// for positive result
					result = 0;
				} else if (txtResult.toUpperCase().startsWith("TRACE")) {
					// for result = TRACE
					result = 0.5;
				} else if (txtResult.toUpperCase().startsWith("AB")) {
					// for blood group result AB, AB pos, AB neg etc
					result = 3;
				}else if (txtResult.toUpperCase().startsWith("A")) {
					// for blood group result A, A pos, A neg etc
					result = 2;
				}else if (txtResult.toUpperCase().startsWith("B")) {
					// for blood group result B, B pos, B neg etc
					result = 1;
				}else if (txtResult.toUpperCase().startsWith("O")) {
					// for blood group result O, O pos, O neg etc
					result = 0;
				} else {
					// numeric qc result
					result = Double.parseDouble(txtResult);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public static ReportableListObject getCalculatedQcResult(String testType, String cntlNum, String equipment, String intTcode, String frDate, String toDate) {
		ReportableListObject row = null; 
		
		try  {	
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("select count(*), count(status) ");
			sqlStr.append(" from labo_qc_result@lis ");
			sqlStr.append(" where test_type = ? ");
			sqlStr.append(" and cntl_num = ? ");
			sqlStr.append(" and equipment = ? ");
			sqlStr.append(" and int_tcode = ? ");
			sqlStr.append(" and seq_date >= ? ");
			sqlStr.append(" and seq_date <= ? ");
			
			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ testType, cntlNum, equipment, intTcode, frDate, toDate });
		
			if (record.size() > 0) {
				row = (ReportableListObject)record.get(0);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return row;
	}
	
	public static ArrayList<ReportableListObject> getQcRules(String testType, String equipment) {
		ArrayList<ReportableListObject> record = new ArrayList<ReportableListObject>();
		
		try  {	
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("select w.rule_num, w.rule_name, q.\"ON\" ");
			sqlStr.append(" from labm_qc_wgrules@lis w ");
			sqlStr.append(" inner join labm_qc_qcrules@lis q on w.rule_num = q.rule_num ");
			sqlStr.append(" inner join labm_testtype@lis t on q.discipline = t.qc ");
			sqlStr.append(" where test_type = ? ");
			sqlStr.append(" and equipment = ? ");
			sqlStr.append(" order by rule_num ");
			
			record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ testType, equipment });
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return record;
	}

	public static ArrayList<ReportableListObject> getSingleQcData(String testType, String cntlNum, String equipment, String intTcode, String frDate, String toDate) {
		ArrayList<ReportableListObject> record = new ArrayList<ReportableListObject>();
		
		try  {	
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("select substr(seq_date, 1, 4) || '-' || substr(seq_date, 5 , 2) || '-' || substr(seq_date, 7, 2) || '(' || dense_rank() over ( partition by seq_date order by seq_log )  || ')', ");
			sqlStr.append(" result, status, reason, rej_acc_by, ");
			sqlStr.append(" to_char(test_date, 'dd/mm/yyyy'), test_time, row_num ");
			sqlStr.append(" from labo_qc_result@lis r ");
			sqlStr.append(" where test_type = ? ");
			sqlStr.append(" and equipment = ? ");
			sqlStr.append(" and cntl_num = ? ");
			sqlStr.append(" and int_tcode = ? ");
			sqlStr.append(" and seq_date >= ? ");
			sqlStr.append(" and seq_date <= ? ");
			
			record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ testType, equipment, cntlNum, intTcode, frDate, toDate });
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return record;
	}

	public static ArrayList<ReportableListObject> getCommentTemplate(String commentType) {
		ArrayList<ReportableListObject> record = new ArrayList<ReportableListObject>();
		
		try  {
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("select notes from labm_func_notes@lis where comment_type = ? and notes is not null order by func_key ");
			
			record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{commentType});
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return record;
	}
	
	public static ReportableListObject getTestByIntTcode(String intTcode) {
		ReportableListObject row = null; 
		
		try {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append(" select code, short_desc ");
			sqlStr.append(" from labm_prices@lis ");
			sqlStr.append(" where int_tcode = ? ");
	
			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ intTcode });				
	
			if (record.size() > 0) {
				row = (ReportableListObject)record.get(0);
			}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		return row;
	}
	
	public static String getInstrumentName(String testType, String machno) {
		String instName = null; 
		
		try{		
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append(" select mach_desc || ' (' || mach_no || ')' ");
			sqlStr.append(" from labm_machine@lis ");
			sqlStr.append(" where mach_no = ? ");
			sqlStr.append(" and mach_type = ? ");
	
			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ machno, testType });
		
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject)record.get(0);
				instName = row.getValue(0);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}			
		
		return instName;
	}	
	
	public static boolean updateQcCommentStatus(String rownum, String comment, String user, String status) {
		try{		
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("update labo_qc_result@lis ");
			sqlStr.append(" set reason = ?, ");
			if ("accept".equals(status)) {
				sqlStr.append(" status = null, ");
			} else if ("reject".equals(status)) {
				sqlStr.append(" status = 'R', ");
			}
			sqlStr.append(" rej_acc_by = ? ");
			sqlStr.append(" where row_num = ? ");
		
			return UtilDBWeb.updateQueue( sqlStr.toString(), new String[] { comment, user, rownum } ); 
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}		
	}
	
	public static String addLeadingZero(String inStr) {
		try {
			if ((inStr != null) && (inStr.length() > 0) && (inStr.charAt(0) == '.')) {
				return "0" + inStr;
			}			
			return inStr;
			
		} catch (Exception e) {
			e.printStackTrace();
			return inStr;
		}
	}	
/*	Remove save calc function
 * 
	public static boolean updateQcNorm(String rangeHigh, String rangeLow, String cntlNum, String testType, String intTcode, String machno) {
		try{		
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("update labo_qc_norm@lis ");
			sqlStr.append(" set range_hi = ?, ");
			sqlStr.append(" range_low = ? ");
			sqlStr.append(" where cntl_num = ? ");
			sqlStr.append(" and test_type = ? ");
			sqlStr.append(" and int_tcode = ? ");
			sqlStr.append(" and equipment = ? ");
			
			return UtilDBWeb.updateQueue( sqlStr.toString(), new String[] { rangeHigh, rangeLow, cntlNum, testType, intTcode, machno });
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}		
	}
*/
}