require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do

    it 'is valid with valid attributes' do
      user = User.new(username: "jimy", email: "jimy@gmail.com", password: "password", password_confirmation: "password")
      expect(user).to be_valid
    end

    it 'is not valid without valid attributes' do
      user = User.new(username: nil, email: nil, password: nil, password_confirmation: nil)
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("can't be blank")
      expect(user.errors[:email]).to include("can't be blank")
      expect(user.errors[:password]).to include("can't be blank")
      expect(user.errors[:password_confirmation]).to include("can't be blank")
    end

    it 'is not valid with a duplicate username and email' do
      User.create(username: "jimy", email: "jimy@gmail.com", password: "password", password_confirmation: "password")
      user = User.new(username: "jimy", email: "jimy@gmail.com", password: "password", password_confirmation: "password")
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("has already been taken")
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'is invalid with an invalid email format' do
      user = User.new(username: 'jimy', email: 'invalid_email', password: 'password', password_confirmation: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    # it 'is invalid with a password shorter then 6 character' do
    #   user = User.new(username: 'jimy', email: 'jimy@gmail.com', password: 'pas', password_confirmation: 'pas')
    #   expect(user).to_not be_valid
    #   expect(user.errors[:password]).to include("is invalid")
    # end

    it 'is invalid when password confirmation does not match' do
      user = User.new(username: 'jimy', email: 'jimy@gmail.com', password: 'password', password_confirmation: 'abcdefg')
      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

  end
end
