# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
  config.log_level = :error
end
