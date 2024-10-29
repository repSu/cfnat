#!/bin/bash

cfnat_file=/root/cfnat
config_file=$cfnat_file/cfnat.conf

mkdir -p /root/cfnat/conf

# CFNAT_COLO
raw_colos=${CFNAT_COLO:-$(grep '^colo=' "$config_file" | cut -d'=' -f2 || echo "[SJC+LAX,HKG]")}
cleaned_colos=$(echo "$raw_colos" | tr -d '[]')
IFS=', ' read -r -a colo_array <<< "$cleaned_colos"

echo "COLO: ${colo_array[@]}"

raw_ports=${CFNAT_PORT:-$(grep '^port=' "$config_file" | cut -d'=' -f2 || echo "[1234,1235]")}
raw_ports=$(echo "$raw_ports" | tr -d '[]')
IFS=',' read -r -a ports <<< "$raw_ports"

raw_delays=${CFNAT_DELAY:-$(grep '^delay=' "$config_file" | cut -d'=' -f2 || echo "[300,300]")}
raw_delays=$(echo "$raw_delays" | tr -d '[]')
IFS=',' read -r -a delays <<< "$raw_delays"

if [ "${#colo_array[@]}" -ne "${#ports[@]}" ] || [ "${#colo_array[@]}" -ne "${#delays[@]}" ]; then
    echo "parse error：the length of COLO、PORT or DELAY are not eq!"
    echo "COLO: ${colo_array[*]}"
    echo "PORT: ${ports[*]}"
    echo "DELAY: ${delays[*]}"
    exit 1
fi

if [ ! -f "$config_file" ]; then
    echo "conf not exist, will create it..."
    echo "colo=${CFNAT_COLO}" >> "$config_file"
    echo "port=${CFNAT_PORT}" >> "$config_file"
    echo "delay=${CFNAT_DELAY}" >> "$config_file"
else
    echo "conf exists, will use the conf..."
fi

for i in "${!colo_array[@]}"; do
    colo="${colo_array[i]}"
    port="${ports[i]}"
    delay="${delays[i]}"
    
    # replace +
    formatted_colo="${colo//+/,}"
    
    echo "start cfnat, colo: $formatted_colo, port: $port, delay: $delay"
    ./cfnat -colo "$formatted_colo" -port "$port" -delay "$delay" -ips 4 -addr "0.0.0.0:$port" &
done

wait
