if Version.match?(System.build_info().version, ">= 1.6.0") do
  defmodule OTPVersionProperyTest do
    use ExUnit.Case
    use ExUnitProperties

    import OTPVersion, only: [normalize_to_semantic_versioning_scheme: 1]

    property "normalize_to_semantic_versioning_scheme result is compatible with Version" do
      check all(list <- list_of(integer() |> map(&abs(&1)), min_length: 1)) do
        unnormalized = Enum.join(list, ".")
        normalized = normalize_to_semantic_versioning_scheme(unnormalized)
        assert {:ok, _version} = Version.parse(normalized)
      end
    end
  end
end
