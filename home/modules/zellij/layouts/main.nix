# Default layout: a focused shell, plus a Layouts tab whose picker transforms the
# session into any chosen layout. The session-manager is summoned on demand via
# the `Alt s` keybind rather than floating on top — keeping it focused on attach
# let the terminal's color-query replies leak into its new-session name field.
{
  node,
  plain,
  leaf,
  flag,
  barNode,
  bottomBarNode,
  bash,
  layoutPicker,
  ...
}: [
  (plain "layout" [
    (plain "default_tab_template" [barNode (flag "children") bottomBarNode])
    (node "tab" {
        name = "Shell";
        focus = true;
      } [
        (leaf "pane" {
          command = bash;
          focus = true;
        })
      ])
    (node "tab" {name = "Layouts";} [
      (leaf "pane" {command = layoutPicker;})
    ])
  ])
]
