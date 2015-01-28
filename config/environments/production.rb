Ratafire::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
   config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  #videojs_rails
  config.assets.precompile += %w( jquery.min video-js.swf vjs.eot vjs.svg vjs.ttf vjs.woff promo/bootstrap.min.js promo/bootstrap-select.min.js promo/bootstrap-datepicker.min.js promo/jquery.appear.js promo/jquery.easings.min.js promo/jquery.carouFredSel-6.2.1-packed.js promo/jquery.touchwipe.min.js promo/jquery.themepunch.tools.min.js promo/jquery.themepunch.revolution.min.js promo/jquery.mCustomScrollbar.concat.min.js promo/jquery.mlens-1.5.min.js promo/jquery.jqplot.min.js promo/jqplot.donutRenderer.min.js promo/raphael-min.js promo/morris.min.js promo/easy-circle-skill.js promo/owl.carousel.min.js promo/isotope.pkgd.min.js promo/TimeCircles.js promo/jquery.fullPage.min.js promo/included-plagins.js promo/main.js rainbow/rainbow.js rainbow/language/c.js rainbow/language/coffeescript.js rainbow/language/csharp.js rainbow/language/css.js rainbow/language/d.js rainbow/language/generic.js rainbow/language/go.js rainbow/language/haskell.js rainbow/language/html.js rainbow/language/java.js rainbow/language/javascript.js rainbow/language/lua.js rainbow/language/php.js rainbow/language/python.js rainbow/language/r.js rainbow/language/ruby.js rainbow/language/scheme.js rainbow/language/shell.js rainbow/language/smalltalk.js mathjax/MathJax.js webfonts/25CB92_0_0.eot webfonts/25CB92_0_0.ttf webfonts/25CB92_0_0.woff)

  #Devise Mailing
  config.action_mailer.default_url_options = { :host => 'www.ratafire.com' }
  config.action_mailer.asset_host = 'www.ratafire.com'
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
   config.action_mailer.smtp_settings = {
     :address              => "smtp.sendgrid.net",
     :port                 => 25,
     :domain               => 'www.ratafire.com',
     :user_name            => ENV["SENDGRID_USERNAME"],
     :password             => ENV["SENDGRID_PASSWORD"],
     :authentication       => :plain,
     :enable_starttls_auto => true  }

  #aws-s3
  config.gem "aws-s3", :lib => "aws/s3"  

  #Google Analytics
  #GA.tracker = ENV["GOOGLE_ANALYTICS"]

end
