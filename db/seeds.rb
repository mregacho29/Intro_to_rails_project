require 'net/http'
require 'json'
require 'faker'
require 'csv'

# Clear existing records
PetsTag.destroy_all
Pet.destroy_all
Tag.destroy_all
Shelter.destroy_all

# Create additional shelters from a CSV file
CSV.foreach("db/csv/additional_shelters.csv", headers: true) do |row|
  Shelter.create!(
    shelter_id: row["shelter_id"],
    name: row["name"],
    city: row["city"],
    state: row["state"],
    country: row["country"],
    website: row["website"]
  )
end

# Create additional tags from a CSV file
CSV.foreach("db/csv/additional_tags.csv", headers: true) do |row|
  Tag.find_or_create_by!(
    id: row["tag_id"],
    name: row["name"]
  )
end

# Create additional pets from a CSV file
CSV.foreach("db/csv/additional_pets.csv", headers: true) do |row|
  Pet.create!(
    pet_id: row["pet_id"],
    name: row["name"],
    animal_type: row["animal_type"],
    breed: row["breed"],
    age: row["age"],
    size: row["size"],
    gender: row["gender"],
    status: row["status"],
    photo_urls: row["photo_urls"],
    shelter_id: Shelter.find_by(shelter_id: row["shelter_id"]).id
  )
end

# Create pets_tags from a CSV file
CSV.foreach("db/csv/additional_pets_tags.csv", headers: true) do |row|
  pet = Pet.find_by(pet_id: row["pet_id"])
  tag = Tag.find_by(id: row["tag_id"])
  if pet && tag
    pet.tags << tag unless pet.tags.include?(tag)
  end
end

# Create a few shelters using Faker
100.times do
  Shelter.create!(
    shelter_id: Faker::Number.unique.number(digits: 4),
    name: Faker::Company.name,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    country: "US",
    website: Faker::Internet.url
  )
end

# Create 100 unique tags using Faker for both dogs and cats
unique_tags = Set.new
while unique_tags.size < 100
  unique_tags.add(Faker::Creature::Dog.meme_phrase)
  unique_tags.add(Faker::Creature::Cat.breed)
end

unique_tags.each do |tag_name|
  Tag.create!(name: tag_name)
end

# Create a large number of pets and associate them with tags using Faker
150.times do
  shelter = Shelter.order('RANDOM()').first
  animal_type = [ 'Dog', 'Cat' ].sample
  pet = Pet.create!(
    pet_id: Faker::Number.unique.number(digits: 6),
    name: animal_type == 'Dog' ? Faker::Creature::Dog.name : Faker::Creature::Cat.name,
    animal_type: animal_type,
    breed: animal_type == 'Dog' ? Faker::Creature::Dog.breed : Faker::Creature::Cat.breed,
    age: [ 'Baby', 'Young', 'Adult', 'Senior' ].sample,
    size: [ 'Small', 'Medium', 'Large', 'Extra Large' ].sample,
    gender: [ 'Male', 'Female' ].sample,
    status: [ 'adoptable', 'adopted' ].sample,
    photo_urls: Faker::LoremFlickr.image(size: "300x300", search_terms: [ animal_type.downcase ]),
    shelter: shelter
  )

  # Associate each pet with 2 unique tags
  Tag.order('RANDOM()').limit(2).each do |tag|
    pet.tags << tag
  end
end


# # Define your Petfinder API credentials
# PETFINDER_API_KEY = '8zSiUdFdzQFSEMqpodCbqqKmp2uYlVXCMVBIbODGoujRGEqxws'
# PETFINDER_API_SECRET = 'k2pvSPvsy5lu7sGaItYvJFY8S8F10BEy0TkMlT85'

# # Get an access token from Petfinder
# uri = URI('https://api.petfinder.com/v2/oauth2/token')
# response = Net::HTTP.post_form(uri, {
#   'grant_type' => 'client_credentials',
#   'client_id' => PETFINDER_API_KEY,
#   'client_secret' => PETFINDER_API_SECRET
# })
# access_token = JSON.parse(response.body)['access_token']

# def fetch_with_retry(uri, req, max_retries = 5)
#   retries = 0
#   begin
#     response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
#     if response.is_a?(Net::HTTPSuccess)
#       JSON.parse(response.body)
#     elsif response.code.to_i == 429
#       raise "Rate limit exceeded"
#     else
#       puts "Failed to fetch data: #{response.code} #{response.message}"
#       puts "Response body: #{response.body}"
#       nil
#     end
#   rescue => e
#     if retries < max_retries
#       retries += 1
#       sleep_time = 2**retries
#       puts "Retrying in #{sleep_time} seconds due to error: #{e.message}"
#       sleep(sleep_time)
#       retry
#     else
#       puts "Max retries reached. Failed to fetch data due to error: #{e.message}"
#       nil
#     end
#   end
# end

# # Fetch shelters data from Petfinder
# uri = URI('https://api.petfinder.com/v2/organizations?limit=100')
# req = Net::HTTP::Get.new(uri)
# req['Authorization'] = "Bearer #{access_token}"
# shelters_data = fetch_with_retry(uri, req)

# if shelters_data
#   shelters = shelters_data['organizations']
# else
#   shelters = nil
# end

# if shelters.nil?
#   puts "Failed to fetch shelters data from Petfinder"
# else
#   # Seed the database with shelters data from Petfinder
#   shelters.each do |shelter_data|
#     shelter = Shelter.find_or_create_by!(
#       shelter_id: shelter_data['id'],
#       name: shelter_data['name'],
#       city: shelter_data['address']['city'],
#       state: shelter_data['address']['state'],
#       country: shelter_data['address']['country'],
#       website: shelter_data['website']
#     )

#     # Fetch pets data for each shelter from Petfinder and seed the database
#     uri = URI("https://api.petfinder.com/v2/animals?organization=#{shelter_data['id']}&limit=3")
#     req = Net::HTTP::Get.new(uri)
#     req['Authorization'] = "Bearer #{access_token}"
#     pets_data = fetch_with_retry(uri, req)

#     if pets_data
#       pets = pets_data['animals']
#     else
#       pets = nil
#     end

#     next if pets.nil?

#     pets.each do |pet|
#       pet_record = Pet.create!(
#         pet_id: pet['id'],
#         name: pet['name'],
#         animal_type: pet['type'],
#         breed: pet['breeds']['primary'],
#         age: pet['age'],
#         size: pet['size'],
#         gender: pet['gender'],
#         status: pet['status'],
#         photo_urls: pet['photos'].map { |photo| photo['medium'] }.join(', '),
#         shelter: shelter
#       )

#       # Fetch and create tags
#       pet['tags'].each do |tag_name|
#         next if tag_name.blank?

#         tag = Tag.find_or_create_by!(name: tag_name)
#         pet_record.tags << tag
#       end
#     end
#   end
# end

puts "Number of shelters seeded: #{Shelter.count}"
puts "Number of pets seeded: #{Pet.count}"
puts "Number of tags seeded: #{Tag.count}"
puts "Number of pets_tags seeded: #{PetsTag.count}"
