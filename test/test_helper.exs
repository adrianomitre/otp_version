if System.get_env("CI") do
  Code.compiler_options(warnings_as_errors: true)
end
ExUnit.start()
