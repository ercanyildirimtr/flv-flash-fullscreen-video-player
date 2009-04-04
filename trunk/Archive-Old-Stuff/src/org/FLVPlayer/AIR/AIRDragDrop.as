/*
FLV Flash Fullscreen Video Player 
Copyright (C) 2008, Florian Plag, www.video-flash.de

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
*/

package org.FLVPlayer.AIR { 

	import org.FLVPlayer.*;
	import org.FLVPlayer.AIR.*;
	import flash.display.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import org.osflash.thunderbolt.Logger;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.filesystem.File;
	import flash.events.NativeDragEvent;
	import flash.desktop.*;
	import flash.system.*;

	
	/**
	* Class AIRDragDrop
	* Drag and Drop for Files 
	*	
	*
	* @version 1.9.5
	* 
	*/
	
	public class AIRDragDrop extends MovieClip {
		


		/**
		* dropBox (drop zone for files)
		*/		
		private var dropBox:MovieClip;
		
		
		/**
		* array with files
		*/		
		public var dropFiles:Array;



		/**
		* Constructor
		*
		* Does nothing at the moment
		*
		*/
			
		public function AIRDragDrop():void {

		
		}
		

		/**
		* setDropBox
		*
		* ...
		*
		*/
		
		public function setDropBox(mc:MovieClip):void {
			
			
			dropBox = mc;
			
			// add event listener
			dropBox.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDrag);
			dropBox.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDrop);
			
		}

		/**
		* onDrag
		*
		* ...
		*
		*/
		
		private function onDrag(evt:NativeDragEvent):void {

		        // accept dragging files on this object, you can see (+) 
		
				// get file extensions
		      	var fa:Object = evt.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
		
				var acceptDrag:Boolean;
		
				switch (fa[0].extension) { 
					
				  case "flv": 
				  acceptDrag = true;
				  break; 
				
				  case "mp4": 
				  acceptDrag = true;
				  break; 
				
				  case "mov": 
				  acceptDrag = true;
				  break;
				
				  default: 
				  acceptDrag = false;
				}
				
				// if true -> valid file extension
		        if(acceptDrag==true){
					// accept drag
	                NativeDragManager.acceptDragDrop(dropBox);
		        }				
		
		}


		/**
		* onDrop
		*
		* ...
		*
		*/

		private function onDrop(evt:NativeDragEvent):void {

		    // files als array abspeichern
		    dropFiles = evt.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
	
			// new event
			var fileEvt:FileEvent = new FileEvent(FileEvent.NEW_FILE, true, true);
			
			// put nativepath into the event
			fileEvt.nativePath = dropFiles[0].nativePath;
			
			// dispatch Event
			dispatchEvent(fileEvt);

		}



		


	}
}