# frozen_string_literal: true

ActiveRecord::Schema.define do
  # ------------------------------------------------------------------- #
  #                                                                     #
  #   Please keep these create table statements in alphabetical order   #
  #   unless the ordering matters.  In which case, define them below.   #
  #                                                                     #
  # ------------------------------------------------------------------- #

  create_table :authors, force: true do |t|
    t.string :name, null: false
  end

  create_table :posts, force: true do |t|
    t.references :author
    t.string :title, null: false
    t.text :body
    t.integer :count, default: 0
    t.boolean :enabled, default: false
  end
end
