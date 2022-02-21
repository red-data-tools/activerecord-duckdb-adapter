require_relative '../spec_helper'

describe Post do
  before(:all) do
    ActiveRecord::Migration.class_eval do
      create_table :posts do |t|
        t.string :title
        t.integer :views
      end
    end
    Post.reset_column_information
  end

  after(:all) do
    ActiveRecord::Migration.class_eval do
      drop_table :posts
    end
  end

  let(:params) { {title: "duckdb book", views: 10000} }

  context 'initialization' do
    it 'should initialize a post object with all columns' do
      post = Post.new(params)
      post.should be_a(Post)
      post.title.should eq "duckdb book"
      post.views.should eq 10000
    end
  end

  context 'persistance' do

    before do
      @post = Post.create!(params)
    end

    after do
      @post.destroy
    end

    it 'should persist the record to the database' do
      @post.persisted?.should eq true
      refresh_posts
      Post.count.should eq 1
    end
  end
end