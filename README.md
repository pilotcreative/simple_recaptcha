# Simple Recaptcha

Ruby library for [reCAPTCHA](http://www.google.com/recaptcha)

## Usage

```ruby
require "simple_recaptcha"

recaptcha = SimpleRecaptcha::Client.new
recaptcha.verify(:private_key => "your-private-key", :ip => "127.0.0.1", :challenge => "challengestring", :response => "user input")
```

All 4 attributes must be specified: `:private_key`, `:ip`, `:challenge`, `:response`

### Configuration

You can configure Simple Recaptcha in two different ways:

```ruby
SimpleRecaptcha.private_key = "your-private-key"

SimpleRecaptcha.configure do |confg|
  config.private_key = "your-private-key"
  config.public_key = "your-public-key"
end
```

You can set `public_key` for consistency, however it is not used during verification

## Copyright

Copyright © 2011 Wojciech Wnętrzak. See LICENSE for details.
