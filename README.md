# tailcat-keys

Tailcatのクライアント公開鍵を、コメント付きの1行1鍵で管理します。

## クライアント公開鍵を生成

Tailcat v0.4.0では、クライアント用の既定鍵を次のコマンドで生成します。

```sh
tailcat genkey --client --key=client-default
```

表示された `nodekey:...` を `kumauta.keys` に追加します。以後のクライアント
接続では、`client-default` が自動的に使用されます。

保存済みの公開鍵を再確認する場合:

```sh
tailcat printpub --key=client-default
```

保存済みの鍵一覧を確認する場合:

```sh
tailcat genkey --list
```

macOSでは秘密鍵が通常、次の場所に保存されます。このファイルは公開リポジトリへ
追加しないでください。

```text
~/Library/Application Support/tailcat/keys/client-default.private.json
```

`--force` を付けて再生成すると公開鍵が変わり、サーバーに登録した古い公開鍵では
接続できなくなります。通常、鍵生成は初回の一度だけ行います。

## `main` ブランチから取得して変換

変換スクリプトと鍵一覧をRaw URLから取得し、Tailcatの `--allow` で使える
カンマ区切り形式へ変換します。

```sh
curl -fsSL \
  https://raw.githubusercontent.com/kumauta/tailcat-keys/main/to-tailcat-allow.sh |
sh -s -- \
  https://raw.githubusercontent.com/kumauta/tailcat-keys/main/kumauta.keys
```

Tailcatサーバーの起動時に直接使用する場合:

```sh
allow_keys="$(
  curl -fsSL \
    https://raw.githubusercontent.com/kumauta/tailcat-keys/main/to-tailcat-allow.sh |
  sh -s -- \
    https://raw.githubusercontent.com/kumauta/tailcat-keys/main/kumauta.keys
)"

exec /usr/local/bin/tailcat \
  --allow="$allow_keys" \
  --serve=no-auth-ssh
```

`kumauta.keys` では、鍵の後ろに `#` でコメントを記載できます。

```text
nodekey:0123456789abcdef... # device-name
```
