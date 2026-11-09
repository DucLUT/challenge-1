"""Run INSIDE a VM.

    python3 check_labels.py                    # print name and role
    python3 check_labels.py --require backend  # exit 0 if role matches, else exit 1

Reads this VM's own labels through the Compute API (standard library only).
Needs a service account with roles/compute.viewer and the cloud-platform scope.
"""
import argparse
import json
import sys
import time
import urllib.error
import urllib.request

META = "http://metadata.google.internal/computeMetadata/v1/"


def metadata(path: str) -> str:
    req = urllib.request.Request(META + path, headers={"Metadata-Flavor": "Google"})
    with urllib.request.urlopen(req, timeout=2) as resp:
        return resp.read().decode()


def get_labels() -> tuple[str, dict]:
    project = metadata("project/project-id")
    zone = metadata("instance/zone").split("/")[-1]  # projects/123/zones/us-central1-a
    name = metadata("instance/name")
    url = f"https://compute.googleapis.com/compute/v1/projects/{project}/zones/{zone}/instances/{name}"

    # A fresh IAM binding can take a minute to apply, so retry a few times.
    for attempt in range(8):
        try:
            token = json.loads(metadata("instance/service-accounts/default/token"))["access_token"]
            req = urllib.request.Request(url, headers={"Authorization": f"Bearer {token}"})
            with urllib.request.urlopen(req, timeout=10) as resp:
                return name, json.load(resp).get("labels", {})
        except (urllib.error.URLError, OSError) as err:
            if attempt == 7:
                print(f"error: could not read labels: {err}", file=sys.stderr)
                sys.exit(255)  # real failure, not "role does not match"
            time.sleep(10)


parser = argparse.ArgumentParser()
parser.add_argument("--require", help="exit 1 unless the role label equals this")
args = parser.parse_args()

name, labels = get_labels()
role = labels.get("role")

if args.require:
    sys.exit(0 if role == args.require else 1)

print(f"name: {name}")
print(f"role: {role}")
