package preloadjs;

/**
 * The AbstractMediaLoader is a base class that handles some of the shared methods and properties of loaders that
 * handle HTML media elements, such as Video and Audio.
 */
@:native("createjs.AbstractMediaLoader")
extern class AbstractMediaLoader
{
	function new(loadItem:Dynamic, preferXHR:Bool, type:String) : Void;
}