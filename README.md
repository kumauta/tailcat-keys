# tailcat-keys

Tailcatのクライアント公開鍵を、コメント付きの1行1鍵で管理します。

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
