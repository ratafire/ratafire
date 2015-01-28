var $ = jQuery;

var delay = (function(){
  var timer = 0;
  return function(callback, ms){
	clearTimeout (timer);
	timer = setTimeout(callback, ms);
  };
})();

//hex to rgba
function convertHex(hex,opacity){
  var r,g,b,result;
  hex = hex.replace('#','');
  r = parseInt(hex.substring(0,2), 16);
  g = parseInt(hex.substring(2,4), 16);
  b = parseInt(hex.substring(4,6), 16);

  result = 'rgba('+r+','+g+','+b+','+opacity/100+')';
  return result;
}

//Calculating The Browser Scrollbar Width
var parent, child, scrollWidth;

if (scrollWidth === undefined){
  parent = $('<div style="width: 50px; height: 50px; overflow: auto"><div/></div>').appendTo('body');
  child = parent.children();
  scrollWidth = child.innerWidth() - child.height(99).innerWidth();
  parent.remove();
}

//Form Stylization
function formStylization(){
  var radio    = 'input[type="radio"]',
	  checkbox = 'input[type="checkbox"]';
  
  $(radio).wrap('<div class="new-radio"></div>').closest('.new-radio').append('<span></span>');
  $(checkbox).wrap('<div class="new-checkbox"></div>').closest('.new-checkbox').append('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="18px" height="18px" viewBox="0 0 20 20" enable-background="new 0 0 20 20" xml:space="preserve"><polygon fill="#fff" points="9.298,13.391 4.18,9.237 3,10.079 9.297,17 17.999,4.678 16.324,3 "/></svg>');
  $(checkbox + ':checked').parent('.new-checkbox').addClass('checked');
  $(radio + ':checked').parent('.new-radio').addClass('checked');
  $(checkbox + ':disabled').closest('.checkbox').addClass('disabled');
  $(radio + ':disabled').closest('.radio').addClass('disabled');
  
  $('html').on('click', function(){
	$(radio).parent('.new-radio').removeClass('checked');
	$(radio + ':checked').parent('.new-radio').addClass('checked');
	$(checkbox).parent('.new-checkbox').removeClass('checked');
	$(checkbox + ':checked').parent('.new-checkbox').addClass('checked');
	$(radio).closest('.radio').removeClass('disabled');
	$(checkbox).closest('.checkbox').removeClass('disabled');
	$(radio + ':disabled').closest('.radio').addClass('disabled');
	$(checkbox + ':disabled').closest('.checkbox').addClass('disabled');
  });
  
  if(typeof($.fn.selectpicker) !== 'undefined'){
	$('select:not(".without-styles")').selectpicker();
  }
}

//Page scroll
function scrollingOnePage(){
  var main               = $('.one-page .main'),
	  section            = main.find('.section'),
	  sectionsBackground = [],
	  anchors            = [],
	  menuTitles         = [],
	  autoScrolling      = true,
	  navigationPosition = 'right',
	  slidesNavPosition  = 'top',
	  bodyWidth          = $('body').width();
  
  if (main.data('navPosition') == 'left'){
	navigationPosition = 'left';
  }
  
  if (main.data('sliderNavPosition') == 'bottom'){
	slidesNavPosition = 'bottom';
  }
  
  section.find('.section-content').css('height', $(window).height());
  
  section.each(function(){
	var $this           = $(this),
		title           = $(this).find('.section-title'),
		thisBackground  = '',
		thisAnchor      = '',
		thisTitle       = '';
	
	if ($this.data('background')){
	  thisBackground = $this.data('background');
	}
	if ($this.data('shadow')){
	  $this.css('border-color', $this.data('shadow'));
	  $this.addClass('shadow');
	}
	if ($this.data('backgroundImage')){
	  $this.css('background-image', 'url(' + $this.data('backgroundImage') + ')');
	  $this.addClass('background-image');
	}
	if ($this.find('.video-background').length){
	  $this.addClass('background-overlay section-video-background');
	}
	if ($this.data('anchor')){
	  thisAnchor = $this.data('anchor');
	}
	if ($this.data('title')){
	  thisTitle = $this.data('title');
	}
	if ($this.data('color')){
	  $this.css('color', $this.data('color'));
	}
	if ($this.data('titleColor')){
	  title.css('color', $this.data('titleColor'));
	}
	if ($this.find('.site-header:not(".second-site-header")').length){
	  $this.addClass('section-header');
	}
	if ($this.find('.site-footer').length){
	  $this.addClass('section-footer');
	}
	
	sectionsBackground.push(thisBackground);
	anchors.push(thisAnchor);
	menuTitles.push(thisTitle);
  });
  
  if (($('body').width() + scrollWidth) < 768){
	autoScrolling = false;
  }
  
  $(window).on('resize', function(){
	if (($('body').width() + scrollWidth) < 768){
	  autoScrolling = false;
	} else {
	  autoScrolling = true;
	}
  });
  
  $(window).load(function(){
	if ($.fn.fullpage){
	  main.fullpage({
		verticalCentered   : true,
		resize             : false,
		sectionsColor      : sectionsBackground,
		anchors            : anchors,
		animateAnchor      : false,
		scrollingSpeed     : 700,
		easing             : 'easeInOutCubic',
		autoScrolling      : autoScrolling,
		navigation         : true,
		navigationPosition : navigationPosition,
		navigationTooltips : menuTitles,
		slidesNavigation   : true,
		slidesNavPosition  : slidesNavPosition,
		scrollOverflow     : false,
		css3               : false,
		paddingTop         : '50',
		paddingBottom      : '50',
		sectionSelector    : '.section',
		slideSelector      : '.slide',
		loopHorizontal     : false,
		afterResize : function(index){
		  $.fn.fullpage.setAutoScrolling(autoScrolling);
		  
		  minimizationNav();
		  
		  $('.section-content').mCustomScrollbar('destroy');
		  
		  if (($('body').width() + scrollWidth) > 767){
			contentHeight();
		  }
		  positionVideoBg();
		},
		onLeave : function(index){
		  $('#fp-nav').fadeOut();
		  
		  if(($('body').width() + scrollWidth) > 767){
			if ($('#main-menu').hasClass('in')){
			  $('.site-header .navbar .navbar-toggle').trigger('click');
			}
			
			$('.numbered-list-description .close, .services-wrap .opened-content .close').trigger('click');
			
			animateSection();
		  }
		},
		afterLoad : function(){
		  navColor();
		  
		  addClassNav();
		  
		  $('#fp-nav').fadeIn();
		  
		  section.not('.active').find('.section-content').mCustomScrollbar('scrollTo','top');

		  videoBg();
		  
		  setTimeout(function(){
			sandwichAnimation();
		  }, 0);
		},
		afterRender: function(){
		  videoBg();
        },
		onSlideLeave : function(){
		  $('.fp-slidesNav').fadeOut();
		},
		afterSlideLoad : function(){
		  navColor();
		  
		  $('.fp-slidesNav').fadeIn();
		}
	  },
	  setTimeout(function(){
		$('.main .fp-slidesNav').each(function(){
		  var $this         = $(this),
			  thisContainer = $this.closest('.section'),
			  wrapper       = '<div class="container slide-nav"></div>';
			  
		  if ($this.hasClass('bottom')){
			$this.wrap(wrapper);
		  } else {
			if (thisContainer.find('.site-header').length){
			  thisContainer
				.find('.site-header')
				.after(wrapper);
			  var thisContainerH = thisContainer.find('.slide-nav');
			  
			  $this.prependTo(thisContainerH);
			} else {
			  $this
				.prependTo(thisContainer)
				.wrap(wrapper);
			}
		  }
		  
		  var slideHeight = thisContainer.find('.fp-slides').height();
		  
		  thisContainer.find('.slide').css('height', slideHeight);
		});
	  }, 0));
	}

	function contentHeight(){
	  $('.section').each(function(){
		var $this = $(this),
			headerHeight = 0,
			footerHeight = 0;
  
		if ($this.hasClass('section-header')){
		  headerHeight = $this.find('.site-header').outerHeight();
		}
		
		if ($this.hasClass('section-footer')){
		  footerHeight = $this.find('.site-footer').outerHeight();
		}
		
		var sectionHeight = $(window).height() - headerHeight - footerHeight;
		
		$this.find('.section-content').removeAttr('style', 'height');
		
		$this.find('.section-content').css('max-height', sectionHeight);
		$this.find('.section-content:not(".not-scroll")').mCustomScrollbar({
		  scrollInertia : 100,
		  contentTouchScroll : false
		});
	  });
	}
	if(($('body').width() + scrollWidth) > 767){
	  contentHeight();
	}
	
	function navColor(){
	  var activeSection    = main.find('.section.active'),
		  activeSlide      = activeSection.find('.slide.active'),
		  sectionColor     = '#d73e4d',
		  sectionColorText = '#fff';
  
	  if (activeSection.data('navColor')){
		sectionColor = activeSection.data('navColor');
	  }
	  
	  if (activeSection.data('navColorText')){
		sectionColorText = activeSection.data('navColorText');
	  }
	  
	  if (!activeSection.hasClass('fp-table')){
		if (activeSlide.data('navColor')){
		  sectionColor = activeSlide.data('navColor');
		} else if (activeSection.data('navColor')){
		  sectionColor = activeSection.data('navColor');
		} else {
		  sectionColor  = '#d73e4d';
		}
	  }
	  
	  if (sectionColor == '#fff'){
		sectionColor  = '#ffffff';
	  }
  
	  activeSection
		.find('.fp-slidesNav li')
		.css('borderColor', convertHex(sectionColor,17))
		.find('a').css('color', sectionColor)
		.find('span').css('background', sectionColor);
	  
  
	  $('#fp-nav li').css('borderColor', convertHex(sectionColor,17))
		.find('a').css('color', sectionColor)
		.find('span').css('background', sectionColor);
	  
	  $('.fp-tooltip').css('background', sectionColor);
	  $('#fp-nav li').on({ mouseenter:function(){
		setTimeout(function(){
		  $('.fp-tooltip').css({
			background : sectionColor,
			color      : sectionColorText
		  });
		}, 0);
	  }});
	}
	navColor();
	
	function animateSection(){
	  var activeSection = main.find('.section.active'),
		  activeSlide   = activeSection.find('.slide.active');
  
	  $('[data-appear-animation]').each(function(){
		var $this     = $(this),
			animation = 'fadeIn';
  
		if ($this.data('appearAnimation')){
		  animation = $this.data('appearAnimation');
		}
		
		var delay = ($this.data('appearAnimationDelay') ? $this.data('appearAnimationDelay') : 1);
  
		if(delay > 1){
		  $this.css('animation-delay', delay + 'ms');
		}
		
		if ($this.closest('.section').hasClass('active')){
			$this.removeClass('animated').removeClass(animation);
		} else {
		  setTimeout(function(){
			$this.removeClass('animated').removeClass(animation);
		  }, 500);
		}
		
		if ($this.closest('.section').hasClass('active')){
		  setTimeout(function(){
			$this.addClass('animated').addClass(animation);
			activeSection.css('overflow', 'hidden');
		  }, 100);
		}
	  });
	}
	
	function addClassNav(){
	  var nav       = $('#fp-nav'),
		  navActive = nav.find('.active').closest('li');
	  
	  nav.find('li').removeClass('prev').removeClass('next');
	  nav.removeClass('fp-prev').removeClass('fp-next');
	  
	  navActive.prev().addClass('prev').closest('#fp-nav').addClass('fp-prev');
	  navActive.next().addClass('next').closest('#fp-nav').addClass('fp-next');
	}
	addClassNav();
	
	function minimizationNav(){
	  $('#fp-nav').removeClass('mini');
	  
	  if (($('body').height() - 150) <  $('#fp-nav').height()){
		$('#fp-nav').addClass('mini');
	  } else {
		$('#fp-nav').removeClass('mini');
	  }
	}
	minimizationNav();
  });
  
  //Video BG
  if ($('.section[data-video-background]').length){
	$('.section[data-video-background]').tubular({
	  videoId   : '0Bmhjf0rKe8',
	  container : $('.section[data-video-background]')
	});
  }
  
  function videoBg(){
	$('.section-video-background').each(function(){
	  var $this = $(this);

	  $this.prepend($this.find('.video-background'));
	  
	  if ($this.find('.video-background video').length){
		setTimeout(function(){
		  var video = $this.find('.video-background video');
		  
		  video.get(0).play();
		  
		  positionVideoBg();
		}, 0);
	  }
	});
  }
  
  function positionVideoBg(){
	$('.section-video-background').each(function(){
	  var $this = $(this);
	  
	  if ($this.find('.video-background video').length){
		var video = $this.find('.video-background video');
		
		if (video.width() == $this.width()){
		  video.css({
			marginLeft : 0,
			marginTop : -((video.height() - $this.height()) / 2)
		  });
		} else {
		  video.css({
			marginTop : 0,
			marginLeft : -((video.width() - $this.width()) / 2)
		  });
		}
	  }
	});
  }
}

//Header Menu
function headerMenu(){
  var menu             = $('.header-menu'),
	  parent           = menu.find('.parent > a'),
	  back             = parent.closest('.parent').find('.back > .back-link'),
	  animationClasses = 'bounceInDown';
  
  if (menu.data('animation')){
	animationClasses = menu.data('animation');
  }
  
  parent.on('click', function (e){
	e.preventDefault();
	
	$(this).closest('li').toggleClass('active').find('.sub').addClass('animated').addClass(animationClasses);
    $(this).closest('ul').toggleClass('sub-view').removeClass(animationClasses);
  });
  
  back.on('click', function (){
	$(this).closest('.parent').removeClass('active').find('.sub').removeClass('animated').removeClass(animationClasses);
    $(this).closest('.sub-view').removeClass('sub-view').addClass(animationClasses);
  });

  menu.find('.collapse').on('show.bs.collapse', function (){
	menu.find('.nav').addClass('animated').addClass(animationClasses);
  });
  
  menu.find('.collapse').on('hide.bs.collapse', function (){
	menu.find('.nav').removeClass('animated').removeClass(animationClasses);
	
	setTimeout(function(){
	  $('.header-menu').find('.sub-view').removeClass('sub-view');
	  parent.closest('.parent').removeClass('active').find('.sub').removeClass('animated').removeClass(animationClasses);
	}, 170);
  });
}

//Charts
function chart(){
  if ($('#dot-chart').length){
	Morris.Line({
	  element : 'dot-chart',
	  data : [
		{ month : '2014-01', sales : 2000, rents : 1000 },
		{ month : '2014-02', sales : 2700, rents : 1700 },
		{ month : '2014-03', sales : 2300, rents : 3800 },
		{ month : '2014-04', sales : 2300, rents : 4800 },
		{ month : '2014-05', sales : 3000, rents : 4300 },
		{ month : '2014-06', sales : 3400, rents : 4800 },
		{ month : '2014-07', sales : 3400, rents : 5000 },
		{ month : '2014-08', sales : 3800, rents : 5000 },
		{ month : '2014-09', sales : 4400, rents : 5300 },
		{ month : '2014-10', sales : 4400, rents : 5000 }
	  ],
	  xkey : 'month',
	  ykeys : ['sales', 'rents'],
	  labels : ['sales', 'rents'],
	  lineColors : ['rgba(215,62,77,0.3)','rgba(94,142,189,0.3)'],
	  hideHover : 'auto',
	  resize : true
	});
  }
  
  if ($('#bar-chart').length){
	Morris.Bar({
	  element : 'bar-chart',
	  data : [
		{ month : 'Jan.', sales : 2000, rents : 1000 },
		{ month : 'Feb.', sales : 2700, rents : 1700 },
		{ month : 'Mar.', sales : 2300, rents : 3800 },
		{ month : 'Apr.', sales : 2300, rents : 4800 },
		{ month : 'May.', sales : 3000, rents : 4300 },
		{ month : 'Jun.', sales : 3400, rents : 4800 },
		{ month : 'Jul.', sales : 3400, rents : 5000 },
		{ month : 'Aug.', sales : 3800, rents : 5000 },
		{ month : 'Sep.', sales : 4400, rents : 5300 },
		{ month : 'Oct.', sales : 4400, rents : 5000 }
	  ],
	  xkey : 'month',
	  ykeys : ['sales', 'rents'],
	  labels : ['sales', 'rents'],
	  barColors : ['#5e8ebd','#d73e4d'],
	  hideHover : 'auto',
	  resize : true
	});
  }
}

function pieCharts(){
  var pieGrid = {
	background : 'transparent',
	borderColor : 'transparent',
	shadow : false,
	drawBorder : false,
	shadowColor : 'transparent'
  };
  
  //Pie Chart 1
  if ($('#chart1').length){
	var data1 = [['One', 25],['Two', 15], ['Three', 16], ['Four', 17],['Five', 27]],
		colors1 = ['#375099', '#d73e4d', '#d6973d', '#179680', '#20bdd0'];
	
	var plot1 = $.jqplot ('chart1', [data1], { 
	  seriesDefaults : {
		shadow : false,
		renderer : $.jqplot.DonutRenderer,
	    rendererOptions : {
		  startAngle : -90,
		  diameter : 140,
		  dataLabelPositionFactor : 0.6,
		  innerDiameter : 28,
		  showDataLabels : true
		}
	  },
	  grid : pieGrid,
	  seriesColors : colors1,
	  legend : { 
		show : true, 
		location : 'e'
	  }
	});
	
	$(window).resize(function(){
	  plot1.replot({ resetAxes : true });
	});
  }
  
  //Pie Chart 2
  if ($('#chart2').length){
	var data2 = [['', 25],['', 16], ['', 59]],
		colors2 = ['#d6973d', '#e2a959', '#c4862e'];
		
	var plot2 = $.jqplot ('chart2', [data2], { 
	  seriesDefaults : {
		shadow : false,
		renderer : $.jqplot.DonutRenderer,
	    rendererOptions : {
		  startAngle : -125,
		  diameter : 140,
		  dataLabelPositionFactor : 0.6,
		  innerDiameter : 28,
		  showDataLabels : true
		}
	  },
	  grid : pieGrid,
	  seriesColors : colors2
	});
	
	$(window).resize(function(){
	  plot2.replot({ resetAxes : true });
	});
  }
  
  //Pie Chart 3
  if ($('#chart3').length){
	var data3 = [['', 25],['', 16], ['', 59]],
		colors3 = ['#d73e4d', '#dc515f', '#e1727d'];
		
	var plot3 = $.jqplot ('chart3', [data3], { 
	  seriesDefaults : {
		shadow : false,
		renderer : $.jqplot.DonutRenderer,
	    rendererOptions : {
		  startAngle : -125,
		  diameter : 140,
		  dataLabelPositionFactor : 0.6,
		  innerDiameter : 28,
		  showDataLabels : true
		}
	  },
	  grid : pieGrid,
	  seriesColors : colors3
	});
	
	$(window).resize(function(){
	  plot3.replot({ resetAxes : true });
	});
  }
  
  //Pie Chart 4
  if ($('#chart4').length){
	var data4 = [['', 25],['', 16], ['', 59]],
		colors4 = ['#375099', '#314889', '#4b62a3'];
		
	var plot4 = $.jqplot ('chart4', [data4], { 
	  seriesDefaults : {
		shadow : false,
		renderer : $.jqplot.DonutRenderer,
	    rendererOptions : {
		  startAngle : -125,
		  diameter : 140,
		  dataLabelPositionFactor : 0.6,
		  innerDiameter : 28,
		  showDataLabels : true
		}
	  },
	  grid : pieGrid,
	  seriesColors : colors4
	});
	
	$(window).resize(function(){
	  plot4.replot({ resetAxes : true });
	});
  }
}

//Google Map
function initialize(){
  var mapCanvas = $('.map-canvas');
  
  mapCanvas.each(function (){
	var $this           = $(this),
		zoom            = 8,
		lat             = -34,
		lng             = 150,
		scrollwheel     = false,
		draggable       = true,
		mapType         = google.maps.MapTypeId.ROADMAP,
		title           = '',
		contentString   = '',
		dataZoom        = $this.data('zoom'),
		dataLat         = $this.data('lat'),
		dataLng         = $this.data('lng'),
		dataType        = $this.data('type'),
		dataScrollwheel = $this.data('scrollwheel'),
		dataTitle       = $this.data('title'),
		dataContent     = $this.data('content');
		
	if (dataZoom !== undefined && dataZoom !== false){
	  zoom = parseFloat(dataZoom);
	}

	if (dataLat !== undefined && dataLat !== false){
	  lat = parseFloat(dataLat);
	}
	
	if (dataLng !== undefined && dataLng !== false){
	  lng = parseFloat(dataLng);
	}
	
	if (dataScrollwheel !== undefined && dataScrollwheel !== false){
	  scrollwheel = dataScrollwheel;
	}
	
	if (dataType !== undefined && dataType !== false){
	  if (dataType == 'satellite'){
		mapType = google.maps.MapTypeId.SATELLITE;
	  } else if (dataType == 'hybrid'){
		mapType = google.maps.MapTypeId.HYBRID;
	  } else if (dataType == 'terrain'){
		mapType = google.maps.MapTypeId.TERRAIN;
	  }
	}
	
	if (dataTitle !== undefined && dataTitle !== false){
	  title = dataTitle;
	}
	
	if( navigator.userAgent.match(/iPad|iPhone|Android/i) ){
	  draggable = false;
	}

	var mapOptions = {
	  zoom        : zoom,
	  scrollwheel : scrollwheel,
	  draggable   : draggable,
	  center      : new google.maps.LatLng(lat, lng),
	  mapTypeId   : mapType
	};
  
	var map = new google.maps.Map($this[0], mapOptions);
	
	var is_internetExplorer11= navigator.userAgent.toLowerCase().indexOf('trident') > -1;
	var image = ( is_internetExplorer11 ) ? 'img/map-marker.png' : 'img/svg/map-marker.svg';
	
	if (dataContent !== undefined && dataContent !== false){
	  contentString = '<div class="map-content">' +
		'<h3 class="title">' + title + '</h3>' +
		dataContent +
	  '</div>';
	}

	var infowindow = new google.maps.InfoWindow({
      content: contentString
	});
	
	var marker = new google.maps.Marker({
	  position : new google.maps.LatLng(lat, lng),
	  map      : map,
	  icon     : image,
	  title    : title
	});
	
	if (dataContent !== undefined && dataContent !== false){
	  google.maps.event.addListener(marker, 'click', function(){
		infowindow.open(map,marker);
	  });
	}
	
	var styles = [
	  {
		'featureType' : 'water',
		'stylers' : [
		  { 'hue' : '#e9ebed' },
		  { 'saturation' : -78	},
		  { 'lightness' : 67 },
		]
	  },
	  {
		'featureType' : 'landscape',
		'elementType' : 'all',
		'stylers' : [
		  { 'hue' : '#ffffff' },
		  { 'saturation' : -100 },
		  { 'lightness' : 100 },
		  { 'visibility' : 'simplified' }
		]
	  },
	  {
		'featureType' : 'road',
		'elementType' : 'geometry',
		'stylers' : [
		  { 'hue' : '#bbc0c4' },
		  { 'saturation' : -93 },
		  { 'lightness': 31 },
		  { 'visibility' : 'simplified' }
		]
	  },
	  {
		'featureType' : 'poi',
		'elementType' : 'all',
		'stylers' : [
		  { 'hue' : '#ffffff' },
		  { 'saturation' : -100 },
		  { 'lightness' : 100 },
		  { 'visibility' : 'off' }
		]
	  },
	  {
		'featureType' : 'road.local',
		'elementType' : 'geometry',
		'stylers' : [
		  { 'hue' : '#e9ebed' },
		  { 'saturation' : -90 },
		  { 'lightness' : -8 },
		  { 'visibility' : 'simplified' }
		]
	  },
	  {
		'featureType' : 'transit',
		'elementType' : 'all',
		'stylers' : [
		  { 'hue' : '#e9ebed' },
		  { 'saturation' : 10 },
		  { 'lightness' : 69 },
		  { 'visibility' : 'on' }
		]
	  },
	  {
		'featureType' : 'administrative.locality',
		'elementType' : 'all',
		'stylers' : [
		  { 'hue' : '#2c2e33' },
		  { 'saturation' : 7 },
		  { 'lightness' : 19 },
		  { 'visibility' : 'on' }
		]
	  },
	  {
		'featureType' : 'road',
		'elementType' : 'labels',
		'stylers' : [
		  { 'hue' : '#bbc0c4'	},
		  { 'saturation' : -93 },
		  { 'lightness' : 31 },
		  { 'visibility' : 'on' }
		]
	  },
	  {
		'featureType' : 'road.arterial',
		'elementType' : 'labels',
		'stylers' : [
		  { 'hue' : '#bbc0c4'	},
		  { 'saturation' : -93 },
		  { 'lightness' : -2 },
		  { 'visibility' : 'simplified' }
		]
	  }
	];
	  
	map.setOptions({styles: styles});
  });
}

function loadScript(){
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&' +
    'callback=initialize';
  document.body.appendChild(script);
}

window.onload = loadScript;

//Circle Skills
function circleSkills(){
  var skill = $('.circle-skill');
  
  skill.each(function(){
	var $this = $(this),
		percent   = 90,
		lineSize  = 1,
		skillName = '',
		color     = '#000';

	if ($.fn.easyCircleSkill){
	  if (($.fn.appear) && (!$this.parents().hasClass('no-appear'))){
		$this.appear(function(){
		  skillInit();
		});
	  } else {
		skillInit();
	  }
	}
	
	function skillInit(){
	  if ($this.data('percent')){
		percent = $this.data('percent');
	  }
	  if ($this.data('lineSize')){
		lineSize = $this.data('lineSize');
	  }
	  if ($this.data('title')){
		skillName = $this.data('title');
	  }
	  if ($this.data('color')){
		color = $this.data('color');
	  }
	  
	  if ( !!document.createElement('canvas').getContext ){
		$this.easyCircleSkill({
		  percent   : percent,
		  linesize  : lineSize,
		  skillName : skillName,
		  colorline : color
		});
	  }
	}
  });
}

//Carousels
function carousels(){
  var carousel = $('.carousel'),
	  options  = {
		itemsCustom : [
		  [0, 1],
		  [768, 2],
		  [992, 3]
		],
		navigation  : true
	  };
  
  carousel.each(function(){
	var $this = $(this);

	if ($this.data('options')){
	  options = $this.data('options');
	}

	$this.owlCarousel(options).addClass('loaded');
	
	$(window).on('resize', function(){
	  delay(function(){
		bottomNavigation();
	  }, 200);
	});

	function bottomNavigation(){
	  if (
		($this.hasClass('bottom-navigation')) && (!$this.find('.owl-pagination .owl-prev').length)
	  ){
		$this.find('.owl-pagination').prepend('<a href="#" class="owl-prev"/>');
		$this.find('.owl-pagination').append('<a href="#" class="owl-next"/>');
		
		$this.find('.owl-next').on('click',function (e){
		  e.preventDefault();
		  
		  $this.trigger('owl.next');
		});
		
		$this.find('.owl-prev').on('click',function (e){
		  e.preventDefault();
		  
		  $this.trigger('owl.prev');
		});
	  }
	}
	bottomNavigation();
  });
}

//Success Carousels
function successCarousels(){
  var success = $('.success-carousel');
  
  success.each(function(){
	var $this   = $(this),
		avatars = $this.find('.avatars-carousel'),
		content = $this.find('.content'),
		logo    = $this.find('.logo');

	avatars.carouFredSel({
	  synchronise : ['.success-carousel .content', false],
	  auto        : false,
	  items       : {
		visible : 1
	  },
	  scroll      : {
		items    : 1,
		fx       : 'fade',
		duration : 0,
		onBefore : function(){
		  avatars.find('.avatar').removeClass('flipInX').addClass('flipOutX');
		  logo.removeClass('selected');
		},
		onAfter   : function(){
		  var current = avatars.triggerHandler('currentVisible'),
			  id = current.attr('id');
		  
		  current.removeClass('flipOutX').addClass('flipInX');
		  $this.find('.logos a[href="#' + id + '"]').addClass('selected');
		}
      },
	  next        : $this.find('.navigation .next'),
	  prev        : $this.find('.navigation .prev'),
	  pagination  : $this.find('.navigation .pager')
	}).addClass('loaded');
	
	content.carouFredSel({
	  responsive : true,
	  auto       : false,
	  width      : '100%',
	  items: {
		visible  : 1
	  }
	})
	.addClass('loaded')
	.touchwipe({
	  wipeLeft: function(){
		avatars.trigger('next', 1);
	  },
	  wipeRight: function(){
		avatars.trigger('prev', 1);
	  },
	  preventDefaultEvents: false
	});
	
	logo.click(function(){
	  avatars.trigger('slideTo', '#' + this.href.split('#').pop() );
	  logo.removeClass('selected');
	  $(this).addClass('selected');
	  return false;
	});
  });
}

//Services
function services(){
  var services    = $('.services-wrap');
  
  if (services.length){
	var circle      = services.find('.circle-wrap:not(.main-circle)'),
		skill       = services.find('.skill-wrap'),
		mainCircle  = services.find('.main-circle'),
		openContent = mainCircle.find('.opened-content'),
		servicesX   = services.offset().left,
		servicesY   = services.offset().top,
		mainCircleCenterX,
		mainCircleCenterY;
	
	if (!skill.find('.line').length){
	  $('<div class="line"><div class="default"></div><div class="active"></div></div>').appendTo(skill);
	}
	
	mainCircleCenterX = mainCircle.offset().left - servicesX + (mainCircle.outerWidth() / 2);
	mainCircleCenterY = mainCircle.offset().top - servicesY + (mainCircle.outerHeight() / 2);
	
	circle.each(function(index){
	  var $this = $(this),
		  $thisCenterX,
		  $thisCenterY;
	  
	  if (index === 0){
		$this.addClass('first');
	  } else if (index%2){
		$this.addClass('even');
	  }
	  
	  if (($('body').width() + scrollWidth) > 767){
		var line  = $this.find('.line');
		
		$thisCenterX = $this.offset().left - servicesX + ($this.outerWidth() / 2);
		$thisCenterY = $this.offset().top - servicesY + ($this.outerHeight() / 2);
	
		//First/Last Circle
		if ($thisCenterY == mainCircleCenterY){
		  line.css('width', Math.abs(mainCircleCenterX - $thisCenterX));
		}
		//Top/Bpttom Circle
		else if	($thisCenterX == mainCircleCenterX)
		{
		  line.css('width', Math.abs(mainCircleCenterY - $thisCenterY));
		}
		//Other Circle
		else
		{
		  line.css('width', Math.sqrt(Math.pow((mainCircleCenterY - $thisCenterY), 2) + (Math.pow((mainCircleCenterX - $thisCenterX), 2))));
		  
		  var tg,
			  angleTg,
			  angle,
			  x = Math.abs(mainCircleCenterX - $thisCenterX),
			  y = Math.abs(mainCircleCenterY - $thisCenterY);
	
		  tg = x / y;
		  
		  if ($thisCenterX < mainCircleCenterX){
			angleTg = Math.atan(1/tg);
		  } else {
			angleTg = Math.atan(tg);
		  }
		  
		  angle = (angleTg * 180) / Math.PI;
	
		  if ($thisCenterY < mainCircleCenterY){
			line.css({'transform' : 'rotate('+ angle +'deg)'});
			
			if ($thisCenterX > mainCircleCenterX){
			  line.css({'transform' : 'rotate('+ (angle + 90) +'deg)'});
			}
		  } else {
			line.css({'transform' : 'rotate('+ - angle +'deg)'});
			
			if ($thisCenterX > mainCircleCenterX){
			  line.css({'transform' : 'rotate('+ - (angle + 90) +'deg)'});
			}
		  }
		}
	  }
	});
	
	circle.find('.skill-wrap').on('click', function(e){
	  var $this = $(this);
	  
	  e.preventDefault();
	  
	  if (!$this.closest('.circle-wrap').hasClass('active')){
		openContent.finish();
		removeOpenedContent();

		$this.closest('.circle-wrap').addClass('active').find('.line .active').animate({
		  width : '100%'
		}, 500, function(){
		  $this.closest('.circle-wrap').find('.description').clone().appendTo(openContent);
		  
		  openContent.find('.text').mCustomScrollbar();
		  
		  openContent
			.animate({
			  opacity : 1
			}, 500)
			.addClass('opened')
			.closest('.services-wrap').addClass('services-opened')
			.closest('html').addClass('hidden-scroll');
		});
	  }
	});
	
	mainCircle.find('.opened-content .close').on('click', function(e){
	  e.preventDefault();
  
	  removeOpenedContent();
	});
  }
  
  function removeOpenedContent(){
	openContent.animate({
	  opacity : 0
	}, 500, function(){
	  openContent.find('.description').remove();
	
	  openContent
		.removeClass('opened')
		.closest('.services-wrap').removeClass('services-opened')
		.closest('html').removeClass('hidden-scroll');
	});

	circle.closest('.circle-wrap').find('.line .active').animate({
	  width : 0
	}, 0);
	
	circle.removeClass('active');
  }
}

//Tabs
function tabs(){
  var tab = $('.nav-tabs');
  
  tab.find('a').click(function (e){
	e.preventDefault();
	
	$(this).tab('show');
  });

  if (($('body').width() + scrollWidth) < 768 && (!tab.hasClass('no-responsive'))){
    tab.each(function(){
	  var $this = $(this);
	  
	  if (!$this.next('.tab-content').hasClass('hidden') && !$this.find('li').hasClass('dropdown')){
		$this.addClass('accordion-tab');

		$this.find('a').each(function(){
		  var $this = $(this),
			  id = $this.attr('href');
		  
		  $this.prepend('<span class="open-sub"></span>');
		  
		  $this.closest('.nav-tabs').next('.tab-content').find(id)
			.appendTo($this.closest('li'));
		});
		
		$this.next('.tab-content').addClass('hidden');
	  }
    });
	
	$('.accordion-tab > li.active .tab-pane').slideDown();
  } else {
	tab.find('.tab-pane').removeAttr('style', 'display');
	tab.each(function(){
	  var $this = $(this);
	  
	  if ($this.next('.tab-content').hasClass('hidden')){
		$this.removeClass('accordion-tab');
	  
		$this.find('a').each(function(){
		  var $this = $(this);
		  
		  $($this.closest('li').find('.tab-pane'))
			.appendTo($this.closest('.nav-tabs').next('.tab-content'));
		});
		
		$this.next('.tab-content').removeClass('hidden');
	  }
    });
  }
  
  $('.accordion-tab > li > a').on('shown.bs.tab', function (e){
	if (($('body').width() + scrollWidth) < 768){	  
	  var $this = $(this),
		  tab = $this.closest('li');
	  
	  e.preventDefault();
	  
	  $this
		.closest('.accordion-tab')
		.find('.tab-pane').not(tab.find('.tab-pane'))
		  .removeClass('active')
		  .slideUp();
	  tab.find('.tab-pane')
		.addClass('active')
		.slideDown();

	  $('html, body').on('scroll mousedown DOMMouseScroll mousewheel keyup', function(){
		$('html, body').stop();
	  });
	}
  });
}

//Work
function openWork(){
  var work        = $('.work:not(.work-link)'),
	  worksOpened = $('.works-opened .single-work');

  work.click(function(e){
	var $this = $(this),
		loadLink = '';
	
	e.preventDefault();
	
	if ($this.data('link')){
	  loadLink = $this.data('link');
	  
	  $.ajax({
		url     : loadLink,
		success : function(result){
		  worksOpened.html(result);
		  
		  worksOpened.parent().fadeIn();
		  
		  $('html').addClass('single-work-opened');
		  
		  images();
			
		  worksOpened.find('.work-container').mCustomScrollbar();
	
		  if (worksOpened.height() < worksOpened.find('.container').height()){
			worksOpened.find('.work-container').addClass('scroll');
		  }

		  worksOpened.prev('.navigation').find('.next-work').attr('data-link', $this.data('linkNext'));
		  worksOpened.prev('.navigation').find('.prev-work').attr('data-link', $this.data('linkPrev'));
		}
	  });
	}
  });
  
  $('.works-opened-close').click(function(e){
	e.preventDefault();
	
	worksOpened.parent().fadeOut();
	
	$('html').removeClass('single-work-opened');
	
	worksOpened.find('.container').remove();
  });
  
  $('.prev-work, .next-work').click(function(e){
	var $this = $(this),
		loadLink = '';
	
	e.preventDefault();
	
	if ($this.data('link')){
	  loadLink = $this.data('link');
	  
	  worksOpened.css('visibility', 'hidden');
	  
	  setTimeout(function(){
		$.ajax({
		  url     : loadLink,
		  success : function(result){
			worksOpened.html(result);
			
			images();
			
			setTimeout(function(){
			  worksOpened.find('.work-container').mCustomScrollbar();
	  
			  if (worksOpened.height() < worksOpened.find('.container').height()){
				worksOpened.find('.work-container').addClass('scroll');
			  }
			  
			  worksOpened.delay(100).css('visibility', 'visible');
			}, 50);
		  }
		});
	  }, 300);
	}
  });
  
  function images(){
	var singleWork = $('.single-work'),
		mainImages = singleWork.find('.main-images'),
		thumbs     = singleWork.find('.thumbs');
	
	mainImages.carouFredSel({
	  responsive : true,
	  circular   : false,
	  auto       : false,
	  items      : {
		visible : 1,
		width : 600,
		height : '62%'
	  },
	  scroll     : {
		fx : 'directscroll'
	  }
	}).parents('.main-images-wrap').addClass('loaded');
	
	if ((($('body').width() + scrollWidth) < 992) && (($('body').width() + scrollWidth) >= 768 )){
	  var maxCount = 5;
	} else {
	  var maxCount = 6;
	}
	
	thumbs.carouFredSel({
	  responsive : true,
	  circular   : false,
	  infinite   : false,
	  auto       : false,
	  prev       : singleWork.find('.thumbs-wrap .prev'),
	  next       : singleWork.find('.thumbs-wrap .next'),
	  items      : {
		visible : {
		  min : 4,
		  max : maxCount
		},
		width : 90,
		height : '66,6%'
	  },
	  onCreate: function (){
		$(window).on('resize', function (){
		  if ((($('body').width() + scrollWidth) < 992) && (($('body').width() + scrollWidth) >= 768 )){
			var maxCount = 5;
		  } else {
			var maxCount = 6;
		  }
		  
		  thumbs.trigger('configuration', {
			items      : {
			  visible : {
				min : 4,
				max : maxCount
			  }
			}
		  });
		});
	  }
	}).touchwipe({
	  wipeLeft: function(){
		thumbs.trigger('next', 1);
	  },
	  wipeRight: function(){
		thumbs.trigger('prev', 1);
	  },
	  preventDefaultEvents : false
	});

	thumbs.find('a').click(function(){
	  mainImages.trigger('slideTo', '#' + this.href.split('#').pop() );
	  thumbs.find('a').removeClass('selected');
	  $(this).addClass('selected');
	  return false;
	});
  }
}

function carouselWork(){
  var work = $('.work-carousel');
  
  if (work.length){
	work.each(function(){
	  var $this = $(this),
		  mainCarousel = $this.find('.main-carousel'),
		  secondCarousel = $this.find('.second-carousel'),
		  workThumbs = $this.find('.thumbs');
	  
	  mainCarousel.carouFredSel({
		synchronise : [$this.find('.second-carousel'), false],
		responsive : true,
		auto       : false,
		width      : '100%',
		height     : 'variable',
		items      : {
		  height   : 'variable',
		  visible  : 1
		}
	  }).closest('.main-carousel-wrap').addClass('loaded');

	  secondCarousel.each(function(){
		secondCarousel.carouFredSel({
		  responsive  : true,
		  auto        : false,
		  width       : '100%',
		  height      : 'variable',
		  items       : {
			height  : 'variable',
			visible : 1
		  }
		});
	  }).closest('.second-carousel-wrap').addClass('loaded');

	  workThumbs.carouFredSel({
		responsive : true,
		circular   : false,
		infinite   : false,
		auto       : false,
		prev       : $this.find('.thumbs-wrap .prev'),
		next       : $this.find('.thumbs-wrap .next'),
		items      : {
		  visible : {
			min : 4,
			max : 6
		  },
		  width : 90,
		  height : '66,6%'
		}
	  });
  
	  workThumbs.find('a').click(function(){
		mainCarousel.trigger('slideTo', '#' + this.href.split('#').pop() );
		workThumbs.find('a').removeClass('selected');
		$(this).addClass('selected');
		return false;
	  });
	});
  }
}

//Blog Gallery
function blogGallery(){
  var gallery = $('.entry-gallery');
  
  if (gallery.length){
	gallery.each(function(){
	  var $this = $(this);
	  
	  $this.carouFredSel({
		responsive : true,
		auto       : false,
		width      : '100%',
		height     : 'variable',
		items      : {
		  height : 'variable'
		},
		prev       : $this.closest('.entry-preview').find('.prev'),
		next       : $this.closest('.entry-preview').find('.next')
	  });
	}).closest('.entry-preview').addClass('loaded');
  }
}

//Shares
function shares(){
  var shares     = $('.shares'),
	  linkShares = shares.find('a'),
	  urlsoc     = location.href.replace('index.html','');
  
  linkShares.each(function(){
	var $this = $(this),
	    icon  = '';
	
	if ($this.data('icon')){
	  icon = $this.data('icon');
	}
	
	if ($this.data('id')){
	  new GetShare({
		root : $this,
		network : $this.attr('class'),
		button : {
		  text : '<i class="fa ' + icon + '"></i>'
		},
		share : {
		  id : $this.data('id')
		}
	  });
	} else {
	  new GetShare({
		root : $this,
		network : $this.attr('class'),
		button : {
		  text : '<i class="fa ' + icon + '"></i>'
		},
		share : {
		  url : urlsoc,
		  message : 'Link to ' + urlsoc
		}
	  });
	}
  });
}

//Filter
function isotopFilter(){
  var filter = $('.filter-box');
  
  if (filter.length){
	filter.each(function (){
	  var filterBox   = $(this),
		  filterElems = filterBox.find('.filter-elements'),
		  buttonBox   = filterBox.find('.filter-buttons'),
		  selector    = filterBox.find('.filter-buttons .active').data('filter');
  
	  if ($.fn.isotope){
		filterElems.isotope({
		  filter: selector,
		  layoutMode: 'fitRows'
		});
		buttonBox.find('.dropdown-toggle').html(filterBox.find('.filter-buttons .active').text() + '<span class="caret"></span>');
	  }
  
	  buttonBox.find('a').on('click', function(e){
		var selector = $(this).data('filter');
		e.preventDefault();
		
		if (!$(this).hasClass('active')){
		  buttonBox.find('a').removeClass('active');
		  $(this).addClass('active');
		  buttonBox.find('.dropdown-toggle').html($(this).text() + '<span class="caret"></span>');
  
		  if (filterBox.hasClass('accordions-filter')){
			filterElems.children().not(selector)
			  .animate({ height : 0 })
			  .addClass('e-hidden');
			filterElems.children(selector)
			  .animate({ height : '100%' })
			  .removeClass('e-hidden');
		  } else {
			filterElems.isotope({
			  filter: selector,
			  layoutMode: 'fitRows'
			});
		  }
		}
	  });
	});
  }
}

//Animation
function animation(){
  $('[data-appear-animation]').each(function(){
	var $this = $(this),
	animation = 'fadeIn';
	
	if ($this.data('appearAnimation')){
	  animation = $this.data('appearAnimation');
	}

	if(($('body').width() + scrollWidth) > 767){
	  $this.appear(function(){
		var delay = ($this.data('appearAnimationDelay') ? $this.data('appearAnimationDelay') : 1);

		if(delay > 1){
		  $this.css('animation-delay', delay + 'ms');
		}
		
		$this.addClass('animated').addClass(animation);
	  }, {accX: 0, accY: 0});
	}
  });
}

// Zoomer
function zoom(){
  if ($.fn.mlens){
	var image = $('.zoom-img');
	  
	image.each(function(){
	  var $this = $(this);
	  
	  image.mlens({
		imgSrc       : $this.attr('data-big'),
		imgSrc2x     : $this.attr('data-big2x'),
		imgOverlay   : $this.attr('data-overlay'),
		lensShape    : 'circle',
		lensSize     : 180,
		borderSize   : 4,
		borderColor  : '#ccc',
		borderRadius : 0,
		overlayAdapt : true,
		zoomLevel    : 2
	  });
	  
	  $this.parent().addClass('zoom-wrap');
	});
  }
}

//Promo
function promo(){
  var promo = $('.promo-box');
  
  promo.each(function(){
	$this         = $(this),
	height        = $this.height(),
	part          = $this.find('.part'),
	sectionHeight = $this.closest('.section').height();
	
	part.css('height', height);

	if (($this.hasClass('full-height')) && (height < (sectionHeight - 100))){
	  part.css('height', sectionHeight - 100);
	}
  });
}
function promoBullet(){
  var bullet = $('.bullet');
  
  bullet.on('click', function(e){
	e.preventDefault();
	
	if(($('body').width() + scrollWidth) < 768){
	  $(this).find('.bullet-content').fadeIn().closest('html').addClass('hidden-scroll');
	}
  });
  
  bullet.find('.close').on('click', function(e){
	if(($('body').width() + scrollWidth) < 768){
	  $(this).closest('.bullet-content').fadeOut().closest('html').removeClass('hidden-scroll');
	}
	return false;
  });
}

//Numbered list
function numberedlist(){
  if ((($('body').width() + scrollWidth) > 767) && ($('body').hasClass('one-page'))){
	var list = $('.numbered-list');
	
	list.each(function(){
	  var $this = $(this),
		  item  = $this.find('.item');
	  
	  if ($this.find('.carousel-item').length){
		$this.data('owlCarousel').destroy();
		
		$this.append(item);
		
		$this.find('.carousel-item').remove();
	  }
	  
	  setTimeout(function(){
		var $thisHeight    = $this.outerHeight(),
			section        = $this.closest('.section-wrap'),
			sectionHeight  = section.outerHeight(),
			carouselHeight = $('body').height() - ($this.offset().top) - (sectionHeight - $this.offset().top - $thisHeight);
  
		$this.prepend('<div class="carousel-item add"/>');
		
		var itemsHeight = 0;
		
		item.each(function(){
		  var $thisItem = $(this);

		  itemsHeight = itemsHeight + $thisItem.outerHeight();
  
		  if ((itemsHeight + 80) >= carouselHeight){
			$('.carousel-item').removeClass('add');
			$this.append('<div class="carousel-item add"/>');
			itemsHeight = $thisItem.outerHeight();
		  }

		  $('.carousel-item.add').append($thisItem);
		});
		
		$this.owlCarousel({
		  singleItem : true,
		  navigation : true
		}).addClass('loaded');
		
		$this.find('.owl-pagination').prepend('<a href="#" class="owl-prev"/>');
		$this.find('.owl-pagination').append('<a href="#" class="owl-next"/>');
		
		$this.find('.owl-next').on('click',function (e){
		  e.preventDefault();
		  
		  $this.trigger('owl.next');
		});
		
		$this.find('.owl-prev').on('click',function (e){
		  e.preventDefault();
		  
		  $this.trigger('owl.prev');
		});
	  }, 0);
	});
  }
  
  $('.numbered-list-description .tab-pane').mCustomScrollbar({
	callbacks: {
      onInit: function(e){
		console.log($(this.mcs).closest('.tab-pane'));
		$(this.mcs).closest('.tab-pane').addClass('test')
	  }
	}
  });
  
  $('.numbered-list .item-link').on('shown.bs.tab', function (e){
	$($(e.target).attr('href')).closest('.numbered-list-description').addClass('open animated zoomIn');
	
	$('.numbered-list .item-link').removeClass('hover');
	
	$(e.target).addClass('hover');
	
	if(($('body').width() + scrollWidth) < 768){
	  $('html').addClass('hidden-scroll');
	}
  });
  
  $('.numbered-list-description .close').on('click', function (e){
	e.preventDefault();
	
	$(this).closest('.numbered-list-description').removeClass('open animated zoomIn');
	
	$('.numbered-list .item-link').removeClass('hover');
	
	if(($('body').width() + scrollWidth) < 768){
	  $('html').removeClass('hidden-scroll');
	}
  });
}

//Date Countdown
function countDown(){
  var countDown = $('#DateCountdown');
  
  if ((countDown.length) && ($.fn.TimeCircles)){
	countDown.TimeCircles({
	  'animation'       : 'ticks',
	  'bg_width'        : 1,
	  'fg_width'        : 0.01,
	  'circle_bg_color' : 'rgba(0,0,0,.05)',
	  'time'            : {
		'Days' : {
		  'text'  : 'Days',
		  'color' : '#d73e4d',
		  'show'  : true
		},
		'Hours' : {
		  'text'  : 'Hours',
		  'color' : '#d6973d',
		  'show'  : true
		},
		'Minutes' : {
		  'text'  : 'Minutes',
		  'color' : '#179680',
		  'show'  : true
		},
		'Seconds' : {
		  'text'  : 'Seconds',
		  'color' : '#20bdd0',
		  'show'  : true
		}
	  }
	});
	
	$(window).on('resize', function(){
	  delay(function(){
		countDown.TimeCircles().rebuild();
	  }, 300);
	});
  }
}

//Sandwich Animation
function sandwichAnimation(){
  var animation = $('.sandwich-animation');
  
  if (animation.length){
	animation.each(function(){
	  var thisAnimation = $(this);
	  
	  if (thisAnimation.css('display') != 'none'){
		var layer = thisAnimation.find('.layer'),
			delay = 500;
	  
		if ($(this).data('animateDelay')){
		  delay = $(this).data('animateDelay')
		}
  
		if ($('body').hasClass('one-page')){
		  if (thisAnimation.closest('.section').hasClass('active')){
			setTimeout(function(){
			  layer.each(function(){
				var $this = $(this);
				
				if ($this.data('animatePosition')){
				  $this.css('margin-top', $this.data('animatePosition'));
				}
			  });
			}, delay);
		  } else {
			layer.removeAttr('style', 'margin-top');
		  }
		}
	  }
	});
  }
}

$(document).ready(function(){
  'use strict';

  var isTouchDevice = navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry|Windows Phone)/);
  
  $('body').on('scroll touchmove mousewheel', function(e){
	if (($('html').hasClass('single-work-opened')) || ($('html').hasClass('hidden-scroll'))){
	  e.preventDefault();
	  e.stopPropagation();
	}
  });
  
  //Touch device
  if(isTouchDevice){
	$('body').addClass('touch-device');
  }

  //Meta Head
  if (($('body').width() + scrollWidth) > 768){
    $('.viewport').remove();
  }

  //Bootstrap Elements
  $('[data-toggle="tooltip"], .tooltip-link').tooltip();
  
  $('a[data-toggle=popover]')
	.popover()
	.click(function(e){
	  e.preventDefault();
	});

  $('.disabled, fieldset[disabled] .selectBox').click(function (){
    return false;
  });
  
  //Accordion
  $('.collapse').on('hide.bs.collapse', function (event){
	event.stopPropagation();
	
	$(this).closest('.panel').removeClass('active');
  });
  
  $('.collapse').on('show.bs.collapse', function (){
	$(this).closest('.panel').addClass('active');
  });

  $('.collapse.in').closest('.panel').addClass('active');

  //Functions
  scrollingOnePage();
  formStylization();
  headerMenu();
  chart();
  circleSkills();
  pieCharts();
  services();
  tabs();
  openWork();
  shares();
  animation();
  zoom();
  promoBullet();
  countDown();
  
  //Functions(load)
  $(window).load(function(){
	carousels();
	blogGallery();
	carouselWork();
	successCarousels();
	isotopFilter();
	promo();
	numberedlist();
  });

  //Scroll Up
  $('.scroll-to-top').click(function(e){
	e.preventDefault();
	
	if (($('body').hasClass('one-page')) && ($.fn.fullpage)){
	  $.fn.fullpage.moveTo(1);
	} else {
	  $('html, body').animate({
		scrollTop : 0
	  }, 300);
	}
  });
  
  //Facebook
  if ($('.facebook-widget').length){
	(function(d, s, id){
	  var js, fjs = d.getElementsByTagName(s)[0];
	  if (d.getElementById(id)) return;
	  js = d.createElement(s); js.id = id;
	  js.src = '//connect.facebook.net/en_EN/all.js#xfbml=1';
	  fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
  }
  
  //Twitter
  if ($('.twitter-widget').length){
	!function(d,s,id){
	  var js,
	  fjs=d.getElementsByTagName(s)[0],
	  p=/^http:/.test(d.location)?'http':'https';
	  
	  if(!d.getElementById(id)){
		js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';
		fjs.parentNode.insertBefore(js,fjs);
	  }
	}(document,'script','twitter-wjs');
  }
  
  //Bootstrap Datepicker
  if($.fn.datepicker){
	$('.datepicker-box').datepicker({
	  todayHighlight : true,
	  beforeShowDay : function (date){
		if (date.getMonth() == (new Date()).getMonth())
		  switch (date.getDate()){
			case 4 :
			  return {
				tooltip : 'Example tooltip',
				classes : 'active'
			  };
			case 8 :
			  return false;
			case 12 :
			  return 'green';
		  }
	  }
	});
  }
  
  //Retina
  if('devicePixelRatio' in window && window.devicePixelRatio >= 2){
    var imgToReplace = $('img.replace-2x').get();
  
    for (var i=0,l=imgToReplace.length; i<l; i++){
      var src = imgToReplace[i].src;
	  
      src = src.replace(/\.(png|jpg|gif)+$/i, '@2x.$1');
	  
      imgToReplace[i].src = src;
	  
	  $(imgToReplace[i]).load(function(){
		$(this).addClass('loaded');
	  });
    }
  }
  
  //Revolution Slider
  if (($('.tp-banner').length) && ($.fn.revolution)){
	$('.tp-banner').show().revolution({
	  dottedOverlay             : 'none',
	  delay                     : 16000,
	  startwidth                : 1170,
	  startheight               : 700,
	  hideThumbs                : 200,
	  thumbWidth                : 100,
	  thumbHeight               : 50,
	  thumbAmount               : 5,
	  navigationType            : 'bullet',
	  navigationArrows          : 'solo',
	  navigationStyle           : 'preview3',
	  touchenabled              : 'on',
	  onHoverStop               : 'on',
	  swipe_velocity            : 0.7,
	  swipe_min_touches         : 1,
	  swipe_max_touches         : 1,
	  drag_block_vertical       : false,
	  parallax                  : 'mouse',
	  parallaxBgFreeze          : 'on',
	  parallaxLevels            : [7,4,3,2,5,4,3,2,1,0],
	  keyboardNavigation        : 'off',
	  navigationHAlign          : 'center',
	  navigationVAlign          : 'bottom',
	  navigationHOffset         : 0,
	  navigationVOffset         : 20,
	  soloArrowLeftHalign       : 'left',
	  soloArrowLeftValign       : 'center',
	  soloArrowLeftHOffset      : 20,
	  soloArrowLeftVOffset      : 0,
	  soloArrowRightHalign      : 'right',
	  soloArrowRightValign      : 'center',
	  soloArrowRightHOffset     : 20,
	  soloArrowRightVOffset     : 0,
	  shadow                    : 0,
	  fullWidth                 : 'on',
	  fullScreen                : 'off',
	  spinner                   : 'spinner4',
	  stopLoop                  : 'off',
	  stopAfterLoops            : -1,
	  stopAtSlide               : -1,
	  shuffle                   : 'off',
	  autoHeight                : 'off',
	  forceFullWidth            : 'off',
	  hideThumbsOnMobile        : 'off',
	  hideNavDelayOnMobile      : 1500,						
	  hideBulletsOnMobile       : 'off',
	  hideArrowsOnMobile        : 'off',
	  hideThumbsUnderResolution : 0,
	  hideSliderAtLimit         : 0,
	  hideCaptionAtLimit        : 0,
	  hideAllCaptionAtLilmit    : 0,
	  startWithSlide            : 0,
	  videoJsPath               : 'rs-plugin/videojs/',
	  fullScreenOffsetContainer : ''
	});
  }
  
  //Preloader
  $(window).load(function(){
	$('body').delay(500).addClass('loaded').find('.preloader').fadeOut(400);
  });
  
  //Header dropdown
  $('.site-header .dropdown-item').on('show.bs.dropdown', function (){
	var drop           = $(this).find('.dropdown-menu'),
		animationClass = 'animated bounceInLeft';
	
	if (drop.hasClass('right')){
	  animationClass = 'animated bounceInRight';
	}
	
	drop.addClass(animationClass);
	
	if ($('#main-menu').hasClass('in')){
	  $('.site-header .navbar .navbar-toggle').trigger('click');
	}
  });
  
  $('.site-header .dropdown-item').on('hide.bs.dropdown', function (){
	var drop              = $(this).find('.dropdown-menu'),
		animationClass    = 'animated bounceInLeft',
		animationClassOut = 'bounceOutLeft';
	
	if (drop.hasClass('right')){
	  animationClass    = 'animated bounceInRight';
	  animationClassOut = 'bounceOutRight';
	}
	
    drop.addClass(animationClassOut);
	
	setTimeout(function(){
	  drop.removeClass(animationClass).removeClass(animationClassOut);
	}, 500);
  });
  
  //Contact Us
  $('.submit-btn').click(function(){
	var $this = $(this);
  
    $.post('php/form.php', $this.closest('.contact-form').serialize(),  function(data){
	  $this.closest('.contact-form').find('.form-message').html(data).animate({opacity: 1}, 500, function(){
		if ($(data).is('.send-true')){
		  $this.closest('.contact-form').trigger( 'reset' );
		}
      });
    });
    return false;
  });
  
  //Under Construction
  $('.join-us').click(function(){
	var $this = $(this);
  
    $.post('php/under-form.php', $this.closest('.under-construction').serialize(),  function(data){
	  $this.closest('.under-construction').find('.success').html(data).animate({opacity: 1}, 500, function(){
		if ($(data).is('.send-true')){
		  $this.closest('.under-construction').trigger( 'reset' );
		}
      });
    });
    return false;
  });
});

//Window Resize
(function(){
  var delay = (function(){
	var timer = 0;
	return function(callback, ms){
	  clearTimeout (timer);
	  timer = setTimeout(callback, ms);
	};
  })();
  
  function resizeFunctions(){	
    if (($('body').width() + scrollWidth) > 767){
	  $('.viewport').remove();
	} else {
	  $('head').append('<meta class="viewport" name="viewport" content="width=device-width, initial-scale=1.0">');
	}
	
	//Functions
	tabs();
	promo();
	numberedlist();
	countDown();
  }

  if(navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry|Windows Phone)/)){
	$(window).bind('orientationchange', function(){
	  $('.preloader').fadeIn(100);
	  
	  if ($.fn.fullpage){
		$.fn.fullpage.moveTo(1);
	  }
	  
	  setTimeout(function(){
		resizeFunctions();
		
		$('.preloader').delay(800).fadeOut(200);
	  }, 0);
	});
  } else {
	$(window).on('resize', function(){
	  delay(function(){
		resizeFunctions();
	  }, 500);
	});
  }

  $(window).on('resize', function(){
	services();
  });
}());