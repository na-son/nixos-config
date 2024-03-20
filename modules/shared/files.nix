{ pkgs, config, ... }:

{
  ".tfenv".source = pkgs.fetchFromGitHub {
    owner = "tfutils";
    repo = "tfenv";
    rev = "39d8c27";
    sha256 = "h5ZHT4u7oAdwuWpUrL35G8bIAMasx6E81h15lTJSHhQ=";
  };

}
