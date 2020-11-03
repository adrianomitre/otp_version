defmodule OTPVersionTest do
  use ExUnit.Case

  doctest OTPVersion

  require OTPVersion

  import OTPVersion,
    only: [
      otp_version: 0,
      otp_version: 1,
      otp_version_file: 1,
      split_components: 1,
      system_otp_release: 0
    ]

  defmacrop file_rename(source, destination) do
    if Version.match?(System.build_info().version, ">= 1.1.0") do
      quote do
        File.rename(unquote(source), unquote(destination))
      end
    else
      quote do
        :file.rename(unquote(source), unquote(destination))
      end
    end
  end

  test "otp_release/1" do
    assert_properties()
    otp_version_file = otp_version_file(system_otp_release())
    temp_file = derive_temp_file(otp_version_file)

    try do
      :ok = file_rename(otp_version_file, temp_file)
      assert_properties()
    after
      :ok = file_rename(temp_file, otp_version_file)
    end
  end

  def assert_properties do
    if Version.match?(System.build_info().version, ">= 1.3.0") do
      assert system_otp_release() == otp_version(:major_only)
    end

    assert otp_version() == otp_version(:otp_version_scheme)
    assert {:ok, _version} = Version.parse(otp_version(:semantic_versioning_scheme))

    components_by_scheme =
      Enum.map(
        [
          major_only: 1..1,
          otp_version_scheme: 1..6,
          semantic_versioning_scheme: 3..3
        ],
        fn {version_scheme, expected_components_range} ->
          result = otp_version(version_scheme)
          assert is_binary(result)
          assert String.starts_with?(result, otp_version(:major_only))
          components = split_components(result)
          assert length(components) in expected_components_range
          {version_scheme, components}
        end
      )
      |> Enum.into(Map.new())

    non_trivial_keys =
      Map.keys(components_by_scheme)
      |> Enum.reject(fn version_scheme -> version_scheme == :major_only end)

    minimum_count =
      non_trivial_keys
      |> Enum.map(fn version_scheme -> Enum.count(components_by_scheme[version_scheme]) end)
      |> Enum.min()

    Enum.each(0..(minimum_count - 1), fn index ->
      unique_components =
        non_trivial_keys
        |> Enum.map(fn k -> Enum.at(components_by_scheme[k], index) end)
        |> Enum.uniq()

      assert Enum.count(unique_components) == 1
    end)
  end

  defp derive_temp_file(original_file) when is_binary(original_file) do
    tentative = original_file <> random_string(4)

    if File.exists?(tentative) do
      derive_temp_file(original_file)
    else
      tentative
    end
  end

  defp random_string(length) do
    # From https://stackoverflow.com/a/32002566
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
