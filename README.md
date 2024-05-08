# koha-ibpan

Helper Debian package that does two things:
- after Koha was updated, apply patches
- after Elasticsearch was updated, reinstall its plugins

It gets triggered by DPKG triggers feature (`src/DEBIAN/triggers`), allowing to run our script (`src/DEBIAN/postinst`) if particular directories have changed as a result of an upgrade, which is extremely convenient.

## Example with it at work

```
# apt install --reinstall koha-common
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
0 upgraded, 0 newly installed, 1 reinstalled, 0 to remove and 0 not upgraded.
Need to get 0 B/17.9 MB of archives.
After this operation, 0 B of additional disk space will be used.
Preconfiguring packages ...
(Reading database ... 103972 files and directories currently installed.)
Preparing to unpack .../koha-common_23.11.04-4_all.deb ...
Unpacking koha-common (23.11.04-4) over (23.11.04-4) ...
Setting up koha-common (23.11.04-4) ...
Upgrading database schema for biblioteka
tmpl_process3.pl: Warning: unconsistent %s count: (1/2):
  line:   12956
  msgid:  "Waiting here since %s. "
  msgstr: "Oczekuje w %s od %s. "

Connection to the memcached servers '__MEMCACHED_SERVERS__' failed. Are the unix socket permissions set properly? Is the host reachable?
If you ignore this warning, you will face performance issues
Updated the pl-PL translations.
Enabling plugins on node rabbit@localhost:
rabbitmq_stomp
The following plugins have been configured:
  rabbitmq_stomp
Applying plugin configuration to rabbit@localhost...
Plugin configuration unchanged.
Processing triggers for koha-ibpan (0.1) ...

==== IB PAN: PATCHING KOHA START ====
patching file /usr/share/koha/lib/C4/Heading/MARC21.pm
patching file /usr/share/koha/lib/Koha/SearchEngine/Elasticsearch/QueryBuilder.pm
Restarting koha-common...
==== IB PAN: PATCHING KOHA END ====

Processing triggers for man-db (2.11.2-2) ...
```

## Description of our patches

1. We use the NUKAT central catalogue, and they use customized non-standard field values for some types of authority records that they use (instead of using the designated fields for a custom name). I figured making these patches would be simpler than going out of our way to patch all the records instead of that...
2. `bulkmarcimport2.pl` contains some changes/improvements to the original script that were not yet all upstreamed...
