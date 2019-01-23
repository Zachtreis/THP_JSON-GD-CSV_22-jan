class SaveData

    def self.save_as_json(datas)
        File.open("db/emails_mairies.json","w") do |f|
            f.puts(JSON.pretty_generate(datas))
            f.close
        end
    end

    def self.save_as_spreadsheet
        #create a Google Drive session & then create a new spreadsheet called "My new sheet"
        session = GoogleDrive::Session.from_config("config.json")
        ws = session.create_spreadsheet("My new sheet")
        ws = session.spreadsheet_by_title("My new sheet").worksheets[0]
        #parse the JSON file and include it in the spreadsheet
        json = File.read('db/emails_mairies.json')
        obj = JSON.parse(json)
        ws[1,1] = "Ville"
        ws[1,2] = "Email mairie"
        ws.insert_rows(2, obj)
        ws.save
    #retrieve the id of the google sheet created and puts its url on the terminal
    file_id = ws.worksheet_feed_url.split("/")[-4]
    ws_url = "https://docs.google.com/spreadsheets/d/#{file_id}/edit#gid=0"
        puts "", ws_url
    end

    def self.save_as_csv
        #open the csv file, and then parse the data from the json file and add it in the csv
        CSV.open("db/emails_mairies.csv", "w") do |csv| 
            JSON.parse(File.open("db/emails_mairies.json").read).each do |hash|
            csv << hash
            end
        end
    end

end