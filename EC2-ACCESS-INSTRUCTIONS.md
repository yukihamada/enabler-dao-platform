# EC2インスタンスアクセス手順

EC2インスタンスが正常に起動しました。以下の情報を使用してアクセスしてください。

## インスタンス情報

- **インスタンスID**: i-00e9c772dc80728e0
- **リージョン**: ap-northeast-1 (東京)
- **パブリックIP**: 18.183.102.149
- **パブリックDNS**: ec2-18-183-102-149.ap-northeast-1.compute.amazonaws.com

## AWSマネジメントコンソールからのアクセス

1. 以下のURLにアクセスしてください：
   [EC2インスタンス接続ページ](https://ap-northeast-1.console.aws.amazon.com/ec2/home?region=ap-northeast-1#ConnectToInstance:instanceId=i-00e9c772dc80728e0)

2. 「接続」タブを選択し、以下のいずれかの方法でインスタンスに接続できます：
   - **EC2 Instance Connect**: ブラウザベースのSSHクライアント
   - **Session Manager**: AWS Systems Managerを使用した接続
   - **SSH クライアント**: 自分のSSHクライアントを使用

## EC2 Instance Connectを使用する場合

1. 「EC2 Instance Connect」タブを選択
2. ユーザー名は `ec2-user` のままにする
3. 「接続」ボタンをクリック

## アプリケーションのデプロイ

インスタンスに接続したら、以下のコマンドを実行してアプリケーションをデプロイできます：

```bash
# GitHubからリポジトリをクローン
git clone https://github.com/yukihamada/enabler-dao-platform.git
cd enabler-dao-platform

# 依存関係をインストール
npm install

# アプリケーションを起動
npm start
```

## アプリケーションへのアクセス

アプリケーションが起動したら、以下のURLでアクセスできます：

```
http://18.183.102.149:3000
```

## セキュリティに関する注意

このEC2インスタンスは一時的なデモ用に設定されています。本番環境では、以下のセキュリティ対策を実施してください：

1. 強力なパスワードの使用
2. SSHキー認証の使用
3. セキュリティグループの制限
4. 定期的なセキュリティアップデート

## トラブルシューティング

アクセスに問題がある場合は、以下を確認してください：

1. インスタンスのステータスが「実行中」であること
2. セキュリティグループが適切に設定されていること
3. ネットワークACLが通信を許可していること