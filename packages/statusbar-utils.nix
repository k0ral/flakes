{ stdenv, lib, oauth2l, httpie, jq, writeShellScriptBin }:

let
  fastmailUnread = writeShellScriptBin "fastmail-unread" ''
    API_KEY="$(cat ''${XDG_CONFIG_HOME:-~/.config}/secrets/fastmail-api-key)"
    API_URL="https://api.fastmail.com/jmap/api"
    ACCOUNT_ID="$(cat ''${XDG_CONFIG_HOME:-~/.config}/secrets/fastmail-account-id)"

    read -r -d ''' BODY << EOM
    {
      "using": [ "urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail" ],
      "methodCalls": [
          [ "Mailbox/query", { "accountId": "$ACCOUNT_ID", "filter": {"name": "Inbox" } }, "0" ],
          [ "Mailbox/get", { "accountId": "$ACCOUNT_ID", "#ids": { "resultOf": "0", "name": "Mailbox/query", "path": "/ids/*" } }, "1" ]
      ]
    }
    EOM

    VALUE="$(echo "$BODY" | http --print b POST "$API_URL" "Authorization: Bearer $API_KEY" | jq ".methodResponses[1][1].list[0].unreadEmails")"

    echo "📧 FASTMAIL $VALUE"
  '';

  gmailUnread = writeShellScriptBin "gmail-unread" ''
    ADDRESS=$(cat ''${XDG_CONFIG_HOME:-~/.config}/secrets/gmail-address)
    URL="https://gmail.googleapis.com/gmail/v1/users/$ADDRESS/labels/INBOX"
    HEADER="$(${oauth2l}/bin/oauth2l header --refresh --credentials ''${XDG_CONFIG_HOME:-~/.config}/secrets/gmail-credentials.json --scope gmail.readonly --disableAutoOpenConsentPage)"
    VALUE="$(${httpie}/bin/http --print b GET "$URL" "$HEADER" | ${jq}/bin/jq ".messagesUnread")"

    echo "📧 GMAIL $VALUE"
  '';
in stdenv.mkDerivation rec {
  pname = "statusbar-utils";
  version = "0.1.0";

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${fastmailUnread}/bin/fastmail-unread $out/bin
    cp ${gmailUnread}/bin/gmail-unread $out/bin
  '';

  meta = with lib; {
    description = "Statusbar utilities";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
