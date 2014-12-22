package preloadjs;

typedef AbstractLoaderLoadstartEvent =
{
	var target : Dynamic;
	var type : String;
}

typedef AbstractLoaderCompleteEvent =
{
	var target : Dynamic;
	var type : String;
}

typedef AbstractLoaderFileerrorEvent =
{
	var target : Dynamic;
	var type : String;
	var The : Dynamic;
}

typedef AbstractLoaderFileloadEvent =
{
	var target : Dynamic;
	var type : String;
	var item : Dynamic;
	var result : Dynamic;
	var rawResult : Dynamic;
}

typedef AbstractLoaderInitializeEvent =
{
	var target : Dynamic;
	var type : String;
	var loader : AbstractLoader;
}

/**
 * The base loader, which defines all the generic methods, properties, and events. All loaders extend this class,
 * including the {{#crossLink "LoadQueue"}}{{/crossLink}}.
 */
@:native("createjs.AbstractLoader")
extern class AbstractLoader extends createjs.EventDispatcher
{
	/**
	 * If the loader has completed loading. This provides a quick check, but also ensures that the different approaches
	 * used for loading do not pile up resulting in more than one `complete` {{#crossLink "Event"}}{{/crossLink}}.
	 */
	var loaded : Bool;
	/**
	 * Determine if the loader was canceled. Canceled loads will not fire complete events. Note that this property
	 * is readonly, so {{#crossLink "LoadQueue"}}{{/crossLink}} queues should be closed using {{#crossLink "LoadQueue/close"}}{{/crossLink}}
	 * instead.
	 */
	var canceled : Bool;
	/**
	 * The current load progress (percentage) for this item. This will be a number between 0 and 1.
	 * 
	 * <h4>Example</h4>
	 * 
	 *     var queue = new createjs.LoadQueue();
	 *     queue.loadFile("largeImage.png");
	 *     queue.on("progress", function() {
	 *         console.log("Progress:", queue.progress, event.progress);
	 *     });
	 */
	var progress : Float;
	/**
	 * The type of item this loader will load. See {{#crossLink "AbstractLoader"}}{{/crossLink}} for a full list of
	 * supported types.
	 */
	var type : String;
	/**
	 * Defines a POST request, use for a method value when loading data.
	 */
	var POST : String;
	/**
	 * Defines a GET request, use for a method value when loading data.
	 */
	var GET : String;
	/**
	 * The preload type for generic binary types. Note that images are loaded as binary files when using XHR.
	 */
	static var BINARY : String;
	/**
	 * The preload type for css files. CSS files are loaded using a &lt;link&gt; when loaded with XHR, or a
	 * &lt;style&gt; tag when loaded with tags.
	 */
	static var CSS : String;
	/**
	 * The preload type for image files, usually png, gif, or jpg/jpeg. Images are loaded into an &lt;image&gt; tag.
	 */
	static var IMAGE : String;
	/**
	 * The preload type for javascript files, usually with the "js" file extension. JavaScript files are loaded into a
	 * &lt;script&gt; tag.
	 * 
	 * Since version 0.4.1+, due to how tag-loaded scripts work, all JavaScript files are automatically injected into
	 * the body of the document to maintain parity between XHR and tag-loaded scripts. In version 0.4.0 and earlier,
	 * only tag-loaded scripts are injected.
	 */
	static var JAVASCRIPT : String;
	/**
	 * The preload type for json files, usually with the "json" file extension. JSON data is loaded and parsed into a
	 * JavaScript object. Note that if a `callback` is present on the load item, the file will be loaded with JSONP,
	 * no matter what the {{#crossLink "LoadQueue/preferXHR:property"}}{{/crossLink}} property is set to, and the JSON
	 * must contain a matching wrapper function.
	 */
	static var JSON : String;
	/**
	 * The preload type for jsonp files, usually with the "json" file extension. JSON data is loaded and parsed into a
	 * JavaScript object. You are required to pass a callback parameter that matches the function wrapper in the JSON.
	 * Note that JSONP will always be used if there is a callback present, no matter what the {{#crossLink "LoadQueue/preferXHR:property"}}{{/crossLink}}
	 * property is set to.
	 */
	static var JSONP : String;
	/**
	 * The preload type for json-based manifest files, usually with the "json" file extension. The JSON data is loaded
	 * and parsed into a JavaScript object. PreloadJS will then look for a "manifest" property in the JSON, which is an
	 * Array of files to load, following the same format as the {{#crossLink "LoadQueue/loadManifest"}}{{/crossLink}}
	 * method. If a "callback" is specified on the manifest object, then it will be loaded using JSONP instead,
	 * regardless of what the {{#crossLink "LoadQueue/preferXHR:property"}}{{/crossLink}} property is set to.
	 */
	static var MANIFEST : String;
	/**
	 * The preload type for sound files, usually mp3, ogg, or wav. When loading via tags, audio is loaded into an
	 * &lt;audio&gt; tag.
	 */
	static var SOUND : String;
	/**
	 * The preload type for video files, usually mp4, ts, or ogg. When loading via tags, video is loaded into an
	 * &lt;video&gt; tag.
	 */
	static var VIDEO : String;
	/**
	 * The preload type for SpriteSheet files. SpriteSheet files are JSON files that contain string image paths.
	 */
	static var SPRITESHEET : String;
	/**
	 * The preload type for SVG files.
	 */
	static var SVG : String;
	/**
	 * The preload type for text files, which is also the default file type if the type can not be determined. Text is
	 * loaded as raw text.
	 */
	static var TEXT : String;
	/**
	 * The preload type for xml files. XML is loaded into an XML document.
	 */
	static var XML : String;
	/**
	 * A custom result formatter function, which is called just before a request dispatches its complete event. Most
	 * loader types already have an internal formatter, but this can be user-overridden for custom formatting. The
	 * formatted result will be available on Loaders using {{#crossLink "getResult"}}{{/crossLink}}, and passing `true`.
	 */
	var resultFormatter : Dynamic;

	/**
	 * Get a reference to the manifest item that is loaded by this loader. In some cases this will be the value that was
	 * passed into {{#crossLink "LoadQueue"}}{{/crossLink}} using {{#crossLink "LoadQueue/loadFile"}}{{/crossLink}} or
	 * {{#crossLink "LoadQueue/loadManifest"}}{{/crossLink}}. However if only a String path was passed in, then it will
	 * be a {{#crossLink "LoadItem"}}{{/crossLink}}.
	 */
	function getItem() : Dynamic;
	/**
	 * Get a reference to the content that was loaded by the loader (only available after the {{#crossLink "complete:event"}}{{/crossLink}}
	 * event is dispatched.
	 */
	function getResult(?raw:Bool) : Dynamic;
	/**
	 * Return the `tag` this object creates or uses for loading.
	 */
	function getTag() : Dynamic;
	/**
	 * Set the `tag` this item uses for loading.
	 */
	function setTag(tag:Dynamic) : Void;
	/**
	 * Begin loading the item. This method is required when using a loader by itself.
	 * 
	 * <h4>Example</h4>
	 * 
	 *      var queue = new createjs.LoadQueue();
	 *      queue.on("complete", handleComplete);
	 *      queue.loadManifest(fileArray, false); // Note the 2nd argument that tells the queue not to start loading yet
	 *      queue.load();
	 */
	function load() : Void;
	/**
	 * Close the the item. This will stop any open requests (although downloads using HTML tags may still continue in
	 * the background), but events will not longer be dispatched.
	 */
	function cancel() : Void;
	/**
	 * Clean up the loader.
	 */
	function destroy() : Void;
	/**
	 * Get any items loaded internally by the loader. The enables loaders such as {{#crossLink "ManifestLoader"}}{{/crossLink}}
	 * to expose items it loads internally.
	 */
	function getLoadedItems() : Array<Dynamic>;
	override function toString() : String;

	/**
	 * The {{#crossLink "ProgressEvent"}}{{/crossLink}} that is fired when the overall progress changes. Prior to
	 * version 0.6.0, this was just a regular {{#crossLink "Event"}}{{/crossLink}}.
	 */
	inline function addProgressEventListener(handler:Dynamic->Void) : Dynamic return addEventListener("progress", handler);
	/**
	 * The {{#crossLink "Event"}}{{/crossLink}} that is fired when a load starts.
	 */
	inline function addLoadstartEventListener(handler:AbstractLoaderLoadstartEvent->Void) : Dynamic return addEventListener("loadstart", handler);
	/**
	 * The {{#crossLink "Event"}}{{/crossLink}} that is fired when the entire queue has been loaded.
	 */
	inline function addCompleteEventListener(handler:AbstractLoaderCompleteEvent->Void) : Dynamic return addEventListener("complete", handler);
	/**
	 * The {{#crossLink "ErrorEvent"}}{{/crossLink}} that is fired when the loader encounters an error. If the error was
	 * encountered by a file, the event will contain the item that caused the error. Prior to version 0.6.0, this was
	 * just a regular {{#crossLink "Event"}}{{/crossLink}}.
	 */
	inline function addErrorEventListener(handler:Dynamic->Void) : Dynamic return addEventListener("error", handler);
	/**
	 * The {{#crossLink "Event"}}{{/crossLink}} that is fired when the loader encounters an internal file load error.
	 * This enables loaders to maintain internal queues, and surface file load errors.
	 */
	inline function addFileerrorEventListener(handler:AbstractLoaderFileerrorEvent->Void) : Dynamic return addEventListener("fileerror", handler);
	/**
	 * The {{#crossLink "Event"}}{{/crossLink}} that is fired when a loader internally loads a file. This enables
	 * loaders such as {{#crossLink "ManifestLoader"}}{{/crossLink}} to maintain internal {{#crossLink "LoadQueue"}}{{/crossLink}}s
	 * and notify when they have loaded a file. The {{#crossLink "LoadQueue"}}{{/crossLink}} class dispatches a
	 * slightly different {{#crossLink "LoadQueue/fileload:event"}}{{/crossLink}} event.
	 */
	inline function addFileloadEventListener(handler:AbstractLoaderFileloadEvent->Void) : Dynamic return addEventListener("fileload", handler);
	/**
	 * The {{#crossLink "Event"}}{{/crossLink}} that is fired after the internal request is created, but before a load.
	 * This allows updates to the loader for specific loading needs, such as binary or XHR image loading.
	 */
	inline function addInitializeEventListener(handler:AbstractLoaderInitializeEvent->Void) : Dynamic return addEventListener("initialize", handler);
}