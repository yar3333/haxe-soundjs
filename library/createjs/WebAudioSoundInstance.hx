package createjs;

/**
 * WebAudioSoundInstance extends the base api of {{#crossLink "AbstractSoundInstance"}}{{/crossLink}} and is used by
 * {{#crossLink "WebAudioPlugin"}}{{/crossLink}}.
 * 
 * WebAudioSoundInstance exposes audioNodes for advanced users.
 */
extern class WebAudioSoundInstance extends AbstractSoundInstance
{
	/**
	 * NOTE this is only intended for use by advanced users.
	 * <br />GainNode for controlling <code>WebAudioSoundInstance</code> volume. Connected to the {{#crossLink "WebAudioSoundInstance/destinationNode:property"}}{{/crossLink}}.
	 */
	var gainNode : js.html.audio.GainNode;
	/**
	 * NOTE this is only intended for use by advanced users.
	 * <br />A panNode allowing left and right audio channel panning only. Connected to WebAudioSoundInstance {{#crossLink "WebAudioSoundInstance/gainNode:property"}}{{/crossLink}}.
	 */
	var panNode : js.html.audio.PannerNode;
	/**
	 * NOTE this is only intended for use by advanced users.
	 * <br />sourceNode is the audio source. Connected to WebAudioSoundInstance {{#crossLink "WebAudioSoundInstance/panNode:property"}}{{/crossLink}}.
	 */
	var sourceNode : js.html.audio.AudioNode;
	/**
	 * Note this is only intended for use by advanced users.
	 * <br />Audio context used to create nodes.  This is and needs to be the same context used by {{#crossLink "WebAudioPlugin"}}{{/crossLink}}.
	 */
	static var context : js.html.audio.AudioContext;
	/**
	 * Note this is only intended for use by advanced users.
	 * <br /> Audio node from WebAudioPlugin that sequences to <code>context.destination</code>
	 */
	static var destinationNode : js.html.audio.AudioNode;

	function new(src:String, startTime:Float, duration:Float, playbackResource:Dynamic) : Void;
}