# EnablerDAO バックエンド

このディレクトリには、EnablerDAOプラットフォームのバックエンドサービスが含まれています。

## 技術スタック

- Node.js
- Express
- GraphQL
- PostgreSQL
- Redis
- The Graph (ブロックチェーンデータのインデックス)

## 機能

- RESTful API
- GraphQL API
- ブロックチェーンイベントのインデックス作成
- オフチェーンデータの管理
- 認証・認可
- キャッシュ
- バックグラウンドジョブ

## 開発環境のセットアップ

```bash
# 依存関係のインストール
npm install

# 開発サーバーの起動
npm run dev

# テストの実行
npm test

# マイグレーションの実行
npm run migrate
```

## API ドキュメント

APIドキュメントは、Swagger UIを使用して提供されています：

```bash
# Swagger UIの起動
npm run docs
```

その後、ブラウザで `http://localhost:3000/api-docs` にアクセスしてください。