defmodule OtpVersion.MixProject do
  use Mix.Project

  def project do
    [
      app: :otp_version,
      version: "0.1.0",
      elixir: "~> 1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp deps do
    if Version.match?(System.version(), ">= 1.6.0") do
      [
        {:dialyxir, "~> 1.0", only: [:dev, :test], optional: true, runtime: false},
        {:excoveralls, "~> 0.13", only: [:dev, :test], optional: true, runtime: false},
        {:credo, "~> 1.4", only: [:dev, :test], optional: true, runtime: false}
      ]
    end
  end
end
