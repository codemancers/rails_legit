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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
