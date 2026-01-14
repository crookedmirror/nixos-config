{ config, ... }:
{
  home.sessionVariables = {
    OPENAI_API_KEY = config.userSecrets.ai.openaiApiKey;
  };
}
