require 'httparty'
require 'json'
require 'faker'
require 'csv'

# Clear existing records
# PetsTag.destroy_all
# Pet.destroy_all
# Tag.destroy_all
# Shelter.destroy_all
# Category.destroy_all








# # Create a few shelters using Faker
# 20.times do
#   Shelter.create!(
#     shelter_id: Faker::Number.unique.number(digits: 4),
#     name: Faker::Company.name,
#     city: Faker::Address.city,
#     state: Faker::Address.state_abbr,
#     country: "US",
#     website: Faker::Internet.url,
#     latitude: Faker::Address.latitude,
#     longitude: Faker::Address.longitude,
#     distance: Faker::Number.between(from: 1, to: 500)
#   )
# end

# Create 50 unique tags using Faker for both dogs and cats
unique_tags = Set.new
while unique_tags.size < 50
  unique_tags.add(Faker::Creature::Dog.meme_phrase)
  unique_tags.add(Faker::Creature::Dog.breed)
  unique_tags.add(Faker::Creature::Cat.breed)
end

unique_tags.each do |tag_name|
  Tag.create!(name: tag_name)
end

# # Create a large number of pets and associate them with tags using Faker
# 20.times do
#   shelter = Shelter.order('RANDOM()').first
#   animal_type = [ 'Dog', 'Cat' ].sample
#   pet = Pet.create!(
#     pet_id: Faker::Number.unique.number(digits: 6),
#     name: animal_type == 'Dog' ? Faker::Creature::Dog.name : Faker::Creature::Cat.name,
#     animal_type: animal_type,
#     breed: animal_type == 'Dog' ? Faker::Creature::Dog.breed : Faker::Creature::Cat.breed,
#     age: [ 'Baby', 'Young', 'Adult', 'Senior' ].sample,
#     size: [ 'Small', 'Medium', 'Large', 'Extra Large' ].sample,
#     gender: [ 'Male', 'Female' ].sample,
#     status: [ 'adoptable', 'adopted' ].sample,
#     photo_urls: Faker::LoremFlickr.image(size: "300x300", search_terms: [ animal_type.downcase ]),
#     shelter: shelter
#   )

#   # Associate each pet with 2 unique tags
#   Tag.order('RANDOM()').limit(2).each do |tag|
#     pet.tags << tag
#   end
# end








# # Create additional shelters from a CSV file
# CSV.foreach("db/csv/additional_shelters.csv", headers: true) do |row|
#   Shelter.create!(
#     shelter_id: row["shelter_id"],
#     name: row["name"],
#     city: row["city"],
#     state: row["state"],
#     country: row["country"],
#     website: row["website"],
#     latitude: row["latitude"],
#     longitude: row["longitude"],
#     distance: row["distance"]
#   )
# end

# # Create additional tags from a CSV file
# CSV.foreach("db/csv/additional_tags.csv", headers: true) do |row|
#   Tag.find_or_create_by!(
#     id: row["tag_id"],
#     name: row["name"]
#   )
# end

# # Create additional pets from a CSV file
# CSV.foreach("db/csv/additional_pets.csv", headers: true) do |row|
#   Pet.create!(
#     pet_id: row["pet_id"],
#     name: row["name"],
#     animal_type: row["animal_type"],
#     breed: row["breed"],
#     age: row["age"],
#     size: row["size"],
#     gender: row["gender"],
#     status: row["status"],
#     photo_urls: ActionController::Base.helpers.asset_path('default_pet_image.jpg'),
#     shelter_id: Shelter.find_by(shelter_id: row["shelter_id"]).id
#   )
# end

# # Create pets_tags from a CSV file
# CSV.foreach("db/csv/additional_pets_tags.csv", headers: true) do |row|
#   pet = Pet.find_by(pet_id: row["pet_id"])
#   tag = Tag.find_by(id: row["tag_id"])
#   if pet && tag
#     pet.tags << tag unless pet.tags.include?(tag)
#   end
# end


















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

# # Track fetched shelter and pet IDs to ensure uniqueness
# fetched_shelter_ids = Set.new
# fetched_pet_ids = Set.new

# # Fetch shelters data from Petfinder
# (1..2).each do |page|
#   uri = URI("https://api.petfinder.com/v2/organizations?limit=100&page=#{page}")
#   req = Net::HTTP::Get.new(uri)
#   req['Authorization'] = "Bearer #{access_token}"
#   response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
#   shelters_data = JSON.parse(response.body)

#   if shelters_data
#     shelters = shelters_data['organizations']
#   else
#     shelters = nil
#   end

#   if shelters.nil?
#     puts "Failed to fetch shelters data from Petfinder"
#   else
#     # Seed the database with shelters data from Petfinder
#     shelters.each do |shelter_data|
#       next if fetched_shelter_ids.include?(shelter_data['id'])

#       fetched_shelter_ids.add(shelter_data['id'])
#       address = shelter_data['address']
#       latitude = address['latitude'] || Faker::Address.latitude
#       longitude = address['longitude'] || Faker::Address.longitude
#       distance = shelter_data['distance'] || Faker::Number.between(from: 1, to: 500)

#       shelter = Shelter.find_or_create_by!(
#         shelter_id: shelter_data['id'],
#         name: shelter_data['name'],
#         city: address['city'],
#         state: address['state'],
#         country: address['country'],
#         website: shelter_data['website'],
#         latitude: latitude,
#         longitude: longitude,
#         distance: distance
#       )

#       # Fetch pets data for each shelter from Petfinder and seed the database
#       uri = URI("https://api.petfinder.com/v2/animals?organization=#{shelter_data['id']}&limit=5")
#       req = Net::HTTP::Get.new(uri)
#       req['Authorization'] = "Bearer #{access_token}"
#       response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
#       pets_data = JSON.parse(response.body)

#       if pets_data
#         pets = pets_data['animals']
#       else
#         pets = nil
#       end

#       next if pets.nil?

#       pets.each do |pet|
#         next if fetched_pet_ids.include?(pet['id'])

#         fetched_pet_ids.add(pet['id'])
#         pet_record = Pet.create!(
#           pet_id: pet['id'],
#           name: pet['name'],
#           animal_type: pet['type'],
#           breed: pet['breeds']['primary'],
#           age: pet['age'],
#           size: pet['size'],
#           gender: pet['gender'],
#           status: pet['status'],
#           photo_urls: pet['photos'].map { |photo| photo['medium'] }.join(', '),
#           shelter: shelter
#         )

#         # Fetch and create tags, limit to 3 tags per pet
#         pet['tags'].sample(3).each do |tag_name|
#           next if tag_name.blank?

#           tag = Tag.find_or_create_by!(name: tag_name)
#           pet_record.tags << tag
#         end

#         # Add additional tags using Faker
#         4.times do
#           faker_tag_name = Faker::Creature::Cat.breed
#           tag = Tag.find_or_create_by!(name: faker_tag_name)
#           pet_record.tags << tag
#         end
#       end
#     end
#   end
# end










# # Create categories
# categories = [ 'All Shelter', 'Dog Shelter', 'Cat Shelter', 'Animal Shelter' ]
# categories.each do |category_name|
#   Category.find_or_create_by!(name: category_name)
# end

# # Assign categories to shelters based on the animal types of the pets
# Shelter.all.each do |shelter|
#   animal_types = shelter.pets.pluck(:animal_type).uniq
#   category_name = if animal_types.include?('Dog')
#                     'Dog Shelter'
#   elsif animal_types.include?('Cat')
#                     'Cat Shelter'
#   else
#                     'Animal Shelter'
#   end
#   category = Category.find_by(name: category_name)
#   shelter.update!(category_id: category.id)
# end

# # Assign "All Shelter" category to all shelters
# all_shelter_category = Category.find_by(name: 'All Shelter')
# Shelter.all.each do |shelter|
#   shelter.update!(category_id: all_shelter_category.id)
# end






# Associate additional tags to existing pets
existing_tags = Tag.all
Pet.all.each do |pet|
  additional_tags = existing_tags.sample(1)
  additional_tags.each do |tag|
    pet.tags << tag unless pet.tags.include?(tag)
  end
end



puts "Number of shelters seeded: #{Shelter.count}"
puts "Number of pets seeded: #{Pet.count}"
puts "Number of tags seeded: #{Tag.count}"
puts "Number of pets_tags seeded: #{PetsTag.count}"
puts "Number of categories seeded: #{Category.count}"
