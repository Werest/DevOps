[webservers]
%{ for vm in webservers ~}
${vm.name} ansible_host=${vm.public_ip} fqdn=${vm.fqdn}
%{ endfor ~}

[databases]
%{ for vm in databases ~}
${vm.name} ansible_host=${vm.public_ip} fqdn=${vm.fqdn}
%{ endfor ~}

[storage]
%{ for vm in storage ~}
${vm.name} ansible_host=${vm.public_ip} fqdn=${vm.fqdn}
%{ endfor ~}