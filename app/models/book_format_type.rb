class BookFormatType < ApplicationRecord
    has_many :book_format
    has_many :books, through: :book_format
end
