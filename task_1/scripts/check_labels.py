import json
import urllib.request

META = "http://metadata.google.internal/computeMetadata/v1/"


def metadata(path: str) -> str:
    req = urllib.request.Request(META + path, headers={"Metadata-Flavor": "Google"})
    with urllib.request.urlopen(req, timeout=2) as resp:
        return resp.read().decode()


project = metadata("project/project-id")
zone = metadata("instance/zone").split("/")[-1]
name = metadata("instance/name")

token = json.loads(metadata("instance/service-accounts/default/token"))["access_token"]

url = f"https://compute.googleapis.com/compute/v1/projects/{project}/zones/{zone}/instances/{name}"
req = urllib.request.Request(url, headers={"Authorization": f"Bearer {token}"})
with urllib.request.urlopen(req, timeout=10) as resp:
    labels = json.load(resp).get("labels", {})

print(f"name: {name}")
print(f"role: {labels.get('role')}")
