{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.nixos.home-assistant;
in {
  options.module.nixos.home-assistant = {
    enable = mkEnableOption "Home Assistant module";
    ntfyAddress = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 1883 8080 ];
      allowedUDPPorts = [ 1883 8080 ];
    };

    services.home-assistant = {
      enable = true;
      openFirewall = true;
      customComponents = [
        pkgs.home-assistant-custom-components.ntfy
      ];
      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };

        homeassistant.allowlist_external_dirs = [ "/hass-media" ];

        shell_command = {
          expose_media = "chmod -R a+rw /hass-media";
        };

        mqtt = [{
          siren = {
            unique_id = "heiman_siren";
            name = "Heiman siren";
            icon = "mdi:alarm-light";
            support_volume_set = false;
            support_duration = false;
            available_tones = [ "burglar" "fire" "emergency" "police_panic" "fire_panic" "emergency_panic" ];
            command_topic = "zigbee2mqtt/Siren/set";
            payload_on = "burglar";
            payload_off = "stop";
            command_template = ''{"warning": {"duration": 900, "mode": "{{ value }}", "strobe": true} }'';
            command_off_template = ''{"warning": {"duration": 0, "mode": "{{ value }}", "strobe": false} }'';
            qos = 1;
            retain = false;
            optimistic = true;
          };
        }];

        notify = [{
          name = "Mail myself";
          platform = "smtp";
          sender = "!secret my-mail";
          recipient = "!secret my-mail";
          server = "!secret smtp-server";
          port = 465;
          encryption = "tls";
          username = "!secret my-mail";
          password = "!secret smtp-password";
        }
          {
            name = "Mail significant other";
            platform = "smtp";
            sender = "!secret my-mail";
            recipient = "!secret significant-other-mail";
            server = "!secret smtp-server";
            port = 465;
            encryption = "tls";
            username = "!secret my-mail";
            password = "!secret smtp-password";
          }
          {
            name = "ntfy";
            platform = "ntfy";
            topic = "home-assistant";
            url = cfg.ntfyAddress;
            verify_ssl = false;
            allow_topic_override = true;
            #attachment_maxsize: 300K
          }
        ];

        alarm_control_panel = [{
          platform = "manual";
          name = "Home alarm";
          code_arm_required = false;
          disarm_after_trigger = true;
          arming_time = 0;
          delay_time = 0;
          trigger_time = 300;
        }];

        automation = [
          {
            alias = "Notify when battery of door sensor is low";
            trigger = [{
              platform = "numeric_state";
              entity_id = "sensor.main_door_sensor_battery";
              below = 25;
              "for".hours = 1;
            }];
            action = [{
              service = "notify.mail_myself";
              data.title = "Door sensor has low battery";
              data.message = "TODO: add link";
            }{
              service = "notify.ntfy";
              data.title = "Door sensor has low battery";
              data.message = "TODO: add link";
            }];
          }

          {
            alias = "Notify when battery of siren is low";
            trigger = [{
              platform = "numeric_state";
              entity_id = "sensor.siren_battery";
              below = 10;
              "for".minutes = 10;
            }];
            condition = [{
              condition = "state";
              entity_id = "alarm_control_panel.home_alarm";
              state = "armed_away";
            }];
            action = [{
              service = "notify.mail_myself";
              data.title = "Siren has low battery while alarm is armed";
              data.message = "TODO: add link";
            }{
              service = "notify.ntfy";
              data.title = "Siren has low battery while alarm is armed";
              data.message = "TODO: add link";
            }];
          }

          {
            alias = "Enable full monitoring when alarm gets armed";
            trigger = [{
              platform = "state";
              entity_id = "alarm_control_panel.home_alarm";
              to = "armed_away";
            }];
            action = [{
              service = "number.set_value";
              target.entity_id = "number.camera1_motion_sensitivity";
              data.value = 33;
            }
              {
                service = "number.set_value";
                target.entity_id = "number.camera1_ai_person_sensitivity";
                data.value = 60;
              }
              {
                service = "number.set_value";
                target.entity_id = "number.camera1_ai_vehicle_sensitivity";
                data.value = 0;
              }
              {
                service = "number.set_value";
                target.entity_id = "number.camera1_floodlight_turn_on_brightness";
                data.value = 100;
              }
              {
                service = "number.set_value";
                target.entity_id = "number.camera1_zoom";
                data.value = 0;
              }
              {
                service = "switch.turn_on";
                target.entity_id = "switch.camera1_auto_focus";
              }
              {
                service = "switch.turn_on";
                target.entity_id = "switch.camera1_email_on_event";
              }
              {
                service = "switch.turn_on";
                target.entity_id = "switch.camera1_infra_red_lights_in_night_mode";
              }
              {
                service = "switch.turn_on";
                target.entity_id = "switch.camera1_record";
              }
              {
                service = "switch.turn_on";
                target.entity_id = "switch.camera1_record_audio";
              }
              {
                service = "switch.turn_off";
                target.entity_id = "switch.camera1_siren_on_event";
              }];
          }

          {
            alias = "Trigger alarm while armed away";
            trigger = [{
              platform = "state";
              entity_id = "binary_sensor.main_door_sensor_contact";
              to = "on";
            }];
            condition = [{
              condition = "state";
              entity_id = "alarm_control_panel.home_alarm";
              state = "armed_away";
            }];
            action = [{
              service = "alarm_control_panel.alarm_trigger";
              target.entity_id = "alarm_control_panel.home_alarm";
            }];
          }

          {
            alias = "Actions when alarm triggered";
            trigger = [{
              platform = "state";
              entity_id = "alarm_control_panel.home_alarm";
              to = "triggered";
            }];
            action = [{
              service = "camera.snapshot";
              target.entity_id = "camera.camera1_fluent";
              data.filename = "/hass-media/alarm-triggered.jpg";
            }{
              service = "shell_command.expose_media";
            }{
              service = "notify.mail_myself";
              data.title = "Home alarm has been TRIGGERED";
              data.message = "TODO: add link";
            }{
              service = "notify.mail_significant_other";
              data.title = "Home alarm has been TRIGGERED";
              data.message = "TODO: add link";
            }{
              service = "notify.ntfy";
              data = {
                title = "Home alarm has been TRIGGERED";
                data = {
                  attach_file = "/hass-media/alarm-triggered.jpg";
                };
              };
            }{
              service = "light.turn_on";
              target.entity_id = "light.camera1_floodlight";
              data.brightness = 255;
            }{
              service = "siren.turn_on";
              target.entity_id = "siren.camera1_siren";
            }{
              service = "siren.turn_on";
              target.entity_id = "siren.heiman_siren";
            }];
          }

          {
            alias = "Send snapshot when alarm is armed and motion is detected";
            trigger = [{
              platform = "state";
              entity_id = "binary_sensor.camera1_motion";
              from = "off";
              to = "on";
            }];
            condition = [{
              condition = "state";
              entity_id = "alarm_control_panel.home_alarm";
              state = "armed_away";
            }];
            action = [{
              service = "camera.snapshot";
              target.entity_id = "camera.camera1_fluent";
              data.filename = "/hass-media/home-assistant-motion.jpg";
            }{
              service = "shell_command.expose_media";
            }{
              service = "notify.ntfy";
              data = {
                title = "Motion detected at home";
                data = {
                  attach_file = "/hass-media/home-assistant-motion.jpg";
                };
              };
            }];
          }

          {
            alias = "Actions when alarm is disarmed";
            trigger = [{
              platform = "state";
              entity_id = "alarm_control_panel.home_alarm";
              to = "disarmed";
            }];
            action = [
              {
                service = "camera.snapshot";
                target.entity_id = "camera.camera1_fluent";
                data.filename = "/hass-media/alarm-disarmed.jpg";
              }{
                service = "shell_command.expose_media";
              }{
                service = "notify.mail_myself";
                data = {
                  title = "Home alarm has been DISARMED";
                  data = {
                    attach_file = "/hass-media/alarm-disarmed.jpg";
                  };
                };
              }
              {
                service = "notify.ntfy";
                data.title = "Home alarm has been DISARMED";
                data.message = "TODO: add link";
              }
              {
                service = "light.turn_off";
                target.entity_id = "light.camera1_floodlight";
              }
              {
                service = "siren.turn_off";
                target.entity_id = "siren.camera1_siren";
              }
              {
                service = "siren.turn_off";
                target.entity_id = "siren.heiman_siren";
              }
              {
                service = "switch.turn_off";
                target.entity_id = "switch.camera1_email_on_event";
              }];
          }

        ];
      };

      extraComponents = [
        "adguard"
        "default_config"
        "esphome"
        "freebox"
        "kodi"
        "homeassistant_sky_connect"
        "met"
        "mqtt"
        "reolink"
      ];
    };

    services.mosquitto = {
      enable = true;
      listeners = [{
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        port = 1883;
        settings.allow_anonymous = true;
      }];
    };

    services.zigbee2mqtt = {
      enable = true;
      settings = {
        homeassistant = {
          discovery_topic = "homeassistant";
          status_topic = "homeassistant/status";
          legacy_entity_attributes = true;
          legacy_triggers = true;
        };
        mqtt = {
          base_topic = "zigbee2mqtt";
          server = "mqtt://localhost:1883";
        };
        serial.port = "/dev/serial/by-id/usb-Nabu_Casa_SkyConnect_v1.0_5695b488db93ed11ab8d82f23b20a988-if00-port0";
        frontend = true;
      };
    };

    sops.secrets."home-assistant/secrets" = {
      owner = "hass";
      path = "${config.services.home-assistant.configDir}/secrets.yaml";
    };

    systemd.tmpfiles.rules = [
      "d /hass-media 0777 hass hass"
    ];
  };
}
