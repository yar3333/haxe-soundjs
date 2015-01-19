package createjs;

/**
 * Loader provides a mechanism to preload Flash content via PreloadJS or internally. Instances are returned to
 * the preloader, and the load method is called when the asset needs to be requested.
 */
extern class FlashAudioLoader extends AbstractLoader
{
	/**
	 * ID used to facilitate communication with flash.
	 * Not doc'd because this should not be altered externally
	 */
	var flashId : String;

	/**
	 * Set the Flash instance on the class, and start loading on any instances that had load called
	 * before flash was ready
	 */
	function setFlash(flash:Dynamic) : Void;
}