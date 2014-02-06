require 'spec_helper'

describe User do
  it "has the username set correctly" do
  	user = User.new username:"Pekka"
  	user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a short password" do
    user = User.create username:"Pekka", password:"4S", password_confirmation:"4S"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a lower case password" do
    user = User.create username:"Pekka", password:"asdasd", password_confirmation:"asdasd"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end


  describe "with a proper password" do
    let(:user){ User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1" }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score:10
      rating2 = Rating.new score:20

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
