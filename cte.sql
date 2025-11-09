
WITH alunos_por_sala AS (
    SELECT 
        s.id_sala,
        COUNT(a.id_aluno) AS total_alunos
    FROM Salas s
    LEFT JOIN Turmas t ON s.id_sala = t.id_sala
    LEFT JOIN Alunos a ON t.id_turma = a.id_turma
    GROUP BY s.id_sala
)
SELECT 
    p.nome AS professor,
    s.nome_sala,
    aps.total_alunos
FROM Professores p
LEFT JOIN Salas s ON p.id_sala = s.id_sala
LEFT JOIN alunos_por_sala aps ON s.id_sala = aps.id_sala
ORDER BY aps.total_alunos DESC, p.nome;

-- ================================================
-- Consulta profissional com múltiplas CTEs
-- Banco fictício: Gestão Escolar
-- ================================================

-- CTE 1: Calcula a idade dos alunos
WITH IdadesAlunos AS (
    SELECT 
        id_aluno,
        nome,
        TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS idade
    FROM Alunos
),

-- CTE 2: Mapeia turmas e suas respectivas salas
TurmasSalas AS (
    SELECT 
        t.id_turma,
        t.nome_turma,
        s.nome_sala,
        s.capacidade
    FROM Turmas t
    LEFT JOIN Salas s ON t.id_sala = s.id_sala
),

-- CTE 3: Relaciona professores com as salas onde lecionam
ProfessoresSalas AS (
    SELECT 
        p.nome AS nome_professor,
        s.nome_sala
    FROM Professores p
    LEFT JOIN Salas s ON p.id_sala = s.id_sala
),

-- CTE 4: Calcula quantos alunos existem por turma
QtdAlunosPorTurma AS (
    SELECT 
        id_turma,
        COUNT(*) AS total_alunos
    FROM Alunos
    WHERE id_turma IS NOT NULL
    GROUP BY id_turma
),

-- CTE 5: Identifica salas subutilizadas (menos de 50% da capacidade)
SalasSubutilizadas AS (
    SELECT 
        ts.nome_sala,
        q.total_alunos,
        ts.capacidade,
        ROUND((q.total_alunos / ts.capacidade) * 100, 1) AS ocupacao_percentual
    FROM TurmasSalas ts
    LEFT JOIN QtdAlunosPorTurma q ON ts.id_turma = q.id_turma
    WHERE q.total_alunos < (ts.capacidade * 0.5)
)

-- ================================================
-- Consulta final: visão completa da estrutura escolar
-- ================================================
SELECT 
    a.nome AS aluno,
    i.idade,
    t.nome_turma,
    ts.nome_sala,
    ps.nome_professor,
    COALESCE(q.total_alunos, 0) AS total_alunos,
    COALESCE(ts.capacidade, 0) AS capacidade,
    CASE 
        WHEN ss.nome_sala IS NOT NULL THEN 'Subutilizada'
        ELSE 'Ocupação Normal'
    END AS status_sala
FROM Alunos a
LEFT JOIN IdadesAlunos i ON a.id_aluno = i.id_aluno
LEFT JOIN TurmasSalas ts ON a.id_turma = ts.id_turma
LEFT JOIN ProfessoresSalas ps ON ts.nome_sala = ps.nome_sala
LEFT JOIN QtdAlunosPorTurma q ON ts.id_turma = q.id_turma
LEFT JOIN SalasSubutilizadas ss ON ts.nome_sala = ss.nome_sala
ORDER BY ts.nome_sala, a.nome;
