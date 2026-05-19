{...}: {
  programs.sdgr-hm.gemini = {
    enable = true;
    enabledMcpServers = ["atlassian"];
    extraSettings = {
      general.vimMode = true;
      context.fileFiltering.respectGitIgnore = false;
      ui.hideBanner = true;
      #ui.errorVerbosity = "full";
      #ui.inlineThinkingMode = "full";
      tools.shell.inactivityTimeout = 600;
      security.disableYoloMode = false;
      ui.footer.showLabels = false;
      #experimental = {
      #  adk.agentSessionInteractiveEnabled = true;
      #  adk.agentSessionNoninteractiveEnabled = true;
      #  adk.agentSessionSubagentEnabled = true;
      #};
    };
  };
}
