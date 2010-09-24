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
package com.flexsqladmin.sqladmin.events
{
    import com.adobe.cairngorm.control.CairngormEvent;
    
    public class ObjectTreeLoaderEvent extends CairngormEvent {
        
        public static var OBJECT_TREE_LOADER:String = 'object_tree_loader';
        public var loadInfo:Object;
        public var parentNode:XML;

        public function ObjectTreeLoaderEvent(info:Object, parent:XML) {
            loadInfo = info;
            parentNode = parent;
            super(OBJECT_TREE_LOADER);
        }
    }
}