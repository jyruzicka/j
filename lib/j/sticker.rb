class J::Sticker < ActiveRecord::Base
  has_and_belongs_to_many :entries, :join_table => "stickings"
end