require 'bundler'
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
    set :database, "sqlite3:///database.db"

    #filters

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
