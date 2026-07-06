# Task management / todos: Neovim on a markdown todo file with a small shell
# pane underneath for quick commands.
{
  node,
  plain,
  leaf,
  flag,
  barNode,
  bottomBarNode,
  bash,
  homeDir,
  ...
}: [
  (plain "layout" [
    (plain "default_tab_template" [barNode (flag "children") bottomBarNode])
    (node "tab" {
        name = "Org";
        focus = true;
      } [
        (node "pane" {command = "nvim";} [
          (leaf "args" "${homeDir}/org/todo.md")
        ])
        (leaf "pane" {
          command = bash;
          size = "25%";
        })
      ])
  ])
]
