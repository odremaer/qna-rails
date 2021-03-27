class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.belongs_to :commentable, polymorphic: true
      t.belongs_to :user, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
