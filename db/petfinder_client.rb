require "httparty"

class PetfinderClient
  include HTTParty
  base_uri "https://api.petfinder.com/v2"

  def initialize(client_id, client_secret)
    @client_id = client_id
    @client_secret = client_secret
    @token = get_token
  end

  def get_token
    response = self.class.post("/oauth2/token", body: {
      grant_type: "client_credentials",
      client_id: @client_id,
      client_secret: @client_secret
    })

    response["access_token"]
  end

  def get_pets(limit = 150)
    self.class.get("/animals", headers: { "Authorization" => "Bearer #{@token}" })
  end

  def get_organizations(limit = 150)
    self.class.get("/organizations", headers: { "Authorization" => "Bearer #{@token}" })
  end
end
