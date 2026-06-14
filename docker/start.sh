#!/bin/sh
# SafeSplit blockchain container: start Hardhat node, wait for RPC, deploy HashStore.
set -e

cd /app

echo "==> npm install"
npm install

echo "==> starting hardhat node (0.0.0.0:8545)"
npx hardhat node --hostname 0.0.0.0 &
HARDHAT_PID=$!

echo "==> waiting for JSON-RPC on 127.0.0.1:8545"
until node -e "fetch('http://127.0.0.1:8545',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({jsonrpc:'2.0',id:1,method:'eth_chainId',params:[]})}).then(r=>r.ok?process.exit(0):process.exit(1)).catch(()=>process.exit(1))" 2>/dev/null; do
  sleep 1
done

echo "==> deploying HashStore"
npx hardhat run scripts/deploy.js --network localhost

echo "==> hardhat ready"
wait $HARDHAT_PID
