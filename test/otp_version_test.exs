defmodule OtpVersionTest do
  use ExUnit.Case
  doctest OtpVersion
  require OtpVersion

  import OtpVersion,
    only: [otp_version: 0, otp_version: 1, system_otp_release: 0]

  test "otp_release/1" do
    if Version.match?(System.build_info().version, ">= 1.3.0") do
      assert system_otp_release() == otp_version(:major_only)
    end

    assert otp_version() == otp_version(:major_only)
    assert {:ok, version} = Version.parse(otp_version(:semantic_versioning_scheme))

    Enum.each(
      [
        major_only: 1..1,
        otp_version_scheme: 1..6,
        semantic_versioning_scheme: 3..3
      ],
      fn {version_scheme, expected_components_range} ->
        result = otp_version(version_scheme)
        assert is_binary(result)
        components = String.split(result, ".")
        assert length(components) in expected_components_range
      end
    )
  end
end
