#!/bin/bash

input_file="domains.txt"
output_file="output.csv"

echo "Domain,Registrar,Organization,Name,Email,Phone,Address,Name Servers,IP Address,Registration Date,Expiration Date" > "$output_file"

while IFS= read -r domain; do
  whois_output=$(timeout 5 whois "$domain")
  registrar=$(echo "$whois_output" | grep -i -m 1 '^Registrar')
  organization=$(echo "$whois_output" | grep -i -m 1 '^Org')
  name=$(echo "$whois_output" | grep -i -m 1 '^Name')
  email=$(echo "$whois_output" | grep -i -m 1 '^Email')
  phone=$(echo "$whois_output" | grep -i -m 1 '^Phone')
  address=$(echo "$whois_output" | grep -i -m 1 '^Address')
  nameservers=$(echo "$whois_output" | grep -i -m 1 '^Name Server')
  ip_address=$(dig +short "$domain")
  registration_date=$(echo "$whois_output" | grep -i -m 1 '^Creation Date')
  expiration_date=$(echo "$whois_output" | grep -i -m 1 '^Registry Expiry Date')

  echo "${domain},${registrar#*:},${organization#*:},${name#*:},${email#*:},${phone#*:},${address#*:},${nameservers#*:},${ip_address},${registration_date#*:},${expiration_date#*:}" >> "$output_file"
done < "$input_file"
