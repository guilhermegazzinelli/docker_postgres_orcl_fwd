# Intro

This project uses Postgres Official buster image to build Oracle_FWD. 
The image is available in: https://hub.docker.com/r/fusiontecnologia/postgres_fdw_oracle

## Used versions

| Versions              | default       |
| -------------         | ------------- |
| postgres_version      | latest (13)   |
| oracle_fdw_version    | 2_3_0         |
| instantclient_version | 21_3          |

*Example*
```console
# To build
docker build  -t postgres_fdw_oracle .

# To run
docker run --name pg_orcl_test -p 5432:5432 fusiontecnologia/postgres_fdw_oracle:latest 
```



## Creating connection to external Oracle Database
Enter in the container or remote access through psql client.
```bash
    docker exec -it pg_orcl_test bash
```

and then execute `psql` inside container. After, just  create connection to Oracle server as follows:

```SQL
create extension oracle_fdw;

create server oracle_server foreign data wrapper oracle_fdw options (dbserver '//<HOST>:1521/<DB_NAME>' );
 
GRANT USAGE ON FOREIGN SERVER oracle_server TO user;

CREATE USER MAPPING FOR user SERVER oracle_server
	OPTIONS (user '<USER>', password '<PASS_WD>');

```
The `<>` are the information from host. Also needs an user to connect to. The user mapping is needed to map the execution in remote db to the user that was granted access to. Needed for each user that uses this server connection. 

### Usage

After created the server just need to define `FOREIGN TABLE` to define remote schema. Caution with the data mapping between both databases. 

```SQL
CREATE FOREIGN TABLE product_view (
    "stored" numeric(3) NULL,
	---(other imported columns)
       ) SERVER oracle_server OPTIONS (schema '<SCHEMA>', table '<TABLE_NAME>');

select * from product_view limit 300;

select * from product_view where  stored = 5 and segmento = 1 and seqproduto in (10508, 9177);
select * from product_view where stored = 5 and segmento = 1 limit 300;
```

As mentioned by @mfvitale is possible to import the foreign schema as follows:

```SQL
IMPORT FOREIGN SCHEMA "<foreignSchemaName>"
    FROM SERVER oracle_server
    INTO <localSchemaName>;
```

making possible to access tables directly (Not tested by me). You can also limit the scope of the import:

```SQL
IMPORT FOREIGN SCHEMA "orcl"
	LIMIT TO ("<TABLE_OR_VIEW_NAME>")
	FROM SERVER oracle_server INTO public; 
```



# TODO
- [] Support tags related to postgres version
- [] Multiple versions for Oracle_FDW

# References:

Oracle_FWD extension: https://github.com/laurenz/oracle_fdw

Oracle client install: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html

References for this docker image build: https://blog.dbi-services.com/connecting-your-postgresql-instance-to-an-oracle-database/

Some kind of inspiration from: https://github.com/guilhermegazzinelli/postgres-oracle-fdw with thanks to @mfvitale

# License
MIT License

Copyright (c) 2021 Guilherme Gazzinelli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.