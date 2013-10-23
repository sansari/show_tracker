class Episode < ActiveRecord::Base
  serialize :cast, Array

  belongs_to :show
end
