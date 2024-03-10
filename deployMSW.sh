# forge create --rpc-url "https://sepolia.optimism.io" --private-key "b59fd4c94058d4a51e427c351482e39e3c3a68c6bb6e81a161201b9eea3d8ecd" ./MultiSignatureWallet.sol:MultiSignatureWallet


forge create --rpc-url "https://sepolia.optimism.io" \
  --constructor-args "0x35c5887Da1Fc7473a02c67358E4947CA5b9AC5Bd" \
  --private-key "b59fd4c94058d4a51e427c351482e39e3c3a68c6bb6e81a161201b9eea3d8ecd" \
  --etherscan-api-key "MJVM6NURUCH63BJMFKP9DNWQSPUW8W67U6" \
  --verify \
  src/MultiSignatureWallet.sol:MultiSignatureWallet
