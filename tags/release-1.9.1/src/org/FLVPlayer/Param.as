/*
FLV Flash Fullscreen Video Player 
Copyright (C) 2008, Florian Plag, www.video-flash.de

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
*/

package org.FLVPlayer {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;	
	
	/**
	* The Param class handles the input parameteres from the URL/HTML/SWFObject
	* It also checks the parameters and sets default values 
	*	
	*	@version 1.9.1
	*/
	
	public class Param {
		
		
		/**
		* URL of the video file
		* 
		* @example /videos/myvideo.flv
		* @example http://www.video-flash.de/myvideo.flv
		*
		* @default 
		*/
		private var _video:String;			

		
		/**
		* URL of the skin file
		* (If the property "playerPath" is set, the URL is relative to the player path.)
		*
		* @example /skins/myskin.swf
		* @example http://www.video-flash.de/myskin.swf
		*
		* @see #playerpath
		*/	
		private var _skin:String;
		
		
		/**
		* Skin scale maximum (fullscreen mode only)
		* 
		*
		* @example 2
		*
		* @default 4
		*
		*/	
		private var _skinScaleMaximum:Number;

	
		/**
		* URL of the default skin file
		*
		*/	
		private var _defaultSkin:String;	
		
		
		
		/**
		* Skin color in Hex values; works only, if the skins is enabled for changing its color
		* 
		* @example 0xFF0000
		*
		* @default DEFAULT_SKIN_COLOR
		*/	
		private var _skinColor:uint;
		
		/**
		* URL of the config file (xml) that contains the parameters  
		*
		* 
		* @example configfile.xml
		* @example http://www.video-flash.de/configfile.xml
		*
		* @default 
		*/	
		//private var _configFile:String;		
		
		/**
		* URL of the preview file (jpg, gif, png, swf) that should displayed as preview screen  
		* (If the property "contentPath" is set, the URL is relative to the content path.)
		*
		* 
		* @example mypreview.jpg
		* @example http://www.video-flash.de/mypreview.jpg
		*
		* @default 
		*/	
		private var _preview:String;			// preview (jpg, gif, png, swf)

		
		
		/**
		* URL or path to all the files that belong to the player (Player SWF files and Skin files)  
		* Note: Don't place a Slash at the end, this is automatically added! 
		*
		* @example stuff/flvplayerfiles
		*
		* @default Default is ""
		*
		* @see #skin
		*/		
		private var _playerPath:String;	
		
		
		/**
		* URL or path to all the files that belong to the content (video, preview, preroll, postroll and captions files)  
		* Note: Don't place a Slash at the end, this is automatically added! 
		*
		* @example content/videos
		*
		* @default Default is ""
		*
		* @see #video
		* @see #preview
		* @see #captions
		* @see #preroll
		*/
		private var _contentPath:String;
		
		
		
		/**
		* If set to true, the video starts immediatelly and no preview is displayed 
		*
		* @default false
		*
		*/	
		private var _autoPlay:Boolean;
		
		
		/**
		* If set to true, the video scales, the preview as well as the video are scaled automatically to their native dimensions
		* If no preview is available, the default preview and its size are taken.
		* 
		* If set to false, the preview as well as the video are scaled to the properties "videoWidth" and "videoHeight".
		*
		* @default true
		*
		* @see #videoWidth
		* @see #videoHeight
		*/			
		private var _autoScale:Boolean;
		
		
		
		/**
		* 
		* Width in pixel; video and preview are scaled to this width, but only if autoScale is set to false
		* 
		* @default 320
		*
		* @see #autoScale
		* @see #videoHeight
		*/					
		private var _videoWidth:Number;		
		
		
		/**
		* 
		* Height in pixel; video and preview are scaled to this height, but only if autoScale is set to false
		* 
		* @default 240
		*
		* @see #autoScale
		* @see #videoWidth
		*/			
		private var _videoHeight:Number;		// height of the video

		
		/**
		* 
		* preroll file
		* 
		* @default 
		*
		*/					
		private var _preRoll:String;			// name of the preroll file
		
		
		
		/**
		* 
		* URL of the preloader file
		* 
		* @default 
		*
		*/					
		private var _preloader:String;
		
	
		/**
		* 
		* URL of the buttonoverlay file
		* 
		* @default 
		*
		*/					
		private var _buttonOverlay:String;
		
		
		/**
		* 
		* captions
		* 
		*
		*/
		private var _captions:String;			// name of the captionsf file


		/**
		* 
		* captions
		* 
		*
		*/
		private var _loop:Boolean;

		// currently not used:
		private var _postRoll:String;

		/**
		* 
		* Constants
		* 
		*
		*/
		private static var DEFAULT_AUTO_PLAY:Boolean = false;
		private static var DEFAULT_AUTO_SCALE:Boolean = true;	
		private static var DEFAULT_BUTTON_OVERLAY_FILENAME:String = "buttonOverlay.swf";
		private static var DEFAULT_CONTENT_PATH:String = "";
		private static var DEFAULT_LOOP:Boolean = false;	
		private static var DEFAULT_PLAYER_PATH:String = "";		
		private static var DEFAULT_PRELOADER_FILENAME:String = "preloader.swf";
		private static var DEFAULT_PREVIEW_FILENAME:String = "defaultpreview.jpg";
		private static var DEFAULT_SKIN_COLOR:uint = 0x555555;
		private static var DEFAULT_SKIN_FILENAME:String = "defaultskin.swf";
		private static var DEFAULT_SKIN_SCALE_MAXIMUM:Number = 4.5;
	
		
					
			/**
			* Constructor; does do anything at the moment
			*
			*/
			public function Param() {

				playerPath = null;	
				contentPath = null;
							
				autoPlay = DEFAULT_AUTO_PLAY;
				autoScale = DEFAULT_AUTO_SCALE;
				buttonOverlay = null;
				captions = null;
				defaultSkin = playerPath + DEFAULT_SKIN_FILENAME;		
				loop = DEFAULT_LOOP;
				preloader = null;
				preRoll = null;
				preview = null;
				skin = null;
				skinColor = DEFAULT_SKIN_COLOR;
				skinScaleMaximum = DEFAULT_SKIN_SCALE_MAXIMUM;
				video = null;
				videoHeight = NaN;
				videoWidth = NaN;
				

			}




			/**
			* This function gets the parameters from HTML/SWFObject/URL. They are saved into variables.
			*
			* @param base	A DisplayObject, where the parameters are; Normally "root"
			*/
			public function setByFlashVars(base:DisplayObject) {

				playerPath = base.loaderInfo.parameters.playerpath;	
				contentPath = base.loaderInfo.parameters.contentpath;
							
				autoPlay = changeParamToBoolean(base.loaderInfo.parameters.autoplay, DEFAULT_AUTO_PLAY);
				autoScale = changeParamToBoolean(base.loaderInfo.parameters.autoscale, DEFAULT_AUTO_SCALE);
				buttonOverlay = base.loaderInfo.parameters.buttonoverlay;
				captions = base.loaderInfo.parameters.captions;
				defaultSkin = playerPath + DEFAULT_SKIN_FILENAME;		
				loop = base.loaderInfo.parameters.loop;
				postRoll = base.loaderInfo.parameters.postroll;
				preloader = base.loaderInfo.parameters.preloader;
				preRoll = base.loaderInfo.parameters.preroll;
				preview = base.loaderInfo.parameters.preview;
				skin = base.loaderInfo.parameters.skin;
				skinColor = changeParamTo_uint(base.loaderInfo.parameters.skincolor, DEFAULT_SKIN_COLOR);
				skinScaleMaximum = changeParamToNumber(base.loaderInfo.parameters.skinscalemaximum);
				video = base.loaderInfo.parameters.video;
				videoHeight = changeParamToNumber(base.loaderInfo.parameters.videoheight);
				videoWidth = changeParamToNumber(base.loaderInfo.parameters.videowidth);

	
			}



			/**
			* set the path to all the player files
			* @param  arg      String
			*/
	
			public function set playerPath( arg:String ) : void { 
				
				if ((arg != null) && (arg != "")) {
					_playerPath = arg + "/"; 
				}
				else {

					_playerPath = DEFAULT_PLAYER_PATH;
				}
								
			}
			

			public function get playerPath():String { 
				return _playerPath; 
			}




			/**
			* set the path to all the content files (video, captions, preroll, ...)
			* @param  arg      String
			*/
	
			public function set contentPath( arg:String ) : void { 

					if ((arg != null) && (arg != "")) {
						_contentPath = arg + "/"; 
					}
					else {

						_contentPath = DEFAULT_CONTENT_PATH;
					}

				}
			

			public function get contentPath():String { 
				return _contentPath; 
			}


			/**
			* set the filename of the video file
			* @param  arg      String
			*/
			public function set video( arg:String ) : void { 
				
				if ((arg != null) && (arg != "")) {
					_video = contentPath + arg; 
				}
				else {
					_video = null;
				}
			}
	
			public function get video() : String { 
				return _video; 
			}



			/**
			* set the filename of the preview file (jpg, swf, gif, png)
			* @param  arg      String
			*/

			public function set preview( arg:String ) : void { 
				
				if ((arg != null) && (arg != "")) {
					_preview = contentPath + arg; 
				}
				else {
					_preview = playerPath + DEFAULT_PREVIEW_FILENAME;
				}
			}
	
			public function get preview() : String { 
				return _preview; 
			}


			/**
			* get Default preview
			*	
			*/
			
			public function getDefaultPreview() : String { 
				return playerPath + DEFAULT_PREVIEW_FILENAME;
			}			

			

			/**
			* set the filename of the skin file
			* @param  arg      String
			*/

			public function set skin( arg:String ) : void { 
			
		
				if ((arg != null) && (arg != "")) {
					_skin = playerPath + arg; 
				}
				else {
					_skin = defaultSkin;
				}
			}

			public function get skin() : String { 
				return _skin; 
			}
			
			
			/**
			* set the filename of the skin file
			* @param  arg      String
			*/

			public function set defaultSkin( arg:String ) : void { 
				_defaultSkin = arg;
			}

			public function get defaultSkin() : String { 
				return _defaultSkin; 
			}			


			/**
			* set the skin color
			* @param  arg      uint
			*/
	
	
			public function set skinColor( arg:uint ) : void { 
				_skinColor = arg; 
			}
			
			
			public function get skinColor() : uint { 
				return _skinColor; 
			}

			
			
			/**
			* set skinScaleMaximum
			* @param  arg      String
			*/

			public function set skinScaleMaximum( arg:Number ) : void { 
				if (isNaN(arg) == false) { 
					_skinScaleMaximum = arg;
				}
				else {
					_skinScaleMaximum = DEFAULT_SKIN_SCALE_MAXIMUM;
				}
			}

			public function get skinScaleMaximum() : Number { 
				return _skinScaleMaximum; 
			}		
			
		
			



			
			/**
			* set the loop parameter (true or false)
			* @param  arg      Boolean
			*/
	
			public function set loop( arg:Boolean ) : void { 

				_loop = arg; 

			}
			

			public function get loop():Boolean { 
				return _loop; 
			}


			
			/**
			* set the autoplay parameter (true or false)
			* @param  arg      Boolean
			*/
	
			public function set autoPlay( arg:Boolean ) : void { 
				_autoPlay = arg; 

			}
			

			public function get autoPlay():Boolean { 
				return _autoPlay; 
			}


			/**
			* set the autoscale parameter (true or false)
			* @param  arg      Boolean
			*/
	
			public function set autoScale( arg:Boolean ) : void { 
				_autoScale = arg; 
			}
			

			public function get autoScale():Boolean { 
				return _autoScale; 
			}


			/**
			* set the preroll clip
			* @param  arg      String
			*/	
	
			public function set preRoll( arg:String ) : void { 
				if ((arg != null) && (arg != "")) {
					_preRoll = contentPath + arg; 
				}
				else {

					_preRoll = null;
				}
			}
			
			public function get preRoll() : String { 
				return _preRoll; 
			}

			/**
			* set the postroll clip
			* @param  arg      String
			*/
			
			public function set postRoll( arg:String ) : void { 
				if ((arg != null) && (arg != "")) {
					_postRoll = arg; 
				}
				else {

					_postRoll = null;
				}
			}
			
			public function get postRoll() : String { 
				return _postRoll; 
			}
			
			/**
			* set a captions file
			* @param  arg      String
			*/
			
			public function set captions( arg:String ) : void { 
				if ((arg != null) && (arg != "")) {
					_captions = contentPath + arg; 
				}
				else {

					_captions = null;
				}
			}
			
			public function get captions() : String { 
				return _captions; 
			}
	
	
			/**
			* set videoWidth
			* @param  arg      String
			*/	
	
			public function set videoWidth( arg:Number ) : void { 
				_videoWidth = arg; 
			}
			
			public function get videoWidth() : Number { 
				return _videoWidth; 
			}	
			

		
			/**
			* set videoHeight
			* @param  arg      String
			*/	
	
			public function set videoHeight( arg:Number ) : void { 
				_videoHeight = arg; 
			}
			
			public function get videoHeight() : Number { 
				return _videoHeight; 
			}	
			
	
	
			/**
			* set the filename of the preloader file (swf)
			* @param  arg      String
			*	
			* @default String	"DEFAULT_PRELOADER_FILENAME"
			*/

			public function set preloader( arg:String ) : void { 
				
				if ((arg != null) && (arg != "")) {
					_preloader = playerPath + arg; 
				}
				else {
					_preloader = playerPath + DEFAULT_PRELOADER_FILENAME;
				}
			}
			
			public function get preloader() : String { 
				return _preloader; 
			}
			
			

			/**
			* set the filename of the buttonoverlay file (swf)
			* @param  arg      String
			*	
			*	*@default String	DEFAULT_BUTTON_OVERLAY_FILENAME
			*/

			public function set buttonOverlay( arg:String ) : void { 
		
				if ((arg != null) && (arg != "")) {
					_buttonOverlay = playerPath + arg; 
				}
				else {
					_buttonOverlay = playerPath + DEFAULT_BUTTON_OVERLAY_FILENAME;
				}
			}
			
	
			public function get buttonOverlay() : String { 
				return _buttonOverlay; 
			}
	
	
	
			/**
			* This function converts the incoming String to a Number
			* @param  arg  String
			* @return value (or NaN, if not defined) Number
			*/	
	
			private function changeParamToNumber(arg:String):Number {
				var myNum:Number;
				if ((arg != null) && (arg != "")) {
					myNum = Number(arg); 
				}
				else {
					myNum = NaN;
				}		
				
				return myNum;
				
			}
			
			/**
			* This function converts the incoming String to Boolean
			* @param  arg  String
			* @return true/false
			*/	
	
			private function changeParamToBoolean(arg:String, defaultValue:Boolean):Boolean {
				var myBool:Boolean;
				if ((arg == "true") ||(arg == "false")) {
					
					if (arg == "true") {
						myBool = true;
					}
					
					if (arg == "false") {
						myBool = false;
					}		
				}
				else {
					myBool = defaultValue;
				}		
				
				return myBool;

			}
			
			
			/**
			* This function converts the incoming String to uint
			* @param  arg  String
			* @return value or defaultValue (if incoming string is not a valid uint)
			*/	
	
			private function changeParamTo_uint(arg:String, defaultValue:uint):uint {
				var my_uint:uint;
				
				if ((arg != null) && (arg != "")) {
						// save uint; an invalid string results in zero
						my_uint = uint(arg);
							
						// check if zero (=invalid), except for the case, that zero was the user input
						if ( (my_uint == 0) && (arg != "0x000000") ) {
								my_uint = defaultValue;
						}
							
				}
				else {
					my_uint = defaultValue;
				}		
				
				return my_uint;

			}
	
	} // class



} // package
