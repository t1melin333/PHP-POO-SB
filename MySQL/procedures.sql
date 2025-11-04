USE sistema_bancario;

DELIMITER $$

-- cadastrar pessoa fisica
DROP PROCEDURE IF EXISTS p_cadastrarPF;
CREATE PROCEDURE p_cadastrarPF (
    IN _nome VARCHAR(100),
    IN _email VARCHAR(100),
    IN _cpf VARCHAR(14),
    IN _data_nascimento DATE,
    IN _telefone VARCHAR(15),
    IN _endereco VARCHAR(255),
    IN _username VARCHAR(50),
    IN _password VARCHAR(255)
)
BEGIN
    DECLARE _cliente_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes (
        nome, email, telefone, endereco, username, password
    ) VALUES (
        _nome, _email, _telefone, _endereco, _username, _password
    );

    SET _cliente_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PF (
        cliente_id, cpf, data_nascimento
    ) VALUES (
        _cliente_id, _cpf, _data_nascimento
    );

    COMMIT;
END$$

-- consulta pessoa com filtro por nome
DROP PROCEDURE IF EXISTS p_consultarPFnome;
CREATE PROCEDURE p_consultarPFnome (IN _nome VARCHAR(255))
BEGIN
    SELECT 
        c.id,
        c.nome,
        c.email,
        c.telefone,
        c.endereco,
        c.username,
        c.created_at,
        pf.cpf,
        pf.data_nascimento
    FROM Clientes c
    INNER JOIN Clientes_PF pf ON c.id = pf.cliente_id
    WHERE c.nome LIKE CONCAT('%', _nome, '%');
END $$

DROP PROCEDURE IF EXISTS p_consultarporCPF;
CREATE PROCEDURE p_consultarporCPF (IN _cpf VARCHAR(14))
BEGIN 
  SELECT 
  c.id,
  c.nome,
  c.email,
  c.telefone,
  c.endereco,
  c.username,
  cpf.cpf,
  cpf.data_nascimento
  FROM Clientes c
  JOIN Clientes_PF cpf ON c.id = cpf.cliente_id
  WHERE cpf.cpf = _cpf;
END $$

DROP PROCEDURE IF EXISTS p_consultarporID;
CREATE PROCEDURE p_consultarporID (IN _id INT)
BEGIN
   SELECT 
   c.id,
   c.nome,
   c.telefone,
   c.endereco,
   c.username,
   cpf.cpf,
   cpf.data_nascimento
   FROM Clientes c
   JOIN Clientes_PF cpf ON c.id = cpf.cliente_id
   WHERE c.id = _id;
END $$

DROP PROCEDURE IF EXISTS p_consultarporEmail;
CREATE PROCEDURE p_consultarporEmail (IN _email VARCHAR(100))
BEGIN
 SELECT
 c.id,
 c.nome,
 c.telefone,
 c.endereco,
 c.username,
 cpf.cpf,
 cpf.data_nascimento
 FROM Clientes c 
 JOIN Clientes_PF cpf ON c.id = cpf.cliente_id
 WHERE c.email = _email;
END $$

DROP PROCEDURE IF EXISTS alterar_cliente_pf;
CREATE PROCEDURE alterar_cliente_pf (
    IN _id INT,
    IN _nome VARCHAR(100),
    IN _email VARCHAR(100),
    IN _telefone VARCHAR(15),
    IN _endereco VARCHAR(255),
    IN _username VARCHAR(50),
    IN _password VARCHAR(255),
    IN _cpf VARCHAR(14),
    IN _data_nascimento DATE
)
BEGIN
    UPDATE Clientes
    SET nome = _nome, email = _email, telefone = _telefone,
        endereco = _endereco, username = _username, password = _password
    WHERE id = _id;

    UPDATE Clientes_PF
    SET cpf = _cpf, data_nascimento = _data_nascimento
    WHERE cliente_id = _id;
END $$

DROP PROCEDURE IF EXISTS deletar_cliente_pf;
CREATE PROCEDURE deletar_cliente_pf (IN _id INT)
BEGIN
    DELETE FROM Clientes WHERE id = _id;
END $$

-- PESSOA JURIDICA
-- cadastrar PJ
DROP PROCEDURE IF EXISTS cadastrar_cliente_pj;
CREATE PROCEDURE cadastrar_cliente_pj (
    IN _nome VARCHAR(100),
    IN _email VARCHAR(100),
    IN _telefone VARCHAR(15),
    IN _endereco VARCHAR(255),
    IN _username VARCHAR(50),
    IN _password VARCHAR(255),
    IN _cnpj VARCHAR(18),
    IN _razao_social VARCHAR(100),
    IN _data_fundacao DATE
)
BEGIN
    INSERT INTO Clientes (nome, email, telefone, endereco, username, password)
    VALUES (_nome, _email, _telefone, _endereco, _username, _password);

    INSERT INTO Clientes_PJ (cliente_id, cnpj, razao_social, data_fundacao)
    VALUES (LAST_INSERT_ID(), _cnpj, _razao_social, _data_fundacao);
END $$

-- alterar PJ
DROP PROCEDURE IF EXISTS alterar_cliente_pj;
CREATE PROCEDURE alterar_cliente_pj (
    IN _id INT,
    IN _nome VARCHAR(100),
    IN _email VARCHAR(100),
    IN _telefone VARCHAR(15),
    IN _endereco VARCHAR(255),
    IN _username VARCHAR(50),
    IN _password VARCHAR(255),
    IN _cnpj VARCHAR(18),
    IN _razao_social VARCHAR(100),
    IN _data_fundacao DATE
)
BEGIN
    UPDATE Clientes
    SET nome = _nome, email = _email, telefone = _telefone,
        endereco = _endereco, username = _username, password = _password
    WHERE id = _id;

    UPDATE Clientes_PJ
    SET cnpj = _cnpj, razao_social = _razao_social, data_fundacao = _data_fundacao
    WHERE cliente_id = _id;
END $$

-- deletar PJ
DROP PROCEDURE IF EXISTS deletar_cliente_pj;
CREATE PROCEDURE deletar_cliente_pj (IN p_id INT)
BEGIN
    DELETE FROM Clientes WHERE id = p_id;
END $$

-- com filtro por nome ou razão social
DROP PROCEDURE IF EXISTS consultar_todos_clientes_pj;
CREATE PROCEDURE consultar_todos_clientes_pj (IN _filtro VARCHAR(100))
BEGIN
    SELECT c.id, c.nome, pj.cnpj, pj.razao_social, c.email
    FROM Clientes c
    JOIN Clientes_PJ pj ON c.id = pj.cliente_id
    WHERE c.nome LIKE CONCAT('%', _filtro, '%')
       OR pj.razao_social LIKE CONCAT('%', _filtro, '%');
END $$

-- consultar por CNPJ
DROP PROCEDURE IF EXISTS consultar_cliente_pj_por_cnpj;
CREATE PROCEDURE consultar_cliente_pj_por_cnpj (IN _cnpj VARCHAR(18))
BEGIN
    SELECT c.*, pj.*
    FROM Clientes c
    JOIN Clientes_PJ pj ON c.id = pj.cliente_id
    WHERE pj.cnpj = _cnpj;
END $$

-- Consultar por ID
DROP PROCEDURE IF EXISTS consultar_cliente_pj_por_id;
CREATE PROCEDURE consultar_cliente_pj_por_id (IN _id INT)
BEGIN
    SELECT c.*, pj.*
    FROM Clientes c
    JOIN Clientes_PJ pj ON c.id = pj.cliente_id
    WHERE c.id = _id;
END $$

-- consultar por email
DROP PROCEDURE IF EXISTS consultar_cliente_pj_por_email;
CREATE PROCEDURE consultar_cliente_pj_por_email (IN _email VARCHAR(100))
BEGIN
    SELECT c.*, pj.*
    FROM Clientes c
    JOIN Clientes_PJ pj ON c.id = pj.cliente_id
    WHERE c.email = _email;
END $$

-- cadastrar conta
DROP PROCEDURE IF EXISTS cadastrar_conta;
CREATE PROCEDURE cadastrar_conta (
    IN _cliente_id INT,
    IN _tipo_conta ENUM('corrente', 'poupanca'),
    IN _saldo DECIMAL(15,2),
    IN _limite DECIMAL(15,2)
)
BEGIN
    INSERT INTO Contas (cliente_id, tipo_conta, saldo, limite)
    VALUES (_cliente_id, _tipo_conta, _saldo, _limite);
END $$

-- alterar conta
DROP PROCEDURE IF EXISTS alterar_conta;
CREATE PROCEDURE alterar_conta (
    IN _id INT,
    IN _tipo_conta ENUM('corrente', 'poupanca'),
    IN _saldo DECIMAL(15,2),
    IN _limite DECIMAL(15,2),
    IN _status ENUM('ativa', 'inativa')
)
BEGIN
    UPDATE Contas
    SET tipo_conta = _tipo_conta,
        saldo = _saldo,
        limite = _limite,
        status = _status
    WHERE id = _id;
END $$

-- Deletar conta
DROP PROCEDURE IF EXISTS deletar_conta;
CREATE PROCEDURE deletar_conta (IN _id INT)
BEGIN
    DELETE FROM Contas WHERE id = _id;
END $$

-- Consultar conta por ID
DROP PROCEDURE IF EXISTS consultar_conta_por_id;
CREATE PROCEDURE consultar_conta_por_id (IN _id INT)
BEGIN
    SELECT * FROM Contas WHERE id = _id;
END $$

-- Consultar conta por Cliente
DROP PROCEDURE IF EXISTS consultar_conta_por_cliente;
CREATE PROCEDURE consultar_conta_por_cliente (IN _cliente_id INT)
BEGIN
    SELECT * FROM Contas WHERE cliente_id = _cliente_id;
END $$

-- Depositar
DROP PROCEDURE IF EXISTS depositar;
CREATE PROCEDURE depositar (
    IN _conta_id INT,
    IN _valor DECIMAL(15,2),
    IN _descricao VARCHAR(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo + _valor
    WHERE id = _conta_id;

    INSERT INTO Transacoes (conta_id, tipo, valor, descricao)
    VALUES (_conta_id, 'deposito', _valor, _descricao);
END $$

-- Transferir
DROP PROCEDURE IF EXISTS transferir;
CREATE PROCEDURE transferir (
    IN _conta_origem INT,
    IN _conta_destino INT,
    IN _valor DECIMAL(15,2),
    IN _descricao VARCHAR(255)
)
BEGIN
    DECLARE saldo_origem DECIMAL(15,2);

    SELECT saldo INTO saldo_origem FROM Contas WHERE id = _conta_origem;

    IF saldo_origem >= _valor THEN
        UPDATE Contas SET saldo = saldo - _valor WHERE id = _conta_origem;
        UPDATE Contas SET saldo = saldo + _valor WHERE id = _conta_destino;

        INSERT INTO Transacoes (conta_id, tipo, valor, descricao)
        VALUES (_conta_origem, 'transferencia', _valor, CONCAT('Para conta ', _conta_destino));

        INSERT INTO Transacoes (conta_id, tipo, valor, descricao)
        VALUES (_conta_destino, 'transferencia', _valor, CONCAT('De conta ', _conta_origem));
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saldo insuficiente para transferência';
    END IF;
END $$

DELIMITER ;
