{
  pkgs,
  lib,
  config,
  ...
}:

let
  colors = config.lib.stylix.colors;
  bg = "0xff${colors.base00}";
  surface = "0xff${colors.base01}";
  text = "0xff${colors.base05}";
  dim = "0xff${colors.base03}";
  accent = "0xff${colors.base0D}";
  red = "0xff${colors.base08}";
  yellow = "0xff${colors.base0A}";
  green = "0xff${colors.base0B}";
  cyan = "0xff${colors.base0C}";
  magenta = "0xff${colors.base0E}";
  font = "FiraCode Nerd Font";

  # sketchybar runs with a minimal PATH that lacks the nix-darwin profile.
  aerospace = "/run/current-system/sw/bin/aerospace";

  workspaces = [
    "1"
    "2"
    "3"
    "4"
    "5"
  ];

  # Nerd Font glyphs
  icons = {
    cpu = "";
    memory = "󰍛";
    clock = "";
    music = "";
    # Vertical battery glyphs indexed by charge / 10 (0 = empty, 10 = full)
    battery = [
      "󰂎"
      "󰁺"
      "󰁻"
      "󰁼"
      "󰁽"
      "󰁾"
      "󰁿"
      "󰂀"
      "󰂁"
      "󰂂"
      "󰁹"
    ];
    charging = [
      "󰢟"
      "󰢜"
      "󰂆"
      "󰂇"
      "󰂈"
      "󰢝"
      "󰂉"
      "󰢞"
      "󰂊"
      "󰂋"
      "󰂅"
    ];
  };

  glyph-array = lib.concatMapStringsSep " " (g: "'${g}'");

  aerospace-sh = pkgs.writeShellScript "sketchybar-aerospace" ''
    WS="$1"
    FOCUSED="''${FOCUSED_WORKSPACE:-$(${aerospace} list-workspaces --focused 2>/dev/null)}"
    FOCUSED="$(echo "$FOCUSED" | tr -d '[:space:]')"
    if [ "$FOCUSED" = "$WS" ]; then
      sketchybar --set "$NAME" background.drawing=on label.color=${bg}
    elif [ -n "$(${aerospace} list-windows --workspace "$WS" 2>/dev/null)" ]; then
      sketchybar --set "$NAME" background.drawing=off label.color=${text}
    else
      sketchybar --set "$NAME" background.drawing=off label.color=${dim}
    fi
  '';

  nowplaying-sh = pkgs.writeShellScript "sketchybar-nowplaying" ''
    TRACK=$(nowplaying-cli get title 2>/dev/null)
    if [ -z "$TRACK" ] || [ "$TRACK" = "null" ]; then
      sketchybar --set "$NAME" drawing=off
    else
      ARTIST=$(nowplaying-cli get artist 2>/dev/null)
      if [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ]; then
        sketchybar --set "$NAME" drawing=on label="$TRACK - $ARTIST"
      else
        sketchybar --set "$NAME" drawing=on label="$TRACK"
      fi
    fi
  '';

  battery-sh = pkgs.writeShellScript "sketchybar-battery" ''
    BATTERY=(${glyph-array icons.battery})
    CHARGING=(${glyph-array icons.charging})
    INFO=$(pmset -g batt)
    BATT=$(echo "$INFO" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
    [ -z "$BATT" ] && exit 0
    LEVEL=$(( (BATT + 5) / 10 ))
    if echo "$INFO" | grep -q 'AC Power'; then
      ICON="''${CHARGING[$LEVEL]}"
      COLOR=${green}
    else
      ICON="''${BATTERY[$LEVEL]}"
      if [ "$BATT" -ge 50 ]; then
        COLOR=${green}
      elif [ "$BATT" -ge 20 ]; then
        COLOR=${yellow}
      else
        COLOR=${red}
      fi
    fi
    sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="''${BATT}%"
  '';

  cpu-sh = pkgs.writeShellScript "sketchybar-cpu" ''
    CPU=$(top -l 2 -n 0 -s 1 | awk '/CPU usage/{v=$3+$5} END{printf "%.0f", v}')
    sketchybar --set "$NAME" label="''${CPU}%"
  '';

  memory-sh = pkgs.writeShellScript "sketchybar-memory" ''
    TOTAL=$(sysctl -n hw.memsize)
    MEM=$(vm_stat | awk -v total="$TOTAL" '
      /page size of/ { size = $8 }
      /Pages active/ { active = $3 }
      /Pages wired down/ { wired = $4 }
      /Pages occupied by compressor/ { comp = $5 }
      END { printf "%.0f", (active + wired + comp) * size / total * 100 }')
    sketchybar --set "$NAME" label="''${MEM}%"
  '';

  clock-sh = pkgs.writeShellScript "sketchybar-clock" ''
    sketchybar --set "$NAME" label="$(date +'%a %-d %b  %-H:%M')"
  '';

  workspace-items = lib.concatMapStrings (ws: ''
    sketchybar \
      --add item space.${ws} left \
      --set space.${ws} \
        label="${ws}" \
        label.color=${dim} \
        label.padding_left=10 \
        label.padding_right=10 \
        icon.drawing=off \
        padding_left=2 \
        padding_right=2 \
        background.color=${accent} \
        background.drawing=off \
        click_script="${aerospace} workspace ${ws}" \
        script="$PLUGIN_DIR/aerospace.sh ${ws}" \
      --subscribe space.${ws} aerospace_workspace_change front_app_switched space_windows_change
  '') workspaces;

  sketchybarrc = pkgs.writeShellScript "sketchybarrc" ''
    PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

    sketchybar \
      --bar \
        height=34 \
        position=top \
        sticky=on \
        padding_left=10 \
        padding_right=10 \
        color=${bg} \
        topmost=window

    sketchybar \
      --default \
        padding_left=4 \
        padding_right=4 \
        icon.font="${font}:Bold:15.0" \
        label.font="${font}:Medium:13.0" \
        icon.color=${text} \
        label.color=${text} \
        icon.padding_left=8 \
        icon.padding_right=4 \
        label.padding_left=4 \
        label.padding_right=8 \
        background.color=${surface} \
        background.corner_radius=6 \
        background.height=24

    # Custom events must be registered before items can subscribe to them.
    sketchybar --add event aerospace_workspace_change

    ${workspace-items}

    sketchybar \
      --add bracket spaces '/space\..*/' \
      --set spaces \
        background.color=${surface} \
        background.corner_radius=6 \
        background.height=26

    sketchybar \
      --add item cpu left \
      --set cpu \
        padding_left=10 \
        update_freq=5 \
        icon="${icons.cpu}" \
        icon.color=${cyan} \
        script="$PLUGIN_DIR/cpu.sh" \
      --add item memory left \
      --set memory \
        update_freq=10 \
        icon="${icons.memory}" \
        icon.color=${magenta} \
        script="$PLUGIN_DIR/memory.sh"

    sketchybar \
      --add item battery right \
      --set battery \
        update_freq=120 \
        script="$PLUGIN_DIR/battery.sh" \
      --subscribe battery power_source_change system_woke \
      --add item clock right \
      --set clock \
        update_freq=30 \
        icon="${icons.clock}" \
        icon.color=${accent} \
        script="$PLUGIN_DIR/clock.sh" \
      --add item nowplaying right\
      --set nowplaying \
        update_freq=5 \
        icon="${icons.music}" \
        icon.color=${yellow} \
        script="$PLUGIN_DIR/nowplaying.sh" \
        label.max_chars=45 \
        drawing=off

    sketchybar --update

    sketchybar --trigger aerospace_workspace_change \
      FOCUSED_WORKSPACE="$(${aerospace} list-workspaces --focused 2>/dev/null)"
  '';

in
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  xdg.configFile = {
    "sketchybar/sketchybarrc".source = sketchybarrc;
    "sketchybar/plugins/aerospace.sh".source = aerospace-sh;
    "sketchybar/plugins/nowplaying.sh".source = nowplaying-sh;
    "sketchybar/plugins/battery.sh".source = battery-sh;
    "sketchybar/plugins/cpu.sh".source = cpu-sh;
    "sketchybar/plugins/memory.sh".source = memory-sh;
    "sketchybar/plugins/clock.sh".source = clock-sh;
  };
}
