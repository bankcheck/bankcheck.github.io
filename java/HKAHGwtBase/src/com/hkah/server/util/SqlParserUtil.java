package com.hkah.server.util;

import gudusoft.gsqlparser.EDbVendor;
import gudusoft.gsqlparser.TBaseType;
import gudusoft.gsqlparser.TCustomSqlStatement;
import gudusoft.gsqlparser.TGSqlParser;
import gudusoft.gsqlparser.nodes.TJoin;
import gudusoft.gsqlparser.nodes.TJoinItem;
import gudusoft.gsqlparser.nodes.TResultColumn;
import gudusoft.gsqlparser.stmt.TSelectSqlStatement;

import java.util.ArrayList;
import java.util.List;

public class SqlParserUtil {
	public static List<String> getSqlColsDbOracle(String sqlString) {
		return getSqlCols(sqlString, EDbVendor.dbvoracle);
	}
	
	public static List<String> getSqlCols(String sqlString, EDbVendor eDbVendor) {
		List<String> ret = new ArrayList<String>();
		
		if (sqlString == null || sqlString.trim().isEmpty()) {
			return ret;
		}
		
		return getColsFromSelectStmt(sqlString, eDbVendor);
	}
	
	private static TGSqlParser parseSql(String stmt, EDbVendor eDbVendor) {
		TGSqlParser sqlparser = new TGSqlParser(eDbVendor);
		sqlparser.sqltext = stmt;
		return sqlparser;
	}
	
	private static List<String> getColsFromSelectStmt(String stmt, EDbVendor eDbVendor) {
		TGSqlParser sqlparser = parseSql(stmt, eDbVendor);
		List<String> cols = new ArrayList<String>();
		
		int ret = sqlparser.parse();
		if (ret == 0){
			for(int i=0;i<sqlparser.sqlstatements.size();i++){
				TSelectSqlStatement pStmt = null;
				try {
					pStmt = (TSelectSqlStatement) sqlparser.sqlstatements.get(i);
					cols.addAll(parseSelectStmtCols(pStmt));
				} catch (Exception e) {
					// not a valid select statement
					System.out.println("SqlParserUtil getColsFromSelectStmt: Not a valid select statement("+i+"): " + 
							sqlparser.sqlstatements.get(i));
				}
			}
		}else{
			System.out.println(sqlparser.getErrormessage());
		}
		return cols;
	}
	
	// Utils

    protected static void analyzeStmt(TCustomSqlStatement stmt){
        switch(stmt.sqlstatementtype){
            case sstselect:
                analyzeSelectStmt((TSelectSqlStatement)stmt);
                break;
            case sstupdate:
                break;
            case sstcreatetable:
                break;
            case sstaltertable:
                break;
            case sstcreateview:
                break;
            default:
                System.out.println(stmt.sqlstatementtype.toString());
        }
    }
    
    protected static List<String> parseSelectStmtCols(TSelectSqlStatement pStmt) {
    	List<String> ret = new ArrayList<String>();
    	
        System.out.println("\nSelect statement:");
        if (pStmt.isCombinedQuery()){
            String setstr="";
            switch (pStmt.getSetOperator()){
                case 1: setstr = "union";break;
                case 2: setstr = "union all";break;
                case 3: setstr = "intersect";break;
                case 4: setstr = "intersect all";break;
                case 5: setstr = "minus";break;
                case 6: setstr = "minus all";break;
                case 7: setstr = "except";break;
                case 8: setstr = "except all";break;
            }
            System.out.printf("set type: %s\n",setstr);
            System.out.println("left select:");
            ret.addAll(parseSelectStmtCols(pStmt.getLeftStmt()));
            System.out.println("right select:");
            ret.addAll(parseSelectStmtCols(pStmt.getRightStmt()));
        }else{
            //select list
            for(int i=0; i < pStmt.getResultColumnList().size();i++){
                TResultColumn resultColumn = pStmt.getResultColumnList().getResultColumn(i);
                System.out.printf("\tColumn: %s, Alias: %s\n",resultColumn.getExpr().toString(), (resultColumn.getAliasClause() == null)?"":resultColumn.getAliasClause().toString());
                ret.add( (resultColumn.getAliasClause() == null)?resultColumn.getExpr().toString():resultColumn.getAliasClause().toString());
            }
        }
        return ret;
    }

    protected static void analyzeSelectStmt(TSelectSqlStatement pStmt){
        System.out.println("\nSelect statement:");
        if (pStmt.isCombinedQuery()){
            String setstr="";
            switch (pStmt.getSetOperator()){
                case 1: setstr = "union";break;
                case 2: setstr = "union all";break;
                case 3: setstr = "intersect";break;
                case 4: setstr = "intersect all";break;
                case 5: setstr = "minus";break;
                case 6: setstr = "minus all";break;
                case 7: setstr = "except";break;
                case 8: setstr = "except all";break;
            }
            System.out.printf("set type: %s\n",setstr);
            System.out.println("left select:");
            analyzeSelectStmt(pStmt.getLeftStmt());
            System.out.println("right select:");
            analyzeSelectStmt(pStmt.getRightStmt());
            if (pStmt.getOrderbyClause() != null){
                System.out.printf("order by clause %s\n",pStmt.getOrderbyClause().toString());
            }
        }else{
            //select list
            for(int i=0; i < pStmt.getResultColumnList().size();i++){
                TResultColumn resultColumn = pStmt.getResultColumnList().getResultColumn(i);
                System.out.printf("\tColumn: %s, Alias: %s\n",resultColumn.getExpr().toString(), (resultColumn.getAliasClause() == null)?"":resultColumn.getAliasClause().toString());
            }

            //from clause, check this document for detailed information
            //http://www.sqlparser.com/sql-parser-query-join-table.php
            for(int i=0;i<pStmt.joins.size();i++){
                TJoin join = pStmt.joins.getJoin(i);
                switch (join.getKind()){
                    case TBaseType.join_source_fake:
                        System.out.printf("\ntable: \n\t%s, alias: %s\n",join.getTable().toString(),(join.getTable().getAliasClause() !=null)?join.getTable().getAliasClause().toString():"");
                        break;
                    case TBaseType.join_source_table:
                        System.out.printf("\ntable: \n\t%s, alias: %s\n",join.getTable().toString(),(join.getTable().getAliasClause() !=null)?join.getTable().getAliasClause().toString():"");
                        for(int j=0;j<join.getJoinItems().size();j++){
                            TJoinItem joinItem = join.getJoinItems().getJoinItem(j);
                            System.out.printf("Join type: %s\n",joinItem.getJoinType().toString());
                            System.out.printf("table: %s, alias: %s\n",joinItem.getTable().toString(),(joinItem.getTable().getAliasClause() !=null)?joinItem.getTable().getAliasClause().toString():"");
                            if (joinItem.getOnCondition() != null){
                                System.out.printf("On: %s\n",joinItem.getOnCondition().toString());
                            }else  if (joinItem.getUsingColumns() != null){
                                System.out.printf("using: %s\n",joinItem.getUsingColumns().toString());
                            }
                        }
                        break;
                    case TBaseType.join_source_join:
                        TJoin source_join = join.getJoin();
                        System.out.printf("\ntable: \n\t%s, alias: %s\n",source_join.getTable().toString(),(source_join.getTable().getAliasClause() !=null)?source_join.getTable().getAliasClause().toString():"");

                        for(int j=0;j<source_join.getJoinItems().size();j++){
                            TJoinItem joinItem = source_join.getJoinItems().getJoinItem(j);
                            System.out.printf("source_join type: %s\n",joinItem.getJoinType().toString());
                            System.out.printf("table: %s, alias: %s\n",joinItem.getTable().toString(),(joinItem.getTable().getAliasClause() !=null)?joinItem.getTable().getAliasClause().toString():"");
                            if (joinItem.getOnCondition() != null){
                                System.out.printf("On: %s\n",joinItem.getOnCondition().toString());
                            }else  if (joinItem.getUsingColumns() != null){
                                System.out.printf("using: %s\n",joinItem.getUsingColumns().toString());
                            }
                        }

                        for(int j=0;j<join.getJoinItems().size();j++){
                            TJoinItem joinItem = join.getJoinItems().getJoinItem(j);
                            System.out.printf("Join type: %s\n",joinItem.getJoinType().toString());
                            System.out.printf("table: %s, alias: %s\n",joinItem.getTable().toString(),(joinItem.getTable().getAliasClause() !=null)?joinItem.getTable().getAliasClause().toString():"");
                            if (joinItem.getOnCondition() != null){
                                System.out.printf("On: %s\n",joinItem.getOnCondition().toString());
                            }else  if (joinItem.getUsingColumns() != null){
                                System.out.printf("using: %s\n",joinItem.getUsingColumns().toString());
                            }
                        }

                        break;
                    default:
                        System.out.println("unknown type in join!");
                        break;
                }
            }

            //where clause
            if (pStmt.getWhereClause() != null){
                System.out.printf("\nwhere clause: \n\t%s\n", pStmt.getWhereClause().getCondition().toString());
            }

            // group by
            if (pStmt.getGroupByClause() != null){
                System.out.printf("\ngroup by: \n\t%s\n",pStmt.getGroupByClause().toString());
            }

            // order by
            if (pStmt.getOrderbyClause() != null){
              System.out.printf("\norder by:");
                for(int i=0;i<pStmt.getOrderbyClause().getItems().size();i++){
                    System.out.printf("\n\t%s",pStmt.getOrderbyClause().getItems().getOrderByItem(i).toString());

                }
            }

            // for update
            if (pStmt.getForUpdateClause() != null){
                System.out.printf("for update: \n%s\n",pStmt.getForUpdateClause().toString());
            }

            // top clause
            if (pStmt.getTopClause() != null){
                System.out.printf("top clause: \n%s\n",pStmt.getTopClause().toString());
            }

            // limit clause
            if (pStmt.getLimitClause() != null){
                System.out.printf("top clause: \n%s\n",pStmt.getLimitClause().toString());
            }
        }
    }
	
	/*
	public static void main(String[] args) {
		TGSqlParser sqlparser = new TGSqlParser(EDbVendor.dbvoracle);

		//sqlparser.sqltext = "select * from aa_query";
		int ret = sqlparser.parse();
		System.out.println("ret="+ret);
		if (ret == 0){
			for(int i=0;i<sqlparser.sqlstatements.size();i++){
				analyzeStmt(sqlparser.sqlstatements.get(i));
				
				System.out.println("");
			}
		}else{
			System.out.println(sqlparser.getErrormessage());
		}
	}
	*/
}
