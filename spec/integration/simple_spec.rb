require 'rudux/combined'
require 'rudux/hash_reducer'

describe 'Rudux' do

  it 'handles object based state' do

    class State < Rudux::Entity
      attr_reader :posts, :comments
    end

    class Post < Rudux::Entity
      attr_reader :id, :title, :comments
      def initialize hash
        @comments = []
        super hash
      end
    end

    class Comment < Rudux::Entity
      attr_reader :id, :body
    end

    class AddComment < Rudux::Action
      attr_reader :post_id, :body, :comment

      def initialize post_id, comment
        @post_id    = post_id
        @comment    = comment
      end

      def comment_id
        @comment.id
      end
    end

    class EditComment < Rudux::Action
      attr_reader :comment_id, :body

      def initialize comment_id, body
        @comment_id = comment_id
        @body = body
      end
    end

    class PostReducer < Rudux::Reducer
      def self.add_comment state, action
        if state.id == action.post_id
          {
            comments: state.comments + [action.comment_id]
          }
        else
          {}
        end
      end
    end

    class CommentReducer < Rudux::Reducer
      def self.edit_comment state, action
        if state.id == action.comment_id
          {
            body: action.body
          }
        else
          {}
        end
      end
    end

    class StateReducer < Rudux::Reducer
      def self.add_comment state, action
        h = Hash[action.comment_id, action.comment]
        {
          comments: state.comments.merge(h)
        }
      end

      def self.base
        Rudux::Combined.new({
          posts:    Rudux::HashReducer.new(PostReducer),
          comments: Rudux::HashReducer.new(CommentReducer),
        })
      end
    end


    p0 = Post.new(id: :p0, title: "First post")
    p1 = Post.new(id: :p1, title: "Second post")
    state = State.new(posts: { :p0 => p0, :p1 => p1 }, comments: {})
    store = Rudux::Store.new(StateReducer, state)

    # identity
    expect(store.state.posts.keys[0]).to eq p0.id
    expect(store.state.posts.keys[1]).to eq p1.id

    # values
    expect(store.state.posts.values[0]).to eq p0
    expect(store.state.posts.values[1]).to eq p1

    # add comments
    c0 = Comment.new(id: :c0, body: "First comment")
    c1 = Comment.new(id: :c1, body: "Second comment")
    action0 = AddComment.new(:p0, c0)
    action1 = AddComment.new(:p0, c1)
    store.dispatch(action0)
    store.dispatch(action1)

    # identity
    expect(store.state.comments.keys[0]).to eq c0.id
    expect(store.state.comments.keys[1]).to eq c1.id

    # values
    expect(store.state.comments.values[0]).to eq c0
    expect(store.state.comments.values[1]).to eq c1

    # associations
    expect(store.state.posts.values[0].comments).to eq [:c0, :c1]

    # edit comment
    action2 = EditComment.new(:c0, "Changed comment")
    store.dispatch(action2)

    # identity
    expect(store.state.comments.keys[0]).to eq c0.id

    # identity of post has not changed
    expect(store.state.posts.keys[0]).to eq p0.id

    # values
    expect(store.state.comments.values[0].body).to eq "Changed comment"

  end

end

