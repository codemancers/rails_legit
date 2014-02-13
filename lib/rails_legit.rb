require "rails_legit/version"
require "active_support"

module RailsLegit
  extend ActiveSupport::Autoload

  autoload :VerifyDateValidator
  autoload :VerifyArrayValidator
  autoload :VerifyHashValidator

  module Errors
    autoload :MethodNotFoundOnRecordError, 'rails_legit/errors/method_not_found_error'
    autoload :NilValueError,               'rails_legit/errors/nil_value_error'
    autoload :NotAnArrayError,             'rails_legit/errors/not_an_array_error'
    autoload :NoMethodError,               'rails_legit/errors/no_method_error'
  end
end
