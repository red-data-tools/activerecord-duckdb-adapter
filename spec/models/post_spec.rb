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

  let(:params) { { id: 1, title: "duckdb book", views: 10000 } }

  context 'initialization' do
    it 'should initialize a post object with all columns' do
      post = Post.new(params)
      expect(post).to be_a(Post)
      expect(post.title).to eq "duckdb book"
      expect(post.views).to eq 10000
    end
  end

  context 'persistance' do
    before do
      @post = Post.create!(params)
    end

    after do
      # 多分deleteは数字を返すことを求めてるけど、duckdbのlibraryは削除したentityを返すようになってる
      @post.destroy
    end

    it 'should persist the record to the database' do
      expect(Post.find(1)).to be_a(Post)
      expect(Post.count).to eq 1
    end

    it 'dd' do
      post1 = Post.create(params.merge(id: 2))
      p post1
      p Post.count

      d = Post.where(id: [1, 2]).destroy_all
      p d
      p Post.count
      p Post.first
    end
  end
end