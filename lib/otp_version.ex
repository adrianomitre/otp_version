defmodule OtpVersion do
  @doc """
  Returns the Erlang/OTP release in the specified version scheme.
  If none is specified, defaults to major version only.
  """
  @spec otp_version(:major_only | :otp_version_scheme | :semantic_versioning_scheme) :: String.t()
  def otp_version(version_scheme \\ :major_only) do
    case version_scheme do
      :major_only ->
        :erlang.list_to_binary(:erlang.system_info(:otp_release))

      :otp_version_scheme ->
        get_otp_version()

      :semantic_versioning_scheme ->
        normalize_to_semantic_versioning_scheme(otp_version(:otp_version_scheme))
    end
  end

  # From https://github.com/hexpm/hex/blob/92f31922/lib/hex/utils.ex#L202
  defp get_otp_version do
    major = :erlang.system_info(:otp_release) |> List.to_string()
    vsn_file = Path.join([:code.root_dir(), "releases", major, "OTP_VERSION"])

    try do
      {:ok, contents} = File.read(vsn_file)
      String.split(contents, "\n", trim: true)
    else
      [full] -> full
      _ -> major
    catch
      :error, _ -> major
    end
  end

  @spec trim(String.t()) :: String.t()
  defmacrop trim(string) do
    if Version.match?(System.build_info().version, ">= 1.3.0") do
      quote do
        String.trim(unquote(string))
      end
    else
      quote do
        String.strip(unquote(string))
      end
    end
  end

  # From https://github.com/mirego/elixir-boilerplate/blob/2e5170a2/lib/mix/tasks/erlang.check_version.ex#L42
  defp normalize_to_semantic_versioning_scheme(version) do
    version
    |> trim()
    |> String.split(".")
    |> case do
      [major] -> "#{major}.0.0"
      [major, minor] -> "#{major}.#{minor}.0"
      [major, minor, patch | _] -> "#{major}.#{minor}.#{patch}"
    end
  end
end
