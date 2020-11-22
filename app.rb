require 'bundler'
require 'sequel'

Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Name
  class App < Sinatra::Application

    #configure
    configure do
      set :root, File.dirname(__FILE__)
      set :public_folder, Proc.new { File.join(root, "public") }
      puts public_folder
    end

    #database
    set :database_file, 'config/database.yml'
    user = ENV['DATABASE_USER'] || 'admin'
    password = ENV['DATABASE_PASSWORD'] || 'testpass1'
    Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/ratpack_dev', user: user, password: password)

    configure :production do
      db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/ratpack')

      ActiveRecord::Base.establish_connection(
        :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        :host     => db.host,
        :username => db.user,
        :password => db.password,
        :database => db.path[1..-1],
        :encoding => 'utf8'
      )
    end

    #routes
    get '/' do
      erb :index
    end

    #helpers
    helpers do
      def partial(file_name)
        erb file_name, :layout => false
      end
    end

  end
end
