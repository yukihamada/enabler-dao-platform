# EnablerDAO Platform EC2デプロイガイド

このガイドでは、EnablerDAO PlatformをAmazon EC2インスタンスにデプロイする方法について説明します。

## 前提条件

- Amazon EC2インスタンス（Amazon Linux 2またはUbuntu推奨）
- Node.js（v14以上）がインスタンスにインストールされていること
- SSHアクセス

## デプロイ手順

### 1. EC2インスタンスの準備

EC2インスタンスを起動し、以下のパッケージをインストールします：

```bash
# Amazon Linux 2の場合
sudo yum update -y
sudo yum install -y git nodejs npm

# Ubuntuの場合
sudo apt update
sudo apt install -y git nodejs npm
```

Node.jsのバージョンが古い場合は、以下のコマンドでアップグレードします：

```bash
# Node.jsの最新バージョンをインストール
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

PM2（プロセスマネージャー）をインストールします：

```bash
sudo npm install -g pm2
```

### 2. デプロイスクリプトの実行

ローカル環境から、以下のコマンドを実行してEC2インスタンスにデプロイします：

```bash
# SSHキーを使用する場合
npm run deploy:ec2 -- ec2-user@your-ec2-instance.compute.amazonaws.com ~/.ssh/your-key.pem

# SSHキーがSSHエージェントに登録されている場合
npm run deploy:ec2 -- ec2-user@your-ec2-instance.compute.amazonaws.com
```

### 3. アプリケーションへのアクセス

デプロイが完了すると、以下のURLでアプリケーションにアクセスできます：

```
http://your-ec2-instance.compute.amazonaws.com:3000
```

## セキュリティグループの設定

EC2インスタンスのセキュリティグループで、以下のポートを開放してください：

- SSH（22）: デプロイ用
- HTTP（80）: Webアクセス用（オプション、Nginxなどでリバースプロキシを設定する場合）
- アプリケーションポート（3000）: 直接アクセス用

## PM2を使用したアプリケーション管理

EC2インスタンス上でアプリケーションを管理するには、以下のPM2コマンドを使用します：

```bash
# アプリケーションのステータス確認
pm2 status

# ログの表示
pm2 logs enabler-dao-platform

# アプリケーションの再起動
pm2 restart enabler-dao-platform

# アプリケーションの停止
pm2 stop enabler-dao-platform

# アプリケーションの削除
pm2 delete enabler-dao-platform

# PM2の起動時自動起動設定
pm2 startup
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user
pm2 save
```

## トラブルシューティング

### アプリケーションが起動しない

ログを確認します：

```bash
pm2 logs enabler-dao-platform
```

### ポートが既に使用されている

別のプロセスが同じポートを使用している場合は、以下のコマンドで確認し、必要に応じて終了します：

```bash
# ポート3000を使用しているプロセスを確認
sudo lsof -i :3000

# プロセスを終了（PIDは上記コマンドの結果から取得）
sudo kill -9 <PID>
```

### SSHアクセスの問題

SSHキーのパーミッションが正しいことを確認します：

```bash
chmod 400 ~/.ssh/your-key.pem
```