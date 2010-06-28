package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flexsqladmin.sqladmin.business.execSQLDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.ExecuteSQLEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.vo.QueryResultInfo;
	
	import mx.collections.XMLListCollection;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	
	public class ExecuteSQLCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
        private var sql:String = "";
		private var sqlquerytype:String = "";
        private var func:Function;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("ExecuteSQLCommand:execute()");
			model.exectimer.startTimer();
			sql = ExecuteSQLEvent(event).sql;
			sqlquerytype = ExecuteSQLEvent(event).sqlquerytype;
            func = ExecuteSQLEvent(event).func;
			var delegate:execSQLDelegate = new execSQLDelegate(this);
			delegate.execSQL(sql, sqlquerytype, model.tempConnectionVO);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("ExecuteSQLCommand.as:onResult()");
			//DebugWindow.log("Web Service Result\n" + event.result.toString());
			model.exectimer.stopTimer();
			
			var querycols:Array = new Array();
           	var datagridcols:Array = new Array();
			
            //trace(event.result);
			var queryxml:XML = new XML(event.result);
            if (sqlquerytype == "special") {
                func(queryxml);
                return;
            }
                
            try {
                model.query_results[VBox(model.main_tabnav.selectedChild).id].queryHistoryVO.writeHistory(sql, sqlquerytype);
            } catch(error:Error) {
                // make it default query window if it failed above
                model.main_tabnav.selectedIndex = model.main_tabnav.getChildIndex(model.main_tabnav.getChildByName("qw-1"));
                model.query_results[VBox(model.main_tabnav.selectedChild).id].queryHistoryVO.writeHistory(sql, sqlquerytype);
            }
            var result_info : QueryResultInfo = model.query_results[VBox(model.main_tabnav.selectedChild).id];
            result_info.showplanwindow.clearWindow();
			result_info.querydata = new XMLListCollection(queryxml.NewDataSet.Table);
			 
			if(sqlquerytype != "showplan")
                querycols = queryxml.datamap.split(",");
                
            for(var x:int; x < querycols.length; x++){
                var querycolumn:DataGridColumn = new DataGridColumn(querycols[x]);
                querycolumn.dataTipField = querycols[x];
                querycolumn.dataField = querycols[x];
               	querycolumn.editable = false;
                datagridcols.push(querycolumn);
            }
            
            result_info.querydatagrid.columns = datagridcols;
			
			if(queryxml.recordcount != ''){
                result_info.querymessages = queryxml.recordcount + " row(s) returned.  Execution time: " + queryxml.executiontime + " ms";
            } else {
                result_info.querymessages = "";
            } 
            
			DebugWindow.log("messages: " + result_info.querymessages);
            if((sqlquerytype == "showplan" || sqlquerytype == "spnormal") && queryxml.datamap.toString() != "Error"){
            	result_info.showplanwindow.drawPlan(queryxml);
            }
            //resetSelection();
		}
		public function onFault(event:*=null):void
		{
			DebugWindow.log("ExecuteSQLCommand.as:onFault()");
		}
	}
}