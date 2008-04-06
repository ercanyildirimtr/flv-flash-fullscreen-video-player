<?php
/*
Plugin Name: FLV Flash Fullscreen Video Player
Version: 1.9.2
Plugin URI: http://www.video-flash.de
Description: Embed flash videos using the "FLV Flash Fullscreen Video Player". The FLV Player can be configured under "Options > FLV Player". How to use: <code>[flashvideo video=demo-video.flv /]</code>. 
Author: Florian Plag
Author URI: http://www.video-flash.de

FLV Flash Fullscreen Video Player (Wordpress), Copyright 2008 Florian Plag

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

1) Based on Flash Video Player Plugin for WordPress (GPL license) by Joshua Eldridgeby
   Website: http://www.mac-dev.net

2) Includes Geoff Stearns' SWFObject Javascript Library (MIT License) v1.5
   Website: http://blog.deconcept.com/swfobject/
   License: http://www.opensource.org/licenses/mit-license.php
*/


$videoid = 0;
$site_url = get_option('siteurl');

function FlashVideo_Parse($content) {
	$content = preg_replace_callback("/\[flashvideo ([^]]*)\/\]/i", "FlashVideo_Render", $content);
	return $content;
}

function FlashVideo_Render($matches) {
	global $videoid, $site_url;
	$output = '';
	
	$matches[1] = str_replace(array('&#8221;','&#8243;'), '', $matches[1]);
	preg_match_all('/(\w*)=(.*?) /i', $matches[1], $attributes);
	$arguments = array();

	foreach ( (array) $attributes[1] as $key => $value ) {
		$arguments[$value] = $attributes[2][$key];
	}

	if ( !array_key_exists('video', $arguments) ) {
		return '<div style="background-color:#f99; padding:10px;">Error: Required parameter "video" is missing!</div>';
		exit;
	}

	$options = get_option('FlashVideoSettings');

	/* Override inline parameters */
	if ( array_key_exists('width', $arguments) ) {
		$options[0][1]['v'] = $arguments['width'];
	}
	if ( array_key_exists('height', $arguments) ) {
		$options[0][2]['v'] = $arguments['height'];
	}
	if ( array_key_exists('image', $arguments) ) {
		$arguments['image'] = $site_url . '/' . $arguments['image'];
	}
	
	/*
	if ( array_key_exists('floatingcontrols', $arguments) ) {
		if ( $arguments['floatingcontrols'] == 'true' ) {
			$options[0][0]['v'] = $options[0][2]['v'];
		}
		if ( $arguments['floatingcontrols'] == 'false' ) {
			$options[0][0]['v'] = '';
		}
	}*/
	
	if(strpos($arguments['filename'], 'http://') !== false || strpos($arguments['filename'], 'rtmp://') !== false) {
		// This is a remote file, so leave it alone but clean it up a little
		$arguments['filename'] = str_replace('&#038;','&',$arguments['filename']);
	} else {
		$arguments['filename'] = $site_url . '/' . $arguments['filename'];
	}
	
	$output .= "\n" . '<span id="video' . $videoid . '" class="flashvideo">' . "\n";
   	$output .= '<a href="http://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</span>' . "\n";
    	$output .= '<script type="text/javascript">' . "\n";
	$output .= 'var s' . $videoid . ' = new SWFObject("' . $options[0][0]['v'] . '","n' . $videoid . '","' . $options[0][1]['v'] . '","' . $options[0][2]['v'] . '","7");' . "\n";
	$output .= 's' . $videoid . '.addParam("allowfullscreen","true");' . "\n";
	$output .= 's' . $videoid . '.addParam("allowscriptaccess","always");' . "\n";
	$output .= 's' . $videoid . '.addParam("scale","noscale");' . "\n";
	$output .= 's' . $videoid . '.addParam("salign","tl");' . "\n";
	$output .= 's' . $videoid . '.addVariable("javascriptid","n' . $videoid . '");' . "\n";
	for ( $i=0; $i<count($options);$i++ ) {
		foreach ( (array) $options[$i] as $key=>$value ) {
			/* Allow for inline override of all parameters */
			if ( array_key_exists($value['on'], $arguments) && $value['on'] != 'displayheight') {
				$value['v'] = $arguments[$value['on']];
			}
			// Handle Floating Controls for Default Values
			if ( $value['on'] == 'displayheight' && !array_key_exists('floatingcontrols', $arguments) ) {
				if ( $value['v'] == 'true' ) {
					$value['v'] = $options[0][2]['v'];
				} else {
					$value['v'] = '';
				}
			}
			
			if ( $value['v'] != '' && $value['on'] != 'location' ) {
				$output .= 's' . $videoid . '.addVariable("' . $value['on'] . '","' . $value['v'] . '");' . "\n";
			}
		}
	}
	$output .= 's' . $videoid . '.addVariable("file","' . $arguments['filename'] . '");' . "\n";
	$output .= 's' . $videoid . '.write("video' . $videoid . '");' . "\n";
	$output .= '</script>' . "\n";

	$videoid++;
	return $output;
}

function FlashVideoAddPage() {
	add_options_page('FLV Player', 'FLV Player', '8', 'flv-player-plugin.php', 'FlashVideoOptions');
}

function FlashVideoOptions() {
	$message = '';	
	$g = array(0=>'Embed SWF (Flash)', 1=>'Paths to player and content', 2=>'Player and Skin', 3=>'Playback', 4=>'Autoscale', 5=>'Content');

	$options = get_option('FlashVideoSettings');
	if ($_POST) {
		for($i=0; $i<count($options);$i++) {
			foreach( (array) $options[$i] as $key=>$value) {
				// Handle Checkboxes that don't send a value in the POST
				if($value['t'] == 'cb' && !isset($_POST[$options[$i][$key]['on']])) {
					$options[$i][$key]['v'] = 'false';
				}
				if($value['t'] == 'cb' && isset($_POST[$options[$i][$key]['on']])) {
					$options[$i][$key]['v'] = 'true';
				}
				// Handle all other changed values
				if(isset($_POST[$options[$i][$key]['on']]) && $value['t'] != 'cb') {
					$options[$i][$key]['v'] = $_POST[$options[$i][$key]['on']];
				}
			}
		}
		update_option('FlashVideoSettings', $options);
		$message = '<div class="updated"><p><strong>Options saved.</strong></p></div>';	
	}

	echo '<div class="wrap">';
	echo '<h2>FLV Flash Fullscreen Video Player Options</h2>';
	echo $message;
	echo '<form method="post" action="options-general.php?page=flv-player-plugin.php">';
	echo '<p class="submit"><input type="submit" method="post" value="Update Options &raquo;"></p>';

	echo "<p>Welcome to the FLV Player plugin options menu! Here you can set all of the available player variables to default values for your website. The variables can be overwritten by setting a new value in your post.</p>";
	echo "<p>How to use (examples):<br /><code>[flashvideo video=demo-video.flv /]</code><br /><code>[flashvideo video=demo-video.flv skin=skin-applestyle.swf /]</code>";

	echo "<p>Have a look at my web site (www.video-flash.de) for the explanation of the parameters/variables.</p>";

	foreach( (array) $options as $key=>$value) {
		echo '<fieldset class="options">';
		echo '<legend>' . $g[$key] . '</legend>';
		echo '<table class="optiontable">';
		foreach( (array) $value as $setting) {
			echo '<tr><th scope="row">' . $setting['dn'] . '</th><td>';
			if($setting['t'] == 'tx') {
				echo '<input type="text" name="' . $setting['on'] . '" value="' . $setting['v'] . '" style="width:500px" />';
			} elseif ($setting['t'] == 'cb') {
				echo '<input type="checkbox" class="check" name="' . $setting['on'] . '" ';
				if($setting['v'] == 'true') {
					echo 'checked="checked"';
				}
				echo ' />';
			}
			echo '</td></tr>';
		}
		echo '</table>';
		echo '</fieldset>';
	}

	echo '<p class="submit"><input type="submit" method="post" value="Update Options &raquo;"></p>';
	echo '</form>';
	echo '</div>';
}

function FlashVideo_head() {
	global $site_url;
	$path = $site_url . '/wp-content/plugins/flv-player-plugin/swfobject.js';
	echo '<script type="text/javascript" src="' . $path . '"></script>' . "\n";
}

add_action('wp_head', 'FlashVideo_head');

function FlashVideoLoadDefaults() {
	global $site_url;
	$f = array();

	/*
	  Array Legend:
	  gn = Group Name
	  id = Unique Identifier
	  on = Option Name
	  dn = Display Name
	  t = Type
	  d = Default
	  g = Groups
	*/
	
// swf


$f[0][0]['on'] = 'location';
$f[0][0]['dn'] = 'SWF Location';
$f[0][0]['t'] = 'tx';
$f[0][0]['v'] = $site_url . '/wp-content/flvplayer/flvplayer.swf';

$f[0][1]['on'] = 'width';
$f[0][1]['dn'] = 'width';
$f[0][1]['t'] = 'tx';
$f[0][1]['v'] = '320';

$f[0][2]['on'] = 'height';
$f[0][2]['dn'] = 'height';
$f[0][2]['t'] = 'tx';
$f[0][2]['v'] = '285';

// paths

$f[1][0]['on'] = 'playerpath';
$f[1][0]['dn'] = 'playerpath';
$f[1][0]['t'] = 'tx';
$f[1][0]['v'] = $site_url . '/wp-content/flvplayer';
   
$f[1][1]['on'] = 'contentpath';
$f[1][1]['dn'] = 'contentpath';
$f[1][1]['t'] = 'tx';
$f[1][1]['v'] = $site_url . '/wp-content/flvplayer/content';


// player and skin

$f[2][0]['on'] = 'buttonoverlay';
$f[2][0]['dn'] = 'buttonoverlay';
$f[2][0]['t'] = 'tx';
$f[2][0]['v'] = '';


$f[2][1]['on'] = 'preloader';
$f[2][1]['dn'] = 'preloader';
$f[2][1]['t'] = 'tx';
$f[2][1]['v'] = '';
   	
   
$f[2][2]['on'] = 'skin';
$f[2][2]['dn'] = 'skin';
$f[2][2]['t'] = 'tx';
$f[2][2]['v'] = '';
   
   
$f[2][3]['on'] = 'skincolor';
$f[2][3]['dn'] = 'skin color';
$f[2][3]['t'] = 'tx';
$f[2][3]['v'] = '';
   
   
$f[2][4]['on'] = 'skinscalemaximum';
$f[2][4]['dn'] = 'skinscalemaximum';
$f[2][4]['t'] = 'tx';
$f[2][4]['v'] = '';			


// playback

$f[3][0]['on'] = 'autoplay';
$f[3][0]['dn'] = 'autoplay';
$f[3][0]['t'] = 'cb';
$f[3][0]['v'] = 'false';
   
   
$f[3][1]['on'] = 'loop';
$f[3][1]['dn'] = 'loop';
$f[3][1]['t'] = 'cb';
$f[3][1]['v'] = 'false';

$f[3][2]['on'] = 'debug';
$f[3][2]['dn'] = 'debug';
$f[3][2]['t'] = 'cb';
$f[3][2]['v'] = 'false';

// autoscale

$f[4][0]['on'] = 'autoscale';
$f[4][0]['dn'] = 'autoscale';
$f[4][0]['t'] = 'cb';
$f[4][0]['v'] = 'true';
   
$f[4][1]['on'] = 'videowidth';
$f[4][1]['dn'] = 'videowidth';
$f[4][1]['t'] = 'tx';
$f[4][1]['v'] = '';
   
$f[4][2]['on'] = 'videoheight';
$f[4][2]['dn'] = 'videoheight';
$f[4][2]['t'] = 'tx';
$f[4][2]['v'] = '';


// content

$f[5][0]['on'] = 'preview';
$f[5][0]['dn'] = 'preview';
$f[5][0]['t'] = 'tx';
$f[5][0]['v'] = '';
   
$f[5][1]['on'] = 'preroll';
$f[5][1]['dn'] = 'preroll';
$f[5][1]['t'] = 'tx';
$f[5][1]['v'] = '';
   
$f[5][2]['on'] = 'video';
$f[5][2]['dn'] = 'video';
$f[5][2]['t'] = 'tx';
$f[5][2]['v'] = '';
   
$f[5][3]['on'] = 'captions';
$f[5][3]['dn'] = 'captions';
$f[5][3]['t'] = 'tx';
$f[5][3]['v'] = '';


	
	return $f;
}

function FlashVideo_activate() {
	update_option('FlashVideoSettings', FlashVideoLoadDefaults());
}

register_activation_hook(__FILE__,'FlashVideo_activate');

function FlashVideo_deactivate() {
	delete_option('FlashVideoSettings');
}

register_deactivation_hook(__FILE__,'FlashVideo_deactivate');

// CONTENT FILTER

add_filter('the_content', 'FlashVideo_Parse');
//add_filter('the_excerpt_rss', 'FlashVideo_Parse');

// OPTIONS MENU

add_action('admin_menu', 'FlashVideoAddPage');

?>