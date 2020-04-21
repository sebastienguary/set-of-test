# set-of-test
 Data set to facilitate the creation of test data


## Examples commands

```sql
    cat sql/mysql.sql  | mysql -h 172.16.1.9 --local-infile -u root -p
```


You can generate an address book with procedure

```sql
CALL generate_addressBook;
```
