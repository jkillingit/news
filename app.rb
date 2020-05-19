require "sinatra"
require "sinatra/reloader"
require "httparty"
def view(template); erb template.to_sym; end

get "/" do
  ### Get the weather
  # Evanston, Kellogg Global Hub... replace with a different location if you want
  lat = 42.0574063
  long = -87.6722787

  units = "imperial"
  weatherkey = "9f35050b376e19c67d3ec6f8b2d75a3d"

  # construct the URL to get the API data (https://openweathermap.org/api/one-call-api)
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=#{units}&appid=#{weatherkey}"
  @forecast = HTTParty.get(url).parsed_response.to_hash
    
    @current = ["Temperature: #{@forecast["current"]["temp"]} degrees", "Conditions: #{@forecast["current"]["weather"][0]["description"]}"]
    puts @current
    puts "8 Day Extended forecast:"
    extended = []
    day_number = 1
    for day in @forecast["daily"]
        extended << "#{day_number} Days Out: #{day["weather"][0]["description"]} with a high of #{day["temp"]["max"]} degrees and a low of #{day["temp"]["min"]} degrees"
        day_number = day_number + 1
    end

    @extfcast = extended[0, 7]

  ### Get the news

  newskey = "a206b7a0d88440aebebbeb610616dc89"
  url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=#{newskey}"
  @news = HTTParty.get(url).parsed_response.to_hash

    puts "Top Headlines"
    article_number = 1
    for article in @news["articles"]
        puts "#{article_number}: #{article["title"]}" 
        puts "By #{article["author"]}"
        puts "Preview: #{article["content"]}"
        puts "#{article["urlToImage"]}"
        puts "Full Article: #{article["url"]}"
        article_number = article_number + 1
    end
    view "news"
end
