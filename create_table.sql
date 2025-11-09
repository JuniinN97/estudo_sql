CREATE TABLE Alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,  
    matricula VARCHAR(10) UNIQUE NOT NULL,    
    nome VARCHAR(100) NOT NULL,               
    data_nascimento DATE NOT NULL,            
    id_turma INT,                             
    FOREIGN KEY (id_turma) REFERENCES Turmas(id_turma)  
);
CREATE TABLE Professores (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,  
    nome VARCHAR(100) NOT NULL,                   
    cpf VARCHAR(11) UNIQUE NOT NULL,              
    id_sala INT,                                  
    FOREIGN KEY (id_sala) REFERENCES Salas(id_sala)
);
CREATE TABLE Salas (
    id_sala INT AUTO_INCREMENT PRIMARY KEY,  
    nome_sala VARCHAR(50) NOT NULL,          
    capacidade INT NOT NULL                 
);
CREATE TABLE Turmas (
    id_turma INT AUTO_INCREMENT PRIMARY KEY,  
    nome_turma VARCHAR(50) NOT NULL,          
    id_sala INT,                             
    FOREIGN KEY (id_sala) REFERENCES Salas(id_sala)  
);
