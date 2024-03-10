# forge create --rpc-url "https://sepolia.optimism.io" --private-key "b59fd4c94058d4a51e427c351482e39e3c3a68c6bb6e81a161201b9eea3d8ecd" ./MultiSignatureWallet.sol:MultiSignatureWallet


forge create --rpc-url "https://sepolia.optimism.io" \
  --constructor-args "JD USD Token" "JDUSD" 1000000000000000000000 \
  --private-key "b59fd4c94058d4a51e427c351482e39e3c3a68c6bb6e81a161201b9eea3d8ecd" \
  --etherscan-api-key "MJVM6NURUCH63BJMFKP9DNWQSPUW8W67U6" \
  --verify \
  src/erc20.sol:MyToken
