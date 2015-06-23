## Embed SWF ##

| **parameter** | **short description** | **example** | **default** |
|:--------------|:----------------------|:------------|:------------|
| contentpath   | This is an important property. It contains the URL or path to all the files that belong to the content (video, preview, preroll and captions files). Note: Don't place a Slash at the end, it is automatically added! | `http://www.video-flash.de/flvplayer/content` or `/flvplayer/content`| -           |

## Content ##

**Important:** All the file names are relative to the path you've defined as 'contentpath'. Example: If 'contentpath' is 'http://www.example.com/flvplayer/content' and video is 'video.flv', your video has to be stored at 'http://www.example.com/flvplayer/content/video.flv'.

That means: All the files have to be in the folder defined in "contentPath". If 'contentpath' is an empty string, you can also use absolute URLs (for instance http://www.video-flash.de/videos/video.flv).

| **parameter** | **short description** | **examples** | default |
|:--------------|:----------------------|:-------------|:--------|
| video         | The file name of the video file that should be displayed. Possible are all formats that can be played with the Flash Player (.flv, .f4v, .m4v, .mov, etc.). For RTMP-Streaming, use a full path rtmp://192.168.2.108/vod/sample.flv | `demo-video.flv`, `demo-video.f4v` | – **(required)** |
| preview       | Defines a custom preview picture (jpg, gif, png). If the file can't be found (e.g. wrong file name), the fallback is showing the default preview picture. |              | The default preview picture. |
| preroll       | Allows you to show a video before the main video (for instance advertisement). The preroll video cannot be skipped. | `demo-ad.flv`| -       |
| captions      | Set the filename of a captions file (.xml) in the "Timed Text" format (see http://livedocs.adobe.com/flash/9.0/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000604.html).|`demo-captions.xml` | -       |

## Mode ##

| **parameter** | **short description** | **examples** | **default** |
|:--------------|:----------------------|:-------------|:------------|
| autoplay      | The video starts immediatelly without the intro screen (containing the preview picture and the button). | `true` or `false` | false       |
| loop          | If the video reaches the end, it'll be started again automatically. | `true` or `false` | false       |
| islive        | Enables live streaming mode. Requires a streaming server (FMS, Wowza, etc.) | `true` or `false` | false       |
| volume        | Initial volume of the player. Number from 0 to 1 | `0` (mute), `0.5` (half) | 1           |
| autoscale     | Your video will be automatically scaled to its native size. Therefore, it's displayed in the best quality – that's why this turned on by default. If want to force a custom a custom size: Set this parameter to false and use the following two parameters for the width and height of the video. | `true` or `false` | true        |
| videowidth    | Width of the video in pixel. Video and preview screen are scaled to this width, but only if autoScale is set to false.  | `640`        | 320         |
| videoheight   | Height of the video in pixel. Video and preview screen are scaled to this height, but only if autoScale is set to false. | `480`        | 240         |
| smoothing     |  Specifies whether the video should be smoothed (interpolated) when it is scaled. This will result in better quality but requires more power. | `true` or `false` | true        |
| debug         | Turns the debug mode on and helps you to find and solve problems. It activates the log engine that gives you information about the current values of the parameters, states and error messages. To see that log engine, you need Firefox and the add-on Firebug (https://addons.mozilla.org/de/firefox/addon/1843) | `true` or `false` | false       |

## Customizing ##
| **parameter** | **short description** | **example** | **default** |
|:--------------|:----------------------|:------------|:------------|
| skincolor     | Changes the color of the play skin. Use hex color values. (Note: Skin must support changing its color) | `0xFF0000`  | 0x555555 (grey) |
| skinscalemaximum | This parameters is a scale factor for the skin in the fullscreen mode. A higher value will increase the size of the buttons in the fullscreen mode and will reduce the required computer power. 4.5 is the maximum (biggest buttons and best performance).  | `2` or `3` or `4.5` | 1           |
| skin          | Sets a custom skin. This skin has to be compatible with the FLV Playback Component of Flash (CS3+CS4). | `skin-applestyle.swf`  | default skin |
| buttonoverlay | Sets a custom buttonoverlay ( = button with play symbol on the intro screen). | buttonoverlay-blue.swf | default buttonoverlay |
| ending        | Sets a custom ending ( = button with replay symbol on the end screen). | ending-blue.swf | default ending |
| preloader     | Sets a custom preloader.  | preloader-ajax.swf | default preloader |


## Stuff ##
With VLC you can easily create preview pictures. Open the flash video in VLC, right click on the video and choose snapshot.