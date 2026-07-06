# Runtime agents-first layout: paned auto-creates the agents tab when it sees
# the IDE marker tab, then moves that tab to the front best-effort.
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
    (plain "default_tab_template" [barNode (flag "children") bottomBarNode])

    (swap "single_open" "20%")
    (swap "single_closed" "1")

    (node "tab" {name = ">";} [
      (leaf "pane" {command = bash;})
    ])
    (node "tab" {
        name = "IDE";
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
  ])
]
