# EnablerDAO Platform デプロイガイド

このガイドでは、EnablerDAO Platformをデプロイする方法について説明します。

## 前提条件

- Node.js (v14以上)
- npm または yarn
- AWS アカウント
- AWS CLI (オプション)

## AWS認証情報の設定

デプロイには、AWS認証情報が必要です。以下のいずれかの方法で設定できます。

### 方法1: セットアップスクリプトを使用する

提供されているセットアップスクリプトを使用して、AWS認証情報を設定できます。

```bash
# スクリプトを実行可能にする
chmod +x scripts/setup-aws.sh

# スクリプトを実行する
./scripts/setup-aws.sh -k YOUR_ACCESS_KEY_ID -s YOUR_SECRET_ACCESS_KEY -r YOUR_REGION -b YOUR_BUCKET_NAME
```

### 方法2: 手動で.envファイルを作成する

プロジェクトのルートディレクトリに`.env`ファイルを作成し、以下の内容を追加します。

```
AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY
AWS_REGION=YOUR_REGION
AWS_S3_BUCKET=YOUR_BUCKET_NAME
```

### 方法3: 環境変数を設定する

環境変数を直接設定することもできます。

```bash
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY
export AWS_REGION=YOUR_REGION
export AWS_S3_BUCKET=YOUR_BUCKET_NAME
```

## フロントエンドのビルド

デプロイする前に、フロントエンドをビルドする必要があります。

```bash
# フロントエンドディレクトリに移動
cd frontend

# 依存関係をインストール
npm install

# ビルドを実行
npm run build
```

## デプロイ

フロントエンドのビルドが完了したら、デプロイスクリプトを実行します。

```bash
# プロジェクトのルートディレクトリに戻る
cd ..

# 依存関係をインストール
npm install

# デプロイを実行
npm run deploy
```

デフォルトでは、`frontend/build`ディレクトリの内容が指定されたS3バケットにデプロイされます。

## カスタムデプロイ

デプロイするディレクトリをカスタマイズする場合は、環境変数`DEPLOY_DIR`を設定します。

```bash
DEPLOY_DIR=./path/to/your/build npm run deploy
```

## トラブルシューティング

### バケットが存在しない

エラーメッセージ: `Bucket YOUR_BUCKET_NAME does not exist or you don't have access to it.`

解決策:
1. AWS Management Consoleにログインし、指定したバケットが存在することを確認します。
2. バケットが存在しない場合は、作成します。
3. バケットへのアクセス権限があることを確認します。

### 認証情報が無効

エラーメッセージ: `The AWS Access Key Id you provided does not exist in our records.`

解決策:
1. AWS認証情報が正しいことを確認します。
2. IAMコンソールで認証情報を確認または再生成します。

### 権限が不足している

エラーメッセージ: `Access Denied`

解決策:
1. 使用しているIAMユーザーまたはロールに、S3バケットへの書き込み権限があることを確認します。
2. 必要に応じて、以下のようなポリシーをIAMユーザーに追加します。

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::YOUR_BUCKET_NAME",
        "arn:aws:s3:::YOUR_BUCKET_NAME/*"
      ]
    }
  ]
}
```

## セキュリティに関する注意

- AWS認証情報は機密情報です。`.env`ファイルをGitリポジトリにコミットしないでください。
- 本番環境では、IAMロールを使用することをお勧めします。
- 最小権限の原則に従い、必要最小限の権限を持つIAMユーザーまたはロールを使用してください。