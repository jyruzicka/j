class J::Tag < ActiveRecord::Base
  has_and_belongs_to_many :entries, :join_table => "taggings"

  def to_s
    name
  end
end