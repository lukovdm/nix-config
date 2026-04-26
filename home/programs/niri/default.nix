{ pkgs, lib, config, ... }:
let
  lock = "${lib.getExe pkgs.swaylock}";
in
{
  # Stylix theming is configured in system/modules/desktop-niri.nix
  # and auto-propagates to home-manager via the NixOS module integration.

  home.packages = with pkgs; [
    # Screenshots
    grim
    slurp

    # Clipboard
    wl-clipboard
    cliphist

    # Utilities
    brightnessctl
    playerctl
    pavucontrol
    networkmanagerapplet
    swaybg

    # File manager
    nautilus
  ];

  # Niri compositor config
  programs.niri.settings = {
    # Spawn at startup
    spawn-at-startup = [
      { command = [ "waybar" ]; }
      { command = [ "mako" ]; }
      { command = [ "nm-applet" "--indicator" ]; }
      { command = [ "${lib.getExe' pkgs.wl-clipboard "wl-paste"}" "--type" "text" "--watch" "${lib.getExe pkgs.cliphist}" "store" ]; }
      { command = [ "swayidle" "-w"
        "timeout" "300" "${lock} -f"
        "timeout" "600" "niri msg action power-off-monitors"
        "before-sleep" "${lock} -f"
      ]; }
    ];

    # Input config
    input = {
      keyboard.xkb = {
        layout = "us";
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = true; # disable while typing
      };
      mouse = {
        accel-speed = 0.0;
      };
    };

    # Layout
    layout = {
      gaps = 8;
      center-focused-column = "never";

      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];

      default-column-width = { proportion = 1.0 / 2.0; };

      focus-ring = {
        enable = false; # stylix uses border instead
      };
      border = {
        enable = true;
        width = 2;
        # Colors set by stylix
      };
    };

    # Keybindings
    binds = let
      spawn = cmd: { action.spawn = cmd; };
      sh = cmd: { action.spawn = [ "sh" "-c" cmd ]; };
    in {
      # App launchers
      "Mod+T" = spawn "foot";
      "Mod+D" = spawn "fuzzel";
      "Mod+E" = spawn "nautilus";
      "Super+Alt+L" = spawn lock;

      # Window management
      "Mod+Q".action.close-window = {};

      # Focus (vim-style + arrows)
      "Mod+H".action.focus-column-left = {};
      "Mod+L".action.focus-column-right = {};
      "Mod+K".action.focus-window-up = {};
      "Mod+J".action.focus-window-down = {};
      "Mod+Left".action.focus-column-left = {};
      "Mod+Right".action.focus-column-right = {};
      "Mod+Up".action.focus-window-up = {};
      "Mod+Down".action.focus-window-down = {};
      "Mod+Home".action.focus-column-first = {};
      "Mod+End".action.focus-column-last = {};

      # Move windows (vim-style + arrows)
      "Mod+Ctrl+H".action.move-column-left = {};
      "Mod+Ctrl+L".action.move-column-right = {};
      "Mod+Ctrl+K".action.move-window-up = {};
      "Mod+Ctrl+J".action.move-window-down = {};
      "Mod+Ctrl+Left".action.move-column-left = {};
      "Mod+Ctrl+Right".action.move-column-right = {};
      "Mod+Ctrl+Up".action.move-window-up = {};
      "Mod+Ctrl+Down".action.move-window-down = {};

      # Monitor focus
      "Mod+Shift+H".action.focus-monitor-left = {};
      "Mod+Shift+L".action.focus-monitor-right = {};
      "Mod+Shift+K".action.focus-monitor-up = {};
      "Mod+Shift+J".action.focus-monitor-down = {};
      "Mod+Shift+Left".action.focus-monitor-left = {};
      "Mod+Shift+Right".action.focus-monitor-right = {};
      "Mod+Shift+Up".action.focus-monitor-up = {};
      "Mod+Shift+Down".action.focus-monitor-down = {};

      # Move to monitor
      "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = {};
      "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = {};
      "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = {};
      "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = {};

      # Workspaces
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      # Move to workspace
      "Mod+Ctrl+1".action.move-column-to-workspace = 1;
      "Mod+Ctrl+2".action.move-column-to-workspace = 2;
      "Mod+Ctrl+3".action.move-column-to-workspace = 3;
      "Mod+Ctrl+4".action.move-column-to-workspace = 4;
      "Mod+Ctrl+5".action.move-column-to-workspace = 5;
      "Mod+Ctrl+6".action.move-column-to-workspace = 6;
      "Mod+Ctrl+7".action.move-column-to-workspace = 7;
      "Mod+Ctrl+8".action.move-column-to-workspace = 8;
      "Mod+Ctrl+9".action.move-column-to-workspace = 9;

      # Workspace scroll
      "Mod+Page_Down".action.focus-workspace-down = {};
      "Mod+Page_Up".action.focus-workspace-up = {};
      "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
      "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
      "Mod+WheelScrollDown" = { action.focus-workspace-down = {}; cooldown-ms = 150; };
      "Mod+WheelScrollUp" = { action.focus-workspace-up = {}; cooldown-ms = 150; };

      # Column sizing
      "Mod+R".action.switch-preset-column-width = {};
      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};
      "Mod+C".action.center-column = {};
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      # Column consume/expel
      "Mod+Comma".action.consume-window-into-column = {};
      "Mod+Period".action.expel-window-from-column = {};
      "Mod+BracketLeft".action.consume-or-expel-window-left = {};
      "Mod+BracketRight".action.consume-or-expel-window-right = {};

      # Floating / tabbed
      "Mod+V".action.toggle-window-floating = {};
      "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};
      "Mod+W".action.toggle-column-tabbed-display = {};

      # Overview
      "Mod+O".action.toggle-overview = {};

      # Screenshots (niri built-in)
      "Print".action.screenshot = {};
      "Ctrl+Print".action.screenshot-screen = {};
      "Alt+Print".action.screenshot-window = {};

      # Clipboard history
      "Mod+Shift+C" = sh "${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.fuzzel} -d | ${lib.getExe pkgs.cliphist} decode | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";

      # Power
      "Mod+Shift+P".action.power-off-monitors = {};
      "Mod+Shift+E".action.quit = {};
      "Ctrl+Alt+Delete".action.quit = {};

      # Hotkey overlay
      "Mod+Shift+Slash".action.show-hotkey-overlay = {};

      # Media keys
      "XF86AudioRaiseVolume" = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume" = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioMute" = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioMicMute" = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      "XF86MonBrightnessUp" = sh "brightnessctl set 5%+";
      "XF86MonBrightnessDown" = sh "brightnessctl set 5%-";
      "XF86AudioPlay" = sh "playerctl play-pause";
      "XF86AudioNext" = sh "playerctl next";
      "XF86AudioPrev" = sh "playerctl previous";
    };

    # Window rules
    window-rules = [
      {
        matches = [{ app-id = "firefox"; title = "Picture-in-Picture"; }];
        open-floating = true;
      }
      {
        matches = [{ app-id = "1password"; }];
        open-floating = true;
      }
      {
        matches = [{ app-id = "pavucontrol"; }];
        open-floating = true;
      }
    ];
  };

  # Terminal
  programs.foot = {
    enable = true;
    # Colors/fonts set by stylix
    settings = {
      main = {
        pad = "8x8";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  # App launcher
  programs.fuzzel = {
    enable = true;
    # Colors/fonts set by stylix
    settings = {
      main = {
        width = 50;
        lines = 10;
        terminal = "foot";
      };
    };
  };

  # Screen locker
  programs.swaylock = {
    enable = true;
    # Colors set by stylix
    settings = {
      show-keyboard-layout = true;
      show-failed-attempts = true;
    };
  };

  # Notification daemon
  services.mako = {
    enable = true;
    # Colors/fonts set by stylix
    settings = {
      default-timeout = 5000;
      max-visible = 3;
      anchor = "top-right";
      border-radius = 8;
      margin = "8";
      padding = "12";
    };
  };

  # Waybar
  programs.waybar = {
    enable = true;
    # Colors/fonts set by stylix
    settings = [{
      layer = "top";
      position = "left";
      width = 44;

      # left = top, center = center, right = bottom (in vertical mode)
      modules-left = [ "niri/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "idle_inhibitor" "pulseaudio" "network" "battery" "tray" ];

      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "";
          default = "";
        };
      };

      clock = {
        format = "{:%H\n%M}";
        format-alt = "{:%d\n%m}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon}";
        format-charging = "";
        format-plugged = "";
        format-icons = [ "" "" "" "" "" ];
        tooltip-format = "{capacity}% — {timeTo}";
      };

      network = {
        format-wifi = "";
        format-ethernet = "";
        format-disconnected = "";
        tooltip-format = "{essid} — {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format = "{icon}";
        format-muted = "";
        format-icons = {
          default = [ "" "" "" ];
        };
        tooltip-format = "{volume}%";
        on-click = "pavucontrol";
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };

      tray = {
        spacing = 4;
      };
    }];

    style = ''
      * {
        font-family: "FiraCode Nerd Font", "Font Awesome 6 Free";
        font-size: 14px;
        min-height: 0;
        min-width: 0;
      }

      window#waybar {
        background: alpha(@base00, 0.7);
        border-right: 2px solid alpha(@base02, 0.5);
      }

      #workspaces {
        padding: 4px 0;
      }

      #workspaces button {
        padding: 6px 0;
        min-width: 30px;
        min-height: 30px;
        border-radius: 0;
        border-left: 2px solid transparent;
      }

      #workspaces button.active {
        border-left: 2px solid @base0D;
        background: alpha(@base0D, 0.2);
      }

      #clock {
        padding: 8px 0;
        font-size: 12px;
      }

      #battery, #network, #pulseaudio, #tray, #idle_inhibitor {
        padding: 8px 0;
        font-size: 16px;
      }

      #battery.warning {
        color: @base0A;
      }

      #battery.critical {
        color: @base08;
      }

      tooltip {
        background: alpha(@base00, 0.9);
        border: 1px solid @base02;
        border-radius: 8px;
      }
    '';
  };
}
