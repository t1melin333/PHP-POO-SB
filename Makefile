# Nome do container do MySQL no Docker
CONTAINER_NAME=mysql_db
DB_USER=root
DB_PASS=root
DB_NAME=sistema_bancario

# Caminho para os arquivos SQL
SCHEMA=./MySQL/schema.sql
SCHEMADROP=./MySQL/schema_drop.sql
INSERTS=./MySQL/inserts.sql
PROCEDURES=./MySQL/procedures.sql

# Apaga tabelas do banco de dados
drop-tables:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMADROP)

# Apaga e recria apenas o schema
create-tables:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMA)

# Cria procedures
create-procedures:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(PROCEDURES)

# Apaga e recria o schema e popula com dados iniciais
reset-db:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMA)
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(INSERTS)

# Executa apenas o seed (dados iniciais)
inserts:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(INSERTS)

# Up container Dockers
start:
	docker compose up -d
# Down container Dockers
stop:
	docker-compose down
# Restart container Dockers
restart: 
	stop start

# Verifica logs do container Web
logs:
	docker logs -f web