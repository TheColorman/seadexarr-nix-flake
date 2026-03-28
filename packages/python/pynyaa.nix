{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  beautifulsoup4,
  httpx,
  lxml,
  pydantic,
  torf,
}:

buildPythonPackage rec {
  pname = "pynyaa";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6AAQr3uzc5y9FUPR+R7PJLgtOUY8lVGb3lZVH+pxn4g=";
  };

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    httpx
    lxml
    pydantic
    torf
  ];

  meta = {
    changelog = "https://github.com/Ravencentric/pynyaa/releases/tag/${version}";
    homepage = "https://github.com/Ravencentric/pynyaa/";
    description = "Turn nyaa.si torrent pages into neat Python objects ";
    license = lib.licenses.mit;
  };
}
