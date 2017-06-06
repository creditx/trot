defmodule Trot.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.strip

  def project do
    [app: :trot,
     version: @version,
     elixir: "~> 1.2",
     deps: deps(),
     name: "Trot",
     docs: [readme: "README.md", main: "README",
            source_ref: "v#{@version}",
            source_url: "https://github.com/creditx/trot"],

     # Hex
     description: description(),
     package: package()]
  end

  def application do
    [applications: [:logger, :plug, :cowboy, :plug_heartbeat],
     mod: {Trot, []}]
  end

  defp deps do
    [
      {:plug, "~> 1.3"},
      {:cowboy, "~> 1.1"},
      {:poison, "~> 3.1"},
      {:calliope, "~> 0.4.0"},
      {:plug_heartbeat, "~> 0.2"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.7", only: :dev},
      {:inch_ex, only: :docs},
      {:credo, "~> 0.8", only: [:dev, :test]},
    ]
  end

  defp description do
    """
    A web micro-framework based on Plug and Cowboy.
    """
  end

  defp package do
    [maintainers: ["William Huba"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/hexedpackets/trot"},
     files: ~w(mix.exs README.md LICENSE lib VERSION)]
  end
end
