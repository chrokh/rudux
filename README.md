# Rudux
Predictable Redux-like state management in OO Ruby.


# Installation

```bash
gem install rudux
```


# Usage

```ruby
require 'rudux/entity'

class State < Rudux::Entity
  attr_reader :number
  def speak
    "The number is #{@number}"
  end
end


require 'rudux/action'

class Multiply < Rudux::Action
  attr_reader :factor
  def initialize factor
    @factor = factor
  end
end


require 'rudux/reducer'

class Reducer < Rudux::Reducer
  def multiply state, action
    {
      number: state.number * action.factor
    }
  end
end


require 'rudux/store'
state = Rudux::State.new(number: 1)
store = Rudux::Store.new(state)
store.state.number # => 1
store.state.speak  # => The number is 1
action = Multiply.new(10)
store.dispatch(action)
store.state.number # => 10
store.state.speak  # => The number is 10
```

TODO: Add a more complex example that makes use of selectors.


**Store**

TODO


**Entities**

Entities are here what state POJOs are in redux. Entities are similar to what is commonly called [Value Objects](http://martinfowler.com/bliki/ValueObject.html). Think of them as entities in a relational database.
In a blogging system, the entities might be: Post, Comment, Author etc.
By Rails analogy, if it's an ActiveRecord model, then it's likely an Entity.
By MVC analogy, not all models are entities but all entities are models. In other words, anything that you would want to save into the state database is an entity. Entities should be serializable and deserializable.


**Actions**

TODO


**Reducers**

TODO


# Rationale

I'm loosing faith in object-oriented programming. I wrote this Redux-like state management library to make use of objects because I'm curious how systems built on an immutable object-oriented architecture will cope over time.


# License

The MIT License (MIT)
Copyright (c) 2016 Christopher Okhravi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

