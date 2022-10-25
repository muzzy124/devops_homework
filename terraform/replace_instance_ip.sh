# Get VM IP
VM_IP=`terraform output instance_fip | sed s/\"//g`
# Replace VM IP in inventory
sed -i -e "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$VM_IP/g" ./ansible/env/dev/inventory

