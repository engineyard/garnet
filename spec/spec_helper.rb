Bundler.require(:test)

require File.expand_path("../../lib/garnet", __FILE__)

DataMapper.setup(:default, "sqlite:memory:")
DataMapper.finalize
DataMapper.auto_upgrade!
