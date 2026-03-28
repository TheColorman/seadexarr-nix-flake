{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  atomicwriter,
  httpx,
  msgspec,
}:

buildPythonPackage rec {
  pname = "seadex";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bLOgeganvqIdjlowBG0MBY/ktjKGZqFSO9kqQjz/3nE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    atomicwriter
    httpx
    msgspec
  ];

  meta = {
    changelog = "https://github.com/Ravencentric/seadex/releases/tag/${version}";
    homepage = "https://github.com/Ravencentric/seadex/";
    description = "Python wrapper for the SeaDex API";
    license = lib.licenses.mit;
  };
}
