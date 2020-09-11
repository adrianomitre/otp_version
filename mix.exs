defmodule OtpVersion.MixProject do
  use Mix.Project

  def project do
    [
      app: :otp_version,
      version: "0.1.0",
      elixir: "~> 1.0",
      start_permanent: Mix.env() == :prod,
      deps: []
    ]
  end
end
