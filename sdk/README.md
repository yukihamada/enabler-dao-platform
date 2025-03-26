# EnablerDAO SDK

このディレクトリには、EnablerDAOプラットフォームの開発者向けSDKが含まれています。

## 概要

EnablerDAO SDKは、開発者がEnablerDAOプラットフォームと簡単に統合できるようにするためのツールキットです。スマートコントラクトとの対話、APIの利用、一般的なタスクの自動化などの機能を提供します。

## インストール

```bash
npm install @enablerdao/sdk
```

## 使用例

```typescript
import { EnablerDAO } from '@enablerdao/sdk';

// SDKの初期化
const enablerDAO = new EnablerDAO({
  rpcUrl: 'https://mainnet.infura.io/v3/YOUR_INFURA_KEY',
  apiUrl: 'https://api.enablerdao.com',
  privateKey: 'YOUR_PRIVATE_KEY' // オプション
});

// DAOの作成
const dao = await enablerDAO.createDAO({
  name: 'My DAO',
  tokenName: 'MyToken',
  tokenSymbol: 'MTK',
  initialHolders: [
    { address: '0x...', amount: '1000000000000000000000' }
  ]
});

// 提案の作成
const proposal = await dao.createProposal({
  title: 'My Proposal',
  description: 'This is a proposal to...',
  actions: [
    {
      target: '0x...',
      value: '0',
      signature: 'transfer(address,uint256)',
      calldata: enablerDAO.encodeParameters(
        ['address', 'uint256'],
        ['0x...', '1000000000000000000']
      )
    }
  ]
});

// 投票
await proposal.vote(true);

// 提案の実行
await proposal.execute();
```

## モジュール

- `core` - コア機能
- `governance` - ガバナンス関連の機能
- `token` - トークン関連の機能
- `finance` - 財務管理関連の機能
- `utils` - ユーティリティ関数

## ドキュメント

詳細なドキュメントは、[docs/sdk](../docs/sdk)ディレクトリを参照してください。