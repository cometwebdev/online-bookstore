class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :author
  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_type, through: :book_formats

  validates :title, presence: true
  validates :publisher, presence: true
  validates :author, presence: true

  def author_name
    # "%s, %s" % [ author.last_name, author.first_name ]
    "#{author.last_name}, #{author.first_name}"
  end

  def average_rating
    book_reviews.sum(:rating) * 1.0 / book_reviews.count
  end

  def book_format_types
    BookFormatType.joins(:books).where("books.id = #{id}")
  end

  def self.search (query, **options)
    searched_books = self.all
    query = query.downcase

    # title_only
    title_only = options[:title_only] || false

    if title_only == true
      searched_books = searched_books.where("lower(title) LIKE '%#{query}%'")
    elsif title_only == false
      searched_books = searched_books.joins(:author, :publisher).where("lower(title) LIKE '%#{query}%' OR lower(authors.last_name) = '#{query}' OR lower(publishers.name) = '#{query}'")
    end

    # book_format_physical
    book_format_physical = options[:book_format_physical]

    searched_books = searched_books.joins(:book_format_type).where("book_format_types.physical = #{book_format_physical}").group(:id) unless book_format_physical.nil?

    # book_format_type_id
    book_format_type_id = options[:book_format_type_id]

    searched_books = searched_books.joins(:book_format_type).where("book_format_types.id = #{book_format_type_id}").group(:id) unless book_format_type_id.nil?

    searched_books.sort { |a, b| -a.average_rating <=> -b.average_rating }
  end

  def to_s
    title
  end
end
