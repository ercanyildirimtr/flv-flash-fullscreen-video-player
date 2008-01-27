/*
FLV Flash Fullscreen Video Player 
Copyright (C) 2008, Florian Plag, www.video-flash.de

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
*/

package org.FLVPlayer { 

	import org.FLVPlayer.*;
	import flash.display.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import org.osflash.thunderbolt.Logger;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.text.TextField;

	
	/**
	* Class FLVPlayer
	* Main application 
	*	
	*
	* @version 1.9.1
	* 
	*/
	
	public class FLVPlayer extends MovieClip {
		

		/**
		* Parameter
		*/		
		public var myParam:Param;
		
		
		/**
		* playback engine (with flv playback in it)
		*/
		private var myPlaybackEngine:PlaybackEngine;
		
		
		/**
		* preloader
		*/	
		private var myPreloader:Preloader;	
		
		
		/**
		* preview
		*/
		public var myPreview:Preview;	
		
		
		/**
		* button overlay
		*/
		private var myButtonOverlay:ButtonOverlay;
		
		
		/**
		* chrome / skin
		*/
		private var myChrome:Chrome;
		
		
		/**
		* timer for checking the status
		*/
		private var myTimer:Timer;
		
		/**
		* text field for error messages 
		*/
		private var errorMsg:TextField;




		/**
		* Constructor
		*
		* Does nothing at the moment
		*
		*/
			
		public function FLVPlayer():void {

		
		}


		/**
		* Get parameteres from flashvars (HTML/SWFObject)
		*
		* @param DisplayObject 	A DisplayObject, where the parameters are; Normally "root"
		*
		*/
			
		public function getFlashVars(myDisplayObject:DisplayObject):void {

			// new Param
			myParam = new Param();
			
			// call function that gets the flashvars
			myParam.setByFlashVars(myDisplayObject);
		
		}


		/**
		* Set the given param object as params for the player
		*
		*	@param Param 	Param Object
		*
		*/
			
		public function setParam(p:Param):void {

			// set Param
			myParam = p;
		
		}


			
		/**
		* start
		*
		* @param p Param (optional)		Parameter Object for the player
		*
		*/
				
		public function start(p:Param = null):void {
		
			if (p != null) {
				myParam = p;
			}

			// place text field for error messages
			placeErrorMsgTextField();

			// new Preloader
			myPreloader = new Preloader(myParam.preloader);
			myPreloader.addEventListener("fileNotFound", preloaderErrorHandling);
			this.addChild(myPreloader);
			myPreloader.x = 10;
			myPreloader.y = 10;

			// new preview
			if (myParam.preview != null) { 
				// preview available
				myPreview = new Preview(myParam.preview, myParam.autoScale, myParam.videoWidth, myParam.videoHeight);
			}
			else {
				// default preview 
				initDefaultPreview();
			}

			myPreview.addEventListener("fileNotFound", previewErrorHandling);


			// new button overlay
			myButtonOverlay = new ButtonOverlay(myParam.buttonOverlay);
			myButtonOverlay.addEventListener("fileNotFound", buttonOverlayErrorHandling);

			// new chrome
			myChrome = new Chrome(myParam.skin, myParam.skinColor);
			myChrome.addEventListener("fileNotFound", chromeErrorHandling);

			// check status (new Timer)
			myTimer = new Timer(200, 0);
			myTimer.addEventListener("timer", checkStatus);
			myTimer.start();		
			
			// trace to Firebug
			debug();

				
		}
		
		private function checkStatus(evt:TimerEvent):void {

			if ((myPreview.loadedComplete == true) && (myChrome.loadedComplete == true) && (myButtonOverlay.loadedComplete == true)) {

					myTimer.stop();

					// autoplay -> jump directly to "start video"
					if (myParam.autoPlay == true) {
						startVideo(new Event(""));
					}
					
					// show screen
					else {

						// add button overlay
						this.addChild(myButtonOverlay);

						// hide preloader, show buttonOverlay
						myPreloader.visible = false;

						// dispatch FLVPlayerResizeEvent (for Flex)
						var myFLVPlayerResizeEvent:FLVPlayerResizeEvent = new FLVPlayerResizeEvent(FLVPlayerResizeEvent.RESIZE, false, false);
						myFLVPlayerResizeEvent.width = myPreview.width;
						myFLVPlayerResizeEvent.height = myPreview.height;
						dispatchEvent(myFLVPlayerResizeEvent);

						// fade in preview
						this.addChild(myPreview);
						myPreview.alpha = 0;
						var previewTween:Tween = new Tween(myPreview,"alpha",Regular.easeOut,myPreview.alpha,100,35,true);

						// center playbutton and set onRelease
						myButtonOverlay.content.myPlaySymbol.centerButton(myPreview.width,myPreview.height);
						myButtonOverlay.content.myPlaySymbol.addEventListener (MouseEvent.MOUSE_UP, startVideo);

						// place chrome
						this.addChild(myChrome);
						myChrome.placeChrome(myPreview.width,myPreview.height);

						// swap depths
						this.swapChildren(myPreview, myPreloader);
						this.swapChildren(errorMsg, myPreview);
					
					}

			}
		}
		



		/*
		* Playback Engine is completely loaded
		*
		*/
		

		private function startVideo(e:Event) {

			if (myParam.autoPlay == false) {
				// remove all items
				removeChild(myPreview);
				removeChild(myChrome);
				removeChild(myButtonOverlay);
			}

			//show Preloader
			myPreloader.visible = true;

			//new playback engine
			myPlaybackEngine = new PlaybackEngine(myParam);

			// event listeners
			myPlaybackEngine.addEventListener ("fileNotFound", playbackEngineErrorHandling);
			myPlaybackEngine.addEventListener ("complete", playbackEngineComplete);
			myPlaybackEngine.addEventListener ("videoNotFound", videoFileErrorHandling);
			myPlaybackEngine.addEventListener ("preRollNotFound", preRollErrorHandling);

			// add to stage
			this.addChild(myPlaybackEngine);

		}



		/*
		* Playback Engine is completely loaded
		*
		*/

		private function playbackEngineComplete(evt:Event):void {

				// hide preloader
				myPreloader.visible = false;		

		}



		/*
		* Init default preview
		*
		*/

		private function initDefaultPreview() {
			myPreview = new Preview(myParam.getDefaultPreview(), myParam.autoScale, myParam.videoWidth, myParam.videoHeight);	
		}



		/*
		* Init default chrome
		*
		*/

		private function initDefaultChrome() {
			myParam.skin = myParam.defaultSkin;
			myChrome = new Chrome(myParam.skin, myParam.skinColor);
			myChrome.addEventListener("fileNotFound", chromeErrorHandling);

		}




		/**
		*	
		* place text field for error messages
		*	
		*/

		private function placeErrorMsgTextField():void {
			errorMsg = new TextField();
			addChild (errorMsg);
			errorMsg.width = 200;
			errorMsg.height = 60;
		}	
	

		/**
		*	
		* preview error handling
		*	
		* @param event
		*/

		private function previewErrorHandling(evt:Event):void {
			Logger.error ("Preview file could not be found, loading default preview");
			initDefaultPreview();
		}


		/**
		*	
		* chrome error handling
		*	
		* @param event
		*	
		*/

		private function chromeErrorHandling(evt:Event):void {

			if (myParam.skin != (myParam.defaultSkin) ) {
				Logger.error ("Custom skin file could not be found ... Loading default skin");
				initDefaultChrome();
			}
			else {
				Logger.error ("Default skin file could not be found!");
			}

		}



		/**
		*	
		* playback engine error handling
		*	
		* @param event
		*/

		private function playbackEngineErrorHandling(evt:Event):void {

			Logger.error ("Error: Playback Engine (playbackengine.swf) could not be found.");
			myPreloader.visible = false;

		}



		/**
		*	
		* video file not found error handling
		*	
		* @param event
		*/

		private function videoFileErrorHandling(evt:Event):void {

			Logger.error ("Error: Video file could not be found.");
			errorMsg.text = "Error: Video file could not be found.";
			myPreloader.visible = false;

		}


		/**
		*	
		* video file not found error handling
		*	
		* @param event
		*/

		private function preRollErrorHandling(evt:Event):void {

			Logger.error ("Error: Preroll file could not be found.");
			myPreloader.visible = false;

		}


		/**
		*	
		* button overlay file not found error handling
		*
		* @param event
		*/

		private function buttonOverlayErrorHandling(evt:Event):void {

			Logger.error ("Error: button overlay file could not be found.");
			myPreloader.visible = false;

		}


		/**
		* preloader file not found error handling
		*
		* @param event
		*/

		private function preloaderErrorHandling(evt:Event):void {

			Logger.error ("Error: preloader file could not be found.");

		}



		/**
		*	
		* debug: trace variables with ThunderBolt to Firebug
		*	
		*/

		private function debug():void {
				Logger.info("autoplay is: " + myParam.autoPlay );
				Logger.info("autoscale is: " + myParam.autoScale );
				Logger.info("buttonOverlay is: " + myParam.buttonOverlay);
				Logger.info("captions is: " + myParam.captions );
				Logger.info("content path is: " + myParam.contentPath );
				Logger.info("default skin is: " + myParam.defaultSkin);
				Logger.info("loop is: " + myParam.loop );
				Logger.info("loop is: " + myParam.loop );
				Logger.info("player path is: " + myParam.playerPath );
				Logger.info("postroll is: " + myParam.postRoll );
				Logger.info("preloader is: " + myParam.preloader);
				Logger.info("preroll is: " + myParam.preRoll );
				Logger.info("preview is: " + myParam.preview );
				Logger.info("skin is: " + myParam.skin);
				Logger.info("skin scale maximum is: " + myParam.skinScaleMaximum);
				Logger.info("skincolor is: " + myParam.skinColor);
				Logger.info("video is: " + myParam.video);
				Logger.info("videoheight is: " + myParam.videoHeight );
				Logger.info("videowidth is: " + myParam.videoWidth );
		}

		


	}
}