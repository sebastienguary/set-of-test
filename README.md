# set-of-test
 Data set to facilitate the creation of test data


## Examples commands

### Mysql

Create tables, procedure and import data
```bash
    cat sql/mysql.sql  | mysql -h 172.16.1.9 --local-infile -u root -p
```


You can generate an address book with procedure

```sql
CALL generate_addressBook(1);
```

### Postgrsql

Create tables, procedure
```bash
    cat sql/postgresql.sql | psql -h 172.17.0.2 -U postgres
```

Import data
```bash
cat csv/first_name.csv | psql -h 172.17.0.2 -U postgres set_of_test -c "COPY firstName(fn_label) FROM STDIN"
cat csv/french_city.csv | psql -h 172.17.0.2 -U postgres set_of_test -c "COPY frenchCity(fc_label) FROM STDIN"
cat csv/last_name.csv | psql -h 172.17.0.2 -U postgres set_of_test -c "COPY lastName(ln_label) FROM STDIN
```




