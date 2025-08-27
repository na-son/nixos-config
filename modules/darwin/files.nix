{
  user,
  config,
  pkgs,
  ...
}:

let
  #xdg_configHome = "${config.users.users.${user.name}.home}/.config";
  #xdg_stateHome = "${config.users.users.${user.name}.home}/.local/state";
  xdg_dataHome = "${config.users.users.${user.name}.home}/.local/share";
in
{
  # tfenv is picky about ggrep being present on osx
  "${xdg_dataHome}/bin/ggrep" = {
    source = "${pkgs.gnugrep}/bin/grep";
    executable = true;
  };
}
