cfnat_file=/root/cfnat
config_file=$cfnat_file/cfnat.conf

cp -r /root/cfnat/conf/* /root/cfnat

colo=${CFNAT_COLO:-$(grep '^colo=' "$config_file" | cut -d'=' -f2 || echo "SJC,LAX,HKG")}
port=${CFNAT_PORT:-$(grep '^port=' "$config_file" | cut -d'=' -f2 || echo "9850")}
delay=${CFNAT_DELAY:-$(grep '^delay=' "$config_file" | cut -d'=' -f2 || echo "300")}

if [ ! -f "$config_file" ]; then
    echo "conf not exist, will create it..."
    echo "colo=${colo}" >>"$config_file"
    echo "port=${port}" >>"$config_file"
    echo "delay=${delay}" >>"$config_file"
else
    echo "conf exists, will use the conf..."
fi
cfnatcolo=$colo
cfnatport=$port
cfnatdelay=$delay

# start cfnat
echo "启动 cfnat, colo: $cfnatcolo, port: $cfnatport, delay: $cfnatdelay"
./cfnat -colo $cfnatcolo -port 443 -delay $cfnatdelay -ips 4 -addr "0.0.0.0:$cfnatport"