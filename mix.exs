defmodule OTPVersion.MixProject do
  use Mix.Project
  @version "0.1.1"
  @repo_url "https://github.com/adrianomitre/otp_version"

  def project do
    [
      app: :otp_version,
      version: @version,
      elixir: "~> 1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Docs
      name: "OTPVersion",
      docs: [
        source_ref: "v#{@version}",
        main: "OTPVersion",
        source_url: @repo_url
      ],

      # Hex
      description:
        "Elixir library for obtaining Erlang/OTP version in full resolution (thus " <>
          "beyond System.otp_release/0) and, optionally, in Version-compatible format.",
      package: [
        maintainers: ["Adriano Mitre"],
        licenses: ["Apache 2.0"],
        links: %{"GitHub" => @repo_url}
      ]
    ]
  end

  defp deps do
    if Version.match?(System.version(), ">= 1.6.0") do
      [
        {:stream_data, "~> 0.5", only: [:dev, :test], runtime: true},
        {:dialyxir, "~> 1.0", only: [:dev, :test], optional: true, runtime: false},
        {:excoveralls, "~> 0.13", only: [:dev, :test], optional: true, runtime: false},
        {:credo, "~> 1.4", only: [:dev, :test], optional: true, runtime: false},
        {:ex_doc, "~> 0.22", only: [:dev, :test], optional: true, runtime: false},
        {:sobelow, "~> 0.10", only: [:dev, :test]}
      ]
    else
      []
    end
  end
end
