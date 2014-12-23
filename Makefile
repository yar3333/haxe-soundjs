OPTIONS+= -src out/data.json
OPTIONS+= --remove-path-prefix native/src
OPTIONS+= --native-package createjs

OPTIONS+= -ifile soundjs/version.js
OPTIONS+= -ifile soundjs/flashaudio/FlashAudioSoundInstance.js
OPTIONS+= -ifile soundjs/htmlaudio/HTMLAudioSoundInstance.js
OPTIONS+= -ifile createjs/utils/indexOf.js 
OPTIONS+= -ifile createjs/utils/extend.js 
OPTIONS+= -ifile createjs/utils/promote.js 
OPTIONS+= -ifile createjs/utils/BrowserDetect.js
OPTIONS+= -ifile createjs/utils/definePropertySupported.js
OPTIONS+= -ifile createjs/utils/proxy.js

OPTIONS+= --type-map AudioNode-js.html.audio.AudioNode
OPTIONS+= --type-map AudioContext-js.html.audio.AudioContext
OPTIONS+= --type-map AudioGainNode-js.html.audio.AudioGain
OPTIONS+= --type-map AudioPannerNode-js.html.audio.PannerNode
OPTIONS+= --type-map RegExp-Dynamic

convert:
	yuidoc -p -o out native/src
	haxelib run yuidoc2haxe $(OPTIONS) library
	rm -r out
	haxelib run refactor process library *.hx postprocess.rules
