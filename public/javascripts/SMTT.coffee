@SMTT =
	init: ->
		SMTT.currentSlide = 1
		SMTT.isMaster = false
		SMTT.socket = io.connect("http://localhost:7777")
		SMTT.bindListeners()
		$(".slide").hide()
		$("#slide-1").show()
		if $(location).attr('hash').substring(1) == 'master'
			while !SMTT.isMaster
				promptVal = prompt 'Ah Ah Ah, what\'s the magic word?'
				if promptVal == 'iamthemaster'
					SMTT.isMaster = true
		else if $(location).attr('hash').substring(1) == 'solo'
			SMTT.isSolo = true

	bindListeners: ->
		$(window).on "swipeleft", (event) ->
			SMTT.nextSlide()
		$(window).on "swiperight", (event) ->
			SMTT.previousSlide()
		$(document).bind 'keydown', (event) ->
			switch event.keyCode
				when 37 then SMTT.previousSlide()
				when 39 then SMTT.nextSlide()

		SMTT.socket.on "init", (data) ->
			console.log data
			SMTT.totalSlides = data.totalSlides
			document.title = data.presentationName
			if !SMTT.isSolo
				if SMTT.currentSlide != data.currentSlide
					SMTT.changeSlide data.currentSlide

		#Update the span with the user count
		SMTT.socket.on "userUpdate", (data) ->
			$("#userCount").text data.userCount

		SMTT.socket.on "slideChanged", (data) ->
			if data.slide != SMTT.currentSlide
				SMTT.changeSlide data.slide

	previousSlide: ->
		if SMTT.currentSlide != 1 && SMTT.isMaster or SMTT.isSolo
			SMTT.currentSlide--

			$('#slide-' + (SMTT.currentSlide + 1)).addClass('animated bounceOutLeft').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
				$(this).removeClass('animated bounceOutLeft').hide()
				if SMTT.isMaster
					SMTT.socket.emit "slideChanged", {slide: SMTT.currentSlide }

				$('#slide-' + SMTT.currentSlide).show().addClass('animated bounceInRight').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
					$(this).removeClass('animated bounceInRight')

	nextSlide: ->
		if SMTT.currentSlide + 1 <= SMTT.totalSlides && SMTT.isMaster or SMTT.isSolo
			SMTT.currentSlide++

			$('#slide-' + (SMTT.currentSlide - 1)).addClass('animated bounceOutLeft').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
				$(this).removeClass('animated bounceOutLeft').hide()
				if SMTT.isMaster
					SMTT.socket.emit "slideChanged", {slide: SMTT.currentSlide }

				$('#slide-' + SMTT.currentSlide).show().addClass('animated bounceInRight').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
					$(this).removeClass('animated bounceInRight')

	changeSlide: (slide)->
		$('#slide-' + SMTT.currentSlide).addClass('animated bounceOutLeft').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$(this).removeClass('animated bounceOutLeft').hide()
			$('.slide').hide()
			SMTT.currentSlide = slide;

			$('#slide-' + SMTT.currentSlide).show().addClass('animated bounceInRight').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
				$(this).removeClass('animated bounceInRight')

		console.log 'changing slide to: ' + slide

