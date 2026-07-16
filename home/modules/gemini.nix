{...}: {
  sdgr-hm.programs.gemini.enable = true;

  programs.antigravity-cli.settings = {
    general.vimMode = true;
    context.fileFiltering.respectGitIgnore = false;
    ui.hideBanner = true;
    tools.shell.inactivityTimeout = 600;
    security.disableYoloMode = false;
    ui.footer.showLabels = false;
  };
}
