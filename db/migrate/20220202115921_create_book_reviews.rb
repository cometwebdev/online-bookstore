class CreateBookReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :book_reviews do |t|
      t.references :book, null: false, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
