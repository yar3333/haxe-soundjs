package createjs;

/**
 * A general error {{#crossLink "Event"}}{{/crossLink}}, that describes an error that occurred, as well as any details.
 */
@:native("createjs.ErrorEvent")
extern class ErrorEvent
{
	/**
	 * The short error title, which indicates the type of error that occurred.
	 */
	var title : String;
	/**
	 * The verbose error message, containing details about the error.
	 */
	var message : String;
	/**
	 * Additional data attached to an error.
	 */
	var data : Dynamic;

	function new(?title:String, ?message:String, ?data:Dynamic) : Void;
}