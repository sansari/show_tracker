class Episode < ActiveRecord::Base
  include RedisSerialize

  redis_serialize :cast

  belongs_to :show
end
