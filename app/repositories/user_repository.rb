require_relative "../models/user"

class UserRepository
  def self.fetch(id)
    return nil unless id

    User.find(id)
  end

  def self.fetch_by_access_token(access_token)
    return nil unless access_token

    User.where(:access_token => access_token).first
  end

  def self.fetch_or_create_by_access_token(access_token, username)
    if user = User.where(:access_token => access_token).first
      user
    else
      User.create!(:access_token => access_token, :username => username)
    end
  end

  def self.setup_complete?
    User.any? && User.first.setup_complete?
  end

  def self.save(user)
    user.save
    user
  end

  def self.first
    User.first
  end
end