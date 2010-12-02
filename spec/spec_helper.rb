require 'dm-core/spec/setup'
require 'dm-core/spec/lib/adapter_helpers'

require 'dm-types'
require 'dm-migrations'
require 'dm-validations'

Dir["#{Pathname(__FILE__).dirname.expand_path}/shared/*.rb"].each { |file| require file }

DataMapper::Spec.setup

Spec::Runner.configure do |config|
  config.extend(DataMapper::Spec::Adapters::Helpers)
end

DEPENDENCIES = {
  'bcrypt' => 'bcrypt-ruby',
}

def try_spec
  begin
    yield
  rescue LoadError => error
    raise error unless lib = error.message.match(/\Ano such file to load -- (.+)\z/)[1]

    gem_location = DEPENDENCIES[lib] || raise("Unknown lib #{lib}")

    warn "[WARNING] Skipping specs using #{lib}, please do: gem install #{gem_location}"
  end
end
