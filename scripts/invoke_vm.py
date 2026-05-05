import json
import subprocess
import sys
import os

INVENTORY_PATH = os.path.join(os.path.dirname(__file__), '..', 'inventory', 'vm_inventory.json')
TERRAFORM_DIR  = os.path.join(os.path.dirname(__file__), '..', 'terraform')
ANSIBLE_DIR    = os.path.join(os.path.dirname(__file__), '..', 'ansible')

ACTION_MAP = {
    "running" : "vm-running",
    "resize"  : "vm-resize",
    "snooze"  : "vm-snooze",
    "destroy" : "vm-destroy"
}

PLAYBOOK_MAP = {
    "running" : "playbook-running.yml",
    "resize"  : "playbook-resize.yml",
    "snooze"  : "playbook-snooze.yml",
    "destroy" : "playbook-destroy.yml"
}

def load_inventory():
    with open(INVENTORY_PATH, 'r') as f:
        return json.load(f)

def list_vms(vms):
    print("\n📋 VM Inventory\n")
    print(f"{'ID':<8} {'Name':<20} {'Alias':<28} {'Desired State':<12} {'Business Unit'}")
    print("-" * 85)
    for vm in vms:
        print(f"{vm['id']:<8} {vm['name']:<20} {vm['alias']:<28} {vm['desired_state']:<12} {vm['business_unit']}")
    print()

def get_vm_choice(vms):
    list_vms(vms)
    choice = input("Enter VM ID or Name to invoke (e.g. vm-001 or vm-running): ").strip()
    for vm in vms:
        if vm['id'] == choice or vm['name'] == choice:
            return vm
    print(f"\n❌ VM '{choice}' not found in inventory.")
    sys.exit(1)

def confirm(vm):
    print(f"\n🔍 Selected VM  : {vm['alias']} ({vm['name']})")
    print(f"   Business Need : {vm['business_need']}")
    print(f"   Desired State : {vm['desired_state'].upper()}")
    print(f"   Business Unit : {vm['business_unit']}")
    print(f"   Priority      : {vm['priority']}")
    ans = input("\n▶ Proceed? (yes/no): ").strip().lower()
    if ans != 'yes':
        print("Aborted.")
        sys.exit(0)

def run_terraform(vm):
    action    = vm['desired_state']
    module    = ACTION_MAP.get(action)
    if not module:
        print(f"❌ No Terraform module mapped for action: {action}")
        sys.exit(1)

    print(f"\n🏗  Running Terraform for module: {module}")
    cmd = ["terraform", "apply", "-auto-approve", f"-target=module.{module.replace('-','_')}"]
    result = subprocess.run(cmd, cwd=TERRAFORM_DIR)
    if result.returncode != 0:
        print("❌ Terraform failed.")
        sys.exit(1)
    print("✅ Terraform done.")

def run_ansible(vm):
    action   = vm['desired_state']
    playbook = PLAYBOOK_MAP.get(action)
    if not playbook:
        print(f"❌ No Ansible playbook mapped for action: {action}")
        sys.exit(1)

    print(f"\n⚙️  Running Ansible playbook: {playbook}")
    cmd = [
        "ansible-playbook",
        "-i", os.path.join(ANSIBLE_DIR, "inventory.ini"),
        os.path.join(ANSIBLE_DIR, playbook)
    ]
    result = subprocess.run(cmd)
    if result.returncode != 0:
        print("❌ Ansible failed.")
        sys.exit(1)
    print("✅ Ansible done.")

def main():
    data = load_inventory()
    vms  = data['vms']
    vm   = get_vm_choice(vms)
    confirm(vm)
    run_terraform(vm)
    run_ansible(vm)
    print(f"\n🎉 VM '{vm['name']}' successfully invoked as: {vm['desired_state'].upper()}\n")

if __name__ == "__main__":
    main()