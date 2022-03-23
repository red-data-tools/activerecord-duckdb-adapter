# frozen_string_literal: true

require "cases/helper"
require "models/author"
require "models/post"

class AuthorTest < TestCase
  include ActiveModel::Lint::Tests

  setup do
    @model = Author.new
  end
end

class PostTest < TestCase
  include ActiveModel::Lint::Tests

  setup do
    @model = Post.new
  end
end
