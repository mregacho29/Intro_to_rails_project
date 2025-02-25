# Dataset Description: Petfinder API

The Petfinder API, which offers access to an extensive database of pets up for adoption from different shelters and rescue groups, serves as the project's main data source.  Individual pet details, such as species, breed, age, size, gender, location, and adoption status, are provided by the API.  It also offers metadata, like names, locations, and contact details, regarding shelters and organizations.

Data Structure and Required Tables/Columns
The data retrieved from the Petfinder API can be structured into the following tables:

1. Pets Table
This table will store essential information about each pet available for adoption.

Column Name	Data Type	  Description
pet_id	    Integer	    Unique identifier for the pet.
name	      String	    Name of the pet.
type	      String	    Species of the pet (e.g., dog, cat, bird).
breed	      String	    Breed of the pet (e.g., Labrador, Siamese).
age	        String	    Age group (e.g., baby, young, adult, senior).
size	      String	    Size of the pet (e.g., small, medium, large).
gender	    String	    Gender of the pet (e.g., male, female).
status	    String	    Adoption status (e.g., adoptable, adopted).
photo_urls	Text	      URLs of the pet's photos.
shelter_id	Integer     Foreign key linking to the Shelters table.

2. Shelters Table
This table will store essential information about the shelters or organizations where the pets are located.

Column Name	  Data Type	  Description
shelter_id	  Integer     Unique identifier for the shelter.
name	        String	    Name of the shelter or organization.
city	        String	    City where the shelter is located.
state	        String	    State or region where the shelter is located.
country	      String	    Country where the shelter is located.
website	      String	    Website URL of the shelter.

3. Tags Table
This table will store various tags that describe the characteristics or attributes of pets.

Column Name    Data Type    Description
id             Integer      Unique identifier for the tag.
name           String       Name of the tag (e.g., friendly, playful).

4. PetsTags Table
This join table will store the associations between pets and tags, enabling a many-to-many relationship between the Pets and Tags tables.

Column Name    Data Type    Description
pet_id         Integer      Foreign key linking to the Pets table.
tag_id         Integer      Foreign key linking to the Tags table.

Relationships Between Tables
Pets and Shelters:
Each pet in the Pets Table is associated with a shelter in the Shelters Table via the shelter_id foreign key. This allows for querying pets based on their location or the shelter they belong to.

Pets and Tags:
Each pet in the Pets Table can have multiple tags, and each tag in the Tags Table can be associated with multiple pets through the PetsTags join table.