{ self, ... }:
{
  flake.nixosModules = {
    default = self.nixosModules.seadexarr;
    seadexarr =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.services.seadexarr;

        seadexarrOpts =
          with lib;
          { name, ... }:
          {
            options = {
              enable = mkEnableOption "SeaDexArr instance";

              name = mkOption {
                type = types.str;
                default = name;
                description = ''
                  Name is used as a suffix for the service name. By default it
                  takes the value you used for `<instance>` in:
                  {option}`services.seadexarr.<instance>`
                '';
              };

              package = mkPackageOption pkgs "seadexarr" { };

              settings = mkOption {
                type = with types; nullOr attrs;
                default = null;
                example = {
                  sonarr_url = "http://localhost:8989";
                  radarr_url = "http://localhost:7878";
                };
                description = ''
                  Settings file written to
                  {file}`/var/lib/seadexarr-<instance>/config.yaml`. For
                  available configuration options, see
                  https://github.com/bbtufty/seadexarr?tab=readme-ov-file#config.
                  This file should NOT be used to store secrets. Use
                  {option}`services.seadexarr.<instance>.settingsFile` instead.
                  This option and `settingsFile` will be merged, with options
                  from `settingsFile` taking precedence.
                '';
              };

              settingsFile = mkOption {
                type = with types; nullOr path;
                default = null;
                example = "/run/secrets/seadexarr.yaml";
                description = ''
                  Path to a YAML file containing settings that will be merged
                  with the `settings` option. This is suitable for storing
                  secrets, as they will not be exposed in the Nix store.
                '';
              };

              scheduleTime = mkOption {
                type = types.int;
                default = 6;
                example = 24;
                description = "How often to run, in hours";
              };
            };
          };
      in
      {
        options.services.seadexarr =
          with lib;
          mkOption {
            default = { };
            type = with types; attrsOf (submodule seadexarrOpts);
            description = ''
              Defines multiple SeaDexArr instances. If you don't require
              multiple instances of SeaDexArr, you can define just one.
            '';
            example = ''
              {
                main = {
                  enable = true;
                  settings = { ... };
                  settingsFile = "/run/secrets/seadexarr-main.json";
                };
                secondary = {
                  enable = true;
                  settings = { ... };
                  settingsFile = "/run/secrets/seadexarr-secondary.json";
                };
              }
            '';
          };

        config =
          let
            mkInstanceServiceConfig =
              instance:
              let
                stateDir = "seadexarr-${instance.name}";
                statePath = "/var/lib/${stateDir}";

                yamlConfigFile = pkgs.writers.writeYAML "config.yaml" instance.settings;

                generateConfigScript = ''
                  #!/usr/bin/env bash

                  ${pkgs.yq-go}/bin/yq \
                    eval-all \
                    '. as $item ireduce ({}; . *+ $item)' \
                    ${yamlConfigFile} \
                    "$CREDENTIALS_DIRECTORY"/secretConfigFile > ${statePath}/config.yml
                '';
              in
              {
                description = "SeaDexArr, ${instance.name} instance";
                wantedBy = [ "multi-user.target" ];
                after = [ "network.target" ];
                preStart = lib.optionalString (
                  instance.settings != null || instance.settingsFile != null
                ) generateConfigScript;

                environment = {
                  CONFIG_DIR = statePath;
                  SCHEDULE_TIME = builtins.toString instance.scheduleTime;
                };

                serviceConfig = {
                  Type = "simple";
                  ExecStart = "${instance.package}/bin/seadexarr run scheduled";
                  Restart = "on-failure";
                  StateDirectory = stateDir;
                  WorkingDirectory = statePath;

                  LoadCredential = lib.mkIf (
                    instance.settingsFile != null
                  ) "secretConfigFile:${instance.settingsFile}";

                  # Hardening
                  NoNewPrivileges = true;
                  PrivateTmp = true;
                  PrivateDevices = true;
                  DevicePolicy = "closed";
                  DynamicUser = true;
                  ProtectSystem = "strict";
                  ProtectHome = true;
                  ProtectControlGroups = true;
                  ProtectKernelModules = true;
                  ProtectKernelTunables = true;
                  RestrictAddressFamilies = [
                    "AF_UNIX"
                    "AF_INET"
                    "AF_INET6"
                    "AF_NETLINK"
                  ];
                  RestrictNamespaces = true;
                  RestrictRealtime = true;
                  RestrictSUIDSGID = true;
                  LockPersonality = true;
                  SystemCallFilter = [
                    "~@cpu-emulation"
                    "~@debug"
                    "~@keyring"
                    "~@memlock"
                    "~@obsolete"
                    "~@privileged"
                    "~@setuid"
                  ];
                };
              };
            instances = lib.attrValues cfg;
            mapInstances = f: lib.mkMerge (map f instances);
          in
          {
            nixpkgs.overlays = [ self.overlays.default ];

            systemd.services = mapInstances (
              instance:
              lib.mkIf instance.enable { "seadexarr-${instance.name}" = mkInstanceServiceConfig instance; }
            );
          };
      };
  };
}
