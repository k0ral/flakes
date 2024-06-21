{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "s";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "zquestz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pHsu5ycvgMpx4aTd+jB+ac6QsMj57UKb/MVWUwi44kQ=";
  };

  vendorHash = "sha256-VyTUJWEk8hlBBsuH2hxDoZLhJckSApUB/wLyx88WeBA=";

  meta = with lib; {
    description = "Open a web search in your terminal";
    homepage = "https://github.com/zquestz/s";
    mainProgram = "s";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
