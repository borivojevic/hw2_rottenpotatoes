class Movie < ActiveRecord::Base

  def self.all_ratings
    select("rating").group("rating").map(&:rating)
  end

end
