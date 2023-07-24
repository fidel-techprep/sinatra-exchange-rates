require "sinatra"
require "http"
require "json"
require "sinatra/reloader"

# Retrieve symbols from appropriate API endpoint
symbols = JSON.parse(HTTP.get('https://api.exchangerate.host/symbols').to_s)["symbols"].keys

#Routes
get("/") do
  
  @symbols = JSON.parse(HTTP.get('https://api.exchangerate.host/symbols').to_s)["symbols"].keys
  erb(:home)
end

get("/:currency") do
  @source = params.fetch("currency") 
  @targets = symbols
  erb(:currency)
end

get("/:source/:target") do
  @source, @target = params.fetch("source"), params.fetch("target")

  # Query exchangerate API for current conversion rate
  @rate = JSON.parse(HTTP.get("https://api.exchangerate.host/convert?from=#{@source}&to=#{@target}"))["info"]["rate"]
  erb(:conversion)
end
