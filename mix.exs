defmodule NervesQt5EngineBuild.MixProject do
  use Mix.Project

  def project do
    [
      app: :nerves_qt5_engine_build,
      version: "0.1.0",
      elixir: "~> 1.9",
      deps: deps(),
      nerves_package: [type: :engine_platform]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.5.4 or ~> 1.6.0", runtime: false}
    ]
  end
end
