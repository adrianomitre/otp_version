# OTPVersion

OTPVersion is an Elixir library for obtaining Erlang/OTP version in full resolution and, optionally, in [Version](https://hexdocs.pm/elixir/Version.html)-compatible format.

## Installation

Add `otp_version` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:otp_version, "~> 0.1.0"}
  ]
end
```

## Usage

Assuming Erlang/OTP 21.3.8.17:
```elixir
iex(1)> System.otp_release()  
"21"
iex(2)> OTPVersion.otp_version()
"21.3.8.17"
iex(3)> OTPVersion.otp_version(:semantic_versioning_scheme)
"21.3.8"
```

Documentation and more examples can be found at https://hexdocs.pm/otp_version.
