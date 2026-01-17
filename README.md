# WordPress Dev Container 開発環境

このリポジトリは、Dev ContainerでWordPressの開発環境を構築するためのプロジェクトです。Docker ComposeとVS Codeの Dev Containers拡張機能を使用して、すぐに開発を始められる環境を提供します。

## 📋 前提条件

以下のツールがインストールされていることを確認してください：

- [Docker Desktop](https://www.docker.com/products/docker-desktop) (Windows/Mac/Linux)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## 🚀 セットアップ手順

### 1. リポジトリをクローン

```bash
git clone https://github.com/jugeeem/wordpress-with-devcontaier.git
cd wordpress-with-devcontaier
```

### 2. 環境変数の設定

`.env.example` をコピーして `.env` ファイルを作成し、データベースの認証情報を設定します：

**Windows (PowerShell):**
```powershell
Copy-Item .env.example .env
```

**Mac/Linux:**
```bash
cp .env.example .env
```

`.env` ファイルを編集し、パスワードを変更してください：

```env
MYSQL_ROOT_PASSWORD=your_strong_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=your_strong_password
```

### 3. Dev Containerで開く

1. VS Codeでこのフォルダーを開きます
2. 左下の緑色のアイコン（><）をクリックするか、`F1` キーを押してコマンドパレットを開きます
3. 「Dev Containers: Reopen in Container」を選択します
4. 初回起動時は自動的にWordPressがダウンロードされ、セットアップが実行されます（数分かかる場合があります）

### 4. WordPressのインストール

Dev Containerが起動したら、ブラウザで以下のURLにアクセスします：

**WordPress:** http://localhost:8080

WordPress のインストールウィザードが表示されるので、以下の手順で進めてください：

1. 言語を選択（日本語が選択されています）
2. サイトのタイトル、ユーザー名、パスワード、メールアドレスを入力
3. 「WordPressをインストール」をクリック
4. インストール完了！

## 🔧 利用可能なサービス

| サービス | URL | 説明 |
|---------|-----|------|
| WordPress | http://localhost:8080 | WordPress サイト |
| phpMyAdmin | http://localhost:8081 | データベース管理ツール |

### phpMyAdmin ログイン情報

- **サーバー:** mysql
- **ユーザー名:** `.env` で設定した `MYSQL_USER` (デフォルト: wpuser)
- **パスワード:** `.env` で設定した `MYSQL_PASSWORD`

または root ユーザーでログイン：
- **ユーザー名:** root
- **パスワード:** `.env` で設定した `MYSQL_ROOT_PASSWORD`

## 📁 プロジェクト構造

```
wordpress-with-devcontaier/
├── .devcontainer/
│   ├── devcontainer.json      # Dev Container設定
│   └── docker-compose.yml     # Dockerコンテナ構成
├── wordpress/                 # WordPressファイル（自動生成）
├── .env                       # 環境変数（Git管理外）
├── .env.example               # 環境変数テンプレート
├── .gitignore                 # Git除外設定
├── wp-config-template.php     # WordPress設定テンプレート
├── setup.sh                   # セットアップスクリプト（Linux/Mac）
├── setup.bat                  # セットアップスクリプト（Windows CMD）
├── setup.ps1                  # セットアップスクリプト（Windows PowerShell）
└── README.md                  # このファイル
```

## 🛠️ 開発ワークフロー

### テーマ開発

テーマファイルは `wordpress/wp-content/themes/` に配置します：

```bash
cd wordpress/wp-content/themes/
mkdir my-theme
cd my-theme
# テーマファイルを作成
```

### プラグイン開発

プラグインファイルは `wordpress/wp-content/plugins/` に配置します：

```bash
cd wordpress/wp-content/plugins/
mkdir my-plugin
cd my-plugin
# プラグインファイルを作成
```

### データベースのバックアップ

phpMyAdmin (http://localhost:8081) を使用してデータベースをエクスポートできます。

## 🐛 トラブルシューティング

### Dev Containerが起動しない

1. Docker Desktopが起動していることを確認
2. `.env` ファイルが存在し、正しく設定されていることを確認
3. VS Codeを再起動
4. Docker Desktopを再起動

### WordPressにアクセスできない

1. コンテナが正常に起動しているか確認：
   ```bash
   docker ps
   ```
   `wordpress`, `mysql`, `phpmyadmin` コンテナが表示されるはずです

2. ポート8080が他のアプリケーションで使用されていないか確認

### データベース接続エラー

1. `.env` ファイルの認証情報が正しいか確認
2. MySQL コンテナが起動しているか確認
3. Dev Containerを再起動

### ファイルの権限エラー

Linux/Macの場合、以下のコマンドで権限を修正できます：

```bash
sudo chown -R www-data:www-data wordpress/
```

## 🔄 環境のリセット

すべてをクリーンな状態にリセットするには：

```bash
# Dev Containerを閉じてから実行
docker-compose -f .devcontainer/docker-compose.yml down -v
rm -rf wordpress/
```

その後、再度 Dev Container で開くと自動的にセットアップされます。

## 📚 追加情報

- [WordPress 日本語版](https://ja.wordpress.org/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [Dev Containers ドキュメント](https://code.visualstudio.com/docs/devcontainers/containers)

## 📝 ライセンス

このプロジェクトはオープンソースです。ご自由にお使いください。

## 🤝 コントリビューション

問題を発見した場合や改善案がある場合は、Issueを作成するか、Pull Requestを送信してください！