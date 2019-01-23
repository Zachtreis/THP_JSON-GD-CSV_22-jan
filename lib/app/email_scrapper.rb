class EmailScrapper

    attr_accessor :global_list
       
    def perform
        create_hash_city_email
        @city_email = []
        @city_email = @global_list
    end


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
        @global_list = Hash.new
        @global_list = Hash[villes.zip(townhall_emails)]
        return @global_list
    end

end

