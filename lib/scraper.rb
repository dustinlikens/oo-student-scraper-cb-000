require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_index_array = []
    page = Nokogiri::HTML(open('./fixtures/student-site/index.html'))
    page.css("div.student-card").each do |card|
      student_name = card.css("h4.student-name").text
      student_hash = {}
      student_hash[:name] = student_name
      student_hash[:location] = card.css("p.student-location").text
      url_end = card.css("a").attribute("href").value
      student_hash[:profile_url] = "./fixtures/student-site/#{url_end}"
      student_index_array << student_hash
    end
    student_index_array
  end

  def self.scrape_profile_page(profile_url)
    scraped_student = {}
    page = Nokogiri::HTML(open(profile_url))

    social_links = page.css("div.social-icon-container a")
    social_links.each do |a|
      value = a.attribute("href").value
  
      if value.include?("twitter.com")
        scraped_student[:twitter] = value
      else if value.include?("linkedin.com")
        scraped_student[:linkedin] = value
        else if value.include?("github.com")
          scraped_student[:github] = value
        else
         scraped_student[:blog] = value
        end
        end
      end  

      # case value
      #   when value.include?("twitter.com")
      #     scraped_student[:twitter] = value
      #   when "www.linkedin.com"
      #     scraped_student[:linkedin] = value
      #   when "github.com"
      #     scraped_student[:github] = value
      #   else
      #     scraped_student[:blog] = value
      # end 

    end

    scraped_student[:profile_quote] = page.css("div.profile-quote").text
    scraped_student[:bio] = page.css("div.description-holder p").text

    scraped_student
  end

end

