package createjs;

typedef SoundFileloadEvent =
{
	var target : Dynamic;
	var type : String;
	var src : String;
	var id : String;
	var data : Dynamic;
}

typedef SoundFileerrorEvent =
{
	var target : Dynamic;
	var type : String;
	var src : String;
	var id : String;
	var data : Dynamic;
}

/**
 * The Sound class is the public API for creating sounds, controlling the overall sound levels, and managing plugins.
 * All Sound APIs on this class are static.
 * 
 * <b>Registering and Preloading</b><br />
 * Before you can play a sound, it <b>must</b> be registered. You can do this with {{#crossLink "Sound/registerSound"}}{{/crossLink}},
 * or register multiple sounds using {{#crossLink "Sound/registerSounds"}}{{/crossLink}}. If you don't register a
 * sound prior to attempting to play it using {{#crossLink "Sound/play"}}{{/crossLink}} or create it using {{#crossLink "Sound/createInstance"}}{{/crossLink}},
 * the sound source will be automatically registered but playback will fail as the source will not be ready. If you use
 * <a href="http://preloadjs.com" target="_blank">PreloadJS</a>, registration is handled for you when the sound is
 * preloaded. It is recommended to preload sounds either internally using the register functions or externally using
 * PreloadJS so they are ready when you want to use them.
 * 
 * <b>Playback</b><br />
 * To play a sound once it's been registered and preloaded, use the {{#crossLink "Sound/play"}}{{/crossLink}} method.
 * This method returns a {{#crossLink "AbstractSoundInstance"}}{{/crossLink}} which can be paused, resumed, muted, etc.
 * Please see the {{#crossLink "AbstractSoundInstance"}}{{/crossLink}} documentation for more on the instance control APIs.
 * 
 * <b>Plugins</b><br />
 * By default, the {{#crossLink "WebAudioPlugin"}}{{/crossLink}} or the {{#crossLink "HTMLAudioPlugin"}}{{/crossLink}}
 * are used (when available), although developers can change plugin priority or add new plugins (such as the
 * provided {{#crossLink "FlashAudioPlugin"}}{{/crossLink}}). Please see the {{#crossLink "Sound"}}{{/crossLink}} API
 * methods for more on the playback and plugin APIs. To install plugins, or specify a different plugin order, see
 * {{#crossLink "Sound/installPlugins"}}{{/crossLink}}.
 * 
 * <h4>Example</h4>
 * 
 *      createjs.Sound.registerPlugins([createjs.WebAudioPlugin, createjs.FlashAudioPlugin]);
 *      createjs.Sound.alternateExtensions = ["mp3"];
 *      createjs.Sound.on("fileload", createjs.proxy(this.loadHandler, (this));
 *      createjs.Sound.registerSound("path/to/mySound.ogg", "sound");
 *      function loadHandler(event) {
 *          // This is fired for each sound that is registered.
 *          var instance = createjs.Sound.play("sound");  // play using id.  Could also use full source path or event.src.
 *          instance.on("complete", createjs.proxy(this.handleComplete, this));
 *          instance.volume = 0.5;
 *      }
 * 
 * The maximum number of concurrently playing instances of the same sound can be specified in the "data" argument
 * of {{#crossLink "Sound/registerSound"}}{{/crossLink}}.  Note that if not specified, the active plugin will apply
 * a default limit.  Currently HTMLAudioPlugin sets a default limit of 2, while WebAudioPlugin and FlashAudioPlugin set a
 * default limit of 100.
 * 
 *      createjs.Sound.registerSound("sound.mp3", "soundId", 4);
 * 
 * Sound can be used as a plugin with PreloadJS to help preload audio properly. Audio preloaded with PreloadJS is
 * automatically registered with the Sound class. When audio is not preloaded, Sound will do an automatic internal
 * load. As a result, it may fail to play the first time play is called if the audio is not finished loading. Use the
 * {{#crossLink "Sound/fileload"}}{{/crossLink}} event to determine when a sound has finished internally preloading.
 * It is recommended that all audio is preloaded before it is played.
 * 
 *      var queue = new createjs.LoadQueue();
 * 		queue.installPlugin(createjs.Sound);
 * 
 * <b>Audio Sprites</b><br />
 * SoundJS has added support for Audio Sprites, available as of version 0.6.0.
 * For those unfamiliar with audio sprites, they are much like CSS sprites or sprite sheets: multiple audio assets
 * grouped into a single file.
 * 
 * Benefits of Audio Sprites
 * <ul><li>More robust support for older browsers and devices that only allow a single audio instance, such as iOS 5.</li>
 * <li>They provide a work around for the Internet Explorer 9 audio tag limit, which until now restricted how many
 * different sounds we could load at once.</li>
 * <li>Faster loading by only requiring a single network request for several sounds, especially on mobile devices
 * where the network round trip for each file can add significant latency.</li></ul>
 * 
 * Drawbacks of Audio Sprites
 * <ul><li>No guarantee of smooth looping when using HTML or Flash audio.  If you have a track that needs to loop
 * smoothly and you are supporting non-web audio browsers, do not use audio sprites for that sound if you can avoid it.</li>
 * <li>No guarantee that HTML audio will play back immediately, especially the first time. In some browsers (Chrome!),
 * HTML audio will only load enough to play through – so we rely on the “canplaythrough” event to determine if the audio is loaded.
 * Since audio sprites must jump ahead to play specific sounds, the audio may not yet have downloaded.</li>
 * <li>Audio sprites share the same core source, so if you have a sprite with 5 sounds and are limited to 2
 * concurrently playing instances, that means you can only play 2 of the sounds at the same time.</li></ul>
 * 
 * <h4>Example</h4>
 * 
 *      createjs.Sound.initializeDefaultPlugins();
 * 		var assetsPath = "./assets/";
 * 		var sounds = [{
 * 			src:"MyAudioSprite.ogg", data: {
 * 				audioSprite: [
 * 					{id:"sound1", startTime:0, duration:500},
 * 					{id:"sound2", startTime:1000, duration:400},
 * 					{id:"sound3", startTime:1700, duration: 1000}
 * 				]}
 * 				}
 * 		];
 * 		createjs.Sound.alternateExtensions = ["mp3"];
 * 		createjs.Sound.on("fileload", loadSound);
 * 		createjs.Sound.registerSounds(sounds, assetsPath);
 * 		// after load is complete
 * 		createjs.Sound.play("sound2");
 * 
 * You can also create audio sprites on the fly by setting the startTime and duration when creating an new AbstractSoundInstance.
 * 
 * 		createjs.Sound.play("MyAudioSprite", {startTime: 1000, duration: 400});
 * 
 * <b>Mobile Safe Approach</b><br />
 * Mobile devices require sounds to be played inside of a user initiated event (touch/click) in varying degrees.
 * As of SoundJS 0.4.1, you can launch a site inside of a user initiated event and have audio playback work. To
 * enable as broadly as possible, the site needs to setup the Sound plugin in its initialization (for example via
 * <code>createjs.Sound.initializeDefaultPlugins();</code>), and all sounds need to be played in the scope of the
 * application.  See the MobileSafe demo for a working example.
 * 
 * <h4>Example</h4>
 * 
 *     document.getElementById("status").addEventListener("click", handleTouch, false);    // works on Android and iPad
 *     function handleTouch(event) {
 *         document.getElementById("status").removeEventListener("click", handleTouch, false);    // remove the listener
 *         var thisApp = new myNameSpace.MyApp();    // launch the app
 *     }
 * 
 * <h4>Known Browser and OS issues</h4>
 * <b>IE 9 HTML Audio limitations</b><br />
 * <ul><li>There is a delay in applying volume changes to tags that occurs once playback is started. So if you have
 * muted all sounds, they will all play during this delay until the mute applies internally. This happens regardless of
 * when or how you apply the volume change, as the tag seems to need to play to apply it.</li>
 * <li>MP3 encoding will not always work for audio tags, particularly in Internet Explorer. We've found default
 * encoding with 64kbps works.</li>
 * <li>Occasionally very short samples will get cut off.</li>
 * <li>There is a limit to how many audio tags you can load and play at once, which appears to be determined by
 * hardware and browser settings.  See {{#crossLink "HTMLAudioPlugin.MAX_INSTANCES"}}{{/crossLink}} for a safe estimate.</li></ul>
 * 
 * <b>Firefox 25 Web Audio limitations</b>
 * <ul><li>mp3 audio files do not load properly on all windows machines, reported
 * <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=929969" target="_blank">here</a>. </br>
 * For this reason it is recommended to pass another FF supported type (ie ogg) first until this bug is resolved, if possible.</li></ul>
 * 
 * <b>Safari limitations</b><br />
 * <ul><li>Safari requires Quicktime to be installed for audio playback.</li></ul>
 * 
 * <b>iOS 6 Web Audio limitations</b><br />
 * <ul><li>Sound is initially muted and will only unmute through play being called inside a user initiated event
 * (touch/click).</li>
 * <li>A bug exists that will distort un-cached web audio when a video element is present in the DOM that has audio at a different sampleRate.</li>
 * <li>Note HTMLAudioPlugin is not supported on iOS by default.  See {{#crossLink "HTMLAudioPlugin"}}{{/crossLink}}
 * for more details.</li>
 * </ul>
 * 
 * <b>Android HTML Audio limitations</b><br />
 * <ul><li>We have no control over audio volume. Only the user can set volume on their device.</li>
 * <li>We can only play audio inside a user event (touch/click).  This currently means you cannot loop sound or use
 * a delay.</li></ul>
 */
extern class Sound
{
	/**
	 * The interrupt value to interrupt any currently playing instance with the same source, if the maximum number of
	 * instances of the sound are already playing.
	 */
	static var INTERRUPT_ANY : String;
	/**
	 * The interrupt value to interrupt the earliest currently playing instance with the same source that progressed the
	 * least distance in the audio track, if the maximum number of instances of the sound are already playing.
	 */
	static var INTERRUPT_EARLY : String;
	/**
	 * The interrupt value to interrupt the currently playing instance with the same source that progressed the most
	 * distance in the audio track, if the maximum number of instances of the sound are already playing.
	 */
	static var INTERRUPT_LATE : String;
	/**
	 * The interrupt value to not interrupt any currently playing instances with the same source, if the maximum number of
	 * instances of the sound are already playing.
	 */
	static var INTERRUPT_NONE : String;
	/**
	 * Defines the playState of an instance that is still initializing.
	 */
	static var PLAY_INITED : String;
	/**
	 * Defines the playState of an instance that is currently playing or paused.
	 */
	static var PLAY_SUCCEEDED : String;
	/**
	 * Defines the playState of an instance that was interrupted by another instance.
	 */
	static var PLAY_INTERRUPTED : String;
	/**
	 * Defines the playState of an instance that completed playback.
	 */
	static var PLAY_FINISHED : String;
	/**
	 * Defines the playState of an instance that failed to play. This is usually caused by a lack of available channels
	 * when the interrupt mode was "INTERRUPT_NONE", the playback stalled, or the sound could not be found.
	 */
	static var PLAY_FAILED : String;
	/**
	 * A list of the default supported extensions that Sound will <i>try</i> to play. Plugins will check if the browser
	 * can play these types, so modifying this list before a plugin is initialized will allow the plugins to try to
	 * support additional media types.
	 * 
	 * NOTE this does not currently work for {{#crossLink "FlashAudioPlugin"}}{{/crossLink}}.
	 * 
	 * More details on file formats can be found at <a href="http://en.wikipedia.org/wiki/Audio_file_format" target="_blank">http://en.wikipedia.org/wiki/Audio_file_format</a>.<br />
	 * A very detailed list of file formats can be found at <a href="http://www.fileinfo.com/filetypes/audio" target="_blank">http://www.fileinfo.com/filetypes/audio</a>.
	 */
	static var SUPPORTED_EXTENSIONS : Array<String>;
	/**
	 * Some extensions use another type of extension support to play (one of them is a codex).  This allows you to map
	 * that support so plugins can accurately determine if an extension is supported.  Adding to this list can help
	 * plugins determine more accurately if an extension is supported.
	 * 
	 * A useful list of extensions for each format can be found at <a href="http://html5doctor.com/html5-audio-the-state-of-play/" target="_blank">http://html5doctor.com/html5-audio-the-state-of-play/</a>.
	 */
	static var EXTENSION_MAP : Dynamic;
	/**
	 * Determines the default behavior for interrupting other currently playing instances with the same source, if the
	 * maximum number of instances of the sound are already playing.  Currently the default is {{#crossLink "Sound/INTERRUPT_NONE:property"}}{{/crossLink}}
	 * but this can be set and will change playback behavior accordingly.  This is only used when {{#crossLink "Sound/play"}}{{/crossLink}}
	 * is called without passing a value for interrupt.
	 */
	static var defaultInterruptBehavior : String;
	/**
	 * An array of extensions to attempt to use when loading sound, if the default is unsupported by the active plugin.
	 * These are applied in order, so if you try to Load Thunder.ogg in a browser that does not support ogg, and your
	 * extensions array is ["mp3", "m4a", "wav"] it will check mp3 support, then m4a, then wav. The audio files need
	 * to exist in the same location, as only the extension is altered.
	 * 
	 * Note that regardless of which file is loaded, you can call {{#crossLink "Sound/createInstance"}}{{/crossLink}}
	 * and {{#crossLink "Sound/play"}}{{/crossLink}} using the same id or full source path passed for loading.
	 * 
	 * <h4>Example</h4>
	 * 
	 * 	var sounds = [
	 * 		{src:"myPath/mySound.ogg", id:"example"},
	 * 	];
	 * 	createjs.Sound.alternateExtensions = ["mp3"]; // now if ogg is not supported, SoundJS will try asset0.mp3
	 * 	createjs.Sound.on("fileload", handleLoad); // call handleLoad when each sound loads
	 * 	createjs.Sound.registerSounds(sounds, assetPath);
	 * 	// ...
	 * 	createjs.Sound.play("myPath/mySound.ogg"); // works regardless of what extension is supported.  Note calling with ID is a better approach
	 */
	static var alternateExtensions : Array<Dynamic>;
	/**
	 * The currently active plugin. If this is null, then no plugin could be initialized. If no plugin was specified,
	 * Sound attempts to apply the default plugins: {{#crossLink "WebAudioPlugin"}}{{/crossLink}}, followed by
	 * {{#crossLink "HTMLAudioPlugin"}}{{/crossLink}}.
	 */
	static var activePlugin : Dynamic;

	/**
	 * Register a list of Sound plugins, in order of precedence. To register a single plugin, pass a single element in the array.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      createjs.FlashAudioPlugin.swfPath = "../src/soundjs/flashaudio/";
	 *      createjs.Sound.registerPlugins([createjs.WebAudioPlugin, createjs.HTMLAudioPlugin, createjs.FlashAudioPlugin]);
	 */
	static function registerPlugins(plugins:Array<Dynamic>) : Bool;
	/**
	 * Initialize the default plugins. This method is automatically called when any audio is played or registered before
	 * the user has manually registered plugins, and enables Sound to work without manual plugin setup. Currently, the
	 * default plugins are {{#crossLink "WebAudioPlugin"}}{{/crossLink}} followed by {{#crossLink "HTMLAudioPlugin"}}{{/crossLink}}.
	 * 
	 * <h4>Example</h4>
	 * 
	 * 	if (!createjs.initializeDefaultPlugins()) { return; }
	 */
	static function initializeDefaultPlugins() : Bool;
	/**
	 * Determines if Sound has been initialized, and a plugin has been activated.
	 * 
	 * <h4>Example</h4>
	 * This example sets up a Flash fallback, but only if there is no plugin specified yet.
	 * 
	 * 	if (!createjs.Sound.isReady()) {
	 * 		createjs.FlashAudioPlugin.swfPath = "../src/soundjs/flashaudio/";
	 * 		createjs.Sound.registerPlugins([createjs.WebAudioPlugin, createjs.HTMLAudioPlugin, createjs.FlashAudioPlugin]);
	 * 	}
	 */
	static function isReady() : Bool;
	/**
	 * Get the active plugins capabilities, which help determine if a plugin can be used in the current environment,
	 * or if the plugin supports a specific feature. Capabilities include:
	 * <ul>
	 *     <li><b>panning:</b> If the plugin can pan audio from left to right</li>
	 *     <li><b>volume;</b> If the plugin can control audio volume.</li>
	 *     <li><b>tracks:</b> The maximum number of audio tracks that can be played back at a time. This will be -1
	 *     if there is no known limit.</li>
	 * <br />An entry for each file type in {{#crossLink "Sound/SUPPORTED_EXTENSIONS:property"}}{{/crossLink}}:
	 *     <li><b>mp3:</b> If MP3 audio is supported.</li>
	 *     <li><b>ogg:</b> If OGG audio is supported.</li>
	 *     <li><b>wav:</b> If WAV audio is supported.</li>
	 *     <li><b>mpeg:</b> If MPEG audio is supported.</li>
	 *     <li><b>m4a:</b> If M4A audio is supported.</li>
	 *     <li><b>mp4:</b> If MP4 audio is supported.</li>
	 *     <li><b>aiff:</b> If aiff audio is supported.</li>
	 *     <li><b>wma:</b> If wma audio is supported.</li>
	 *     <li><b>mid:</b> If mid audio is supported.</li>
	 * </ul>
	 */
	static function getCapabilities() : Dynamic;
	/**
	 * Get a specific capability of the active plugin. See {{#crossLink "Sound/getCapabilities"}}{{/crossLink}} for a
	 * full list of capabilities.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      var maxAudioInstances = createjs.Sound.getCapability("tracks");
	 */
	static function getCapability(key:String) : Dynamic;
	/**
	 * Register an audio file for loading and future playback in Sound. This is automatically called when using
	 * <a href="http://preloadjs.com" target="_blank">PreloadJS</a>.  It is recommended to register all sounds that
	 * need to be played back in order to properly prepare and preload them. Sound does internal preloading when required.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      createjs.Sound.alternateExtensions = ["mp3"];
	 *      createjs.Sound.on("fileload", handleLoad); // add an event listener for when load is completed
	 *      createjs.Sound.registerSound("myAudioPath/mySound.ogg", "myID", 3);
	 */
	static function registerSound(src:Dynamic, ?id:String, ?data:Dynamic, basePath:String) : Dynamic;
	/**
	 * Register an array of audio files for loading and future playback in Sound. It is recommended to register all
	 * sounds that need to be played back in order to properly prepare and preload them. Sound does internal preloading
	 * when required.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      var sounds = [
	 *          {src:"asset0.ogg", id:"example"},
	 *          {src:"asset1.ogg", id:"1", data:6},
	 *          {src:"asset2.mp3", id:"works"}
	 *      ];
	 *      createjs.Sound.alternateExtensions = ["mp3"];	// if the passed extension is not supported, try this extension
	 *      createjs.Sound.on("fileload", handleLoad); // call handleLoad when each sound loads
	 *      createjs.Sound.registerSounds(sounds, assetPath);
	 */
	static function registerSounds(sounds:Array<Dynamic>, basePath:String) : Dynamic;
	/**
	 * Deprecated.  Please use {{#crossLink "Sound/registerSounds"}}{{/crossLink} instead.
	 */
	static function registerManifest(sounds:Array<Dynamic>, basePath:String) : Dynamic;
	/**
	 * Remove a sound that has been registered with {{#crossLink "Sound/registerSound"}}{{/crossLink}} or
	 * {{#crossLink "Sound/registerSounds"}}{{/crossLink}}.
	 * <br />Note this will stop playback on active instances playing this sound before deleting them.
	 * <br />Note if you passed in a basePath, you need to pass it or prepend it to the src here.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      createjs.Sound.removeSound("myAudioBasePath/mySound.ogg");
	 *      createjs.Sound.removeSound("myID");
	 */
	static function removeSound(src:Dynamic, basePath:String) : Bool;
	/**
	 * Remove an array of audio files that have been registered with {{#crossLink "Sound/registerSound"}}{{/crossLink}} or
	 * {{#crossLink "Sound/registerSounds"}}{{/crossLink}}.
	 * <br />Note this will stop playback on active instances playing this audio before deleting them.
	 * <br />Note if you passed in a basePath, you need to pass it or prepend it to the src here.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      var sounds = [
	 *          {src:"asset0.ogg", id:"example"},
	 *          {src:"asset1.ogg", id:"1", data:6},
	 *          {src:"asset2.mp3", id:"works"}
	 *      ];
	 *      createjs.Sound.removeSounds(sounds, assetPath);
	 */
	static function removeSounds(sounds:Array<Dynamic>, basePath:String) : Dynamic;
	/**
	 * Remove all sounds that have been registered with {{#crossLink "Sound/registerSound"}}{{/crossLink}} or
	 * {{#crossLink "Sound/registerSounds"}}{{/crossLink}}.
	 * <br />Note this will stop playback on all active sound instances before deleting them.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     createjs.Sound.removeAllSounds();
	 */
	static function removeAllSounds() : Void;
	/**
	 * Check if a source has been loaded by internal preloaders. This is necessary to ensure that sounds that are
	 * not completed preloading will not kick off a new internal preload if they are played.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     var mySound = "assetPath/asset0.ogg";
	 *     if(createjs.Sound.loadComplete(mySound) {
	 *         createjs.Sound.play(mySound);
	 *     }
	 */
	static function loadComplete(src:String) : Bool;
	/**
	 * Play a sound and get a {{#crossLink "AbstractSoundInstance"}}{{/crossLink}} to control. If the sound fails to play, a
	 * AbstractSoundInstance will still be returned, and have a playState of {{#crossLink "Sound/PLAY_FAILED:property"}}{{/crossLink}}.
	 * Note that even on sounds with failed playback, you may still be able to call AbstractSoundInstance {{#crossLink "AbstractSoundInstance/play"}}{{/crossLink}},
	 * since the failure could be due to lack of available channels. If the src does not have a supported extension or
	 * if there is no available plugin, a default AbstractSoundInstance will be returned which will not play any audio, but will not generate errors.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      createjs.Sound.on("fileload", handleLoad);
	 *      createjs.Sound.registerSound("myAudioPath/mySound.mp3", "myID", 3);
	 *      function handleLoad(event) {
	 *      	createjs.Sound.play("myID");
	 *      	// we can pass in options we want to set inside of an object, and store off AbstractSoundInstance for controlling
	 *      	var myInstance = createjs.Sound.play("myID", {interrupt: createjs.Sound.INTERRUPT_ANY, loop:-1});
	 *      	// alternately, we can pass full source path and specify each argument individually
	 *      	var myInstance = createjs.Sound.play("myAudioPath/mySound.mp3", createjs.Sound.INTERRUPT_ANY, 0, 0, -1, 1, 0);
	 *      }
	 * 
	 * NOTE to create an audio sprite that has not already been registered, both startTime and duration need to be set.
	 * This is only when creating a new audio sprite, not when playing using the id of an already registered audio sprite.
	 */
	static function play(src:String, ?interrupt:Dynamic, ?delay:Float, ?offset:Float, ?loop:Float, ?volume:Float, ?pan:Float, ?startTime:Float, ?duration:Float) : AbstractSoundInstance;
	/**
	 * Creates a {{#crossLink "AbstractSoundInstance"}}{{/crossLink}} using the passed in src. If the src does not have a
	 * supported extension or if there is no available plugin, a default AbstractSoundInstance will be returned that can be
	 * called safely but does nothing.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      var myInstance = null;
	 *      createjs.Sound.on("fileload", handleLoad);
	 *      createjs.Sound.registerSound("myAudioPath/mySound.mp3", "myID", 3);
	 *      function handleLoad(event) {
	 *      	myInstance = createjs.Sound.createInstance("myID");
	 *      	// alternately we could call the following
	 *      	myInstance = createjs.Sound.createInstance("myAudioPath/mySound.mp3");
	 *      }
	 * 
	 * NOTE to create an audio sprite that has not already been registered, both startTime and duration need to be set.
	 * This is only when creating a new audio sprite, not when playing using the id of an already registered audio sprite.
	 */
	static function createInstance(src:String, ?startTime:Float, ?duration:Float) : AbstractSoundInstance;
	/**
	 * Set the master volume of Sound. The master volume is multiplied against each sound's individual volume.  For
	 * example, if master volume is 0.5 and a sound's volume is 0.5, the resulting volume is 0.25. To set individual
	 * sound volume, use AbstractSoundInstance {{#crossLink "AbstractSoundInstance/setVolume"}}{{/crossLink}} instead.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     createjs.Sound.setVolume(0.5);
	 */
	static function setVolume(value:Float) : Void;
	/**
	 * Get the master volume of Sound. The master volume is multiplied against each sound's individual volume.
	 * To get individual sound volume, use AbstractSoundInstance {{#crossLink "AbstractSoundInstance/volume:property"}}{{/crossLink}} instead.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     var masterVolume = createjs.Sound.getVolume();
	 */
	static function getVolume() : Float;
	/**
	 * Mute/Unmute all audio. Note that muted audio still plays at 0 volume. This global mute value is maintained
	 * separately and when set will override, but not change the mute property of individual instances. To mute an individual
	 * instance, use AbstractSoundInstance {{#crossLink "AbstractSoundInstance/setMute"}}{{/crossLink}} instead.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     createjs.Sound.setMute(true);
	 */
	static function setMute(value:Bool) : Bool;
	/**
	 * Returns the global mute value. To get the mute value of an individual instance, use AbstractSoundInstance
	 * {{#crossLink "AbstractSoundInstance/getMute"}}{{/crossLink}} instead.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     var muted = createjs.Sound.getMute();
	 */
	static function getMute() : Bool;
	/**
	 * Stop all audio (global stop). Stopped audio is reset, and not paused. To play audio that has been stopped,
	 * call AbstractSoundInstance {{#crossLink "AbstractSoundInstance/play"}}{{/crossLink}}.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     createjs.Sound.stop();
	 */
	static function stop() : Void;
	/**
	 * Static initializer to mix EventDispatcher methods into a target object or prototype.
	 * 
	 * 		EventDispatcher.initialize(MyClass.prototype); // add to the prototype of the class
	 * 		EventDispatcher.initialize(myObject); // add to a specific instance
	 */
	static function initialize(target:Dynamic) : Void;
	/**
	 * Adds the specified event listener. Note that adding multiple listeners to the same function will result in
	 * multiple callbacks getting fired.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      displayObject.addEventListener("click", handleClick);
	 *      function handleClick(event) {
	 *         // Click happened.
	 *      }
	 */
	static function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool) : Dynamic;
	/**
	 * A shortcut method for using addEventListener that makes it easier to specify an execution scope, have a listener
	 * only run once, associate arbitrary data with the listener, and remove the listener.
	 * 
	 * This method works by creating an anonymous wrapper function and subscribing it with addEventListener.
	 * The created anonymous function is returned for use with .removeEventListener (or .off).
	 * 
	 * <h4>Example</h4>
	 * 
	 * 		var listener = myBtn.on("click", handleClick, null, false, {count:3});
	 * 		function handleClick(evt, data) {
	 * 			data.count -= 1;
	 * 			console.log(this == myBtn); // true - scope defaults to the dispatcher
	 * 			if (data.count == 0) {
	 * 				alert("clicked 3 times!");
	 * 				myBtn.off("click", listener);
	 * 				// alternately: evt.remove();
	 * 			}
	 * 		}
	 */
	static function on(type:String, listener:Dynamic, ?scope:Dynamic, ?once:Bool, ?data:Dynamic, ?useCapture:Bool) : Dynamic;
	/**
	 * Removes the specified event listener.
	 * 
	 * <b>Important Note:</b> that you must pass the exact function reference used when the event was added. If a proxy
	 * function, or function closure is used as the callback, the proxy/closure reference must be used - a new proxy or
	 * closure will not work.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      displayObject.removeEventListener("click", handleClick);
	 */
	static function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool) : Void;
	/**
	 * A shortcut to the removeEventListener method, with the same parameters and return value. This is a companion to the
	 * .on method.
	 */
	static function off(type:String, listener:Dynamic, ?useCapture:Bool) : Void;
	/**
	 * Removes all listeners for the specified type, or all listeners of all types.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      // Remove all listeners
	 *      displayObject.removeAllEventListeners();
	 * 
	 *      // Remove all click listeners
	 *      displayObject.removeAllEventListeners("click");
	 */
	static function removeAllEventListeners(?type:String) : Void;
	/**
	 * Dispatches the specified event to all listeners.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      // Use a string event
	 *      this.dispatchEvent("complete");
	 * 
	 *      // Use an Event instance
	 *      var event = new createjs.Event("progress");
	 *      this.dispatchEvent(event);
	 */
	static function dispatchEvent(eventObj:Dynamic) : Bool;
	/**
	 * Indicates whether there is at least one listener for the specified event type.
	 */
	static function hasEventListener(type:String) : Bool;
	/**
	 * Indicates whether there is at least one listener for the specified event type on this object or any of its
	 * ancestors (parent, parent's parent, etc). A return value of true indicates that if a bubbling event of the
	 * specified type is dispatched from this object, it will trigger at least one listener.
	 * 
	 * This is similar to {{#crossLink "EventDispatcher/hasEventListener"}}{{/crossLink}}, but it searches the entire
	 * event flow for a listener, not just this object.
	 */
	static function willTrigger(type:String) : Bool;
	function toString() : String;

	/**
	 * This event is fired when a file finishes loading internally. This event is fired for each loaded sound,
	 * so any handler methods should look up the <code>event.src</code> to handle a particular sound.
	 */
	static inline function addFileloadEventListener(handler:SoundFileloadEvent->Void, ?useCapture:Bool) : Dynamic return addEventListener("fileload", handler, useCapture);
	inline function removeFileloadEventListener(handler:SoundFileloadEvent->Void, ?useCapture:Bool) : Void removeEventListener("fileload", handler, useCapture);
	/**
	 * This event is fired when a file fails loading internally. This event is fired for each loaded sound,
	 * so any handler methods should look up the <code>event.src</code> to handle a particular sound.
	 */
	static inline function addFileerrorEventListener(handler:SoundFileerrorEvent->Void, ?useCapture:Bool) : Dynamic return addEventListener("fileerror", handler, useCapture);
	inline function removeFileerrorEventListener(handler:SoundFileerrorEvent->Void, ?useCapture:Bool) : Void removeEventListener("fileerror", handler, useCapture);
}