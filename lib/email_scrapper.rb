require 'rubygems'
require 'nokogiri'         
require 'open-uri'
require 'json'
require 'google_drive'
require 'csv'
require "pry"
require 'resolv-replace'



class EmailScrapper

    attr_accessor :email, :ville
    @@all_users = []
        
    # Cree un array comportant toutes les villes du Val d'Oise
    def get_city
        page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
        villes =[]
        page.xpath('//*[@class="lientxt"]').each do |ville|
            villes << ville.text
        end
        return villes
    end


    #Cree un array comportant toutes les terminaisons des liens de chaque ville du Val d'Oise
    #Puis ajoute le debut du chemin pour construire les bons liens vers toutes les pages des villes du Val d'Oise
    def get_link
        page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
        faux_liens_villes =[]
        page.xpath('//*[@class="lientxt"]').each do |lien|
            faux_liens_villes << lien.values[1]
        end
        liens_villes = faux_liens_villes.map{ |el| "http://annuaire-des-mairies.com" + el[1..-1]}
        return liens_villes
    end

    #Scrappe l'email de la mairie sur chaque page (en passant sur tous les liens du tableau construit precedemment)
    def get_townhall_email(townhall_url)
        townhall_emails = []
        liens_villes = get_link
        for lien in townhall_url do 
            townhall_emails << Nokogiri::HTML(open(lien)).xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text 
        end
        return townhall_emails
    end
    
    #Range dans notre tableau des hash associant chaque ville a son email
    def create_hash_city_email
        emails_mairies = []
        villes = get_city
        url_villes = get_link
        townhall_emails = get_townhall_email(url_villes)
        for i in (0...villes.length) do
            emails_mairies << {"#{villes[i]}" => "#{townhall_emails[i]}"}
        end    
    return emails_mairies
    end

    def save_as_JSON
        emails_mairies = create_hash_city_email
        file = File.new("emails_mairies.json","a")
        emails_mairies.each do |hash|
            file.puts hash
        end
        file.close
    end

    def save_as_spreadsheet
    end

    def save_as_CSV
        villes = get_city
        url_villes = get_link
        townhall_emails = get_townhall_email(url_villes)
        list_csv = villes.zip(townhall_emails)
        CSV.generate do |csv|
            list_csv.each do |el|
                csv << el
            end
        end
        # emails_mairies = create_hash_city_email.map { |el| el.join(",")}.join("\n")
        # emails_mairies.each do |hash|
        #     csv.open("emails_mairies.csv", "w") do |csv|
        #         csv << hash
        #     end
        # end
        # binding pry
    end
end


            

valdoise = EmailScrapper.new
# print valdoise.create_hash_city_email
# #valdoise.save_as_JSON
valdoise.save_as_CSV
