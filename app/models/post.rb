class Post < ApplicationRecord
<<<<<<< HEAD
    has_many :comments, dependent: :destroy
=======
    has_many :comments
>>>>>>> 4802ee3 (Added comments functionality)

    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }
end
