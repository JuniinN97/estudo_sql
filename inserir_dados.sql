INSERT INTO Alunos (matricula, nome, data_nascimento, id_turma)
VALUES 
    ('A001', 'Maria Silva', '2005-03-15', 1),
    ('A002', 'João Souza', '2004-07-22', 2),
    ('A003', 'Ana Pereira', '2006-01-30', NULL);

INSERT INTO Professores (nome, cpf, id_sala)
VALUES
    ('Carlos Almeida', '12345678901', 1),
    ('Fernanda Costa', '98765432100', 2),
    ('Ricardo Silva', '45678912300', NULL);

INSERT INTO Salas (nome_sala, capacidade)
VALUES
    ('Sala A', 30),
    ('Sala B', 25),
    ('Sala C', 20); 

INSERT INTO Turmas (nome_turma, id_sala)
VALUES
    ('Turma 1A', 1),
    ('Turma 2B', 2),
    ('Turma 3C', NULL);
