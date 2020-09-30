[![Actions Status](https://github.com/adrianomitre/otp_version/workflows/Elixir%20CI/badge.svg)](https://github.com/adrianomitre/otp_version/actions) [![codecov](https://codecov.io/gh/adrianomitre/otp_version/branch/master/graph/badge.svg?precision=2)](https://codecov.io/gh/adrianomitre/otp_version)

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
