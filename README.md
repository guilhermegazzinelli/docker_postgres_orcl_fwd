#Intro

This project uses Postgres Oficial Image to build Oracle_FWD. 

## Supported args

| Versiosn              | default       |
| -------------         | ------------- |
| postgres_version      | latest (13)   |
| oracle_fdw_version    | 2_3_0         |
| instantclient_version | 21_3          |

*Example*
```console
docker build --build-arg postgres_version=10.4 -t postgres-ora-fdw:10.4 .
```



## Creating conenction to external Oracle Database

```SQL
create extension oracle_fdw;


create server oracle_server foreign data wrapper oracle_fdw options (dbserver '//<HOST>:1521/<DB_NAME>' );
 
GRANT USAGE ON FOREIGN SERVER oracle_server TO user;


CREATE USER MAPPING FOR user SERVER oracle_server
	OPTIONS (user '<USER>', password '<PASS_WD>');

```

### Usage

```SQL
CREATE FOREIGN TABLE product_view (
    "stored" numeric(3) NULL,
	---(other imported columns)
       ) SERVER oracle_server OPTIONS (schema '<SCHEMA>', table '<TABLE_NAME>');

select * from product_view limit 300;

select * from product_view where  stored = 5 and segmento = 1 and seqproduto in (10508, 9177);
select * from product_view where stored = 5 and segmento = 1 limit 300;
```

# References:

Oracle_FWD extension: https://github.com/laurenz/oracle_fdw

Oracle client install: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html

References for this docker image build: https://blog.dbi-services.com/connecting-your-postgresql-instance-to-an-oracle-database/

