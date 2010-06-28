package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.business.handleUpdateDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.DeleteRowEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.view.OpenTableWindow;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.DataGrid;

	public class DeleteRowCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var tablemetadata:OpenTableData;
		private var deletesql:String;
		private var datagrid:DataGrid;
		private var tablewindow:OpenTableWindow;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("DeleteRowCommand.as:execute()");
			var deletestring:String = "";
			var checksqlstring:String = "";
			tablemetadata = DeleteRowEvent(event).tablemetadata;
			datagrid = DeleteRowEvent(event).datagrid;
			tablewindow = DeleteRowEvent(event).tablewindow;
			
			for (var x:int = 0; x < datagrid.selectedItem.children().length(); x++){
            	deletestring += "\"" + datagrid.columns[x].dataField + "\"";
            	if (datagrid.selectedItem.children()[x] == "<NULL>"){
            		deletestring += " IS NULL";
            	} else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "MONEY" || tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "SMALLMONEY"){
            		deletestring += " = " + datagrid.selectedItem.children()[x];
            	}else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "INTEGER"|| tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "BOOLEAN"){
            		deletestring += " = " + datagrid.selectedItem.children()[x]; 
            	}else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "DATE"){
            		deletestring += " = date'" + datagrid.selectedItem.children()[x] + "'"; 
            	}else {
            		deletestring += " = '" + datagrid.selectedItem.children()[x] + "'"; 
            	}
            	if (x + 1 < datagrid.selectedItem.children().length())
        			deletestring += " AND ";
            }
			
			var table:String = tablemetadata.getTable();
			var tableParts:Array = table.split(".");
			table = tableParts.join('"."');
			checksqlstring = "SELECT * FROM \"" + table + "\" WHERE " + deletestring;
			deletesql = "DELETE FROM \"" + table + "\" WHERE " + deletestring;
			
			DebugWindow.log("Delete String = " + deletesql);
			DebugWindow.log("Check String = " + checksqlstring);
			var delegate:handleUpdateDelegate = new handleUpdateDelegate(this);
			delegate.handleUpdate(deletesql, checksqlstring, model.connectionVO);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("DeleteRowCommand.as:onResult()");
			DebugWindow.log("DeleteRowCommand Data\n" + event.result.toString());
			var deleteresult:XML = new XML(event.result);
    		if(deleteresult.datamap == "Error"){
    			mx.controls.Alert.show(deleteresult.NewDataSet.Table.Error, "Delete Error");
    		} else{
                try {
                    model.query_results[VBox(model.main_tabnav.selectedChild).id].queryHistoryVO.writeHistory(deletesql, "");
                } catch(error:Error) {
                    model.query_results["qw-1"].queryHistoryVO.writeHistory(deletesql, "");
                }
    			tablewindow.refreshData();
        	}
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("DeleteRowCommand.as:onFault()");
		}
		
	}
}