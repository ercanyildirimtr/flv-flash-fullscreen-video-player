# Hot to use the FLV Flash Fullscreen Video Player #

There are various methods to use the FLV Player
  * Links
  * iFrame
  * SWFObject
  * JavaScript Playlists
  * ActionScript
You can find examples in the download.

## How to use the FLV Player using links ##

The `flvplayer` contains an HTML page called `flashvideoplayer.html`. You can link to this page and transfer the parameters in the query strings.

```
http://www.yourdomain.com/flvplayer/flashvideoplayer.html?video=content/demo-video.flv
```

If you have more than one parameter, add them with an "&".
```
http://www.yourdomain.com/flvplayer/flashvideoplayer.html?video=content/demo-video.flv&skin=skin-applestyle.swf
```

## How to embed the FLV Player using an iFrame ##

You can integrate the player with an iframe. Just change the URL to `flashvideoplayer.html`and the parameters (see previous section).
```
<iframe src=".../flvplayer/flashvideoplayer.html?video=content/demo-video.flv" width="450" height="400" frameborder="0" scrolling="no"></iframe>
```

## How to embed the FLV Player using SWFObject ##
[SWFObject](http://code.google.com/p/swfobject/) is an easy-to-use and standards-friendly method to embed Flash content, which utilizes one small JavaScript file. You can pass the parameters to player with 'flashvars'.

HTML head:
```
<script type="text/javascript" src="../flvplayer/swfobject.js"></script>

<script type="text/javascript">
	var playervars = {    
		contentpath: "../flvplayer/content",
		video: "demo-video.flv",
		preview: "demo-preview.jpg",							
	        skin: "skin-applestyle.swf",
		skincolor: "0x2c8cbd"
		// ...
		//see documentation for all the parameters		
	};	
  			
		var params = { scale: "noscale", allowfullscreen: "true", salign: "tl", bgcolor: "#ffffff", base: "." };  	
		var attributes = { align: "left"};
		
	swfobject.embedSWF("../flvplayer/flvplayer.swf", "videoCanvas", "500", "450", "9.0.28", "../flvplayer/expressInstall.swf", playervars, params, attributes);
         
		// Playlist
</script>
```


HTML body:
```
	<div id="videoCanvas" style="margin:0px">
	
	    <p>This content requires the Adobe Flash Player.</p>

		<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a>
	    </p>

	</div>
```

## How to create a JavaScript playlist ##
Important: This features doesn't work locally (security reasons). Either, upload it on a web server or put the folder with the FLV Player into a trusted zone ([link](http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html)).

Let's say you have integrated the player using SWFObject with playervars:
```
        ...
	var playervars = {    
		contentpath: "../flvplayer/content",
		video: "demo-video.flv",
		preview: "demo-preview.jpg",							
	        skin: "skin-applestyle.swf",
		skincolor: "0x2c8cbd"
		// ...
		//see documentation for all the parameters		
	};
     ...
```

This examples shows you how to update the player with the JavaScript function `updatePlayer`. If `video1` (= HTML element, e.g. button, table row, etc.) is clicked, a reference to the video player is saved in the variable `player`. Then `playervars.video` is set to another video file. After that, the player is updated.
```
window.onload = function() {     
					document.getElementById("video1").onclick = function() {  		
						var player = swfobject.getObjectById("videoCanvas");  													    
  						playervars.video = "demo-video2.flv";
 						player.updatePlayer(playervars);					
					}; 
```