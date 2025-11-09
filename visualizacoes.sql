- View 1: Relatório completo de turmas com alunos e professores
CREATE OR REPLACE VIEW vw_relatorio_turmas_completo AS
SELECT 
    t.id_turma,
    t.nome_turma,
    s.nome_sala,
    s.capacidade,
    COUNT(a.id_aluno) AS total_alunos,
    p.nome AS professor_responsavel,
    ROUND((COUNT(a.id_aluno) / s.capacidade) * 100, 1) AS ocupacao_percentual
FROM Turmas t
LEFT JOIN Salas s ON t.id_sala = s.id_sala
LEFT JOIN Alunos a ON t.id_turma = a.id_turma
LEFT JOIN Professores p ON s.id_sala = p.id_sala
GROUP BY 
    t.id_turma, t.nome_turma, s.nome_sala, s.capacidade, p.nome;

-- View 2: Alunos que não estão associados a nenhuma turma
CREATE OR REPLACE VIEW vw_alunos_sem_turma AS
SELECT 
    a.id_aluno,
    a.matricula,
    a.nome,
    a.data_nascimento
FROM Alunos a
WHERE a.id_turma IS NULL;

-- View 3: Percentual de ocupação das salas com base nas turmas e alunos
CREATE OR REPLACE VIEW vw_ocupacao_salas AS
SELECT
    s.id_sala,
    s.nome_sala,
    s.capacidade,
    COUNT(a.id_aluno) AS total_alunos,
    CONCAT(ROUND((COUNT(a.id_aluno)/s.capacidade)*100,1), '%') AS taxa_ocupacao
FROM Salas s
LEFT JOIN Turmas t ON s.id_sala = t.id_sala
LEFT JOIN Alunos a ON t.id_turma = a.id_turma
GROUP BY s.id_sala, s.nome_sala, s.capacidade
