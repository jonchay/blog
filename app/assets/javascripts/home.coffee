$ ->
  #"https://api.unsplash.com/photos/?client_id=6bb5bb78cfde81736048d37f2d3399d5024a6a5be277ad88a4b1a366a5e4f77f"
  API_URL = "https://api.unsplash.com/photos/"
  TRANSITION_DURATION = 2000
  #TRANSITION_DURATION = 500

  default_opts = {
    client_id: "6bb5bb78cfde81736048d37f2d3399d5024a6a5be277ad88a4b1a366a5e4f77f"
    page: 1
  }

  window.$slideshow = $slideshow = $('[data-toggle="slideshow"]')
  $slide = $("<div class='slide' />").css('display', 'none')
  $prevSlide = $currentSlide = null
  slideShowInterval = null
  currentPage = 1

  pauseSlideshow = -> clearInterval(slideShowInterval)
  startSlideShow = -> slideShowInterval = setInterval(resumeSlideshow, TRANSITION_DURATION)

  fetchPhotos = (page = 1) ->
    $.getJSON(API_URL, _.defaults(page: page, default_opts), (photos) ->
      _.each(photos, (photo) ->
        newSlide = $slide.clone().css('background-image', """url("#{photo.urls.small}")""")
        $slideshow.append(newSlide)
      )
    )

  resumeSlideshow = ->
    nextSlide = $currentSlide.next()
    if nextSlide[0]
      $prevSlide = $currentSlide
      $currentSlide = nextSlide
      $currentSlide.fadeIn()
    else
      pauseSlideshow()
      fetchPhotos(currentPage += 1).then( -> startSlideShow())

  # Init
  fetchPhotos(currentPage).then( ->
    firstSlide = $slideshow.find('.slide:first-child')
    firstSlide.show()
    $prevSlide = $currentSlide = firstSlide
    slideShowInterval = setInterval(resumeSlideshow, TRANSITION_DURATION)
  )
