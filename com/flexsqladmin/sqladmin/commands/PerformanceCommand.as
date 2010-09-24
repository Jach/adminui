/*
Dynamo Admin UI is a web service project for administering LucidDB
Copyright (C) 2010 Dynamo Business Intelligence Corporation

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version approved by Dynamo Business Intelligence Corporation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/
package com.flexsqladmin.sqladmin.commands
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.components.PerformanceMonitor;
    import com.flexsqladmin.sqladmin.events.PerformanceEvent;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    
    import mx.managers.CursorManager;
    
    public class PerformanceCommand implements Command, Responder {
        private var model:ModelLocator = ModelLocator.getInstance();
        
        private var counter_name:String;
        private var monitor:PerformanceMonitor;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("PerformanceCommand:execute()");
            counter_name = PerformanceEvent(event).counter_name;
            monitor = PerformanceEvent(event).monitor;

            var delegate:GeneralDelegate = new GeneralDelegate(this, 'PerformanceCountersService');
            
            if (counter_name == '') {
                CursorManager.setBusyCursor();
                delegate.serviceDelegate('getAllPerformanceCounters');
            } else if (counter_name.search(',') != -1) {
                delegate.serviceDelegate('getCountersByNames', {names: counter_name});
            } else {
                delegate.serviceDelegate('findPerformanceCounterByName', {counterName: counter_name});
            }
        }
        
        public function onResult(event:*=null) : void {
            var r:XML = new XML(event.result);
            monitor.addData(r, counter_name);
            CursorManager.removeBusyCursor();
        }
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("PerformanceCommand:onFault()");
        }
    }
}