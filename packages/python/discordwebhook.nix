{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "discordwebhook";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sqicwyLgNsNvaU8joCAj551pFvW2vhJ94nM7ex+TRFw=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  meta = {
    changelog = "https://github.com/10mohi6/discord-webhook-python/releases/tag/${version}";
    homepage = "https://github.com/10mohi6/discord-webhook-python/";
    description = "discordwebhook is a python library for discord webhook with discord rest api on Python 3.6 and above.";
    license = lib.licenses.mit;
  };
}
