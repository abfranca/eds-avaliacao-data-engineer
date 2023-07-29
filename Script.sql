-- 0.
--    Adicionei alguns scripts para ajudar no momento de validar as soluções.
create schema if not exists stg_hospital_a;

create schema if not exists stg_hospital_b;

create schema if not exists stg_hospital_c;

create schema if not exists stg_prontuario;

create table if not exists stg_hospital_a.paciente (
id serial PRIMARY KEY,
nome varchar(255) not null,
dt_nascimento date not null,
cpf varchar(11) unique not null,
nome_mae varchar(255) not null,
dt_atualizacao timestamp not null
);

create table if not exists stg_hospital_b.paciente (
id serial PRIMARY KEY,
nome varchar(255) not null,
dt_nascimento date not null,
cpf varchar(11) unique not null,
nome_mae varchar(255) not null,
dt_atualizacao timestamp not null
);

create table if not exists stg_hospital_c.paciente (
id serial PRIMARY KEY,
nome varchar(255) not null,
dt_nascimento date not null,
cpf varchar(11) unique not null,
nome_mae varchar(255) not null,
dt_atualizacao timestamp not null
);

insert into stg_hospital_a.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
values (
'paciente01', '1999-01-01', '12345678901', 'mae01', '2023-01-01 10:10:00'
);

insert into stg_hospital_a.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
values (
'paciente02', '1999-01-01', '12345678902', 'mae02', '2023-01-01 10:11:00'
);

insert into stg_hospital_a.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
values (
'paciente03', '1999-01-01', '12345678903', 'mae03', '2023-01-01 10:12:00'
);

insert into stg_hospital_b.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
values (
'paciente01', '1999-01-01', '12345678901', 'mae01', '2023-01-01 10:12:00'
);

insert into stg_hospital_b.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
values (
'paciente02', '1999-01-01', '12345678902', 'mae02', '2023-01-01 10:13:00'
);

insert into stg_hospital_c.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
values (
'paciente01', '1999-01-01', '12345678901', 'mae01', '2023-01-01 10:11:00'
);

insert into stg_hospital_c.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
values (
'paciente02', '1999-01-01', '12345678902', 'mae02', '2023-01-01 10:12:00'
);

-- 1.
--    Modifiquei o tipo de cpf para um tipo textual,
--    adicionei a constraint not null para todos os atributos.
create table if not exists stg_prontuario.paciente (
id serial PRIMARY KEY,
nome varchar(255) not null,
dt_nascimento date not null,
cpf varchar(11) not null,
nome_mae varchar(255) not null,
dt_atualizacao timestamp not null
);

-- 2. 
insert into stg_prontuario.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
select p.nome, p.dt_nascimento, p.cpf, p.nome_mae, p.dt_atualizacao
from stg_hospital_a.paciente p;

insert into stg_prontuario.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
select p.nome, p.dt_nascimento, p.cpf, p.nome_mae, p.dt_atualizacao
from stg_hospital_b.paciente p;

insert into stg_prontuario.paciente (
nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
)
select p.nome, p.dt_nascimento, p.cpf, p.nome_mae, p.dt_atualizacao
from stg_hospital_c.paciente p;

-- 3.
select * from stg_prontuario.paciente p
where (select count(pp.cpf) from stg_prontuario.paciente pp
where p.cpf like pp.cpf) > 1
order by p.cpf;

-- 4.
select * from stg_prontuario.paciente p
where (select count(pp.cpf) from stg_prontuario.paciente pp
where p.cpf like pp.cpf) > 1 and
(select max(pp.dt_atualizacao) from stg_prontuario.paciente pp
where p.cpf like pp.cpf) = p.dt_atualizacao;

-- 7. 
--    Criaria uma tabela stg_prontuario.atendimento_medico e uma tabela stg_prontuario.diagnostico
--    que teria uma coluna id_atendimento que guardaria uma chave estrangeira com uma referência
--    para uma linha da tabela stg_prontuario.atendimento_medico.

-- 8.
--    select (
--    select count(*)
--    from stg_prontuario.diagnostico d
--    where d.id_atendimento in (
--    select am.id
--    from stg_prontuario.atendimento_medico am
--    where am.tipo like 'U')) / (
--    select count(*)
--    from stg_prontuario.atendimento_medico am
--    where am.tipo like 'U')
--    as media_diagnosticos_urgencia;