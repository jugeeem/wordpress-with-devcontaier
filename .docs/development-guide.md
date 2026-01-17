# WordPress Dev Container 開発手順書

## 📚 目次

1. [プロジェクト概要](#プロジェクト概要)
2. [開発環境の構成](#開発環境の構成)
3. [前提条件](#前提条件)
4. [初期セットアップ](#初期セットアップ)
5. [開発環境の起動](#開発環境の起動)
6. [WordPressの初期設定](#wordpressの初期設定)
7. [開発ワークフロー](#開発ワークフロー)
8. [データベース管理](#データベース管理)
9. [デバッグ方法](#デバッグ方法)
10. [トラブルシューティング](#トラブルシューティング)
11. [ベストプラクティス](#ベストプラクティス)

---

## プロジェクト概要

このプロジェクトは、Visual Studio CodeのDev Container機能を使用してWordPressの開発環境を構築するためのものです。Docker ComposeベースでWordPress、MySQL、phpMyAdminが統合された完全な開発環境を提供します。

### 主な特徴

- **コンテナ化された環境**: Docker Composeを使用した完全に分離された開発環境
- **VS Code統合**: Dev Containers拡張機能による seamless な開発体験
- **日本語対応**: WordPress日本語版が自動的にセットアップ
- **データベース管理**: phpMyAdminによる直感的なDB管理
- **自動セットアップ**: ワンクリックでWordPressが起動可能

---

## 開発環境の構成

### アーキテクチャ図

```
┌─────────────────────────────────────────────────┐
│            Visual Studio Code                   │
│         (Dev Containers Extension)              │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────┴───────────────────────────────┐
│           Docker Compose Environment            │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────┐  ┌──────────────┐           │
│  │  WordPress   │  │    MySQL     │           │
│  │ (Port 8080)  │◄─┤  (Port 3306) │           │
│  │              │  │              │           │
│  └──────────────┘  └──────────────┘           │
│         │                  ▲                   │
│         │                  │                   │
│         ▼          ┌───────┴──────┐           │
│  ┌──────────────┐  │ phpMyAdmin   │           │
│  │  Workspace   │  │ (Port 8081)  │           │
│  │   Folder     │  └──────────────┘           │
│  └──────────────┘                              │
│                                                 │
└─────────────────────────────────────────────────┘
```

### コンテナ構成

#### 1. WordPress コンテナ
- **イメージ**: `wordpress:latest`
- **ポート**: 8080 → 80
- **機能**: WordPressアプリケーション本体
- **マウント**: 
  - `../wordpress` → `/var/www/html` (WordPressファイル)
  - `..` → `/workspace` (プロジェクトルート)

#### 2. MySQL コンテナ
- **イメージ**: `mysql:8.0`
- **ポート**: 3306 (内部のみ)
- **機能**: WordPressデータベース
- **永続化**: `mysql_data` ボリューム

#### 3. phpMyAdmin コンテナ
- **イメージ**: `phpmyadmin:latest`
- **ポート**: 8081 → 80
- **機能**: データベース管理UI

---

## 前提条件

### 必須ソフトウェア

以下のソフトウェアがインストールされている必要があります：

1. **Docker Desktop**
   - バージョン: 最新版推奨
   - ダウンロード: https://www.docker.com/products/docker-desktop
   - Windows: WSL 2バックエンドが有効であること
   - Mac: Apple Silicon (M1/M2) の場合、ARM版をインストール
   - Linux: Docker Engine + Docker Compose

2. **Visual Studio Code**
   - バージョン: 最新版推奨
   - ダウンロード: https://code.visualstudio.com/

3. **Dev Containers 拡張機能**
   - ID: `ms-vscode-remote.remote-containers`
   - インストール: VS Code内で拡張機能タブから検索してインストール

### システム要件

- **メモリ**: 最低4GB、推奨8GB以上
- **ディスク空き容量**: 最低5GB
- **OS**: 
  - Windows 10/11 (Pro, Enterprise, Education) または Windows 11 Home
  - macOS 10.15 Catalina 以降
  - Linux (Ubuntu 20.04 LTS 以降推奨)

### 推奨ツール

- **Git**: ソースコード管理用
- **ブラウザ**: Chrome, Firefox, Edge など最新版

---

## 初期セットアップ

### ステップ1: リポジトリの取得

```bash
# HTTPSでクローン
git clone https://github.com/jugeeem/wordpress-with-devcontaier.git
cd wordpress-with-devcontaier
```

または

```bash
# SSHでクローン (SSH鍵設定済みの場合)
git clone git@github.com:jugeeem/wordpress-with-devcontaier.git
cd wordpress-with-devcontaier
```

### ステップ2: 環境変数ファイルの作成

プロジェクトルートに `.env` ファイルを作成します。

**Windows (PowerShell):**
```powershell
Copy-Item .env.example .env
```

**Windows (CMD):**
```cmd
copy .env.example .env
```

**Mac/Linux:**
```bash
cp .env.example .env
```

### ステップ3: 環境変数の設定

`.env` ファイルをテキストエディタで開き、以下の設定を編集します：

```env
# MySQL Database Configuration
MYSQL_ROOT_PASSWORD=強力なルートパスワード
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=強力なユーザーパスワード
```

**重要なセキュリティ設定:**
- `MYSQL_ROOT_PASSWORD`: MySQLのrootユーザーパスワード（推奨: 16文字以上の英数字記号混在）
- `MYSQL_PASSWORD`: WordPressが使用するDBユーザーのパスワード（推奨: 16文字以上）
- パスワード生成ツール: https://passwordsgenerator.net/

**パスワード例:**
```env
MYSQL_ROOT_PASSWORD=Rt9@kL#mN2pQ$xZ7
MYSQL_PASSWORD=uY5!vW8@aB3#cD6$
```

### ステップ4: Docker Desktopの起動確認

Dev Containerを開く前に、Docker Desktopが起動していることを確認してください。

**確認方法:**
```bash
docker --version
docker compose version
```

正常に動作している場合、バージョン情報が表示されます。

---

## 開発環境の起動

### Dev Containerでの起動

1. **VS Codeでプロジェクトを開く**
   ```bash
   code .
   ```
   または、VS Codeから `File > Open Folder` でプロジェクトフォルダを開きます。

2. **Dev Containerで再起動**
   
   以下のいずれかの方法で実行：
   
   **方法A: コマンドパレット**
   - `F1` または `Ctrl+Shift+P` (Mac: `Cmd+Shift+P`) でコマンドパレットを開く
   - `Dev Containers: Reopen in Container` を選択
   
   **方法B: 通知から**
   - VS Codeが自動的にDev Container構成を検出した場合、右下に通知が表示される
   - `Reopen in Container` をクリック
   
   **方法C: ステータスバーから**
   - VS Code左下の `><` アイコンをクリック
   - `Reopen in Container` を選択

3. **初回セットアップの実行**
   
   初回起動時、以下の処理が自動的に実行されます（5-10分程度）：
   - Dockerイメージのダウンロード
   - コンテナの起動
   - WordPress日本語版のダウンロード
   - ファイル権限の設定
   - wp-config.phpの生成

   **進行状況の確認:**
   - VS Code右下に「Starting Dev Container」の通知が表示されます
   - `Show Log` をクリックすると詳細なログが確認できます

4. **起動完了の確認**
   
   以下のメッセージがターミナルに表示されれば成功です：
   ```
   ==========================================
   ✅ Setup completed successfully!
   ==========================================
   
   WordPress is now accessible at:
     🌐 http://localhost:8080
   
   phpMyAdmin is accessible at:
     🔧 http://localhost:8081
   ```

### 起動後のアクセス確認

ブラウザで以下のURLにアクセスして動作確認：

- **WordPress**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8081

---

## WordPressの初期設定

### WordPress インストールウィザード

1. **言語選択**
   - ブラウザで http://localhost:8080 にアクセス
   - デフォルトで日本語が選択されています
   - `続ける` をクリック

2. **サイト情報の入力**
   
   以下の情報を入力します：
   
   | 項目 | 説明 | 例 |
   |------|------|-----|
   | サイトのタイトル | サイト名 | `My WordPress Site` |
   | ユーザー名 | 管理者ユーザー名 | `admin` (避けるべき) → `site_admin` など |
   | パスワード | 管理者パスワード | 強力なパスワードを設定 |
   | メールアドレス | 管理者メールアドレス | `admin@example.com` |
   | 検索エンジンでの表示 | 開発環境では通常チェック | ☑ 検索エンジンがサイトをインデックスしないようにする |

3. **インストールの実行**
   - `WordPressをインストール` をクリック
   - 数秒で完了します

4. **ログイン**
   - 設定したユーザー名とパスワードでログイン
   - 管理画面 (ダッシュボード) が表示されます

### 初期設定の推奨項目

#### 一般設定
- **設定 > 一般**
  - タイムゾーン: `東京`
  - 日付形式: `Y年m月d日` (例: 2026年1月17日)
  - 時刻形式: `H:i` (例: 13:45)

#### パーマリンク設定
- **設定 > パーマリンク**
  - 推奨: `投稿名` または `カスタム構造: /%postname%/`
  - SEOに優しいURL構造

#### テーマのインストール
- **外観 > テーマ > 新規追加**
  - 開発用の軽量テーマを選択（例: Twenty Twenty-Four）

#### プラグインの推奨インストール
```
開発に役立つプラグイン:
- Query Monitor (デバッグ・パフォーマンス監視)
- Debug Bar (開発者向けデバッグツール)
- WP-CLI (コマンドラインツール - コンテナ内で利用可能)
```

---

## 開発ワークフロー

### プロジェクト構造

```
wordpress-with-devcontaier/
├── .devcontainer/              # Dev Container設定
│   ├── devcontainer.json      # VS Code Dev Container設定
│   ├── docker-compose.yml     # Docker Compose定義
│   └── .gitignore             # Dev Container用.gitignore
├── .docs/                      # ドキュメント (このファイル)
│   └── development-guide.md
├── wordpress/                  # WordPress本体 (自動生成)
│   ├── wp-content/            # カスタムコンテンツ
│   │   ├── themes/           # テーマディレクトリ
│   │   ├── plugins/          # プラグインディレクトリ
│   │   └── uploads/          # アップロードファイル
│   ├── wp-admin/              # 管理画面
│   ├── wp-includes/           # WordPressコアライブラリ
│   └── wp-config.php          # WordPress設定ファイル
├── .env                        # 環境変数 (Git管理外)
├── .env.example                # 環境変数テンプレート
├── .gitignore                  # Git除外設定
├── wp-config-template.php      # wp-config.phpテンプレート
├── setup.sh                    # セットアップスクリプト (Linux/Mac)
├── setup.bat                   # セットアップスクリプト (Windows CMD)
├── setup.ps1                   # セットアップスクリプト (PowerShell)
└── README.md                   # プロジェクトREADME
```

### テーマ開発

#### 新規テーマの作成

1. **テーマディレクトリの作成**
   ```bash
   mkdir -p wordpress/wp-content/themes/my-custom-theme
   cd wordpress/wp-content/themes/my-custom-theme
   ```

2. **必須ファイルの作成**
   
   **style.css** (テーマのメタ情報):
   ```css
   /*
   Theme Name: My Custom Theme
   Theme URI: https://example.com/
   Author: Your Name
   Author URI: https://example.com/
   Description: カスタムテーマの説明
   Version: 1.0.0
   License: GNU General Public License v2 or later
   License URI: http://www.gnu.org/licenses/gpl-2.0.html
   Text Domain: my-custom-theme
   */
   
   /* ここにスタイルを記述 */
   body {
       font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
       line-height: 1.6;
   }
   ```
   
   **index.php** (メインテンプレート):
   ```php
   <?php get_header(); ?>
   
   <main id="main" class="site-main">
       <?php
       if ( have_posts() ) :
           while ( have_posts() ) :
               the_post();
               ?>
               <article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
                   <h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
                   <div class="entry-content">
                       <?php the_excerpt(); ?>
                   </div>
               </article>
               <?php
           endwhile;
       else :
           ?>
           <p>投稿が見つかりませんでした。</p>
           <?php
       endif;
       ?>
   </main>
   
   <?php get_footer(); ?>
   ```
   
   **functions.php** (テーマ機能):
   ```php
   <?php
   /**
    * My Custom Theme functions
    */
   
   // テーマのセットアップ
   function my_custom_theme_setup() {
       // タイトルタグのサポート
       add_theme_support( 'title-tag' );
       
       // アイキャッチ画像のサポート
       add_theme_support( 'post-thumbnails' );
       
       // メニューの登録
       register_nav_menus( array(
           'primary' => __( 'Primary Menu', 'my-custom-theme' ),
       ) );
   }
   add_action( 'after_setup_theme', 'my_custom_theme_setup' );
   
   // スタイルとスクリプトのエンキュー
   function my_custom_theme_scripts() {
       wp_enqueue_style( 'my-custom-theme-style', get_stylesheet_uri(), array(), '1.0.0' );
   }
   add_action( 'wp_enqueue_scripts', 'my_custom_theme_scripts' );
   ```

3. **テーマの有効化**
   - 管理画面 > 外観 > テーマ
   - 作成したテーマを有効化

### プラグイン開発

#### 新規プラグインの作成

1. **プラグインディレクトリの作成**
   ```bash
   mkdir -p wordpress/wp-content/plugins/my-custom-plugin
   cd wordpress/wp-content/plugins/my-custom-plugin
   ```

2. **プラグインファイルの作成**
   
   **my-custom-plugin.php**:
   ```php
   <?php
   /**
    * Plugin Name: My Custom Plugin
    * Plugin URI: https://example.com/
    * Description: カスタムプラグインの説明
    * Version: 1.0.0
    * Author: Your Name
    * Author URI: https://example.com/
    * License: GPL v2 or later
    * License URI: https://www.gnu.org/licenses/gpl-2.0.html
    * Text Domain: my-custom-plugin
    */
   
   // 直接アクセスを防ぐ
   if ( ! defined( 'ABSPATH' ) ) {
       exit;
   }
   
   // プラグインの機能をここに記述
   function my_custom_plugin_init() {
       // 初期化処理
   }
   add_action( 'init', 'my_custom_plugin_init' );
   
   // ショートコードの例
   function my_custom_shortcode( $atts ) {
       $atts = shortcode_atts( array(
           'title' => 'デフォルトタイトル',
       ), $atts );
       
       return '<div class="my-custom-box"><h3>' . esc_html( $atts['title'] ) . '</h3></div>';
   }
   add_shortcode( 'my_custom', 'my_custom_shortcode' );
   ```

3. **プラグインの有効化**
   - 管理画面 > プラグイン
   - 作成したプラグインを有効化

### コード編集のワークフロー

1. **VS Codeでファイルを編集**
   - Dev Container内でファイルを直接編集
   - IntelliSense (自動補完) が利用可能

2. **変更の確認**
   - ブラウザで http://localhost:8080 をリロード
   - 変更が即座に反映されます

3. **デバッグ**
   - PHPエラーはブラウザまたはログファイルで確認
   - Query Monitorプラグインを使用した詳細デバッグ

4. **Gitコミット**
   ```bash
   git add wordpress/wp-content/themes/my-custom-theme
   git commit -m "feat: add custom theme"
   git push origin main
   ```

### ファイル監視とホットリロード

**Browser Sync などの導入 (オプション)**:

1. **package.json の作成** (プロジェクトルート):
   ```json
   {
     "name": "wordpress-dev",
     "version": "1.0.0",
     "scripts": {
       "watch": "browser-sync start --proxy 'localhost:8080' --files 'wordpress/wp-content/**/*.php, wordpress/wp-content/**/*.css, wordpress/wp-content/**/*.js'"
     },
     "devDependencies": {
       "browser-sync": "^2.29.0"
     }
   }
   ```

2. **npmパッケージのインストール**:
   ```bash
   npm install
   ```

3. **監視の開始**:
   ```bash
   npm run watch
   ```

---

## データベース管理

### phpMyAdminの使用

#### アクセス方法

1. ブラウザで http://localhost:8081 を開く
2. ログイン情報を入力:
   - **サーバー**: `mysql`
   - **ユーザー名**: `.env`で設定した`MYSQL_USER` (デフォルト: `wpuser`)
   - **パスワード**: `.env`で設定した`MYSQL_PASSWORD`

または root ユーザーでログイン:
- **ユーザー名**: `root`
- **パスワード**: `.env`で設定した`MYSQL_ROOT_PASSWORD`

#### 主な操作

**テーブルの閲覧**:
1. 左サイドバーから `wordpress` データベースを選択
2. テーブル一覧から目的のテーブルをクリック
3. `表示` タブでデータを確認

**SQLクエリの実行**:
1. `SQL` タブをクリック
2. クエリを入力して `実行` をクリック

例:
```sql
-- 全投稿を取得
SELECT * FROM wp_posts WHERE post_type = 'post' AND post_status = 'publish';

-- ユーザー一覧を取得
SELECT ID, user_login, user_email FROM wp_users;

-- オプションの確認
SELECT * FROM wp_options WHERE option_name = 'siteurl';
```

**データのエクスポート**:
1. エクスポートするデータベースを選択
2. `エクスポート` タブをクリック
3. エクスポート形式を選択 (通常はSQL)
4. `実行` をクリックしてダウンロード

**データのインポート**:
1. `インポート` タブをクリック
2. SQLファイルを選択
3. `実行` をクリック

### WP-CLIによるデータベース操作

Dev Container内でWP-CLIが利用できます。

```bash
# コンテナ内のシェルに入る
docker exec -it wordpress bash

# データベースのエクスポート
wp db export /workspace/backup.sql --allow-root

# データベースのインポート
wp db import /workspace/backup.sql --allow-root

# データベースの最適化
wp db optimize --allow-root

# データベースのチェック
wp db check --allow-root

# 検索と置換 (URLの変更など)
wp search-replace 'http://oldsite.com' 'http://localhost:8080' --allow-root
```

### データベースのバックアップ戦略

**推奨バックアップ方法**:

1. **定期的なエクスポート**:
   ```bash
   # コンテナ内で実行
   wp db export /workspace/backups/backup-$(date +%Y%m%d-%H%M%S).sql --allow-root
   ```

2. **Dockerボリュームのバックアップ**:
   ```bash
   # ホストマシンで実行
   docker run --rm \
     -v wordpress-with-devcontaier_mysql_data:/source \
     -v $(pwd)/backups:/backup \
     alpine tar czf /backup/mysql-data-backup.tar.gz -C /source .
   ```

3. **Git管理からの除外**:
   - バックアップファイルは `.gitignore` に追加
   - 機密情報を含むため、リポジトリにはコミットしない

---

## デバッグ方法

### PHPエラーログの確認

#### WordPressデバッグモードの有効化

`wordpress/wp-config.php` を編集:

```php
// デバッグモードを有効化
define( 'WP_DEBUG', true );

// エラーを画面に表示
define( 'WP_DEBUG_DISPLAY', true );

// エラーをログファイルに記録
define( 'WP_DEBUG_LOG', true );

// JavaScriptエラーも表示
define( 'SCRIPT_DEBUG', true );
```

#### エラーログの場所

- **WordPress デバッグログ**: `wordpress/wp-content/debug.log`
- **PHPエラーログ**: Dockerコンテナ内 `/var/log/apache2/error.log`

#### ログの確認方法

**VS Code内で確認**:
- エクスプローラーから `wordpress/wp-content/debug.log` を開く

**ターミナルで確認**:
```bash
# リアルタイムでログを監視
docker exec -it wordpress tail -f /var/www/html/wp-content/debug.log

# Apacheエラーログの確認
docker exec -it wordpress tail -f /var/log/apache2/error.log
```

### Query Monitor プラグイン

**インストール**:
1. 管理画面 > プラグイン > 新規追加
2. "Query Monitor" を検索
3. インストールして有効化

**主な機能**:
- データベースクエリの監視と最適化
- PHPエラーと警告の表示
- フック実行の追跡
- HTTPリクエストの監視
- 環境情報の表示

**使用方法**:
- サイトを表示すると、管理バーに "Query Monitor" メニューが表示される
- クリックして各種デバッグ情報を確認

### Xdebugの設定 (高度なデバッグ)

#### Xdebugの有効化

1. **docker-compose.yml の編集**:
   
   `.devcontainer/docker-compose.yml` のWordPressサービスに環境変数を追加:
   ```yaml
   wordpress:
     image: wordpress:latest
     environment:
       # 既存の環境変数...
       XDEBUG_MODE: debug
       XDEBUG_CONFIG: client_host=host.docker.internal client_port=9003
   ```

2. **VS Code の launch.json 設定**:
   
   `.vscode/launch.json` を作成:
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Listen for Xdebug",
         "type": "php",
         "request": "launch",
         "port": 9003,
         "pathMappings": {
           "/var/www/html": "${workspaceFolder}/wordpress"
         }
       }
     ]
   }
   ```

3. **ブレークポイントの設定**:
   - PHPファイルの行番号左側をクリック
   - 赤い丸が表示されればブレークポイントが設定されます

4. **デバッグの開始**:
   - VS Codeの `実行とデバッグ` ビューを開く
   - "Listen for Xdebug" を選択して開始
   - ブラウザでページをリロード

---

## トラブルシューティング

### よくある問題と解決方法

#### 1. Dev Containerが起動しない

**症状**: "Failed to connect to docker" エラー

**解決方法**:
- Docker Desktopが起動していることを確認
- Docker Desktopの設定で "Use WSL 2 based engine" が有効か確認 (Windows)
- WSLが最新版か確認: `wsl --update` (Windows)
- Docker Desktopを再起動

#### 2. ポートが使用中

**症状**: "Port 8080 is already in use" エラー

**解決方法**:
```bash
# Windowsの場合
netstat -ano | findstr :8080
taskkill /PID <プロセスID> /F

# Mac/Linuxの場合
lsof -i :8080
kill -9 <プロセスID>
```

または `.devcontainer/docker-compose.yml` のポート番号を変更:
```yaml
ports:
  - "8090:80"  # 8080 → 8090 に変更
```

#### 3. WordPressのダウンロードに失敗

**症状**: "Failed to download WordPress" エラー

**解決方法**:
```bash
# コンテナ内で手動ダウンロード
cd /workspace
curl -sL https://ja.wordpress.org/latest-ja.tar.gz -o latest-ja.tar.gz
tar -xzf latest-ja.tar.gz
cp -r wordpress/* /workspace/wordpress/
rm -rf wordpress latest-ja.tar.gz
```

#### 4. データベース接続エラー

**症状**: "Error establishing a database connection"

**解決方法**:
1. `.env` ファイルの設定を確認
2. MySQLコンテナが起動しているか確認:
   ```bash
   docker ps
   ```
3. MySQLコンテナのログを確認:
   ```bash
   docker logs mysql
   ```
4. データベース接続をテスト:
   ```bash
   docker exec -it mysql mysql -u root -p
   # パスワードを入力してログインできるか確認
   ```

#### 5. ファイル権限エラー

**症状**: "Permission denied" エラー

**解決方法**:
```bash
# コンテナ内で権限を修正
docker exec -it wordpress bash
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
```

#### 6. 画像アップロードができない

**症状**: アップロード時に "Failed to write file to disk" エラー

**解決方法**:
```bash
# uploadsディレクトリの権限を設定
docker exec -it wordpress bash
mkdir -p /var/www/html/wp-content/uploads
chown -R www-data:www-data /var/www/html/wp-content/uploads
chmod -R 755 /var/www/html/wp-content/uploads
```

#### 7. メモリ不足エラー

**症状**: "Allowed memory size exhausted" エラー

**解決方法**:

`wordpress/wp-config.php` にメモリ制限を追加:
```php
define( 'WP_MEMORY_LIMIT', '256M' );
define( 'WP_MAX_MEMORY_LIMIT', '512M' );
```

または `.devcontainer/docker-compose.yml` でPHPメモリ制限を設定:
```yaml
wordpress:
  environment:
    PHP_MEMORY_LIMIT: 256M
```

#### 8. コンテナの完全リセット

**すべてをリセットして再起動する場合**:

```bash
# コンテナの停止と削除
docker-compose -f .devcontainer/docker-compose.yml down -v

# イメージの削除 (オプション)
docker rmi wordpress:latest mysql:8.0 phpmyadmin:latest

# WordPressファイルの削除 (注意: データが消えます)
rm -rf wordpress/*

# Dev Containerで再起動
# VS Codeで「Reopen in Container」を実行
```

### ログの確認方法

#### Dockerコンテナログ

```bash
# 全コンテナのログ
docker-compose -f .devcontainer/docker-compose.yml logs

# 特定コンテナのログ
docker logs wordpress
docker logs mysql
docker logs phpmyadmin

# リアルタイムでログ監視
docker logs -f wordpress
```

#### WordPressデバッグログ

```bash
# リアルタイム監視
docker exec -it wordpress tail -f /var/www/html/wp-content/debug.log

# ログ全体を表示
docker exec -it wordpress cat /var/www/html/wp-content/debug.log
```

---

## ベストプラクティス

### セキュリティ

#### 1. 環境変数の管理

- ✅ `.env` ファイルは絶対にGitにコミットしない
- ✅ `.env.example` をテンプレートとして提供
- ✅ 強力なパスワードを使用（16文字以上、英数字記号混在）
- ❌ パスワードをコードに直接記述しない

#### 2. WordPressセキュリティ

```php
// wp-config.php に追加するセキュリティ設定

// ファイル編集を無効化 (本番環境)
define( 'DISALLOW_FILE_EDIT', true );

// ファイルモディフィケーションを無効化 (本番環境)
define( 'DISALLOW_FILE_MODS', true );

// SSL強制 (HTTPS環境)
define( 'FORCE_SSL_ADMIN', true );

// 認証キーの設定 (必須)
// https://api.wordpress.org/secret-key/1.1/salt/ から取得
```

#### 3. 定期的なアップデート

- WordPressコア、テーマ、プラグインを最新状態に保つ
- `docker-compose pull` で最新のDockerイメージを取得

### パフォーマンス最適化

#### 1. データベースの最適化

```bash
# 定期的なデータベース最適化
wp db optimize --allow-root

# リビジョンの削除
wp post delete $(wp post list --post_type='revision' --format=ids --allow-root) --force --allow-root

# トランジェントのクリア
wp transient delete --all --allow-root
```

#### 2. キャッシュの活用

推奨プラグイン:
- **WP Super Cache**: ページキャッシュ
- **Redis Object Cache**: オブジェクトキャッシュ

#### 3. 画像の最適化

- **ImageMagick/GD**: 自動リサイズ
- **WebP形式**: 次世代画像フォーマット
- **Lazy Loading**: 遅延読み込み (WordPress 5.5以降標準搭載)

### 開発効率化

#### 1. Git管理の最適化

**推奨 .gitignore**:
```gitignore
# WordPress
wordpress/

# 環境変数
.env

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# バックアップ
*.sql
backups/

# ログ
*.log

# 依存関係
node_modules/
vendor/
```

**カスタムコードのみGit管理**:
```bash
# テーマとプラグインのみを管理する場合
git add wordpress/wp-content/themes/my-theme/
git add wordpress/wp-content/plugins/my-plugin/
```

#### 2. コードスニペット集

**functions.php によく使う関数**:

```php
// カスタム投稿タイプの登録
function register_custom_post_type() {
    register_post_type( 'product', array(
        'labels' => array(
            'name' => '製品',
            'singular_name' => '製品',
        ),
        'public' => true,
        'has_archive' => true,
        'supports' => array( 'title', 'editor', 'thumbnail' ),
    ) );
}
add_action( 'init', 'register_custom_post_type' );

// カスタムタクソノミーの登録
function register_custom_taxonomy() {
    register_taxonomy( 'product_category', 'product', array(
        'label' => '製品カテゴリー',
        'hierarchical' => true,
    ) );
}
add_action( 'init', 'register_custom_taxonomy' );

// ショートコードの作成
function my_button_shortcode( $atts, $content = null ) {
    $atts = shortcode_atts( array(
        'url' => '#',
        'text' => 'クリック',
    ), $atts );
    
    return '<a href="' . esc_url( $atts['url'] ) . '" class="btn">' . esc_html( $atts['text'] ) . '</a>';
}
add_shortcode( 'button', 'my_button_shortcode' );
```

#### 3. WP-CLI活用

**よく使うコマンド**:

```bash
# 投稿の作成
wp post create --post_title="テスト投稿" --post_content="本文" --post_status=publish --allow-root

# ユーザーの作成
wp user create newuser user@example.com --role=editor --user_pass=password --allow-root

# プラグインの一括インストール
wp plugin install query-monitor debug-bar --activate --allow-root

# テーマの切り替え
wp theme activate twentytwentyfour --allow-root

# メディアの再生成
wp media regenerate --yes --allow-root

# サイトのエクスポート
wp export --dir=/workspace/exports --allow-root
```

### テストとデバッグ

#### 1. ユニットテストの導入

```bash
# PHPUnitのインストール
composer require --dev phpunit/phpunit

# WordPressテストスイートのセットアップ
bash bin/install-wp-tests.sh wordpress_test root password mysql latest

# テストの実行
./vendor/bin/phpunit
```

#### 2. コード品質チェック

```bash
# PHP_CodeSnifferのインストール
composer require --dev squizlabs/php_codesniffer

# WordPress Coding Standardsの適用
./vendor/bin/phpcs --standard=WordPress wordpress/wp-content/themes/my-theme/
```

---

## 付録

### 推奨VS Code拡張機能

Dev Containerには以下の拡張機能が自動インストールされます：

- **PHP Intelephense**: PHP言語サポート
- **PHP Debug**: Xdebugサポート
- **WordPress Toolbox**: WordPress開発ツール
- **WordPress Snippet**: WordPressコードスニペット

### 追加で便利な拡張機能

- **GitLens**: Git履歴の可視化
- **Prettier**: コードフォーマッター
- **ESLint**: JavaScriptリンター
- **MySQL**: MySQL管理

### 参考リンク

#### 公式ドキュメント

- [WordPress Codex (日本語)](https://wpdocs.osdn.jp/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [Docker Documentation](https://docs.docker.com/)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)

#### コミュニティ

- [WordPress日本語フォーラム](https://ja.wordpress.org/support/forums/)
- [WordPress Stack Exchange](https://wordpress.stackexchange.com/)

#### 学習リソース

- [WordPress Theme Handbook](https://developer.wordpress.org/themes/)
- [WordPress Plugin Handbook](https://developer.wordpress.org/plugins/)
- [WP-CLI Handbook](https://make.wordpress.org/cli/handbook/)

---

## サポート

### 問題が解決しない場合

1. **GitHubのIssueを確認**: https://github.com/jugeeem/wordpress-with-devcontaier/issues
2. **新しいIssueを作成**: 問題の詳細、エラーメッセージ、環境情報を記載
3. **Discussions**: 質問や議論は https://github.com/jugeeem/wordpress-with-devcontaier/discussions

---

**最終更新**: 2026年1月17日  
**バージョン**: 1.0.0
