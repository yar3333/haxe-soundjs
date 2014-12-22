package preloadjs;

/**
 * Utilities that assist with parsing load items, and determining file types, etc.
 */
@:native("createjs.RequestUtils")
extern class RequestUtils
{
	/**
	 * The Regular Expression used to test file URLS for an absolute path.
	 */
	static var ABSOLUTE_PATH : Dynamic;
	/**
	 * The Regular Expression used to test file URLS for an absolute path.
	 */
	static var RELATIVE_PATH : Dynamic;
	/**
	 * The Regular Expression used to test file URLS for an extension. Note that URIs must already have the query string
	 * removed.
	 */
	static var EXTENSION_PATT : Dynamic;

	/**
	 * Parse a file path to determine the information we need to work with it. Currently, PreloadJS needs to know:
	 * <ul>
	 *     <li>If the path is absolute. Absolute paths start with a protocol (such as `http://`, `file://`, or
	 *     `//networkPath`)</li>
	 *     <li>If the path is relative. Relative paths start with `../` or `/path` (or similar)</li>
	 *     <li>The file extension. This is determined by the filename with an extension. Query strings are dropped, and
	 *     the file path is expected to follow the format `name.ext`.</li>
	 * </ul>
	 */
	static function parseURI(path:String) : Dynamic;
	/**
	 * Formats an object into a query string for either a POST or GET request.
	 */
	static function formatQueryString(data:Dynamic, ?query:Array<Dynamic>) : Void;
	/**
	 * A utility method that builds a file path using a source and a data object, and formats it into a new path.
	 */
	static function buildPath(src:String, ?data:Dynamic) : String;
	static function isCrossDomain(item:Dynamic) : Bool;
	static function isLocal(item:Dynamic) : Bool;
	/**
	 * Determine if a specific type should be loaded as a binary file. Currently, only images and items marked
	 * specifically as "binary" are loaded as binary. Note that audio is <b>not</b> a binary type, as we can not play
	 * back using an audio tag if it is loaded as binary. Plugins can change the item type to binary to ensure they get
	 * a binary result to work with. Binary files are loaded using XHR2. Types are defined as static constants on
	 * {{#crossLink "AbstractLoader"}}{{/crossLink}}.
	 */
	static function isBinary(type:String) : Bool;
	/**
	 * Check if item is a valid HTMLImageElement
	 */
	static function isImageTag(item:Dynamic) : Bool;
	/**
	 * Check if item is a valid HTMLAudioElement
	 */
	static function isAudioTag(item:Dynamic) : Bool;
	/**
	 * Check if item is a valid HTMLVideoElement
	 */
	static function isVideoTag(item:Dynamic) : Bool;
	/**
	 * Determine if a specific type is a text-based asset, and should be loaded as UTF-8.
	 */
	static function isText(type:String) : Bool;
	/**
	 * Determine the type of the object using common extensions. Note that the type can be passed in with the load item
	 * if it is an unusual extension.
	 */
	static function getTypeByExtension(extension:String) : String;
}