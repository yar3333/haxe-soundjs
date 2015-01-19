package createjs;

/**
 * Play sounds using a Flash instance. This plugin is not used by default, and must be registered manually in
 * {{#crossLink "Sound"}}{{/crossLink}} using the {{#crossLink "Sound/registerPlugins"}}{{/crossLink}} method. This
 * plugin is recommended to be included if sound support is required in older browsers such as IE8.
 * 
 * This plugin requires FlashAudioPlugin.swf and swfObject.js, which is compiled
 * into the minified FlashAudioPlugin-X.X.X.min.js file. You must ensure that {{#crossLink "FlashAudioPlugin/swfPath:property"}}{{/crossLink}}
 * is set when using this plugin, so that the script can find the swf.
 * 
 * <h4>Example</h4>
 * 
 *      createjs.FlashAudioPlugin.swfPath = "../src/soundjs/flashaudio";
 *      createjs.Sound.registerPlugins([createjs.WebAudioPlugin, createjs.HTMLAudioPlugin, createjs.FlashAudioPlugin]);
 *      // Adds FlashAudioPlugin as a fallback if WebAudio and HTMLAudio do not work.
 * 
 * Note that the SWF is embedded into a container DIV (with an id and classname of "SoundJSFlashContainer"), and
 * will have an id of "flashAudioContainer". The container DIV is positioned 1 pixel off-screen to the left to avoid
 * showing the 1x1 pixel white square.
 * 
 * <h4>Known Browser and OS issues for Flash Audio</h4>
 * <b>All browsers</b><br />
 * <ul><li> There can be a delay in flash player starting playback of audio.  This has been most noticeable in Firefox.
 * Unfortunely this is an issue with the flash player and the browser and therefore cannot be addressed by SoundJS.</li></ul>
 */
extern class FlashAudioPlugin extends AbstractPlugin
{
	/**
	 * A developer flag to output all flash events to the console (if it exists).  Used for debugging.
	 * 
	 *      createjs.Sound.activePlugin.showOutput = true;
	 */
	var showOutput : Bool;
	/**
	 * Determines if the Flash object has been created and initialized. This is required to make <code>ExternalInterface</code>
	 * calls from JavaScript to Flash.
	 */
	var flashReady : Bool;
	/**
	 * The path relative to the HTML page that the FlashAudioPlugin.swf resides. Note if this is not correct, this
	 * plugin will not work.
	 */
	static var swfPath : String;

	function new() : Void;

	/**
	 * Determine if the plugin can be used in the current browser/OS.
	 */
	static function isSupported() : Bool;
}