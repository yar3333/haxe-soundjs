package soundjs.cordovaaudio;

import haxe.Constraints.Function;

/**
 * CordovaAudioSoundInstance extends the base api of {{#crossLink "AbstractSoundInstance"}}{{/crossLink}} and is used by
 * {{#crossLink "CordovaAudioPlugin"}}{{/crossLink}}.
 */
@:native('createjs.CordovaAudioSoundInstance')
extern class CordovaAudioSoundInstance extends AbstractSoundInstance
{
	/**
	 * Sets the playAudioWhenScreenIsLocked property for play calls on iOS devices.
	 */
	var playWhenScreenLocked : Bool;

	function new(src:String, startTime:Float, duration:Float, playbackResource:Dynamic) : Void;

	/**
	 * Maps to <a href="http://plugins.cordova.io/#/package/org.apache.cordova.media" target="_blank">Media.getCurrentPosition</a>,
	 * which is curiously asynchronus and requires a callback.
	 */
	function getCurrentPosition(mediaSuccess:Function, ?mediaError:Function) : Void;
}