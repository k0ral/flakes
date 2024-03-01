{ pkgs, ... }:

rec {
  ninjas = pkgs.writeShellScriptBin "ninjas" ''
    BASE_URL="https://api.api-ninjas.com"
    ${pkgs.httpie}/bin/http GET "$BASE_URL/v1/quotes" "Referer:$BASE_URL" "Origin:$BASE_URL" | ${pkgs.jq}/bin/jq -r '.[] | .quote + " — " + .author'
  '';

  reddit = pkgs.writeShellScriptBin "reddit" ''
    SOURCES=(
      "https://www.reddit.com/r/quotes/hot.json"
      "https://www.reddit.com/r/quotes/top.json?t=day"
      "https://www.reddit.com/r/quotes/top.json?t=week"
      "https://www.reddit.com/r/quotes/top.json?t=month"
      "https://www.reddit.com/r/quotes/top.json?t=year"
      "https://www.reddit.com/r/quotes/top.json?t=all"
    )
    I=$(${pkgs.coreutils}/bin/shuf -i0-5 -n1)

    ${pkgs.httpie}/bin/http GET "''${SOURCES[$I]}" | ${pkgs.jq}/bin/jq -r ".data.children[].data.title" | ${pkgs.coreutils}/bin/shuf -n1
  '';

  quotable = pkgs.writeShellScriptBin "quotable" ''
    ${pkgs.httpie}/bin/http GET "https://api.quotable.io/quotes/random" | ${pkgs.jq}/bin/jq -r '.[] | .content + " — " + .author'
  '';

  quote-garden = pkgs.writeShellScriptBin "quote-garden" ''
    ${pkgs.httpie}/bin/http GET "https://quote-garden.onrender.com/api/v3/quotes/random" | ${pkgs.jq}/bin/jq -r '.data[] | .quoteText + " — " + .quoteAuthor'
  '';

  zenquote = pkgs.writeShellScriptBin "zenquote" ''
    ${pkgs.httpie}/bin/http GET "https://zenquotes.io/api/random" | ${pkgs.jq}/bin/jq -r '.[] | .q + " — " + .a'
  '';

  quottit = pkgs.writeShellScriptBin "quottit" ''
    SOURCES=(
      ${ninjas}/bin/ninjas
      ${reddit}/bin/reddit
      ${quotable}/bin/quotable
      ${quote-garden}/bin/quote-garden
      ${zenquote}/bin/zenquote
    )
    I=$(${pkgs.coreutils}/bin/shuf -i0-4 -n1)

    ${pkgs.bash}/bin/bash "''${SOURCES[$I]}"
  '';
}
