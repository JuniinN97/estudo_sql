-- Procedures de Carga e Atualização (ETL)
DELIMITER //
CREATE PROCEDURE Atualizar_Idade_Alunos()
BEGIN
    UPDATE Alunos
    SET idade = TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE());
END //
DELIMITER ;

-- Procedures de Relatórios
DELIMITER //
CREATE PROCEDURE Relatorio_Ocupacao_Salas()
BEGIN
    SELECT 
        s.nome_sala,
        COUNT(a.id_aluno) AS total_alunos,
        s.capacidade,
        CONCAT(ROUND((COUNT(a.id_aluno)/s.capacidade)*100,1), '%') AS ocupacao
    FROM Salas s
    LEFT JOIN Turmas t ON s.id_sala = t.id_sala
    LEFT JOIN Alunos a ON t.id_turma = a.id_turma
    GROUP BY s.id_sala;
END //
DELIMITER ;

-- Procedures Parametrizadas (Dinâmicas)
DELIMITER //
CREATE PROCEDURE Buscar_Alunos_Por_Turma(IN turma_nome VARCHAR(50))
BEGIN
    SELECT 
        a.matricula,
        a.nome,
        t.nome_turma,
        s.nome_sala
    FROM Alunos a
    INNER JOIN Turmas t ON a.id_turma = t.id_turma
    LEFT JOIN Salas s ON t.id_sala = s.id_sala
    WHERE t.nome_turma = turma_nome;
END //
DELIMITER ;

-- Procedures de Auditoria / Log
DELIMITER //
CREATE PROCEDURE Registrar_Auditoria(
    IN acao VARCHAR(50),
    IN entidade VARCHAR(50),
    IN usuario VARCHAR(100)
)
BEGIN
    INSERT INTO Log_Auditoria (acao, entidade, usuario, data_execucao)
    VALUES (acao, entidade, usuario, NOW());
END //
DELIMITER ;

-- Procedures Automatizadas (Rotinas Agendadas)
DELIMITER //
CREATE PROCEDURE Atualizar_Estatisticas_Diarias()
BEGIN
    INSERT INTO Estatisticas (data_execucao, total_alunos, total_professores)
    SELECT 
        CURDATE(),
        (SELECT COUNT(*) FROM Alunos),
        (SELECT COUNT(*) FROM Professores);
END //
DELIMITER ;

-- Agendar execução diária às 23:59
CREATE EVENT IF NOT EXISTS Evento_Estatisticas_Diarias
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURDATE(), '23:59:00')
DO
    CALL Atualizar_Estatisticas_Diarias();
