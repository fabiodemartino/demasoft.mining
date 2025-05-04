import os
import time
import requests
from rich.console import Console
from rich.table import Table
from dotenv import load_dotenv

# Load .env file
# load_dotenv(".env.gpu-p2p")
load_dotenv(r"C:\source\repos\DemaSoftAI\Mining\Monero\.env.gpu-p2p")

# Load environment variables
WALLET_ADDRESS = os.getenv("POOL_USER")
POOL_PASS = os.getenv("POOL_PASS", "N/A")
DONATE_LEVEL = os.getenv("DONATE_LEVEL", "N/A")
P2POOL_STATS_URL = os.getenv("P2POOL_STATS_URL", "http://localhost:3333")

print(f"Wallet Address: {WALLET_ADDRESS}")
print(f"Pool Pass: {POOL_PASS}")
print(f"Donate Level: {DONATE_LEVEL}")
print(f"P2Pool Stats URL: {P2POOL_STATS_URL}")

console = Console()

def get_p2pool_stats():
    try:
        resp = requests.get(P2POOL_STATS_URL, timeout=5)
        return resp.json()
    except Exception as e:
        return {"error": str(e)}

def display(stats):
    table = Table(title="Monero P2Pool Miner Dashboard", expand=True)
    table.add_column("Metric", style="cyan", justify="right")
    table.add_column("Value", style="magenta")

    if "error" in stats:
        table.add_row("Error", stats["error"])
    elif WALLET_ADDRESS not in stats.get("miners", {}):
        table.add_row("Status", "Waiting for shares...")
    else:
        miner = stats["miners"][WALLET_ADDRESS]
        table.add_row("Address", WALLET_ADDRESS)
        table.add_row("Hashrate", f'{miner["hashrate"]:.2f} H/s')
        table.add_row("Difficulty", str(miner["difficulty"]))
        table.add_row("Shares", str(miner["shares"]))
        table.add_row("Blocks Found", str(miner.get("blocks_found", 0)))
        table.add_row("Donate Level", f"{DONATE_LEVEL}%")
        table.add_row("Worker Tag", POOL_PASS)

    console.clear()
    console.print(table)

def main():
    while True:
        stats = get_p2pool_stats()
        display(stats)
        time.sleep(5)

if __name__ == "__main__":
    main()
