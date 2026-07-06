# De-templated from Yazelix yzx_side.kdl + yzx_side.swap.kdl. zbar top bar +
# yazi sidebar; the swap variants give the auto open/closed sidebar arrangement
# that the pane manager toggles between.
{
  node,
  plain,
  leaf,
  flag,
  barNode,
  bottomBarNode,
  yaziSidebar,
  bash,
  ...
}: let
  # `command` here is a child node (string argument), matching the upstream
  # Yazelix sidebar layout, so the per-pane yazi wrapper is launched.
  sidebar = size:
    node "pane" {
      name = "sidebar";
      inherit size;
    } [
      (leaf "command" yaziSidebar)
    ];

  stackedChildren = node "pane" {stacked = true;} [(flag "children")];

  swap = name: sidebarSize:
    node "swap_tiled_layout" {inherit name;} [
      (node "tab" {min_panes = 2;} [
        barNode
        (node "pane" {split_direction = "vertical";} [
          (sidebar sidebarSize)
          stackedChildren
        ])
        bottomBarNode
      ])
    ];
in [
  (plain "layout" [
    # No sidebar in the template: it would land on every tab. The sidebar lives
    # in the Project tab explicitly, and the swap layouts (sidebar + stacked
    # children, with the bar) match its structure so the pane manager can swap
    # cleanly between them to toggle/hide the sidebar.
    (plain "default_tab_template" [barNode (flag "children") bottomBarNode])

    (swap "single_open" "20%")
    (swap "single_closed" "1")

    (node "tab" {
        name = "Project";
        focus = true;
      } [
        (node "pane" {split_direction = "vertical";} [
          (sidebar "20%")
          (node "pane" {stacked = true;} [
            (leaf "pane" {
              command = "nvim";
              name = "editor";
            })
          ])
        ])
      ])
    (node "tab" {name = "Shell";} [
      (leaf "pane" {command = bash;})
    ])
  ])
]
