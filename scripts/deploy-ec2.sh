#!/bin/bash

# EC2インスタンスにデプロイするスクリプト
# 使用方法: ./scripts/deploy-ec2.sh <EC2_HOST> <SSH_KEY_PATH>

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 引数のチェック
if [ $# -lt 1 ]; then
    echo -e "${RED}エラー: EC2ホスト名が必要です${NC}"
    echo "使用方法: $0 <EC2_HOST> [SSH_KEY_PATH]"
    echo "例: $0 ec2-user@ec2-12-34-56-78.compute-1.amazonaws.com ~/.ssh/my-key.pem"
    exit 1
fi

EC2_HOST=$1
SSH_KEY_PATH=$2
SSH_OPTIONS=""

if [ ! -z "$SSH_KEY_PATH" ]; then
    if [ ! -f "$SSH_KEY_PATH" ]; then
        echo -e "${RED}エラー: SSH鍵ファイル '$SSH_KEY_PATH' が見つかりません${NC}"
        exit 1
    fi
    SSH_OPTIONS="-i $SSH_KEY_PATH"
fi

# リポジトリのルートディレクトリを取得
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ $? -ne 0 ]; then
    REPO_ROOT=$(pwd)
fi

echo -e "${YELLOW}EnablerDAO Platformをデプロイします...${NC}"
echo -e "ホスト: ${EC2_HOST}"

# 一時的なデプロイディレクトリを作成
DEPLOY_DIR=$(mktemp -d)
echo -e "一時デプロイディレクトリ: ${DEPLOY_DIR}"

# 必要なファイルをコピー
echo -e "${YELLOW}必要なファイルをコピーしています...${NC}"
cp -r $REPO_ROOT/* $DEPLOY_DIR/
rm -rf $DEPLOY_DIR/node_modules $DEPLOY_DIR/.git

# .envファイルが存在する場合は削除（機密情報を含むため）
if [ -f "$DEPLOY_DIR/.env" ]; then
    rm $DEPLOY_DIR/.env
fi

# デプロイパッケージを作成
echo -e "${YELLOW}デプロイパッケージを作成しています...${NC}"
DEPLOY_PACKAGE="enabler-dao-platform.tar.gz"
cd $DEPLOY_DIR
tar -czf $DEPLOY_PACKAGE *
cd - > /dev/null

# EC2インスタンスに接続してデプロイ
echo -e "${YELLOW}EC2インスタンスに接続しています...${NC}"

# EC2インスタンスに接続できるか確認
ssh $SSH_OPTIONS -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=accept-new $EC2_HOST "echo 'Connection successful'" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}エラー: EC2インスタンスに接続できません${NC}"
    echo "SSH接続設定を確認してください"
    rm -rf $DEPLOY_DIR
    exit 1
fi

# デプロイディレクトリを作成
echo -e "${YELLOW}EC2インスタンスにデプロイディレクトリを作成しています...${NC}"
ssh $SSH_OPTIONS $EC2_HOST "mkdir -p ~/enabler-dao-platform"

# パッケージをアップロード
echo -e "${YELLOW}パッケージをアップロードしています...${NC}"
scp $SSH_OPTIONS $DEPLOY_DIR/$DEPLOY_PACKAGE $EC2_HOST:~/enabler-dao-platform/

# パッケージを展開し、アプリケーションをセットアップ
echo -e "${YELLOW}パッケージを展開し、アプリケーションをセットアップしています...${NC}"
ssh $SSH_OPTIONS $EC2_HOST "cd ~/enabler-dao-platform && \
    tar -xzf $DEPLOY_PACKAGE && \
    rm $DEPLOY_PACKAGE && \
    npm install && \
    echo 'export PORT=3000' > .env"

# アプリケーションを起動
echo -e "${YELLOW}アプリケーションを起動しています...${NC}"
ssh $SSH_OPTIONS $EC2_HOST "cd ~/enabler-dao-platform && \
    pm2 stop enabler-dao-platform 2>/dev/null || true && \
    pm2 delete enabler-dao-platform 2>/dev/null || true && \
    pm2 start npm --name enabler-dao-platform -- start || \
    (echo 'PM2がインストールされていません。インストールしています...' && \
    npm install -g pm2 && \
    pm2 start npm --name enabler-dao-platform -- start)"

# 一時ディレクトリを削除
rm -rf $DEPLOY_DIR

echo -e "${GREEN}デプロイが完了しました！${NC}"
echo -e "アプリケーションは http://$EC2_HOST:3000 で実行されています"