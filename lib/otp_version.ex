defmodule OtpVersion do
  @moduledoc false

  @doc false
  defmacro system_otp_release do
    if Version.match?(System.build_info().version, ">= 1.3.0") do
      quote do
        System.otp_release()
      end
    else
      quote do
        :erlang.list_to_binary(:erlang.system_info(:otp_release))
      end
    end
  end

  @doc """
  Returns the Erlang/OTP release in the specified version scheme.
  If none is specified, defaults to major version only.
  """
  @spec otp_version(:major_only | :otp_version_scheme | :semantic_versioning_scheme) :: String.t()
  def otp_version(version_scheme \\ :major_only) do
    case version_scheme do
      :major_only ->
        system_otp_release()

      :otp_version_scheme ->
        get_otp_version()

      :semantic_versioning_scheme ->
        normalize_to_semantic_versioning_scheme(otp_version(:otp_version_scheme))
    end
  end

  # From https://github.com/hexpm/hex/blob/92f31922/lib/hex/utils.ex#L202
  @spec get_otp_version() :: String.t()
  defp get_otp_version do
    major = system_otp_release()
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

  # Based on https://github.com/mirego/elixir-boilerplate/blob/2e5170a2/lib/mix/tasks/erlang.check_version.ex#L42
  @spec normalize_to_semantic_versioning_scheme(String.t()) :: String.t()
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
