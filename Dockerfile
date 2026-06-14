# SafeSplit — local Ethereum (Hardhat)
FROM node:22

WORKDIR /app

# 8545 = Hardhat JSON-RPC
EXPOSE 8545

# Dependencies + contract are mounted as a volume; start.sh installs and runs.
CMD ["sh", "./docker/start.sh"]
