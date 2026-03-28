{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "arrapi";
  version = "1.4.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7vh9BhxYK2NdMgqC4by+J0HMlS91835036TiJ5qYjWc=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  meta = {
    changelog = "https://github.com/Kometa-Team/ArrAPI/releases/tag/${version}";
    homepage = "https://github.com/Kometa-Team/ArrAPI/";
    description = "A lightweight Python library for Radarr and Sonarr API.";
    license = lib.licenses.mit;
  };
}
