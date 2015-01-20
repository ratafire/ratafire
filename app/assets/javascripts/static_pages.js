	/*	Reveal Menu */
	$('#header-botton-mobile').on(click, function(){
		$('#header').removeClass('borderRadius');
		if( !$('#mobile-content').hasClass('inactive') ){
		
			// Slide and scale content
			$('#mobile-content').addClass('inactive');
			setTimeout(function(){ $('#mobile-content').addClass('flag'); }, 100);
			
			// Slide in menu links
			var timer = 0;
			$.each($('li'), function(i,v){
				timer = 40 * i;
				setTimeout(function(){
					$(v).addClass('visible');
				}, timer);
			});
		}
	});