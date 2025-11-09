-- Exibe os alunos, a turma em que estão matriculados e a sala associada
SELECT 
    a.matricula,
    a.nome AS nome_aluno,
    t.nome_turma,
    s.nome_sala,
    s.capacidade
FROM Alunos a
LEFT JOIN Turmas t ON a.id_turma = t.id_turma
LEFT JOIN Salas s ON t.id_sala = s.id_sala
ORDER BY a.nome;

-- Lista todos os professores e a sala onde lecionam
SELECT 
    p.nome AS nome_professor,
    p.cpf,
    s.nome_sala,
    s.capacidade
FROM Professores p
LEFT JOIN Salas s ON p.id_sala = s.id_sala
ORDER BY nome_professor;

-- Mostra o número de alunos por turma e a capacidade total da sala correspondente
SELECT 
    t.nome_turma,
    s.nome_sala,
    s.capacidade,
    COUNT(a.id_aluno) AS total_alunos,
    (s.capacidade - COUNT(a.id_aluno)) AS vagas_restantes
FROM Turmas t
LEFT JOIN Alunos a ON t.id_turma = a.id_turma
LEFT JOIN Salas s ON t.id_sala = s.id_sala
GROUP BY t.id_turma, t.nome_turma, s.nome_sala, s.capacidade
ORDER BY total_alunos DESC;

-- Mostra quais professores lecionam em salas que possuem turmas vinculadas
SELECT 
    p.nome AS professor,
    s.nome_sala,
    t.nome_turma
FROM Professores p
JOIN Salas s ON p.id_sala = s.id_sala
JOIN Turmas t ON s.id_sala = t.id_sala
ORDER BY s.nome_sala;

-- Retorna os alunos sem turma
SELECT 
    a.matricula,
    a.nome AS nome_aluno,
    DATE_FORMAT(a.data_nascimento, '%d/%m/%Y') AS data_nascimento
FROM Alunos a
WHERE a.id_turma IS NULL;

- Capacidade total e taxa média de ocupação (usando subconsultas)
SELECT 
    s.nome_sala,
    s.capacidade,
    COALESCE((
        SELECT COUNT(*) 
        FROM Alunos a
        JOIN Turmas t ON a.id_turma = t.id_turma
        WHERE t.id_sala = s.id_sala
    ), 0) AS ocupacao,
    ROUND(
        COALESCE((
            SELECT COUNT(*) 
            FROM Alunos a
            JOIN Turmas t ON a.id_turma = t.id_turma
            WHERE t.id_sala = s.id_sala
        ), 0) / s.capacidade * 100, 1
    ) AS taxa_ocupacao_percent
FROM Salas s
ORDER BY taxa_ocupacao_percent DESC;
