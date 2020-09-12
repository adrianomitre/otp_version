defmodule OtpVersionTest do
  use ExUnit.Case
  doctest OtpVersion

  test "otp_release/1" do
    assert OtpVersion.otp_version() == OtpVersion.otp_version(:major_only)

    Enum.each(
      [
        major_only: 1..1,
        otp_version_scheme: 2..6,
        semantic_versioning_scheme: 3..3
      ],
      fn {version_scheme, expected_components_range} ->
        result = OtpVersion.otp_version(version_scheme)
        assert is_binary(result)
        components = String.split(result, ".")
        assert length(components) in expected_components_range
      end
    )
  end
end
