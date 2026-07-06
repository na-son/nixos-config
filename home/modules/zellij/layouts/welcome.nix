# Welcome screen: a plain shell tab, under the
# shared status bar used by the other layouts.
{
  node,
  plain,
  leaf,
  flag,
  barNode,
  bottomBarNode,
  bash,
  ...
}: [
  (plain "layout" [
    (plain "default_tab_template" [barNode (flag "children") bottomBarNode])
    (node "tab" {
        name = "Shell";
        focus = true;
      } [
        (leaf "pane" {command = bash;})
      ])
  ])
]
