package createjs;

typedef SoundOptions =
{
	@:optional var interrupt : String;
	
	/**
	 * The delay in milliseconds before the sound starts.
	 */
	@:optional var delay : Int;
	
	/**
	 * How far into the sound to begin playback, in milliseconds.
	 */
	@:optional var offset : Int;
	
	/**
	 * The number of times to loop the audio. Use -1 for infinite loops.
	 */
	@:optional var loop : Int;
	
	/**
	 * The volume of the sound, between 0 and 1.
	 */
	@:optional var volume : Float;
	
	/**
	 * The pan of the sound between -1 (left) and 1 (right). Note that pan is not supported for HTML Audio.
	 */
	@:optional var pan : Float;
	
	/**
	 * To create an audio sprite (with duration), the initial offset to start playback and loop from, in milliseconds.
	 */
	@:optional var startTime : Int;
	
	/**
	 * To create an audio sprite (with startTime), the amount of time to play the clip for, in milliseconds.
	 */
	@:optional var duration : Int;
}
