--
-- PostgreSQL database dump
--

\restrict 2EiP4P9KDfuaHI8wAc0JuFMwx8CZ8oTzUvT5uDYabuvNmgqPd3xcbXN8gc6yNhp

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-23 16:41:36

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 30082)
-- Name: consumidor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consumidor (
    codigo integer NOT NULL,
    dadospagamento character varying(255)
);


ALTER TABLE public.consumidor OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 30108)
-- Name: endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco (
    codigo integer NOT NULL,
    usuarioid integer NOT NULL,
    cidade character varying(100) NOT NULL,
    estado character(2) NOT NULL,
    logradouro character varying(150) NOT NULL,
    numero integer,
    bairro character varying(100),
    cep character(8) NOT NULL,
    complemento character varying(100)
);


ALTER TABLE public.endereco OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 30107)
-- Name: endereco_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.endereco_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.endereco_codigo_seq OWNER TO postgres;

--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 223
-- Name: endereco_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.endereco_codigo_seq OWNED BY public.endereco.codigo;


--
-- TOC entry 230 (class 1259 OID 30155)
-- Name: itempedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itempedido (
    codigo integer NOT NULL,
    pedidoid integer NOT NULL,
    produtoid integer NOT NULL,
    quantidade integer NOT NULL,
    precounitario numeric NOT NULL
);


ALTER TABLE public.itempedido OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 30154)
-- Name: itempedido_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.itempedido_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.itempedido_codigo_seq OWNER TO postgres;

--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 229
-- Name: itempedido_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.itempedido_codigo_seq OWNED BY public.itempedido.codigo;


--
-- TOC entry 228 (class 1259 OID 30140)
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    codigo integer NOT NULL,
    consumidorid integer NOT NULL,
    datapedido date NOT NULL,
    status character varying(20),
    motivocancelamento character varying(255),
    datacancelamento timestamp without time zone
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 30139)
-- Name: pedido_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_codigo_seq OWNER TO postgres;

--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 227
-- Name: pedido_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_codigo_seq OWNED BY public.pedido.codigo;


--
-- TOC entry 226 (class 1259 OID 30126)
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    codigo integer NOT NULL,
    nome character varying(100) NOT NULL,
    preco numeric NOT NULL,
    peso numeric NOT NULL,
    qtdeestoque integer NOT NULL
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 30125)
-- Name: produto_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produto_codigo_seq OWNER TO postgres;

--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 225
-- Name: produto_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_codigo_seq OWNED BY public.produto.codigo;


--
-- TOC entry 222 (class 1259 OID 30093)
-- Name: produtor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtor (
    codigo integer NOT NULL,
    cnpj character(14),
    nomepropriedade character varying(100) NOT NULL
);


ALTER TABLE public.produtor OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 30067)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    codigo integer NOT NULL,
    nome character varying(150) NOT NULL,
    cpf character(11) NOT NULL,
    email character varying(100) NOT NULL,
    telefone character varying(20),
    senha character varying(255) NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 30066)
-- Name: usuario_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_codigo_seq OWNER TO postgres;

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuario_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_codigo_seq OWNED BY public.usuario.codigo;


--
-- TOC entry 4885 (class 2604 OID 30111)
-- Name: endereco codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco ALTER COLUMN codigo SET DEFAULT nextval('public.endereco_codigo_seq'::regclass);


--
-- TOC entry 4888 (class 2604 OID 30158)
-- Name: itempedido codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedido ALTER COLUMN codigo SET DEFAULT nextval('public.itempedido_codigo_seq'::regclass);


--
-- TOC entry 4887 (class 2604 OID 30143)
-- Name: pedido codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido ALTER COLUMN codigo SET DEFAULT nextval('public.pedido_codigo_seq'::regclass);


--
-- TOC entry 4886 (class 2604 OID 30129)
-- Name: produto codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto ALTER COLUMN codigo SET DEFAULT nextval('public.produto_codigo_seq'::regclass);


--
-- TOC entry 4884 (class 2604 OID 30070)
-- Name: usuario codigo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN codigo SET DEFAULT nextval('public.usuario_codigo_seq'::regclass);


--
-- TOC entry 5062 (class 0 OID 30082)
-- Dependencies: 221
-- Data for Name: consumidor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consumidor (codigo, dadospagamento) FROM stdin;
1	PIX
\.


--
-- TOC entry 5065 (class 0 OID 30108)
-- Dependencies: 224
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.endereco (codigo, usuarioid, cidade, estado, logradouro, numero, bairro, cep, complemento) FROM stdin;
1	1	São Paulo	SP	Rua 10	213	Centro	15733000	Casa ao fundo
2	2	Jales	SP	Estrada da uva	0		16738353	Porteira azul
\.


--
-- TOC entry 5071 (class 0 OID 30155)
-- Dependencies: 230
-- Data for Name: itempedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itempedido (codigo, pedidoid, produtoid, quantidade, precounitario) FROM stdin;
15	1	1	3	24.99
16	1	2	3	4.0
\.


--
-- TOC entry 5069 (class 0 OID 30140)
-- Dependencies: 228
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido (codigo, consumidorid, datapedido, status, motivocancelamento, datacancelamento) FROM stdin;
1	1	2026-11-22	CRIADO	\N	\N
\.


--
-- TOC entry 5067 (class 0 OID 30126)
-- Dependencies: 226
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (codigo, nome, preco, peso, qtdeestoque) FROM stdin;
1	Café	24.99	0.5	50
2	Farinha de Trigo	4	1	20
\.


--
-- TOC entry 5063 (class 0 OID 30093)
-- Dependencies: 222
-- Data for Name: produtor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtor (codigo, cnpj, nomepropriedade) FROM stdin;
2	74750970000140	Sítio São José
\.


--
-- TOC entry 5061 (class 0 OID 30067)
-- Dependencies: 220
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (codigo, nome, cpf, email, telefone, senha) FROM stdin;
1	Pedro Antônio Silva	11144477735	antoniopedro@gmail.com	(17) 99538-8217	123456
2	José Carlos de Souza	52998224725	josecarlos@gmail.com	(17) 99638-8637	12345678
\.


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 223
-- Name: endereco_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_codigo_seq', 2, true);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 229
-- Name: itempedido_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.itempedido_codigo_seq', 18, true);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 227
-- Name: pedido_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_codigo_seq', 8, true);


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 225
-- Name: produto_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_codigo_seq', 2, true);


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuario_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_codigo_seq', 2, true);


--
-- TOC entry 4894 (class 2606 OID 30087)
-- Name: consumidor consumidor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumidor
    ADD CONSTRAINT consumidor_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4900 (class 2606 OID 30119)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4906 (class 2606 OID 30167)
-- Name: itempedido itempedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedido
    ADD CONSTRAINT itempedido_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4904 (class 2606 OID 30148)
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4902 (class 2606 OID 30138)
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4896 (class 2606 OID 30101)
-- Name: produtor produtor_cnpj_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtor
    ADD CONSTRAINT produtor_cnpj_key UNIQUE (cnpj);


--
-- TOC entry 4898 (class 2606 OID 30099)
-- Name: produtor produtor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtor
    ADD CONSTRAINT produtor_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4890 (class 2606 OID 30081)
-- Name: usuario usuario_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_cpf_key UNIQUE (cpf);


--
-- TOC entry 4892 (class 2606 OID 30079)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4907 (class 2606 OID 30088)
-- Name: consumidor consumidor_codigo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumidor
    ADD CONSTRAINT consumidor_codigo_fkey FOREIGN KEY (codigo) REFERENCES public.usuario(codigo) ON DELETE CASCADE;


--
-- TOC entry 4909 (class 2606 OID 30120)
-- Name: endereco endereco_usuarioid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_usuarioid_fkey FOREIGN KEY (usuarioid) REFERENCES public.usuario(codigo) ON DELETE CASCADE;


--
-- TOC entry 4911 (class 2606 OID 30168)
-- Name: itempedido itempedido_pedidoid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedido
    ADD CONSTRAINT itempedido_pedidoid_fkey FOREIGN KEY (pedidoid) REFERENCES public.pedido(codigo) ON DELETE CASCADE;


--
-- TOC entry 4912 (class 2606 OID 30173)
-- Name: itempedido itempedido_produtoid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itempedido
    ADD CONSTRAINT itempedido_produtoid_fkey FOREIGN KEY (produtoid) REFERENCES public.produto(codigo) ON DELETE CASCADE;


--
-- TOC entry 4910 (class 2606 OID 30149)
-- Name: pedido pedido_consumidorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_consumidorid_fkey FOREIGN KEY (consumidorid) REFERENCES public.consumidor(codigo) ON DELETE CASCADE;


--
-- TOC entry 4908 (class 2606 OID 30102)
-- Name: produtor produtor_codigo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtor
    ADD CONSTRAINT produtor_codigo_fkey FOREIGN KEY (codigo) REFERENCES public.usuario(codigo) ON DELETE CASCADE;


-- Completed on 2026-11-23 16:41:37

--
-- PostgreSQL database dump complete
--

\unrestrict 2EiP4P9KDfuaHI8wAc0JuFMwx8CZ8oTzUvT5uDYabuvNmgqPd3xcbXN8gc6yNhp

