### ✅`This README Includes:`

- An overview of the lab
- Container setup instructions
- `iptables` rules with examples

---

### `README.md`

```markdown
# 🔒 Docker Network Security Lab with IPTables

This lab environment uses Docker containers to simulate a small network with a _firewall/router_ and multiple **clients**. It allows practicing `iptables` firewall rules for network security and traffic control.

---

## 🧪 Lab Topology

- `firewall`: Connected to two networks (`labnet192`, `labnet172`)
- `client1`: Connected to `labnet192`
- `client2`, `client3`: Connected to `labnet172`

---

## 🚀 Container Setup Script

Each container is given specific capabilities for networking control:

bash --cap-add=NET_ADMIN --cap-add=SYS_ADMIN
```

The `firewall` container also connects to both subnets for routing.

> ⚠️ Use this lab only in a **controlled, non-production** environment.

---

## 🛡 IPTables Rules Examples

### 1. Block All Incoming Traffic

```bash
iptables -t filter -A INPUT -j DROP
```

---

### 2. Block Specific IP or IP Range

```bash
# Single IP
iptables -t filter -A INPUT -s 192.168.100.2 -j DROP

# IP range
iptables -t filter -A INPUT -s 192.168.100.0/23 -j DROP
```

---

### 3. Block HTTP Access for a Specific IP

```bash
iptables -t filter -A INPUT -m tcp -p tcp -s 172.24.0.11 --dport 80 -j DROP
```

---

### 4. Block SSH and Telnet Access for a Specific IP (Multiport)

```bash
iptables -t filter -A INPUT -m multiport -p tcp -s 172.24.0.11 --dports 22,23 -j DROP
```

---

### 5. Save, Restore, and Manage Rules

```bash
# Save rules
iptables-save > /etc/iptables/rules.v4

# Restore rules
iptables-restore < /etc/iptables/rules.v4

# List rules with line numbers
iptables -L -v -n --line-numbers

# Delete a rule by line number
iptables -t filter -D INPUT <line_number>

# Delete a rule by content
iptables -t filter -D INPUT -s 172.24.0.11 -j DROP

# Flush INPUT chain
iptables -t filter -F INPUT

# # To delete all rules in the filter table
iptables -t filter -F

# To delete all rules in the NAT table
iptables -t nat -F

# To delete all rules in the Mangle table
iptables -t mangle -F

# To delete all rules in the RAW table
iptables -t raw -F
```

---

### 6. Block or Allow ICMP (Ping)

```bash
# Block all ping/icmp requests
iptables -t filter -A INPUT -p icmp -j DROP

# Allow ping from specific IP
iptables -t filter -A INPUT -p icmp -s <specific_ip> --icmp-type echo-request -j ACCEPT

# Allow all ping
iptables -t filter -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
```

---

### 7. 🔁 Packet Forwarding Samples

Use these rules to control forwarding traffic **between containers** connected to different subnets via the `firewall` container.

> Replace `client1-ip` and `client2-ip` with actual IP addresses (e.g., `192.168.100.2`, `172.24.0.5`)

```bash
# Drop ICMP (ping) from client1 to client2
iptables -t filter -A FORWARD -p icmp --icmp-type echo-request -s client1-ip -d client2-ip -j DROP

# Allow HTTP (port 80) traffic from client1 to client2
iptables -t filter -A FORWARD -p tcp --dport 80 -s client1-ip -d client2-ip -j ACCEPT

# Block SSH traffic between client1 and client2
iptables -t filter -A FORWARD -p tcp --dport 22 -s client1-ip -d client2-ip -j DROP

# Allow all traffic between the two subnets (labnet192 and labnet172)
iptables -t filter -A FORWARD -s 192.168.100.0/24 -d 172.24.0.0/24 -j ACCEPT
iptables -t filter -A FORWARD -s 172.24.0.0/24 -d 192.168.100.0/24 -j ACCEPT

# Block all forwarding by default (for strict policies)
iptables -P FORWARD DROP
```

----
### 8. Allow Only Established/Related Connections

```bash
iptables -t filter -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

---

## 📁 Notes

- Make sure `iptables-persistent` is installed to save rules:

  ```bash
  apt update && apt install -y iptables-persistent
  ```

- Run containers using the `setup.sh` script included in this repo.

---

## 📜 License

This project is intended for learning & educational purposes only.
