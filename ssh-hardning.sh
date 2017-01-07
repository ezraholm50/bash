#!/bin/bash

sed -i "s|.*Protocol.*|Protocol 2|g" "/etc/ssh/sshd_config"

sed -i "s|.*PermitRootLogin.*|PermitRootLogin without-password|g" "/etc/ssh/sshd_config"

sed -i "s|.*LoginGraceTime.*|LoginGraceTime 30|g" "/etc/ssh/sshd_config"

sed -i "s|.*ChallengeResponseAuthentication.*|ChallengeResponseAuthentication no|g" "/etc/ssh/sshd_config"

sed -i "s|.*UsePAM.*|UsePAM yes|g" "/etc/ssh/sshd_config"

sed -i "s|.*PubkeyAuthentication.*|PubkeyAuthentication yes|g" "/etc/ssh/sshd_config"

sed -i "s|.*PasswordAuthentication.*|PasswordAuthentication no|g" "/etc/ssh/sshd_config"

sed -i "s|.*ServerKeyBits.*|ServerKeyBits 2048|g" "/etc/ssh/sshd_config"

sed -i "s|.*Banner.*|Banner /var/scripts/ssh.txt|g" "/etc/ssh/sshd_config"

sed -i "s|.*Port.*|Port 8822|g" "/etc/ssh/sshd_config"

sed -i "s|.*RSAAuthentication.*|RSAAuthentication yes|g" "/etc/ssh/sshd_config"

sed -i "s|.*PermitEmptyPasswords.*|PermitEmptyPasswords no|g" "/etc/ssh/sshd_config"

echo "AllowUsers root" >> /etc/ssh/sshd_config

cat <<-SSH > "/var/scripts/ssh.txt"
***************************************************************************
                            NOTICE TO USERS


This computer system is the private property of its owner, whether
individual, corporate or government.  It is for authorized use only.
Users (authorized or unauthorized) have no explicit or implicit
expectation of privacy.

Any or all uses of this system and all files on this system may be
intercepted, monitored, recorded, copied, audited, inspected, and
disclosed to your employer, to authorized site, government, and law
enforcement personnel, as well as authorized officials of government
agencies, both domestic and foreign.

By using this system, the user consents to such interception, monitoring,
recording, copying, auditing, inspection, and disclosure at the
discretion of such personnel or officials.  Unauthorized or improper use
of this system may result in civil and criminal penalties and
administrative or disciplinary action, as appropriate. By continuing to
use this system you indicate your awareness of and consent to these terms
and conditions of use. LOG OFF IMMEDIATELY if you do not agree to the
conditions stated in this warning.

****************************************************************************
SSH
