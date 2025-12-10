{
  pkgs,
  lib,
  globals,
  ...
}:
{
  home = {
    packages = with pkgs; [ claude-code ];
    file = {
      ".claude/settings.json".source =
        lib._custom.relativeSymlink globals.myuser.configDirectory ./settings.json;
      ".claude/statusline.sh" = {
        source = ./statusline.sh;
        executable = true;
      };
    };
    sessionVariables = {
      OTEL_METRICS_EXPORTER = "otlp";
      OTEL_LOGS_EXPORTER = "otlp";
      OTEL_TRACES_EXPORTER = "otlp";
      OTEL_EXPORTER_OTLP_PROTOCOL = "otlp";
      OTEL_LOG_USER_PROMPTS = 1;
      # OTEL_EXPORTER_OTLP_ENDPOINT,OTEL_EXPORTER_OTLP_INSECURE -> check jarvis/default.nix
      # Set per project
      # OTEL_RESOURCE_ATTRIBUTES = service.name=claude-code,service.version=1.0.0,deployment.environment=production,project.name=internal,team=softwarefactory
    };
  };
}
