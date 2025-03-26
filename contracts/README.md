# EnablerDAO スマートコントラクト

このディレクトリには、EnablerDAOプラットフォームのスマートコントラクトが含まれています。

## 構成

- `core/` - DAOの基本機能を提供するコアコントラクト
- `governance/` - ガバナンス関連のコントラクト
- `token/` - トークン関連のコントラクト
- `finance/` - 財務管理関連のコントラクト
- `interfaces/` - コントラクトインターフェース
- `libraries/` - 共通ライブラリ
- `test/` - テストスクリプト

## 開発環境のセットアップ

```bash
# 依存関係のインストール
npm install

# テストの実行
npx hardhat test

# ローカルネットワークの起動
npx hardhat node

# コントラクトのデプロイ
npx hardhat run scripts/deploy.js --network <network-name>
```

## セキュリティ

すべてのコントラクトは、デプロイ前に厳格なセキュリティ監査を受けます。脆弱性を発見した場合は、責任ある開示をお願いします。