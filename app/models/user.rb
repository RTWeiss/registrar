class User < ActiveRecord::Base
  has_one :profile
  accepts_nested_attributes_for :profile

  has_many :domains
  has_many :collaborations, source: :domains

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
