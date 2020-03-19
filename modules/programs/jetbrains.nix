{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.jetbrains;
  pluginPath = "config/jba_config/installed_plugins.txt";
in

  {
  ###### interface
  options = {
    programs.jetbrains = {
      enable = mkEnableOption "JetBrains";

      username = mkOption {
        type = types.str;
        description = "The username of the JetBrains account to use.";
        default = "";
        example = "evanjs";
      };

      plugins = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExample [
          "com.chrisrm.idea.MaterialThemeUI"
          "ms.konovalov.intellij.hidpi-profiles"
          "nix-idea"
          "org.asciidoctor.intellij.asciidoc"
          "org.intellij.plugins.markdown"
          "org.rust.lang"
          "org.toml.lang"
        ];
        description = ''
          List of plugins to install.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {

    home.file = mkMerge (
      [{
        ".CLion2019.1/${pluginPath}" = mkIf (cfg.plugins != []) (
          {
            #text = "${toString (strings.intersperse "\n" cfg.plugins)}";
            text = "${strings.replaceStrings [ " " ] [ "" ] (builtins.toString (lib.strings.intersperse "\n" cfg.plugins))}";
          }
          );
        }]
        );
      };
    }
