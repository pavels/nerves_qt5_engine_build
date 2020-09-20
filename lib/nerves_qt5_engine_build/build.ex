defmodule NervesQt5EngineBuild.Build do
  use Nerves.Package.Platform
  alias Nerves.Artifact
  import Mix.Nerves.Utils

  @doc """
  Called as the last step of bootstrapping the Nerves env.
  """
  def bootstrap(_) do
  end

  @doc """
  Build the artifact
  """
  def build(pkg, toolchain, opts) do
    {_, type} = :os.type()
    make(type, pkg, toolchain, opts)
  end

  @doc """
  Return the location in the build path to where the global artifact is linked.
  """
  def build_path_link(pkg) do
    Artifact.build_path(pkg)
  end

  @doc """
  Clean up all the build files
  """
  def clean(pkg) do
    _ = Artifact.Cache.delete(pkg)

    Artifact.build_path(pkg)
    |> File.rm_rf()
  end

  @doc """
  Create an archive of the artifact
  """
  def archive(pkg, toolchain, opts) do
    {_, type} = :os.type()
    make_archive(type, pkg, toolchain, opts)
  end

  defp make(:linux, pkg, _toolchain, _opts) do
    System.delete_env("BINDIR")
    dest = Artifact.build_path(pkg)

    {:ok, pid} = Nerves.Utils.Stream.start_link(file: "build.log")
    stream = IO.stream(pid, :line)

    case shell("make", ["artifact", "NERVES_BUILD_CONFIG=#{defconfig(pkg)}", "NERVES_BUILD_DIR=#{dest}"], cd: makepath(), stream: stream) do
      {_, 0} -> {:ok, dest}
      {_error, _} -> {:error, Nerves.Utils.Stream.history(pid)}
    end
  end

  defp make(type, _pkg, _toolchain, _opts) do
    error_host_os(type)
  end

  defp make_archive(:linux, pkg, _toolchain, _opts) do
    name = Artifact.download_name(pkg)
    dest = Artifact.build_path(pkg)

    {:ok, pid} = Nerves.Utils.Stream.start_link(file: "archive.log")
    stream = IO.stream(pid, :line)

    case shell("make", ["archive", "NERVES_BUILD_CONFIG=#{defconfig(pkg)}", "NERVES_BUILD_DIR=#{dest}", "NERVES_ARCHIVE_NAME=#{name}"], cd: makepath(), stream: stream) do
      {_, 0} -> {:ok, Path.join(dest, name <> Artifact.ext(pkg))}
      {_error, _} -> {:error, Nerves.Utils.Stream.history(pid)}
    end
  end

  defp make_archive(type, _pkg, _toolchain, _opts) do
    error_host_os(type)
  end

  defp error_host_os(type) do
    {:error,
     """
     Local build_runner is not available for host system: #{type}
     Please use the Docker build_runner to build this package artifact
     """}
  end

  defp makepath() do
    Nerves.Env.package(:nerves_qt5_engine_build).path
  end

  defp defconfig(pkg) do
    platform_config = pkg.config[:platform_config][:defconfig]
    Path.join("#{pkg.path}", platform_config)
  end
end
