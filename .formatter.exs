[
  import_deps: [:ecto, :phoenix],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  plugin: [Pheonix.LiveView.HTMLFormatter],
  subdirectories: ["priv/*/migrations"]
]
