package soundjs;

typedef AbstractSoundInstanceSucceededEvent =
{
	var target : Dynamic;
	var type : String;
}

typedef AbstractSoundInstanceInterruptedEvent =
{
	var target : Dynamic;
	var type : String;
}

typedef AbstractSoundInstanceFailedEvent =
{
	var target : Dynamic;
	var type : String;
}

typedef AbstractSoundInstanceLoopEvent =
{
	var target : Dynamic;
	var type : String;
}

typedef AbstractSoundInstanceCompleteEvent =
{
	var target : Dynamic;
	var type : String;
}

/**
 * A AbstractSoundInstance is created when any calls to the Sound API method {{#crossLink "Sound/play"}}{{/crossLink}} or
 * {{#crossLink "Sound/createInstance"}}{{/crossLink}} are made. The AbstractSoundInstance is returned by the active plugin
 * for control by the user.
 * 
 * <h4>Example</h4>
 * 
 *      var myInstance = createjs.Sound.play("myAssetPath/mySrcFile.mp3");
 * 
 * A number of additional parameters provide a quick way to determine how a sound is played. Please see the Sound
 * API method {{#crossLink "Sound/play"}}{{/crossLink}} for a list of arguments.
 * 
 * Once a AbstractSoundInstance is created, a reference can be stored that can be used to control the audio directly through
 * the AbstractSoundInstance. If the reference is not stored, the AbstractSoundInstance will play out its audio (and any loops), and
 * is then de-referenced from the {{#crossLink "Sound"}}{{/crossLink}} class so that it can be cleaned up. If audio
 * playback has completed, a simple call to the {{#crossLink "AbstractSoundInstance/play"}}{{/crossLink}} instance method
 * will rebuild the references the Sound class need to control it.
 * 
 *      var myInstance = createjs.Sound.play("myAssetPath/mySrcFile.mp3", {loop:2});
 *      myInstance.on("loop", handleLoop);
 *      function handleLoop(event) {
 *          myInstance.volume = myInstance.volume * 0.5;
 *      }
 * 
 * Events are dispatched from the instance to notify when the sound has completed, looped, or when playback fails
 * 
 *      var myInstance = createjs.Sound.play("myAssetPath/mySrcFile.mp3");
 *      myInstance.on("complete", handleComplete);
 *      myInstance.on("loop", handleLoop);
 *      myInstance.on("failed", handleFailed);
 */
@:native("createjs.AbstractSoundInstance")
extern class AbstractSoundInstance extends createjs.EventDispatcher
{
	/**
	 * The source of the sound.
	 */
	var src : String;
	/**
	 * The unique ID of the instance. This is set by {{#crossLink "Sound"}}{{/crossLink}}.
	 */
	var uniqueId : Dynamic;
	/**
	 * The play state of the sound. Play states are defined as constants on {{#crossLink "Sound"}}{{/crossLink}}.
	 */
	var playState : String;
	/**
	 * The volume of the sound, between 0 and 1.
	 * <br />Note this uses a getter setter, which is not supported by Firefox versions 3.6 or lower and Opera versions 11.50 or lower,
	 * and Internet Explorer 8 or lower.  Instead use {{#crossLink "AbstractSoundInstance/setVolume"}}{{/crossLink}} and {{#crossLink "AbstractSoundInstance/getVolume"}}{{/crossLink}}.
	 * 
	 * The actual output volume of a sound can be calculated using:
	 * <code>myInstance.volume * createjs.Sound.getVolume();</code>
	 */
	var volume : Float;
	/**
	 * The pan of the sound, between -1 (left) and 1 (right). Note that pan is not supported by HTML Audio.
	 * 
	 * <br />Note this uses a getter setter, which is not supported by Firefox versions 3.6 or lower, Opera versions 11.50 or lower,
	 * and Internet Explorer 8 or lower.  Instead use {{#crossLink "AbstractSoundInstance/setPan"}}{{/crossLink}} and {{#crossLink "AbstractSoundInstance/getPan"}}{{/crossLink}}.
	 * <br />Note in WebAudioPlugin this only gives us the "x" value of what is actually 3D audio.
	 */
	var pan : Float;
	/**
	 * The length of the audio clip, in milliseconds.
	 * 
	 * <br />Note this uses a getter setter, which is not supported by Firefox versions 3.6 or lower, Opera versions 11.50 or lower,
	 * and Internet Explorer 8 or lower.  Instead use {{#crossLink "AbstractSoundInstance/setDuration"}}{{/crossLink}} and {{#crossLink "AbstractSoundInstance/getDuration"}}{{/crossLink}}.
	 */
	var duration : Float;
	/**
	 * Object that holds plugin specific resource need for audio playback.
	 * This is set internally by the plugin.  For example, WebAudioPlugin will set an array buffer,
	 * HTMLAudioPlugin will set a tag, FlashAudioPlugin will set a flash reference.
	 */
	var playbackResource : Dynamic;
	/**
	 * The position of the playhead in milliseconds. This can be set while a sound is playing, paused, or stopped.
	 * 
	 * <br />Note this uses a getter setter, which is not supported by Firefox versions 3.6 or lower, Opera versions 11.50 or lower,
	 * and Internet Explorer 8 or lower.  Instead use {{#crossLink "AbstractSoundInstance/setPosition"}}{{/crossLink}} and {{#crossLink "AbstractSoundInstance/getPosition"}}{{/crossLink}}.
	 */
	var position : Float;
	/**
	 * The number of play loops remaining. Negative values will loop infinitely.
	 * 
	 * <br />Note this uses a getter setter, which is not supported by Firefox versions 3.6 or lower, Opera versions 11.50 or lower,
	 * and Internet Explorer 8 or lower.  Instead use {{#crossLink "AbstractSoundInstance/setLoop"}}{{/crossLink}} and {{#crossLink "AbstractSoundInstance/getLoop"}}{{/crossLink}}.
	 */
	var loop : Float;
	/**
	 * Determines if the audio is currently muted.
	 * 
	 * <br />Note this uses a getter setter, which is not supported by Firefox versions 3.6 or lower, Opera versions 11.50 or lower,
	 * and Internet Explorer 8 or lower.  Instead use {{#crossLink "AbstractSoundInstance/setMute"}}{{/crossLink}} and {{#crossLink "AbstractSoundInstance/getMute"}}{{/crossLink}}.
	 */
	var muted : Bool;
	/**
	 * Tells you if the audio is currently paused.
	 * 
	 * <br />Note this uses a getter setter, which is not supported by Firefox versions 3.6 or lower, Opera versions 11.50 or lower,
	 * and Internet Explorer 8 or lower.
	 * Use {{#crossLink "AbstractSoundInstance/pause:method"}}{{/crossLink}} and {{#crossLink "AbstractSoundInstance/resume:method"}}{{/crossLink}} to set.
	 */
	var paused : Bool;

	function new(src:String, startTime:Float, duration:Float, playbackResource:Dynamic) : Void;

	/**
	 * Play an instance. This method is intended to be called on SoundInstances that already exist (created
	 * with the Sound API {{#crossLink "Sound/createInstance"}}{{/crossLink}} or {{#crossLink "Sound/play"}}{{/crossLink}}).
	 * 
	 * <h4>Example</h4>
	 * 
	 *      var myInstance = createjs.Sound.createInstance(mySrc);
	 *      myInstance.play({offset:1, loop:2, pan:0.5});	// options as object properties
	 *      myInstance.play(createjs.Sound.INTERRUPT_ANY);	// options as parameters
	 * 
	 * Note that if this sound is already playing, this call will do nothing.
	 */
	function play(?interrupt:Dynamic, ?delay:Float, ?offset:Float, ?loop:Float, ?volume:Float, ?pan:Float) : AbstractSoundInstance;
	/**
	 * Stop playback of the instance. Stopped sounds will reset their position to 0, and calls to {{#crossLink "AbstractSoundInstance/resume"}}{{/crossLink}}
	 * will fail.  To start playback again, call {{#crossLink "AbstractSoundInstance/play"}}{{/crossLink}}.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     myInstance.stop();
	 */
	function stop() : AbstractSoundInstance;
	/**
	 * Remove all external references and resources from AbstractSoundInstance.  Note this is irreversible and AbstractSoundInstance will no longer work
	 */
	function destroy() : Void;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/paused:property"}}{{/crossLink}} can be accessed directly as a property,
	 * and getPaused remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Returns true if the instance is currently paused.
	 */
	function getPaused() : Bool;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/paused:property"}}{{/crossLink}} can be accessed directly as a property,
	 * setPaused remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Pause or resume the instance.  Note you can also resume playback with {{#crossLink "AbstractSoundInstance/play"}}{{/crossLink}}.
	 */
	function setPaused(value:Bool) : AbstractSoundInstance;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/volume:property"}}{{/crossLink}} can be accessed directly as a property,
	 * setVolume remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Set the volume of the instance.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      myInstance.setVolume(0.5);
	 * 
	 * Note that the master volume set using the Sound API method {{#crossLink "Sound/setVolume"}}{{/crossLink}}
	 * will be applied to the instance volume.
	 */
	function setVolume(value:Float) : AbstractSoundInstance;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/volume:property"}}{{/crossLink}} can be accessed directly as a property,
	 * getVolume remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Get the volume of the instance. The actual output volume of a sound can be calculated using:
	 * <code>myInstance.getVolume() * createjs.Sound.getVolume();</code>
	 */
	function getVolume() : Float;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/muted:property"}}{{/crossLink}} can be accessed directly as a property,
	 * setMuted exists to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Mute and unmute the sound. Muted sounds will still play at 0 volume. Note that an unmuted sound may still be
	 * silent depending on {{#crossLink "Sound"}}{{/crossLink}} volume, instance volume, and Sound muted.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     myInstance.setMuted(true);
	 */
	function setMute(value:Bool) : AbstractSoundInstance;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/muted:property"}}{{/crossLink}} can be accessed directly as a property,
	 * getMuted remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Get the mute value of the instance.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      var isMuted = myInstance.getMuted();
	 */
	function getMute() : Bool;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/pan:property"}}{{/crossLink}} can be accessed directly as a property,
	 * getPan remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Set the left(-1)/right(+1) pan of the instance. Note that {{#crossLink "HTMLAudioPlugin"}}{{/crossLink}} does not
	 * support panning, and only simple left/right panning has been implemented for {{#crossLink "WebAudioPlugin"}}{{/crossLink}}.
	 * The default pan value is 0 (center).
	 * 
	 * <h4>Example</h4>
	 * 
	 *     myInstance.setPan(-1);  // to the left!
	 */
	function setPan(value:Float) : AbstractSoundInstance;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/pan:property"}}{{/crossLink}} can be accessed directly as a property,
	 * getPan remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Get the left/right pan of the instance. Note in WebAudioPlugin this only gives us the "x" value of what is
	 * actually 3D audio.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     var myPan = myInstance.getPan();
	 */
	function getPan() : Float;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/position:property"}}{{/crossLink}} can be accessed directly as a property,
	 * getPosition remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Get the position of the playhead of the instance in milliseconds.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     var currentOffset = myInstance.getPosition();
	 */
	function getPosition() : Float;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/position:property"}}{{/crossLink}} can be accessed directly as a property,
	 * setPosition remains to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Set the position of the playhead in the instance. This can be set while a sound is playing, paused, or
	 * stopped.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      myInstance.setPosition(myInstance.getDuration()/2); // set audio to its halfway point.
	 */
	function setPosition(value:Float) : AbstractSoundInstance;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/duration:property"}}{{/crossLink}} can be accessed directly as a property,
	 * getDuration exists to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Get the duration of the instance, in milliseconds.
	 * Note a sound needs to be loaded before it will have duration, unless it was set manually to create an audio sprite.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     var soundDur = myInstance.getDuration();
	 */
	function getDuration() : Float;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/duration:property"}}{{/crossLink}} can be accessed directly as a property,
	 * setDuration exists to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Set the duration of the audio.  Generally this is not called, but it can be used to create an audio sprite out of an existing AbstractSoundInstance.
	 */
	function setDuration(value:Float) : AbstractSoundInstance;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/playbackResource:property"}}{{/crossLink}} can be accessed directly as a property,
	 * setPlaybackResource exists to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * An object containing any resources needed for audio playback, set by the plugin.
	 * Only meant for use by advanced users.
	 */
	function setPlaybackResource(value:Dynamic) : AbstractSoundInstance;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/playbackResource:property"}}{{/crossLink}} can be accessed directly as a property,
	 * getPlaybackResource exists to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * An object containing any resources needed for audio playback, usually set by the plugin.
	 */
	function getPlaybackResource(value:Dynamic) : Dynamic;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/loop:property"}}{{/crossLink}} can be accessed directly as a property,
	 * getLoop exists to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * The number of play loops remaining. Negative values will loop infinitely.
	 */
	function getLoop() : Float;
	/**
	 * NOTE {{#crossLink "AbstractSoundInstance/loop:property"}}{{/crossLink}} can be accessed directly as a property,
	 * setLoop exists to allow support for IE8 with FlashAudioPlugin.
	 * 
	 * Set the number of play loops remaining.
	 */
	function setLoop(value:Float) : Void;

	/**
	 * The event that is fired when playback has started successfully.
	 */
	inline function addSucceededEventListener(handler:AbstractSoundInstanceSucceededEvent->Void) : Dynamic return addEventListener("succeeded", handler);
	/**
	 * The event that is fired when playback is interrupted. This happens when another sound with the same
	 * src property is played using an interrupt value that causes this instance to stop playing.
	 */
	inline function addInterruptedEventListener(handler:AbstractSoundInstanceInterruptedEvent->Void) : Dynamic return addEventListener("interrupted", handler);
	/**
	 * The event that is fired when playback has failed. This happens when there are too many channels with the same
	 * src property already playing (and the interrupt value doesn't cause an interrupt of another instance), or
	 * the sound could not be played, perhaps due to a 404 error.
	 */
	inline function addFailedEventListener(handler:AbstractSoundInstanceFailedEvent->Void) : Dynamic return addEventListener("failed", handler);
	/**
	 * The event that is fired when a sound has completed playing but has loops remaining.
	 */
	inline function addLoopEventListener(handler:AbstractSoundInstanceLoopEvent->Void) : Dynamic return addEventListener("loop", handler);
	/**
	 * The event that is fired when playback completes. This means that the sound has finished playing in its
	 * entirety, including its loop iterations.
	 */
	inline function addCompleteEventListener(handler:AbstractSoundInstanceCompleteEvent->Void) : Dynamic return addEventListener("complete", handler);
}