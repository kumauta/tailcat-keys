# tailcat-keys

Tailcatのクライアント公開鍵を、コメント付きの1行1鍵で管理します。

## クライアント公開鍵を生成

Tailcat v0.4.0では、クライアント用の既定鍵を次のコマンドで生成します。

```sh
tailcat genkey --client --key=client-default
```

表示された `nodekey:...` を、後述の `./edit-keys.sh` で追加します。以後のクライアント
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

## 鍵一覧を編集

`kumauta.keys.list` はコメント付きの編集元、`kumauta.keys` はTailcatに
直接渡すカンマ区切り1行の配布用ファイルです。直接編集せず、
次のコマンドを使います。

```sh
./edit-keys.sh
```

スクリプトは `vi` または `$VISUAL` / `$EDITOR` で編集元を開き、
鍵の形式と重複を検証してから `kumauta.keys` を生成します。

`kumauta.keys.list` では、鍵の後ろに `#` でコメントを記載できます。

```text
nodekey:0123456789abcdef... # device-name
```

## `main` ブランチから取得

Tailcatサーバーの起動時に、生成済みの1行ファイルを直接取得します。

```sh
allow_keys="$(
  curl -fsSL \
    https://raw.githubusercontent.com/kumauta/tailcat-keys/main/kumauta.keys
)"

exec /usr/local/bin/tailcat \
  --allow="$allow_keys" \
  --serve=no-auth-ssh
```
