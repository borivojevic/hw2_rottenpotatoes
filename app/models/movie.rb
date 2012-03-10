class Movie < ActiveRecord::Base

  def self.all_ratings
    group("rating").map(&:rating)
  end

end
