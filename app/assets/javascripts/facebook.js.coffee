jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true


window.fbAsyncInit = ->
  FB.init(appId: '249146721904203', cookie: true)

  $('#facebook-connect').click (e) ->
    e.preventDefault()
    FB.login (response) ->
      window.location = 'auth/facebook/callback' if response.authResponse