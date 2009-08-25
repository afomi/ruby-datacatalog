# I want to generate a new API key for a user
user = DataCatalog::User.find(user_id)

# ^^^^^^^^^^^^ DONE ^^^^^^^^^^^^^^^
# vvvvvvvvvvvvvvv NOT DONE vvvvvvvvvvvvvvvvvvv 

user.generate_api_key(:type => "valet", :purpose => "42")
user.generate_api_key(:type => "application", :purpose => "42")
# returns openstructified hash

# I want to get a user's primary API key
user = DataCatalog::User.find(user_id)
user.primary_api_key # => openstructified hash

user.application_api_keys # => [openstructified hashes]
user.valet_api_keys # => [openstructified hashes]

# I want to get all API keys of a single user
user = DataCatalog::User.find(user_id)
user.api_keys # => [openstructified hashes]


# I want to delete an API key of a user
user = DataCatalog::User.find(user_id)
user.delete_api_key("098123")
# => true / exception

# I want to update the purpose of an API key
user.update_api_key(:type => "...", :purpose => "42.5")
# => openstructified hash

# Given an API key, I want to see what user it corresponds to, if any.
DataCatalog::User.find_by_api_key("098123")
# => User object
