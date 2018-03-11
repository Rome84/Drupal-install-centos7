resource "aws_instance" "drupal" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "m4.large"
  vpc_security_group_ids = [ "${aws_security_group.from_uswest.id}" ]
  key_name = "${aws_key_pair.mykey.key_name}"
 
#  provisioner "file" {
#    source = "script-centos.sh"
#    destination = "/tmp/script.sh"
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/script.sh",
#      "sudo /tmp/script.sh"
#    ]
#  }

   provisioner "local-exec" {
     command = "sleep 95 && echo \"[drupal-server]\n${aws_instance.drupal.public_ip} ansible_connection=ssh ansible_ssh_user=ec2-user ansible_ssh_private_key_file=mykey host_key_checking=False\" > drupal-inventory &&  ansible-playbook -i drupal-inventory ansible-playbooks/drupal-create.yml "
  }

  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}
output "drupal_ip" {
    value = "${aws_instance.drupal.public_ip}"
}
output "drupal_END_URL" {
    value = "http://${aws_instance.drupal.public_ip}:8080"
}
