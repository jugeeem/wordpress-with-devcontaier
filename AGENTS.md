# WordPress 開発 AI エージェント支援ガイド

このドキュメントは、AIエージェント（GitHub Copilot）を活用してWordPress開発を効率的に進めるためのガイドラインです。

## 📋 目次

1. [基本方針](#基本方針)
2. [コミュニケーション規約](#コミュニケーション規約)
3. [Git/GitHub 運用ルール](#gitgithub-運用ルール)
4. [WordPress 開発ガイドライン](#wordpress-開発ガイドライン)
5. [AIエージェントへの依頼方法](#aiエージェントへの依頼方法)
6. [セキュリティとベストプラクティス](#セキュリティとベストプラクティス)

---

## 基本方針

### コミュニケーション言語
- **必ず日本語で会話すること**
- コード内のコメントも日本語で記述
- ドキュメント、README、コミットメッセージも日本語

### 開発環境
- Dev Container を使用した統一開発環境
- WordPress コアファイルは `wordpress/` ディレクトリに配置
- カスタム開発は `wp-content/` 以下で実施

---

## コミュニケーション規約

### AIエージェントとのやり取り

#### 質問する際の原則
- **具体的に**: 「〇〇の機能を実装したい」ではなく「〇〇プラグインに△△という機能を追加したい」
- **コンテキストを提供**: 関連ファイルを添付または言及
- **期待する結果を明示**: 「動くコードが欲しい」「説明が欲しい」「レビューが欲しい」など

#### AIエージェントに依頼できる主なタスク
- コードの実装・修正・リファクタリング
- バグの調査と修正
- セキュリティ脆弱性のチェック
- WordPress Codex/Developer Handbook に基づいたベストプラクティスの提案
- プラグイン/テーマの新規作成
- データベースクエリの最適化
- Git/GitHub操作の自動化

---

## Git/GitHub 運用ルール

### Git 操作の優先順位

Git関連の操作は以下の優先順位で実行してください:

1. **GitHub MCP (最優先)**
   - GitHub MCPツールが利用可能な場合は最優先で使用
   - Issue作成、PR作成、レビュー依頼など
   
2. **gh command (次点)**
   - GitHub MCPが使えない場合は `gh` コマンドを使用
   - `gh issue create`, `gh pr create` など
   
3. **Markdown記述 (最終手段)**
   - 上記2つが使えない場合のみ、手動での操作をMarkdownで指示

### ブランチ戦略

#### ブランチモデル: GitHub Flow

```
main (保護ブランチ)
  ↑
  └── feature/機能名
  └── fix/バグ修正名
  └── hotfix/緊急修正名
```

#### ブランチ命名規則

| プレフィックス | 用途 | 例 |
|--------------|------|-----|
| `feature/` | 新機能開発 | `feature/user-profile-widget` |
| `fix/` | バグ修正 | `fix/login-redirect-error` |
| `hotfix/` | 緊急修正（本番障害） | `hotfix/security-patch-xss` |
| `refactor/` | リファクタリング | `refactor/database-query-optimization` |
| `docs/` | ドキュメント更新 | `docs/update-readme` |
| `test/` | テスト追加・修正 | `test/add-unit-tests-user-model` |

#### ブランチ運用ルール

1. **main ブランチ**
   - 常にデプロイ可能な状態を保つ
   - 直接コミット禁止
   - マージは必ずPR経由

2. **作業ブランチ**
   - `main` から切る
   - 1機能/1修正 = 1ブランチ
   - 作業完了後は速やかにPRを作成
   - マージ後は削除

3. **コミットメッセージ**
   ```
   [種別] 概要（50文字以内）
   
   詳細説明（任意）
   - 変更内容
   - 影響範囲
   - 関連Issue: #123
   ```
   
   **種別の例:**
   - `[feat]` 新機能
   - `[fix]` バグ修正
   - `[refactor]` リファクタリング
   - `[docs]` ドキュメント
   - `[test]` テスト
   - `[chore]` その他（設定変更など）

### GitHub Issue 規約

#### Issue作成時のルール

1. **必須項目**
   - タイトル: 簡潔かつ具体的に（例: 「ログイン時にエラーが発生する」）
   - 説明: 問題の詳細、再現手順、期待する動作
   - ラベル: 適切なラベルを付与

2. **Issueテンプレート**

```markdown
## 概要
<!-- 何を実現したいか、何が問題か -->

## 詳細
<!-- 具体的な内容 -->

## 再現手順（バグの場合）
1. 
2. 
3. 

## 期待する動作
<!-- どうあるべきか -->

## 現在の動作（バグの場合）
<!-- 何が起きているか -->

## 環境
- WordPress バージョン:
- PHP バージョン:
- ブラウザ（該当する場合）:

## 追加情報
<!-- スクリーンショット、エラーログなど -->

## 関連
- 関連Issue: #
- 参考URL:
```

#### ラベル体系

| ラベル | 説明 |
|-------|------|
| `bug` | バグ報告 |
| `enhancement` | 機能追加・改善 |
| `documentation` | ドキュメント関連 |
| `security` | セキュリティ関連 |
| `performance` | パフォーマンス改善 |
| `priority:high` | 優先度高 |
| `priority:medium` | 優先度中 |
| `priority:low` | 優先度低 |
| `good first issue` | 初心者向け |
| `help wanted` | 協力者募集 |
| `wontfix` | 対応しない |
| `duplicate` | 重複 |

### GitHub Pull Request (PR) 規約

#### PR作成時のルール

1. **タイトル**
   - Issueと同様の形式: `[種別] 概要`
   - 例: `[feat] ユーザープロフィールウィジェットを追加`

2. **説明（必須項目）**
   ```markdown
   ## 変更内容
   <!-- 何を変更したか -->
   
   ## 関連Issue
   Closes #123
   <!-- または Fixes #123, Resolves #123 -->
   
   ## 変更の種類
   - [ ] バグ修正
   - [ ] 新機能
   - [ ] リファクタリング
   - [ ] ドキュメント更新
   
   ## テスト
   - [ ] ローカル環境でテスト済み
   - [ ] ユニットテスト追加
   - [ ] 既存テストが全てパス
   
   ## チェックリスト
   - [ ] コードは WordPress Coding Standards に準拠
   - [ ] セキュリティリスクを確認
   - [ ] ドキュメントを更新（必要な場合）
   - [ ] コミットメッセージは明確
   
   ## スクリーンショット（該当する場合）
   <!-- UI変更がある場合 -->
   
   ## 補足
   <!-- その他の情報 -->
   ```

3. **PRのライフサイクル**
   ```
   Draft PR作成 → 実装 → Ready for Review → レビュー依頼 → 
   修正対応 → 承認 → マージ → ブランチ削除
   ```

4. **レビュー規約**
   - 最低1名の承認が必要
   - AI レビュー（Copilot）を活用
   - セルフレビューを先に実施
   - レビュー観点: コード品質、セキュリティ、パフォーマンス、WordPress標準準拠

5. **マージ方法**
   - **Squash and Merge** (推奨): 細かいコミットを1つにまとめる
   - **Merge Commit**: 履歴を残したい場合
   - **Rebase and Merge**: 直線的な履歴にしたい場合

---

## WordPress 開発ガイドライン

### ディレクトリ構造

```
wordpress-with-devcontainer/
├── .devcontainer/          # Dev Container設定
├── wordpress/              # WordPressコア（編集禁止）
│   ├── wp-admin/
│   ├── wp-includes/
│   └── wp-content/         # カスタム開発エリア
│       ├── plugins/        # プラグイン開発
│       │   └── my-plugin/
│       ├── themes/         # テーマ開発
│       │   └── my-theme/
│       └── uploads/        # アップロードファイル
├── AGENTS.md              # このファイル
└── README.md
```

### コーディング規約

#### WordPress Coding Standards 準拠
- [WordPress PHP Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/)
- [WordPress JavaScript Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/javascript/)
- [WordPress CSS Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/css/)

#### 必須ルール

1. **セキュリティ**
   - すべての出力を `esc_html()`, `esc_attr()`, `esc_url()` でエスケープ
   - データベースクエリには `$wpdb->prepare()` を使用
   - nonce による CSRF 対策
   - 権限チェック `current_user_can()`

2. **国際化 (i18n)**
   - すべてのテキストを翻訳関数で囲む: `__()`, `_e()`, `esc_html__()`
   - テキストドメインを統一

3. **データベース操作**
   - WordPress関数を優先: `get_posts()`, `get_terms()` など
   - 直接SQL実行は最小限に
   - トランザクション処理に注意

4. **フック活用**
   - アクションフック: `add_action()`
   - フィルターフック: `add_filter()`
   - カスタムフックの作成: `do_action()`, `apply_filters()`

### プラグイン開発

#### プラグインの基本構造
```php
<?php
/**
 * Plugin Name: プラグイン名
 * Plugin URI: https://example.com/plugin
 * Description: プラグインの説明
 * Version: 1.0.0
 * Author: 作者名
 * Author URI: https://example.com
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: my-plugin
 * Domain Path: /languages
 */

// 直接アクセスを防ぐ
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

// プラグインのメイン処理
```

### テーマ開発

#### テーマの必須ファイル
- `style.css` - テーマ情報とスタイル
- `index.php` - メインテンプレート
- `functions.php` - テーマ機能

#### テーマの推奨ファイル
- `header.php`, `footer.php`, `sidebar.php`
- `single.php`, `page.php`, `archive.php`
- `404.php`, `search.php`

---

## AIエージェントへの依頼方法

### 効果的な依頼例

#### ❌ 悪い例
```
「ログイン機能を作って」
```

#### ✅ 良い例
```
「wp-content/plugins/custom-login/ に、以下の機能を持つログインプラグインを作成してください:

1. ショートコード [custom_login] でフロントエンドにログインフォームを表示
2. ログイン成功後は /dashboard にリダイレクト
3. ログイン失敗時はエラーメッセージを表示
4. nonce によるCSRF対策を実装
5. WordPress Coding Standards に準拠

関連ファイル: wordpress/wp-login.php を参考にしてください。」
```

### タスク別の依頼テンプレート

#### コード実装
```
「[実装場所] に [機能] を実装してください。

要件:
- 要件1
- 要件2

制約:
- 制約1
- 制約2

参考: [関連ファイル・URL]」
```

#### バグ修正
```
「[ファイル名] の [行番号付近/関数名] でエラーが発生しています。

エラー内容:
[エラーメッセージ]

再現手順:
1. 〜する
2. 〜する
3. エラー発生

期待する動作:
[正しい動作]

調査と修正をお願いします。」
```

#### コードレビュー
```
「[ファイル名] のコードをレビューしてください。

レビュー観点:
- セキュリティ
- パフォーマンス
- WordPress標準準拠
- コード品質

特に [具体的な懸念点] について確認をお願いします。」
```

#### リファクタリング
```
「[ファイル名] をリファクタリングしてください。

目的:
- 可読性向上
- 保守性向上
- パフォーマンス改善

既存の動作は維持してください。」
```

---

## セキュリティとベストプラクティス

### セキュリティチェックリスト

- [ ] すべての出力をエスケープ処理
- [ ] SQLインジェクション対策（`$wpdb->prepare()`使用）
- [ ] XSS対策（`wp_kses()`, `esc_*()` 使用）
- [ ] CSRF対策（nonce検証）
- [ ] 権限チェック（`current_user_can()`）
- [ ] ファイルアップロード検証
- [ ] 直接ファイルアクセスの防止（`ABSPATH` チェック）

### パフォーマンス最適化

- [ ] データベースクエリの最小化
- [ ] トランジェントAPIの活用（キャッシュ）
- [ ] 不要なアセット（CSS/JS）の読み込み回避
- [ ] 画像の最適化
- [ ] lazyloadの実装

### WordPress API 活用

- Settings API: 設定画面の作成
- Options API: オプションの保存・取得
- Transients API: 一時データのキャッシュ
- HTTP API: 外部APIとの通信
- Filesystem API: ファイル操作
- Cron API: スケジュールタスク

---

## 開発ワークフロー例

### 新機能開発の流れ

1. **Issue作成**
   ```bash
   # GitHub MCPで Issue作成
   # または
   gh issue create --title "[feat] 新機能名" --body "詳細"
   ```

2. **ブランチ作成**
   ```bash
   git checkout -b feature/new-feature
   ```

3. **実装（AIエージェントと協働）**
   - AIに具体的な要件を伝える
   - 生成されたコードをレビュー
   - テスト実施

4. **コミット**
   ```bash
   git add .
   git commit -m "[feat] 新機能を追加

   - 機能1を実装
   - 機能2を実装
   
   Refs: #123"
   ```

5. **プッシュとPR作成**
   ```bash
   git push origin feature/new-feature
   # GitHub MCPでPR作成
   # または
   gh pr create --title "[feat] 新機能名" --body "PRテンプレートに従って記入"
   ```

6. **レビュー依頼（Copilot活用）**
   - AIレビューを実行
   - 人間レビューアーをアサイン

7. **マージ**
   - 承認後、Squash and Merge

8. **ブランチ削除**
   ```bash
   git branch -d feature/new-feature
   ```

---

## トラブルシューティング

### よくある問題と解決方法

#### 1. WordPress関数が見つからない
```php
// 解決: WordPressを読み込む
require_once(ABSPATH . 'wp-load.php');
```

#### 2. データベースエラー
```php
// 解決: エラー内容を確認
global $wpdb;
echo $wpdb->last_error;
```

#### 3. プラグインが動作しない
- プラグインヘッダーを確認
- PHPエラーログを確認
- 他のプラグインとの競合を確認

---

## 参考リソース

### 公式ドキュメント
- [WordPress Developer Handbook](https://developer.wordpress.org/)
- [WordPress Codex](https://codex.wordpress.org/)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)

### ツール
- [WordPress Plugin Boilerplate](https://github.com/DevinVinson/WordPress-Plugin-Boilerplate)
- [Query Monitor](https://ja.wordpress.org/plugins/query-monitor/) - デバッグプラグイン
- [Debug Bar](https://ja.wordpress.org/plugins/debug-bar/) - デバッグツール

---

## バージョン管理

このドキュメントのバージョン: **1.0.0**  
最終更新日: 2026年1月17日

### 変更履歴
- 2026-01-17: 初版作成

---

## フィードバック

このガイドに関する改善提案は、Issue または PR でお知らせください。

**Happy WordPress Development with AI! 🚀**