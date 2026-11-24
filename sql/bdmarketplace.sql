create table usuario (
    codigo serial primary key,
    nome varchar(150) not null,
    cpf char(11) not null unique,
    email varchar(100) not null,
    telefone varchar(20),
    senha varchar(255) not null
);

create table consumidor (
    codigo integer primary key references usuario(codigo) on delete cascade,
    dadospagamento varchar(255)
);

create table produtor (
    codigo integer primary key references usuario(codigo) on delete cascade,
    cnpj char(14) unique,
    nomepropriedade varchar(100) not null
);

create table endereco (
    codigo serial primary key,
    usuarioid integer not null references usuario(codigo) on delete cascade,
    cidade varchar(100) not null,
    estado char(2) not null,
    logradouro varchar(150) not null,
    numero integer,
    bairro varchar(100),
    cep char(8) not null,
    complemento varchar(100)
);

create table produto(
    codigo serial primary key,
    nome varchar(100) not null,
    preco numeric not null,
    peso numeric not null,
    qtdeestoque integer not null
);

create table pedido (
    codigo serial primary key,
    consumidorid integer not null references consumidor(codigo) on delete cascade,
    datapedido timestamp not null,
    status varchar(20),
	motivocancelamento varchar(255),
	datacancelamento timestamp
);

create table itempedido(
    codigo serial primary key,
    pedidoid integer not null references pedido(codigo) on delete cascade,
    produtoid integer not null references produto(codigo) on delete cascade,
    quantidade integer not null,
    precounitario numeric not null
);