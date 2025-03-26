/**
 * AWS S3へのデプロイスクリプト
 * 
 * 注意: このスクリプトは.envファイルから環境変数を読み込みます
 */

require('dotenv').config();
const AWS = require('aws-sdk');
const fs = require('fs');
const path = require('path');
const mime = require('mime-types');

// AWS認証情報の設定
const s3 = new AWS.S3({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  region: process.env.AWS_REGION || 'us-east-1'
});

// バケット名
const BUCKET_NAME = process.env.AWS_S3_BUCKET || 'enabler-dao-platform';

// デプロイするディレクトリ
const DEPLOY_DIR = process.env.DEPLOY_DIR || path.join(__dirname, '../frontend/build');

/**
 * ファイルをS3にアップロードする
 * @param {string} filePath - ファイルパス
 * @param {string} key - S3のキー
 * @returns {Promise} - アップロード結果のPromise
 */
async function uploadFile(filePath, key) {
  const fileContent = fs.readFileSync(filePath);
  const contentType = mime.lookup(filePath) || 'application/octet-stream';
  
  const params = {
    Bucket: BUCKET_NAME,
    Key: key,
    Body: fileContent,
    ContentType: contentType
  };
  
  try {
    const data = await s3.upload(params).promise();
    console.log(`File uploaded successfully: ${data.Location}`);
    return data;
  } catch (err) {
    console.error(`Error uploading file: ${err.message}`);
    throw err;
  }
}

/**
 * ディレクトリ内のすべてのファイルをS3にアップロードする
 * @param {string} directory - ディレクトリパス
 * @param {string} prefix - S3のプレフィックス
 * @returns {Promise} - アップロード結果のPromise
 */
async function uploadDirectory(directory, prefix = '') {
  const files = fs.readdirSync(directory);
  
  for (const file of files) {
    const filePath = path.join(directory, file);
    const stats = fs.statSync(filePath);
    
    if (stats.isDirectory()) {
      await uploadDirectory(filePath, path.join(prefix, file));
    } else {
      const key = path.join(prefix, file);
      await uploadFile(filePath, key);
    }
  }
}

/**
 * メイン関数
 */
async function main() {
  try {
    console.log(`Deploying ${DEPLOY_DIR} to S3 bucket ${BUCKET_NAME}...`);
    
    // ディレクトリが存在するか確認
    if (!fs.existsSync(DEPLOY_DIR)) {
      console.error(`Directory ${DEPLOY_DIR} does not exist.`);
      process.exit(1);
    }
    
    // S3バケットが存在するか確認
    try {
      await s3.headBucket({ Bucket: BUCKET_NAME }).promise();
    } catch (err) {
      console.error(`Bucket ${BUCKET_NAME} does not exist or you don't have access to it.`);
      process.exit(1);
    }
    
    // ディレクトリをアップロード
    await uploadDirectory(DEPLOY_DIR);
    
    console.log('Deployment completed successfully!');
  } catch (err) {
    console.error(`Deployment failed: ${err.message}`);
    process.exit(1);
  }
}

// スクリプトの実行
main();