require 'spec_helper'
include OwnTestHelper

describe "Beer" do
	let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
	let!(:user) { FactoryGirl.create :user }

	before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

	it "when given a name, beer is created" do
    visit new_beer_path
    fill_in('beer_name', with:'TestBeer')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.by(1)
  end

  it "user is returned to creat beer page if beer name is not valid" do
  	visit new_beer_path
  	fill_in('beer_name', with:'')
  	
  	click_button "Create Beer"
  	expect(current_path).to eq(beers_path)
  	expect(page).to have_content 'Name can\'t be blank'
  	expect(Beer.count).to eq(0)
  end

end