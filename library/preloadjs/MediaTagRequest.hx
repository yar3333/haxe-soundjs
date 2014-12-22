package preloadjs;

/**
 * An {{#crossLink "TagRequest"}}{{/crossLink}} that loads HTML tags for video and audio.
 */
@:native("createjs.MediaTagRequest")
extern class MediaTagRequest
{
	function new(loadItem:preloadjs.LoadItem, tag:Dynamic, srcAttribute:String) : Void;
}