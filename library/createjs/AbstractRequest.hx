package createjs;

/**
 * A base class for actual data requests, such as {{#crossLink "XHRRequest"}}{{/crossLink}}, {{#crossLink "TagRequest"}}{{/crossLink}},
 * and {{#crossLink "MediaRequest"}}{{/crossLink}}. PreloadJS loaders will typically use a data loader under the
 * hood to get data.
 */
extern class AbstractRequest
{
	function new(item:LoadItem) : Void;

	/**
	 * Begin a load.
	 */
	function load() : Void;
	/**
	 * Clean up a request.
	 */
	function destroy() : Void;
	/**
	 * Cancel an in-progress request.
	 */
	function cancel() : Void;
}