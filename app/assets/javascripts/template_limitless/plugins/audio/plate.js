(function($){
jQuery.fn.plate = function(options){
	opt = $.extend({
		autoplay: false,
		speed: 1.0,
		playlist: false,
		defCover: 'img/no_cover.png',
		volume: 50,
		random: false,
		width: 320,
		repeat: false
	}, options);
	
	var make = function(){
		$this = $(this);//елемент на який вішається плейер
		$audio = new Audio();//об'єкт плейера
/*--------------------------------------------------------------------
		КОНВЕРТЕРИ
---------------------------------------------------------------------*/
		$this.rotInSec = function(){
			return (78/opt.speed)/60;
			return 1.3;
		}
		
		$this.degToSec = function(deg){
			return deg*$this.rotInSec()/360;
		}
		
		$this.secToDeg = function(sec){
			return sec*360/$this.rotInSec();
		}
		
		$this.heightToDeg = function(height){
			return height*180/$record.height();
		}
		
		$this.heightToSec = function(height){
			return $this.degToSec($this.heightToDeg(height));
		}
		
		$this.secToPerc = function(sec){
			var perc = sec*100/$audio.duration;
			if(perc < 0){
				perc = 0;
			}else if(perc > 100){
				perc = 100;
			}
			return perc;
		}
		
		$this.secToMin = function(sec){
			sec = Number(sec);
			var mod = Math.floor(sec % 60);
			if(mod < 10){mod = '0' + mod;}
			return Math.floor(sec/60) + ':' + mod;
		}

		
/*--------------------------------------------------------------------
		ГЕНЕРАЦІЯ РОЗМІТКИ
---------------------------------------------------------------------*/
		$clr = $('<div class="clr"></div>');

		$album = $('<div class="album"></div>').append(
			$record = $('<div class="record"></div>'),
			$recordLight = $('<div class="record_light"></div>'),
			$cover = $('<img class="cover" src="'+opt.defCover+'" alt=""/>'),
			$glass = $('<div class="glass"></div>'),
			$playlist = $('<div class="playlist"></div>')
		);

		$info = $('<div class="info"></div>').append(
			$title = $('<b>&nbsp;</b>'),
			$artist = $('<div>&nbsp;</div>')
		);

		$volume = $('<div class="volume"></div>');
		
		$playlist.hide();
		$plControl = $('<div class="pl_btn">PLAYLIST</div>');

		$control = $('<div class="control"></div>').append(
			$prev = $('<div class="prev"></div>'),
			$play = $('<div class="play pause"></div>'),
			$next = $('<div class="next"></div>'),
			$repeat = $('<div class="repeat"></div>'),
			$random = $('<div class="random"></div>'),
			$speed = $('<div class="speed">1.0x</div>'),
			$clr
		);

		$time = $('<div class="time"></div>').append(
			$curTime = $('<b>0:00</b>'),
			' / ',
			$allTime = $('<span>0:00</span>')
		);

		$progress = $('<div class="progress"><div class="bufer seg0"></div>');
		
		
/*--------------------------------------------------------------------
		ІНІЦІАЛІЗАЦІЯ ТА ПОЧАТКОВІ НАЛАШТУВАННЯ ОБ'ЄКТІВ
---------------------------------------------------------------------*/
		//апдейт з кукісів
		opt.volume = $.cookie('plate_volume') ? $.cookie('plate_volume')*100 : opt.volume;
		opt.speed = $.cookie('plate_speed') ? $.cookie('plate_speed')*1 : opt.speed;
		opt.random = ($.cookie('plate_random') !== null)  ? $.cookie('plate_random')*1 : opt.random;
		opt.repeat = ($.cookie('plate_repeat') !== null) ? $.cookie('plate_repeat') : opt.repeat;
		opt.autoplay = ($.cookie('plate_play') !== null) ? $.cookie('plate_play')*1 : opt.autoplay;

		$audio.volume = opt.volume*0.01;

		//перемотка
		$progress.slider({animate:true, range:'min', value:0, min:0, max:0, step:1, slide:function(event, ui){
			$progress.handChange = true;
			$audio.currentTime = ui.value;
		}});

		//гучність
		$volume.slider({animate:true, range:'min', value:$audio.volume, min:0, max:1, step:0.01, slide:function(event, ui){
			$audio.volume = ui.value;
			$.cookie('plate_volume', ui.value);
		}});
		
		if(opt.repeat){//зациклювання
			$repeat.addClass(opt.repeat);
		}
		
		if(opt.random){//початкові налаштування перемішування плейлиста
			$random.addClass('active');
		}
		
		if(opt.autoplay){//знімаємо паузу, якщо автовідтворення
			$play.removeClass('pause');
		}
		
		$speed.playbackRate = opt.speed;//швидкість відтворення
		
		$recordLight.angle = 0.4;//крок бліку платівки
		
		//плейлист
		if(!opt.playlist){//зчитуємо швидкий, якщо нема нормального
			var tracks = $this.text().replace(/[\f\n\r\t ]*/gim, '').split(',');
			opt.playlist = [];
			tracks.forEach(function(src, i){
				opt.playlist[i] = {file: src};
			});
		}
		
		//візуалізація плейлиста
		opt.playlist.forEach(function(track, i){
			if(!track.title || !track.artist){//доповнюємо інфу метаданими з файлу
				ID3v2.parseURL(track.file, function(tags){//підгрузка метаданих з файлу
					if(!track.title){track.title = tags.Title ? tags.Title : '&nbsp;';}//назва
					if(!track.artist){track.artist = tags.Artist? tags.Artist : '&nbsp;';}//виконавець
					
					$playlist.append('<div class="track" rel="'+i+'">'+track.title+' - '+track.artist+'</div>');
				});
			}else{
				$playlist.append('<div class="track" rel="'+i+'">'+track.title+' - '+track.artist+'</div>');
			}
		});
		

		//очищуємо, додаємо "фірмовий" клас, ставимо ширину з налаштувань, запихуємо розмітку
		$this.empty().addClass('plate').css({width:opt.width}).append(
			$album,
			$clr,
			$volume,
			$plControl,
			$info,
			$clr,
			$control,
			$time,
			$clr,
			$progress
		);


/*--------------------------------------------------------------------
		ПОДІЇ АУДІО ОБ'ЄКТА
---------------------------------------------------------------------*/
		$audio.loadTrack = function(n){//ініціалізація конкретного трека
			$progress.find('.bufer').remove();//скидуємо візуалізацію буфера
			$progress.slider({value: 0});//скидуємо прогресбар
			$curTime.html('0:00');//скидуємо час
			$allTime.html('0:00');//скидуємо час
		
			//перевірка на нормальний номер треку
			if(n < 0 || n > opt.playlist.length-1){
				if(!$repeat.hasClass('all') && !$repeat.hasClass('one')){//якщо не повтор всіх треків, або одного
					$recordLight.unbind('mousedown');//off мікс платівки
					$play.addClass('pause');//переводимо кнопку-контроллер в режим паузи
				}
			}
			
			if(n < 0){n = opt.playlist.length-1;}//перший трек
			else if(n > opt.playlist.length-1){n = 0;}//останній трек

			$audio.currentTrack = n;//фіксуємо номер поточного треку
			$.cookie('plate_track', n);
			$playlist.find('.track').removeClass('active');
			$playlist.find('.track[rel='+n+']').addClass('active');//виділяємо активний трек в плейлисті
		
			if(!opt.playlist[n].duration){opt.playlist[n].duration = 120;}//fix на неможливість визначити довжину треку
			
			if(!opt.playlist[n].cover || !opt.playlist[n].title || !opt.playlist[n].artist){//доповнюємо інфу метаданими з файлу
				ID3v2.parseURL(opt.playlist[n].file, function(tags){//підгрузка метаданих з файлу
					if(!opt.playlist[n].cover){opt.playlist[n].cover = tags.pictures.length ? tags.pictures[0].dataURL : opt.defCover;}//обложка
					if(!opt.playlist[n].title){opt.playlist[n].title = tags.Title ? tags.Title : '&nbsp;';}//назва
					if(!opt.playlist[n].artist){opt.playlist[n].artist = tags.Artist? tags.Artist : '&nbsp;';}//виконавець
					$audio.loadTrack(n);
				});
			}else{
				$cover.attr('src', opt.playlist[n].cover);//обкладинка
				$title.html(opt.playlist[n].title);//назва
				$artist.html(opt.playlist[n].artist);//виконавець
				$audio.src = opt.playlist[n].file;//адреса файлу
				if(opt.playlist[n].duration){$progress.slider({max: opt.playlist[n].duration});}//діапазон прогресбара	
			}
		}
		
		$audio.addEventListener('loadedmetadata', function(e){//можна грати
			//діапазон прогресбара і тривалість трека
			if($audio.duration){
				$allTime.html($this.secToMin($audio.duration));
				$progress.slider({max: $audio.duration});
			}else{
				$allTime.html($this.secToMin(opt.playlist[n].duration));
				$progress.slider({max: opt.playlist[n].duration});
			}
			
			$audio.currentTime = $.cookie('plate_time')*1;//позиція з кукісів
			
			$audio.playbackRate = $speed.playbackRate;//виставляємо поточну швидкість
			$speed.html($speed.playbackRate.toFixed(1)+'x');//швидкість на панель!!!
			if($speed.html() == '1.0x'){$speed.removeClass('active');}
			else{$speed.addClass('active');}

			$album.animate({width:'100%'}, 700);//розгортаємо альбом
			
			if(!$play.hasClass('pause')){$audio.play();}//запускаємо, якщо не пауза
		});
		
		$audio.addEventListener('play', function(){
			$playlist.find('.track').removeClass('active');
			$playlist.find('.track[rel='+$audio.currentTrack+']').addClass('active');//виділяємо активний трек в плейлисті
			$recordLight.mousedown(function(e){//мікс платівки
				var oldy = e.pageY;
				$(this).mousemove(function(e){//рухаємо платівку мишею
					$audio.currentTime += $this.heightToSec(e.pageY - oldy);//змінюємо час композиції
					$record.rotate($this.secToDeg($audio.currentTime));//крутимо платівку
					oldy = e.pageY;//фіксуємо старий час
				});
				$(document).mouseup(function(){//вийшли за межі платівки при міксуванні
					$audio.playbackRate = $speed.playbackRate;//повертаємо нормальну швидкість
					$recordLight.unbind('mousemove');
				});
				return false;
			});
		});
		
		$audio.addEventListener('progress', function(){//візуалізація буфера
			for(var i = 0; i < $audio.buffered.length; i++){
				$seg = $progress.find('.seg'+i);
				if(!$seg.size()){//створюємо новий кусок
					$seg = $('<div class="bufer seg'+i+'"></div>').appendTo($progress);
				}
				$seg.css({//змінюємо розміри куска
					left:$this.secToPerc($audio.buffered.start(i))+'%',
					right:(100-$this.secToPerc($audio.buffered.end(i)))+'%'
				});
			}
		});
		
		$audio.addEventListener('timeupdate', function(){
			$record.rotate({animateTo:$this.secToDeg($audio.currentTime)});//крутипо платівку
			$recordLight.rotate($recordLight.angle*=-1);//рухаємо блік
			if($progress.handChange){//якщо не рухали прогресбар вручну
				$progress.handChange = false;
			}else{
				$progress.slider({value: $audio.currentTime});//оновлюємо прогресбар
			}
			//оновлюємо час
			if($time.hasClass('revers')){
				$curTime.html('- '+$this.secToMin($audio.duration - $audio.currentTime));//скільки залишилось
			}else{
				$curTime.html($this.secToMin($audio.currentTime));//скільки пройшло
			}
			$.cookie('plate_time', $audio.currentTime*1);//поточний час в куки
		});
		
		$audio.addEventListener('ended', function(){//трек закінчився
			if($repeat.hasClass('one')){//якшо повторювати один трек
				$audio.currentTime = 0;//спочатку
				$audio.play();//грати
			}else{//наступний трек
				$next.click();
			}
		});
		
		
/*--------------------------------------------------------------------
		КНОПКИ УПРАВЛІННЯ
---------------------------------------------------------------------*/
		$plControl.click(function(){
			$playlist.slideToggle(300);
			$(this).toggleClass('active');
		});
		
		$play.click(function(){
			$(this).toggleClass('pause');
			if($(this).hasClass('pause')){
				$audio.pause();
				$.cookie('plate_play', 0);
			}else{
				$audio.play();
				$.cookie('plate_play', 1);
			}
		});

		$next.click(function(){
			var num = 0;
			$.cookie('plate_time', 0);
			if($random.hasClass('active')){
				while(num == $audio.currentTrack){num = Math.floor(Math.random() * (opt.playlist.length));}
			}else{
				num = $audio.currentTrack + 1;
			}
			
			$audio.loadTrack(num);
		});
		
		$playlist.on('click', '.track', function(){
			$audio.loadTrack($(this).attr('rel'));
		});
		
		$prev.click(function(){
			var num = 0;
			$.cookie('plate_time', 0);
			if($random.hasClass('active')){
				while(num == $audio.currentTrack){num = Math.floor(Math.random() * (opt.playlist.length));}
			}else{
				num = $audio.currentTrack - 1;
			}

			$audio.loadTrack(num);
		});
		
		$repeat.click(function(){
			if($(this).hasClass('one')){
				$(this).removeClass('one').addClass('all');
				$.cookie('plate_repeat', 'all');
			}else if($(this).hasClass('all')){
				$(this).removeClass('all');
				$.cookie('plate_repeat', 0);
				if($random.hasClass('active')){
					$(this).addClass('one');
					$.cookie('plate_repeat', 'one');
				}
			}else{
				$(this).addClass('one');
				$.cookie('plate_repeat', 'one');
			}
		});
		
		$random.click(function(){
			if($(this).hasClass('active')){
				$(this).removeClass('active');
				$.cookie('plate_random', 0);
			}else{
				$(this).addClass('active');
				$.cookie('plate_random', 1);
				if(!$repeat.hasClass('one')){
					$repeat.addClass('all');
					$.cookie('plate_repeat', 'all');
				}
			}
		});
		
		$speed.click(function(){
			if($speed.playbackRate >= 2){
				$speed.playbackRate = 0.5;
			}else{
				$speed.playbackRate += 0.25;
			}

			$audio.playbackRate = $speed.playbackRate;
			$(this).html($speed.playbackRate.toFixed(1)+'x');
			
			$.cookie('plate_speed', $speed.playbackRate);
			
			if($(this).html() == '1.0x'){$(this).removeClass('active');}
			else{$(this).addClass('active');}
		});
		
		$time.click(function(){//переключалка часу
			$(this).toggleClass('revers');
			//оновлюємо час
			if($time.hasClass('revers')){
				$curTime.html('- '+$this.secToMin($audio.duration - $audio.currentTime));
			}else{
				$curTime.html($this.secToMin($audio.currentTime));
			}
			return false;
		});
		
/*--------------------------------------------------------------------
		ПУСК
---------------------------------------------------------------------*/
		$audio.loadTrack(($.cookie('plate_track') != null) ? $.cookie('plate_track')*1 : 0);
		
	};
	return this.each(make); 
};
})(jQuery);

jQuery(function(){
	jQuery('.quickPlate').plate();
});


/**
 * Cookie plugin
 *
 * Copyright (c) 2006 Klaus Hartl (stilbuero.de)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 */
jQuery.cookie=function(name,value,options){if(typeof value!='undefined'){options=options||{};if(value===null){value='';options=$.extend({},options);options.expires=-1;}var expires='';if(options.expires&&(typeof options.expires=='number'||options.expires.toUTCString)){var date;if(typeof options.expires=='number'){date=new Date();date.setTime(date.getTime()+(options.expires*24*60*60*1000));}else{date=options.expires;}expires='; expires='+date.toUTCString();}var path=options.path?'; path='+(options.path):'';var domain=options.domain?'; domain='+(options.domain):'';var secure=options.secure?'; secure':'';document.cookie=[name,'=',encodeURIComponent(value),expires,path,domain,secure].join('');}else{var cookieValue=null;if(document.cookie&&document.cookie!=''){var cookies=document.cookie.split(';');for(var i=0;i<cookies.length;i++){var cookie=jQuery.trim(cookies[i]);if(cookie.substring(0,name.length+1)==(name+'=')){cookieValue=decodeURIComponent(cookie.substring(name.length+1));break;}}}return cookieValue;}};
// VERSION: 2.3 LAST UPDATE: 11.07.2013
/* 
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 * 
 * Made by Wilq32, wilq32@gmail.com, Wroclaw, Poland, 01.2009
 * Website: http://code.google.com/p/jqueryrotate/ 
 */
(function(k){for(var d,f,l=document.getElementsByTagName("head")[0].style,h=["transformProperty","WebkitTransform","OTransform","msTransform","MozTransform"],g=0;g<h.length;g++)void 0!==l[h[g]]&&(d=h[g]);d&&(f=d.replace(/[tT]ransform/,"TransformOrigin"),"T"==f[0]&&(f[0]="t"));eval('IE = "v"=="\v"');jQuery.fn.extend({rotate:function(a){if(0!==this.length&&"undefined"!=typeof a){"number"==typeof a&&(a={angle:a});for(var b=[],c=0,d=this.length;c<d;c++){var e=this.get(c);if(e.Wilq32&&e.Wilq32.PhotoEffect)e.Wilq32.PhotoEffect._handleRotation(a); else{var f=k.extend(!0,{},a),e=(new Wilq32.PhotoEffect(e,f))._rootObj;b.push(k(e))}}return b}},getRotateAngle:function(){for(var a=[],b=0,c=this.length;b<c;b++){var d=this.get(b);d.Wilq32&&d.Wilq32.PhotoEffect&&(a[b]=d.Wilq32.PhotoEffect._angle)}return a},stopRotate:function(){for(var a=0,b=this.length;a<b;a++){var c=this.get(a);c.Wilq32&&c.Wilq32.PhotoEffect&&clearTimeout(c.Wilq32.PhotoEffect._timer)}}});Wilq32=window.Wilq32||{};Wilq32.PhotoEffect=function(){return d?function(a,b){a.Wilq32={PhotoEffect:this}; this._img=this._rootObj=this._eventObj=a;this._handleRotation(b)}:function(a,b){this._img=a;this._onLoadDelegate=[b];this._rootObj=document.createElement("span");this._rootObj.style.display="inline-block";this._rootObj.Wilq32={PhotoEffect:this};a.parentNode.insertBefore(this._rootObj,a);if(a.complete)this._Loader();else{var c=this;jQuery(this._img).bind("load",function(){c._Loader()})}}}();Wilq32.PhotoEffect.prototype={_setupParameters:function(a){this._parameters=this._parameters||{};"number"!==typeof this._angle&&(this._angle=0);"number"===typeof a.angle&&(this._angle=a.angle);this._parameters.animateTo="number"===typeof a.animateTo?a.animateTo:this._angle;this._parameters.step=a.step||this._parameters.step||null;this._parameters.easing=a.easing||this._parameters.easing||this._defaultEasing;this._parameters.duration=a.duration||this._parameters.duration||1E3;this._parameters.callback=a.callback||this._parameters.callback||this._emptyFunction;this._parameters.center=a.center||this._parameters.center||["50%","50%"];this._rotationCenterX="string"==typeof this._parameters.center[0]?parseInt(this._parameters.center[0],10)/100*this._imgWidth*this._aspectW:this._parameters.center[0];this._rotationCenterY="string"==typeof this._parameters.center[1]?parseInt(this._parameters.center[1],10)/100*this._imgHeight*this._aspectH:this._parameters.center[1];a.bind&&a.bind!=this._parameters.bind&&this._BindEvents(a.bind)},_emptyFunction:function(){},_defaultEasing:function(a,b,c,d,e){return-d*((b=b/e-1)*b*b*b-1)+c},_handleRotation:function(a,b){d||this._img.complete||b?(this._setupParameters(a),this._angle==this._parameters.animateTo?this._rotate(this._angle):this._animateStart()):this._onLoadDelegate.push(a)},_BindEvents:function(a){if(a&&this._eventObj){if(this._parameters.bind){var b=this._parameters.bind,c;for(c in b)b.hasOwnProperty(c)&&jQuery(this._eventObj).unbind(c,b[c])}this._parameters.bind=a;for(c in a)a.hasOwnProperty(c)&&jQuery(this._eventObj).bind(c,a[c])}},_Loader:function(){return IE?function(){var a=this._img.width,b=this._img.height;this._imgWidth=a;this._imgHeight=b;this._img.parentNode.removeChild(this._img);this._vimage=this.createVMLNode("image");this._vimage.src=this._img.src;this._vimage.style.height=b+"px";this._vimage.style.width=a+"px";this._vimage.style.position="absolute";this._vimage.style.top="0px";this._vimage.style.left="0px";this._aspectW=this._aspectH=1;this._container=this.createVMLNode("group");this._container.style.width=a;this._container.style.height=b;this._container.style.position="absolute";this._container.style.top="0px";this._container.style.left="0px";this._container.setAttribute("coordsize",a-1+","+(b-1));this._container.appendChild(this._vimage);this._rootObj.appendChild(this._container);this._rootObj.style.position="relative";this._rootObj.style.width=a+"px";this._rootObj.style.height=b+"px";this._rootObj.setAttribute("id",this._img.getAttribute("id"));this._rootObj.className=this._img.className;for(this._eventObj=this._rootObj;a=this._onLoadDelegate.shift();)this._handleRotation(a,!0)}:function(){this._rootObj.setAttribute("id",this._img.getAttribute("id"));this._rootObj.className=this._img.className;this._imgWidth=this._img.naturalWidth;this._imgHeight=this._img.naturalHeight;var a=Math.sqrt(this._imgHeight*this._imgHeight+this._imgWidth*this._imgWidth);this._width=3*a;this._height=3*a;this._aspectW=this._img.offsetWidth/this._img.naturalWidth;this._aspectH=this._img.offsetHeight/this._img.naturalHeight;this._img.parentNode.removeChild(this._img);this._canvas=document.createElement("canvas");this._canvas.setAttribute("width",this._width);this._canvas.style.position="relative";this._canvas.style.left=-this._img.height*this._aspectW+"px";this._canvas.style.top=-this._img.width*this._aspectH+"px";this._canvas.Wilq32=this._rootObj.Wilq32;this._rootObj.appendChild(this._canvas);this._rootObj.style.width=this._img.width*this._aspectW+"px";this._rootObj.style.height=this._img.height*this._aspectH+"px";this._eventObj=this._canvas;for(this._cnv=this._canvas.getContext("2d");a=this._onLoadDelegate.shift();)this._handleRotation(a,!0)}}(),_animateStart:function(){this._timer&&clearTimeout(this._timer);this._animateStartTime=+new Date;this._animateStartAngle=this._angle;this._animate()},_animate:function(){var a=+new Date,b=a-this._animateStartTime>this._parameters.duration;if(b&&!this._parameters.animatedGif)clearTimeout(this._timer);else{if(this._canvas||this._vimage||this._img)a=this._parameters.easing(0,a-this._animateStartTime,this._animateStartAngle,this._parameters.animateTo-this._animateStartAngle,this._parameters.duration),this._rotate(~~(10*a)/10);this._parameters.step&&this._parameters.step(this._angle);var c=this;this._timer=setTimeout(function(){c._animate.call(c)},10)}this._parameters.callback&&b&&(this._angle=this._parameters.animateTo,this._rotate(this._angle),this._parameters.callback.call(this._rootObj))},_rotate:function(){var a=Math.PI/180;return IE?function(a){this._angle=a;this._container.style.rotation=a%360+"deg";this._vimage.style.top=-(this._rotationCenterY-this._imgHeight/2)+"px";this._vimage.style.left=-(this._rotationCenterX-this._imgWidth/2)+"px";this._container.style.top=this._rotationCenterY-this._imgHeight/2+"px";this._container.style.left=this._rotationCenterX-this._imgWidth/2+"px"}:d?function(a){this._angle=a;this._img.style[d]="rotate("+a%360+"deg)";this._img.style[f]=this._parameters.center.join(" ")}:function(b){this._angle=b;b=b%360*a;this._canvas.width=this._width;this._canvas.height=this._height;this._cnv.translate(this._imgWidth*this._aspectW,this._imgHeight*this._aspectH);this._cnv.translate(this._rotationCenterX,this._rotationCenterY);this._cnv.rotate(b);this._cnv.translate(-this._rotationCenterX,-this._rotationCenterY);this._cnv.scale(this._aspectW,this._aspectH);this._cnv.drawImage(this._img,0,0)}}()};IE&&(Wilq32.PhotoEffect.prototype.createVMLNode=function(){document.createStyleSheet().addRule(".rvml","behavior:url(#default#VML)");try{return!document.namespaces.rvml&&document.namespaces.add("rvml","urn:schemas-microsoft-com:vml"),function(a){return document.createElement("<rvml:"+a+' class="rvml">')}}catch(a){return function(a){return document.createElement("<"+a+' xmlns="urn:schemas-microsoft.com:vml" class="rvml">')}}}())})(jQuery);
//meta from file
ID3v2 = {
	parseStream: function(stream, onComplete){
		var PICTURE_TYPES = {
			"0": "Other",
			"1": "32x32 pixels 'file icon' (PNG only)",
			"2": "Other file icon",
			"3": "Cover (front)",
			"4": "Cover (back)",
			"5": "Leaflet page",
			"6": "Media (e.g. lable side of CD)",
			"7": "Lead artist/lead performer/soloist",
			"8": "Artist/performer",
			"9": "Conductor",
			"A": "Band/Orchestra",
			"B": "Composer",
			"C": "Lyricist/text writer",
			"D": "Recording Location",
			"E": "During recording",
			"F": "During performance",
			"10": "Movie/video screen capture",
			"11": "A bright coloured fish",
			"12": "Illustration",
			"13": "Band/artist logotype",
			"14": "Publisher/Studio logotype"
		}

		var TAGS = {
		'AENC': 'Audio encryption',
		'APIC': 'Attached picture',
		'COMM': 'Comments',
		'COMR': 'Commercial frame',
		'ENCR': 'Encryption method registration',
		'EQUA': 'Equalization',
		'ETCO': 'Event timing codes',
		'GEOB': 'General encapsulated object',
		'GRID': 'Group identification registration',
		'IPLS': 'Involved people list',
		'LINK': 'Linked information',
		'MCDI': 'Music CD identifier',
		'MLLT': 'MPEG location lookup table',
		'OWNE': 'Ownership frame',
		'PRIV': 'Private frame',
		'PCNT': 'Play counter',
		'POPM': 'Popularimeter',
		'POSS': 'Position synchronisation frame',
		'RBUF': 'Recommended buffer size',
		'RVAD': 'Relative volume adjustment',
		'RVRB': 'Reverb',
		'SYLT': 'Synchronized lyric/text',
		'SYTC': 'Synchronized tempo codes',
		'TALB': 'Album',
		'TBPM': 'BPM',
		'TCOM': 'Composer',
		'TCON': 'Genre',
		'TCOP': 'Copyright message',
		'TDAT': 'Date',
		'TDLY': 'Playlist delay',
		'TENC': 'Encoded by',
		'TEXT': 'Lyricist',
		'TFLT': 'File type',
		'TIME': 'Time',
		'TIT1': 'Content group description',
		'TIT2': 'Title',
		'TIT3': 'Subtitle',
		'TKEY': 'Initial key',
		'TLAN': 'Language(s)',
		'TLEN': 'Length',
		'TMED': 'Media type',
		'TOAL': 'Original album',
		'TOFN': 'Original filename',
		'TOLY': 'Original lyricist',
		'TOPE': 'Original artist',
		'TORY': 'Original release year',
		'TOWN': 'File owner',
		'TPE1': 'Artist',
		'TPE2': 'Band',
		'TPE3': 'Conductor',
		'TPE4': 'Interpreted, remixed, or otherwise modified by',
		'TPOS': 'Part of a set',
		'TPUB': 'Publisher',
		'TRCK': 'Track number',
		'TRDA': 'Recording dates',
		'TRSN': 'Internet radio station name',
		'TRSO': 'Internet radio station owner',
		'TSIZ': 'Size',
		'TSRC': 'ISRC (international standard recording code)',
		'TSSE': 'Software/Hardware and settings used for encoding',
		'TYER': 'Year',
		'TXXX': 'User defined text information frame',
		'UFID': 'Unique file identifier',
		'USER': 'Terms of use',
		'USLT': 'Unsychronized lyric/text transcription',
		'WCOM': 'Commercial information',
		'WCOP': 'Copyright/Legal information',
		'WOAF': 'Official audio file webpage',
		'WOAR': 'Official artist/performer webpage',
		'WOAS': 'Official audio source webpage',
		'WORS': 'Official internet radio station homepage',
		'WPAY': 'Payment',
		'WPUB': 'Publishers official webpage',
		'WXXX': 'User defined URL link frame'
	  };
	  
		var TAG_MAPPING_2_2_to_2_3 = {
		'BUF': 'RBUF',
		'COM': 'COMM',
		'CRA': 'AENC',
		'EQU': 'EQUA',
		'ETC': 'ETCO',
		'GEO': 'GEOB',
		'MCI': 'MCDI',
		'MLL': 'MLLT',
		'PIC': 'APIC',
		'POP': 'POPM',
		'REV': 'RVRB',
		'RVA': 'RVAD',
		'SLT': 'SYLT',
		'STC': 'SYTC',
		'TAL': 'TALB',
		'TBP': 'TBPM',
		'TCM': 'TCOM',
		'TCO': 'TCON',
		'TCR': 'TCOP',
		'TDA': 'TDAT',
		'TDY': 'TDLY',
		'TEN': 'TENC',
		'TFT': 'TFLT',
		'TIM': 'TIME',
		'TKE': 'TKEY',
		'TLA': 'TLAN',
		'TLE': 'TLEN',
		'TMT': 'TMED',
		'TOA': 'TOPE',
		'TOF': 'TOFN',
		'TOL': 'TOLY',
		'TOR': 'TORY',
		'TOT': 'TOAL',
		'TP1': 'TPE1',
		'TP2': 'TPE2',
		'TP3': 'TPE3',
		'TP4': 'TPE4',
		'TPA': 'TPOS',
		'TPB': 'TPUB',
		'TRC': 'TSRC',
		'TRD': 'TRDA',
		'TRK': 'TRCK',
		'TSI': 'TSIZ',
		'TSS': 'TSSE',
		'TT1': 'TIT1',
		'TT2': 'TIT2',
		'TT3': 'TIT3',
		'TXT': 'TEXT',
		'TXX': 'TXXX',
		'TYE': 'TYER',
		'UFI': 'UFID',
		'ULT': 'USLT',
		'WAF': 'WOAF',
		'WAR': 'WOAR',
		'WAS': 'WOAS',
		'WCM': 'WCOM',
		'WCP': 'WCOP',
		'WPB': 'WPB',
		'WXX': 'WXXX'
	  };

	  var ID3_2_GENRES = {
			'0': 'Blues',
			'1': 'Classic Rock',
			'2': 'Country',
			'3': 'Dance',
			'4': 'Disco',
			'5': 'Funk',
			'6': 'Grunge',
			'7': 'Hip-Hop',
			'8': 'Jazz',
			'9': 'Metal',
			'10': 'New Age',
			'11': 'Oldies',
			'12': 'Other',
			'13': 'Pop',
			'14': 'R&B',
			'15': 'Rap',
			'16': 'Reggae',
			'17': 'Rock',
			'18': 'Techno',
			'19': 'Industrial',
			'20': 'Alternative',
			'21': 'Ska',
			'22': 'Death Metal',
			'23': 'Pranks',
			'24': 'Soundtrack',
			'25': 'Euro-Techno',
			'26': 'Ambient',
			'27': 'Trip-Hop',
			'28': 'Vocal',
			'29': 'Jazz+Funk',
			'30': 'Fusion',
			'31': 'Trance',
			'32': 'Classical',
			'33': 'Instrumental',
			'34': 'Acid',
			'35': 'House',
			'36': 'Game',
			'37': 'Sound Clip',
			'38': 'Gospel',
			'39': 'Noise',
			'40': 'AlternRock',
			'41': 'Bass',
			'42': 'Soul',
			'43': 'Punk',
			'44': 'Space',
			'45': 'Meditative',
			'46': 'Instrumental Pop',
			'47': 'Instrumental Rock',
			'48': 'Ethnic',
			'49': 'Gothic',
			'50': 'Darkwave',
			'51': 'Techno-Industrial',
			'52': 'Electronic',
			'53': 'Pop-Folk',
			'54': 'Eurodance',
			'55': 'Dream',
			'56': 'Southern Rock',
			'57': 'Comedy',
			'58': 'Cult',
			'59': 'Gangsta',
			'60': 'Top 40',
			'61': 'Christian Rap',
			'62': 'Pop/Funk',
			'63': 'Jungle',
			'64': 'Native American',
			'65': 'Cabaret',
			'66': 'New Wave',
			'67': 'Psychadelic',
			'68': 'Rave',
			'69': 'Showtunes',
			'70': 'Trailer',
			'71': 'Lo-Fi',
			'72': 'Tribal',
			'73': 'Acid Punk',
			'74': 'Acid Jazz',
			'75': 'Polka',
			'76': 'Retro',
			'77': 'Musical',
			'78': 'Rock & Roll',
			'79': 'Hard Rock',
			'80': 'Folk',
			'81': 'Folk-Rock',
			'82': 'National Folk',
			'83': 'Swing',
			'84': 'Fast Fusion',
			'85': 'Bebob',
			'86': 'Latin',
			'87': 'Revival',
			'88': 'Celtic',
			'89': 'Bluegrass',
			'90': 'Avantgarde',
			'91': 'Gothic Rock',
			'92': 'Progressive Rock',
			'93': 'Psychedelic Rock',
			'94': 'Symphonic Rock',
			'95': 'Slow Rock',
			'96': 'Big Band',
			'97': 'Chorus',
			'98': 'Easy Listening',
			'99': 'Acoustic',
			'100': 'Humour',
			'101': 'Speech',
			'102': 'Chanson',
			'103': 'Opera',
			'104': 'Chamber Music',
			'105': 'Sonata',
			'106': 'Symphony',
			'107': 'Booty Bass',
			'108': 'Primus',
			'109': 'Porn Groove',
			'110': 'Satire',
			'111': 'Slow Jam',
			'112': 'Club',
			'113': 'Tango',
			'114': 'Samba',
			'115': 'Folklore',
			'116': 'Ballad',
			'117': 'Power Ballad',
			'118': 'Rhythmic Soul',
			'119': 'Freestyle',
			'120': 'Duet',
			'121': 'Punk Rock',
			'122': 'Drum Solo',
			'123': 'A capella',
			'124': 'Euro-House',
			'125': 'Dance Hall'
		};
			
		var tag = {
			pictures: []
		};
		
		
		var max_size = Infinity;
		
		function read(bytes, callback){
			stream(bytes, callback, max_size);
		}
		
		
		function encode_64(input){
			var output = '', i = 0, l = input.length,
			key = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", 
			chr1, chr2, chr3, enc1, enc2, enc3, enc4;
			while (i < l) {
				chr1 = input.charCodeAt(i++);
				chr2 = input.charCodeAt(i++);
				chr3 = input.charCodeAt(i++);
				enc1 = chr1 >> 2;
				enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
				enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
				enc4 = chr3 & 63;
				if (isNaN(chr2)) enc3 = enc4 = 64;
				else if (isNaN(chr3)) enc4 = 64;
				output = output + key.charAt(enc1) + key.charAt(enc2) + key.charAt(enc3) + key.charAt(enc4);
			}
			return output;
		}



		function parseDuration(ms){
			var msec = parseInt(cleanText(ms)); 
			var secs = Math.floor(msec/1000);
			var mins = Math.floor(secs/60);
			var hours = Math.floor(mins/60);
			var days = Math.floor(hours/24);
		
			return {
				milliseconds: msec%1000,
				seconds: secs%60,
				minutes: mins%60,
				hours: hours%24,
				days: days
			};
		}


		function pad(num){
			var arr = num.toString(2);
			return (new Array(8-arr.length+1)).join('0') + arr;
		}

		function arr2int(data){
			if(data.length == 4){
				if(tag.revision > 3){
					var size = data[0] << 0x15;
					size += data[1] << 14;
					size += data[2] << 7;
					size += data[3];
				}else{
					var size = data[0] << 24;
					size += data[1] << 16;
					size += data[2] << 8;
					size += data[3];
				}
			}else{
				var size = data[0] << 16;
				size += data[1] << 8;
				size += data[2];
			}
			return size;
		}
		
		function parseImage(str){
			var TextEncoding = str.charCodeAt(0);
			str = str.substr(1);
			var MimeTypePos = str.indexOf('\0');
			var MimeType = str.substr(0, MimeTypePos);
			str = str.substr(MimeTypePos+1);
			var PictureType = str.charCodeAt(0);
			var TextPictureType = PICTURE_TYPES[PictureType.toString(16).toUpperCase()];
			str = str.substr(1);
			var DescriptionPos = str.indexOf('\0');
			var Description = str.substr(0, DescriptionPos);
			str = str.substr(DescriptionPos+1);
			var PictureData = str;
			var Magic = PictureData.split('').map(function(e){return String.fromCharCode(e.charCodeAt(0) & 0xff)}).join('');
			return {
				dataURL: 'data:'+MimeType+';base64,'+encode_64(Magic),
				PictureType: TextPictureType,
				Description: Description,
				MimeType: MimeType
			};
		}
		
		function parseImage2(str){
			var TextEncoding = str.charCodeAt(0);
			str = str.substr(1);
			var Type = str.substr(0, 3);
			str = str.substr(3);
			
			var PictureType = str.charCodeAt(0);
			var TextPictureType = PICTURE_TYPES[PictureType.toString(16).toUpperCase()];
			
			str = str.substr(1);
			var DescriptionPos = str.indexOf('\0');
			var Description = str.substr(0, DescriptionPos);
			str = str.substr(DescriptionPos+1);
			var PictureData = str;
			var Magic = PictureData.split('').map(function(e){return String.fromCharCode(e.charCodeAt(0) & 0xff)}).join('');
			return {
				dataURL: 'data:img/'+Type+';base64,'+encode_64(Magic),
				PictureType: TextPictureType,
				Description: Description,
				MimeType: MimeType
			};
		}

		var TAG_HANDLERS = {
			"APIC": function(size, s, a){
				tag.pictures.push(parseImage(s));
			},
			"PIC": function(size, s, a){
				tag.pictures.push(parseImage2(s));
			},
			"TLEN": function(size, s, a){
				tag.Length = parseDuration(s);
			},
			"TCON": function(size, s, a){
				s = cleanText(s);
				if(/\([0-9]+\)/.test(s)){
					var genre = ID3_2_GENRES[parseInt(s.replace(/[\(\)]/g,''))];
				}else{
					var genre = s;
				}
				tag.Genre = genre;
			}
		};

		function read_frame(){
			if(tag.revision < 3){
				read(3, function(frame_id){
					if(/[A-Z0-9]{3}/.test(frame_id)){
						var new_frame_id = TAG_MAPPING_2_2_to_2_3[frame_id.substr(0,3)];
						read_frame2(frame_id, new_frame_id);
					}else{
						onComplete(tag);
						return;
					}
				})
			}else{
				read(4, function(frame_id){
					if(/[A-Z0-9]{4}/.test(frame_id)){
						read_frame3(frame_id);
					}else{
						onComplete(tag);
						return;
					}
				})
			}
		}
		
		
		function cleanText(str){
			if(str.indexOf('http://') != 0){
				var TextEncoding = str.charCodeAt(0);
				str = str.substr(1);
			}
			//screw it i have no clue
			return str.replace(/[^A-Za-z0-9\(\)\{\}\[\]\!\@\#\$\%\^\&\* \/\"\'\;\>\<\?\,\~\`\.\n\t]/g,'');
		}
		
		
		function read_frame3(frame_id){
			read(4, function(s, size){
				var intsize = arr2int(size);
				read(2, function(s, flags){
					flags = pad(flags[0]).concat(pad(flags[1]));
					read(intsize, function(s, a){
						if(typeof TAG_HANDLERS[frame_id] == 'function'){
							TAG_HANDLERS[frame_id](intsize, s, a);
						}else if(TAGS[frame_id]){
							tag[TAGS[frame_id]] = (tag[TAGS[frame_id]]||'') + cleanText(s);
						}else{
							tag[frame_id] = cleanText(s);
						}
						read_frame();
					})
				})
			})
		}
		
		function read_frame2(v2ID, frame_id){
			read(3, function(s, size){
				var intsize = arr2int(size);
				read(intsize, function(s, a){
					if(typeof TAG_HANDLERS[v2ID] == 'function'){
						TAG_HANDLERS[v2ID](intsize, s, a);
					}else if(typeof TAG_HANDLERS[frame_id] == 'function'){
						TAG_HANDLERS[frame_id](intsize, s, a);
					}else if(TAGS[frame_id]){
						tag[TAGS[frame_id]] = (tag[TAGS[frame_id]]||'') + cleanText(s);
					}else{
						tag[frame_id] = cleanText(s);
					}
					read_frame();
				})
			})
		}
		
		
		read(3, function(header){
			if(header == "ID3"){
				read(2, function(s, version){
					tag.version = "ID3v2."+version[0]+'.'+version[1];
					tag.revision = version[0];
					read(1, function(s, flags){
						flags = pad(flags[0]);
						read(4, function(s, size){
							max_size = arr2int(size);
							read(0, function(){});
							read_frame();
						})
					})
				})
			}else{
				onComplete(tag);
				return false;
			}
		})
		return tag;
	},

	parseURL: function(url, onComplete){
		var xhr = new XMLHttpRequest();
		xhr.open('get', url, true);
		if(xhr.overrideMimeType){xhr.overrideMimeType('text/plain; charset=x-user-defined');}

		var pos = 0, 
				bits_required = 0, 
				handle = function(){},
				maxdata = Infinity;

		function read(bytes, callback, newmax){
			bits_required = bytes;
			handle = callback;
			maxdata = newmax;
			if(bytes == 0) callback('',[]);
		}
		var responseText = '';
		(function(){
			if(xhr.responseText){
				responseText = xhr.responseText;
			}
			if(xhr.responseText.length > maxdata) xhr.abort();

			if(responseText.length > pos + bits_required && bits_required){
				var data = responseText.substr(pos, bits_required);
				var arrdata = data.split('').map(function(e){return e.charCodeAt(0) & 0xff});
				pos += bits_required;
				bits_required = 0;
				if(handle(data, arrdata) === false){
					xhr.abort();
					return;
				}
			}
			setTimeout(arguments.callee, 0);
		})()
		xhr.send(null);
		return [xhr, ID3v2.parseStream(read, onComplete)];
	}
}