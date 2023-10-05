class Movie < ActiveRecord::Base

  attr_accessor :ratings_to_show

  def initialize
    @ratings_to_show = ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
  
  if ratings_list == nil
    return Movie.all
  else
    return Movie.where(rating: ratings_list)
  end

  end

  def all_ratings
    return ['G','PG','PG-13','R']
  end

  def checkbox(ratings)
    if ratings.length() > 0
      return ratings
    else
      return @ratings_to_show
    end
  end

end
