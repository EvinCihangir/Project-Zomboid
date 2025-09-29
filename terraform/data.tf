data "aws_ami" "ubuntu_jammy" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Config templates
data "template_file" "pz" {
  vars = {
    username        = var.username
    install_dir     = var.install_dir
    server_name     = var.server_name
    admin_password  = var.admin_password
    server_password = var.server_password
  }

  template = <<EOF
#cloud-config
package_update: true
package_upgrade: true
packages:
  - lib32gcc-s1
  - lib32stdc++6
  - libsdl2-2.0-0:i386
  - libpulse0:i386
  - openjdk-17-jre-headless

groups:
  - $${username}
users:
  - default
  - name: $${username}
    homedir: $${install_dir}
    primary_group: $${username}
    lock_passwd: False
write_files:
  - path: $${install_dir}/Zomboid/Server/$${server_name}.ini
    owner: $${username}:$${username}
    defer: true
    permissions: '0644'
    content: |
      PublicName=$${server_name} PZ Server
      MaxPlayers=32
      DefaultPort=16261
      UDPPort=16262
      SteamVAC=true
      RCONPort=27015
      RCONPassword=ChangeThisRconPW
      Mods=
      Map=Muldraugh, KY
      PVP=false
      PauseEmpty=true
      GlobalChat=true
      Open=true
      AutoCreateUserInWhiteList=true
      DoLuaChecksum=true
      DenyLoginOnOverloadedServer=true
      Public=false
      PingLimit=300
      Password=$${server_password}

  - path: /usr/local/bin/pz-run.sh
    owner: root:root
    permissions: '0755'
    content: |
      #!/bin/bash
      FILE="$${install_dir}/Zomboid/db/$${server_name}.db"
      if [[ -f "$FILE" ]]; then
          echo "DB exists, running first command..."
          $${install_dir}/start-server.sh -Djava.library.path=./natives -Xmx14g -servername $${server_name}
      else
          echo "DB does not exist, running fallback..."
          $${install_dir}/start-server.sh -adminusername admin -adminpassword $${admin_password} -Djava.library.path=./natives -Xmx14g -servername $${server_name}
      fi

  - path: /etc/systemd/system/pzserver.service
    owner: root:root
    permissions: "0644"
    content: |
      [Unit]
      Description=Project Zomboid Dedicated Server
      After=network-online.target
      Wants=network-online.target

      [Service]
      PrivateTmp=true
      Type=simple
      User=pz
      Group=pz
      KillSignal=SIGCONT
      Restart=on-failure
      RestartSec=10
      TimeoutStopSec=60
      WorkingDirectory=$${install_dir}
      ExecStart=/usr/local/bin/pz-run.sh

      [Install]
      WantedBy=multi-user.target

runcmd:
  - apt-get update -y
  - add-apt-repository -y multiverse || true
  - dpkg --add-architecture i386 || true
  - apt-get update -y
  - echo "steamcmd steam/question select I AGREE" | debconf-set-selections
  - echo "steamcmd steam/license note ''" | debconf-set-selections
  - echo "steamcmd steam/question seen true" | debconf-set-selections
  - DEBIAN_FRONTEND=noninteractive apt-get install -y steamcmd
  - mkdir -p /opt/pzserver
  - chown -R $${username}:$${username} $${install_dir}
  - su - $${username} -c "/usr/games/steamcmd +force_install_dir $${install_dir} +login anonymous +app_update 380870 validate +quit"
  - systemctl daemon-reload
  - systemctl enable pzserver
  - systemctl start pzserver

final_message: |
  Project Zomboid server install attempted.
  Check logs with: journalctl -u pzserver -f

EOF
}
