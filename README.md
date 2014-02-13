# Rails::Legit

It is quite common to perform checks like:

* Check if an array is a subset of another array
* A date supplied by the user does not be in the past
* An event start date will always fall after the event end date

and so on...

This gem abstracts out this common logic and lets you do things like:

    validates :start_date, verify_date: { before: Date.current }

or

    validates :end_date, verify_date: { before: :current}

As of now, only `Date` and `DateTime` validators are implemented.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_legit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_legit

## Usage

The gem uses Rails' `ActiveModel::Validator` to perform these checks.


### Date Validator

Say we are building an event management application where the management
can create events where they can specify the start times and the end times
of the event. `EventForm` is such a class that is a non-persistent model of
the event record.

```ruby
class Event < ActiveRecord::Base
  # has the following attributes:
  # name
  # description
  # to
  # from
end
```

The `to` and `from` are DateTime objects that get stored in the DB. And the
corresponding ActiveModel form: (assuming Rails 4)

```ruby
class EventForm 
  include ActiveModel::Model
  attr_accessor :name, :description, :to, :from
  attr_accessor :to_date, :to_time
  attr_accessor :from_date, :from_time
end
```

The `:to_date`, `:to_time`, `:from_date`, `:from_time` are the attributes
for the data that is returned from the UI where there are separate inputs
for start date, end date, start time and end time.

To use the `DateValidator`, include the `RailsLegit` module in the
`EventForm` class:

```ruby
class EventForm
  # unchanged from above
  include RailsLegit
end
```

Adding validations is as simple as:

```ruby
class EventForm
  # unchanged from above
  validates :from_date, :to_date, date: true
end
```

Currently supported validation syntax elements are:

    verify_date: true

This will check if the date returned from the input fields in the UI is
valid or not.

    verify_date: { before: Date.current }
    # same as:
    verify_date: { before: :current }

The valid options are `:before`, `:after`, `:on_or_before`, `:on_or_after`, `:on`.

You can pass in a method as a symbol, string or a `Date` object. By default, all symbols except
`:current`, `:today`, `:now` are sent to the object under validation.

```ruby
validates :from_date, date: { greater_than: :current } # Date.current is used
validates :from_date, date: { greater_than: :today   } # Date.current is used 
validates :from_date, date: { greater_than: :now     } # Date.current is used

validates :from_date, date: { greater_than: :end_date } # <EventForm Object>.end_date is used
```

Finally,

```ruby
class EventForm
  attr_accessor :to_date, :from_date
  include ActiveModel::Model
  include RailsLegit
  validates :from_date, date: { greater_than: :today }
  validates :to_date, date: { greater_than: :from_date }
end
```

### Array Validator

It is quite common to check whether an array of attributes is a subset
of another array -- a list of valid IDs, for example. The `VerifyArray`
validator handles the three cases of `:in`, :not_in` and `:eq`. The
abstract functionality is as follows:

    # The simplest case would be to verify if a record attribute is an
    # Array
    validates [1, 2], verify_array: true                    # => true

    # Or, you could specify options. Supported options are :in, :not_in,
    # :eq

    validates [1, 2, 3], verify_array: { in: [1, 2, 3, 4] } # => true
    # Note: The :in and :not_in validators are not strict. That is, the
    # following will work as expected. This is similar to :eq in this
    # case
    validates [1, 2, 3], verify_array: { in: [1, 2, 3] }    # => true
    validates [1, 2, 3], verify_array: { in: [1, 2] }       # => false

    # The ordering is not a factor
    validates [3, 2, 1], verify_array: { in: [1, 2, 3, 4] } # => true

    validates [1, 2], verify_array: { not_in: [4, 5] }      # => true
    validates [1, 2], verify_array: { not_in: [1, 5] }      # => true

    # :eq is a strict validator which will result true only if the given
    # array contains the exact same elements (irrespective of order)
    # compared to the verification array.

    validates [1, 2], verify_array: { eq: [2, 1] }          # => true
    validates [1, 2], verify_array: { eq: [3, 1] }          # => false

Use this in validating your models like so:

    # Specify a Symbol which is a method defined on the model
    class EventInvitees < ActiveRecord::Base
      validates :invited_users, verify_array: { in: :valid_users_in_db }

      def valid_users_in_db
        User.all.pluck(:id).map(&:to_s)
      end
    end

    # or, specify an Array
    class EventInvitees < ActiveRecord::Base
      validates :invited_users, verify_array: { in: [1, 25, 155] }
    end

    # or, specify a Proc that returns an array
    class EventInvitees < ActiveRecord::Base
      validates :invited_users, verify_array: { in: ->{ [1, 25, 155] } }
    end


The only caveat here is that the verification item (symbol/proc) should
return an Array.

### Hash Validator

To validate a hash, you can do like so:

    # some_hash = { one: 1, two: 2, three: 3 }
    validates some_hash, verify_hash: { keys: [:one, :two, :three] } # => true
    validates some_hash, verify_hash: { values: [1, 2, 3] }          # => true

The valid options are `:keys` and `:values`. You can pass in an Array or
a Proc that evaluates to an array or a method that is defined inside the
class.

    # You can use an Array as the option's value

    class Skill < ActiveRecord::Base
      validates :item, verify_hash: { keys: ['gardening', 'carpentry'] }
    end

    # You can use a Proc

    class Skill < ActiveRecord::Base
      validates :item, verify_hash: { keys: -> { ['gardening', 'carpentry'] } }
    end

    # Or, you can use a Symbol if a method with that name is defined

    class Skill < ActiveRecord::Base
      validates :item, verify_hash: { keys: :accepted_skill_names }

      # The method can be private or a visible one
      private

      def accepted_skill_names
        ['gardening', 'carpentry']
      end
    end

The keys or values are checked for existence and not for equality. In
other words even if the hash in the first example in Hash section was `{
one: 1, two: 2 }`, it would still validate to true. To add to that, the
ordering is not significant.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
