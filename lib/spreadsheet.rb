# lib/spreadsheet.rb
# spreadsheet id: 1avYA6yl8Wb5Pt5Z6df1PXTwxSQ_2bPG4aGQjiV9U3JY
 
require 'google_drive'
require 'pry'

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config("../lib/../config.json")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
# Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
#ws = session.spreadsheet_by_key("1avYA6yl8Wb5Pt5Z6df1PXTwxSQ_2bPG4aGQjiV9U3JY").worksheets[0]

# Load JSON file
emails = File.read('../db/emails.json')

# Parse JSON file
data = JSON.parse(emails)

# Create a new spreadsheet
spreadsheet = session.create_spreadsheet('City Halls')

# Select the first worksheet
worksheet = spreadsheet.worksheets.first

# Set the headers
worksheet[1,1] = "Municipality"
worksheet[1,2] = "Email Address"

# Write the data in the worksheet
# Loop through the data and add it to the worksheet
row = 2
data.each do |municipality, email|
  worksheet[row, 1] = municipality
  worksheet[row, 2] = email
  row += 1
end

# Save the changes to the worksheet
worksheet.save

