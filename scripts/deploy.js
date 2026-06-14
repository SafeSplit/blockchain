/**
 * Deploy HashStore to the running Hardhat node and export its address + ABI
 * to deployments/deployment.json (shared file — decision D7), so the Laravel
 * app (and later the Go nodes) can read where the contract lives.
 */
const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

// Host-facing RPC URL (the Docker port mapping). Overridable via env.
const RPC_URL = process.env.SAFESPLIT_RPC_URL || "http://localhost:49545";

async function main() {
  const Factory = await hre.ethers.getContractFactory("HashStore");
  const store = await Factory.deploy();
  await store.waitForDeployment();
  const address = await store.getAddress();

  const artifact = await hre.artifacts.readArtifact("HashStore");

  const outDir = path.join(__dirname, "..", "deployments");
  fs.mkdirSync(outDir, { recursive: true });

  const info = {
    network: "SafeSplit Local",
    rpcUrl: RPC_URL,
    chainId: 31337,
    contract: "HashStore",
    address,
    abi: artifact.abi,
  };

  fs.writeFileSync(
    path.join(outDir, "deployment.json"),
    JSON.stringify(info, null, 2),
  );

  console.log("HashStore deployed at:", address);
  console.log("→ deployments/deployment.json written");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
