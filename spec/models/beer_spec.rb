require 'spec_helper'

describe Beer do
  it "is created with name and style" do
  	beer = Beer.create name:"Bisse", style:"IPA"
  	expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not created without name" do
  	beer = Beer.create style:"IPA"
  	expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not created without style" do
  	beer = Beer.create name:"Bisse"
  	expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  def create_beer_with_rating(score, user)
      beer = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, score:score, beer:beer, user:user)
      beer
    end

end
