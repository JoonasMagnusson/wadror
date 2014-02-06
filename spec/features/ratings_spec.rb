require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user2 }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "List ratings" do
    let!(:rating1) { FactoryGirl.create :rating, beer:beer1, user:user  }
    let!(:rating2) { FactoryGirl.create :rating, beer:beer2, user:user  }
    let!(:rating3) { FactoryGirl.create :rating, beer:beer2, user:user2  }
    

    it "lists the ratings and their number" do
      @ratings = [rating1, rating2, rating3]
      visit ratings_path
      expect(page).to have_content "Number of ratings #{@ratings.count}"
      @ratings.each do |rating|
        expect(page).to have_content rating.beer.name
      end
    end

    it "lists only users ratings" do
      @user_ratings = [rating1, rating2]

      visit user_path(user)

      expect(page).to have_content "#{user.username} has made #{@user_ratings.count}"
      @user_ratings.each do |rating|
        expect(page).to have_content rating.beer.name
      end

    end

    it " is succesfully deleted" do
      id = rating1.id
      visit user_path(user)

      expect{
        find('li', :text => "#{rating1.beer.name}").click_link('delete')
      }.to change{Rating.count}.by(-1)
    end

  end
end