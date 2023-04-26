# lib/app/scrapper.rb

require 'nokogiri'   
require 'open-uri'
require 'pry'
require 'json'
require 'csv'

require_relative "../lib/spreadsheet.rb"

#binding.pry

townhall_list_url = "https://annuaire-des-mairies.com/val-d-oise.html"
$hash = {}

def get_townhall_list(townhall_list_url)
  
  urls = []
  emails = []
  towns = []

  # Get the HTML content of the townhall list page
  townhall_list_page = Nokogiri::HTML(URI.open(townhall_list_url))

  # Get the name of each town in the list
  townhall_list_page.css('a.lientxt').each do |link|
    towns << link.text
  end

  # Get the URL of each town in the list
  townhall_list_page.css('a.lientxt').each do |link|
    urls << "https://annuaire-des-mairies.com" + link['href'][1..-1] 
  end

  # Get the email address of each town
  urls.each do | url |
    email_list = Nokogiri::HTML(URI.open(url))  
    text = email_list.xpath('//tbody/tr[4]/td[2]').map(&:text)
    emails << text[0]
  end

  # Create a hash with the towns and their email addresses
  $hash = towns.zip(emails).to_h
end


# Generate JSON file
def save_as_JSON(hash)
  File.open("../../db/emails.json","w") do |f|
    f.write(hash.to_json)
  end
end

# Generate .csv file
def save_as_csv

    # Load JSON file
    emails = File.read('../../db/emails.json')

    # Parse JSON file
    data = JSON.parse(emails)

    # Create file
    CSV.open("../../db/emails.csv", "wb") do |csv|
      data.each do | municipality, email |
        csv << [municipality, email]
    end
  end
end

def menu
  puts "Welcome to the data exporter"
  puts
  puts "What kind of file format do you want ?"
  puts "1. Hash format"
  puts "2. JSON format"
  puts "3. CSV format"
  puts
  choice = gets.chomp().to_i
end

def menu_choice(choice)
  case choice
  when 1
    get_townhall_list(townhall_list_url)
  when 2
    save_as_JSON($hash)
    save_as_csv
  when 3
    save_as_csv
  else
    puts "Wrong input. Enter 1, 2 or 2"
    menu_choice(gets.chomp.to_i)
  end
end



