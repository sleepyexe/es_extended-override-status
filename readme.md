
# Change the permission

```cfg
add_principal group.admin group.user
add_principal group.superadmin group.user
add_ace group.superadmin command allow # allow all commands
add_ace group.superadmin command.quit deny # but don't allow quit
add_ace resource.es_extended command.add_ace allow
add_ace resource.es_extended command.add_principal allow
add_ace resource.es_extended command.remove_principal allow
add_ace resource.es_extended command.stop allow
```