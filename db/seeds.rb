require_relative "../lib/petfinder_client"
require "csv"
require "faker"

# Clean up existing data
PetsTag.destroy_all
Pet.destroy_all
Shelter.destroy_all
Tag.destroy_all

# Initialize the Petfinder API client
client_id = "8zSiUdFdzQFSEMqpodCbqqKmp2uYlVXCMVBIbODGoujRGEqxws"
client_secret = "k2pvSPvsy5lu7sGaItYvJFY8S8F10BEy0TkMlT85"
petfinder_client = PetfinderClient.new(client_id, client_secret)

# Fetch data from the Petfinder API
pets_response = petfinder_client.get_pets(150)
organizations_response = petfinder_client.get_organizations(150)

# Create shelters from the API data
organizations_response["organizations"].each do |org|
  Shelter.create!(
    shelter_id: org["id"],
    name: org["name"],
    city: org["address"]["city"],
    state: org["address"]["state"],
    country: org["address"]["country"],
    website: org["website"]
  )
end

# Create pets and tags from the API data
pets_response["animals"].each do |animal|
  pet = Pet.create!(
    pet_id: animal["id"],
    name: animal["name"],
    type: animal["type"],
    breed: animal["breeds"]["primary"],
    age: animal["age"],
    size: animal["size"],
    gender: animal["gender"],
    status: animal["status"],
    photo_urls: animal["photos"].map { |photo| photo["full"] }.join(", "),
    shelter_id: animal["organization_id"]
  )

  # Create and assign tags to pets
  animal["tags"].each do |tag_name|
    tag = Tag.find_or_create_by!(name: tag_name)
    PetsTag.create!(pet: pet, tag: tag)
  end
end





# Create additional pets using Faker
30.times do
  pet = Pet.create!(
    pet_id: Faker::Number.unique.number(digits: 4),
    name: Faker::Creature::Dog.name,
    type: [ "dog", "cat", "bird" ].sample,
    breed: Faker::Creature::Dog.breed,
    age: [ "baby", "young", "adult", "senior" ].sample,
    size: [ "small", "medium", "large" ].sample,
    gender: [ "male", "female" ].sample,
    status: [ "adoptable", "adopted" ].sample,
    photo_urls: [ Faker::Internet.url ],
    shelter: Shelter.order("RANDOM()").first
  )

  # Assign random tags to pets
  Tag.order("RANDOM()").limit(2).each do |tag|
    PetsTag.create!(pet: pet, tag: tag)
  end
end


# Create additional shelters using Faker
30.times do
  Shelter.create!(
    shelter_id: Faker::Number.unique.number(digits: 4),
    name: Faker::Company.name,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    country: "US",
    website: Faker::Internet.url
  )
end







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


# Create additional pets from a CSV file
CSV.foreach("db/csv/additional_shelters.csv", headers: true) do |row|
  pet = Pet.create!(
    pet_id: row["pet_id"],
    name: row["name"],
    type: row["type"],
    breed: row["breed"],
    age: row["age"],
    size: row["size"],
    gender: row["gender"],
    status: row["status"],
    photo_urls: row["photo_urls"],
    shelter_id: row["shelter_id"]
  )

  # Assign random tags to pets
  Tag.order("RANDOM()").limit(2).each do |tag|
    PetsTag.create!(pet: pet, tag: tag)
  end
end
