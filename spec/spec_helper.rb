Bundler.require(:test)

require File.expand_path("../../lib/garnet", __FILE__)

DataMapper.setup(:default, "sqlite::memory:")
DataMapper.finalize
DataMapper.auto_upgrade!

Dir[File.expand_path("../{support,fixtures}/**/*.rb", __FILE__)].each {|f| require f}
