/*
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
    
    public class PerformanceCommand implements Command, Responder {
        private var model:ModelLocator = ModelLocator.getInstance();
        
        private var counter_name:String;
        private var monitor:PerformanceMonitor;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("PerformanceCommand:execute()");
            counter_name = PerformanceEvent(event).counter_name;
            monitor = PerformanceEvent(event).monitor;

            var delegate:GeneralDelegate = new GeneralDelegate(this, 'PerformanceCountersService');
            
            if (counter_name == '')
                delegate.serviceDelegate('getAllPerformanceCounters');
            else
                delegate.serviceDelegate('findPerformanceCounterByName', {counterName: counter_name});
        }
        
        public function onResult(event:*=null) : void {
            var r:XML = new XML(event.result);
            monitor.addData(r, counter_name);
        }
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("PerformanceCommand:onFault()");
        }
    }
}