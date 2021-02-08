class User < ApplicationRecord
  searchkick word_middle: [:first_name, :last_name, :email]

  validates :email, presence: true, uniqueness: true

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email
    }
  end
end
