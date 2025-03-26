# EnablerDAO フロントエンド

このディレクトリには、EnablerDAOプラットフォームのウェブインターフェースが含まれています。

## 技術スタック

- React
- TypeScript
- ethers.js
- Tailwind CSS
- Next.js

## 機能

- DAO作成・管理インターフェース
- ガバナンスダッシュボード（提案・投票）
- トークン管理
- 財務ダッシュボード
- メンバー管理
- アクティビティフィード

## 開発環境のセットアップ

```bash
# 依存関係のインストール
npm install

# 開発サーバーの起動
npm run dev

# ビルド
npm run build

# テストの実行
npm test
```

## デザインシステム

UIコンポーネントは再利用可能なコンポーネントライブラリとして実装されています。Storybookを使用してコンポーネントをプレビューできます：

```bash
npm run storybook
```