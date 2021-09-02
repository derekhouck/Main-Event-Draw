defmodule MainEventDraw.MixProject do
  use Mix.Project

  def project do
    [
      app: :main_event_draw,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.12"}
    ]
  end

  defp escript do
    [main_module: MainEventDraw]
  end
end
