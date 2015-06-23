# Changelog for 1.9.7b #

- Internet Explorer 7 (IE7) problem -> Fixed a bug in the HTML templates. The option "base" was in attributes (wrong), now it's in params (correct).

# Changelog for 1.9.7 #

## playerpath ##
The parameter "playerpath" isn't required any more, it's optional now and only necessary if you use the FLVPlayer from ActionScript.

To give you some background information: Instead the "base" parameter of SWFObject is set to "." so the Player automatically knows its location

## End screen ##
A new end screen has been introduced. The default version shows a button with replay symbol.
If you want to embed a custom ending: The corresponding parameter is called "ending". You can find the flash template in "src/endings", if you want to develop your own ending in Flash.

## Keyboard control ##
The player can be controlled with some keyboard shortcuts.
  * space bar: play or pause the video
  * right/left arrow: fast-forwar/rewind the video

## New JavaScript Method and Playlists ##
A new function (`updatePlayer()`) has been created that can be called from JavaScript.
So you can update the content of the video player dynamically. This feature allows you to create playlists in HTML.
An example can be found in the download.

## skinScaleMaximum ##
The scale factor of the has been decreased which results in a smaller skin in fullscreen mode (looks nicer).
However, if you have performance problems in fullscreen mode, set it to a higher value (for instance 3) or to the default (4.5 is the default value of the FLV Playback component).

## volume ##
There's a new parameter called "volume". Default is 1 (=maximum), 0 equates to no sound.

## context menu ##
The standard context menu (right click on the player) has been replaced with a custom one.

## Subfolders for deploying ##
I've introduced subfolders in the "flvplayer" folder.
  * buttonoverlays
  * endings
  * preloaders
  * skins
That helps to keep to player folder clearly arranged.

I've moved some additional skins to the subfolder "flvplayer/skins" where you can access them directly using the "skin" parameter.

## Subfolders for sources ##
Analogous the deploy folder, the sources have also been restructured.

## HTML templates ##
Some small changes in the HTML. "flashvars" is now "playervars" and "videoPlayer" is now "videoCanvas".

## SWFObject 2.1 ##
Updated SWFObject to 2.1

## Use the player in AS3 ##
For Flash Developers: The Player can be instantiated and used in ActionScript. Optimized and removed some bugs.

## Unit tests ##
Introduced some unit tests to keep an eye on the parameters

# Changelog for 1.9.6 #

## Live streaming ##
Support for live streaming (new parameter `islive`

# Changelog for 1.9.5 #

  * The version number is now displayed in the debug mode.
  * Introduced the usage of the player in ActionScript

# Changelog for 1.9.4 #

  * smoothing

# Changelog for 1.9.3 #
  * Introduced debug mode (with FireFox and Firebug)
  * Added a new preloader, button overlay and skin
  * changed requirements (Flash Player 9.0.28)



