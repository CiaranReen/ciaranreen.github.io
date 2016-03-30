require "jekyll-assets"
require "react-jsx-sprockets"

ReactJSXSprockets.configure do |config|
  config.extensions = %w( jsx )
end
