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
	import flash.system.Capabilities;
	import flash.geom.*;

	
	/**
	* Class AIRApplication
	* Main application 
	*	
	*
	* @version 1.9.5
	* 
	*/
	
	public class AIRApplication extends MovieClip {
		

		/**
		* Parameter
		*/		
		public var myParam:Param;
		

		/**
		* FLVPlayer
		*/		
		public var myFLVPlayer:FLVPlayer;

		/**
		* AIRDragDrop
		*/		
		public var myDragDrop:AIRDragDrop;
		
		/**
		* OpenButton
		*/		
		public var myOpenButton:OpenButton;
		
		/**
		* dropZoneSymbol
		*/		
		public var myDropZoneSymbol:DropZoneSymbol;


		/**
		* Constructor
		*
		* Init application
		*
		*/
			
		public function AIRApplication():void {


			// create new player and add to stage
			myFLVPlayer = new FLVPlayer();
			addChild(myFLVPlayer);
			myFLVPlayer.x = 15;
			myFLVPlayer.y = 100;

			// new param objects
			myParam = new Param();


			// param 1
			myParam.contentPath = "";
			myParam.video = "demo-video.flv";
			myParam.preview = "demo-preview.jpg";
			myParam.skinColor = 0x333333;

			// start with first param
			myFLVPlayer.start(myParam);
			myFLVPlayer.visible = false;


			myDropZoneSymbol = new DropZoneSymbol();
			addChild (myDropZoneSymbol);
			myDropZoneSymbol.x = 15;
			myDropZoneSymbol.y = 100;
			
			// enable drag and drop
			myDragDrop = new AIRDragDrop();
			myDragDrop.setDropBox(myDropZoneSymbol);
			
			
			myDragDrop.addEventListener("new file", onNewFile);
			
			// new open Button
			myOpenButton = new OpenButton();
			addChild (myOpenButton);
			
			myOpenButton.addEventListener("new file", onNewFile);
		
		}


		/**
		* onNewFile
		*
		* ...
		*
		*/
			
		private function onNewFile(evt:FileEvent):void {

			myFLVPlayer.visible = true;
			
			// hide drop zone symbol
			myDropZoneSymbol.visible = false;
			myDragDrop.setDropBox(this);
			
			// param 1
			myParam.contentPath = "";
			
			// start video
			myParam.autoPlay = true;
			
			// mac os x?
		    if ( Capabilities.os.search("Mac") >= 0 ) {
				myParam.video = "file://" + evt.nativePath;
			} else {
				myParam.video = evt.nativePath;
			}
			

			// start with first param
			myFLVPlayer.updatePlayer(myParam);
		}


		/**
		* init window
		*
		* ...
		*
		*/		

		public function initWindow(window:NativeWindow):void {


		    // no scale for stage
		    stage.scaleMode = StageScaleMode.NO_SCALE;

		    // align top left
		    stage.align = "tl";

		    // windows title
		    window.title = "AIR FLV Player";

		    // maximale Größe des AIR Fensters festlegen
		    window.maxSize = new Point (1280, 740);

		    // minimale Größe des AIR Fensters festlegen
		    window.minSize = new Point (400, 300);

		}



	}
}