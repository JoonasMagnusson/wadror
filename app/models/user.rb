class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { in: 3..15 }

  validates :password, length: { minimum: 3 },
                       format: { with: /.*(\d.*[A-Z]|[A-Z].*\d).*/,
                                 message: "should contain a uppercase letter and a number" }


  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty? 
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    ratings.first.beer.style
    #TODO actual implementation
  end

  def favorite_brewery
    return nil if ratings.empty?
    ratings.first.beer.brewery
    #TODO actual implementation
  end

end
