# app.rb
require 'sinatra'
require 'haml'
load 'lib/book.rb'
require 'sanitize'

set :bind, '0.0.0.0'
set :haml, { escape_html: false }

OPDS_URL = ENV.fetch('OPDS_URL')

helpers do
  def truncate(text, length: 500)
    return text if text.length <= length
    "#{text[0...length]}..."
  end
end

get '/' do
  @books, @authors = Book.search(**params)
  @current_url =  "/?q=#{CGI.escape(params[:q].to_s)}"
  @title = 'OPDS WebUI'
  haml :search_results
end

get '/author' do
  @author_name, @books = Book.for_author(**params)
  @current_url =  "/author?id=#{params[:id]}&q=#{CGI.escape(params[:q].to_s)}"
  @title = "#{@author_name} — Books"
  haml :author
end
