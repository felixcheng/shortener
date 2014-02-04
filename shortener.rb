require 'sinatra'
require 'active_record'
require 'pry'

###########################################################
# Configuration
###########################################################

set :public_folder, File.dirname(__FILE__) + '/public'

configure :development, :production do
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
end

# Handle potential connection pool timeout issues
after do
    ActiveRecord::Base.connection.close
end

###########################################################
# Models
###########################################################
# Models to Access the database through ActiveRecord.
# Define associations here if need be
# http://guides.rubyonrails.org/association_basics.html

class Link < ActiveRecord::Base
end

###########################################################
# Routes
###########################################################

get '/' do
    @links = Link.all # FIXME
    erb :index
end

get '/new' do
    params[:url]
    link = Link.new
    link.url = params[:url]
    link.save
    erb :form
end


post '/new' do
    newSite = params[:url]
    
    unless storage.index(newSite)
      storage.push(newSite)
      return newSite
    end


    puts "Site entered is #{newSite}, the array is #{storage}"

    # PUT CODE HERE TO CREATE NEW SHORTENED LINKS
end

# MORE ROUTES GO HERE