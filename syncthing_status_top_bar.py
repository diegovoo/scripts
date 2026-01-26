#!/usr/bin/env python3
import urllib.request
import json
import sys

import env

API_KEY = env.SYNCTHING_API_KEY
URL_BASE = "http://127.0.0.1:8384"

def get_syncthing_data(endpoint):
    try:
        req = urllib.request.Request(f"{URL_BASE}{endpoint}")
        req.add_header("X-API-Key", API_KEY)
        with urllib.request.urlopen(req, timeout=2) as response:
            if response.status == 200:
                return json.loads(response.read().decode())
    except Exception:
        return None
    
def to_subscript(n):
    subs = "₀₁₂₃₄₅₆₇₈₉"
    return "".join(subs[int(d)] for d in str(n))

def main():
    # Syncthing is offline
    raw_connections = get_syncthing_data("/rest/system/connections")
    if not raw_connections:
        sys.exit(0)

    # Get connected devices
    connections_map = raw_connections.get("connections", {})
    active_device_ids = [
        device_id for device_id, data in connections_map.items()
        if isinstance(data, dict) and not data.get("paused", False) 
        and (data.get("connected", False) or data.get("address") or data.get("clientAddr"))
    ]
    
    # No devices connected
    if not active_device_ids:
        sys.exit(0)
    

    config = get_syncthing_data("/rest/system/config")
    if not config:
        print(f"⚠  {to_subscript(len(active_device_ids))}")
        sys.exit(0)
    
    folders = config.get("folders", [])
    
    for folder in folders:
        f_id = folder.get("id")
        
        # Local state is syncing/scanning
        status_data = get_syncthing_data(f"/rest/db/status?folder={f_id}")
        if status_data and status_data.get("state", "idle") not in ["idle", "paused"]:
            print(f"  {to_subscript(len(active_device_ids))}")
            sys.exit(0)
        
        # Remote state is incomplete
        folder_devices = [d.get("deviceID") for d in folder.get("devices", [])]
        for dev_id in folder_devices:
            if dev_id in active_device_ids:
                comp_data = get_syncthing_data(f"/rest/db/completion?folder={f_id}&device={dev_id}")
                if comp_data and comp_data.get("completion", 100) < 99.9:
                    print(f"  {to_subscript(len(active_device_ids))}")
                    sys.exit(0)
    
    # All synced
    print(f"  {to_subscript(len(active_device_ids))}")

if __name__ == "__main__":
    main()
