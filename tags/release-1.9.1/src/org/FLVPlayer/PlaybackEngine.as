/*
FLV Flash Fullscreen Video Player 
Copyright (C) 2008, Florian Plag, www.video-flash.de

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
*/

package org.FLVPlayer { 

	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.video.*;
	import org.FLVPlayer.Param;
	import org.osflash.thunderbolt.Logger;
	import flash.system.*;
	

	
	/**
	  * Loads and handles the FLV Playback Engine.
	  *	The FLV Playback Engine is a swf file containing the flv playback component (instance name: myFLVPlayback)
	  *	and the flv playback captioning component (instance name: myFLVPlaybackCaptioning)
	  *
	  *	This class is loaded after the user clicks the playback button and handles the video playback.  
	  */
	
	public class PlaybackEngine extends MovieClip {
		
		/**
		* URL request
		*/
		private var request:URLRequest;			
		
		/**
		* loader
		*/
		private var loader:Loader; 					

			
		/**
		* Parameter Object
		*/
		public var _param:Param;					

		/**
		* reference to the player
		*/
		public var player:MovieClip;				
		
			
		/**
		* current state ("preRoll" or "mainVideo")
		*/
		private var currentState:String; 			

		/**
		* Constructor
		* Loads the externals swf file (which contains the components) 
		* @param targ    	target for the FLVPlayer MovieClip
		* @param p     		parameters from HTML/SWFObject
        */	
	
		public function PlaybackEngine (p:Param){
			
			
			// save param
			this._param = p;
			
			// external swf file with player
			request  = new URLRequest(_param.playerPath + "playbackengine.swf");
			loader = new Loader();
		
			// eventListeners
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fileNotFound);
			
			// start loading
			loader.load(request);
			
			// add to stage
			this.addChild(loader);
		}
		
		

		  /**
		  * loadComplete
		  * Save reference to player and init/play video 
		  *
		  * @param event   event from eventlistener 
		  *
		  */	
		private function loadComplete(event:Event):void {
			
		    trace("FLVPlayer complete");
			
			// reference to content movieclip
			this.player = loader.content as MovieClip;	
			
			// dispatch Event
			dispatchEvent(new Event("complete"));
			
			// init and play video
			this.initAndPlayVideo();


		}
		
		

		  /**
		  * initAndPlayVideo
		  *
		  * Prepares the components by setting the parameters and plays the video(s)
		  *  
		  */	
		  
		function initAndPlayVideo():void {
	
			// state change (error handling)
			//player.myFLVPlayback.addEventListener(VideoEvent.STATE_CHANGE, stateChange);	
	
			// no preroll (or preroll already played) -> load main video
			if ((_param.preRoll == null) || (this.currentState == "mainVideo")) {
					
				// set current state
				this.currentState = "mainVideo";
				
				if (this._param.video != null) {
					player.myFLVPlayback.play(_param.video);

				}
				else {
					dispatchEvent(new Event("videoNotFound"));
				}
				
				if (_param.loop == true) {
					player.myFLVPlayback.addEventListener(VideoEvent.COMPLETE, initLoop);
				}
				
				loadSkin();
				loadCaptions();
			}
			
			// else: load preroll
			else {
				
				// set current state
				this.currentState = "preRoll";
				
				player.myFLVPlayback.load(this._param.preRoll);
				player.myFLVPlayback.addEventListener(VideoEvent.COMPLETE, complete_listener_preRoll);
			}
			
			
			// set scale mode
			if (_param.autoScale == false) {
				player.myFLVPlayback.scaleMode = VideoScaleMode.EXACT_FIT;
				
				// set custom width and height
				player.myFLVPlayback.width = _param.videoWidth;
				player.myFLVPlayback.height = _param.videoHeight;
			}
			
			else {
				// just play because the autoscale is default
				player.myFLVPlayback.scaleMode = VideoScaleMode.NO_SCALE;
			}
			
			// start Video
			player.myFLVPlayback.play();

		}		

		
		
		/**
		* Check if captions file is turned on (and load if so)
		*/
		private function loadCaptions():void{
			
			// captions file not null?		
			if (this._param.captions != "") {
				
				// set captions file
				player.myFLVPlaybackCaptioning.source = this._param.captions;	
			}
			
			// else: do nothing
			
		}
		
		
		/**
		* Load skin and set skin color
		*/
		private function loadSkin():void {
			
			// load flv playback skin
			player.myFLVPlayback.skin = this._param.skin;			
		
			// set skin color
			player.myFLVPlayback.skinBackgroundColor = this._param.skinColor;	
			
			// set skin scale maximum
			player.myFLVPlayback.skinScaleMaximum = this._param.skinScaleMaximum;	
			
		}
		
		/**
		* 
		* Start main video after preroll
		*
		*/
		private function complete_listener_preRoll(evet:Event):void {
			
			// set current state
			this.currentState = "mainVideo";
			
			// remove Eventlistener
			player.myFLVPlayback.removeEventListener(VideoEvent.COMPLETE, complete_listener_preRoll);
			
			// start initAndPlay again
			this.initAndPlayVideo();
		}
		
		
		/**
		* 
		* Loop
		*
		*/
		private function initLoop(evet:Event):void {
			
			// start again
			player.myFLVPlayback.play();
		}
		
		
		
		/**
		  * file not found, dispatch event
		  *
		  */		
		private function fileNotFound(e:Event):void {
			trace ("error: file not found");
			dispatchEvent(new Event("fileNotFound"));
		}
		
		
		/**
		  * State change
		  *
		  */		
		private function stateChange(e:VideoEvent):void {
			
			// case: connectionError
			if (e.state == "connectionError") {
				
				if (this.currentState == "preRoll") {
					dispatchEvent(new Event("preRollNotFound"));
				}
				
				// video not found
				if (this.currentState == "mainVideo") {
					dispatchEvent(new Event("videoNotFound"));
				}				

			}
			
			if (e.state == "playing") {
				
				// main video
				if (this.currentState == "mainVideo") {

				}				
				
				
			}
			
		}
		
		
	}
}