class CreateBookFormats < ActiveRecord::Migration[6.1]
  def change
    create_table :book_formats do |t|
      t.references :book, null: false, foreign_key: true
      t.references :book_format_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
