#!/bin/bash

# AWS認証情報をセットアップするスクリプト
# 注意: このスクリプトは機密情報を扱います。安全に管理してください。

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# ヘルプメッセージ
function show_help {
  echo "AWS認証情報をセットアップするスクリプト"
  echo ""
  echo "使用方法:"
  echo "  $0 [オプション]"
  echo ""
  echo "オプション:"
  echo "  -h, --help                このヘルプメッセージを表示"
  echo "  -k, --key KEY             AWS Access Key ID"
  echo "  -s, --secret SECRET       AWS Secret Access Key"
  echo "  -r, --region REGION       AWS Region (デフォルト: us-east-1)"
  echo "  -b, --bucket BUCKET       S3 Bucket名 (デフォルト: enabler-dao-platform)"
  echo "  -p, --profile PROFILE     AWS Profile名 (デフォルト: default)"
  echo ""
  echo "例:"
  echo "  $0 -k AKIAXXXXXXXX -s abcdefg123456 -r us-west-2 -b my-bucket"
}

# デフォルト値
AWS_REGION="us-east-1"
AWS_S3_BUCKET="enabler-dao-platform"
AWS_PROFILE="default"

# コマンドライン引数の解析
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -h|--help)
      show_help
      exit 0
      ;;
    -k|--key)
      AWS_ACCESS_KEY_ID="$2"
      shift
      shift
      ;;
    -s|--secret)
      AWS_SECRET_ACCESS_KEY="$2"
      shift
      shift
      ;;
    -r|--region)
      AWS_REGION="$2"
      shift
      shift
      ;;
    -b|--bucket)
      AWS_S3_BUCKET="$2"
      shift
      shift
      ;;
    -p|--profile)
      AWS_PROFILE="$2"
      shift
      shift
      ;;
    *)
      echo -e "${RED}エラー: 不明なオプション '$1'${NC}"
      show_help
      exit 1
      ;;
  esac
done

# 必須パラメータのチェック
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo -e "${RED}エラー: AWS Access Key IDとSecret Access Keyは必須です${NC}"
  show_help
  exit 1
fi

# .envファイルの作成
ENV_FILE="../.env"
echo "# AWS認証情報" > $ENV_FILE
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> $ENV_FILE
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> $ENV_FILE
echo "AWS_REGION=$AWS_REGION" >> $ENV_FILE
echo "AWS_S3_BUCKET=$AWS_S3_BUCKET" >> $ENV_FILE

echo -e "${GREEN}.envファイルを作成しました${NC}"

# AWS CLIがインストールされているか確認
if command -v aws &> /dev/null; then
  # AWS認証情報の設定
  mkdir -p ~/.aws
  
  # credentialsファイルの確認
  if [ ! -f ~/.aws/credentials ]; then
    echo "[${AWS_PROFILE}]" > ~/.aws/credentials
    echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> ~/.aws/credentials
    echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> ~/.aws/credentials
  else
    # プロファイルが存在するか確認
    if grep -q "\[${AWS_PROFILE}\]" ~/.aws/credentials; then
      # 既存のプロファイルを更新
      sed -i "/\[${AWS_PROFILE}\]/,/^\[/ s/aws_access_key_id.*/aws_access_key_id = ${AWS_ACCESS_KEY_ID}/" ~/.aws/credentials
      sed -i "/\[${AWS_PROFILE}\]/,/^\[/ s/aws_secret_access_key.*/aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}/" ~/.aws/credentials
    else
      # 新しいプロファイルを追加
      echo "" >> ~/.aws/credentials
      echo "[${AWS_PROFILE}]" >> ~/.aws/credentials
      echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> ~/.aws/credentials
      echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> ~/.aws/credentials
    fi
  fi
  
  # configファイルの確認
  if [ ! -f ~/.aws/config ]; then
    echo "[profile ${AWS_PROFILE}]" > ~/.aws/config
    echo "region = ${AWS_REGION}" >> ~/.aws/config
    echo "output = json" >> ~/.aws/config
  else
    # プロファイルが存在するか確認
    if grep -q "\[profile ${AWS_PROFILE}\]" ~/.aws/config; then
      # 既存のプロファイルを更新
      sed -i "/\[profile ${AWS_PROFILE}\]/,/^\[/ s/region.*/region = ${AWS_REGION}/" ~/.aws/config
    else
      # 新しいプロファイルを追加
      echo "" >> ~/.aws/config
      echo "[profile ${AWS_PROFILE}]" >> ~/.aws/config
      echo "region = ${AWS_REGION}" >> ~/.aws/config
      echo "output = json" >> ~/.aws/config
    fi
  fi
  
  echo -e "${GREEN}AWS CLIの認証情報を設定しました${NC}"
  
  # 認証情報のテスト
  echo -e "${YELLOW}AWS認証情報をテストしています...${NC}"
  if aws sts get-caller-identity --profile $AWS_PROFILE &> /dev/null; then
    echo -e "${GREEN}AWS認証情報は有効です${NC}"
  else
    echo -e "${RED}AWS認証情報が無効です。設定を確認してください${NC}"
  fi
else
  echo -e "${YELLOW}AWS CLIがインストールされていません。.envファイルのみ作成しました${NC}"
fi

echo -e "${GREEN}セットアップが完了しました${NC}"