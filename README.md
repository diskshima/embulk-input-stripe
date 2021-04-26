# embulk-input-stripe

[Embulk](https://www.embulk.org/) input plugin for Stripe.

## Overview

- **Plugin type**: input
- **Resume supported**: no
- **Cleanup supported**: no
- **Guess supported**: no

## Configuration

- **api_key**: Stripe API key
- **resource_type**: Stripe object to retrieve. Currently supports `customers`, `invoices`, `subscriptions` .
- **fields**: Fields to retrieve from Stripe. Each field should contain the below elements.
    - name: Name of the ID.
    - type: Type of the field.

### Example Config

```yaml
in:
  type: stripe
  api_key: STRIPE_SECRET_API_KEY
  resource_type: customers
  fields:
    - { name: id, type: string }
    - { name: created, type: timestamp }
    - { name: email, type: string }
    - { name: name, type: string }

out:
  type: stdout
```

Please see the [`sample_configs`](./sample_configs) directory for more examples.


## Building the gem

```
bundle exec rake
```

The gem will be generated under `pkg/`.
