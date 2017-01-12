require 'rudux/combined'
require 'rudux/action'
require 'rudux/reducer'
require 'rudux/store'

describe 'Rudux' do

  it 'handles hash based state' do


    #
    # ACTIONS
    #

    class AddComment < Rudux::Action
      attr_reader :post_id, :body, :comment

      def initialize post_id, comment
        @post_id    = post_id
        @comment    = comment
      end

      def comment_id
        @comment[:id]
      end
    end

    class EditComment < Rudux::Action
      attr_reader :comment_id, :body

      def initialize comment_id, body
        @comment_id = comment_id
        @body = body
      end
    end


    #
    # REDUCERS
    #

    class PostsReducer < Rudux::Reducer
      def self.add_comment state, action
        posts = state.dup
        post = posts[action.post_id].dup
        post[:comments] = Array(post[:comments]) + [action.comment_id]
        posts[action.post_id] = post
        posts
      end
    end

    class CommentsReducer < Rudux::Reducer
      def self.edit_comment state, action
        dup = state.dup
        dup[action.comment_id] = {
          id: action.comment_id,
          body: action.body
        }
        dup
      end
    end

    class StateReducer < Rudux::Reducer
      def self.add_comment state, action
        h = Hash[action.comment_id, action.comment]
        {
          comments: state[:comments].merge(h)
        }
      end

      def self.base
        Rudux::Combined.new({
          posts:    PostsReducer,
          comments: CommentsReducer,
        })
      end
    end


    # prepare state
    p0 = { id: :p0, title: 'post zero' }
    p1 = { id: :p1, title: 'post one' }
    state = {
      posts: {
        p0: p0,
        p1: p1
      },
      comments: {}
    }
    store = Rudux::Store.new(StateReducer, state)


    expect(store.state).to eq({
      posts: {
        p0: {
          id:    :p0,
          title: 'post zero'
        },
        p1: {
          id:     :p1,
          title: 'post one'
        }
      },
      comments: {}
    })


    # ACTION: add comments
    c0 = { id: :c0, body: "comment zero" }
    c1 = { id: :c1, body: "comment one" }
    action0 = AddComment.new(:p0, c0)
    action1 = AddComment.new(:p1, c1)
    store.dispatch(action0)
    store.dispatch(action1)


    expect(store.state).to eq({
      posts: {
        p0: {
          id:    :p0,
          title: 'post zero',
          comments: [:c0]
        },
        p1: {
          id:     :p1,
          title: 'post one',
          comments: [:c1]
        }
      },
      comments: {
        c0: {
          id: :c0,
          body: 'comment zero'
        },
        c1: {
          id: :c1,
          body: 'comment one'
        },
      }
    })

    # ACTION: edit comment
    store.dispatch(EditComment.new(:c0, 'changed comment zero'))

    expect(store.state).to eq({
      posts: {
        p0: {
          id:       :p0,
          title:    'post zero',
          comments: [:c0]
        },
        p1: {
          id:       :p1,
          title:    'post one',
          comments: [:c1]
        }
      },
      comments: {
        c0: {
          id: :c0,
          body: 'changed comment zero'
        },
        c1: {
          id: :c1,
          body: 'comment one'
        },
      }
    })
  end

end

