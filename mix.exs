defmodule OtpVersion.MixProject do
  use Mix.Project

  def project do
    [
      app: :otp_version,
      version: "0.1.0",
      elixir: "~> 1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    if Version.match?(System.version(), ">= 1.6.0") do
      [{:dialyxir, "~> 1.0"}]
    end
  end
end
