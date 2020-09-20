defmodule Mix.Tasks.Compile.NervesQt5Build do

  def run(_args) do
    config = Mix.Project.config()
    runtime_package = nerves_qt5_engine()

    toolchain_path = Nerves.Env.toolchain_path()
    sysroot_path = Nerves.Env.system_path() |> Path.join("staging")
    package_path = Nerves.Artifact.dir(runtime_package)
    engine_path = package_path |> Path.join("qt5-engine")
    host_tools_path_bin = package_path |> Path.join("qt5-host-tools") |> Path.join("bin")

    qmake = host_tools_path_bin |> Path.join("qmake")

    src = Path.join(".","src") |> Path.expand(File.cwd!())
    cwd = Mix.Project.app_path(config) |> Path.join("obj")

    File.mkdir_p(cwd)

    env = %{
      "NERVES_TOOLCHAIN_DIR" => toolchain_path,
      "NERVES_SYSROOT_DIR" => sysroot_path,
      "QT5_ENGINE_DIR" => engine_path,
      "INSTALL_ROOT" => Mix.Project.app_path(config),
    }

    qt_conf = "[Paths]\n" <>
              "Prefix=#{engine_path |> Path.join("qt5")}\n" <>
              "HostPrefix=#{package_path |> Path.join("qt5-host-tools")}\n" <>
              "Sysroot=#{sysroot_path}\n"

    qt_conf_file = Path.join(cwd, "qt.conf")
    File.write! qt_conf_file, qt_conf

    Mix.shell().info("QT5 qmake step in: #{cwd}")
    cmd(qmake,[src, "-qtconf", qt_conf_file,  "QMAKE_CFLAGS_ISYSTEM="],cwd,env)
    cmd("make",[],cwd,env)
    cmd("make",["install"],cwd,env)

    :ok
  end

  defp nerves_qt5_engine do
    nerves_qt5_engine =
      Nerves.Env.packages_by_type(:nerves_qt5_engine)
      |> List.first()

      nerves_qt5_engine
  end

  defp cmd(exec, args, cwd, env) do
    opts = [
      into: IO.stream(:stdio, :line),
      stderr_to_stdout: true,
      cd: cwd,
      env: env
    ]

    {%IO.Stream{}, status} = System.cmd(find_executable(exec), args, opts)
    status
  end

  defp find_executable(exec) do
    System.find_executable(exec) ||
      Mix.raise("""
      "#{exec}" not found in the path. If you have set the MAKE environment variable,
      please make sure it is correct.
      """)
  end

end
