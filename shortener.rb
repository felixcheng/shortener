require 'sinatra'
require 'active_record'
require 'pry'
require 'securerandom'


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
    attr_accessible :url, :short_link
end

###########################################################
# Routes
###########################################################

get '/' do
    @links = Link.all # FIXME
    erb :index
end

get '/new' do
    erb :form
end

get '/:short_link' do
    params[:short_link]
    link = Link.find_by_short_link params[:short_link]

    if link.nil?
        erb :form
    else
        redirect "http://" + link.url
    end
end
    
post '/new' do
    newSite = params[:url]
    
    encrpted = SecureRandom.urlsafe_base64

    link = Link.find_or_create_by_url :url => newSite, :short_link => encrpted
    puts link
    link.inspect
    encrpted

end

# MORE ROUTES GO HERE