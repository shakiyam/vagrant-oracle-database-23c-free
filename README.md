vagrant-oracle-database-23c-free
================================

Vagrant + Oracle Linux 8 + Oracle Database 23c Free

Download
--------

Download [Oracle Database 23c Free](https://www.oracle.com/database/technologies/free-downloads.html). Then place downloaded file in the same directory as the Vagrantfile.

* oracle-database-free-23c-1.0-1.el8.x86_64.rpm

Configuration
-------------

Copy the file `dotenv.sample` to a file named `.env` and rewrite the contents as needed.

```shell
# SYS, SYSTEM and PDBADMIN password
ORACLE_PASSWORD=oracle
# Specifies whether or not to add the Sample Schemas to your database
ORACLE_SAMPLESCHEMA=TRUE
```

Provision
---------

When you run `vagrant up`, the following will work internally.

* Download and boot Oracle Linux 8
* Install Oracle Database 23c Free
* Creating and configuring an Oracle Database
* Set environment variables
* Install rlwrap and set alias
* Configure automating shutdown and startup
* Install sample schemas

```console
vagrant up
```

Example of use
--------------

Connect to the guest OS.

```console
vagrant ssh
```

Connect to CDB root and confirm the connection.

```console
sqlplus system/oracle
SHOW CON_NAME
```

Connect to PDB and confirm the connection. If you have sample schemas installed, browse to the sample table.

```console
sqlplus system/oracle@localhost/FREEPDB1
SHOW CON_NAME
-- If you have sample schemas installed
SELECT JSON_OBJECT(*) FROM hr.employees WHERE rownum <= 3;
-- SELECT on expressions no longer require FROM dual
SELECT 2*3;
```

Author
------

[Shinichi Akiyama](https://github.com/shakiyam)

License
-------

[MIT License](https://opensource.org/licenses/MIT)
