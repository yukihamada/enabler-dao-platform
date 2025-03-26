/**
 * EnablerDAO Platform サーバー
 */

const express = require('express');
const path = require('path');
const fs = require('fs');

// 環境変数の読み込み
require('dotenv').config();

// アプリケーションの初期化
const app = express();
const PORT = process.env.PORT || 3000;

// 静的ファイルの提供
app.use(express.static(path.join(__dirname, 'frontend/build')));

// APIルート
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.get('/api/info', (req, res) => {
  res.json({
    name: 'EnablerDAO Platform',
    version: '0.1.0',
    environment: process.env.NODE_ENV || 'development'
  });
});

// フロントエンドのルーティング
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'frontend/build/index.html'));
});

// サーバーの起動
app.listen(PORT, () => {
  console.log(`EnablerDAO Platform サーバーが起動しました: http://localhost:${PORT}`);
});