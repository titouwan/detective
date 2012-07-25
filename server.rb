require 'sinatra'
require 'data_mapper'
require 'haml'
require 'sinatra/reloader'

DataMapper::setup(:default,"sqlite3://#{Dir.pwd}/detective.db")

class Log
  include DataMapper::Resource
  property :seq, Serial
  property :host, String
  property :facility, String
  property :level, String
  property :datetime, Time
  property :program, String
  property :msg, Text

  attr_accessor :seq

  def self.all_sorted_desc
    self.all.each { |item| item.seq }.sort { |a,b| a.seq <=> b.seq }.reverse
  end
end

DataMapper.finalize.auto_upgrade!

get '/' do
  @logs = Log.all :order => :seq.desc
  haml :index
end

get '/hot' do
  @logs = Log.all_sorted_desc
  haml :index
end

#post '/' do
#  l = Link.new
#  l.title = params[:title]
#  l.url = params[:url]
#  l.created_at = Time.now
#  l.save
#  redirect back
#end

#put '/:id/vote/:type' do
#  l = Link.get params[:id]
#  l.points += params[:type].to_i
#  l.save
#  redirect back
#end

__END__

@@ layout
%html
        %head
                %link(rel="stylesheet" href="/css/bootstrap.css")
                %link(rel="stylesheet" href="/css/style.css")
        %body
                .container
                        #main
                                .title Detective
                                .options        
                                        %a{:href => ('/')} Search 
                                = yield                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                      
@@ index
#logs-list     
        -@logs.each do |l|     
                .row
                        .span3
                                %span.span
                                        %form{:action => "#{l.seq}/", :method => "post"}
                                                %input{:type => "hidden", :name => "_method", :value => "put"}
                                                %input{:type => "submit", :value => "⇡"}
                                %span.points
                                        #{l.points}
                                %span.span
                                        %form{:action => "#{l.seq}/hot", :method => "post"}
                                                %input{:type => "hidden", :name => "_method", :value=> "put"}
                                                %input{:type => "submit", :value => "⇣"}                                
                        .span6
                                %span.log
                                        %h3
                                                %a{:href => (l.seq)} #{l.host}
#add-link
        %form{:action => "/", :method => "post"}
                %input{:type => "text", :name => "title", :placeholder => "Title"}
                %input{:type => "text", :name => "url", :placeholder => "Url"}
                %input{:type => "submit", :value => "Submit"}   
