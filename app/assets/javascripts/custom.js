/*
	Radius by TEMPLATED
	templated.co @templatedco
	Released for free under the Creative Commons Attribution 3.0 license (templated.co/license)
*/
$(document).on('turbolinks:load', function() {
(function($) {

/*	skel.breakpoints({
		xlarge:	'(max-width: 1680px)',
		large:	'(max-width: 1280px)',
		medium:	'(max-width: 980px)',
		small:	'(max-width: 736px)',
		xsmall:	'(max-width: 480px)'
	});
*/
	$(function() {

		var	$window = $(window),
			$body = $('body'),
			$header = $('#custom-header'),
			$footer = $('#footer');

		// Disable animations/transitions until the page has loaded.
			$body.addClass('is-loading');

			$window.on('load', function() {
				window.setTimeout(function() {
					$body.removeClass('is-loading');
				}, 100);
			});

		// Fix: Placeholder polyfill.
			$('form').placeholder();

		// Prioritize "important" elements on medium.
			skel.on('+medium -medium', function() {
				$.prioritize(
					'.important\\28 medium\\29',
					skel.breakpoint('medium').active
				);
			});

		// Header.
			// $header.each( function() {

			// 	var t 		= jQuery(this),
			// 		button 	= t.find('.custom-button');

			// 	button.click(function(e) {

			// 		t.toggleClass('custom-hide');

			// 		if ( t.hasClass('preview') ) {
			// 			return true;
			// 		} else {
			// 			e.preventDefault();
			// 		}

			// 	});

			// });

		// Footer.
			$footer.each( function() {
				var t 		= jQuery(this),
					inner 	= t.find('.inner'),
					button 	= t.find('.info');

				button.click(function(e) {
					t.toggleClass('custom-show');
					e.preventDefault();
				});

			});

	});
	$(document).ready(function() {
	  if ($('.pagination').length) {
	    $(window).scroll(function() {
	      var url = $('.pagination .next_page').attr('href');
	      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
	        $('.pagination').text("Please Wait...");
	        return $.getScript(url);
	      }
	    });
	    return $(window).scroll();
	  }
	});
})(jQuery);
});