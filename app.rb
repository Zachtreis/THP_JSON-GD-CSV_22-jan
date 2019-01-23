require 'bundler'
Bundler.require
$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/email_scrapper'
require 'app/save_data'
require 'views/index'
require 'views/done'
require 'csv'
require 'open-uri'
require 'csv'
require 'resolv-replace'


class Launching
    attr_accessor :answer, :answer_end
  
    def perform
        #launch the menu to get user's choice
        answer = Index.prompt_choice
        case answer
        when 1
            Launching.parse_and_json
            puts "", "Datas scrapped and stored under email.json file available in 'db' folder", ""
            puts "*" * 60
        when 2
            Launching.parse_and_google_sheet
        when 3
            Launching.parse_and_csv
        end
        #launch the End_Menu to check if user wants to continue or not
        answer_end = Done.prompt
        case answer_end
        when 1
            Launching.new.perform
        when 2
            puts "*" * 60
            puts "", "You did it. You're amazing! See you around :)", ""
            puts "*" * 60
        end
    end
    
    private
    
    def self.parse_and_json
        #this launch the method to parse and save data as json file
        townhalls_data = EmailScrapper.new.perform
        SaveData.save_as_json(townhalls_data)
    end
    
    def self.parse_and_google_sheet
        #check if a config.json file (for GoogleDrive API) exists
        unless File.exist?('config.json')
            puts "", "Seems that config.json file is missing"
            puts "Please copy your own config.json file in this folder and launch again", ""
            puts "*" * 60
        else
            #if it exists, check if not empty before calling the method
            if File.read('config.json').empty?
                puts "", "Please ensure your config.json file is not corrupt", ""
            else
                #check if email.json file is not empty. If yes, call parse_and_json method
                if File.read('db/emails_mairies.json').empty? 
                    Launching.parse_and_json
                    SaveData.save_as_spreadsheet
                else
                    #if email.json file is not empty, call the Google Sheets method
                    SaveData.save_as_spreadsheet
                end
            puts "", "Data saved under Google Sheet (see link above)", ""
            puts "*" * 60
            end
        end
    end
    
    def self.parse_and_csv
        #check if email.json file is not empty. If yes, call parse_and_json method
        if File.read('db/emails_mairies.json').empty? 
            Launching.parse_and_json
            SaveData.save_as_csv
            puts "", "Datas stored under a csv file available in 'db' folder", ""
            puts "*" * 60
        else
            ##if email.json file is not empty, call the csv method
            SaveData.save_as_csv
            puts "", "Datas stored under a csv file available in 'db' folder", ""
            puts "*" * 60
        end
    end
    
end
  
#create a new class object to run the app (like a perform method)
Launching.new.perform