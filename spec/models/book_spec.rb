require 'rails_helper'

class Command; end

RSpec.describe Book, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before :each do
    @corey = Author.create(first_name: 'corey', last_name: 'breshears')
    @william = Publisher.create(name: 'william')
    @funny = Book.create(title: 'funny', author: @corey, publisher: @william)
    BookReview.create(book: @funny, rating: 5)
    BookReview.create(book: @funny, rating: 4)
    BookReview.create(book: @funny, rating: 2)
    BookFormatType.create(name: 'hardcover1', physical: true)
    BookFormatType.create(name: 'hardcover2', physical: true)
    @pdf = BookFormatType.create(name: 'pdf', physical: false)
    @docx = BookFormatType.create(name: 'docx', physical: false)
    BookFormat.create(book: @funny, book_format_type: @pdf)
    BookFormat.create(book: @funny, book_format_type: @docx)
  end

  it "author_name should work well" do
    @author_name = @funny.author_name
    expect(@author_name).to eq ('breshears, corey')
  end

  it "average_rating should work well" do
    @average_rating = @funny.average_rating
    expect(@average_rating).to eq (5+4+2)/3.0
  end

  it "book_format_types should work well" do
    @book_format_types = @funny.book_format_types
    expect(@book_format_types.count).to eq 2
  end

  it "title_only search should work well" do
    books = Book.search('fUn', title_only: true)
    expect(books.count).to eq 1

    books = Book.search('wonderful', title_only: true)
    expect(books.count).to eq 0

    books = Book.search('bReshEars')
    expect(books.count).to eq 1

    books = Book.search('brEshear', title_only: false)
    expect(books.length()).to eq 0
  end

  it "total search should work well" do
    books = Book.search('brEshears', book_format_type_id: 3, book_format_physical: true)
    expect(books.length()).to eq 0

    books = Book.search('brEshears', book_format_type_id: 3, book_format_physical: false)
    expect(books.length()).to eq 1
  end
end
