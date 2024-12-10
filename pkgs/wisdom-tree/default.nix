{
  pkgs,
  fetchFromGitHub,
  ...
}: let
  pythonPackages = pkgs.python313Packages;
in
  pythonPackages.buildPythonApplication rec {
    pname = "wisdom-tree";
    version = "0.0.20";

    src = fetchFromGitHub {
      owner = "HACKER097";
      repo = "wisdom-tree";
      rev = "refs/tags/v${version}";
      hash = "sha256-PnOzQtiG1y7D4WTiUJMdvqEtdhnFVbJCIREWmuSbsIs=";
    };

    propagatedBuildInputs = with pythonPackages; [
      python-vlc
      pytube
    ];
  }