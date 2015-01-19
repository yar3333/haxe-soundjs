package createjs;

/**
 * Loader provides a mechanism to preload Web Audio content via PreloadJS or internally. Instances are returned to
 * the preloader, and the load method is called when the asset needs to be requested.
 */
extern class WebAudioLoader extends XHRRequest
{
	/**
	 * web audio context required for decoding audio
	 */
	static var context : js.html.audio.AudioContext;
}