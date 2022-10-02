#  LaboDappSwiftUI

## 概要

## ビルド準備
- AppConstants.swiftに、自身で取得したAPIKeyを入力する
- Wallet Connect v2に対応するウォレットアプリをiOS端末にインストール
 - [対応ウォレット一覧](https://explorer.walletconnect.com/?type=wallet&version=2)

## 使用技術

- Xcode 14.0.1
- Swift 5
- SwiftUI
- Swift Package Manager
- WalletConnect
- web3.swift 0.9.3

## 機能一覧

- WalletConnectを利用して、Ethereumアドレスに接続
- Ethereum上のスマートコントラクトのgetメソッドを呼び出す
- Ethereum上のスマートコントラクトのsetメソッドを呼び出す
