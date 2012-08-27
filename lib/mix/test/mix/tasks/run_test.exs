Code.require_file "../../../test_helper.exs", __FILE__

defmodule Mix.Tasks.RunTest do
  use MixTest.Case

  defmodule GetApp do
    def project do
      [
        app: :get_app,
        version: "0.1.0",
        deps: [
          { :git_repo, "0.1.0", git: MixTest.Case.fixture_path("git_repo") }
        ]
      ]
    end
  end

  defmodule NoSourceApp do
    def project do
      [ app: :nosource, version: "0.1.0", source_paths: [] ]
    end
  end

  test "run command with dependencies" do
    Mix.Project.push GetApp

    in_fixture "only_mixfile", fn ->
      Mix.Tasks.Deps.Get.run []
      Mix.Tasks.Run.run ["Mix.shell.info", "GitRepo.hello"]
      assert_received { :mix_shell, :info, ["World"] }
    end
  after
    purge [GitRepo, GitRepo.Mix]
    Mix.Project.pop
  end

  test "run command with file" do
    Mix.Project.push NoSourceApp

    in_fixture "no_mixfile", fn ->
      Mix.Tasks.Run.run ["-f", "lib/a.ex"]
      assert :code.is_loaded(A)
    end
  after
    purge [A]
    Mix.Project.pop
  end
end