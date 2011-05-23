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
package com.dynamobi.adminui.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.dynamobi.adminui.components.DebugWindow;
	import com.dynamobi.adminui.vo.OpenTableData;
	import com.dynamobi.adminui.view.InsertRowWindow;

	public class InsertRowEvent extends CairngormEvent
	{
		public var tablemetadata:OpenTableData;
		public var insertrowwindow:InsertRowWindow;
		
		public static var INSERTROW:String = "insertRow";
		
		public function InsertRowEvent(tablemd:OpenTableData, window:InsertRowWindow)
		{
			DebugWindow.log("InsertRowEvent.as:InsertRowEvent('" + tablemd.getTable() + "')");
			super(INSERTROW);
			tablemetadata = tablemd;
			insertrowwindow = window;
		}
	}
}