package com.flexsqladmin.sqladmin.business
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.business.ServiceLocator;
    import com.flexsqladmin.sqladmin.business.Services;
    import com.flexsqladmin.sqladmin.commands.TableDetailsCommand;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.soap.mxml.WebService;

   public class tableDetailsDelegate
    {

       private var responder:Responder;
       private var service:WebService;

       private var model:ModelLocator = ModelLocator.getInstance();
       
       public function tableDetailsDelegate(r:Responder) {
           DebugWindow.log("tableDetailsDelegate.as:tableDetailsDelegate()");
           service = ServiceLocator.getInstance().getService("TableDetailsService") as WebService;
           model.tempConnectionVO.setHttpHeaders(service);
           responder = r;
       }
        
       public function getTableDetails(cat:String, schema:String, table:String) : void {
           DebugWindow.log("tableDetailsDelegate.as:getTableDetails()");
           var o:AbstractOperation = service.getOperation("getTableDetails");
           o.arguments.table = table;
           o.arguments.schema = schema;
           o.arguments.catalog = cat;
           var token:AsyncToken = service.getTableDetails();
           token.resultHandler = responder.onResult;
           token.faultHandler = responder.onFault;
       }
       
       public function postTableDetails(cat:String, schema:String, table:String, details:XML) : void {
           // TODO: get rid of the hardcoded url in here.
           DebugWindow.log("shiiiitableDetailsDelegate.as:postTableDetails()");
           service.postTableDetails.request = XMLList(
               "<ns0:postTableDetails xmlns:ns0=\"http://api.ws.dynamobi.com/\">" +
               "<catalog>" + cat + "</catalog>" +
               "<schema>" + schema + "</schema>" +
               "<table>" + table + "</table>" +
               details +
               "</ns0:postTableDetails>"
               );
           var o:AbstractOperation = service.getOperation("postTableDetails");
           var token:AsyncToken = service.postTableDetails();
           token.resultHandler = responder.onResult;
           token.faultHandler = responder.onFault;
       }
   
   }
}