# EBS volumes whose lifetime is independent of any Kubernetes cluster.
#
# The usual Kubernetes pattern (a StorageClass dynamically provisioning a
# volume per PVC) ties each volume's life to its PVC/PV objects, which die
# with the cluster. For a cluster that is torn down and rebuilt routinely,
# that means losing every stateful workload's data on every cycle. Instead:
#   1. this module owns the volumes (retained across teardown), and
#   2. eks/static_persistent_volumes creates PersistentVolume objects in each
#      new cluster that point at these volume IDs and are pre-bound to the
#      PVC names the workloads create, so they re-attach to the same data.
#
# prevent_destroy is hard-coded on purpose: these hold data, and a destroy
# (including an "include retained" teardown) must fail loudly instead of
# deleting it. To really delete a volume, remove it from var.volumes AND
# take it out of state deliberately.
#
# Existing volumes (e.g. originally created by the EBS CSI driver) are
# adopted with `terraform import 'aws_ebs_volume.this["<key>"]' vol-...`;
# the attributes below must then match the real volume exactly (notably
# `encrypted`, which forces replacement) - check the plan shows no replace.
resource "aws_ebs_volume" "this" {
  for_each = var.volumes

  availability_zone = each.value.availability_zone
  size              = each.value.size_gb
  type              = each.value.type
  iops              = each.value.iops
  throughput        = each.value.throughput
  encrypted         = each.value.encrypted
  kms_key_id        = each.value.kms_key_id

  tags = merge(var.tags, each.value.tags, {
    Name = each.key
  })

  lifecycle {
    prevent_destroy = true
  }
}
