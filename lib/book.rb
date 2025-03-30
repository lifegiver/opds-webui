require 'active_support'
require 'active_support/core_ext/hash'
require 'open-uri'
require 'cgi'

class Book
  def self.search(**options)
    query = CGI.escape(options[:q].to_s)
    page = options[:page]
    books = Hash.from_xml(URI.open("#{OPDS_URL}/opds/search?book=#{query}&page=#{page}"))
    authors = Hash.from_xml(URI.open("#{OPDS_URL}/opds/search?author=#{query}&page=#{page}"))
    [Array.wrap(books['feed']['entry']), Array.wrap(authors['feed']['entry'])]
  end

  def self.for_author(**options)
    author_id = options[:id]
    page = options[:page].to_i
    url = "#{OPDS_URL}/opds/authors?id=#{author_id}&anthology=alphabet&page=#{page}"
    puts url
    author_data = Hash.from_xml(URI.open(url))
    author_name = author_data['feed']['title']
    books = author_data['feed']['entry']
    [author_name, Array.wrap(books)]
  end
end
