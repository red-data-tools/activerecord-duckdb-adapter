# frozen_string_literal: true

require "cases/helper"
require "models/author"
require "models/post"

class PersistenceTest < TestCase
  fixtures :authors, :posts

  def test_update_many
    author_data = { 1 => { "name" => "Bob" }, 2 => { "name" => "Tom" } }
    updated = Author.update(author_data.keys, author_data.values)

    assert_equal [1, 2], updated.map(&:id)
    assert_equal "Bob", Author.find(1).name
    assert_equal "Tom", Author.find(2).name
  end

  def test_update_all
    assert_equal Author.count, Author.update_all("name = 'bulk updated!'")
    assert_equal "bulk updated!", Author.find(1).name
    assert_equal "bulk updated!", Author.find(2).name
  end

  def test_create
    author = Author.new
    author.id = 7
    author.name = "Emi"
    author.save
    author_reloaded = Author.find(author.id)
    assert_equal("Emi", author_reloaded.name)
  end

  def test_delete
    author = Author.find(4)
    assert_equal author, author.delete, "author.delete did not return self"
    assert author.frozen?, "author not frozen after delete"
    assert_raise(ActiveRecord::RecordNotFound) { Author.find(author.id) }
  end

  def test_destroy
    author = Author.find(5)
    assert_equal author, author.destroy, "author.destroy did not return self"
    assert author.frozen?, "author not frozen after destroy"
    assert_raise(ActiveRecord::RecordNotFound) { Author.find(author.id) }
  end

  def test_delete_all
    assert Post.count > 0

    assert_equal Post.count, Post.delete_all
  end
end
