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
	import flash.net.FileFilter;

	
	/**
	* Class OpenButton
	* Open Files 
	*	
	*
	* @version 1.9.5
	* 
	*/
	
	public class OpenButton extends MovieClip {
		
		/**
		* file
		*/
		private var myFile:File;


		private var mySimpleButton:SimpleButton;

		/**
		* Constructor
		*
		* Place button
		*
		*/
			
		public function OpenButton():void {
			
			// new Button
			mySimpleButton = new SimpleButton();
			
			// new States for this button
			var mySimpleButtonUpState:OpenButtonUpState = new OpenButtonUpState();
			
			// link state objects with button
			mySimpleButton.upState = mySimpleButtonUpState;
			mySimpleButton.downState = mySimpleButtonUpState;
			mySimpleButton.overState = mySimpleButtonUpState;
			mySimpleButton.hitTestState = mySimpleButtonUpState;
			
			// add to stage
			addChild (mySimpleButton);
			
			mySimpleButton.x = 300;
			mySimpleButton.y = 10;
			
			mySimpleButton.addEventListener(MouseEvent.CLICK, onClick)
		
		}
		



		/**
		* onClick
		*
		* ...
		*
		*/

		private function onClick(evt:MouseEvent):void {

			// new file (represents the file the user will choose)
			myFile = new File();

			var videoFilter:FileFilter = new FileFilter("Text", "*.flv;*.mp4");
			
			try  {

			        // call open dialog
			        myFile.browseForOpen("Bitte wählen Sie eine Datei", [videoFilter]);

			        // add event listener 
			        myFile.addEventListener(Event.SELECT, fileSelected);
			    }

			    catch (error:Error) {
			        trace(error.message);
			 }
			
			
		}


		private function fileSelected(event:Event):void {

		    // file in Variable abspeichern
		    var selectedFile:File = event.target as File;

			// new event
			var fileEvt:FileEvent = new FileEvent(FileEvent.NEW_FILE, true, true);
			
			// put nativepath into the event
			fileEvt.nativePath = selectedFile.nativePath;;
			
			// dispatch Event
			dispatchEvent(fileEvt);

		
		}
		


	}
}