require "garnet/version"

module Garnet
  autoload :Api, 'garnet/api'
end


require 'dm-core'
require 'dm-validations'
require 'dm-types'

require 'garnet/stone'
require 'garnet/cut'
require 'garnet/user'
require 'garnet/ownership'
require 'garnet/dependency'

DataMapper.finalize
