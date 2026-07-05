--
-- PostgreSQL database dump
--

-- Dumped from database version 16.14
-- Dumped by pg_dump version 17.0

-- Started on 2026-07-05 16:49:00

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
-- TOC entry 221 (class 1259 OID 16458)
-- Name: aliments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aliments (
    t_groupe_code integer,
    t_ss_groupe_code integer,
    t_ss_ss_groupe_code integer,
    t_groupe_nom text,
    t_ss_groupe_nom text,
    t_ss_ss_groupe_nom text,
    t_aliment_code integer NOT NULL,
    t_aliment_nom text NOT NULL,
    t_proteines numeric,
    t_glucides numeric,
    t_lipides numeric,
    t_energie numeric
);


ALTER TABLE public.aliments OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16466)
-- Name: groupes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groupes (
    code integer NOT NULL,
    nom text NOT NULL
);


ALTER TABLE public.groupes OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16436)
-- Name: recipe_ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe_ingredients (
    id integer NOT NULL,
    recipe_id integer NOT NULL,
    aliment_code integer NOT NULL,
    quantity_g numeric NOT NULL,
    CONSTRAINT recipe_ingredients_quantity_g_check CHECK ((quantity_g > (0)::numeric))
);


ALTER TABLE public.recipe_ingredients OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16435)
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipe_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_ingredients_id_seq OWNER TO postgres;

--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 219
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipe_ingredients_id_seq OWNED BY public.recipe_ingredients.id;


--
-- TOC entry 218 (class 1259 OID 16404)
-- Name: recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipes (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    steps text NOT NULL,
    author_id integer NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    reviewed_at timestamp with time zone,
    reviewed_by integer,
    servings integer DEFAULT 1 NOT NULL,
    CONSTRAINT recipes_servings_check CHECK ((servings > 0)),
    CONSTRAINT recipes_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.recipes OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16403)
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_id_seq OWNER TO postgres;

--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 217
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- TOC entry 223 (class 1259 OID 16473)
-- Name: sous_groupes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sous_groupes (
    groupe_code integer NOT NULL,
    code integer NOT NULL,
    nom text NOT NULL
);


ALTER TABLE public.sous_groupes OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16485)
-- Name: sous_sous_groupes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sous_sous_groupes (
    groupe_code integer NOT NULL,
    sous_groupe_code integer NOT NULL,
    code integer NOT NULL,
    nom text NOT NULL
);


ALTER TABLE public.sous_sous_groupes OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16390)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    role character varying(20) DEFAULT 'user'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    username character varying(50) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(30) NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'user'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16389)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3334 (class 2604 OID 16439)
-- Name: recipe_ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients ALTER COLUMN id SET DEFAULT nextval('public.recipe_ingredients_id_seq'::regclass);


--
-- TOC entry 3330 (class 2604 OID 16407)
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- TOC entry 3327 (class 2604 OID 16393)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3518 (class 0 OID 16458)
-- Dependencies: 221
-- Data for Name: aliments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aliments (t_groupe_code, t_ss_groupe_code, t_ss_ss_groupe_code, t_groupe_nom, t_ss_groupe_nom, t_ss_ss_groupe_nom, t_aliment_code, t_aliment_nom, t_proteines, t_glucides, t_lipides, t_energie) FROM stdin;
0	0	0				24999	Dessert (aliment moyen)	4.61	36.6	12.9	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25601	Salade de thon et légumes, appertisée	9.15	7.74	4.7	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25602	Salade composée avec viande ou poisson, appertisée	8.06	6.4	5.3	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25605	Champignons à la grecque, appertisés	2.08	3.95	3.55	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25606	Salade de pommes de terre, fait maison	2.68	9.9	8.2	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25608	Taboulé ou Salade de couscous, préemballé	4.88	23.7	6.7	179
1	101	0	entrées et plats composés	salades composées et crudités	-	25609	Salade de pomme de terre à la piémontaise, préemballée	4.5	8.87	8.3	130
1	101	0	entrées et plats composés	salades composées et crudités	-	25614	Salade de riz, appertisée	5.13	16.1	4.35	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25615	Salade de pâtes, végétarienne	5.7	13.7	8.1	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25616	Crudité, sans assaisonnement (aliment moyen)	0.94	3.07	0.7	29.9
1	101	0	entrées et plats composés	salades composées et crudités	-	25619	Salade de pâtes aux légumes, avec poisson ou viande, préemballée	5.19	14	9.94	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25626	Macédoine de légumes en salade, avec sauce, préemballée	2.81	7	9.3	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25628	Salade César au poulet (salade verte, fromage, croûtons, sauce), préemballée	8.13	4.88	10	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	25629	Salade végétale à base de boulgour et/ou quinoa et légumes, préemballée	4.06	17.4	8.3	168
1	101	0	entrées et plats composés	salades composées et crudités	-	26257	Carottes râpées, avec sauce, préemballées	0.98	6.01	5	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	26258	Salade de betterave, avec sauce, préemballée	1.29	7.45	4.94	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	26259	Salade de chou ou Coleslaw, avec sauce, préemballée	0.94	5.78	8.1	105
1	101	0	entrées et plats composés	salades composées et crudités	-	26260	Salade de concombre à la crème/fromage blanc, préemballée	1.1	1.97	11.3	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	26261	Salade de lentilles et saucisse fumée, préemballée	7	8.9	11.8	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	26262	Salade grecque, avec sauce, préemballée	2	1.4	7.1	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	26263	Salade de riz à la niçoise, avec sauce, préemballée	4.45	15.8	6.08	\N
1	101	0	entrées et plats composés	salades composées et crudités	-	26269	Taboulé ou Salade de couscous au poulet, préemballé	6.4	20.6	7.45	\N
1	102	0	entrées et plats composés	soupes	-	25900	Soupe aux lentilles, préemballée à réchauffer	3.74	6.6	1.12	55
1	102	0	entrées et plats composés	soupes	-	25901	Soupe à la volaille et aux légumes, préemballée à réchauffer	3.09	2.6	0.8	30.8
1	102	0	entrées et plats composés	soupes	-	25903	Soupe aux légumes variés, préemballée à réchauffer	0.76	5.05	1.56	39.4
1	102	0	entrées et plats composés	soupes	-	25904	Soupe de poissons et / ou crustacés, préemballée à réchauffer	3.45	2.88	1.79	42.8
1	102	0	entrées et plats composés	soupes	-	25905	Soupe aux légumes variés, déshydratée reconstituée	0.86	4.43	1.22	34.5
1	102	0	entrées et plats composés	soupes	-	25907	Soupe aux poireaux et pommes de terre, préemballée à réchauffer	0.79	4.46	1.51	37.1
1	102	0	entrées et plats composés	soupes	-	25908	Soupe à la volaille et aux vermicelles, préemballée à réchauffer	1.3	3.86	1	30.8
1	102	0	entrées et plats composés	soupes	-	25909	Bouillon de viande et légumes type pot-au-feu, prêt à consommer	0.2	0.1	0.4	4.8
1	102	0	entrées et plats composés	soupes	-	25910	Soupe à l oignon, préemballée à réchauffer	1.35	4.93	1.4	40.4
1	102	0	entrées et plats composés	soupes	-	25912	Soupe aux champignons, préemballée à réchauffer	0.81	4.09	3.07	48.2
1	102	0	entrées et plats composés	soupes	-	25913	Soupe à la carotte, préemballée à réchauffer	0.61	3.89	1.41	33.2
1	102	0	entrées et plats composés	soupes	-	25914	Soupe à la tomate, préemballée à réchauffer	0.74	6.27	0.99	38.7
1	102	0	entrées et plats composés	soupes	-	25915	Soupe chorba frik, à base de viande et de frik	3.75	5.4	2.5	62.9
1	102	0	entrées et plats composés	soupes	-	25916	Soupe minestrone, préemballée à réchauffer	1.2	5.6	2	48.8
1	102	0	entrées et plats composés	soupes	-	25917	Soupe au pistou, déshydratée reconstituée	1.2	5.2	0.35	30.4
1	102	0	entrées et plats composés	soupes	-	25919	Soupe de poissons et / ou crustacés, déshydratée reconstituée	0.91	5.09	0.5	29
1	102	0	entrées et plats composés	soupes	-	25923	Soupe asiatique, avec pâtes, déshydratée reconstituée	0.97	5.25	0.44	29.8
1	102	0	entrées et plats composés	soupes	-	25924	Soupe marocaine, déshydratée reconstituée	1.2	5.77	0.55	34.3
1	102	0	entrées et plats composés	soupes	-	25925	Soupe aux poireaux et pommes de terre, déshydratée reconstituée	0.63	4.84	0.41	26.1
1	102	0	entrées et plats composés	soupes	-	25928	Soupe à la volaille et aux légumes, déshydratée reconstituée	0.99	4.58	0.44	27.3
1	102	0	entrées et plats composés	soupes	-	25930	Bouillon de boeuf, déshydraté reconstitué	0.6	1.33	0.15	9.05
1	102	0	entrées et plats composés	soupes	-	25932	Soupe aux asperges, déshydratée reconstituée	0.6	5.14	1.31	35.3
1	102	0	entrées et plats composés	soupes	-	25933	Soupe à la tomate et aux vermicelles, préemballée à réchauffer	1.1	5.87	0.8	37.7
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25122	Gratin de pâtes	7.06	16.4	9.2	179
1	102	0	entrées et plats composés	soupes	-	25934	Soupe aux céréales et aux légumes, déshydratée reconstituée	1.4	6.8	1.4	47.8
1	102	0	entrées et plats composés	soupes	-	25935	Soupe à la tomate, déshydratée reconstituée	0.76	5.79	0.97	36.2
1	102	0	entrées et plats composés	soupes	-	25936	Soupe aux champignons, déshydratée reconstituée	0.65	4.37	1.79	37.8
1	102	0	entrées et plats composés	soupes	-	25942	Soupe à l oignon, déshydratée reconstituée	0.58	4.37	0.4	24
1	102	0	entrées et plats composés	soupes	-	25945	Soupe au potiron, préemballée à réchauffer	0.67	4.13	1.56	35.9
1	102	0	entrées et plats composés	soupes	-	25947	Bouillon de volaille, déshydraté reconstitué	0.6	0.5	0.13	5.58
1	102	0	entrées et plats composés	soupes	-	25948	Bouillon de légumes, déshydraté reconstitué	0.34	0.65	0.16	5.38
1	102	0	entrées et plats composés	soupes	-	25949	Soupe à la tomate et aux vermicelles, déshydratée reconstituée	0.63	4.21	0.18	21.6
1	102	0	entrées et plats composés	soupes	-	25950	Soupe à la volaille et aux vermicelles, déshydratée reconstituée	0.75	3.87	0.25	21.3
1	102	0	entrées et plats composés	soupes	-	25953	Soupe au pistou, préemballée à réchauffer	2	4.1	0.5	31.9
1	102	0	entrées et plats composés	soupes	-	25954	Soupe au potiron, déshydratée reconstituée	0.79	5.61	1.24	38.3
1	102	0	entrées et plats composés	soupes	-	25955	Soupe asiatique, avec pâtes, préemballée à réchauffer	0.7	3.4	0.5	22.3
1	102	0	entrées et plats composés	soupes	-	25956	Soupe minestrone, déshydratée reconstituée	1.14	5.53	0.34	31.3
1	102	0	entrées et plats composés	soupes	-	25957	Soupe au cresson, déshydratée reconstituée	0.42	3.95	0.8	25.1
1	102	0	entrées et plats composés	soupes	-	25958	Soupe au cresson, préemballée à réchauffer	1	5.4	0.8	34
1	102	0	entrées et plats composés	soupes	-	25962	Soupe aux légumes avec fromage, préemballée à réchauffer	1.34	5.09	2.51	50.2
1	102	0	entrées et plats composés	soupes	-	25963	Soupe aux légumes verts, préemballée à réchauffer	1	3.84	1.32	33.4
1	102	0	entrées et plats composés	soupes	-	25964	Soupe aux légumes verts, déshydratée reconstituée	0.72	5.31	1.07	34.8
1	102	0	entrées et plats composés	soupes	-	25965	Soupe aux pois cassés, préemballée à réchauffer	2.68	6.25	1.98	56.7
1	102	0	entrées et plats composés	soupes	-	25967	Soupe froide type Gaspacho ou Gazpacho, préemballée	0.65	3.38	1.62	32.8
1	102	0	entrées et plats composés	soupes	-	25968	Soupe aux asperges, préemballée à réchauffer	4.6	4.7	10.4	133
1	102	0	entrées et plats composés	soupes	-	25969	Soupe (aliment moyen)	1.27	4.5	1.37	37.4
1	102	0	entrées et plats composés	soupes	-	25972	Soupe miso, déshydratée reconstituée	1.38	2.18	0.5	17.1
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	8601	Tripes à la mode de Caen	20.4	0.3	3.68	116
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	8602	Tripes à la mode de Caen, préemballées	18.4	0.7	3.62	112
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	8612	Tripes à la tomate ou à la provençale	15.7	0.6	3.2	94.1
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25001	Blanquette de veau	15.4	3.1	4	113
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25033	Boeuf bourguignon	8.93	4.17	3.3	84.6
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25035	Sauté d agneau au curry, préemballé	10.5	\N	13.9	\N
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25058	Canard en sauce (poivre vert, chasseur, etc.), préemballé	9.55	10.2	7.3	145
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25063	Lapin à la moutarde, préemballé	14.9	0.5	5	108
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25121	Coq au vin	13	4	7	133
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25125	Paupiette de veau	14.5	2.6	13.8	193
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25126	Paupiette de volaille	23.9	8.8	3.4	164
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25172	Viande en sauce (aliment moyen)	11.3	3.65	4.6	104
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25174	Poulet au curry et au lait de coco	10.6	3.15	6.9	124
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25175	Meloukhia, plat à base de boeuf et corete, fait maison	10.6	1.2	14.7	189
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25200	Palette à la diable, préemballée	13.5	2.08	6.07	120
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25201	Langue de boeuf sauce madère, préemballée	9.5	4.5	13.5	180
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25207	Porc au caramel, préemballé	10	11.4	5.4	136
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25211	Boulettes au boeuf, à la sauce tomate, préemballées	9	5.5	6.5	117
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25213	Paupiette de veau, préemballée,  cuite au four	22	0.48	20.5	276
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25538	Carpaccio de boeuf, avec marinade	15.2	0.55	23	271
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25565	Yakitori (brochettes japonaises grillées en sauce)	26	9.3	3.3	172
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25585	Brochette de boeuf, cuite	21.9	0.33	5.2	139
1	103	10301	entrées et plats composés	plats composés	plats de viande sans garniture	25586	Brochette de volaille, cuite	23.1	1.39	4	137
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20039	Poireau, cru	1.49	4.9	0.25	32.3
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25009	Hachis parmentier à la viande, préemballé	5.99	9.39	8.22	138
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25029	Couscous au mouton	8.31	12.2	7.2	149
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25043	Couscous à la viande ou au poulet, préemballé, allégé	5.9	11.5	1.9	90.7
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25057	Poêlée de pommes de terre préfrites, lardons ou poulet, et autres, sans légumes verts, préemballée	3.2	16.2	9.6	168
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25127	Couscous royal (avec plusieurs viandes), préemballé	7.69	14	4.53	132
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25138	Couscous au poulet	7.5	15.6	3.85	130
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25152	Couscous à la viande, préemballé	7.59	12.5	4.73	128
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25195	Parmentier de canard, préemballé	6.82	8.51	9.06	146
1	103	10302	entrées et plats composés	plats composés	plats de viande et féculents	25587	Parmentier de canard, préemballé, cuit	7	10.5	10.2	168
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25002	Cassoulet, appertisé	8.06	9.41	5.77	129
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25003	Choucroute garnie, préemballée	5.06	2.8	8.06	109
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25010	Petit salé ou saucisse aux lentilles, préemballé	8.24	8.89	4.87	118
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25013	Pot-au-feu, préemballé	10.9	3.2	2.02	77.5
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25065	Boeuf aux carottes	13.2	3.3	3.15	96.6
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25071	Potée auvergnate (chou et porc)	6	3.7	4.3	82.1
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25098	Cassoulet au porc, appertisé	8.3	8.6	6.3	132
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25099	Cassoulet au canard ou oie, appertisé	10.5	10.1	7.86	161
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25103	Tomate farcie	5.49	2	9.67	122
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25106	Chou farci, préemballé	5.3	2	6.6	94.9
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25111	Chili con carne, préemballé	7.13	13	3.35	118
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25123	Moussaka	5.82	5.16	10.8	147
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25124	Navarin d agneau aux légumes	8.05	5	8.61	133
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25159	Tajine de mouton	12.8	4.5	6.83	132
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25164	Osso buco	11.2	3.5	4.08	96.7
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25190	Poulet basquaise, préemballé	9.3	2.5	6.4	107
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25204	Tajine de poulet, préemballé	7.54	14.4	3.7	127
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25205	Chop suey (porc ou poulet), préemballé	5	7.8	3	78.2
1	103	10303	entrées et plats composés	plats composés	plats de viande et légumes/légumineuses	25511	Légumes farcis (sauf tomate)	6.4	3.6	3	69.8
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	10082	Moules marinières (oignons et vin blanc)	10.3	7.43	2.24	92
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	10083	Moules farcies (matière grasse, persillade…), préemballées, crues	9.56	4.43	24.8	284
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25037	Gratin ou cassolette de poisson et / ou fruits de mer,  préemballé, cru	6.13	8.39	5.1	105
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25038	Gratin ou cassolette de poisson et / ou fruits de mer, préemballé, cuit	6.69	5.28	7.5	117
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25077	Saumon à l oseille, préemballé	8.36	7.43	7.65	133
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25086	Poisson blanc à la bordelaise, préemballé	14.8	5.3	10.4	176
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25128	Poisson blanc à la provençale ou niçoise (sauce tomate), préemballé	9.31	3.1	2.3	75.2
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25140	Poisson blanc à la florentine (sauce aux épinards), préemballé	11.4	2.9	4.35	100
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25141	Poisson blanc à la marinière (sauce aux oignons, vin blanc, moules), préemballé	11.5	2.2	2.8	80
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25142	Poisson blanc à la sauce moutarde, préemballé	9.2	5.4	3.6	90.8
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25143	Poisson blanc à la parisienne (sauce aux champignons), préemballé	9.16	3	3.25	79.9
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25145	Poisson blanc à l estragon, préemballé	8.8	4.2	2.8	77.2
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25146	Poisson blanc sauce oseille, préemballé	11.8	3.9	5.5	114
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25210	Saumon farci, préemballé	18.8	0.4	16.2	227
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25539	Brochette de poisson	18	0.86	5.71	127
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	25540	Brochette de crevettes	18.5	1.5	1.5	93.5
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	26054	Poisson en sauce, surgelé	13.3	3.18	7.05	132
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	26140	Poisson cuit (aliment moyen)	23.5	0	5.52	144
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	26249	Poisson blanc, cuit (aliment moyen)	22	0	2.18	107
1	103	10304	entrées et plats composés	plats composés	plats de poisson sans garniture	26250	Poisson blanc, de mer, cuit (aliment moyen)	22.1	0	2	106
1	103	10305	entrées et plats composés	plats composés	plats de poisson et féculents	25031	Paëlla	7.86	17.1	4.9	148
1	103	10305	entrées et plats composés	plats composés	plats de poisson et féculents	25107	Couscous au poisson	7.5	14.2	1.6	105
1	103	10305	entrées et plats composés	plats composés	plats de poisson et féculents	25154	Gratin de poisson et purée ou brandade aux pommes de terre ou parmentier de poisson, préemballé	6.39	8.57	6.15	117
1	103	10305	entrées et plats composés	plats composés	plats de poisson et féculents	25456	Sushi ou Maki aux produits de la mer	6.69	26.9	3.7	171
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	8296	Terrine ou mousse de légumes	4.05	5.6	9.56	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	8297	Flan de légumes	5.38	4.13	18.6	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	20194	Haricots blancs à la sauce tomate, appertisés	4.67	10.1	0.4	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	20240	Piperade basquaise, préemballée	1.1	6.5	3.8	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	20262	Poêlée de légumes assaisonnés sans champignon, surgelée, crue	2.6	12.1	1.77	81.2
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	20273	Poêlée de légumes assaisonnés à l asiatiques ou wok de légumes, surgelée, crue	3.13	5.83	3.93	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	20274	Poêlée de légumes assaisonnés grillée, méridionale ou méditerranéenne, surgelée, crue	1.61	4.33	1.77	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	20498	Poêlée de légumes assaisonnés aux champignons ("champêtre"), surgelée	1.89	3.59	1.21	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25018	Ratatouille cuisinée, préemballée	1.22	4.97	3.15	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25026	Épinards à la crème, préemballés	2.5	4.1	2.9	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25052	Gratin d aubergine, préemballé	1.95	5.45	8.68	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25056	Gratin dauphinois	3.38	14.5	4.2	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25073	Endive au jambon	7.44	4.71	6.3	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25101	Gratin de chou-fleur, préemballé	3	3.3	6.5	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25162	Gratin de légumes	3.44	6.91	6.7	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25196	Riste d aubergines (aubergines, tomates, oignons), préemballée	1.05	10.6	10.4	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25199	Palet ou galette de légumes, préfrit, surgelé	3.29	10.7	5.44	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25208	Palet ou galette de légumes, préfrit, surgelé, cuit	3.31	8.45	5.7	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25220	Choucroute, sans garniture, égouttée, cuite	1.38	0.1	6.6	75.3
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25524	Tomate à la provençale, fait maison	1.65	6.55	4.32	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25556	Beignet de légumes	3.52	23	8.52	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25571	Falafel ou Boulette de pois-chiche et/ou fève, frite	8.25	18.7	14.4	252
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25588	Gratin de légumes en sauce blanche type béchamel, cuit	3.56	6.74	6.5	\N
1	103	10306	entrées et plats composés	plats composés	plats de légumes/légumineuses	25590	Falafel ou Boulette de pois-chiche et/ou fève, préemballé	7.38	17.7	10.8	211
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	9082	Blé dur précuit cuisiné, en sachet micro-ondable	5.29	29.5	4.84	188
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	9083	Blé dur précuit, grains entiers, cuisiné, à poêler	12.1	67.2	1.59	344
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25019	Ravioli à la viande, sauce tomate, appertisé	4.22	12.5	2.83	95.3
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25081	Lasagnes ou cannelloni à la viande (bolognaise)	6.29	13.5	5.72	134
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25085	Pâtes à la bolognaise (spaghetti, tagliatelles…)	5.32	13.6	4.07	116
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25088	Riz cantonais	5.46	23.6	4.94	164
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25110	Ravioli chinois à la vapeur à la crevette, cuit	5.5	27.8	5.5	190
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25131	Lasagnes ou cannellonis aux légumes, préemballées, cuits	2.75	11	4.85	103
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25135	Pâtes à la carbonara (spaghetti, tagliatelles…)	5.91	14.2	8.7	161
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25139	Lasagnes ou cannellonis au poisson, préemballées	7.28	13	7.1	148
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25149	Pâtes fraîches farcies (ex : raviolis, tortellinis, ravioles du Dauphiné), au fromage, cuites	10	26.8	8.3	226
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25150	Couscous de légumes, préemballé	4.32	16.4	2.25	108
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25155	Pâtes fraîches farcies (ex : raviolis, tortellinis), au fromage et aux légumes, préemballées, cuites	7.94	27.8	7.5	219
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25157	Pâtes fraîches farcies (ex : raviolis, totellinis), à la viande (ex : bolognaise), préemballées, crues	11.4	40.3	5.79	265
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25158	Pâtes fraîches farcies (ex : raviolis, tortellinis), à la viande (ex : bolognaise), préemballées, cuites	6.94	25.1	4.65	174
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25181	Pâtes fraîches farcies (ex : raviolis, tortellinis, ravioles du Dauphiné), au fromage, préemballées, crues	11.3	37.3	7.69	268
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25182	Pâtes fraîches farcies (ex : raviolis, tortellinis), au fromage et aux légumes, préemballées, crues	9.98	41.4	5.69	262
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25183	Nouilles sautées/poêlées aux crevettes	4.88	12.6	3.4	104
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25184	Riz blanc, avec poulet, préemballé, cuit	4.44	31.5	3.19	175
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25185	Riz blanc, avec légumes et viande, préemballé, cuit	4.85	28.3	3.57	167
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25187	Risotto, aux légumes, préemballé	2.88	18.4	3.8	120
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25188	Risotto, aux fruits de mer, préemballé	5.75	12.5	6.07	130
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25189	Risotto, aux fromages, préemballé	5.93	30.9	5.16	195
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25192	Raviolis aux légumes, sauce tomate, appertisés	2.88	13.5	2.45	91.1
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25193	Pâtes fraîches farcies (ex : raviolis, tortellinis), aux légumes, préemballées, cuites	5.19	20.9	4.9	156
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25198	Pâtes en sauce aux fromages (spaghetti, tagliatelles…), préemballées	7.17	15.9	7.4	163
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25203	Pâtes fraîches farcies (ex : raviolis, tortellinis), aux légumes, préemballées, crues	9.4	41.4	5.06	255
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25216	Pâtes fraîches farcies (ex : raviolis, tortellinis), cuites (aliment moyen)	7.98	25.7	6.53	199
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25217	Feuille de vigne farcie au riz ou dolmas, égouttée, préemballée	2.63	18.6	6.5	150
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25218	Lasagnes ou cannellonis aux légumes, préemballés, cuits	4.38	11.8	5.9	122
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25219	Lasagnes ou cannellonis aux légumes et au fromage de chèvre, préemballés, cuits	7	14	10.2	179
1	103	10307	entrées et plats composés	plats composés	plats de céréales/pâtes	25635	Lasagnes ou cannellonis au fromage et aux épinards, préemballés	6.1	11.4	6.6	133
1	103	10308	entrées et plats composés	plats composés	plats de fromage	4041	Aligot (purée de pomme de terre à la tomme fraîche), préemballé	8.06	9.5	13.3	195
1	103	10308	entrées et plats composés	plats composés	plats de fromage	19437	Fromage de chèvre pané à dorer, préemballé	12.7	15	19.2	\N
1	103	10308	entrées et plats composés	plats composés	plats de fromage	25020	Soufflé au fromage	12.9	3.8	12.6	184
1	103	10308	entrées et plats composés	plats composés	plats de fromage	25137	Tartiflette, préemballée	6	13.5	8.9	161
1	103	10308	entrées et plats composés	plats composés	plats de fromage	25437	Gougère	16.2	22.7	26.6	399
1	103	10308	entrées et plats composés	plats composés	plats de fromage	25509	Préparation à base de fromage(s) pour fondue savoyarde, préemballée	15.9	2.6	17.2	231
1	103	10308	entrées et plats composés	plats composés	plats de fromage	25546	Fromage pané au jambon	17.4	15.3	14.6	263
1	103	10309	entrées et plats composés	plats composés	plats végétariens	20914	Escalope végétale ou steak à base de soja	17	8.7	14.7	\N
1	103	10309	entrées et plats composés	plats composés	plats végétariens	20917	Tempeh	17.6	7.89	4.7	157
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25225	Nuggets de blé (sans soja), préemballé	13.5	22.4	14.9	284
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25226	Nuggets soja et blé (ne convient pas aux véganes ou végétaliens), préemballé	14.1	18.5	12.6	253
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25227	Nuggets soja et blé (convient aux véganes ou végétaliens), préemballé	15.5	19.7	10.9	251
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25228	Pané soja et blé (ne convient pas aux véganes ou végétaliens)	14.4	16.8	13.9	260
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25229	Bâtonnet pané soja et blé (convient aux véganes ou végétaliens), préemballée	16.9	18.8	10	245
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20276	Tomate ronde, crue	0.5	3.59	0.5	20.3
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25230	Escalope panée, soja, blé et fromage, type cordon bleu, préemballée	15.2	15.1	13.1	247
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25231	Raviolis au tofu, à la sauce tomate, préemballés	3.13	12.5	2.7	91.7
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25233	Galette de céréales au fromage (sans soja), préemballé	7	27.8	10.3	241
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25234	Galette de céréales aux légumes (sans soja), préemballé	5.31	28	7.6	211
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25589	Boulette végétale au soja et/ou blé, préemballée	17.6	7.98	10.6	211
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25591	Galette ou pavé aux lentilles, soja et légumes, préemballé	10.6	16.7	5.6	170
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25592	Galette ou pavé au blé (seitan) et légumes, préemballé	13.4	20.8	7.1	208
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25593	Galette ou pavé au blé et soja (convient aux véganes ou végétaliens), préemballé	17.5	8.15	11	215
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25594	Galette ou pavé au blé et soja (ne convient pas aux véganes ou végétaliens), préemballé	11.1	13.3	10.2	201
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25595	Galette ou pavé au soja et fromage, préemballé	16.8	6.08	12	204
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25596	Galette ou pavé au soja et légumes, préemballé	14.4	8.36	8.1	175
1	103	10309	entrées et plats composés	plats composés	plats végétariens	25597	Galette ou pavé au soja, fromage et légumes, préemballé	15.1	7.72	9.1	180
1	103	10309	entrées et plats composés	plats composés	plats végétariens	30181	Haché végétal à base de soja, préemballé	12.6	7.01	5.8	143
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25404	Pizza au fromage ou Pizza margherita, préemballée	9.09	29.6	7.64	227
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25405	Quiche lorraine, préemballée	8.96	21	16.8	274
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25409	Crêpe ou Galette fourrée béchamel jambon, préemballée	5.75	18.7	4	136
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25410	Crêpe ou Galette fourrée béchamel jambon fromage, préemballée	8.83	19.1	7.5	182
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25411	Crêpe ou Galette fourrée béchamel champignon, préemballée	4.83	20.7	5.02	150
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25417	Tarte aux légumes, préemballée	5	21.8	11.7	216
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25435	Pizza jambon fromage, préemballée	10.3	28	6.69	218
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25444	Tarte au fromage, préemballée	10.3	20.7	18	289
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25454	Tarte à la provençale, préemballée	5.5	20	14.3	241
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25457	Pizza à la viande, type bolognaise, préemballée	10.3	27.2	8.03	227
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25459	Burritos	8	14.3	8.5	170
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25460	Fajitas	12.7	16	4.5	158
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25462	Pizza au chorizo ou salami, préemballée	10.4	26.5	10.7	248
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25463	Pizza aux fruits de mer, préemballée	10.3	24.6	6.65	200
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25464	Pizza au saumon, préemballée	10.1	26.7	8.78	231
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25468	Pizza au chèvre et lardons, préemballée	10.7	26.9	9.96	245
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25472	Pizza aux légumes ou Pizza 4 saisons, préemballée	8.48	25.7	8	214
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25477	Pizza champignons fromage, préemballée	7.8	31.6	6.1	217
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25478	Pizza 4 fromages, préemballée	13.1	28.2	10.5	267
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25516	Pizza (aliment moyen)	10.8	27.3	8.39	233
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25528	Pissaladière, préemballée	6.4	33.8	13.1	284
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25529	Tarte à l oignon, préemballée	7	23.5	17.2	280
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25548	Pizza jambon fromage champignons ou pizza royale, reine ou regina, préemballée	9.54	25.7	6.66	205
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25549	Crêpe ou Galette fourrée béchamel fromage, préemballée	6.02	17.7	5.75	149
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25550	Flammenkueche ou Tarte flambée aux lardons, préemballée	8.81	31.8	14.8	300
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25552	Crêpe ou Galette fourrée béchamel jambon fromage champignon, préemballée	8.3	16.6	6.3	159
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25553	Tarte ou Tourte aux poireaux, préemballée	5.76	21.6	14.3	243
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25555	Tarte au saumon, préemballée	8.53	21	10.5	215
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25560	Tourte au riesling, préemballée	10.2	23.7	12.6	251
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25561	Tarte à la tomate, préemballée	5.17	19.3	12.8	218
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25562	Crêpe ou Galette complète (oeuf, jambon, fromage), préemballée	12.7	15.2	9.8	209
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25564	Tarte aux noix de Saint-Jacques, préemballée	8.25	24.2	14.5	266
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25568	Pastilla au poulet, préemballée	12.3	14.1	12.2	218
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25570	Pizza aux lardons, oignons et fromage, préemballée	11.2	27.7	10.6	255
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25572	Crêpe ou Galette aux noix de St Jacques, préemballée	7.7	15.8	8	168
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25573	Tarte ou quiche salée (aliment moyen)	8.11	22.7	15.6	267
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25581	Crêpe ou Galette fourrée béchamel champignon, cuite, préemballée	5.5	18.5	7.7	172
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25623	Tarte au maroilles ou Flamiche au maroilles, préemballée	14.1	22.1	18.3	315
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	25625	Crêpe ou Galette fourrée au poisson et / ou fruits de mer, préemballée	8.5	14.3	12.4	206
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	26256	Ficelle picarde, préemballée	8.6	11.9	7.5	151
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	26267	Tarte épinard chèvre, préemballée	7.08	22.2	13.6	244
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	26268	Tielle sétoise, préemballée	8.15	30.9	16	306
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	26270	Pizza au thon, préemballée	10.8	23.3	8.78	220
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	26271	Pizza kebab, préemballée	9.4	26.6	7.01	211
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	26272	Pizza au poulet, préemballée	9.95	27.5	6.68	215
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	26273	Pizza type raclette ou tartiflette, préemballée	11.8	27.5	12.7	276
1	104	0	entrées et plats composés	pizzas, tartes et crêpes salées	-	26274	Pizza au speck ou jambon cru, préemballée	12.2	25.7	9.43	240
1	105	0	entrées et plats composés	sandwichs	-	7811	Focaccia, garnie	8	29.5	8.75	233
1	105	0	entrées et plats composés	sandwichs	-	7812	Fougasse, garnie	9.53	38.8	11.8	306
1	105	0	entrées et plats composés	sandwichs	-	25400	Croque-monsieur, fait maison	14.3	\N	18.4	\N
1	105	0	entrées et plats composés	sandwichs	-	25403	Hot-dog, préemballé	10.9	26.3	13.8	278
1	105	0	entrées et plats composés	sandwichs	-	25413	Hamburger, provenant de fast food	13.3	28.3	8.44	246
1	105	0	entrées et plats composés	sandwichs	-	25414	Cheeseburger, provenant de fast food	14	23.1	12.9	268
1	105	0	entrées et plats composés	sandwichs	-	25415	Double cheeseburger, provenant de fast food	15.5	21.5	16.7	299
1	105	0	entrées et plats composés	sandwichs	-	25416	Burger au poisson, provenant de fast food	12.2	26.7	11.5	263
1	105	0	entrées et plats composés	sandwichs	-	25428	Sandwich grec ou Kebab, pita, crudités	15.2	17.4	10.9	233
1	105	0	entrées et plats composés	sandwichs	-	25429	Sandwich grec ou Kebab, baguette, crudités	15	23.6	9.8	246
1	105	0	entrées et plats composés	sandwichs	-	25431	Sandwich baguette, thon, crudités (tomate, salade), mayonnaise	10.3	32	11.3	274
1	105	0	entrées et plats composés	sandwichs	-	25434	Sandwich panini, jambon cru, mozzarella, tomates	14.2	27.2	8.35	243
1	105	0	entrées et plats composés	sandwichs	-	25475	Sandwich baguette, jambon, oeuf dur, crudités (tomate, salade), beurre	10.1	30.9	5.98	222
1	105	0	entrées et plats composés	sandwichs	-	25476	Sandwich baguette, poulet, crudités (tomate, salade), mayonnaise	10	36.3	6.35	247
1	105	0	entrées et plats composés	sandwichs	-	25485	Sandwich baguette, jambon emmental, préemballé	13.3	26.9	13.1	285
1	105	0	entrées et plats composés	sandwichs	-	25488	Sandwich baguette, saumon fumé, beurre	11.5	40.8	5.6	265
1	105	0	entrées et plats composés	sandwichs	-	25490	Sandwich baguette, thon, maïs, crudités, préemballé	8.87	25	6.03	198
1	105	0	entrées et plats composés	sandwichs	-	25502	Burger au poulet	12.7	23.8	11	249
1	105	0	entrées et plats composés	sandwichs	-	25513	Pan bagnat	7.95	30.3	6.48	215
1	105	0	entrées et plats composés	sandwichs	-	25517	Sandwich baguette, jambon, beurre	9.93	33.7	11.5	285
1	105	0	entrées et plats composés	sandwichs	-	25518	Sandwich baguette, camembert, beurre	11.9	34.3	16.7	339
1	105	0	entrées et plats composés	sandwichs	-	25519	Sandwich baguette, pâté, cornichons	10.1	32.1	13.9	298
1	105	0	entrées et plats composés	sandwichs	-	25520	Sandwich baguette, saucisson, beurre	13.7	32	21.6	383
1	105	0	entrées et plats composés	sandwichs	-	25521	Sandwich baguette, jambon, emmental, beurre	12.2	32.7	10.9	286
1	105	0	entrées et plats composés	sandwichs	-	25522	Sandwich (aliment moyen)	14.2	27.2	8.35	243
1	105	0	entrées et plats composés	sandwichs	-	25523	Toasts ou Canapés salés, garnitures diverses, préemballés	9.09	17.8	13.3	233
1	105	0	entrées et plats composés	sandwichs	-	25530	Sandwich baguette, crudités diverses, mayonnaise	6.54	30	7.9	221
1	105	0	entrées et plats composés	sandwichs	-	25531	Sandwich baguette, dinde, crudités (tomate, salade), mayonnaise	12.4	30.6	8.82	255
1	105	0	entrées et plats composés	sandwichs	-	25532	Sandwich baguette, oeuf, crudités (tomate, salade), mayonnaise	8.52	30.9	9.47	247
1	105	0	entrées et plats composés	sandwichs	-	25533	Sandwich baguette, porc, crudités (tomate, salade), mayonnaise	12	30.1	10.6	267
1	105	0	entrées et plats composés	sandwichs	-	25535	Sandwich baguette, merguez, ketchup moutarde	13.1	31	11.4	282
1	105	0	entrées et plats composés	sandwichs	-	25536	Sandwich baguette, salami, beurre	12.5	33.2	21.4	379
1	105	0	entrées et plats composés	sandwichs	-	25542	Croque-madame	13.7	16.9	15.5	264
1	105	0	entrées et plats composés	sandwichs	-	25543	Sandwich baguette (aliment moyen)	11.2	31.4	11.6	277
1	105	0	entrées et plats composés	sandwichs	-	25544	Sandwich pain de mie, garnitures diverses, préemballé	11.7	25.1	12.4	267
1	105	0	entrées et plats composés	sandwichs	-	25547	Croque-monsieur, préemballé	11.3	26.8	12.9	273
1	105	0	entrées et plats composés	sandwichs	-	25574	Sandwich pain de mie complet, jambon, crudités, fromage optionnel, préemballé	10	23.1	11.6	243
1	105	0	entrées et plats composés	sandwichs	-	25575	Sandwich pain de mie complet, thon, crudités, mayonnaise, préemballé	9.82	23.1	11.3	240
1	105	0	entrées et plats composés	sandwichs	-	25576	Sandwich pain de mie complet, jambon, fromage, préemballé	12.9	26.1	14.6	292
1	105	0	entrées et plats composés	sandwichs	-	25577	Sandwich pain de mie complet, poulet, crudités, mayonnaise, préemballé	9.18	23.7	10.4	232
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	7814	Cake salé (garniture : fromage, légumes, viande, poisson, volaille, etc.), préemballé	11.6	25.6	18.4	321
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25108	Samossa ou Samoussa, préemballé, cuit	9.33	16.5	13.7	230
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25151	Feuilleté au poisson et / ou fruits de mer	6.55	26.5	13	255
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25169	Spécialité chinoise type bouchée à la vapeur, préemballée, cuite	5.9	28	1.4	149
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25399	Feuilleté aux escargots, préemballé	6.69	23.1	22.1	321
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25401	Feuilleté ou Friand au fromage	8.25	28.1	17.1	302
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25402	Feuilleté ou Friand à la viande, préemballé	9.59	25.9	22.6	348
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25412	Bouchée à la reine, à la viande/volaille/quenelle	6.12	23.5	18.9	292
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25418	Croissant au jambon	7.9	19.2	14.6	243
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25419	Rouleau de printemps	4.57	16.6	1.82	103
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25420	Nem ou Pâté impérial	6.48	21.1	11.2	216
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25438	Brick garni (garniture : crevettes, légumes, volaille, viande, poisson, etc.), fait maison, cuit	12.2	8.48	11.5	187
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25503	Bouchée à la reine, au poisson et fruits de mer	6.72	13.4	13.8	206
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25508	Feuilleté ou Friand jambon fromage	8.46	25.7	16.7	290
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25551	Beignet de viande, volaille ou poisson, fait maison, cru	18.7	10	13.5	238
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25557	Brick à l oeuf, fait maison, cuit	10.4	12.3	18.1	255
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25558	Brick au boeuf	10.4	33.5	17	342
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25559	Brick à la pomme de terre, fait maison, cuit	3.25	19.6	13.4	215
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25578	Feuilleté salé (aliment moyen)	8.39	26.1	17.8	301
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25580	Bouchée à la reine, garnie (aliment moyen)	6.42	18.4	16.3	249
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25582	Nem ou Pâté impérial, au poulet, préemballé, cuit	8.06	20.9	8.1	197
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25583	Nem ou Pâté impérial, au porc, préemballé, cuit	6.88	22.6	12.7	237
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	25584	Nem ou Pâté impérial, aux crevettes et/ou au crabe, préemballé, cuit	7.44	23.7	9.2	213
1	106	0	entrées et plats composés	feuilletées et autres entrées	-	26266	Croissant au jambon fromage, préemballé	8.92	22	14.5	258
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	13004	Avocat, pulpe, cru	1.56	0.83	20.6	205
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20004	Bette ou blette, crue	1	1.63	0.5	16.4
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20009	Carotte, crue	0.63	7.59	0.5	40.2
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20010	Champignon, tout type, cru	2.37	1.88	0.23	21.7
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20012	Salade ou chicorée frisée, crue	1.48	2.4	0.25	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20014	Chou rouge, cru	1.13	4.33	0.5	30
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20016	Chou-fleur, cru	1.81	2.13	0.7	26.2
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20019	Concombre, pulpe et peau, cru	0.64	2.54	0.11	15.6
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20020	Courgette, pulpe et peau, crue	1.23	1.8	0.26	16.5
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20022	Cresson de fontaine, cru	2.09	0.9	0.15	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20023	Céleri branche, cru	0.63	2.41	0.5	17.6
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20026	Endive, crue	1.19	2.83	0.5	20.2
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20028	Fenouil, cru	1	2.63	0.5	21.8
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20031	Laitue, crue	1.3	1.33	0.2	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20034	Oignon, cru	1.1	6.25	0.62	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20038	Pissenlit, cru	2.91	6.1	0.85	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20041	Poivron, vert, jaune ou rouge, cru	0.8	4.55	0.27	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20044	Potiron, cru	1	3.5	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20045	Radis rouge, cru	0.94	1.53	0.5	14.5
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20047	Tomate, crue	0.86	2.49	0.26	19.3
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20052	Artichaut, cru	3.2	4.92	0.18	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20053	Aubergine, crue	1.12	2.39	0.14	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20054	Cardon, cru	0.7	1.7	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20055	Céleri-rave, cru	1.38	3.98	0.5	29.3
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20056	Champignon de Paris ou champignon de couche, cru	2.62	3.15	0.36	28
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20057	Brocoli, cru	3.95	1.7	0.48	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20058	Chou de Bruxelles, cru	3.98	5.67	0.4	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20059	Épinard, cru	2.62	2.25	0.5	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20061	Haricot vert, cru	1.85	4.14	0.21	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20064	Navet, pelé, cru	0.76	4.7	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20065	Chou-rave, cru	1.79	2.35	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20069	Chou vert, cru	2.53	1.92	0.41	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20070	Haricot vert, surgelé, cru	1.97	4.35	0.17	34
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20072	Petits pois, crus	5.84	7	0.55	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20073	Asperge, pelée, crue	2.04	2.4	0.21	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20082	Chou-fleur, surgelé, cru	2.09	2.64	0.37	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20083	Épinard, surgelé, cru	2.87	0.89	0.49	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20084	Petits pois, surgelés, crus	5.86	8.77	0.44	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20085	Poivron vert, cru	0.81	3.43	0.5	26
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20087	Poivron rouge, cru	1.06	5.98	0.5	36.6
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20089	Radis noir, cru	0.94	5.52	0.3	29.2
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20090	Scarole, crue	1.25	0.3	0.2	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20091	Betterave rouge, crue	1.74	9.1	0.24	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20097	Échalote, crue	1.81	12.2	0.5	63.6
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20099	Mâche, crue	2	0.5	0.5	16.8
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20101	Légumes, mélange surgelé, crus	2.26	5.71	2.65	65.1
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20103	Champignon, chanterelle ou girolle, crue	2.28	2.3	0.78	33.1
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20105	Champignon, morille, crue	3.16	0.1	0.54	24.5
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20106	Champignon, truffe noire, crue	5.77	\N	0.51	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20108	Maïs doux, en épis, surgelé, cru	3.36	17	1.19	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20111	Oseille, crue	1.84	1.6	0.65	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20114	Champignon, pleurote, crue	3.06	1.5	0.36	25.5
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20116	Chou blanc, cru	1.38	4.63	0.6	36.5
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20119	Tomate verte, crue	1.2	4	0.2	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20123	Batavia, crue	1.25	1.78	0.5	17.9
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20126	Haricot de Lima, cru	6.84	15.3	0.86	105
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20128	Courge musquée, pulpe, crue	0.55	4.6	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20132	Potimarron, pulpe, cru	0.63	3.1	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20134	Courge hokkaïdo, pulpe, crue	1.4	9.98	0.6	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20136	Courge melonnette, pulpe, crue	0.75	5.98	0.13	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20138	Courge doubeurre (butternut), pulpe, crue	1	5.4	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20139	Courge, crue	1.1	1.6	0.17	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20145	Courge spaghetti, pulpe, crue	0.64	5.41	0.57	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20151	Piment, cru	1.87	7.7	0.32	\N
3	302	30201	produits céréaliers	pains et assimilés	pains	7180	Pain pita	8.26	53	0.92	259
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20159	Champignon, oronge vraie, crue	2	2.45	0.3	23.2
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20160	Champignon, cèpe, cru	3.13	3.03	0.43	31.6
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20161	Champignon, rosé des prés, cru	2.3	2.45	0.4	25.3
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20162	Chicorée rouge, crue	1.4	1.6	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20163	Chicorée verte, crue	1.9	0.5	0.5	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20166	Citrouille, pulpe, crue	1	6	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20167	Chou chinois ou pak-choi ou pé-tsai, cru	1.38	1.65	0.2	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20168	Poivron jaune, cru	0.94	4.73	0.3	30.7
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20171	Laitue romaine, crue	1.24	1.2	0.3	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20172	Tomate cerise, crue	1.31	5.62	0.5	33.7
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20173	Pois mange-tout ou pois gourmand, cru	3.08	6.2	0.27	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20181	Panais, cru	1.54	10.1	0.4	58.3
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20183	Haricot mungo germé ou pousse de "soja", cru	2.81	3.4	0.5	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20192	Tomate côtelée ou coeur de boeuf, crue	0.5	3.23	0.5	19.8
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20195	Haricot beurre, cru	1.85	5.6	0.16	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20197	Salsifis noir, ou scorsonère d Espagne, cru	3.13	15.3	0.3	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20198	Bambou, pousse, crue	2.52	5.08	0.2	35.1
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20199	Cresson alénois, cru	2.55	2.2	0.6	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20200	Laitue iceberg, crue	1.01	2.45	0.18	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20201	Rutabaga, cru	1.17	5.7	0.13	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20203	Haricot beurre, surgelé, cru	2	4.9	0.17	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20204	Brocoli, surgelé, cru	2.79	1.56	0.44	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20206	Chou de Bruxelles, surgelé, cru	3.43	4.5	0.33	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20208	Carotte, surgelée, crue	0.63	4.99	0.27	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20210	Concombre, pulpe, cru	0.56	2.23	0.5	14.7
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20214	Petits pois et carottes, surgelés, crus	3.89	7.1	0.37	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20217	Roquette, crue	2.58	2.1	0.66	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20218	Chou frisé, cru	4.33	4.2	1.07	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20228	Champignon de Paris ou champignon de couche, surgelé, cru	1.8	0.83	0.25	15.9
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20230	Courgette, pulpe et peau, surgelée, crue	1.19	2.18	0.14	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20231	Crosne, surgelé, cru	1.4	8.7	0	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20232	Artichaut, fond, surgelé, cru	2.08	8.09	0.43	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20233	Maïs doux, surgelé, cru	3.28	19.8	0.78	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20234	Navet, surgelé, cru	0.82	2	0.18	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20235	Oignon, surgelé, cru	1	5.39	0.12	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20236	Poireau, surgelé, cru	1.42	3.35	0.29	26.7
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20237	Salsifis, surgelé, cru	2.65	4.15	0.15	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20238	Oignon rouge, cru	1.31	5.63	0.4	36.3
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20239	Oignon jaune, cru	1.19	6.39	0.5	37.8
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20263	Légumes pour potages, surgelés, crus	1.44	4.69	0.44	34.1
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20265	Julienne ou brunoise de légumes, surgelée, crue	1.19	4.08	0.25	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20266	Légumes pour ratatouille, surgelés	1.01	3.23	0.089	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20267	Printanière de légumes, surgelée, crue (haricots verts, carottes, pomme de terre, petits pois, oignons)	2.4	8.48	0.078	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20269	Haricot plat, cru	1.93	4.47	0.12	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20270	Épinard, jeunes pousses pour salades, cru	2.06	0.85	0.4	18.3
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20272	Mesclun ou salade, mélange de jeunes pousses	2	2.5	0	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20279	Asperge, verte, crue	2.46	2.03	0.27	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20280	Chou romanesco ou brocoli à pomme, cru	2.93	2.2	0.4	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20282	Asperge, blanche ou violette, pelée, crue	2.5	2.5	0.3	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20283	Salicorne (Salicornia sp.), fraîche	0.67	1.1	0.24	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20288	Salade sucrine, crue	1.13	2.58	0.3	17.9
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20295	Salade feuille de chêne, crue	1.13	1.03	0.5	14.3
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20496	Légumes pour couscous, surgelés, crus	2.05	6.75	0.7	46.5
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	20584	Tomate grappe, crue	0.5	3.03	0.5	20.1
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	25604	Salade verte, crue, sans assaisonnement	1.01	1.5	0.1	\N
2	201	20101	fruits, légumes, légumineuses et oléagineux	légumes	légumes crus	53100	Banane plantain, crue	1.28	29.6	0.39	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	13177	Chayote ou christophine ou chouchou, bouillie/cuite à l eau	0.62	2.29	0.48	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20000	Artichaut, cuit	2.53	0.99	0.28	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20001	Asperge, bouillie/cuite à l eau	2.68	0.81	0.32	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20002	Aubergine, cuite	1.33	4.17	0.28	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20003	Betterave rouge, cuite	1.44	7.13	0.4	42.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20005	Bette ou blette, cuite	0.7	1.23	0.5	14.7
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20006	Brocoli, cuit	2.1	1.1	0.78	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20007	Carotte, appertisée, égouttée	0.67	3.4	0.2	21.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20008	Carotte, cuite	0.55	2.6	0.1	18.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20011	Champignon, tout type, appertisé, égoutté	1.87	2.56	0.29	24.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20013	Chou de Bruxelles, cuit	2.6	4.2	0.11	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20015	Chou vert, cuit	1.03	3.04	0.45	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20017	Chou-fleur, cuit	1.6	1.6	0.46	20.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20018	Coeur de palmier, appertisé, égoutté	2.45	4.03	0.5	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20021	Courgette, pulpe et peau, cuite	0.93	1.4	0.36	15.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20024	Céleri branche, cuit	0.83	1.2	0.16	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20025	Céleri-rave, cuit	1.3	4.6	0.86	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20027	Épinard, cuit	3.2	0.5	0.14	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20029	Haricot mungo germé ou pousse de "soja", appertisé, égoutté	1.71	2.36	0.12	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20030	Haricot vert, cuit	2	3	0.17	29.4
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20033	Navet, cuit	0.9	3.8	0.2	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20035	Oignon, cuit	1.3	6.2	0.2	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20036	Petits pois, appertisés, égouttés	5.12	10.7	0.8	81.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20037	Petits pois, cuits	5.8	4.7	0.87	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20040	Poireau, cuit	1.1	3	0.2	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20043	Potiron, appertisé, égoutté	1.1	5.19	0.28	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20046	Salsifis, cuit	2.73	12.3	0.17	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20048	Tomate, pelée, appertisée, égouttée	1.07	1.89	0.28	18.3
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20049	Maïs doux, en épis, cuit	3.41	18.6	1.5	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20051	Macédoine de légumes, appertisée, égouttée	2.32	5.59	0.28	40.4
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20060	Épinard, appertisé, égoutté	2.81	0.93	0.5	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20062	Haricot vert, appertisé, égoutté	1.33	2.07	0.31	23.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20063	Haricot beurre, appertisé, égoutté	1.22	3.48	0.23	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20066	Maïs doux, appertisé, égoutté	2.82	18.4	1.68	106
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20067	Artichaut, appertisé, égoutté	1.5	6.5	0.2	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20068	Tomate, concentré, appertisé	4.4	17.1	0.53	99.2
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20071	Haricot vert, surgelé, cuit	1.95	5.1	0.19	36.3
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20074	Artichaut, cuit à la vapeur sous pression	2.63	3.24	0.3	47.3
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20076	Asperge, appertisée, égouttée	1.58	1.43	0.27	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20077	Chou de Bruxelles, appertisé, égoutté	2.5	4.1	0.53	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20078	Céleri branche, appertisé, égoutté	0.63	1.38	0.15	13.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20079	Champignon de Paris ou champignon de couche, appertisé, égoutté	2.23	0.7	0.37	19.4
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20081	Salsifis, appertisé, égoutté	1.25	4.25	0.15	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20086	Poivron vert, cuit	0.92	2.36	0.2	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20088	Poivron rouge, cuit	1.4	7	0.3	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20093	Petits pois et carottes, appertisés, égouttés	2.51	7.39	0.33	49
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20094	Chou-rave, bouilli/cuit à l eau	1.8	4.4	0.11	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20095	Chou rouge, bouilli/cuit à l eau	1.51	3.32	0.09	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20096	Potiron, cuit	0.81	4.5	0.07	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20102	Champignon de Paris ou champignon de couche, bouilli/cuit à l eau	2.17	3	0.47	28.7
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20118	Fenouil, bouilli/cuit à l eau	1.13	0.8	0.1	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20121	Épinard, surgelé, cuit	4.01	0.51	0.87	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20122	Chou-fleur, surgelé, cuit	1.61	1.05	0.22	18
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20124	Petits pois, surgelés, cuits	5.15	7.95	0.27	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20125	Champignon de Paris ou champignon de couche, sauté/poêlé, sans matière grasse	4.44	4.53	0.6	38.4
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20133	Panais, cuit	1.32	13.4	0.3	67.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20135	Fondue de poireau	1.1	0	5.2	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20141	Courge doubeurre (butternut), pulpe, cuite	1.23	\N	0.07	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20143	Courge spaghetti, pulpe, cuite	0.66	5.06	0.26	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20155	Artichaut, coeur, appertisé, égoutté	1.8	2.31	0.5	26
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20156	Artichaut, fond, appertisé, égoutté	1.2	3.02	0.5	25.2
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20158	Tétragone cornue, cuite	1.3	1	0.17	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20165	Rutabaga, cuit	0.93	4.26	0.18	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20169	Tomate, pulpe, appertisée	1.2	3.63	0.5	26.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20170	Tomate, purée, appertisée	1.4	7.54	0.4	47.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20188	Bambou, pousses, appertisées, égouttées	1.61	1.9	0.15	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20205	Brocoli, surgelé, cuit	3.1	2.36	0.11	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20207	Chou de Bruxelles, surgelé, cuit	3.64	4.22	0.39	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20209	Carotte, surgelée, cuite	0.58	4.52	0.68	32.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20212	Champignon, lentin comestible ou shiitaké, cuit	1.56	12.3	0.22	60.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20215	Petits pois et carottes, surgelés, cuits	3.09	7.02	0.42	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20216	Pois mange-tout ou pois gourmand, bouilli/cuit à l eau	2.25	3.39	0.3	30.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20219	Chou frisé, cuit	1.9	3.63	0.4	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20221	Chou chinois (pak-choi ou pé-tsai), cuit	1.53	0.75	0.17	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20241	Cardon, cuit	0.76	3.63	0.11	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20242	Tomate, pulpe et peau, bouillie/cuite à l eau	0.95	2.8	0.11	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20243	Pois mange-tout ou pois gourmands, cuits	3.5	5.92	0.38	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20255	Échalote, cuite	2.13	13.5	0.5	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20257	Haricots verts, purée	1.7	4.2	2.9	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20258	Légumes (3-4 sortes en mélange), purée	1.94	4.25	3.4	61.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20259	Brocoli, purée	2.5	2.75	0.38	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20260	Tomate, coulis, appertisé (purée de tomates mi-réduite à 11%)	2.05	8.53	0.2	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20261	Carotte, purée	0.88	5.06	0.3	31.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20264	Courgette, purée	2.8	6.5	1.9	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20268	Tomate, double concentré, appertisé	3.73	17	0.29	92.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20271	Macédoine de légumes, surgelée, pré-cuite (à recuire)	3.48	6.8	0.28	54.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20275	Poivron rouge, appertisé, égoutté	0.91	4.42	0.77	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20277	Asperge blanche, bouillie/cuite à l eau	1.44	1.63	0.3	18.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20278	Céleri-rave, purée	1.37	2.83	0.18	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20284	Petits pois, purée	4.8	8	2.8	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20285	Épinard, purée	3.7	5.2	2.2	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20289	Tomate, pulpe et peau, rôtie/cuite au four	0.88	4.13	0.6	31.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20290	Chou romanesco ou brocoli à pomme, cuit	3	2.03	0.8	35.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20291	Potimarron, pulpe, cuit à l étouffée	1.31	7.05	0.5	44.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20292	Courge musquée, pulpe, cuite	1.06	5.24	0.5	30.7
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20298	Carotte, purée cuisinée à la crème, préemballée	1.44	4.57	1.6	44.4
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20299	Asperge verte, bouillie/cuite à l eau	2.69	1.73	0.3	26.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20300	Aubergine, pulpe et peau, rôtie/cuite au four	1.31	3.83	0.3	33.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20301	Bette ou blette, côte et feuille, bouillie/cuite à l eau	0.88	1.43	0.3	16.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20302	Brocoli, bouilli/cuit à l eau, croquant	2.5	1.23	0.4	23.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20303	Brocoli, bouilli/cuit à l eau, fondant	2.19	1.03	0.5	23.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20304	Brocoli, cuit à la vapeur	4.13	2.53	0.7	37.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20305	Carotte, bouillie/cuite à l eau, croquante	0.75	6.33	0.3	35.7
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20306	Carotte, bouillie/cuite à l eau, fondante	0.5	5.73	0.3	31.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20307	Carotte, cuite à la vapeur	0.63	7.33	0.3	41.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20308	Chou blanc, bouilli/cuit à l eau	1	3.23	0.3	23.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20309	Chou de Bruxelles, bouilli/cuit à l eau	3.19	5.4	0.3	45.4
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20310	Chou rouge, cuit à l étouffée	1.19	5.7	0.3	34.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20311	Chou vert, bouilli/cuit à l eau	1.63	1.83	0.3	21.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20312	Chou-fleur, cuit à la vapeur	2.56	3.41	0.3	30.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20313	Courgette, pulpe et peau, rôtie/cuite au four	1.5	3.13	0.3	23
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20314	Céleri branche, cuit à l étouffée	0.75	2.48	0.3	16.7
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20315	Céleri rave, bouilli/cuit à l eau	0.94	4.32	0.3	26.2
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20316	Endive, rôtie/cuite au four	1.13	4.38	0.3	23.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20317	Fenouil, cuit à l étouffée	0.5	1.94	0.3	13.7
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20318	Haricot beurre, bouilli/cuit à l eau	2.19	4.45	0.3	34.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20320	Haricot vert, bouilli/cuit à l eau	1.75	3.39	0.3	28
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20321	Navet, bouilli/cuit à l eau	0.75	3.23	0.3	21.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20322	Oignon blanc ou jaune, sauté/poêlé sans matière grasse	1.56	6.73	0.3	40.2
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20323	Oignon nouveau ou oignon frais ou cébette, sauté/poêlé sans matière grasse	1.13	3.56	0.3	27.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20324	Oignon rouge, sauté/poêlé sans matière grasse	1.69	7.55	0.3	42.4
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20325	Panais, cuit à l étouffée	1.94	16.6	0.5	90.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20326	Petits pois, bouillis/cuits à l eau	6.38	9.93	0.6	80.3
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20327	Poireau, bouilli/cuit à l eau	2.56	2.23	0.3	27.4
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20328	Poivron jaune, sauté/poêlé sans matière grasse	1	5.33	0.6	35.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20329	Poivron rouge, sauté/poêlé sans matière grasse	0.94	6.53	0.3	35.7
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20330	Poivron vert, sauté/poêlé sans matière grasse	1.25	3.53	0.3	28.6
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20331	Potimarron, pulpe, bouilli/cuit à l eau	1.06	6.88	0.3	38.2
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20332	Potiron, rôti/cuit au four	0.5	5.66	0.3	30.2
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20333	Salsifis, bouilli/cuit à l eau	2.63	9.29	0.3	57.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20334	Tomate, rôtie/cuite au four	1	3.53	0.4	25.3
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20335	Échalote, sautée/poêlée sans matière grasse	2	12.3	0.4	66.9
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20336	Épinard, bouilli/cuit à l eau	3.38	0.85	0.7	28.1
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20497	Légumes pour couscous, cuits	1.53	2.55	0.43	\N
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20499	Légume cuit (aliment moyen)	2.11	5.81	0.3	43.5
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	20590	Crosne, cuit	2.13	9.11	0.5	50.8
2	201	20102	fruits, légumes, légumineuses et oléagineux	légumes	légumes cuits	58103	Gombo, fruit, cuit	1.87	2.01	0.21	\N
2	201	20103	fruits, légumes, légumineuses et oléagineux	légumes	légumes séchés ou déshydratés	20092	Carotte, déshydratée	8.1	56	1.49	\N
2	201	20103	fruits, légumes, légumineuses et oléagineux	légumes	légumes séchés ou déshydratés	20180	Oignon, séché	8.95	75	0.46	\N
2	201	20103	fruits, légumes, légumineuses et oléagineux	légumes	légumes séchés ou déshydratés	20189	Tomate, séchée	14.2	43.3	2.99	\N
2	201	20103	fruits, légumes, légumineuses et oléagineux	légumes	légumes séchés ou déshydratés	20202	Champignon noir, séché	7.27	\N	0.075	\N
2	201	20103	fruits, légumes, légumineuses et oléagineux	légumes	légumes séchés ou déshydratés	20211	Champignon, lentin comestible ou shiitaké, séché	9.58	63.9	0.99	316
2	201	20103	fruits, légumes, légumineuses et oléagineux	légumes	légumes séchés ou déshydratés	20256	Tomate, séchée, à l huile	4.27	13.4	11.7	187
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20800	Banane jaune, pulpe, cuite à la vapeur, prélevée à la Martinique	1.06	\N	0.057	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20801	Chips de giraumon (variété locale), pulpe, prélevé à la Martinique	\N	12.3	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20802	Chips de giraumon (variété phoenix), pulpe, prélevé à la Martinique	\N	13.9	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20803	Chou dur ou chou caraïbe, pulpe, cuit à la vapeur, prélevé à la Martinique	3.25	\N	0.0033	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20804	Christophine à peau blanche, pulpe, cuite à la vapeur, prélevée à la Martinique	1.21	5.93	0.033	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20805	Christophine à peau verte, pulpe, cuite à la vapeur, prélevée à la Martinique	1.23	4.6	0.023	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20806	Christophine blanche, pulpe, appertisée, non égouttée, prélevée à la Martinique	\N	\N	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20807	Christophine, pulpe, cuite à la vapeur, surgelée, prélevée à la Martinique	\N	\N	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20808	Concombre, pulpe avec graines, cru, prélevé à la Martinique	0.73	\N	0.58	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20809	Concombre, pulpe, cru, prélevé à la Martinique	0.42	\N	0.27	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20810	Cresson, feuille, cru, prélevé à la Martinique	2.25	\N	0.1	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20811	Dachine, pulpe, cuit à la vapeur, prélevé à la Martinique	1.15	\N	0.3	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20812	Farine de pulpe de patate douce, prélevée à la Martinique	\N	50.1	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20813	Fruit à pain, pulpe, cuit à la vapeur, prélevé à la Martinique	1.29	\N	0.11	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20814	Giraumon (variété locale), pulpe, cuit à la vapeur, prélevé à la Martinique	1.1	4.51	0.097	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20815	Giraumon (variété locale), pulpe, cuit à la vapeur, surgelé, prélevé à la Martinique	\N	3.75	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20816	Giraumon (variété locale), pulpe, râpé, cru, prélevé à la Martinique	\N	2.42	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20817	Giraumon (variété phoenix), pulpe, cuit à la vapeur, prélevé à la Martinique	1.03	5.62	0.05	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20818	Giraumon (variété phoenix), pulpe, râpé, cru, prélevé à la Martinique	\N	3.51	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20819	Giraumon (variété phoenix), pulpe, surgelé, cuit à la vapeur, prélevé à la Martinique	\N	4.37	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20820	Gombo, entier, appertisé, non égoutté, prélevé à la Martinique	\N	\N	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20821	Gombo, entier, cuit à la vapeur, prélevé à la Martinique	1.8	4.69	0.3	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20822	Gombo, pulpe, blanchi, surgelé, prélevé à la Martinique	0.24	5.28	0.1	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20823	Igname cousse-couche, pulpe, cuit à la vapeur, prélevé à la Martinique	1.65	17.9	0.3	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20824	Igname jaune, pulpe, cuit à la vapeur, prélevé à la Martinique	2.04	27.6	0.37	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20825	Igname saint martin, pulpe, cuit à la vapeur, prélevé à la Martinique	2.25	18.4	0.3	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20826	Topinambour, pulpe, cuit à la vapeur, prélevé à la Martinique	1.23	\N	0.18	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20827	Kamanioc, pulpe, cuit à la vapeur, prélevé à la Martinique	0.6	\N	0	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20828	Massissi, pulpe, cru, prélevé à la Martinique	2.58	\N	0.8	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20829	Papaye, pulpe, crue, prélevée à la Martinique	0.67	\N	0.0033	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20830	Papaye, pulpe, cuite à la vapeur, prélevée à la Martinique	0.63	\N	0	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20831	Patate douce, pulpe, blanchie, surgelée, prélevée à la Martinique	\N	19.3	\N	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20832	Patate douce, pulpe, cuite à la vapeur, prélevée à la Martinique	1.48	25.2	0.067	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20833	Pois d angole, entier, cuit à la vapeur, prélevé à la Martinique	16.3	\N	0.74	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20834	Ti nain, pulpe, cuit à la vapeur, prélevé à la Martinique	1.13	\N	0.05	\N
2	201	20104	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Martinique	20835	Tomate, entière, crue, prélevée à la Martinique	1.06	\N	0.06	\N
2	201	20105	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Réunion	20296	Brèdes chou de Chine ou bok choy ou pak choï, tiges et feuilles, cuites à la vapeur, prélevées à La Réunion (Brassica rapa subsp. Chinensis)	1.69	1.7	0.3	17.7
2	201	20105	fruits, légumes, légumineuses et oléagineux	légumes	légumes et leurs produits de la Réunion	20297	Chayote ou christophine ou chouchou, pulpe avec pépins, cuite à la vapeur, prélevée à La Réunion (Sechium edule)	0.63	3.5	0.3	22.2
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4000	Tapioca ou Perles du Japon, cru	0.19	87.8	0.02	354
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4002	Pomme de terre, sans peau, rôtie/cuite au four	1.96	20.1	0.1	91.9
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4003	Pomme de terre, bouillie/cuite à l eau	1.8	16.7	0.34	80.5
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4004	Chips de pommes de terre nature ou aromatisées, standard	5.67	51.1	34.3	545
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4007	Pomme de terre nouvelle, bouillie/cuite à l eau	1.44	\N	0.3	\N
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4008	Pomme de terre, sans peau, crue	2.16	16.2	0.18	80.5
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4011	Pomme de terre, appertisée, égouttée	1.47	11.7	0.34	59.9
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4013	Pomme de terre noisette, surgelée, crue	2.76	24.9	7.22	181
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4014	Pomme de terre vapeur, sous vide	1.7	15.4	0.2	73.6
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4015	Pomme de terre poêlée, avec matière grasse	2.5	17.3	5.7	137
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4016	Pomme de terre, flocons déshydratés, au lait ou à la crème	10.5	69.4	3.97	371
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4017	Pomme de terre, purée à base de flocons, reconstituée avec lait entier, matière grasse	1.92	10.2	5.18	97.9
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4018	Pomme de terre, purée, avec lait et beurre, non salée	1.87	14.2	2.4	88.8
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4019	Pomme de terre, purée à base de flocons, reconstituée avec lait demi-écrémé et eau, non salée	2.63	12.1	0.53	67.3
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4020	Pomme de terre dauphine, surgelée, crue	4.62	25.6	17.7	285
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4021	Pomme de terre dauphine, surgelée, cuite	4.5	30.2	17.7	302
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4022	Pomme de terre, flocons déshydratés, nature	8.04	76.1	0.46	361
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4023	Pomme de terre nouvelle, crue	1.88	15.9	0.3	76.4
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4025	Potatoes ou Wedges ou Quartiers de pommes de terre épicés, surgelées, cuites	3.25	25.3	5.8	174
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4026	Pomme de terre, rôtie/cuite au four	2.5	18.5	0.13	89.4
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4027	Pomme de terre sautée/rissolée, pré-frite, surgelée, cuite	2.81	23	4.8	156
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4028	Pomme de terre de conservation, sans peau, bouillie/cuite à l eau	1.81	15.7	0.5	76.1
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4029	Pomme de terre primeur, sans peau, bouillie/cuite à l eau	1.84	14.9	0.1	71.6
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4030	Frites de pommes de terre, surgelées, rôties/cuites au four	3.75	32.6	6.6	213
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4032	Frites de pommes de terre, surgelées, cuites en friteuse	3.28	39.4	11.9	285
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4034	Pomme de terre duchesse, surgelée, cuite	3.44	29.5	8.5	218
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4035	Pomme de terre noisette, surgelée, cuite	2.81	28.5	6.6	191
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4036	Pomme de terre sautée/poêlée à la graisse de canard	2.54	21.9	12.1	213
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4037	Chips de pommes de terre nature ou aromatisées, à l ancienne	5.62	49.8	37.6	570
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4038	Chips de pommes de terre et assimilés nature ou aromatisées, allégées en matière grasse	6.58	62.1	19.8	463
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4039	Rostis ou Galette de pomme de terre	2.38	22.5	8.3	182
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4042	Pomme de terre duchesse, surgelée, crue	2.8	23.2	7.72	178
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4043	Pomme de terre sautée/ rissolée, pré-frites, surgelée, crue	2.32	20.9	4.2	135
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4044	Frites de pommes de terre, surgelées, préfrites, pour cuisson rôtie/ au four	2.41	23.4	5.09	154
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4045	Frites de pommes de terre, surgelées, préfrites, pour cuisson micro-ondes	3.5	34	10.8	254
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4046	Frites de pommes de terre, surgelées, préfrites, pour cuisson en friteuse	3.12	29.1	12.1	244
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4047	Pomme de terre, purée (aliment moyen)	2.11	12.7	3.25	91.8
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4048	Pomme de terre, cuite (aliment moyen)	2.01	17.2	1.37	93.2
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4101	Patate douce, crue	1.51	18.3	0.15	86.3
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4102	Patate douce, cuite	1.69	12.2	0.15	62.8
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	4103	Patate douce, purée, cuisinée à la crème	1.1	12.1	2	79.8
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	20050	Topinambour, cuit	1.8	16	0.7	81.9
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	20196	Topinambour, cru	1.94	11.5	0.31	60.7
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	53101	Banane plantain, cuite	0.79	28.9	0.18	125
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	53200	Taro, tubercule, cru	1.5	22.8	0.2	107
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	53201	Taro, tubercule, cuit	0.52	29.5	0.11	131
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	53502	Igname, épluchée, crue	1.53	23.8	0.17	111
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	53503	Igname, épluchée, bouillie/cuite à l eau	1.49	23.6	0.14	109
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	54031	Manioc, racine crue	1.31	36.3	0.29	157
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	54034	Manioc, racine cuite	0.69	32	0.043	132
2	202	0	fruits, légumes, légumineuses et oléagineux	pommes de terre et autres tubercules	-	54500	Fruit à pain, cru	1.07	22.2	0.23	105
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20293	Haricot coco, bouilli/cuit à l eau	9.63	13.7	0.5	131
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20500	Fève, bouillie/cuite à l eau	8.06	9.35	0.8	82.9
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20502	Haricot blanc, bouilli/cuit à l eau	6.75	12	1.1	112
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20503	Haricot rouge, bouilli/cuit à l eau	9.63	12.3	0.6	116
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20505	Lentille, bouillie/cuite à l eau	9.02	12.2	0.38	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20506	Pois cassé, bouilli/cuit à l eau	8.6	16.3	1.49	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20507	Pois chiche, bouilli/cuit à l eau	8.31	17.7	3	147
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20508	Haricot flageolet, appertisé, égouttés	6.1	12.2	0.79	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20510	Lentille, cuisinée, appertisée, égouttée	6.28	11.8	0.64	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20511	Haricot blanc, appertisé, égoutté	6.57	10.9	0.4	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20513	Haricot flageolet, bouilli/cuit à l eau	6.75	12	1.1	112
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20524	Haricot rouge, appertisé, égoutté	8.31	13	0.97	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20531	Haricot mungo, bouilli/cuit à l eau	7.54	11.9	0.55	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20532	Pois chiche, appertisé, égoutté	6.74	15	2.68	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20540	Haricot flageolet, vert, bouilli/cuit à l eau	5.63	15.8	1.1	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20542	Fève, pelée, surgelée, cuite à l eau	6.4	9	0.5	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20543	Fève, surgelée, bouillie/cuite à l eau	5.6	7.4	0.5	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20587	Lentille verte, bouillie/cuite à l eau	10.1	16.2	0.58	127
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20588	Lentille blonde, bouillie/cuite à l eau	9.7	16.3	0.7	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20589	Lentille corail, bouillie/cuite à l eau	10.6	15	0.5	\N
2	203	20301	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses cuites	20700	Légume sec, cuit (aliment moyen)	8.38	12.1	0.62	\N
2	203	20302	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses fraîches	20517	Fève à écosser, fraîche	6.76	4.2	0.67	\N
2	203	20302	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses fraîches	20521	Lentille, germée	8.86	19	0.58	\N
2	203	20302	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses fraîches	20534	Lupin, graine crue	36.2	21.5	9.74	\N
2	203	20302	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses fraîches	20536	Fève, fraîche, surgelée	7.5	7.95	0.22	\N
2	203	20302	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses fraîches	20537	Haricot flageolet, surgelé	9.32	25.6	0.7	\N
2	203	20302	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses fraîches	20541	Fève, pelée, surgelée, crue	14.9	14.9	0.3	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20501	Haricot blanc, sec	19.1	43.9	1.78	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20504	Lentille, sèche	25.4	50.6	1.34	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20515	Pois cassé, sec	22.8	52	1.44	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20516	Pois chiche, sec	20.5	47.5	5.85	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20518	Fève, sèche	26.1	33.3	1.53	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20525	Haricot rouge, sec	22.5	46.1	1.06	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20530	Haricot mungo, sec	24.5	47.6	1.42	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20535	Lentille corail, sèche	27.7	44.9	0.8	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20539	Haricot flageolet, vert, sec	19.1	42.1	2.6	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20585	Lentille verte, sèche	25.1	44.5	1.8	\N
2	203	20303	fruits, légumes, légumineuses et oléagineux	légumineuses	légumineuses sèches	20586	Lentille blonde, sèche	26.1	48.3	1.9	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13000	Abricot, dénoyauté, cru	0.81	9.01	0.5	45.9
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13002	Ananas, pulpe, cru	0.5	11.7	0.5	54.4
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13005	Banane, pulpe, crue	1.06	19.7	0.5	90.5
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13007	Cassis, cru	1.33	9.68	0.86	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13008	Cerise, dénoyautée, crue	0.81	13	0.3	55.7
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13009	Citron, pulpe, cru	0.5	1.56	0.5	27.6
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13010	Coing, cru	0.51	13.4	0.1	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13012	Figue, crue	1.19	13.5	0.5	69.4
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13014	Fraise, crue	0.63	6.03	0.5	38.6
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13015	Framboise, crue	1.19	5.83	0.8	49.2
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13016	Fruit de la passion ou maracudja, pulpe et pépins, cru	2.13	10.9	3	101
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13018	Grenade, pulpe et pépins, crue	1.44	14.3	1.2	80.6
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13019	Groseille, crue	1.56	7.06	0.7	68.5
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13020	Groseille à maquereau, crue	0.75	4.88	0.59	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13021	Kiwi, pulpe et graines, cru	0.88	11	0.6	60.5
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13023	Litchi, pulpe, cru	1.13	16.1	0.5	81
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13024	Clémentine ou Mandarine, pulpe, crue	0.81	9.17	0.5	47.3
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13025	Mangue, pulpe, crue	0.63	14.3	0.5	73.9
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13026	Melon cantaloup (par ex.: Charentais, de Cavaillon) pulpe, cru	1.13	14.8	0.5	62.7
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13027	Mirabelle, crue	0.63	18	0.5	76.9
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13028	Myrtille, crue	0.87	10.6	0.33	57.7
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13029	Mûre (de ronce), crue	1.13	6.53	0.7	47.3
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13030	Nectarine ou brugnon, pulpe et peau, crue	1.16	8.9	0.31	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13034	Orange, pulpe, crue	0.75	8.03	0.5	45.5
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13035	Papaye, pulpe, crue	0.75	8.53	0.3	42.2
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13036	Pastèque, pulpe, crue	0.69	8.33	0.5	38.9
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13037	Poire, pulpe et peau, crue	0.49	10.9	0.27	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13039	Pomme, pulpe et peau, crue	0.25	11.6	0.25	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13040	Pomelo (dit Pamplemousse), pulpe, cru	0.5	8.02	0.5	39.8
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13041	Prune Reine-Claude, crue	0.94	16.4	0.5	71.3
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13043	Pêche, pulpe et peau, crue	1.08	9	0.33	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13044	Raisin blanc, à gros grain (type Italia ou Dattier), cru	0.75	16.6	0.5	73.4
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13045	Raisin noir, cru	0.63	15.6	0.4	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13047	Rhubarbe, tige, crue	0.78	1.47	0.23	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13050	Pomme, pulpe, crue	0.27	10.7	0.13	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13054	Carambole, pulpe, crue	1.15	3.9	0.32	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13056	Anone ou chérimole, pulpe, crue	1.72	15.4	0.64	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13061	Feijoa, pulpe, crue	0.71	8.2	0.42	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13063	Figue de Barbarie, pulpe et graines, crue	0.37	6	0.31	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13066	Kaki, pulpe, cru	0.88	14.3	0.3	68.6
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13067	Citron vert ou Lime, pulpe, cru	1.13	3.14	0.3	40.2
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13071	Mûre noire (du mûrier), crue	1.44	8.1	0.39	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13077	Ramboutan, pulpe, crue	0.65	20	0.21	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13080	Tamarin, fruit mûr, pulpe, cru	2.65	57.4	0.6	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13083	Goyave, pulpe, crue	1.59	9.02	0.73	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13085	Pomme Canada, pulpe, crue	0.4	11.6	0.1	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13086	Pomme Golden, pulpe, crue	0.5	11.7	0.5	54.9
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13100	Prune, crue	0.66	9.92	0.29	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13101	Raisin Chasselas, cru	0.75	16.9	0.5	79.1
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13107	Poire, pulpe, crue	0.3	10.4	0.1	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13110	Griotte, crue	1.1	10.5	0.3	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13112	Raisin, cru	0.72	15.7	0.16	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13113	Canneberge ou cranberry, crue	0.75	7.6	0.13	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13121	Pomme Granny Smith, pulpe, crue	0.5	11.4	0.5	53.9
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13122	Pomme Granny Smith, pulpe et peau, crue	0.5	10.7	0.5	51.5
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13125	Citron, zeste, cru	1.38	5.4	0.3	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13126	Sureau, baie, crue	0.64	11.4	0.5	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13132	Myrtille, surgelée, crue	0.68	8.9	0.43	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13134	Salade de fruits, crue	0.5	11.4	0.15	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13136	Framboise, surgelée, crue	1.16	6.43	0.8	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13148	Nectarine ou brugnon, jaune, pulpe et peau, crue	0.69	11.3	0.5	51.3
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13149	Nectarine ou brugnon, blanche, pulpe et peau, crue	0.81	11.4	0.5	51.8
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13150	Mûre (de ronce), surgelée, crue	1.22	10.7	0.42	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13179	Pomelo (dit Pamplemousse) jaune, pulpe, cru	0.69	7.31	0.1	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13180	Pomelo (dit Pamplemousse) rose, pulpe, cru	0.77	6.2	0.14	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13188	Poire Conférence, pulpe, crue	0.5	11.4	0.5	53.1
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13189	Poire Williams, pulpe, crue	0.5	11.5	0.5	54.1
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13190	Pomme Chantecler, pulpe, crue	0.5	11.2	0.5	51.8
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13191	Pomme Gala, pulpe, crue	0.5	11.9	0.5	54.5
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13192	Pomme Pink lady, pulpe, crue	0.5	12.8	0.5	60.1
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13193	Pêche blanche, pulpe et peau, crue	0.69	9.48	0.5	47.2
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13194	Pêche blanche, pulpe, crue	0.63	9.63	0.5	46.1
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13195	Pêche jaune, pulpe, crue	0.69	9.8	0.5	46.3
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13529	Dourian, pulpe, cru	1.47	23.3	5.33	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13549	Kumquat, sans pépin, cru	1.57	9.6	1.18	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13552	Longan, pulpe, cru	1.31	14	0.1	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13614	Pamplemousse chinois, pulpe, cru	0.76	8.62	0.04	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13620	Pomme Golden, pulpe et peau, crue	0.5	12.8	0.5	57.1
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13621	Raisin noir Muscat, cru	0.69	20	0.5	90.1
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13742	Melon miel ou melon honeydew, pulpe, cru	0.58	4.3	0.17	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13997	Fruits rouges, crus (framboises, fraises, groseilles, cassis)	1.11	7.88	0.31	\N
2	204	20401	fruits, légumes, légumineuses et oléagineux	fruits	fruits crus	13999	Fruit cru (aliment moyen)	0.7	11.6	0.26	59.5
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13038	Compote de pomme	0.23	24.4	0.21	102
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13048	Rhubarbe, tige, cuite, sucrée	0.39	29.2	0.05	\N
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13108	Compote, tout type de fruits	0.5	23.9	0.092	102
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13109	Compote, tout type de fruits, allégée en sucres	0.5	15.3	0.08	66
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13128	Chayote ou christophine ou chouchou, crue	0.72	2.8	0.12	\N
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13129	Compote, tout type de fruits, allégée en sucres, rayon frais	0.32	14.9	0.48	\N
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13151	Compote de pomme, allégée en sucres	0.5	15.1	0.08	65.1
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13152	Dessert de fruits, tout type de fruits (en taux de sucres : compotes allégées en sucres < desserts de fruits < compotes allégée)	0.32	19.5	0.2	\N
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13153	Purée de fruits, tout type de fruits, type "compote sans sucres ajoutés"	0.5	13.4	0.3	58.9
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13154	Spécialité de fruits divers, sucrée (mélange pulpes et/ou purées de fruits, mais toujours avec autre ingrédient)	0.41	16.9	0.56	\N
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13175	Pomme, pulpe, rôtie/cuite au four	0.5	21	0.5	\N
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13176	Pomme, pulpe, bouillie/cuite à l eau	0.26	11.2	0.36	\N
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13185	Compote ou assimilé, tout type de fruits, teneur en sucre (allégée en sucres ou non, sans sucres ajoutés...) inconnue (aliment moyen)	0.25	18.6	0.15	80.1
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13187	Purée de pommes, type "compote sans sucres ajoutés"	1.13	11.7	0.3	56.4
2	204	20402	fruits, légumes, légumineuses et oléagineux	fruits	compotes et assimilés	13998	Coulis de fruits rouges (framboises, fraises, groseilles, cassis)	0.8	25.1	0.54	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13704	Abricot au sirop (sans précision sur léger ou classique), appertisé, égoutté (aliment moyen)	0.5	16.2	0.25	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13705	Macédoine ou cocktail ou salade de fruits, au sirop (sans précision sur léger ou classique), appertisé, égouttée (aliment moyen)	0.25	16.2	0.25	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13706	Macédoine ou cocktail ou salade de fruits, au sirop, appertisé, égoutté	0.5	17.4	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13707	Macédoine ou cocktail ou salade de fruits, au sirop, appertisé, non égoutté	0.5	18.3	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13708	Macédoine ou cocktail ou salade de fruits, au sirop léger, appertisé, égoutté	0.5	14.4	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13709	Macédoine ou cocktail ou salade de fruits, au sirop léger, appertisé, non égoutté	0.5	14.5	0.061	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13712	Abricot au sirop léger, appertisé, égoutté	0.94	13.7	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13713	Abricot au sirop léger, appertisé, non égoutté	0.81	14	0.043	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13714	Abricot au sirop, appertisé, égoutté	0.5	16.2	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13715	Abricot au sirop, appertisé, non égoutté	0.29	16.6	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13716	Ananas au jus d ananas, égoutté, appertisé	0.5	13.6	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13717	Ananas au jus d ananas, appertisé, non égoutté	0.5	13.6	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13718	Ananas au sirop léger, appertisé, égoutté	0.5	15.9	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13719	Ananas au sirop léger, appertisé, non égoutté	0.5	16	0.078	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13730	Pêche au sirop léger, appertisée, égouttée	0.5	13.8	0.5	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13731	Pêche au sirop léger, appertisée, non égouttée	0.31	14.1	0.038	\N
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13734	Poire au sirop léger, appertisée, égouttée	0.5	13.9	0.4	64.9
2	204	20403	fruits, légumes, légumineuses et oléagineux	fruits	fruits appertisés	13735	Poire au sirop léger, appertisée, non égouttée	0.3	14.5	0.12	\N
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13001	Abricot, dénoyauté, sec	2.88	59.1	0.5	239
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13011	Datte, pulpe et peau, sèche	1.81	64.7	0.25	\N
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13013	Figue, sèche	2.99	54.3	0.87	\N
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13042	Pruneau, sec	1.63	55.4	0.4	229
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13046	Raisin, sec	3	73.2	0.9	321
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13051	Mélange apéritif de fruits exotiques, sec	2.19	69.5	10.5	389
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13089	Banane, pulpe, sèche	3.89	78.4	1.81	\N
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13111	Pomme, sèche	0.78	57.2	0.31	\N
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13118	Pêche, sèche	5	68.9	1	\N
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13178	Canneberge ou cranberry, séchée, sucrée	0.5	76.4	1	333
2	204	20404	fruits, légumes, légumineuses et oléagineux	fruits	fruits séchés	13623	Abricot, dénoyauté, sec, moelleux (réhydraté à 35-45%)	2.31	51.1	0.4	200
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13400	Abricot pays, pulpe, au sirop, appertisé, non égoutté, prélevé à la Martinique	0.28	13.3	0.1	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13401	Abricot pays, pulpe, cru, prélevé à la Martinique	0.48	10.8	0.05	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13402	Ananas, pulpe, cru , prélevé à la Martinique	0.56	\N	0	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13403	Caïmite, pulpe, cru, prélevé à la Martinique	0.31	\N	2.87	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13404	Cerise acérola, pulpe, crue, prélevée à la Martinique	0.56	\N	0.097	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13405	Chadèque, pulpe, cru, prélevé à la Martinique	0.48	\N	0.3	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13406	Chips d abricot pays, pulpe, prélevé à la Martinique	0.96	68.7	18.7	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13407	Goyave, pulpe, purée, prélevée à la Martinique	0.83	\N	0.0067	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13408	Jus de carambole, prélevé à la Martinique, jus filtré	4.52	\N	0.15	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13409	Jus de carambole, prélevée à la Martinique, jus non filtré	0.063	\N	0.03	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13410	Jus de citron punch (variété petit calibre), pur jus, prélevé à la Martinique	0.48	\N	0.14	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13411	Jus de citron vert (variété gros calibre), pur jus, prélevé à la Martinique	0.69	\N	0.46	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13412	Jus de corossol, prélevé à la Martinique	0.65	\N	0.43	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13413	Jus de fruit de la passion ou maracudja, prélevé à la Martinique, pur jus	1.08	\N	0.37	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13414	Jus de grenade, prélevée à la Martinique	0.69	\N	0	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13415	Jus de lime, pur jus, prélevé à la Martinique	0.35	\N	0.57	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13416	Jus de mandarine commune, pur jus filtré pasteurisé, prélevée à la Martinique	\N	\N	\N	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13417	Jus de mandarine commune, pur jus filtré, prélevée à la Martinique	0.61	8.63	0.57	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13418	Jus de mandarine macaque, pur jus filtré, prélevée à la Martinique	0.6	10.8	0	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13419	Jus de moubin, pur jus, prélevé à la Martinique	0.88	\N	0.19	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13420	Jus de pamplemousse (variété locale), pur jus, prélevé à la Martinique	0.42	\N	0.19	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13421	Jus de prune de cythère verte "géante" (variété locale), fruit mûr, pur jus filtré, prélevée à la Martinique	0.29	7.13	0.19	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13422	Jus de prune de cythère verte "géante" (variété locale), fruit vert, pur jus filtré, prélevée à la Martinique	0.44	6.55	0.28	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13423	Jus de prune de cythère verte "naine" (variété hybride), fruit mûr, pur jus filtré, prélevée à la Martinique	0.69	9.97	0.21	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13424	Jus de prune de cythère verte "naine" (variété hybride), fruit vert, pur jus filtré, prélevée à la Martinique	0.67	6.34	0.26	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13425	Mandarine commune, pulpe, au sirop, appertisée, non égouttée, prélevée à la Martinique	\N	\N	\N	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13426	Mango bassignac, pulpe, cru, prélevé à la Martinique	0.32	18.5	\N	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13427	Mango moussache, pulpe, cru, prélevé à la Martinique	1.28	20.9	\N	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13428	Mangue julie, pulpe, crue, prélevée à la Martinique	0.71	18.3	\N	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13429	Mangue verte, pulpe, crue, prélevée à la Martinique	1.31	12.2	\N	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13430	Melon, pulpe, cru, prélevé à la Martinique	1.08	\N	0.047	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13431	Orange (variété locale), pulpe, prélevée à la Martinique	0.6	\N	0.67	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13432	Orange amère, pulpe, crue, prélevée à la Martinique	0.73	\N	0.43	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13433	Pastèque, pulpe, crue, prélevée à la Martinique	0.77	\N	0.26	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13434	Pomme cajou, pulpe, crue, prélevée à la Martinique	0.79	\N	0.11	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13435	Pomme cannelle,  pulpe, crue, prélevée à la Martinique	1.48	\N	0.57	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13436	Pomme d eau ou pomme malaca, pulpe, crue, prélevée à la Martinique	0.44	\N	0.023	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13437	Pomme liane, pulpe, crue, prélevée à la Martinique	0.88	\N	0.22	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13438	Prune de cythère, mûre, fruit entier, crue, prélevée à la Martinique	0.54	\N	0.03	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13439	Prune de cythère, verte ou immature, fruit entier, crue, prélevée à la Martinique	0.6	\N	0.07	\N
2	204	20405	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Martinique	13440	Jacques, pulpe, cru, prélevé à la Martinique	1.98	\N	0.21	\N
2	204	20406	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Réunion	13200	Mangue José, pulpe, crue, prélevée à La Réunion (Mangifera indica L.)	0.75	19.3	0.5	88.8
2	204	20406	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Réunion	13201	Ananas Victoria ou ananas Queen Victoria, pulpe crue, prélevé à La Réunion Ananas comosus (L.) merr var. Queen)	0.94	15.1	0.3	71.8
2	204	20406	fruits, légumes, légumineuses et oléagineux	fruits	fruits et leurs produits de la Réunion	13202	Papaye Colombo (fruit mûr), pulpe sans pépin, crue, prélevée à La Réunion (Carica papaya L.)	0.56	7.88	0.3	40
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	9570	Farine de châtaigne	6.1	70.4	3.43	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15000	Amande (avec peau)	22.6	9.51	51.3	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15001	Cacahuète ou Arachide	26.1	14.8	49.1	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15002	Cacahuète, grillée, salée	26.2	15	50	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15004	Noisette	17	7.16	56.9	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15005	Noix, séchée, cerneaux	15.7	6.88	67.3	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15006	Noix de coco, amande mûre, fraîche	3.93	6.22	33.5	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15007	Noix de coco, amande, sèche	7.8	8.55	66.3	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15008	Noix du Brésil	16.9	6.17	66.1	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15009	Pistache, grillée, salée	22.3	15.9	49.5	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15010	Sésame, graine	20.8	9.85	49.7	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15011	Tournesol, graine	25.1	10.1	55.5	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15013	Crème de marrons	1.51	55	0.67	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15014	Noix de coco, amande immature, fraîche	3.93	6.22	33.5	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15016	Crème de marrons vanillée, appertisée	1.13	59.8	0.7	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15018	Mélange apéritif de graines salées et raisins secs	19.6	27.1	39.6	560
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15019	Noix de cajou, grillée, salée	18	26.7	49.5	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15020	Châtaigne, bouillie/cuite à l eau	2.36	23	1.38	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15021	Châtaigne, grillée	3.74	47.9	2.2	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15023	Noix, fraîche	12.9	9.94	31.8	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15024	Châtaigne, crue	2.13	36.5	2.23	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15025	Pignon de pin	16.2	6.31	65	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15026	Noix de pécan	11.3	5.43	72.6	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15027	Noix de macadamia	9.33	5.22	75.8	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15028	Cucurbitacées, graine	35.6	4.71	49.1	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15029	Luzerne, graine germée	3.87	0.91	0.7	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15032	Luzerne, graine	35	39.3	12.6	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15033	Noisette grillée	17	5.21	66	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15034	Lin, graine	23.9	6.6	36.6	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15035	Sésame, graine décortiquée	24.9	4.5	56.1	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15037	Cacahuète, grillée à sec, salée	24.8	18.2	47.7	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15038	Sésame, grillé, graine décortiquée	20	9.14	48	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15039	Châtaigne ou Marron, appertisé	2.31	28.8	1.4	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15041	Amande, mondée, émondée ou blanchie	25.8	8.76	52.5	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15042	Amande, grillée, salée	24.1	8.72	53.9	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15043	Noix de macadamia, grillée, salée	8.3	9.95	70.2	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15044	Pistache, grillée	21.7	18.6	47.4	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15045	Tournesol, graine, grillé, salé	22.8	15.1	49.8	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15046	Noix de pécan, salées	12	5	73	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15047	Chia, graine, séchée	19.5	7.72	30.7	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15048	Mélange apéritif de graines (non salées) et fruits séchés	9.78	32.2	26.3	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15049	Mélange apéritif de graines (non salées) et raisins secs	14.8	31.8	37.2	541
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15050	Noisette grillée, salée	15.8	7.67	61.2	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15052	Lin, brun, graine	21.3	3.56	42.2	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15053	Cacahuète, grillée, sans sel ajouté	26.8	11.3	51.9	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15054	Noix de cajou, grillée, non salée	20.5	21.3	48.1	618
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15055	Noix de cajou, grillée à sec, non salée	20.5	23.5	49	630
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15201	Pâte d amande, préemballée	7	70.3	13.5	432
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15202	Beurre de cacahuète ou Pâte d arachide	25.4	16.1	52.5	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	15203	Tahin ou Purée de sésame	20.3	13.8	53.4	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	20581	Arachide, bouillie/cuite à l eau, salée	15.5	9.54	22	\N
2	205	0	fruits, légumes, légumineuses et oléagineux	fruits à coque et graines oléagineuses	-	20901	Soja, graine entière	37.8	20.8	19.2	432
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9081	Blé dur précuit, grains entiers, cuit, non salé	5.94	27.4	0.9	149
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9085	Nouilles asiatiques cuites, aromatisées	5.12	18.8	4.3	147
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9086	Pâtes ou nouilles asiatiques au blé, cuites, nature, non salées	3.75	21.4	6.9	165
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9103	Riz complet, cuit, non salé	3.38	32.6	1	158
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9104	Riz blanc, cuit, non salé	3.06	31.8	0.41	145
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9105	Riz blanc étuvé, cuit, non salé	3.1	31.7	0.56	146
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9110	Riz rouge, cuit, non salé	3.63	28.2	0.69	141
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9111	Riz sauvage, cuit, non salé	3.99	19.7	0.34	102
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9124	Riz thaï, cuit, non salé	3.06	30.5	0.7	143
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9125	Riz basmati, cuit, non salé	2.88	24.4	0.6	117
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9313	Flocons d avoine, bouillis/cuits à l eau	2.72	11.9	1.52	75.5
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9322	Orge perlée, bouilli/cuite à l eau, non salée	2.42	24.4	0.44	119
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9331	Mil, cuit, non salé	3.76	22.4	1	116
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9341	Quinoa, bouilli/cuit à l eau, non salé	5	27.9	1.1	149
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9615	Polenta ou semoule de maïs, cuite, non salée	1.38	16.9	0.3	77.5
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9683	Graine de couscous (semoule de blé dur précuite), cuite, non salée	5	31	1	157
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9691	Boulgour de blé, cuit, non salé	4	21.7	0.5	111
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9811	Pâtes sèches standard, cuites, non salées	4.38	25	0.55	126
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9816	Pâtes fraîches, aux oeufs, cuites, non salées	6.31	32	1.3	168
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9822	Pâtes sèches, aux oeufs, cuites, non salées	4.94	23	2	134
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9824	Pâtes sèches, sans gluten, cuites, non salées	3.25	34.4	1.1	163
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9871	Pâtes sèches, au blé complet, cuites, non salées	4.88	23.4	0.9	128
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9875	Pâtes, sans gluten, à base de riz et maïs, cuites à l eau, non salées	3.38	36.6	0.8	170
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9876	Pâtes, sans gluten, à base de lentilles corail, cuites à l eau, non salées	12.6	25.1	0.8	168
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9901	Vermicelle de riz, cuite, non salée	1.5	20.1	0.5	89.3
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	9903	Vermicelle de soja, cuite, non salée	0.63	14.4	0.1	61.2
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	25479	Gnocchi à la semoule, cuit	5.6	34.4	2.4	185
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	25510	Gnocchi à la pomme de terre, cuit	5.01	33.6	2.05	177
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	25579	Gnocchi, cuit (aliment moyen)	6.34	34	7.88	181
3	301	30101	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales cuits	51511	Frik (blé dur immature concassé), cuit, non salé	2.19	14	0.48	76
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9001	Épeautre, cru	15.6	59.5	2.43	344
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9003	Blé de Khorasan, cru	15.6	59.5	2.13	342
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9010	Blé tendre entier ou froment, cru	\N	\N	\N	\N
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9011	Blé germé, cru	8.03	41.4	1.27	211
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9060	Blé dur entier, cru	13	62.4	2.24	343
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9080	Blé dur précuit, entier, cru	14.7	67.7	1.83	359
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9100	Riz blanc, cru	7.4	78	0.91	352
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9101	Riz blanc étuvé, cru	7.47	78.6	0.98	356
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9102	Riz complet, cru	7.38	71.4	2.8	350
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9108	Riz sauvage, cru	11.7	69.2	0.94	344
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9109	Riz rouge, cru	8.38	70.6	3	352
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9119	Riz thaï ou basmati, cru	8.06	77.8	0.84	353
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9120	Riz thaï ou basmati, cuit, non salé	3	28.3	\N	\N
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9121	Riz, mélange de variétés (blanc, complet, rouge, sauvage, etc.), cru	7.5	78.1	1	355
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9200	Maïs entier, cru	8.1	67.2	3.7	346
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9310	Avoine, crue	18.1	55.7	6.9	378
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9320	Orge entière, crue	13.4	56.2	2.3	334
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9321	Orge perlée, crue	10.6	68.6	1.16	346
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9330	Mil entier, cru	11.8	64.3	4.21	359
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9340	Quinoa, cru	14.1	58.1	6.07	358
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9345	Amarante, crue	14.5	58.6	7.02	369
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9360	Sorgho entier, cru	10.6	65.4	3.46	349
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9380	Sarrasin entier, cru	12.9	64.6	3.55	356
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9390	Seigle entier, cru	10.5	61	1.97	334
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9610	Semoule de blé dur, crue	12	71.6	1.25	352
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9611	Semoule de blé dur, cuite, non salée	3.75	24	0.8	122
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9612	Mélange de céréales et légumineuses, cru	15	59	4	354
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9614	Polenta ou semoule de maïs, précuite, sèche	7.88	74	1.8	350
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9681	Graine de couscous (semoule de blé dur précuite), crue	13.2	72.7	1.45	365
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9690	Boulgour de blé, cru	12.4	66.8	1.71	351
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9810	Pâtes sèches standard, crues	12.6	65.8	1.79	336
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9815	Pâtes fraîches, aux oeufs, crues	11.1	53.8	1.87	283
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9821	Pâtes sèches, aux oeufs, crues	15.2	68	4.72	381
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9863	Pâtes ou nouilles asiatiques au blé et aux oeufs, crues, nature	13	71	3	371
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9870	Pâtes sèches, au blé complet, crues	12.6	67.6	2.2	353
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9874	Pâtes sèches, sans gluten, crues	6.61	79	1.24	356
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9900	Vermicelle de riz, sèche	7.81	80.5	1	365
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	9902	Vermicelle de soja, sèche	0.63	84.7	0.14	344
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	26264	Gnocchi à la pomme de terre, cru	4.66	35	1.42	176
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	26265	Gnocchi à la semoule, cru	6.2	37	2.6	200
3	301	30102	produits céréaliers	pâtes, riz et céréales	pâtes, riz et céréales crus	51510	Frik (blé dur immature concassé), cru	10.3	55.8	2.25	323
3	302	30201	produits céréaliers	pains et assimilés	pains	7000	Pain (aliment moyen)	9.01	54.4	1.61	276
3	302	30201	produits céréaliers	pains et assimilés	pains	7001	Pain, baguette, courante	9.06	58.3	1.4	287
3	302	30201	produits céréaliers	pains et assimilés	pains	7002	Pain, baguette ou boule, au levain	8.13	53.1	1.3	261
3	302	30201	produits céréaliers	pains et assimilés	pains	7007	Pain, baguette, de tradition française	8.94	56.6	1	279
3	302	30201	produits céréaliers	pains et assimilés	pains	7010	Pain, baguette ou boule, bis (à la farine T80 ou T110) 	9.43	54	0.33	265
3	302	30201	produits céréaliers	pains et assimilés	pains	7012	Pain courant, 400g ou boule	8.67	52	2	266
3	302	30201	produits céréaliers	pains et assimilés	pains	7025	Pain, baguette ou boule, bio (à la farine T55 jusqu à T110)	9.52	49.9	1.19	257
3	302	30201	produits céréaliers	pains et assimilés	pains	7100	Pain, baguette ou boule, de campagne	8.25	50	1.3	253
3	302	30201	produits céréaliers	pains et assimilés	pains	7110	Pain complet ou intégral (à la farine T150)	9.19	44.3	1.8	244
3	302	30201	produits céréaliers	pains et assimilés	pains	7111	Pain de mie, complet	9.33	43.7	4.06	262
3	302	30201	produits céréaliers	pains et assimilés	pains	7112	Pain de mie, au son	7.5	46	5.5	278
3	302	30201	produits céréaliers	pains et assimilés	pains	7113	Pain de mie, multicéréale	9.66	43.6	5.41	274
3	302	30201	produits céréaliers	pains et assimilés	pains	7115	Pain au son	8.8	44.4	2.6	249
3	302	30201	produits céréaliers	pains et assimilés	pains	7125	Pain de seigle, et froment	9.06	51.5	1	260
3	302	30201	produits céréaliers	pains et assimilés	pains	7130	Pain, sans gluten	2.75	51.8	3.3	261
3	302	30201	produits céréaliers	pains et assimilés	pains	7160	Pain, baguette, sans sel	9.1	56.5	1.3	279
3	302	30201	produits céréaliers	pains et assimilés	pains	7170	Pain panini	8.4	55.9	1.1	272
3	302	30201	produits céréaliers	pains et assimilés	pains	7200	Pain de mie, courant	7.81	52.3	3.6	278
3	302	30201	produits céréaliers	pains et assimilés	pains	7201	Pain de mie, sans croûte, préemballé	8.25	49.5	3.8	271
3	302	30201	produits céréaliers	pains et assimilés	pains	7210	Pain de mie brioché, préemballé	8.63	52.4	6.5	309
3	302	30201	produits céréaliers	pains et assimilés	pains	7255	Pain, baguette ou boule, aux céréales et graines, artisanal	10.5	46.9	3.2	269
3	302	30201	produits céréaliers	pains et assimilés	pains	7256	Muffin anglais, complet, petit pain spécial, préemballé	13.7	32.9	1.87	217
3	302	30201	produits céréaliers	pains et assimilés	pains	7257	Muffin anglais, petit pain spécial, préemballé	11.6	39.6	1.88	228
3	302	30201	produits céréaliers	pains et assimilés	pains	7258	Bagel	10.2	47.3	3.98	272
3	302	30201	produits céréaliers	pains et assimilés	pains	7259	Pain pour hamburger ou hot dog (bun), préemballé	9.95	49.7	5.35	293
3	302	30201	produits céréaliers	pains et assimilés	pains	7260	Pain blanc maison (avec farine pour machine à pain)	8.56	52.1	0.9	256
3	302	30201	produits céréaliers	pains et assimilés	pains	7261	Pain de campagne maison (avec farine pour machine à pain)	8.75	46.7	0.9	240
3	302	30201	produits céréaliers	pains et assimilés	pains	7262	Pain pour hamburger ou hot dog (bun), complet, préemballé	9.75	46.3	5.75	285
3	302	30201	produits céréaliers	pains et assimilés	pains	7263	Bretzel, pain frais	10.1	54.6	7.1	330
3	302	30201	produits céréaliers	pains et assimilés	pains	7813	Tortilla souple (à garnir), à base de maïs	9.06	54.7	5.8	313
3	302	30201	produits céréaliers	pains et assimilés	pains	7815	Tortilla souple (à garnir), à base de blé	9.15	52.1	8.2	327
3	302	30201	produits céréaliers	pains et assimilés	pains	23805	Blini	5.98	33.7	11.2	\N
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7004	Pain grillé, domestique	10.4	64	1.3	317
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7300	Biscotte classique	10.8	76.6	5.9	409
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7301	Biscotte briochée	11.9	69	9.28	417
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7310	Biscotte sans adjonction de sel	11.4	74	5.88	405
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7330	Biscotte multicéréale	12.9	66.7	7.22	398
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7340	Biscotte complète ou riche en fibres	12.8	67	6.17	393
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7351	Crackers de table au froment	8.5	75	12	450
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7352	Galette de riz soufflé complet	7.69	80.5	3	385
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7353	Galette multicéréales soufflée	8.86	82.4	2.5	394
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7354	Galette de maïs soufflé	7.44	\N	1.7	\N
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7400	Pain grillé, tranches, au froment	10.7	74.4	6.16	404
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7403	Pain grillé brioché, tranché, préemballé	11.6	70.8	9.19	419
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7407	Pain grillé suédois au froment	9.75	68.5	8.25	402
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7409	Pain grillé suédois aux graines de lin	11.3	63	9	396
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7410	Tartine craquante, extrudée et grillée	10.9	73.7	3.57	379
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7420	Pain grillé suédois au blé complet	11.5	66.4	8	398
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7421	Pain grillé suédois aux fruits	8.75	70.8	8	401
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7425	Pain grillé, tranches, multicéréale	12.1	68.8	9.3	419
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7431	Croûton à tartiner	13.5	70	2.85	374
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7432	Croûtons nature, préemballés	9.19	59.1	24.1	495
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7500	Chapelure	12.7	70	3.77	374
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	7525	Gressin	13.9	65.3	11.8	433
3	302	30202	produits céréaliers	pains et assimilés	biscottes et pains grillés	38500	Croûton à l ail aux fines herbes ou aux oignons, préemballé	8.81	58.9	24.1	492
3	303	0	produits céréaliers	biscuits apéritifs	-	9230	Pop-corn ou Maïs éclaté, à l huile, salé	11	52.6	23.8	485
3	303	0	produits céréaliers	biscuits apéritifs	-	9231	Pop-corn ou Maïs éclaté, à l air, non salé	10.2	60	12.3	417
3	303	0	produits céréaliers	biscuits apéritifs	-	9232	Pop-corn ou Maïs éclaté, au caramel	3	85.4	6.5	418
3	303	0	produits céréaliers	biscuits apéritifs	-	38104	Chips de crevette	3.1	63.7	26.6	508
3	303	0	produits céréaliers	biscuits apéritifs	-	38105	Chips de maïs ou tortilla chips	6.56	59.5	24.7	495
3	303	0	produits céréaliers	biscuits apéritifs	-	38106	Biscuit apéritif soufflé, à base de pomme de terre	4.25	60.5	24.1	484
3	303	0	produits céréaliers	biscuits apéritifs	-	38107	Biscuit apéritif, mini bretzel ou sticks	11.2	74.4	3.13	379
3	303	0	produits céréaliers	biscuits apéritifs	-	38108	Biscuit apéritif soufflé, à base de pomme de terre et de soja	19	58.3	9.33	409
3	303	0	produits céréaliers	biscuits apéritifs	-	38399	Biscuit apéritif (aliment moyen)	9.2	60.3	22.3	486
3	303	0	produits céréaliers	biscuits apéritifs	-	38400	Biscuit apéritif soufflé, à base de maïs, sans cacahuète	6.96	62.1	23	489
3	303	0	produits céréaliers	biscuits apéritifs	-	38401	Biscuit apéritif, crackers, garni ou fourré, au fromage	13.8	46.3	32.2	537
3	303	0	produits céréaliers	biscuits apéritifs	-	38402	Biscuit apéritif, crackers, nature	10.5	59	23.9	499
3	303	0	produits céréaliers	biscuits apéritifs	-	38403	Biscuit apéritif, crackers, nature, allégé en matière grasse	6.53	73.1	9.33	410
3	303	0	produits céréaliers	biscuits apéritifs	-	38404	Biscuit apéritif soufflé, à base de maïs, à la cacahuète	13.3	54.8	22.9	487
3	303	0	produits céréaliers	biscuits apéritifs	-	38405	Biscuit apéritif à base de pomme de terre, type tuile salée	4.63	59.1	28.8	521
3	303	0	produits céréaliers	biscuits apéritifs	-	38406	Cacahuètes (arachide) enrobées d un biscuit, pour apéritif	15.8	45.4	29.7	518
3	303	0	produits céréaliers	biscuits apéritifs	-	38407	Biscuit apéritif feuilleté	12.3	53.7	26.5	509
3	303	0	produits céréaliers	biscuits apéritifs	-	38408	Crêpe dentelle (pour apéritif) au fromage, préemballée	9.3	48.8	35.6	555
3	305	30501				4090	Fécule de pomme de terre	0	86.3	0.2	348
3	305	30501				9311	Flocon d avoine	14.2	57.9	6.51	367
3	305	30501				9410	Farine de blé tendre ou froment T110	10.3	68.6	1.5	343
3	305	30501				9415	Farine de blé tendre ou froment T150	12.2	64.9	1.52	342
3	305	30501				9435	Farine de blé tendre ou froment T65	14.9	67.6	1	346
3	305	30501				9436	Farine de blé tendre ou froment T55 (pour pains)	9.9	73.7	1	350
3	305	30501				9437	Farine de blé tendre ou froment avec levure incorporée	10	74	1	350
3	305	30501				9440	Farine de blé tendre ou froment T45 (pour pâtisserie)	9.94	75.9	0.82	356
3	305	30501				9445	Farine de blé tendre ou froment T80	10.9	73.2	1.18	355
3	305	30501				9480	Farine d épeautre (grand épeautre)	12.5	64	3	352
3	305	30501				9510	Amidon de maïs ou fécule de maïs	0.43	89.2	0.25	362
3	305	30501				9520	Farine de riz	8	73.9	2.5	357
3	305	30501				9530	Farine de seigle T170	17.1	44.8	2.22	315
3	305	30501				9532	Farine de seigle T85	8.7	70.7	1.37	344
3	305	30501				9533	Farine de seigle T130	7.76	70.9	1.12	344
3	305	30501				9540	Farine de sarrasin	11.5	68.4	2.19	348
3	305	30501				9545	Farine de maïs	6.23	78.1	2.1	361
3	305	30501				9550	Farine d orge	10.6	64.5	2.3	339
3	305	30501				9555	Farine de millet	10.2	63.2	4.1	350
3	305	30501				9580	Farine de pois chiche	22.4	47	6.69	359
3	305	30501				20900	Farine de soja	39.2	22.9	21.4	460
3	305	30501				96781	Amidon de riz	0.63	85	0	343
3	305	30502				23402	Pâte à pizza fine, crue	8.45	44.6	7.01	279
3	305	30502				23410	Pâte brisée, crue	5.87	43.6	19.5	377
3	305	30502				23412	Pâte brisée, matière grasse végétale, cuite	8.19	58.3	26.4	505
3	305	30502				23414	Pâte brisée, pur beurre, crue	6.33	44.9	19.5	384
3	305	30502				23415	Pâte brisée, pur beurre, surgelée, crue	6.2	43.3	20.7	387
3	305	30502				23416	Pâte brisée, pur beurre, cuite	8.31	61.1	23.9	497
3	305	30502				23420	Pâte feuilletée, matière grasse végétale, crue	5.93	41.4	20.4	377
3	305	30502				23421	Pâte feuilletée, surgelée, crue	3.6	33.3	27.4	400
3	305	30502				23422	Pâte feuilletée, cuite	7.88	54.1	31	531
3	305	30502				23424	Pâte feuilletée pur beurre, crue	6.14	39.7	20.1	368
3	305	30502				23425	Pâte feuilletée pur beurre, surgelée crue	5.47	35.3	25.8	398
3	305	30502				23426	Pâte feuilletée pur beurre, cuite	5.05	57	28.7	509
3	305	30502				23430	Feuille de brick, cuite à sec sans matière grasse	6.75	82.4	1.76	378
3	305	30502				23440	Pâte sablée, crue	5.3	51	19.6	404
3	305	30502				23442	Pâte sablée, cuite	5.7	64.4	24.6	505
3	305	30502				23444	Pâte sablée pur beurre, crue	5.95	53.6	15.8	383
3	305	30502				23445	Pâte phyllo ou Pâte filo, crue	7.1	50.8	6	289
3	305	30502				23446	Pâte sablée pur beurre, surgelée, crue	4.9	60.9	17.5	423
3	305	30502				23448	Pâte sablée pur beurre, cuite	6.2	63	20.9	469
3	305	30502				37001	Pâte à pizza crue	7.05	44.2	3.45	240
3	305	30502				51550	Khatfa feuille de brick, préemballée	7	59	1.5	283
3	305	30502				96778	Pâte à pizza cuite	8.5	55.3	7.1	324
4	401	0	viandes, œufs, poissons et assimilés	viandes cuites	-	6584	Viande blanche, cuite (aliment moyen)	28.1	0.26	6.55	173
4	401	0	viandes, œufs, poissons et assimilés	viandes cuites	-	6585	Viande rouge, cuite (aliment moyen)	26	0.027	10.1	195
4	401	0	viandes, œufs, poissons et assimilés	viandes cuites	-	6999	Viande cuite (aliment moyen)	27.2	0.24	8.04	182
4	401	0	viandes, œufs, poissons et assimilés	viandes cuites	-	36900	Volaille, cuite (aliment moyen)	27.6	0.28	5.96	166
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6100	Boeuf, entrecôte, partie maigre, grillée/poêlée	25.5	0.1	10.7	198
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6101	Boeuf, braisé	32.1	0	12.4	240
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6104	Boeuf, gîte à la noix, cuit	21	0.2	1.9	102
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6105	Boeuf, faux-filet, rôti/cuit au four	28.8	\N	8.71	194
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6110	Boeuf, faux-filet, grillé/poêlé	27.1	0	8.17	182
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6123	Boeuf, plat de côtes, braisé	37.3	0	13.3	269
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6131	Boeuf, hampe, grillée/poêlée	21.6	\N	9.76	174
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6141	Boeuf, joue, braisée ou bouillie	39.2	\N	8.82	236
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6151	Boeuf, jarret, bouilli/cuit à l eau	31	\N	4.1	161
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6161	Boeuf, tende de tranche, grillée/poêlée	28.7	\N	2.92	141
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6162	Boeuf, tende de tranche, rôtie/cuite au four	29.8	\N	3.03	146
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6200	Boeuf, steak ou bifteck, grillé	27.6	\N	1.95	128
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6205	Boeuf, onglet, grillé	23	\N	8.8	171
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6207	Boeuf, rumsteck, grillé	25	\N	2.5	123
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6208	Boeuf, boule de macreuse, grillée/poêlée	26.7	\N	4.11	144
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6210	Boeuf, rosbif, rôti/cuit au four	21.9	0.3	3.16	117
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6211	Boeuf, bavette d aloyau, grillée/poêlée	25	\N	6.94	162
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6214	Boeuf, boule de macreuse, rôtie/cuite au four	27.3	\N	4.2	147
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6230	Boeuf, à bourguignon ou pot-au-feu, cuit	34	\N	4.05	172
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6241	Boeuf, collier, braisé	33	\N	5.8	184
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6251	Boeuf, steak haché 5% MG, cuit	25.5	0	5.85	155
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6253	Boeuf, steak haché 10% MG, cuit	26.1	0	11.8	210
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6255	Boeuf, steak haché 15% MG, cuit	23.6	0	16.1	239
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6257	Boeuf, steak haché 20% MG, cuit	23	0.14	19.2	265
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6259	Boeuf, steak haché, cuit (aliment moyen)	23.8	0.0018	15.1	231
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6271	Boeuf, paleron, braisé ou bouilli	36.8	0.2	11.4	251
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6310	Boeuf, queue, bouillie/cuite à l eau	28	\N	9.3	196
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6511	Veau, côte, grillée/poêlée	25.1	0	6.24	156
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6512	Veau, carré, sauté/poêlé	28	\N	6.6	171
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6520	Veau, escalope, cuite	31	\N	2.5	147
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6523	Veau, noix, grillée/poêlée	29.1	\N	3.44	147
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6524	Veau, noix, rôtie	29.1	\N	3.44	147
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6531	Veau, filet, rôti/cuit au four	23.4	0.5	11.7	201
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6551	Veau, rôti, cuit	28.1	0	3.39	143
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6562	Veau, épaule, grillée/poêlée	27.6	\N	6.17	166
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6563	Veau, épaule, braisée ou bouillie	36.4	\N	8.14	219
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6564	Veau, viande, cuite (aliment moyen)	29	0.74	5.55	169
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6581	Veau, jarret, braisé ou bouilli	37.4	\N	6.43	207
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6582	Veau, tête, bouillie/cuite à l eau	21	\N	11.4	187
4	401	40101	viandes, œufs, poissons et assimilés	viandes cuites	bœuf et veau	6591	Veau, collier, braisé ou bouilli	34.9	\N	10.4	233
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28007	Porc, longe, cuite	27.1	0	14.7	240
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28009	Porc, palette, crue	24.8	\N	12.1	208
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28010	Porc, épaule, cuite	30	0	14.8	253
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28101	Porc, côte, grillée	29.6	0	10.3	211
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28103	Porc, rouelle de jambon, cuite	36.9	\N	13.1	266
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28105	Porc, carré, cuit	34.1	0.6	7.45	206
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28202	Porc, filet, maigre, en rôti, cuit	28.3	0	9.39	198
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28203	Porc, filet mignon, cuit	26.1	\N	7.1	168
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28205	Porc, viande, cuite (aliment moyen)	29.1	0.24	9.78	205
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28301	Porc, rôti, cuit	30.5	0.65	4.31	163
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28401	Porc, travers, braisé	23.1	0.13	26.6	333
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28451	Porc, échine, rôtie/cuite au four	26.2	0.1	21.2	295
4	401	40102	viandes, œufs, poissons et assimilés	viandes cuites	porc	28461	Porc, escalope de jambon, cuite	36	\N	6.2	200
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36004	Poulet, cuisse, viande et peau, rôtie/cuite au four	25.9	2	11.3	213
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36005	Poulet, viande et peau, rôti/cuit au four	28.9	2.1	9.88	213
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36006	Poulet, cuisse, viande, rôti/cuit au four	24.8	0	8.03	171
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36018	Poulet, filet, sans peau, sauté/poêlé	30.1	0	2	141
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36030	Poulet, cuisse, viande, bouilli/cuit à l eau	24.8	0.7	9.52	188
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36031	Poulet, cuisse, viande et peau, bouilli/cuit à l eau	26.1	0.55	9.1	188
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36032	Poulet, poitrine, viande et peau, rôti/cuit au four	29.8	0	7.78	189
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36033	Poulet, aile, viande et peau, rôti/cuit au four	23.8	0	16.9	247
4	401	40103	viandes, œufs, poissons et assimilés	viandes cuites	poulet	36041	Poulet, filet, sans peau, sauté/poêlé, bio	31.1	0	1.8	144
4	401	40104	viandes, œufs, poissons et assimilés	viandes cuites	dinde	36302	Dinde, viande, rôtie/cuite au four	29.1	0	3.84	151
4	401	40104	viandes, œufs, poissons et assimilés	viandes cuites	dinde	36306	Dinde, escalope, sautée/poêlée	28.5	0	1.09	124
4	401	40104	viandes, œufs, poissons et assimilés	viandes cuites	dinde	36308	Dinde, escalope, rôtie/cuite au four	24.6	0.5	3.04	128
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21501	Agneau, côtelette, grillée	25.7	\N	15.2	240
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21503	Agneau, gigot, rôti/cuit au four	26.8	0	6.85	169
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21506	Agneau, épaule, rôtie/cuite au four	30.5	0.1	14.5	252
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21507	Agneau, épaule, maigre, rôtie/cuite au four	24.9	0	10.8	197
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21508	Agneau, collier, braisé ou bouilli	33.6	\N	25.6	365
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21509	Agneau, côte filet, grillée/poêlée	26.3	\N	5.78	157
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21512	Agneau, côte première, grillée/poêlée	26.1	0	9.01	185
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21513	Agneau, selle, partie maigre, rôtie/cuite au four	26.1	0	5.45	153
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21518	Agneau, gigot, grillé/poêlé	27.6	\N	7.08	174
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21519	Agneau, gigot, braisé	35.2	\N	9.03	222
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21520	Agneau, selle, partie maigre, grillée/poêlée	26.1	\N	5.45	153
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21522	Agneau, côte ou côtelette, cuite (aliment moyen)	26.3	0	5.78	157
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21523	Agneau, viande, cuite (aliment moyen)	28.1	0.011	10.6	208
4	401	40105	viandes, œufs, poissons et assimilés	viandes cuites	agneau et mouton	21524	Agneau, côte ou côtelette, grillée/poêlée (aliment moyen)	26.3	0	5.78	157
4	401	40106	viandes, œufs, poissons et assimilés	viandes cuites	gibier	14000	Chevreuil, rôti/cuit au four	30.2	0	3.19	150
4	401	40106	viandes, œufs, poissons et assimilés	viandes cuites	gibier	14003	Sanglier, rôti/cuit au four	28.3	0	4.38	153
4	401	40106	viandes, œufs, poissons et assimilés	viandes cuites	gibier	14007	Cerf, rôti/cuit au four	30.2	0	3.19	150
4	401	40106	viandes, œufs, poissons et assimilés	viandes cuites	gibier	14008	Gibier à poil, cuit (aliment moyen)	29.6	0	3.74	152
4	401	40106	viandes, œufs, poissons et assimilés	viandes cuites	gibier	36402	Faisan, viande, rôtie/cuite au four	32.4	0	12.1	239
4	401	40106	viandes, œufs, poissons et assimilés	viandes cuites	gibier	36603	Gibier à plumes, viande, cuit (aliment moyen)	25.1	0	13	217
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	6902	Cheval, viande, rôtie/cuite au four	28	0	2.85	138
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	6906	Cheval, tende de tranche, grillée/poêlée	27.9	\N	2.58	135
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	6907	Cheval, faux-filet, grillé/poêlé	26.6	\N	6.27	163
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	6908	Cheval, entrecôte, grillée/poêlée	28.2	\N	6.24	169
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	6909	Cheval, faux-filet, rôti/cuit au four	28.3	\N	6.68	173
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	6910	Cheval, tende de tranche, rôtie/cuite au four	29.7	\N	2.75	144
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	21801	Chevreau, cuit	27.1	0	3.03	136
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	34000	Lapin, viande braisée	30.4	0	8.41	197
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	34002	Lapin, viande cuite	20.5	0.5	9.2	167
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	34004	Lapin de garenne, viande, cuite	33	0	3.51	164
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36051	Chapon, viande et peau, rôti/cuit au four	29	0	11.7	221
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36102	Caille, viande et peau, cuite	26.8	0	10.9	206
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36200	Canard, viande et peau, rôti/cuit au four	19	0	28.4	331
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36202	Canard, viande, rôtie/cuite au four	23.3	0	11.2	194
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36205	Canard, magret, grillé/poêlé	26.7	\N	12.8	222
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36502	Oie, viande, rôtie/cuite au four	29	0	12.7	230
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36503	Oie, viande et peau, rôtie/cuite au four	25.2	0	21.9	298
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36602	Pigeon, viande, rôtie/cuite au four	23.9	0	13	213
4	401	40107	viandes, œufs, poissons et assimilés	viandes cuites	autres viandes	36801	Autruche, viande cuite	26.2	0	7.07	168
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40003	Cervelle, agneau, cuite	12.6	0.8	10.2	145
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40004	Cervelle, porc, braisée	12.4	0.05	13.8	174
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40007	Cervelle, veau, cuite	11.5	0	9.63	133
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40053	Coeur, boeuf, cuit	23	0.15	4.5	133
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40056	Coeur, poulet, cuit	26.4	0.1	7.92	177
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40057	Coeur, dinde, cuit	24.9	0	7.52	167
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40059	Coeur, agneau, cuit	25	1.93	7.91	179
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40103	Foie, agneau, cuit	23	3.16	5.8	157
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40105	Foie, génisse, cuit	26.3	2.2	5.71	165
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40107	Foie, veau, cuit	19	4.47	3.02	121
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40109	Foie, volaille, cuit	25.8	0	6.4	164
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40113	Foie, porc, cuit	26	3.76	4.4	159
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40116	Foie, poulet, cuit	24.5	0.8	6.51	160
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40118	Foie, dinde, cuit	27	0	8.18	182
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40201	Langue, veau, cuite	21	0	17	237
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40203	Langue, boeuf, cuite	23.7	0	15.6	235
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40303	Ris, agneau, cuit	22.8	0	15.1	227
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40305	Ris, veau, braisé ou sauté/poêlé	21	0	5.8	136
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40401	Rognon, cuit (aliment moyen)	26.1	0	6.31	161
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40403	Rognon, boeuf, cuit	27	0	7	171
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40405	Rognon, porc, cuit	25.4	0	4.7	144
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40406	Rognon, agneau, braisé	23.7	0	3.62	127
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40408	Rognon, veau, braisé ou sauté/poêlé	26	0	7	167
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40601	Abat, cuit (aliment moyen)	25.1	1.36	6.24	162
4	401	40108	viandes, œufs, poissons et assimilés	viandes cuites	abats	40701	Gésier, canard, confit, appertisé	32.4	0	2.1	149
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6001	Boeuf, côte, crue	18.7	\N	19.6	251
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6002	Boeuf, épaule, crue	20.4	0	9.64	168
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6003	Boeuf, basse-côte, crue	19	1.45	13.2	201
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6102	Boeuf, gîte à la noix, cru	21.3	0	7.05	148
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6103	Boeuf, entrecôte, crue	19.4	0	17.1	231
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6106	Boeuf, rond de gîte, cru	22.9	0.38	2.02	111
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6111	Boeuf, faux-filet, cru	22.3	0.6	6.74	152
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6116	Boeuf, filet, cru	21.6	0.22	4.95	132
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6122	Boeuf, plat de côtes, cru	18.4	0	23.7	287
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6130	Boeuf, hampe, crue	19	0	8.63	154
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6140	Boeuf, joue, crue	22.3	0.4	5.02	136
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6150	Boeuf, jarret, cru	20.9	0	4.25	122
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6160	Boeuf, tende de tranche, crue	23.1	0.57	2.34	116
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6201	Boeuf, steak ou bifteck, cru	19.2	0	16.2	223
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6202	Boeuf, boule de macreuse, crue	21.8	0	3.36	118
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6204	Boeuf, onglet, cru	19.9	0.62	6.18	138
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6206	Boeuf, rumsteck, cru	22.5	0.4	2.5	114
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6212	Boeuf, bavette d aloyau, crue	20.4	0	5.67	133
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6231	Boeuf, à bourguignon ou pot-au-feu, cru	24	0	7.5	164
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6240	Boeuf, collier, cru	20.1	0.78	12.7	198
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6250	Boeuf, steak haché 5% MG, cru	21.9	0.3	4.59	130
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6252	Boeuf, steak haché 10% MG, cru	20	0.05	10.1	171
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6254	Boeuf, steak haché 15% MG, cru	20.2	0.47	14.1	209
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6256	Boeuf, steak haché 20% MG, cru	17.3	0	20	249
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6270	Boeuf, paleron, cru	21.2	0	6.54	144
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6311	Boeuf, queue, crue	21.5	0.23	12.9	203
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6510	Veau, côte, crue	18.3	0	12.9	189
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6513	Veau, carré, cru	19.5	0.4	7.25	145
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6521	Veau, escalope, crue	20.7	0.58	2.6	108
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6522	Veau, noix, crue	21.8	0	2.58	111
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6530	Veau, filet, cru	20.6	0	1.4	95
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6535	Veau, steak haché 20% MG, cru	16.7	0.4	19.5	243
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6536	Veau, steak haché 15% MG, cru	18.2	\N	15	208
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6540	Veau, poitrine, crue	18.7	0	11.2	176
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6550	Veau, rôti, cru	27.3	0	3.96	145
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6560	Veau, épaule, crue	20.7	0	4.63	124
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6580	Veau, pied, cru	19.1	\N	12	184
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6583	Veau, jarret, cru	21.3	0	3.66	118
4	402	40201	viandes, œufs, poissons et assimilés	viandes crues	bœuf et veau	6590	Veau, collier, cru	19.8	\N	5.92	133
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28001	Porc, épaule, crue	18.9	0.38	11.2	178
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28002	Porc, poitrine, crue	17	0	20.5	253
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28003	Porc, longe, crue	20.8	0.75	9.89	175
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28004	Porc, jarret, cru	19.9	0	12	187
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28100	Porc, côte, crue	19.8	0.38	9.3	164
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28102	Porc, rouelle de jambon, crue	20.2	0	7.56	149
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28104	Porc, carré, cru	22.7	0.4	5.94	146
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28201	Porc, filet, maigre, cru	21.2	0	3.6	117
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28204	Porc, filet mignon, cru	21.2	0.4	4.09	123
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28300	Porc, rôti, cru	22.3	0.5	6.86	153
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28302	Porc, échine, crue	18	0.1	14	198
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28400	Porc, travers, cru	18	0.6	18	237
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28460	Porc, escalope de jambon, crue	21.5	0	4.76	129
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28470	Porc, bardière découennée, crue	4.51	0.1	80.6	744
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28471	Porc, gorge, découennée, crue	11.6	0.14	47.5	475
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28472	Porc, hachage sans jarret, sans bateau, découenné, dégraissé, désossé, cru	18.9	0.23	12.3	187
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28473	Porc, jambon sans jarret, sans bateau, découenné, dégraissé, désossé, cru	20.9	0.28	6.3	141
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28474	Porc, jambonneau arrière, découenné, dégraisssé, désossé, cru	20.2	0.28	7.31	148
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28475	Porc, maigre 90/10, cru	18.8	0.24	15.1	212
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28476	Porc, maigre 80/20, cru	17.3	0.26	24.7	293
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28477	Porc, palette, découennée, dégraissée, désossée, crue	19.9	0.25	10.4	174
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28479	Porc, poitrine cutter, sans mouille, crue	15.9	0.22	28.7	323
4	402	40202	viandes, œufs, poissons et assimilés	viandes crues	porc	28480	Porc, rôti filet avec chaînette, cru	22.3	0.37	6.2	146
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36002	Poulet, cuisse, viande et peau, cru	17.3	0	13.5	192
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36003	Poulet, viande, crue	20	0	3.73	113
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36007	Poulet (var. blanc), viande et peau, cru	21.2	0	4.3	123
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36008	Poulet fermier, viande et peau, cru	21.5	0.2	5.4	135
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36016	Poulet, viande et peau, cru	20.2	0.3	10.1	173
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36017	Poulet, filet, sans peau, cru	23.4	0	1.5	110
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36019	Poulet, haut de cuisse, viande, cru	19.7	0	4.12	116
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36020	Poulet éviscéré sans abats, cru	18.6	\N	15.1	210
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36022	Poulet, pilon, cru	18.4	0	9.05	155
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36023	Poulet, aile, viande et peau, cru	20.4	0	11	181
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36024	Poulet, cuisse, viande, cru	19.3	0	4.05	114
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36029	Poulet, poitrine, viande et peau, cru	21.1	0	8.08	157
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36037	Poulet, cuisse, viande et peau, cru, bio	18.1	0	13.3	193
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36038	Poulet, cuisse, viande et peau, cru, label rouge	19.1	0	10.6	173
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36039	Poulet, filet, sans peau, cru, bio	24.6	0	1.8	118
4	402	40203	viandes, œufs, poissons et assimilés	viandes crues	poulet	36040	Poulet, filet, sans peau, cru, label rouge	25.2	0	1	113
4	402	40204	viandes, œufs, poissons et assimilés	viandes crues	dinde	36300	Dinde, viande et peau, crue	23.4	0	4.31	132
4	402	40204	viandes, œufs, poissons et assimilés	viandes crues	dinde	36301	Dinde, viande, crue	22.4	0.8	1.88	110
4	402	40204	viandes, œufs, poissons et assimilés	viandes crues	dinde	36304	Dinde, escalope, crue	24.1	0.51	1.22	109
4	402	40204	viandes, œufs, poissons et assimilés	viandes crues	dinde	36305	Dinde, cuisse, viande et peau, crue	19.8	0	7.85	150
4	402	40204	viandes, œufs, poissons et assimilés	viandes crues	dinde	36307	Dinde, cuisse, viande sans peau, crue	21.3	0.4	2.5	109
4	402	40204	viandes, œufs, poissons et assimilés	viandes crues	dinde	36310	Dinde, aile, crue	20.2	0	12.3	192
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21001	Mouton, viande, crue	20.6	\N	6.11	137
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21003	Mouton, épaule, crue	18.3	0.1	14.5	204
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21004	Mouton, pied, cru	18.1	\N	14.6	204
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21005	Mouton, tête, crue	18.1	\N	14.6	204
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21006	Mouton, gigot, cru	18	\N	17	225
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21500	Agneau, côtelette, crue	14.4	0	34.5	368
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21502	Agneau, gigot, cru	20	0.48	5.13	128
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21504	Agneau, épaule, crue	18.3	0.45	10.6	170
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21505	Agneau, épaule, maigre, crue	19.6	0	6.76	139
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21514	Agneau, collier, cru	18	\N	13.7	195
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21515	Agneau, selle, crue	17.5	0	18.4	236
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21516	Agneau, côte filet, crue	17.6	2.3	18	242
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21517	Agneau, côte première, crue	16.9	0	23.1	276
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21521	Agneau, côte ou côtelette, crue (aliment moyen)	16.3	0.92	22.6	273
4	402	40205	viandes, œufs, poissons et assimilés	viandes crues	agneau et mouton	21525	Agneau, côte découverte, crue	16.3	1.38	15	205
4	402	40206	viandes, œufs, poissons et assimilés	viandes crues	gibier	14002	Sanglier, cru	20.7	0	7.13	147
4	402	40206	viandes, œufs, poissons et assimilés	viandes crues	gibier	14004	Lièvre, viande crue	21.6	0	2.67	111
4	402	40206	viandes, œufs, poissons et assimilés	viandes crues	gibier	14005	Chevreuil, cru	23	0	2	110
4	402	40206	viandes, œufs, poissons et assimilés	viandes crues	gibier	14006	Cerf, cru	23.7	0	2.04	113
4	402	40206	viandes, œufs, poissons et assimilés	viandes crues	gibier	36401	Faisan, viande, cru	23.3	0	3.78	127
4	402	40206	viandes, œufs, poissons et assimilés	viandes crues	gibier	36403	Faisan, viande et peau, cru	23.2	0	7.95	164
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	6900	Cheval, viande, crue	18.8	0.6	10	167
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	6901	Cheval, steak, cru	21.4	0.4	4.6	129
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	6903	Cheval, tende de tranche, crue	22.7	\N	1.68	106
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	6904	Cheval, faux-filet, cru	22.2	\N	3.58	121
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	6905	Cheval, entrecôte, crue	22.1	\N	3.34	118
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	21800	Chevreau, cru	20.6	0	2.31	103
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	34001	Lapin, viande crue	20.4	0.66	11.6	189
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	34003	Lapin de garenne, viande, crue	21.8	0	2.32	108
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36000	Poule, viande et peau, crue	17.8	0.4	15.8	215
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36001	Poule, viande ,crue	20.9	0	4.51	124
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36014	Poule, cuisse, crue	19.6	0	5.92	131
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36050	Chapon, viande et peau, cru	21.8	0	10.6	183
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36100	Caille, viande et peau, crue	21.5	0	5.55	136
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36101	Caille, viande, crue	22.5	0.5	3.81	126
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36201	Canard, viande, crue	19.4	0	5.33	126
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36203	Canard, cuisse avec peau, sans os, crue	18.7	\N	3.1	103
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36204	Canard, viande et peau, cru	17.4	2.75	22.6	284
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36206	Canard, magret, cru	17.9	0.85	29.4	340
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36500	Oie, viande crue	22.6	0	7.12	155
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36501	Oie, viande et peau, crue	15.7	0	33.6	365
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36600	Pigeon, cru	18.9	0.7	16	222
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36700	Pintade, crue	22.8	0	5.75	143
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36702	Pintade, poitrine, crue	25.1	0	0.7	107
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36703	Pintade, cuisse, crue	21.3	0	4	121
4	402	40207	viandes, œufs, poissons et assimilés	viandes crues	autres viandes	36800	Autruche, viande crue	20.2	0	8.7	159
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40002	Cervelle, agneau, crue	10.4	0.8	8.58	122
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40005	Cervelle, porc, crue	10.3	0	9.21	124
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40006	Cervelle, veau, crue	10.3	0.5	8.21	117
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40052	Coeur, boeuf, cru	18.5	0.7	2.95	103
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40054	Coeur, poulet, cru	15.6	0.7	9.32	149
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40055	Coeur, dinde, cru	16.7	0.4	7.44	135
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40058	Coeur, agneau, cru	16.5	0.4	5.68	119
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40060	Coeur, porc, cru	17.1	0.4	4.33	109
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40062	Coeur, veau, cru	16.1	1.8	3.84	106
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40102	Foie, agneau, cru	21.8	2.92	5.45	148
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40104	Foie, génisse, cru	21	3.67	4.3	138
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40106	Foie, veau, cru	15.5	5.64	3.4	120
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40108	Foie, volaille, cru	21.3	1.13	4.88	133
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40110	Foie, lapin, cru	19	5	4	132
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40111	Foie, poulet, cru	18.8	1.1	4.62	121
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40115	Foie, dinde, cru	18.3	0	5.5	123
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40119	Foie, porc, cru	20.6	1.85	4.2	127
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40120	Foie, oie, cru	16.3	6.3	4.29	129
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40121	Foie, canard, cru	18.7	3.5	4.62	131
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40202	Langue, boeuf, crue	16.8	0.4	13.8	193
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40204	Langue, veau, crue	17	0.9	8.84	151
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40205	Langue, porc, crue	16.6	0.5	13.6	191
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40207	Langue, agneau, crue	15.4	1.75	10.9	167
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40302	Ris, agneau, cru	14.6	0	7.04	122
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40304	Ris, veau, cru	17.4	0	3.02	96.6
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40402	Rognon, boeuf, cru	17.1	0.9	2.65	95.9
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40404	Rognon, porc, cru	16.4	1.1	3.13	97.9
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40407	Rognon, agneau, cru	14.7	1.13	3.43	94.1
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40409	Rognon, veau, cru	16	0.2	2.36	86.1
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40502	Tripes, boeuf, crues	12.1	0	3.69	81.5
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40600	Sang, boeuf, cru	19.5	0.8	0.12	82.1
4	402	40208	viandes, œufs, poissons et assimilés	viandes crues	abats	40700	Gésier, poulet, cru	17.3	0.6	3.75	105
4	403	0	viandes, œufs, poissons et assimilés	charcuteries et assimilés	-	30900	Charcuterie (aliment moyen)	19.7	1.47	17.1	238
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	8429	Jambon persillé en gelée	19	0.48	7.9	152
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28700	Jambon de porc à cuire ou Jambon à rôtir/cuire au four	19.9	0	9.08	161
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28727	Filet de bacon	23.1	0.7	2.6	118
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28803	Jambon cuit, fumé	20	0.79	5.8	135
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28900	Jambon cuit, supérieur	20.8	0.81	4.28	125
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28901	Jambon cuit, supérieur, avec couenne	20.2	0.91	5.82	137
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28902	Jambon cuit, supérieur, découenné	20.5	0.77	3.52	117
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28905	Jambon à l os braisé	21.6	0.3	16.8	238
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28906	Jambon cuit, supérieur, découenné dégraissé	20.3	1.03	3.66	119
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28907	Jambon cuit, supérieur, à teneur réduite en sel	20.8	0.74	3.83	121
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28910	Jambon cuit, choix	19.5	1.7	4.5	125
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28911	Épaule de porc, cuite, choix, découennée dégraissée	18	1.93	4.5	121
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28912	Jambon cuit, choix, avec couenne	19.4	0.55	6.3	137
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28913	Jambon cuit, choix, découenné dégraissé	19.6	1.61	3.24	114
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28917	Rond de jambon cuit	20.3	1.4	10.6	182
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28922	Dés, allumettes, râpé ou haché de jambon	17.9	2.08	4.46	121
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28924	Épaule de porc, cuite, standard, découennée dégraissée	13.7	3.58	5.98	123
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28925	Jambon cuit, de Paris, découenné dégraissé	20	1.08	3.42	115
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28929	Dés, allumettes, râpé ou haché de jambon de volaille	18	1.58	5.88	132
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28960	Jambonneau, cuit	23.2	0.4	7.52	162
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28963	Jambon de poulet ou Blanc de poulet en tranche	20.7	1.39	1.79	106
4	403	40301	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons cuits	28964	Jambon de dinde ou Blanc de dinde en tranche	20.9	1.29	1.67	104
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28800	Jambon cru	25.9	0.76	13.2	225
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28801	Jambon cru, fumé	24.2	0.98	16.1	246
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28802	Jambon sec, découenné, dégraissé	26.3	0.3	9.5	192
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28804	Jambon cru, fumé, allégé en matière grasse	27.7	0.1	3.4	142
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28811	Jambon de Bayonne	28	0.63	12.6	228
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28812	Jambon sec	28.7	0.48	12.6	230
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28844	Jambon sec de Parme	27.2	0.3	15.4	248
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28845	Jambon sec Serrano	30.4	0.76	12.3	235
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28850	Coppa	25	1	20	284
4	403	40302	viandes, œufs, poissons et assimilés	charcuteries et assimilés	jambons secs et crus	28858	Pancetta ou Poitrine roulée sèche	20.2	0.75	28.8	342
4	403	40303	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisson secs	30300	Saucisson sec	24.2	2.41	34.5	418
4	403	40303	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisson secs	30301	Saucisson sec pur porc	28.7	1.79	32.3	417
4	403	40303	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisson secs	30302	Saucisson sec pur porc, qualité supérieure	27.7	1.65	27.6	366
4	403	40303	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisson secs	30304	Rosette ou Fuseau	24.2	1.79	30.7	380
4	403	40303	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisson secs	30309	Saucisse sèche	27.3	1.7	37.1	451
4	403	40303	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisson secs	30311	Saucisson sec aux noix et/ou noisettes	27.7	1.78	39.7	477
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30005	Chipolata, cuite	18.8	0.8	22.4	282
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30011	Saucisse de Toulouse, cuite	18.8	0	22.1	274
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30050	Chair à saucisse, crue	14.7	0.6	29.1	323
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30051	Chair à saucisse, pur porc, crue	15.4	5.25	21.2	273
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30052	Farce porc et boeuf, crue	11.8	4.4	26.5	309
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30102	Saucisse fumée, à cuire	16.8	\N	30.7	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30104	Saucisse de Morteau	16	1	36.6	397
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30105	Saucisse de Montbéliard	17.3	1	27.3	319
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30108	Saucisse de Morteau, bouillie/cuite à l eau	15.2	0	29.1	323
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30110	Saucisse de Toulouse, crue	13.2	1	30	327
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30115	Chipolata, crue	15.8	1	20.6	253
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30125	Saucisse alsacienne fumée ou Gendarme	19	\N	24.9	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30130	Saucisse de volaille, façon charcutière	16.8	1.19	17.7	231
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30131	Saucisse de volaille, type Knack	14	1.82	18.9	236
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30134	Saucisse de Francfort	13.7	1.24	23.4	271
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30150	Merguez, crue	13.5	2.5	28	316
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30152	Merguez, pur boeuf, crue	11	\N	43.5	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30153	Merguez, porc et boeuf, crue	11.5	\N	41	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30154	Merguez, boeuf, mouton et porc, crue	14.6	\N	33.3	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30155	Merguez, boeuf et mouton, cuite	19.8	1.8	21.8	283
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30156	Merguez, boeuf et mouton, crue	14	2.8	27.6	315
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30176	Saucisse de foie	11.7	0.9	35.9	374
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30177	Diot, cru	18	\N	30	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30742	Saucisse de Strasbourg ou Knack	12.4	1.39	25.9	291
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30746	Saucisse cocktail	12.7	1.46	25.9	290
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30750	Saucisse viennoise, crue	10.3	\N	21.3	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30764	Saucisse de jambon pur porc	15.7	1	17.5	224
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30766	Saucisse de bière	13	\N	29.7	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30778	Saucisse de langue à la pistache	15.3	\N	25.8	\N
4	403	40304	viandes, œufs, poissons et assimilés	charcuteries et assimilés	saucisses et assimilés	30780	Saucisse (aliment moyen)	17.3	0.88	23	281
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8120	Confit de foie de porc	16	14.1	25	346
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8125	Confit de foie de volaille	14	7.42	30	356
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8201	Pâté au poivre vert	10.1	1.45	34.6	358
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8206	Pâté au jambon	15.2	\N	28.6	\N
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8211	Pâté ou terrine de campagne	15.5	1.5	28.2	323
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8214	Pâté breton	11	2.88	34	363
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8232	Terrine de canard	13.2	4.44	27.1	320
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8240	Pâté de lapin	16.3	0.00027	20.2	247
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8242	Terrine de lapin	16.5	5.67	21.2	281
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8245	Pâté de gibier	15	4	23	284
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8250	Pâté ou terrine aux champignons (forestier)	12.6	5.93	28.1	329
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8300	Pâté de foie de porc, supérieur	13	2.4	31	341
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8305	Pâté de foie de porc	10.8	2.91	33.3	355
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8312	Mousse de foie de porc supérieure ou Crème de foie	11.1	10.3	26.1	322
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8313	Mousse de foie de porc	12	3.39	24.9	287
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8315	Mousse de canard	10.1	7.07	36.1	395
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8316	Pâté de foie de volaille	13.8	1.96	22.9	269
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8326	Pâté de foie d oie	11.4	4.67	43.8	459
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8332	Pâté (aliment moyen)	13.6	4.61	27.9	325
4	403	40305	viandes, œufs, poissons et assimilés	charcuteries et assimilés	pâtés et terrines	8391	Pâté en croûte	11	22.9	17.1	292
4	403	40306	viandes, œufs, poissons et assimilés	charcuteries et assimilés	rillettes	8000	Rillettes traditionnelles de porc	14.3	0.2	36.9	390
4	403	40306	viandes, œufs, poissons et assimilés	charcuteries et assimilés	rillettes	8001	Rillettes pur porc	16.7	0.13	38.3	414
4	403	40306	viandes, œufs, poissons et assimilés	charcuteries et assimilés	rillettes	8010	Rillettes de Tours	18	\N	50	522
4	403	40306	viandes, œufs, poissons et assimilés	charcuteries et assimilés	rillettes	8015	Rillettes du Mans	15.6	4.7	37.6	420
4	403	40306	viandes, œufs, poissons et assimilés	charcuteries et assimilés	rillettes	8025	Rillettes pur oie	14.7	\N	39.8	417
4	403	40306	viandes, œufs, poissons et assimilés	charcuteries et assimilés	rillettes	8026	Rillettes de canard	15.3	1.03	34.6	377
4	403	40306	viandes, œufs, poissons et assimilés	charcuteries et assimilés	rillettes	8030	Rillettes d oie	14.9	0.99	33.4	364
4	403	40306	viandes, œufs, poissons et assimilés	charcuteries et assimilés	rillettes	8040	Rillettes de poulet	16.4	0.49	30.3	340
4	403	40307	viandes, œufs, poissons et assimilés	charcuteries et assimilés	quenelles	8903	Quenelle de veau, en sauce	3.52	15.6	9.5	165
4	403	40307	viandes, œufs, poissons et assimilés	charcuteries et assimilés	quenelles	8910	Quenelle de volaille, crue	9.3	14.1	10.1	187
4	403	40307	viandes, œufs, poissons et assimilés	charcuteries et assimilés	quenelles	8912	Quenelle de volaille, en sauce	3.55	10.3	8.92	138
4	403	40307	viandes, œufs, poissons et assimilés	charcuteries et assimilés	quenelles	8932	Quenelle de poisson, en sauce	3.79	10.5	8.51	135
4	403	40307	viandes, œufs, poissons et assimilés	charcuteries et assimilés	quenelles	8933	Quenelle de poisson, crue	8.1	23.6	12.7	245
4	403	40307	viandes, œufs, poissons et assimilés	charcuteries et assimilés	quenelles	8934	Quenelle de poisson, cuite	5.72	\N	13.1	\N
4	403	40307	viandes, œufs, poissons et assimilés	charcuteries et assimilés	quenelles	8937	Quenelle nature, crue	7.68	14.8	13.7	217
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8109	Confit de canard, viande (cuisse), sans peau, réchauffé	32	\N	7.4	195
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8110	Confit de canard	25.7	0.15	18.8	273
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8111	Canard, magret fumé	21.9	0.55	30.5	364
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8321	Foie gras, canard, entier, cuit	8.41	2.32	54.6	535
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8323	Foie gras, canard, bloc, sans morceaux	5.75	2.1	50	482
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8324	Foie gras, canard, bloc, 30% de morceaux	6.88	2.43	50.1	489
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8325	Foie gras, canard, bloc, 50% de morceaux	6.39	2	49.5	479
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8328	Foie gras de canard, cru	5.94	1.41	63.4	600
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8331	Foie gras, canard, bloc (aliment moyen)	6.88	2.43	50.1	489
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8350	Galantine (aliment moyen)	15.2	1.57	23.4	279
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8373	Roulade de porc pistachée	17.7	0.7	20.2	258
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8380	Oeuf au jambon en gelée	11.5	\N	4.7	\N
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8395	Jambon en croûte	14.1	17.8	7	193
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8400	Fromage de tête	14.1	0.2	12.9	173
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8406	Museau de porc vinaigrette	8.22	1.02	16.3	185
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8450	Museau de boeuf	26.2	0	5.17	151
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8500	Andouille	18.4	0.3	15.1	211
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8501	Andouille de Guéméné	18	\N	18	234
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8504	Andouille, réchauffée à la poêle	22.5	0	20	271
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8512	Andouille de Vire	19	\N	18	238
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8550	Andouillette, à cuire	18.8	1	16.3	227
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8551	Andouillette, sautée/poêlée	24.5	1	22.3	303
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8552	Andouillette de Troyes, à cuire	19.7	0.5	19	254
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8703	Boudin noir, à cuire	12.2	4.5	27.1	313
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8704	Boudin noir, sauté/poêlé	11.9	3.78	20.3	246
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8705	Boudin, sauté/poêlé (aliment moyen)	11.3	4.02	19.4	246
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8742	Boudin antillais, à cuire	11.5	9.2	16.5	\N
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8800	Boudin blanc, sauté/poêlé	9.89	4.6	17.1	\N
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8801	Boudin blanc, à cuire	10	\N	21	\N
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	8803	Boudin blanc truffé, à cuire	11.3	4.8	17.8	227
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	25610	Museau de boeuf en vinaigrette	11.3	1	13.1	167
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28501	Lardon nature, cru	16.6	1.01	22.1	270
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28502	Poitrine de porc, fumée, crue	15.6	0.79	26.1	303
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28503	Bresaola	31.6	0	4.3	165
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28504	Lardon nature, cuit	23.8	2	24.5	324
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26192	Lieu jaune ou colin, cuit	24.4	\N	0.5	100
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28505	Corned-beef, appertisé	23.1	0.1	10.5	188
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28530	Oreille de porc demi-sel	22.5	0.6	15.1	228
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28540	Pied de porc demi-sel	11.6	0.01	10	137
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28550	Poitrine de porc demi-sel	16.8	0.75	22	268
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28720	Lardon fumé, cru	16.7	0.96	22.6	275
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28725	Lardon fumé, cuit	14.7	0.8	22.1	261
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28860	Viande des Grisons	38.9	1	5.47	209
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28927	Haché de volaille	17.7	3.5	5.68	137
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	28976	Rôti de volaille en salaison, cuit	22	1.28	1.73	110
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30315	Chorizo	23.5	3.05	36.1	433
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30316	Chorizo supérieur, doux ou fort, type saucisse sèche	20.9	2.6	41.9	476
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30317	Chorizo supérieur, doux ou fort, type charcuterie en tranches	22.6	2.1	23.9	322
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30350	Salami	17.7	1.05	41.8	451
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30351	Salami pur porc	22.6	1.6	33.7	400
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30352	Salami porc et boeuf	21.5	1.56	28.8	351
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30366	Salami type danois	17	1.35	42.9	459
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30700	Saucisson à l ail	15	1.63	23.6	280
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30701	Saucisson cuit pur porc	13.8	1.3	29	322
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30705	Saucisson de Paris	12.5	0.6	32.7	346
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30706	Saucisson de Paris, fumé	13.7	0.6	25.6	288
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30707	Saucisson brioché, cuit	14.7	22.6	17.4	309
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30730	Cervelas	11.9	1.56	24.8	278
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30731	Cervelas obernois	13	1	27.5	305
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30732	Cervelas à l ail, pur porc	12.5	0.2	27.4	297
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30789	Mortadelle	15	1.4	26.7	305
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30790	Mortadelle, pur porc	14.8	1.55	25.8	298
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30791	Mortadelle, porc et boeuf	16.4	0.7	25.4	297
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30797	Mortadelle pistachée pur porc	14.4	1.16	28.2	320
4	403	40308	viandes, œufs, poissons et assimilés	charcuteries et assimilés	autres spécialités charcutières	30801	Saucisson de cheval type cervelas	14.2	\N	20	\N
4	403	40309	viandes, œufs, poissons et assimilés	charcuteries et assimilés	substituts de charcuteries pour végétariens	1030	Spécialité végétale type jambon cuit, préemballée	29.7	4.13	11.1	242
4	403	40309	viandes, œufs, poissons et assimilés	charcuteries et assimilés	substituts de charcuteries pour végétariens	1031	Spécialité végétale type pâté, préemballée	3.56	9.45	15.4	197
4	403	40309	viandes, œufs, poissons et assimilés	charcuteries et assimilés	substituts de charcuteries pour végétariens	20337	Saucisse végétale au tofu (convient aux véganes ou végétaliens), préemballée	14.6	5.69	16.3	231
4	403	40309	viandes, œufs, poissons et assimilés	charcuteries et assimilés	substituts de charcuteries pour végétariens	20338	Quenelle au tofu (ne convient pas aux véganes ou végétaliens), préemballée	12.1	4.97	7.2	136
4	403	40309	viandes, œufs, poissons et assimilés	charcuteries et assimilés	substituts de charcuteries pour végétariens	25232	Saucisse végétale au blé ou seitan, préemballé	29.1	7.53	10.5	250
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	6260	Haché à base de boeuf ou Préparation de viande hachée de boeuf, 15% MG, cru, prémeballé	15.8	2.48	13.6	\N
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25089	Cordon bleu de volaille, préemballé	14	14.6	12.2	226
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25163	Boeuf, boulettes cuites	18.5	5.65	13.3	217
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25173	Veau, escalope panée, cuite	22.9	12.6	14.1	271
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25186	Boulettes au porc et au boeuf (à la suédoise), préemballées, crues	14.4	7.78	18.6	260
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25194	Boulettes au boeuf et à l agneau (type kefta), préemballées, crues	15.7	9.46	15.7	247
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25504	Brochette de volaille	18.6	0.8	13	195
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25505	Brochette de boeuf	17.1	1.02	12.9	191
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25506	Brochette mixte de viande	19.7	1.02	13.8	208
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25512	Volaille, croquette panée ou nuggets	13.1	16.2	13.2	239
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25541	Brochette d agneau	12.6	2.54	5.1	112
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	25566	Brochette de porc, crue	15.6	2.1	6.5	131
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	36027	Poulet, croquette panée ou nuggets	15.6	19.4	11.6	250
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	36035	Poulet, manchons marinés, rôtis/cuits au four	22.4	2.1	12.6	213
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	36036	Poulet, escalope panée	7.25	21.7	24	339
4	404	0	viandes, œufs, poissons et assimilés	autres produits à base de viande	-	36318	Dinde, escalope viennoise ou milanaise ou escalope panée	14.1	13.5	10.9	211
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	25996	Saumon, cuit, sans précision (aliment moyen)	23	0	12.5	205
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	25997	Cabillaud, cuit, sans précision (aliment moyen)	23.1	0	0.73	98.9
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	25998	Hareng fumé, filet, doux	18.1	0	9.9	162
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26003	Carrelet ou plie, cuit à la vapeur	19	\N	1.89	93
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26008	Églefin, cuit à la vapeur	20.9	\N	0.6	89
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26012	Hareng, frit	23	\N	12.1	201
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26013	Hareng fumé, au naturel	16.5	0.5	11.7	173
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26014	Hareng, grillé/poêlé	21.6	\N	11.4	189
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26015	Lieu noir, cuit	23.1	\N	0.81	99.7
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26017	Limande-sole, cuite à la vapeur	17.4	\N	2.27	90.1
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26019	Maquereau, rôti/cuit au four	21.5	\N	15.8	228
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26020	Maquereau, frit	23.6	\N	10.2	186
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26021	Merlan, frit	23.1	\N	3.61	125
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26022	Merlan, cuit à la vapeur	23	\N	0.7	98.3
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26023	Cabillaud, rôti/cuit au four	22.3	\N	0.6	94.6
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26024	Morue, salée, bouillie/cuite à l eau	26	\N	1.01	113
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26025	Cabillaud, cuit à la vapeur	24.5	\N	0.95	106
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26026	Mulet, rôti/cuit au four	24.8	\N	4.86	143
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26031	Raie, rôtie/cuite au four	23	\N	0.5	96.3
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26033	Roussette ou petite roussette ou saumonette, cuite	25.4	\N	17.2	256
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26037	Saumon fumé	22	0.91	9.49	178
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26038	Saumon, cuit à la vapeur	23	\N	11.5	195
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26041	Thon, rôti/cuit au four	29.9	\N	1.83	136
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26059	Sole, cuite à la vapeur	20.3	\N	1.48	94.6
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26060	Sole, rôtie/cuite au four	15.7	\N	1.69	78.2
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26061	Sole, bouillie/cuite à l eau	15	\N	1	69
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26062	Sole, frite	15.8	\N	1	72.2
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26073	Raie, cuite au court-bouillon	23.2	\N	0.57	97.8
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26081	Lotte ou baudroie, grillée/poêlée	23	\N	0.68	98.2
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26087	Maquereau, fumé	18.8	0	24.3	294
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26090	Haddock (fumé) ou églefin fumé	22.6	0	0.73	97
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26093	Espadon, rôti/cuit au four	28.7	\N	16.9	266
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26094	Turbot, rôti/cuit au four	21.3	\N	3.64	118
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26120	Merlu, cuit à l étouffée	21.2	\N	3	112
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26126	Églefin, grillé/poêlé	20	\N	0.55	84.9
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26136	Sardine, grillée	25.1	\N	10.4	194
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26147	Vivaneau, cuit	26.3	\N	1.72	121
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26148	Rascasse, cuite à la vapeur	24.6	\N	3.1	126
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26152	Lieu ou colin d Alaska, fumé	18.3	0	0.9	81.3
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26211	Saumon, cuit au micro-ondes, élevage	24.2	\N	11.4	200
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26217	Saumon, bouilli/cuit à l eau, élevage	25	\N	10.3	193
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26222	Dorade grise, ou daurade grise, ou griset, rôtie/cuite au four	22.9	\N	3.3	121
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26229	Saumon, grillé/poêlé	25.5	\N	13.5	223
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26230	Saumon, élevage, rôti/cuit au four	22.1	\N	13.5	210
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26232	Hareng fumé, à l huile	15.1	2	11	168
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26234	Julienne ou Lingue, cuite	24.5	\N	0.82	105
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26247	Flétan du Groënland ou flétan noir ou flétan commun, cuit à la vapeur	17.3	\N	11.6	173
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26248	Sole, poêlée	23.6	\N	0.5	96.7
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	26999	Anguille, cuite (aliment moyen)	22.1	0	13.8	213
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27000	Anguille, rôtie/cuite au four	23.6	\N	15	229
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27001	Anguille, bouillie/cuite à l eau	20.5	\N	12.7	197
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27002	Brochet, rôti/cuit au four	23.1	\N	0.88	100
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27004	Carpe, rôtie/cuite au four	21.6	\N	7.17	151
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27005	Perche, rôtie/cuite au four	22.1	\N	3.42	119
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27006	Truite, rôtie/cuite au four	26.6	\N	8.47	183
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27007	Truite, cuite à la vapeur	19	\N	2.6	99.4
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27014	Truite arc en ciel, élevage, rôtie/cuite au four	21.5	\N	6.33	143
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27015	Truite arc en ciel, élevage, cuite à la vapeur	20	\N	4.14	117
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27018	Panga, Pangasius, ou poisson-chat du Mékong, filet, cuit	17.5	\N	1	79
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27029	Truite d élevage, fumée	23.4	0.69	9.27	180
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27030	Bar commun ou loup, rôti/cuit au four	22.2	\N	6.51	147
4	405	0	viandes, œufs, poissons et assimilés	poissons cuits	-	27031	Dorade (Daurade) royale, cuite au four	23.6	\N	5.9	148
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26001	Bar rayé ou bar d Amérique, cru	20.3	\N	3.58	113
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26006	Lieu ou colin d Alaska, cru	16.3	\N	0.61	70.8
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26009	Flétan de l Atlantique ou flétan blanc, cru	21.2	\N	1.31	96.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26011	Hareng, cru	17.7	\N	11.7	176
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26018	Lotte ou baudroie, crue	15.1	\N	0.74	67.2
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26036	Saumon, cru, élevage	20.5	\N	12.4	194
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26042	Turbot sauvage, cru	17.2	\N	2.54	91.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26043	Cabillaud, cru	18.1	\N	0.57	77.6
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26044	Merlu, cru	17.6	\N	1.35	82.6
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26047	Lieu noir, surgelé, cru	19.8	\N	0.37	82.4
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26048	Merlu, filet, surgelé, cru	15.1	\N	2.4	82
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26051	Maquereau, cru	18.1	\N	13.5	194
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26052	Raie, crue	21.4	\N	0.47	89.9
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26053	Thon, cru	24	\N	5.38	144
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26055	Carrelet ou plie, cru	20	\N	0.94	88.6
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26057	Limande, crue	18.3	\N	0.85	80.8
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26058	Sole, crue	18	\N	0.6	77.3
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26063	Rascasse, crue	18.9	\N	1.33	87.6
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26064	Thon albacore ou thon jaune, cru	25	\N	0.94	108
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26065	Sardine, crue	19.5	\N	9.48	163
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26068	Thon listao ou Bonite à ventre rayé, cru	22	\N	1.01	97.1
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26069	Thon rouge, cru	23.3	\N	6.81	155
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26072	Bar commun ou loup, cru, sans précision	19.1	\N	0.7	82.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26074	Roussette ou petite roussette ou saumonette, crue	23.3	\N	0.5	97.8
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26075	Bar ou loup de l Atlantique, cru	16.6	\N	2.61	89.9
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26076	Thon germon ou thon blanc, cru	27.2	\N	1.37	121
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26079	Anchois commun, cru	18.6	\N	6.07	129
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26208	Baudroie rousse ou Lotte, crue	16.7	\N	0.37	70.2
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26080	Dorade royale, ou daurade ou vraie daurade, crue, sauvage	18.1	\N	2.31	93.2
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26082	Espadon, cru	18.9	\N	5.97	130
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26083	Éperlan, cru	17.5	\N	1.7	85.4
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26084	Cardine franche, crue	19.9	\N	1.53	93.4
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26085	Rouget-barbet de roche, cru	18.4	\N	9.37	158
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26088	Dorade royale ou daurade ou vraie daurade, crue, élevage	20.9	\N	5.1	129
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26091	Mulet, cru	20.1	\N	3.62	113
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26092	Truite de mer, crue	19.6	\N	3.63	111
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26095	Merlan, cru	18.8	\N	0.47	79.3
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26098	Morue, salée, sèche	47.6	\N	1.67	206
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26099	Dorade grise, ou daurade grise, ou griset, crue	20.5	\N	5.27	130
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26100	Bogue, crue	17.9	\N	2.03	90
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26101	Bonite, crue	22.3	\N	8.01	161
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26102	Maquereau espagnol ou maquereau blanc ou billard, cru	22.1	\N	5.15	135
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26103	Denté, cru	17	\N	3.5	99.3
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26104	Saint-Pierre, cru	19.9	\N	0.8	86.7
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26106	Grondin, cru	19	\N	2	94
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26107	Corb, cru	20	\N	0.8	87.2
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26108	Capelan, cru	18.7	\N	1.71	90
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26109	Dorade rose, ou daurade rose, crue	21	\N	2	102
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26110	Rouget-barbet de roche, vapeur	24.1	\N	5.2	143
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26111	Saupe, crue	18	\N	2.5	94.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26113	Chinchard, cru	19	\N	4.42	116
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26122	Églefin, cru	17.3	\N	0.35	72.3
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26127	Congre, cru	18.3	\N	4.6	115
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26128	Grenadier (de roche), cru	15.4	\N	0.81	68.9
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26129	Lieu jaune ou colin, cru	17.7	\N	0.51	75.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26130	Julienne ou Lingue, crue	19.2	\N	0.44	80.8
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26133	Tacaud, cru	19.7	\N	0.33	81.6
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26134	Lieu noir, cru	18.8	\N	0.8	82.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26135	Limande-sole, crue	17	\N	1.4	80.6
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26141	Foie de morue, cru	5	\N	66.6	619
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26146	Vivaneau, cru	20.5	\N	1.34	94.1
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26153	Sabre, cru	18	\N	5.9	125
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26154	Flétan du Groënland ou flétan noir ou flétan commun, cru	13.5	\N	12.7	168
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26157	Carangue, cru	19.9	\N	2.7	104
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26159	Coulirou, cru	17.5	\N	0.1	70.9
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26161	Saumon, cru, sauvage	21	\N	9.17	166
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26162	Requin, cru	20.8	\N	2.91	109
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26166	Orphie commune, crue	20	\N	5.91	133
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26168	Lompe, crue	10	\N	14.2	168
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26170	Brème, cru	16.9	\N	4	104
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26171	Omble chevalier, cru	19.8	\N	2.7	103
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26172	Loup tacheté, cru	16.3	\N	4.8	108
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26173	Sprat, cru	19.8	\N	11.9	186
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26174	Turbot, cru	17.9	\N	1.55	85.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26175	Corégone lavaret, cru	20.5	\N	3.72	115
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26178	Mérou, cru	18.6	\N	0.86	82.3
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26194	Lingue bleue ou Lingue, crue	18.9	\N	0.44	79.6
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26200	Sole tropicale ou Sole langue, crue	15.7	\N	0.58	68.2
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26201	Turbot d élevage, cru	18.3	\N	3.94	109
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26205	Bar commun ou loup (Méditerranée), cru, sauvage	20.1	\N	1.94	97.9
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26206	Bar commun ou loup (Méditerranée), cru, élevage	21.4	\N	4.25	124
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26210	Sébaste du nord, ou grand sébaste, ou dorade sébaste, ou daurade sébaste, crue	18.8	\N	1.6	89.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26213	Hoki, tout lieu de pêche, cru	17.8	\N	2.36	92.3
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26214	Grenadier bleu ou hoki de Nouvelle-Zélande, cru	15.6	\N	1.46	75.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26219	Grondin perlon, cru	20.3	\N	1.79	97.4
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26233	Merlu blanc du Cap, surgelé, cru	16.1	\N	1.52	78
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26235	Chinchard maigre, cru	18.7	\N	2.42	96.7
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26236	Chinchard gras, cru	19.6	\N	7.66	147
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26237	Hareng maigre, cru	18.3	\N	4.22	111
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26238	Hareng gras, cru	18.7	\N	10.8	172
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26240	Joëls (petits poissons entiers) pour friture, crus	17.5	\N	2.1	88.9
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26241	Empereur, filet, sans peau, cru	15	\N	1.5	73.5
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	26244	Rouget-barbet, filet avec peau, surgelé, cru (Thaïlande, Sénégal…)	16.3	\N	3.5	96.7
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27003	Carpe, crue, élevage	17.7	\N	4.76	114
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27008	Truite d élevage, crue	19.3	\N	6.22	133
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27009	Truite arc en ciel, crue, élevage	19	\N	6.24	132
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27010	Perche, crue	17.9	\N	1.19	82.2
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27011	Brochet, cru	18.8	\N	0.94	83.7
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27012	Esturgeon, cru	17.7	\N	5.84	123
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27016	Anguille, crue	16.1	\N	18.6	232
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27017	Pangasius ou Poisson-chat, cru	13.5	\N	1.27	65.2
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27019	Tilapia, cru	18.1	\N	2.13	91.6
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27021	Truite saumonée, crue	19.2	\N	7.4	143
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27023	Lotte de rivière, crue	17.8	\N	0.66	77
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27024	Sandre, cru	18.3	\N	1.08	82.9
4	406	0	viandes, œufs, poissons et assimilés	poissons crus	-	27025	Perche du Nil, crue	19.1	\N	0.68	82.4
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10000	Bigorneau, cuit	16.3	\N	3.5	\N
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10004	Coquille Saint-Jacques, noix et corail, cuite	20.2	3.22	1.77	110
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10006	Crevette grise, cuite	18.3	1.47	1.2	89.9
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10007	Crevette, cuite	19	1.87	1.16	93.8
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10009	Homard, bouilli/cuit à l eau	19.6	0.11	1.32	90.9
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10013	Moule, bouillie/cuite à l eau	17.2	5.12	2.09	108
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10020	Bulot ou Buccin, cuit	20.7	2.69	0.47	97.7
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10022	Langouste, bouillie/cuite à l eau	21.8	1.3	1.52	106
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10025	Crabe ou Tourteau, bouilli/cuit à l eau	19.5	1.79	4.29	124
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10027	Clam, Praire ou Palourde, bouilli/cuit à l eau	16.2	5.33	1.48	99.2
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10031	Écrevisse, cuite	16.3	0.56	0.7	73.5
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10033	Crevette rose bouquet, cuite	22.8	\N	1.27	\N
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10037	Calmar ou calamar ou encornet, bouilli/cuit à l eau	32.5	1.64	1.4	149
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10043	Fruits de mer (aliment moyen)	18.9	3.06	1.76	104
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10044	Langoustine, bouillie/cuite à l eau	20.9	\N	0.98	\N
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10057	Araignée de mer, cuite	18.3	\N	3.8	\N
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10061	Crevette pattes blanches, cuite	22.6	\N	0.96	\N
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10062	Crevette géante tigrée, cuite	23.4	\N	0.98	\N
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10064	Crevette royale rose, cuite	26.6	\N	1.18	\N
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10079	Poulpe, cuit	29.8	4.4	2.08	156
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10080	Fruits de mer, cuits, surgelés	13.5	2.83	1.57	79.5
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10084	Calmar ou calamar ou encornet, frit ou poêlé avec matière grasse	17.9	8.45	7.48	173
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	10099	Escargot, sans matière grasse ajoutée, cuit	16.6	0.23	1.4	80
4	407	0	viandes, œufs, poissons et assimilés	mollusques et crustacés cuits	-	34501	Grenouille, cuisse, grillée/poêlée	21.9	\N	0.9	\N
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10001	Calmar ou calamar ou encornet, cru	14.4	2.17	1.19	77
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10003	Coquille Saint-Jacques, noix et corail, crue	17	0.78	1.31	83
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10008	Escargot, cru	16.1	1.29	0.92	77.9
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10010	Homard, cru	17.9	0.94	1.15	85.5
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10011	Huître, sans précision, crue	8.64	3.86	1.91	67.2
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10014	Moule commune, crue	11.2	2.69	1.82	71.8
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10015	Langouste, crue	17.7	1.07	1.34	86.9
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10016	Seiche, crue	16.2	0.51	1.05	76.3
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10017	Clam, Praire ou Palourde, cru	11.5	2.66	2.65	80.5
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10018	Poulpe, cru	12.9	0.97	0.5	60.1
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10019	Bulot ou Buccin, cru	23.8	7.61	0.57	131
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10021	Crevette, crue	19.7	3.21	0.84	99
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10024	Langoustine, crue	19.1	1.53	0.79	89.8
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10026	Moule de Méditerranée, crue	10.7	2.77	1.67	68.7
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10030	Écrevisse, crue	14.8	0.81	0.64	68.3
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10035	Huître creuse, crue	8.64	3.86	1.91	67.2
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10036	Huître plate, crue	10.2	1.16	0.9	53.5
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10038	Crevette, surgelée, crue	23.4	0.74	0.9	105
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10039	Crabe, cru	19.5	0.027	2.86	104
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10041	Ormeau, cru	14.4	8.69	0.83	99.6
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10045	Coquille Saint-Jacques, noix, crue	17.9	1.15	0.84	83.6
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10048	Pecten d Amérique ou Peigne du canada, noix, crue	17.3	1.78	0.54	81.3
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10049	Pétoncle ou Peigne du Pérou, noix, crue	17.5	3.1	0.7	88.7
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	10059	Crevette rose, crue	21.9	0	0.53	92.3
4	408	0	viandes, œufs, poissons et assimilés	mollusques et crustacés crus	-	34500	Grenouille, cuisse, crue	16.2	0.66	0.28	70
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	8059	Rillettes de crabe, préemballées	12.2	3.5	13.6	192
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	8080	Rillettes de poisson, préemballées	13.9	0.3	20.7	243
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	8081	Rillettes de saumon, préemballées	15.1	2	18.4	237
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	8082	Rillettes de thon, préemballées	16.4	1.65	13.8	199
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	8083	Rillettes de maquereau, préemballées	11	1	22	246
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	8291	Terrine de poisson, préemballée	11	5.5	11.4	171
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	8292	Terrine de fruits de mer, avec ou sans poisson, préemballée	8.4	6.5	14	188
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	8293	Tarama, préemballé	6.75	3.19	54.8	534
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	10002	Calmar ou Calamar ou encornet, à la romaine (beignet)	8.69	21.2	14.4	252
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	10005	Crabe, miettes et ou pattes décortiquées, appertisé, égoutté	14.8	8.72	1.8	111
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	10012	Langoustine, panée, frite	10.9	29	13.6	282
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	10023	Beignet de crevette	6.5	26	10	222
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	10028	Moule, appertisée, égouttée	14.6	5.93	2.2	102
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	10042	Escargot en sauce au beurre persillé, préemballé, cuit	12.9	2.26	23.7	277
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	10081	Moules à la sauce catalane ou escabèche (tomate), appertisée, égouttée	12.5	5	7.9	145
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	25433	Accra de poisson	12.4	15.1	17.6	275
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	25537	Carpaccio de saumon avec marinade	19.8	0.22	12.7	194
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	25995	Maquereau, filet grillé, appertisé, nature, égoutté	19.7	0.55	18.3	246
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	25999	Anchois, filets roulés aux câpres, semi-conserve, égoutté	24.8	1.48	10.3	198
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26000	Anchois, filets à l huile, semi-conserve, égoutté	26.4	0.2	8.45	182
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26002	Carrelet ou plie, pané, frit	13.4	8.86	16.8	242
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26004	Oeufs de lompe, semi-conserve	10.4	1	7.27	111
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26005	Caviar, semi-conserve	25	\N	17.1	254
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26010	Hareng mariné ou rollmops	13.7	8	13.8	211
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26016	Limande-sole, panée, frite	16.7	11.9	10.2	206
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26027	Pilchard, sauce tomate, appertisé, égoutté	13	3.99	11	167
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26028	Poisson, croquette ou beignet ou nuggets, frit	13.2	18.4	13.7	255
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26029	Poisson pané, surgelé, cru	11	16.1	5.73	162
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26030	Poisson pané, frit	11.9	13.4	10	193
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26034	Sardine, à l huile, appertisée, égouttée	24.4	0.49	12	207
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26035	Sardine, sauce tomate, appertisée, égouttée	20.2	1.38	11.6	193
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26039	Thon, au naturel, appertisé, égoutté	26.8	0	0.4	111
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26040	Sardine, à l huile d olive, appertisée, égouttée	24.3	1.06	11.2	202
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26046	Surimi, bâtonnets, tranche ou râpé saveur crabe	8.31	11.8	4.92	125
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26056	Oeufs de cabillaud, fumés, semi-conserve	26.9	0.1	4.2	146
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26077	Thon germon ou thon blanc, cuit à la vapeur sous pression	30	0	5.06	165
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26086	Maquereau, filet sauce tomate, appertisé, égoutté	17.7	1.94	16.3	227
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26096	Maquereau, filet sauce moutarde, appertisé, égoutté	20.8	1.09	14.2	217
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26097	Maquereau, filet au vin blanc, appertisé, égoutté	17.8	2.25	14.1	207
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26119	Saumon, appertisé, égoutté	20.5	1.5	10.2	180
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26123	Maquereau, au naturel, appertisé, égoutté	21.6	0	11.4	189
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26124	Merlan, pané	12.6	13	9.57	190
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26142	Foie de morue, appertisé, égoutté	7.25	1.1	44.4	433
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26151	Oeufs de truite, semi-conserve	26.3	\N	9.5	\N
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26177	Anchois au sel (anchoité, semi-conserve)	25	0	3.1	128
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26179	Thon germon ou thon blanc, à l huile d olive, appertisé, égoutté	31.3	1.01	6.95	192
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26180	Thon à l huile de tournesol, entier, appertisé, égoutté	23.3	0.76	12.2	206
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26181	Thon albacore ou thon jaune, au naturel, appertisé, égoutté	26.6	0.58	1.98	128
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26186	Maquereau, mariné	16.3	\N	13.3	185
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26187	Anchois commun, mariné, préemballé	23.9	2.7	3.26	136
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26231	Sardine, filets sans arêtes à l huile d olive, appertisés, égouttés	21.5	0.62	13.9	213
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26239	Surimi, fourré au fromage	6.6	9.24	9.3	149
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26242	Thon à la tomate, miettes, appertisées, égouttées	14.6	4.33	5.93	130
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26243	Thon, à la catalane ou à l escabèche (sauce tomate), appertisé	10.8	5.05	8.6	142
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26245	Thon à l huile de tournesol, miettes, appertisées, égouttées	23.4	0	14.8	227
4	409	0	viandes, œufs, poissons et assimilés	produits à base de poissons et produits de la mer	-	26275	Oeufs de saumon, semi-conserve	30.8	1.5	10.5	224
4	410	41001	viandes, œufs, poissons et assimilés	œufs	œufs cuits	22008	Oeuf, blanc (blanc d oeuf), cuit	10.3	1.12	0.17	47.3
4	410	41001	viandes, œufs, poissons et assimilés	œufs	œufs cuits	22009	Oeuf, jaune (jaune d oeuf), cuit	16	1.31	30.1	340
4	410	41001	viandes, œufs, poissons et assimilés	œufs	œufs cuits	22010	Oeuf, dur	13.5	0.52	8.62	134
4	410	41001	viandes, œufs, poissons et assimilés	œufs	œufs cuits	22011	Oeuf, poché	12.5	0.71	9.47	138
4	410	41001	viandes, œufs, poissons et assimilés	œufs	œufs cuits	22014	Oeuf, à la coque	12.2	1.08	9.82	142
4	410	41001	viandes, œufs, poissons et assimilés	œufs	œufs cuits	22501	Oeuf, au plat, frit, salé	14.3	0.74	16	204
4	410	41001	viandes, œufs, poissons et assimilés	œufs	œufs cuits	22502	Oeuf, brouillé, avec matière grasse	9.99	1.62	11	145
4	410	41001	viandes, œufs, poissons et assimilés	œufs	œufs cuits	22505	Oeuf, au plat, sans matière grasse	13.8	1.01	9.72	147
4	410	41002	viandes, œufs, poissons et assimilés	œufs	œufs crus	22000	Oeuf, cru	12.7	0.27	9.83	140
4	410	41002	viandes, œufs, poissons et assimilés	œufs	œufs crus	22001	Oeuf, blanc (blanc d oeuf), cru	10.8	0.85	0.19	48.1
4	410	41002	viandes, œufs, poissons et assimilés	œufs	œufs crus	22002	Oeuf, jaune (jaune d oeuf), cru	15.5	1.09	26.7	307
4	410	41002	viandes, œufs, poissons et assimilés	œufs	œufs crus	22050	Oeuf de caille, cru	13.1	0.41	11.1	154
4	410	41002	viandes, œufs, poissons et assimilés	œufs	œufs crus	22060	Oeuf de cane, cru	13	1.31	13.8	181
4	410	41002	viandes, œufs, poissons et assimilés	œufs	œufs crus	22070	Oeuf d oie, cru	13.8	1.4	13.3	180
4	410	41002	viandes, œufs, poissons et assimilés	œufs	œufs crus	22080	Oeuf de dinde, cru	13.7	1.13	11.9	166
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22003	Oeuf, jaune (jaune d oeuf), en poudre	34.1	2.77	57	660
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22004	Oeuf, blanc (blanc d oeuf), en poudre	81.2	7.73	0	356
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22013	Oeuf, en poudre	47.9	3.11	42	582
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22506	Omelette au fromage	17.7	2.56	19.3	255
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22507	Omelette aux lardons	12.5	1.46	23.5	267
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22508	Omelette aux champignons	8.09	2.28	9.2	125
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22509	Omelette aux fines herbes	9.5	1.98	11.2	147
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22510	Tortilla espagnole aux oignons (omelette aux pommes de terre et oignons), préemballée	5.56	11.7	9.9	165
4	410	41003	viandes, œufs, poissons et assimilés	œufs	omelettes et autres ovoproduits	22511	Omelette, garnitures diverses : légumes, fromages, viandes... (aliment moyen)	9.82	5.07	13.5	184
4	411	0	viandes, œufs, poissons et assimilés	substitus de produits carnés	-	20591	Protéine de soja texturée, réhydratée	20.4	7.03	2.9	150
4	411	0	viandes, œufs, poissons et assimilés	substitus de produits carnés	-	20904	Tofu nature, préemballé	14.7	2.87	8.5	148
4	411	0	viandes, œufs, poissons et assimilés	substitus de produits carnés	-	20912	Tofu fumé, préemballé	16.4	2.91	9.5	164
4	411	0	viandes, œufs, poissons et assimilés	substitus de produits carnés	-	25223	Bouchées ou émincé végétal au soja et blé (convient aux véganes ou végétaliens), préemballé	21.3	6.76	3.7	157
4	411	0	viandes, œufs, poissons et assimilés	substitus de produits carnés	-	25224	Bouchées ou émincé au soja et blé  (ne convient pas aux véganes ou végétaliens), préemballé	19.3	8.19	7	185
4	411	0	viandes, œufs, poissons et assimilés	substitus de produits carnés	-	25598	Seitan, préemballé	20.6	6.74	2.5	134
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19023	Lait entier, UHT	3.25	4.85	3.63	65.1
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19024	Lait entier, pasteurisé	3.23	3.47	3.3	56.5
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19037	Lait demi-écrémé, UHT, enrichi en vitamine D seulement	3.31	4.8	1.52	46.6
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19038	Lait à 1,2% de matière grasse, UHT, enrichi en plusieurs vitamines	3.31	4.79	1.25	44.1
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19039	Lait, teneur en matière grasse inconnue, UHT (aliment moyen)	3.32	4.82	1.59	47.3
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19041	Lait demi-écrémé, UHT	3.31	4.83	1.55	47
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19042	Lait demi-écrémé, pasteurisé	3.13	4.9	1.54	46.4
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19050	Lait écrémé, UHT	3.44	4.64	0.06	33.4
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19051	Lait écrémé, pasteurisé	3.21	4.99	0.19	34.5
5	501	50101	produits laitiers et assimilés	laits	laits de vaches liquides (non concentrés)	19060	Lait demi-écrémé (ou à teneur en matière grasse légèrement inférieure) à teneur réduite en lactose	3.38	4.69	1.29	44.4
5	501	50102	produits laitiers et assimilés	laits	laits autres que de vache	19200	Lait de chèvre, entier, UHT	3.33	4.35	2.83	56.1
5	501	50102	produits laitiers et assimilés	laits	laits autres que de vache	19201	Lait de chèvre, demi-écrémé, UHT	3.69	4.13	1.57	45.8
5	501	50102	produits laitiers et assimilés	laits	laits autres que de vache	19202	Lait de chèvre, entier, cru	3.15	4.01	3.2	57.4
5	501	50102	produits laitiers et assimilés	laits	laits autres que de vache	19225	Lait de jument, entier	2.36	6.18	1.73	50
5	501	50102	produits laitiers et assimilés	laits	laits autres que de vache	19250	Lait de brebis, entier	5.56	4.5	6.97	103
5	501	50103	produits laitiers et assimilés	laits	laits de vache concentrés ou en poudre	19021	Lait en poudre, entier	26.9	37.5	26.8	499
5	501	50103	produits laitiers et assimilés	laits	laits de vache concentrés ou en poudre	19026	Lait concentré non sucré, entier	6.31	9.91	5.9	122
5	501	50103	produits laitiers et assimilés	laits	laits de vache concentrés ou en poudre	19027	Lait concentré sucré, entier	7.54	55.6	7.87	323
5	501	50103	produits laitiers et assimilés	laits	laits de vache concentrés ou en poudre	19044	Lait en poudre, demi-écrémé	30.8	43.4	17.5	459
5	501	50103	produits laitiers et assimilés	laits	laits de vache concentrés ou en poudre	19054	Lait en poudre, écrémé	34.6	54	0.7	361
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19500	Boisson lactée, lait fermenté ou yaourt à boire, aromatisé, avec édulcorants, allégé en sucres, 0% MG, au L Casei	2.84	3.64	0.1	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19508	Boisson lactée, lait fermenté ou yaourt à boire, aromatisé, sucré	2.92	11.6	1.4	73.7
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19516	Boisson lactée, lait fermenté ou yaourt à boire, aromatisé, sucré, au L Casei	2.75	12.7	1.52	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19534	Boisson lactée, lait fermenté ou yaourt à boire, aromatisé, sucré, enrichi en vitamine D	3.02	12.6	1.2	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19535	Boisson lactée, lait fermenté ou yaourt à boire, aux fruits, sucré	3.03	13.1	1.69	82.8
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19536	Boisson lactée, lait fermenté ou yaourt à boire, aux fruits, sucré, enrichie en vitamine D	2.97	13.9	1.5	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19538	Boisson lactée, lait fermenté ou yaourt à boire, nature, sucré, au L Casei	2.7	12.9	1.6	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19539	Lait fermenté ou spécialité laitière type yaourt, aromatisé, sucré, au bifidus	3.75	11.5	3.1	94.4
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19541	Lait fermenté ou spécialité laitière type yaourt, aux fruits, avec édulcorants, 0% MG, au bifidus	4.58	6.71	0.094	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19542	Lait fermenté ou spécialité laitière type yaourt, aux fruits, sucré, au bifidus	3.5	13	3.01	97.2
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19543	Lait fermenté ou spécialité laitière type yaourt, aux fruits, 0% MG, avec édulcorants, aux esters de stérol	3.8	6.6	0.5	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19544	Lait fermenté ou spécialité laitière type yaourt, nature, 0% MG, au bifidus	4.3	5.75	0.3	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19546	Lait fermenté ou spécialité laitière type yaourt, nature, au bifidus	3.77	3.47	3.6	64.5
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19548	Lait fermenté ou spécialité laitière type yaourt, sur lit de fruits, sucré, au bifidus	3.73	13.3	2.72	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19550	Yaourt à la grecque, au lait de brebis	3.76	4.99	3.4	69.1
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19552	Yaourt à la grecque, sur lit de fruits	2.27	16.3	6.3	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19553	Yaourt au lait de brebis, aromatisé, sucré	4.94	9.33	3.7	93.7
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19554	Yaourt au lait de brebis, nature, 3% MG environ	5.6	4.6	3	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19556	Yaourt au lait de chèvre, nature, 5% MG environ	4.06	1.12	5.2	73.4
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19557	Yaourt, lait fermenté ou spécialité laitière sur lit de fruits, sucré	2.89	15.2	3.91	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19558	Yaourt, lait fermenté ou spécialité laitière, aux céréales, 0% MG	4.53	8.25	1.08	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19559	Yaourt, lait fermenté ou spécialité laitière, aromatisé, avec édulcorants, 0% MG	4.44	8.29	0.06	54.5
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19575	Yaourt, lait fermenté ou spécialité laitière, aromatisé, sucré	3.35	12.2	2.6	89.1
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19577	Yaourt, lait fermenté ou spécialité laitière, aromatisé, sucré, à la crème	3.02	13.4	5.45	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19578	Yaourt, lait fermenté ou spécialité laitière, aromatisé, sucré, enrichi en vitamine D	3.36	13.6	1.79	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19579	Yaourt, lait fermenté ou spécialité laitière, aux céréales	3.57	11.3	3.43	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19580	Yaourt, lait fermenté ou spécialité laitière, aux copeaux de chocolat, à la crème, sucré	3.44	14.1	5.1	122
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19581	Yaourt, lait fermenté ou spécialité laitière, aux fruits, avec édulcorants, 0% MG	4.13	3.72	0.3	38.9
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19582	Yaourt, lait fermenté ou spécialité laitière, aux fruits, avec édulcorants, 0% MG, enrichi en vitamine D	4.45	7.45	0.097	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19587	Yaourt, lait fermenté ou spécialité laitière, aux fruits, sucré	3.54	14.2	2.4	95.7
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19589	Yaourt, lait fermenté ou spécialité laitière, aux fruits, sucré, à la crème	2.38	14.5	4.28	109
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19592	Yaourt, lait fermenté ou spécialité laitière, aux fruits, sucré, enrichi en vitamine D	3.44	14	2.35	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19593	Yaourt, lait fermenté ou spécialité laitière, nature	3.88	2.65	1.5	45.5
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19594	Yaourt, lait fermenté ou spécialité laitière, nature, 0% MG	4.73	4.1	0.064	39.4
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19596	Yaourt, lait fermenté ou spécialité laitière, nature, 0% MG, enrichi en vitamine D	4.5	5	0	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19597	Yaourt, lait fermenté ou spécialité laitière, nature, 0% MG, sucré, enrichi en vitamine D	4.33	5.4	1.17	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19598	Yaourt, lait fermenté ou spécialité laitière, nature, à la crème	3	3.08	9.8	115
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19599	Yaourt, lait fermenté ou spécialité laitière, nature, sucré	3.41	12.5	1.95	84.3
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19600	Yaourt ou spécialité laitière nature (aliment moyen)	3.8	4.73	2.3	56.8
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19624	Yaourt ou spécialité laitière nature ou aux fruits (aliment moyen)	3.57	7.47	2.5	69.4
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19628	Yaourt ou spécialité laitière aux fruits (aliment moyen)	3.14	12.8	2.89	93.1
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19669	Spécialité laitière type encas, riche en protéines, sur lit de fruits, sucrée	7.31	11.5	2.29	98.3
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19671	Yaourt, lait fermenté ou spécialité laitière, aromatisé ou aux fruits, 0% MG (aliment moyen)	4.2	4.92	0.13	42.4
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19672	Yaourt, lait fermenté ou spécialité laitière, aromatisé ou aux fruits, non allégé en MG (aliment moyen)	3.17	12.9	2.81	93.2
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19675	Yaourt, lait fermenté ou spécialité laitière, aromatisé ou aux fruits, avec édulcorants (aliment moyen)	4.2	4.92	0.13	42.4
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19676	Yaourt, lait fermenté ou spécialité laitière, aromatisé ou aux fruits, sucré (aliment moyen)	3.18	13	2.83	93.3
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19677	Yaourt, lait fermenté ou spécialité laitière, aromatisé ou aux fruits, sucré, non allégé en MG (aliment moyen)	3.18	13	2.83	93.2
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19682	Yaourt, lait fermenté ou spécialité laitière, aromatisé ou aux fruits (aliment moyen)	3.25	12.4	2.63	89.3
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19801	Lait fermenté à boire, nature, maigre	3.44	2.18	0.6	33.6
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19805	Lait fermenté à boire, nature, au lait entier	3.31	1.99	3.2	55.7
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19860	Yaourt à la grecque, nature	3.25	4.21	9.22	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19862	Yaourt à la grecque, aromatisé, sucré	4.2	12.8	8.2	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19865	Kéfir de lait	3.13	4.5	3.5	\N
5	502	50201	produits laitiers et assimilés	produits laitiers frais et assimilés	yaourts et spécialités laitières type yaourt	19882	Yaourt au lait de brebis, nature, 6% MG environ	5.04	4.56	6.08	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19501	Fromage blanc nature ou aux fruits (aliment moyen)	6.95	5.68	4.31	87.7
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19572	Fromage frais type petit suisse, aromatisé chocolat, sucré	3.87	20.9	5.18	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19638	Faisselle au coulis de fruits	3.5	8.5	5	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19639	Faisselle, 0% MG	4.38	4.44	0	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19641	Faisselle, 6% MG environ	4.38	3.57	5.5	84.2
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19643	Fromage blanc et crème fouettée sur lit de fruits, sucré	4.5	16	7	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19644	Fromage blanc nature, 0% MG	7.78	3.89	0.044	49.4
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19645	Fromage blanc nature, 0% MG, enrichi en vitamine D	7.4	5	0.1	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19646	Fromage blanc nature, 3% MG environ	7.86	3.46	3.26	76.9
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19647	Fromage blanc nature, 3% MG environ, au bifidus	7.04	3.94	3.28	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19648	Fromage blanc nature, 3% MG environ, enrichi en vitamine D	6.9	5.4	3.2	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19649	Fromage blanc nature, gourmand, 8% MG environ	6.07	5.25	7.65	116
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19650	Fromage blanc ou spécialité laitière nature et crème fouetté, 10% MG environ	6.75	3.74	10.2	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19651	Fromage blanc ou spécialité laitière, aromatisé, sucré, 0% MG	6.98	12.5	0.025	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19652	Fromage blanc ou spécialité laitière, aromatisé, sucré, 3% MG environ	6.26	13.1	2.65	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19653	Fromage blanc ou spécialité laitière, aromatisé, sucré, 3% MG environ, au bifidus	5.47	14	3.2	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19654	Fromage blanc ou spécialité laitière, aux copeaux de chocolat, sucré, 7% MG environ	5.23	16.2	5.97	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19655	Fromage blanc ou spécialité laitière, aux fruits, avec édulcorants, allégé en sucres, 0% MG	6.11	6.76	0.12	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19656	Fromage blanc ou spécialité laitière, aux fruits, sucré, 0% MG	7.77	13.5	\N	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19657	Fromage blanc ou spécialité laitière, aux fruits, sucré, 3% MG environ	5.13	14.7	3.31	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19658	Fromage blanc ou spécialité laitière, aux fruits, sucré, 3% MG environ, au bifidus	5.25	13.5	2.98	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19659	Fromage blanc ou spécialité laitière, aux fruits, sucré, gourmand, 7% MG environ	5.08	13.4	5.53	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19661	Fromage frais type petit suisse, aux fruits, 2-3% MG	6.56	9.34	2.8	92.7
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19662	Fromage frais type petit suisse, aux fruits, 2-3% MG, enrichi en calcium et vitamine D	6.29	12.2	2.63	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19663	Fromage frais type petit suisse, nature, 0% MG	9.69	3.8	0.24	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19664	Fromage frais type petit suisse, nature, 4% MG environ	9.75	2.84	4	88.8
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19665	Mousse de fromage blanc sur lit de fruits, 0% MG, avec édulcorants, enrichie en calcium et vitamine D	6.35	6	0.45	\N
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19666	Fromage frais type petit suisse, nature, 10% MG environ	9.5	3.17	10.4	149
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19667	Fromage frais type petit suisse, aromatisé ou aux fruits, 2-3% MG, enrichi en calcium et vitamine D	5.63	10.2	2.5	90.4
5	502	50202	produits laitiers et assimilés	produits laitiers frais et assimilés	fromages blancs	19668	Fromage blanc ou spécialité laitière, aux fruits, avec édulcorants, allégé en sucres, 3% MG environ	3.1	12.2	2.5	\N
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	19673	Crème dessert, allégée en MG, rayon frais	3.56	12.4	1.3	79.2
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	19674	Flan aux oeufs, rayon frais	4	18.5	2.2	111
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	19678	Lait emprésuré aromatisé, rayon frais	5.52	17.6	2.5	\N
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	19679	Lait gélifié aromatisé, nappé caramel, rayon frais	2.5	16.7	1.3	91.9
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	19680	Lait gélifié aromatisé, rayon frais	3.32	19.5	3.53	\N
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	19681	Liégeois ou viennois (chocolat, café, caramel ou vanille), rayon frais	2.94	18.8	5.78	\N
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	19683	Lait gélifié aromatisé, allégé en matière grasse et en sucre, rayon frais	4.08	11.8	1.08	\N
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	19685	Panna cotta, avec préparations de fruits ou caramel, rayon frais	2.69	14.9	13	198
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	23534	Gâteau de semoule aux raisins et caramel, rayon frais	3.81	24.8	3.4	146
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	23536	Gâteau de riz au caramel, rayon frais	3.19	25.4	3.1	143
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39001	Milk-shake, provenant de fast food	3.32	17.4	4.66	126
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39200	Crème dessert au chocolat, rayon frais	3.32	19.9	3.93	130
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39206	Mousse au chocolat (base laitière), rayon frais	5.31	21.3	4.4	150
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39209	Crème caramel, rayon frais	4.35	20.6	3.6	132
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39211	Crème aux oeufs (petit pot de crème chocolat, vanille, etc.), rayon frais	4.23	19.4	8.88	176
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39212	Riz au lait, rayon frais	3.27	21.4	3.01	126
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39213	Crème brûlée, rayon frais	4.37	16.6	20.8	272
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39214	Crème dessert à la vanille, appertisée	3.63	21.1	3.62	132
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39215	Ile flottante, rayon frais	4.87	19.8	3.31	129
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39218	Semoule au lait, rayon frais	3.39	19.4	3.23	121
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39228	Mousse aux fruits, rayon frais	6.13	5.51	0.3	53.1
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39229	Crème dessert à la vanille, rayon frais	3	14.4	3.6	105
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39230	Crème dessert, rayon frais (aliment moyen)	3.35	17.9	5.1	133
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39235	Mousse liégeoise (chocolat, café, caramel ou vanille), rayon frais	3.55	20	10.1	186
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39246	Crème dessert au café, rayon frais	2.87	17.8	3.69	116
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39247	Crème dessert au caramel, rayon frais	2.86	18.6	3.47	117
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39505	Crème dessert, appertisée (aliment moyen)	3.42	21.4	3.52	135
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39506	Crème dessert au chocolat, appertisée	3.18	21.8	3.42	138
5	502	50203	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts lactés	39511	Crème dessert, rayon frais ou appertisée (aliment moyen)	3.35	18	5.07	133
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	19689	Cheesecake ou Gâteau au fromage frais, préemballé	4.57	31.7	20.3	330
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	19698	Tiramisu, préemballé	4.25	30.4	9.8	241
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	19852	Mousse à la crème de marrons, préemballée	2.13	34.4	6.5	207
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	23474	Profiteroles (crème pâtissière et sauce chocolat), préemballées	5.51	34.3	12.2	273
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	23535	Gâteau de semoule, appertisé	2.85	27.4	3.03	150
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39210	Mousse au chocolat traditionnelle, préemballée	6.39	25.6	18.6	303
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39216	Clafoutis aux fruits, préemballé	5.11	27.2	6.51	192
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39220	Liégeois aux fruits, préemballé	1.5	16	8.1	147
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39232	Gâteau de riz, appertisé	4.2	20	1.9	115
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39233	Fondant au chocolat noir et crème anglaise, préemballé	5.05	20	14.3	\N
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39234	Gâteau au chocolat, coeur fondant, préemballé (rayon frais)	6.86	41.9	18.1	364
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39236	Pain perdu	6	29	8.45	218
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39400	Lait de poule, sans alcool	4.46	8.05	4.19	87.8
5	502	50204	produits laitiers et assimilés	produits laitiers frais et assimilés	autres desserts	39710	Crème pâtissière	3.79	18	3.6	120
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	19692	Dessert au soja, aux fruits, sucré, enrichi en calcium, fermenté, préemballé	3	12.9	2.3	86.7
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	19693	Dessert au soja, nature, non sucré, non enrichi, fermenté, préemballé	4.13	2.05	1.9	44.7
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	19694	Dessert au soja, nature, non sucré, enrichi en calcium, fermenté, préemballé	3.94	1.1	2.1	42
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	19695	Dessert au soja, aux fruits, sucré, non enrichi, fermenté, préemballé	3.63	11	1.7	78
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	19696	Dessert au soja, aux amandes, fermenté, préemballé	4	2.85	2.8	56
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	20911	Dessert au soja, aromatisé, sucré, enrichi en calcium, préemballé	3.56	15.3	1.9	95
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	20921	Dessert au soja, aromatisé, sucré, non enrichi, préemballé	3	16	1.7	93.1
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	20922	Dessert végétal sans soja (amande, avoine, chanvre, coco, riz), aromatisé, sucré, non enrichi, préemballé	2	15.8	8	148
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	20923	Dessert végétal sans soja (coco, riz), aux fruits, sucré, enrichi en calcium, fermenté, préemballé	0.5	16	1	76.6
5	502	50205	produits laitiers et assimilés	produits laitiers frais et assimilés	desserts végétaux	39248	Mousse au chocolat végétale, préemballée	6.69	24.3	14	262
5	503	0	produits laitiers et assimilés	fromages et assimilés	-	12999	Fromage (aliment moyen)	21.3	0.56	27.4	338
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12001	Camembert, sans précision	19.1	\N	22.5	280
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12003	Fromage à pâte molle et croûte fleurie (type camembert)	17.1	\N	32.3	359
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12006	Camembert au lait cru	20.3	\N	20.3	267
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12008	Fromage à pâte molle et croûte fleurie double crème environ 30% MG	17.2	\N	29.4	333
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12009	Fromage rond à pâte molle et croûte fleurie 5 à 11% MG type camembert allégé en matière grasse	22.2	\N	9.3	173
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12010	Coulommiers	18.4	\N	22.8	279
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12012	Fromage rond à pâte molle et croûte fleurie environ 11% MG type coulommiers allégé en matière grasse	22	\N	11	187
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12013	Fromage rond à pâte molle et croûte fleurie environ 5% MG type camembert allégé en matière grasse	25.2	\N	5.5	150
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12020	Brie, sans précision	16.9	\N	25.5	297
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12021	Brie de Meaux	21	\N	20.7	271
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12022	Brie de Melun	21.6	\N	22.2	288
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12025	Carré de l Est	21	\N	27	327
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12028	Chaource	17	\N	22.9	276
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12029	Maroilles laitier	21.8	\N	27.8	338
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12030	Maroilles fermier	20.8	\N	29.5	349
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12031	Neufchâtel	18.1	\N	23.9	287
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12033	Fromage à pâte molle triple crème environ 40% MG	9.69	\N	37.5	376
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12034	Fromage à pâte molle et croûte lavée (aliment moyen)	20.2	0	26.5	320
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12035	Fromage à pâte molle et croûte lavée, allégé environ 13% MG	21.2	\N	12.6	198
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12036	Maroilles, sans précision	21.5	\N	26.4	325
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12037	Livarot	24.1	\N	22.6	301
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12038	Époisses	17.4	\N	24.5	290
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12039	Munster	20.7	\N	29	344
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12040	Langres	16.4	\N	23.8	281
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12042	Pont l Évêque	22.2	\N	26.2	326
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12045	Reblochon	19.9	\N	27.4	326
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12047	Fromage à pâte molle à croûte lavée, au lait pasteurisé (type Vieux Pané)	19.9	\N	25.7	311
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12049	Saint-Marcellin	14.8	\N	24.3	280
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12050	Fromage à pâte molle et croûte mixte (lavée et fleurie) colorée	17.8	\N	29	332
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12051	Mont d or ou Vacherin du Haut-Doubs (produit en France) ou Vacherin-Mont d Or (produit en Suisse)	18.5	\N	25.4	302
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12052	Saint-Félicien	13.1	\N	25.2	281
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12064	Boulette d Avesne	20.5	\N	30	355
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12801	Fromage de chèvre lactique affiné, au lait cru (type Crottin de Chavignol, Picodon, Rocamadour, Sainte-Maure de Touraine)	20.3	\N	27	324
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12802	Fromage de chèvre lactique affiné, au lait pasteurisé (type bûchette ou crottin)	19.4	\N	24.7	300
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12803	Fromage de chèvre lactique affiné (type bûchette, crottin, Sainte-Maure)	20	\N	26.2	315
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2030	Jus de citron vert, maison	0.42	1.69	0.07	\N
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12807	Sainte-Maure de Touraine (fromage de chèvre)	19.2	\N	24.2	294
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12810	Fromage de chèvre demi-sec	21.1	\N	29.8	353
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12812	Fromage de chèvre bûche	18.4	\N	23.3	285
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12813	Fromage de chèvre bûche, allégé en matière grasse	22.1	\N	10	179
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12814	Fromage de chèvre à pâte molle non pressée non cuite croûte naturelle, au lait pasteurisé	19	\N	22.6	279
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12815	Fromage de chèvre sec	29.9	\N	35.6	440
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12820	Fromage de chèvre à pâte molle et croûte fleurie type camembert	19.4	\N	23.8	292
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12824	Fromage de brebis à pâte molle et croûte fleurie	16.5	\N	23.3	276
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12830	Chabichou (fromage de chèvre)	20.1	\N	23.8	294
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12831	Pélardon (fromage de chèvre)	23.3	\N	27.8	343
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12832	Crottin de chèvre, au lait cru	22.7	\N	32.6	384
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12833	Crottin de chèvre, sans précision	21.9	\N	28	340
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12834	Crottin de Chavignol (fromage de chèvre)	19.3	\N	24.4	296
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12836	Picodon (fromage de chèvre)	20.3	\N	26	315
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12839	Pouligny Saint-Pierre (fromage de chèvre)	18.5	\N	24.5	294
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12842	Sainte-Maure (fromage de chèvre)	21.7	\N	30	357
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12845	Selles-sur-Cher (fromage de chèvre)	18.9	\N	23.9	291
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12846	Chevrot (fromage de chèvre)	18.1	\N	22.8	277
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12847	Rocamadour (fromage de chèvre)	17.5	\N	22.6	274
5	503	50301	produits laitiers et assimilés	fromages et assimilés	fromages à pâte molle	12848	Valençay (fromage de chèvre)	18.9	\N	25.5	306
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12500	Roquefort	19.1	\N	33.9	384
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12519	Fourme de Montbrison	22.1	\N	30.8	365
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12520	Fromage bleu au lait de vache	19.5	\N	28.3	333
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12521	Fromage bleu d Auvergne	22	\N	28.4	343
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12522	Fourme d Ambert	19.5	\N	27.6	326
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12523	Fromage bleu des Causses	20	\N	30	350
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12524	Gorgonzola	18.6	\N	26.4	312
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12526	Bleu de Gex ou Fromage bleu du Haut-jura ou Bleu de septmoncel (AOC)	22.1	\N	30.7	364
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12527	Fromage bleu de Bresse	17	\N	30.5	342
5	503	50302	produits laitiers et assimilés	fromages et assimilés	fromages à pâte persillée	12528	Fromage bleu de Bresse allegé environ 15% MG	26.5	\N	15.5	246
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12100	Fromage à pâte pressée cuite (aliment moyen)	27.4	0	30.8	390
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12105	Beaufort	26	\N	34	410
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12110	Comté	26.7	\N	34.6	418
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12112	Abondance	26.6	\N	31.6	393
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12113	Gruyère IGP France	26.7	\N	32	396
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12114	Gruyère	27.9	\N	34.6	423
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12115	Emmental ou emmenthal	27.3	\N	28.8	373
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12116	Fromage à pate pressée cuite type emmental ou emmenthal, allégé en matière grasse	30	\N	18	282
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12118	Emmental ou emmenthal râpé	27.5	\N	28.6	367
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12119	Ossau-Iraty	23.8	\N	37	428
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12120	Parmesan	30.5	\N	31	406
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12121	Fontina	25.1	\N	31.1	381
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12122	Pecorino	\N	\N	28.8	\N
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12123	Grana Padano	33.4	\N	29.2	396
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12705	Fromage à pâte ferme environ 14% MG type Masdaam à teneur réduite en MG	28.4	\N	13.8	238
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12716	Provolone	25.1	\N	26.6	340
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12720	Fromage à pâte ferme, enrobé de cire	21.3	\N	23.7	303
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12722	Cantal entre-deux	26.1	\N	30.5	383
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12723	Cantal, Salers ou Laguiole	24.8	\N	31	378
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12725	Salers	25.4	\N	31.4	388
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12726	Cheddar	23.6	\N	33.8	399
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12729	Edam	25	\N	25.5	329
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12735	Mimolette jeune	28.3	\N	24.2	331
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12736	Gouda	22.8	\N	31.5	374
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12737	Mimolette demi-vieille	30.8	\N	26.9	365
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12738	Mimolette vieille	33.3	\N	28.8	397
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12740	Mimolette, sans précision	24.4	\N	23.4	308
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12741	Fromage à pâte ferme environ 27% MG type Maasdam	25	\N	28.4	359
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12742	Mimolette extra-vieille	33.2	\N	28.2	387
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12743	Morbier	22.4	\N	29.2	355
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12747	Fromage de brebis des Pyrénées	23.6	\N	33.6	397
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12748	Saint-Nectaire, laitier	22.3	\N	27	332
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12749	Raclette (fromage)	22.9	\N	27.5	342
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12751	Saint-Nectaire, fermier	21.8	\N	29.8	355
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12752	Saint-Nectaire, sans précision	22	\N	28.4	344
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12755	Saint-Paulin (fromage à pâte pressée non cuite demi-ferme)	21.8	\N	26.4	327
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12758	Tomme ou tome de vache	21.1	\N	29.4	350
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12759	Tomme ou tome de montagne ou de Savoie	25	\N	29.1	364
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12760	Tomme ou tome, allégée en matière grasse, environ 13% MG	30.4	\N	12.1	231
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12761	Asiago	31.4	\N	25.6	356
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12762	Fromage de brebis Corse à pâte molle	27.9	\N	38.4	457
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12763	Tome des Bauges	26.1	\N	30.8	381
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12827	Fromage de brebis à pâte pressée	23.4	\N	32.3	384
5	503	50303	produits laitiers et assimilés	fromages et assimilés	fromages à pâte pressée	12828	Fromage de lactosérum de brebis	9.91	4.3	14.8	190
5	503	50304	produits laitiers et assimilés	fromages et assimilés	fromage fondus	12300	Fromage fondu en tranchettes	13.8	5.34	18.5	246
5	503	50304	produits laitiers et assimilés	fromages et assimilés	fromage fondus	12305	Fromage fondu en portions ou en cubes environ 8% MG	11.3	\N	7.48	\N
5	503	50304	produits laitiers et assimilés	fromages et assimilés	fromage fondus	12310	Fromage fondu en portions ou en cubes environ 20% MG	10.4	6.38	19.3	242
5	503	50304	produits laitiers et assimilés	fromages et assimilés	fromage fondus	12320	Fromage fondu double crème, environ 31% MG	8.88	1.78	29.6	311
5	503	50304	produits laitiers et assimilés	fromages et assimilés	fromage fondus	12325	Cancoillotte (spécialité fromagère fondue)	13.6	0.5	10.5	151
5	503	50304	produits laitiers et assimilés	fromages et assimilés	fromage fondus	12355	Spécialité fromagère fondante au fromage blanc et aux noix	10.4	4.2	31.6	\N
5	503	50304	produits laitiers et assimilés	fromages et assimilés	fromage fondus	12356	Snack pour enfants à base de fromage fondu et de gressins	10.6	24.1	18.9	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12060	Fromage type feta, au lait de vache	16	1.42	21.7	270
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12061	Fromage 100% brebis (Feta AOP ou type Feta)	14.5	2.5	22.8	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12063	Fromage type feta, au lait de vache, à l huile et aux aromates	17.3	0.16	23.4	283
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12066	Feta AOP	14.8	0.65	24.3	285
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12315	Spécialité fromagère non affinée environ 25% MG, type fromage en barquette à tartiner ou coque fromagère	5.25	4.24	23.9	255
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12340	Spécialité fromagère non affinée environ 20% MG, type fromage en barquette à tartiner ou coque fromagère	7.49	1.4	21.2	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12800	Fromage de chèvre frais, au lait pasteurisé (type bûchette fraîche)	15.8	2.08	20	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12804	Fromage de chèvre frais, au lait cru (type palet ou crottin frais)	12.9	2.03	16.9	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12805	Fromage de chèvre frais, au lait pasteurisé ou cru (type crottin frais ou bûchette fraîche)	14.3	2.05	18.4	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	12819	Fromage de chèvre à tartiner, nature	10.6	2.41	12.2	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	19530	Spécialité fromagère non affinée à tartiner environ 30-40 % MG aromatisée (ex: ail et fines herbes)	7.5	4.24	35.3	366
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	19584	Mascarpone	4.29	4	39	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	19585	Ricotta	8.61	4	11.9	\N
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	19590	Mozzarella au lait de vache	16.1	0.75	17.7	227
5	503	50305	produits laitiers et assimilés	fromages et assimilés	autres fromages et spécialités	19591	Mozzarella au lait de bufflonne ou buflesse ("di bufala")	14.3	0.24	22.3	260
5	503	50306	produits laitiers et assimilés	fromages et assimilés	substituts de fromages pour végétariens	1027	Spécialité végétale type fromage à tartiner, au soja, préemballée	12.8	1.05	13.1	175
5	503	50306	produits laitiers et assimilés	fromages et assimilés	substituts de fromages pour végétariens	1028	Spécialité végétale type fromage, à la noix de cajou, préemballée	14.5	15.2	35.3	441
5	503	50306	produits laitiers et assimilés	fromages et assimilés	substituts de fromages pour végétariens	1029	Spécialité végétale type fromage en tranche ou râpé, sans soja, préemballée	0.5	21.2	20.1	272
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19402	Crème de lait ou spécialité à base de crème légère, teneur en matière grasse inconnue (aliment moyen)	2.82	2.87	26	269
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19410	Crème de lait, 30% MG, épaisse, rayon frais	2.94	2.8	30.7	304
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19411	Crème d Isigny AOP, >= 35% MG	2.29	3	40	\N
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19415	Crème de lait, 30% MG, semi-épaisse, UHT	2.44	1.94	30.7	297
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19420	Crème chantilly, sous pression, UHT	2.06	10.6	28.2	308
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19430	Crème de lait, 15 à 20% MG, légère, semi-épaisse, UHT	2.56	2.89	18.7	194
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19431	Crème de lait, 15 à 20% MG, légère, épaisse, rayon frais	2.75	3	15.3	166
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19433	Spécialité à base de crème légère 8% MG, fluide ou épaisse	3.19	5.28	4.3	76.2
5	504	0	produits laitiers et assimilés	crèmes et spécialités à base de crème	-	19436	Crème de lait, 15 à 20% MG, légère, fluide, rayon frais	2.9	4.3	13.5	\N
6	601	0	eaux et autres boissons	eaux	-	18008	Eau de source, embouteillée (aliment moyen)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	18009	Eau minérale, embouteillée, faiblement minéralisée (aliment moyen)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	18044	Eau minérale (aliment moyen)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	18045	Eau minérale, plate (aliment moyen)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	18046	Eau minérale, gazeuse (aliment moyen)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	18066	Eau du robinet	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	18430	Eau embouteillée de source	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76000	Eau minérale Abatilles, embouteillée, non gazeuse, faiblement minéralisée (Arcachon, 33)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76001	Eau minérale Aix-les-Bains, embouteillée, non gazeuse, faiblement minéralisée (Aix-les-Bains, 73)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76002	Eau minérale Aizac, embouteillée, gazeuse, faiblement minéralisée (Aizac, 07)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76004	Eau minérale Amanda, embouteillée, non gazeuse, fortement minéralisée (St-Amand, 59)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76006	Eau minérale Arcens, embouteillée, gazeuse, moyennement minéralisée (Arcens, 07)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76007	Eau minérale Ardesy, embouteillée, gazeuse, fortement minéralisée (Ardes, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76010	Eau minérale Celtic, embouteillée, gazeuse ou non gazeuse, très faiblement minéralisée (Niederbronn, 67)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76011	Eau minérale Chambon, embouteillée, non gazeuse, faiblement minéralisée (Chambon, 45)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76012	Eau minérale Chantemerle, embouteillée, non gazeuse, faiblement minéralisée (Le Pestrin, 07)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76013	Eau minérale Chateauneuf, embouteillée, gazeuse, fortement minéralisée (Chateauneuf, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76014	Eau minérale Chateldon, embouteillée, gazeuse, fortement minéralisée (Chateldon, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76015	Eau minérale Clos de l Abbaye, embouteillée, non gazeuse, moyennement minéralisée (St-Amand, 59)	0	0	0	0
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2031	Jus de citron vert, pur jus	0.25	1.24	0.23	\N
6	601	0	eaux et autres boissons	eaux	-	76016	Eau minérale Contrex, embouteillée, non gazeuse, fortement minéralisée (Contrexéville, 88)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76017	Eau minérale Dax, embouteillée, non gazeuse, moyennement minéralisée (Dax, 40)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76018	Eau minérale Didier, embouteillée, gazeuse, fortement minéralisée (Martinique)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76019	Eau minérale Didier, embouteillée non gazeuse, fortement minéralisée (Martinique)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76020	Eau minérale Evian, embouteillée, non gazeuse, faiblement minéralisée (Evian, 74)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76022	Eau minérale Hépar, embouteillée, non gazeuse, fortement minéralisée (Vittel, 88)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76023	Eau minérale Hydroxydase, embouteillée, gazeuse, fortement minéralisée (Le Breuil sur Couze, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76024	Eau minérale Vernière, embouteillée, gazeuse, moyennement minéralisée (Les Aires, 34)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76025	Eau minérale Luchon, embouteillée, non gazeuse, faiblement minéralisée (Luchon, 31)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76027	Eau minérale Mont-Roucous, embouteillée, très faiblement minéralisée (Lacaune, 81)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76028	Eau de source Ogeu, embouteillée, faiblement minéralisée (Ogeu, 64)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76029	Eau minérale Orée du bois, embouteillée, non gazeuse, moyennement minéralisée (St-Amand, 59)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76030	Eau minérale Orezza, embouteillée, gazeuse, moyennement minéralisée (Rapaggio, 20B)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76031	Eau minérale Parot, embouteillée, gazeuse, moyennement minéralisée (St-Romain-le-Puy, 42)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76032	Eau minérale Plancoet, embouteillée, gazeuse ou non gazeuse, faiblement minéralisée (Plancoet, 22)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76033	Eau minérale Propiac, embouteillée, non gazeuse, fortement minéralisée (Propiac, 26)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76034	Eau minérale Puits St-Georges, embouteillée, gazeuse, moyennement minéralisée (St-Romain-le-Puy, 42)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76035	Eau minérale Quézac, embouteillée, gazeuse, moyennement minéralisée (Quézac, 48)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76036	Eau minérale Reine des basaltes, embouteillée, gazeuse, moyennement minéralisée (Asperjoc, 07)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76037	Eau minérale Rozana, embouteillée, gazeuse, fortement minéralisée (Beauregard, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76038	Eau minérale Sail-les-Bains, embouteillée, non gazeuse, faiblement minéralisée (Sail-les-Bains, 42)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76039	Eau minérale Salvetat, embouteillée, gazeuse, moyennement minéralisée (La Salvetat, 34)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76043	Eau minérale St-Amand, embouteillée, gazeuse ou non gazeuse, moyennement minéralisée (St-Amand, 59)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76044	Eau minérale St-Antonin, embouteillée, non gazeuse, fortement minéralisée (St-Antonin-Noble-Val, 82)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76046	Eau minérale St-Diéry, embouteillée, gazeuse, fortement minéralisée (St-Diéry, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76047	Eau minérale Ste-Marguerite, embouteillée, gazeuse, moyennement minéralisée (St-Maurice, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76049	Eau minérale St-Yorre, embouteillée, gazeuse, fortement minéralisée (Saint-Yorre, 03)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76050	Eau minérale Thonon, embouteillée, non gazeuse, faiblement minéralisée (Thonon, 74)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76053	Eau minérale Ventadour, embouteillée, gazeuse, faiblement minéralisée (Le Pestrin, 07)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76054	Eau minérale Vernet, embouteillée, gazeuse, faiblement minéralisée (Prades, 07)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76055	Eau minérale Vichy Célestins, embouteillée, gazeuse, fortement minéralisée (Saint-Yorre, 03)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76056	Eau minérale Vittel, embouteillée, non gazeuse, moyennement minéralisée (Vittel, 88)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76057	Eau minérale Volvic, embouteillée, non gazeuse, faiblement minéralisée (Volvic, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76058	Eau minérale Volvic active, embouteillée, gazeuse, faiblement minéralisée (Volvic, 63)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76059	Eau minérale Wattwiller, embouteillée, gazeuse ou non gazeuse, faiblement minéraliséee (Wattwiller, 68)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76060	Eau minérale Perrier, embouteillée, gazeuse, faiblement minéralisée (Vergèse, 30)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76061	Eau minérale Badoit, embouteillée, gazeuse, moyennement minéralisée (St-Galmier, 42)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76062	Eau minérale Avra, embouteillée, non gazeuse, faiblement minéralisée (Grèce)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76063	Eau minérale Beckerich, embouteillée, non gazeuse, faiblement minéralisée (Luxembourg)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76065	Eau minérale Chaudfontaine, embouteillée, non gazeuse, faiblement minéralisée (Belgique)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76066	Eau minérale Christinen Brunnen, embouteillée, non gazeuse, moyennement minéralisée (Allemagne)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76067	Eau minérale Courmayeur, embouteillée, non gazeuse, fortement minéralisée (Italie)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76069	Eau minérale Levissima, embouteillée, non gazeuse, faiblement minéralisée (Italie)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76070	Eau minérale Luso, embouteillée, non gazeuse, très faiblement minéralisée (Portugal)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76071	Eau minérale Néro, embouteillée, non gazeuse, faiblement minéralisée (Grèce)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76072	Eau minérale Penacova, embouteillée, non gazeuse, très faiblement minéralisée (Portugal)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76074	Eau minérale San Bernardo, embouteillée, très faiblement minéralisée (Italie)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76075	Eau minérale San Pellegrino, embouteillée, gazeuse, moyennement minéralisée (Italie)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76076	Eau minérale Spa-Reine, embouteillée, gazeuse ou non non gazeuse, moyennement minéralisée (Belgique)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76078	Eau minérale Valvert, embouteillée, non gazeuse, faiblement minéralisée (Belgique)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76079	Eau minérale Appollinaris, embouteillée, non gazeuse, fortement minéralisée (Allemagne)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76080	Eau de source Cristaline, embouteillée, non gazeuse	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76081	Eau minérale Biovive, embouteillée, non gazeuse, faiblement minéralisée (Dax, 40)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76082	Eau minérale La Cairolle, embouteillée, non gazeuse, fortement minéralisée (Les Aires, 34)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76083	Eau minérale Cilaos, embouteillée, gazeuse, fortement minéralisée (Cilaos, 974)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76085	Eau minérale La Française, embouteillée, non gazeuse, fortement minéralisée (Propiac, 26)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76086	Eau minérale Montcalm, embouteillée, non gazeuse, très faiblement minéralisée (Auzat, 09)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76087	Eau minérale Montclar, embouteillée, non gazeuse, faiblement minéralisée (Montclar, 04)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76088	Eau minérale Nessel, embouteillée, gazeuse, moyennement minéralisée (Soultzmatt, 68)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76089	Eau minérale Ogeu, embouteillée, gazeuse, faiblement minéralisée (Ogeu-les-Bains, 64)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76090	Eau minérale Ogeu, embouteillée, non gazeuse, faiblement minéralisée (Ogeu-les-Bains, 64)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76091	Eau minérale Prince Noir, embouteillée, non gazeuse, fortement minéralisée (St-Antonin-Noble-Val, 82)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76092	Eau minérale St-Alban, embouteillée, gazeuse, moyennement minéralisée (St-Alban, 42)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76093	Eau minérale St-Géron, embouteillée, gazeuse, moyennement minéralisée (St-Géron, 43)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76094	Eau minérale St-Michel-de-Mourcairol, embouteillée, gazeuse, moyennement minéralisée (Les Aires, 34)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76095	Eau minérale Treignac, embouteillée, non gazeuse, très faiblement minéralisée (Treignac, 19)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76096	Eau minérale Vals, embouteillée, gazeuse, moyennement minéralisée (Vals-les-Bains, 07)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76097	Eau minérale Vauban, embouteillée, non gazeuse, moyennement minéralisée (St-Amand-les-Eaux, 59)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76100	Eau minérale Carola, embouteillée, gazeuse ou non gazeuse, moyennement minéralisée (Ribeauville, 68)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76101	Eau minérale Mont-Blanc, embouteillée, non gazeuse, faiblement minéralisée (Italie)	0	0	0	0
6	601	0	eaux et autres boissons	eaux	-	76102	Eau minérale Eden (La Goa), embouteillée, non gazeuse, faiblement minéralisée (Suisse)	0	0	0	0
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2000	Jus d ananas, à base de concentré	0.41	11.9	0.096	52.3
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2002	Jus multifruit, pur jus, multivitaminé	0.48	11.3	0.1	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2004	Jus de fruits (aliment moyen)	0.52	9.58	0.14	47
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2006	Jus de carotte, pur jus	0.4	6.55	0.1	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2007	Jus de citron, maison	0.49	2.41	0.24	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2011	Jus multifruit - base orange, multivitaminé	0.5	11.7	0.8	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2012	Jus d orange, à base de concentré	0.63	9.59	0.13	45.6
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2013	Jus d orange, maison	0.7	9.4	0.2	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2014	Jus de pomme, à base de concentré	0.24	11.3	0.098	48.5
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2015	Jus de pamplemousse (pomélo), à base de concentré	0.52	8.41	0.1	40.9
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2016	Jus de raisin, pur jus	0.25	16.3	0.057	69.2
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2017	Jus de grenade, pur jus	0.15	13	0.29	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2018	Jus de pruneau	0.37	18.7	0.039	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2019	Jus de raisin, à base de concentré	0.31	16	0.11	68.8
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2023	Jus de mangue, frais	0.19	9.5	0	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2024	Jus de fruit de la passion ou maracudja, frais	0.67	14.3	0.18	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2025	Jus de pamplemousse (pomélo), maison	0.5	9.1	0.1	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2026	Jus de tomate, pur jus, salé à 3 g/L	0.88	4.13	0.17	23.2
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2027	Jus de pamplemousse (pomelo), pur jus	0.49	8.89	0.083	42.5
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2028	Jus de citron, pur jus	0.4	6.1	0.29	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2032	Jus de tomate, pur jus, salé à 6g/L	0.88	3.31	0.11	20.1
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2033	Jus multifruit, à base de jus et purée de fruits	0.46	11.5	0.11	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2034	Jus de clémentine ou mandarine, pur jus	0.66	10.6	0.14	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2035	Jus multifruit, pur jus, standard	0.5	11.2	0.3	48.9
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2036	Jus multifruit - base raisin, standard	0.5	13	0	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2038	Jus multifruit - base orange, standard	0.7	10.4	0.16	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2039	Jus de grenade, frais	0.2	11.6	0	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2048	Jus multifruit - base pomme, standard	0.33	12.2	0.1	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2050	Jus multifruit - base pomme, multivitaminé	0.33	11	0.1	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2052	Jus de fruit(s) et de légume(s), pur jus	0.85	9.5	\N	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2053	Jus de tomate, pur jus (aliment moyen)	0.88	3.72	0.14	21.7
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2069	Jus multifruit, à base de concentré, standard	0.52	11.2	0.15	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2070	Jus d orange, pur jus	0.61	9.61	0.11	45.4
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2071	Jus multifruit, à base de concentré, multivitaminé	0.29	10.8	0.091	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2072	Jus de fruits, pur jus (aliment moyen)	0.51	9.32	0.14	46.9
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2073	Jus d ananas, pur jus	0.41	12.1	0.074	52.9
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2074	Jus de pomme, pur jus	0.17	11.4	0.14	48.9
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2075	Jus de légumes, pur jus (aliment moyen)	0.72	4.66	0.13	21.7
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2077	Jus de fruits, à base de concentré (aliment moyen)	0.54	10.5	0.13	47.1
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2377	Jus d orange sanguine, pur jus	0.63	10.2	0.1	\N
6	602	60201	eaux et autres boissons	boissons sans alcool	jus	2500	Smoothie	0.62	12.4	0.26	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2009	Nectar multifruit - base pomme, standard	0.28	10	0.1	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2010	Nectar multifruit - base pomme, multivitaminé	0.1	9.1	0.1	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2043	Nectar d abricot	0.21	13.7	0.03	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2045	Nectar de papaye	0.17	13.9	0.15	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2054	Nectar de poire	0.19	14.8	0.043	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2060	Nectar multifruit, multivitaminé	0.24	11.3	0.1	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2061	Nectar multifruit, standard	0.3	11.5	0.089	49.7
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2062	Nectar multifruit - base orange, multivitaminé	0.4	11.1	0.1	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2063	Nectar multifruit - base orange, standard	0.3	12.2	0.12	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2064	Nectar, avec édulcorants, allégé en sucres	0.18	5.47	0.037	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2076	Nectar de pomme	0.14	10.9	0.075	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2365	Nectar de fruit de la passion ou maracuja	0.3	15.2	0.1	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2366	Nectar de banane	0.23	13.6	0.048	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2367	Nectar de goyave	0.14	11.3	0.16	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2370	Nectar de mangue	0.2	12.3	0.083	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2371	Nectar de pêche	0.22	12.1	0.05	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2374	Nectar d ananas	0.1	13	0	\N
6	602	60202	eaux et autres boissons	boissons sans alcool	nectars	2375	Nectar d orange	0.29	8.79	0.08	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18001	Boisson gazeuse, sans jus de fruit, non sucrée, avec édulcorants	0.05	0.16	\N	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18010	Limonade, sucrée	0.04	8.45	0.02	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18011	Eau de coco	0.5	3.33	0.3	15.2
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18012	Boisson à l eau minérale ou de source, aromatisée, sucrée	0.086	3.48	0.086	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18013	Tonic ou bitter, non sucré, avec édulcorants	0.05	0.4	\N	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18014	Tonic ou bitter, sucré, avec édulcorants	0	6.45	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18015	Boisson au thé, aromatisée, sucrée, avec édulcorants	0	5.3	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18016	Limonade, sucrée, avec édulcorants	0	3	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18018	Cola, sucré	0.093	10.2	0.062	41.8
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18019	Boisson gazeuse aux fruits (de 10 à 50% de jus), sucrée	0.067	11.3	0.028	46.6
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18021	Boisson plate aux fruits, (à moins de 10% de jus), non sucrée, avec édulcorants	0.06	0.96	0.13	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18023	Boisson plate aux fruits (à moins de 10% de jus), sucrée	0.1	4.4	0.1	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18024	Boisson plate aux fruits (10 à 50% de jus de jus), sucrée, avec édulcorants	0	6.17	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18025	Kombucha, préemballé	0.5	1.45	0.3	9.46
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18026	Boisson gazeuse, sans jus de fruit, sucrée	0.14	8.67	0.078	37.1
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18028	Boisson à l eau minérale ou de source, aromatisée, non sucrée, sans édulcorant	0.06	0.14	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18029	Boisson rafraîchissante sans alcool (aliment moyen)	0.11	7.42	0.042	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18030	Boisson à l eau minérale ou de source, aromatisée, non sucrée, avec édulcorants	0.086	0.28	0.086	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18033	Boisson gazeuse aux fruits (à moins de 10% de jus), sucrée, avec édulcorants	\N	7	\N	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18034	Boisson gazeuse aux fruits (de 10 à 50% de jus), sucrée, avec édulcorants	0.067	3.83	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18035	Limonade, non sucrée, avec édulcorants	0.067	0.1	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18037	Cola, sucré, avec édulcorants	0.0093	6.65	0.0033	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18039	Diabolo (limonade et sirop)	0.075	10.6	\N	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18048	Boisson gazeuse aux fruits (teneur en jus non spécifiée), sucrée (aliment moyen)	0.068	11.2	0.03	46.6
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18049	Boisson gazeuse aux fruits (à moins de 10% de jus), sucrée	0.081	9.97	0.051	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18051	Boisson gazeuse aux fruits (de 10 à 50% de jus), non sucrée, avec édulcorants	0.073	1.39	0.014	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18057	Boisson préparée à partir de boisson concentrée à diluer, non sucrée, avec édulcorants, type "sirop 0%", diluée dans l eau	0.5	2.42	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18058	Boisson préparée à partir de sirop à diluer type menthe, fraise, etc, sucré, dilué dans l eau	0.055	7.7	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18060	Cola, non sucré, avec édulcorants	0.081	0.11	0.053	1.3
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18062	Boisson au thé, aromatisée, teneur en sucre et édulcorant inconnue (aliment moyen)	0.028	6.11	0.0092	27.3
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18063	Cola, teneur en sucre et édulcorant inconnue (aliment moyen)	0.089	7.45	0.059	30.7
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18064	Boisson au thé, aromatisée, à teneur réduite en sucres	0	\N	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18065	Boisson au thé, aromatisée, non sucrée, avec édulcorants	0.014	0.34	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18067	Cola, sucré, sans caféine	\N	11	\N	43.8
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18068	Cola, non sucré, avec édulcorants, sans caféine	0	0.2	0	0.87
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18075	Boisson au thé, aromatisée, sucrée	0.033	6.76	0.022	27.3
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18078	Boisson gazeuse, sans jus de fruit, sucrée, avec édulcorants	0	6.8	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18304	Boisson plate aux fruits (10 à 50% de jus), à teneur réduite en sucres	0.014	5.16	0.01	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18309	Boisson plate aux fruits (teneur en jus non spécifiée), sucrée	0.1	11.2	0.07	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18339	Boisson plate aux fruits (10 à 50% de jus), sucrée	0.13	10.1	0.06	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18340	Boisson gazeuse aux fruits (à moins de 10% de jus), non sucrée, avec édulcorants	0.063	0.45	0.13	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18341	Boisson gazeuse à la pomme (de 50 à 99% de fruits), non sucrée	0	7.5	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18344	Tonic ou bitter, sucré	0.068	8.28	0.066	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18345	Boisson gazeuse aux fruits (à moins de 10% de jus), non sucrée, sans édulcorant	0	4.17	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18352	Boisson énergisante, sucrée	0.2	11.9	0	\N
6	602	60203	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes sans alcool	18353	Boisson énergisante, non sucrée, avec édulcorants	0.073	0.95	0.1	\N
6	602	60204	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes lactées	18343	Boisson au jus de fruit et au lait	0.56	9.63	0.3	47.5
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18076	Thé, feuille	19.4	6.3	2	232
6	602	60204	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes lactées	19120	Boisson lactée aromatisée (arôme inconnu), sucrée, au lait partiellement écrémé, enrichie et/ou restaurée en vitamines et/ou minéraux (aliment moyen)	2.87	12.1	1.08	\N
6	602	60204	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes lactées	19122	Boisson lactée aromatisée au chocolat, sucrée, au lait partiellement écrémé, enrichie et/ou restaurée en vitamines et/ou minéraux	2.7	10.8	0.99	63.8
6	602	60204	eaux et autres boissons	boissons sans alcool	boissons rafraîchissantes lactées	19127	Boisson lactée aromatisée à la fraise, sucrée, au lait partiellement écrémé, enrichie à la vitamine D	2.13	10	0.45	52.6
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18041	Lait de coco ou Crème de coco	1.77	3.4	18.4	188
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18107	Boisson à l amande, nature, non sucrée, non enrichie, préemballée	1.06	0.68	3.2	36.3
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18110	Boisson à l amande, sucrée, enrichie en calcium, préemballée	0.69	3.96	2.8	44.4
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18305	Boisson plate aux fruits (10 à 50% de jus), non sucrée, avec édulcorants	0.1	1.4	0.1	\N
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18900	Boisson au soja, nature, non enrichie, préemballée	3.63	0.7	2.07	37.1
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18901	Boisson au soja, nature, enrichie en calcium, préemballée	3.75	2.18	2.05	44.2
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18902	Boisson au soja, aromatisée, sucrée, non enrichie, préemballée	3.25	7.24	1.92	60.5
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18903	Boisson au soja, aromatisée, sucrée, enrichie en calcium, préemballée	3.3	2.89	1.8	42.8
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18904	Boisson au riz, nature, préemballée	0.5	10.8	1	53.7
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18905	Boisson à base d avoine, nature, préemballée	0.5	7.8	1.1	42.6
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18906	Boisson à la châtaigne, nature, préemballée	0.5	13.5	1.4	68.9
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	18907	Boisson à la noix de coco, nature, préemballée	0.5	2.75	2.1	31.4
6	602	60205	eaux et autres boissons	boissons sans alcool	boissons végétales	29209	Boisson au soja et jus de fruits concentrés, préemballée	2.3	9.5	1	56.2
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18004	Café, non instantané, non sucré, prêt à boire	0.5	1.35	0.018	6.88
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18020	Thé infusé, non sucré	0	0	0.007	0.063
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18022	Tisane infusée, non sucrée	0	0.2	0.008	0.87
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18070	Café décaféiné, non instantané, non sucré, prêt à boire	0.1	0.6	0.18	4.42
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18071	Café expresso, non instantané, non sucré, prêt à boire	0.5	1.16	0.2	7.64
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18072	Café décaféiné, instantané, non sucré, prêt à boire	0.12	0.4	0.002	2.1
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18073	Café, instantané, non sucré, prêt à boire	0.1	0.3	0.004	1.64
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18104	Boisson cacaotée ou au chocolat, instantanée, sucrée, prête à boire (reconstituée avec du lait demi-écrémé standard)	3.78	9.5	1.42	69.3
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18106	Boisson cacaotée ou au chocolat, instantanée, sucrée, enrichie en vitamines, prête à boire (reconstituée avec du lait demi-écrémé standard)	4.08	9.91	1.71	71.9
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18151	Café au lait, café crème ou cappuccino, instantané ou non, non sucré, prêt à boire	1.36	2.31	0.76	21.5
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18153	Chicorée et café, instantané, non sucré, prête à boire (reconstituée avec du lait demi-écrémé standard)	3.66	5.9	1.62	53.7
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18154	Thé noir, infusé, non sucré	0	0.3	0.007	1.26
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18155	Thé vert, infusé, non sucré	0	1.09	0	5.1
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18156	Thé oolong, infusé, non sucré	0	0	0	0
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18161	Chicorée, instantanée, non sucrée, prête à boire (reconstituée avec du lait demi-écrémé standard)	\N	7.1	7.1	93.5
6	602	60206	eaux et autres boissons	boissons sans alcool	café, thé, cacao etc. prêts à consommer	18162	Chicorée et café, instantané, non sucré, prêt à boire (reconstituée avec de l eau)	0.56	6.06	0.3	28.7
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18003	Café, moulu	14.4	40.2	15.4	397
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18005	Café, poudre soluble	19.4	42.6	1.1	296
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18017	Sirop à diluer, sucré	0.5	62.6	0.5	255
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18059	Boisson concentrée à diluer, sans sucres ajoutés, avec édulcorants, type "sirop 0%"	0.5	2.76	0.5	21.7
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18069	Café, décaféiné, poudre soluble	12.7	76	0.2	357
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18100	Cacao, non sucré, poudre soluble	22.4	11.6	20.6	387
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18101	Poudre cacaotée ou au chocolat pour boisson, sucrée	6.65	75.6	3.29	379
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18102	Poudre maltée, cacaotée ou au chocolat pour boisson, sucrée, enrichie en vitamines et minéraux	9.9	79.4	5.03	\N
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18150	Chicorée et café, poudre soluble	9.3	66.9	0.35	332
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18152	Chicorée, poudre soluble	3.3	57.2	2.5	323
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18160	Café au lait ou cappuccino, poudre soluble	11.9	70.1	8.8	416
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18163	Café au lait ou cappuccino au chocolat, poudre soluble	11	67.1	9.13	402
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18167	Poudre cacaotée ou au chocolat sucrée pour boisson, enrichie en vitamines et minéraux	4.68	79.3	3.04	376
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18168	Poudre cacaotée ou au chocolat pour boisson, sucrée, enrichie en vitamines	4.29	85	2.04	386
6	602	60207	eaux et autres boissons	boissons sans alcool	boissons à reconstituer	18220	Citron ou Lime, spécialité à diluer pour boissons, sans sucres ajoutés	0.5	1.31	0	19.7
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	1006	Vin doux	0.2	10.5	0	\N
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	5100	Pétillant de fruits	0	6.95	0	\N
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	5201	Vin blanc mousseux	0	1.7	0	\N
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	5207	Champagne	0.3	2.81	0	\N
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	5209	Vin blanc mousseux aromatisé	0.2	5.1	0	\N
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	5210	Vin (aliment moyen)	0.09	3.29	0	\N
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	5214	Vin rouge	0.07	2.63	0	82.1
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	5215	Vin blanc (sec)	0.5	4.04	0	\N
6	603	60301	eaux et autres boissons	boisson alcoolisées	vins	5216	Vin rosé	0	1.6	0	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5000	Bière brune	0.43	4.1	\N	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5001	Bière "coeur de marché" (4-5° alcool)	0.39	2.7	0	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5002	Bière forte (>8° alcool)	0.63	4.6	0	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5003	Cidre (aliment moyen)	0.069	3.22	0.083	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5006	Cidre brut	0	2.62	0	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5007	Cidre doux	0.5	5.09	0.6	37.5
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5008	Bière faiblement alcoolisée (3° alcool)	0.31	4.62	0.05	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5009	Bière blanche	0.5	0.43	0.6	34.6
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5010	Bière "spéciale" (5-6° alcool)	0.48	4.55	0.05	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5011	Bière "de spécialités" ou d abbaye, régionales ou d une brasserie (degré d alcool variable)	0.63	3.2	0	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5020	Cidre traditionnel	0	1.87	0	\N
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5021	Cidre bouché demi-sec	0.5	4.4	0.6	48
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5022	Cidre aromatisé (framboise)	0.5	5.34	0.6	35.4
6	603	60302	eaux et autres boissons	boisson alcoolisées	bières et cidres	5030	Bière sans alcool (<1,2° alcool)	0.31	4.89	0.05	25.3
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1000	Pastis	0	2.86	0	274
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1001	Eau de vie	0	0.37	0	229
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1002	Gin	0	0	0	265
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1003	Liqueur	0.1	39.6	0.3	328
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1004	Rhum	0	0	0	256
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1005	Whisky	0	0.096	0	252
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1007	Apéritif à base de vin ou vermouth	0.054	11.3	0	\N
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1008	Vodka	0	0	0	242
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1010	Pastis, prêt à boire (1+ 5)	0	6.89	0	27.6
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1011	Apéritif anisé sans alcool	0	1	0	\N
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1014	Alcool pur	0	0	0	660
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1015	Marsala	0.1	27.9	0	211
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1016	Marsala aux oeufs	0	12.4	0	153
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1021	Crème de cassis	0	41	0	245
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1023	Eau de vie de vin, type armagnac, cognac	0	1	0	228
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1024	Eau de vie, type calvados	0	0	0	\N
6	603	60303	eaux et autres boissons	boisson alcoolisées	liqueurs et alcools	1026	Saké ou Alcool de riz	0	5	0	133
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	1012	Cocktail à base de rhum	0	22.5	2.19	\N
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	1013	Cocktail à base de whisky	0	15.9	0.02	\N
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	1017	Sangria	0	10.3	0.05	\N
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	1018	Kir (au vin blanc)	0.18	7.36	0	\N
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	1019	Kir royal (au champagne)	0.25	7.97	0	\N
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	1022	Cocktail type punch, 16% alcool	0.6	17.8	0.6	\N
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	2008	Cocktail sans alcool (à base de jus de fruits et de sirop)	0.5	12.8	0	\N
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	5004	Panaché (limonade et bière)	0	5.63	0	36.2
6	603	60304	eaux et autres boissons	boisson alcoolisées	cocktails	5005	Panaché préemballé (<1° alc.)	0.48	4.93	0.05	25.4
7	701	0	produits sucrés	sucres, miels et assimilés	-	11506	Édulcorant à l aspartame, en pastilles	6.35	69.3	0	216
7	701	0	produits sucrés	sucres, miels et assimilés	-	11509	Édulcorant à l aspartame, en poudre	0.63	94.7	0.25	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	11510	Vermicelles multicolores	0.5	93	5	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31008	Miel	0.56	81.7	0	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31016	Sucre blanc	0	99.8	0	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31017	Sucre roux	0.12	97.3	0	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31034	Sirop d érable	0.04	67.1	0.06	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31044	Sucre vanillé	0.1	99	0.33	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31046	Caramel liquide ou nappage caramel	0	81	0	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31064	Édulcorant à la saccharine	1.25	88.8	0	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31067	Mélasse de canne	0	74.7	0.1	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31076	Sucre allégé à l aspartame	0.81	98.7	0	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31077	Fructose	0	99.8	0	\N
7	701	0	produits sucrés	sucres, miels et assimilés	-	31087	Édulcorant à base d extrait de stévia	\N	98	0.2	238
7	701	0	produits sucrés	sucres, miels et assimilés	-	31089	Sirop d agave	0.5	78.1	0.5	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31000	Barre chocolatée biscuitée	6.14	60.5	28.1	523
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31001	Barre chocolatée non biscuitée enrobée	3.7	66.4	24.1	496
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31002	Barre à la noix de coco, enrobée de chocolat	3.88	60.2	23.8	475
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31004	Chocolat au lait, tablette	7.5	55.6	30.8	537
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31005	Chocolat noir à moins de 70% de cacao, à croquer, tablette	6.63	42.9	33.8	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31009	Chocolat au lait aux céréales croustillantes, tablette	7.15	60.6	26.6	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31010	Chocolat blanc, tablette	6.16	57.1	34.2	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31012	Barres ou confiserie chocolatées au lait	8.75	50.9	34.2	551
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31018	Chocolat au lait aux fruits secs (noisettes, amandes, raisins, praline), tablette	8.43	48.7	35.9	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31020	Chocolat au lait sans sucres ajoutés, avec édulcorants, tablette	5.75	54.2	34.6	487
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31026	Chocolat blanc aux fruits secs (noisettes, amandes, raisins, praliné) , tablette	7.64	48	39.1	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31030	Chocolat noir sans sucres ajoutés, avec édulcorants, en tablette	8.48	34.1	42.3	525
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31032	Pâte à tartiner chocolat et noisette	5.02	57.9	32.4	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31041	Confiserie au chocolat dragéifiée	5.49	65	24.3	505
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31042	Cacahuètes enrobées de chocolat dragéifiées	9.5	55.9	25	499
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31063	Bouchée chocolat fourrage fruits à coques et/ou praliné	9.1	51.5	34.7	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31066	Rocher chocolat fourré praliné	6.53	51.4	35.3	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31069	Chocolat noir aux fruits (orange, framboise, poire), tablette	6.8	45.3	34.4	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31070	Chocolat noir aux fruits secs (noisettes, amandes, raisins, praline), tablette	8.69	40.7	39	567
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31071	Barre chocolatée aux fruits secs	7.23	57.6	26	494
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31072	Chocolat noir fourrage confiseur à la menthe	2.9	70.5	16	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31073	Barre goûter frais au lait et chocolat	6.81	41	28.5	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31074	Chocolat noir à 70% cacao minimum, extra, dégustation, tablette	10.4	26.9	46.3	591
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31079	Chocolat au lait fourré	4.8	45.5	45	\N
9	901	0	matières grasses	beurres	-	16404	Beurre à 82% MG, doux, tendre	0.7	0.5	83.4	755
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31080	Chocolat noir fourré praliné, tablette	6.38	52.4	34.8	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31084	Chocolat au lait fourré au praliné, tablette	7.29	52.9	34.9	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31085	Chocolat noir à 40% de cacao minimum, à pâtisser, tablette	6.39	51.4	33.1	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31091	Bonbon / bouchée au chocolat fourrage gaufrettes / biscuit	6.5	55.1	29.4	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31098	Barre chocolat au lait avec nougat	5.8	60.5	29	532
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31099	Barre goûter frais au lait et chocolat avec génoise	6.68	39	34.2	\N
7	702	0	produits sucrés	chocolats et produits à base de chocolat	-	31120	Chocolat, en tablette (aliment moyen)	7.81	45.3	36.1	557
7	703	0	produits sucrés	confiseries non chocolatées	-	31003	Bonbons, tout type	1.75	86.5	6.32	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31007	Chewing-gum, sucré	0.5	90.6	0.32	372
7	703	0	produits sucrés	confiseries non chocolatées	-	31014	Pâte de fruits	1.69	76.6	1.8	336
7	703	0	produits sucrés	confiseries non chocolatées	-	31021	Zeste d orange confit	0.2	82.7	0.2	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31023	Marron glacé	0.94	79.5	0.5	324
7	703	0	produits sucrés	confiseries non chocolatées	-	31027	Fruit confit	0.5	72.3	0.3	298
7	703	0	produits sucrés	confiseries non chocolatées	-	31033	Nougat ou touron	7.88	62.5	25.2	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31036	Dragée amande	5	73.9	17.2	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31050	Guimauve ou marshmallow	3.67	78.7	1.42	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31054	Chewing-gum, sans sucre	0.69	78.1	0.45	228
7	703	0	produits sucrés	confiseries non chocolatées	-	31059	Bonbon dur et sucette	0.19	95.4	0.35	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31060	Bonbon gélifié	6.28	80.2	0.25	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31081	Bonbon au caramel, mou	2.95	83.7	8.04	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31092	Calissons d Aix en Provence	7.88	60.3	18	440
7	703	0	produits sucrés	confiseries non chocolatées	-	31093	Guimauve ou marshmallow, enrobé de chocolat	4.65	66.2	10.3	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31094	Bonbon dur au caramel	1.21	72.5	6	\N
7	703	0	produits sucrés	confiseries non chocolatées	-	31121	Chewing-gum, teneur en sucre inconnue (aliment moyen)	0.53	82.5	0.41	279
7	704	0	produits sucrés	confitures et assimilés	-	30999	Confiture ou Marmelade, tout type de fruits, teneur en sucre inconnue (aliment moyen)	0.37	56.5	0.29	228
7	704	0	produits sucrés	confitures et assimilés	-	31006	Confiture ou Marmelade, tout type de fruits (aliment moyen)	0.29	60.2	0.31	249
7	704	0	produits sucrés	confitures et assimilés	-	31024	Confiture de fraise (extra ou classique)	0.5	60.5	0.5	251
7	704	0	produits sucrés	confitures et assimilés	-	31037	Confiture d abricot (extra ou classique)	0.5	59.7	0.3	247
7	704	0	produits sucrés	confitures et assimilés	-	31038	Confiture de cerise (extra ou classique)	0.38	60.9	0.16	\N
7	704	0	produits sucrés	confitures et assimilés	-	31039	Marmelade d orange	0.5	59.3	0.4	246
7	704	0	produits sucrés	confitures et assimilés	-	31040	Confiture de lait	6.32	58	5.45	\N
7	704	0	produits sucrés	confitures et assimilés	-	31053	Confiture de prune (extra ou classique)	0.27	59.3	0.1	\N
7	704	0	produits sucrés	confitures et assimilés	-	31062	Confiture de framboise (extra ou classique)	0.47	61	0.21	\N
7	704	0	produits sucrés	confitures et assimilés	-	31068	Confiture de myrtilles (extra ou classique)	0.5	58.9	0.4	246
7	704	0	produits sucrés	confitures et assimilés	-	31082	Préparation de fruits divers (en taux de sucres : confitures allégées en sucres < préparations de fruits < confitures)	0.49	43.4	0.33	\N
7	704	0	produits sucrés	confitures et assimilés	-	31086	Gelée de fruits divers (extra ou classique)	0.35	61.6	0.17	\N
7	704	0	produits sucrés	confitures et assimilés	-	31095	Gelée de groseille (extra ou classique)	0.5	59.6	0.3	246
7	704	0	produits sucrés	confitures et assimilés	-	31110	Confiture, tout type de fruits, allégée en sucres (extra ou classique)	0.75	38	0.3	162
7	705	0	produits sucrés	viennoiseries	-	7225	Pain brioché ou viennois	10.7	55.5	9.38	356
7	705	0	produits sucrés	viennoiseries	-	7600	Viennoiserie (aliment moyen)	8.02	49.1	16.2	380
7	705	0	produits sucrés	viennoiseries	-	7602	Croissant, sans précision	7.29	40.4	20	375
7	705	0	produits sucrés	viennoiseries	-	7615	Croissant ordinaire, artisanal	6.94	47.6	21.1	412
7	705	0	produits sucrés	viennoiseries	-	7620	Croissant au beurre, artisanal	7.25	45.7	22.6	420
7	705	0	produits sucrés	viennoiseries	-	7650	Croissant aux amandes, artisanal	8.36	35.9	29.1	446
7	705	0	produits sucrés	viennoiseries	-	7710	Pain au lait, artisanal	9.38	50.6	15.4	382
7	705	0	produits sucrés	viennoiseries	-	7711	Pain au lait, préemballé	8.94	52.2	12.3	359
7	705	0	produits sucrés	viennoiseries	-	7712	Pain au lait aux pépites de chocolat, préemballé	8.51	52	13.5	369
7	705	0	produits sucrés	viennoiseries	-	7720	Pain aux raisins (viennoiserie)	5.6	55.9	9	333
7	705	0	produits sucrés	viennoiseries	-	7730	Pain au chocolat feuilleté, artisanal	8.19	45.4	22.5	423
7	705	0	produits sucrés	viennoiseries	-	7733	Pain au chocolat, préemballé	7.56	46.8	22.3	425
7	705	0	produits sucrés	viennoiseries	-	7735	Brioche (ou briochettes) aux pépites de chocolat, préemballée	8.56	51.6	11.2	348
7	705	0	produits sucrés	viennoiseries	-	7737	Brioche fourrée au chocolat	7.47	53.2	11.6	351
7	705	0	produits sucrés	viennoiseries	-	7738	Brioche fourrée aux fruits, préemballée	6.9	50.5	12.1	346
7	705	0	produits sucrés	viennoiseries	-	7739	Brioche fourrée crème pâtissière (type "chinois"), préemballée	6.22	49.2	8.41	300
7	705	0	produits sucrés	viennoiseries	-	7740	Brioche, préemballée	8.13	52.7	11.8	354
7	705	0	produits sucrés	viennoiseries	-	7741	Brioche, sans précision	11.3	46	19.1	401
7	705	0	produits sucrés	viennoiseries	-	7742	Brioche, de boulangerie traditionnelle	9.81	49.2	14.7	374
7	705	0	produits sucrés	viennoiseries	-	7744	Couronne de Noël (Brioche) aux fruits confits, préemballée	7.2	53.3	12.3	355
7	705	0	produits sucrés	viennoiseries	-	7745	Brioche pur beurre, préemballée	8	51.6	14	366
7	705	0	produits sucrés	viennoiseries	-	23467	Chouquette	7.76	42.6	18.6	381
7	705	0	produits sucrés	viennoiseries	-	23480	Chausson aux pommes	4.17	36.6	18.7	338
7	706	0	produits sucrés	biscuits sucrés	-	7412	Tartine craquante, extrudée et grillée, fourrée au chocolat	7.85	64.3	16	\N
7	706	0	produits sucrés	biscuits sucrés	-	7413	Tartine craquante, extrudée et grillée, fourrée aux fruits	5.38	74.7	6.44	\N
7	706	0	produits sucrés	biscuits sucrés	-	23027	Macaron sec	6.9	77.7	10.2	\N
7	706	0	produits sucrés	biscuits sucrés	-	24000	Biscuit sec, sans précision	6.9	65	20.6	\N
7	706	0	produits sucrés	biscuits sucrés	-	24001	Biscuit sec nature	6.77	70	15.1	\N
7	706	0	produits sucrés	biscuits sucrés	-	24002	Biscuit sec à teneur garantie en vitamines	9.63	72.6	14.2	\N
7	706	0	produits sucrés	biscuits sucrés	-	24003	Biscuit sec à teneur garantie en vitamines et minéraux	10.8	61.9	19.8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24004	Biscuit sec aux fruits, hyposodé	10.8	61.4	15.8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24005	Biscuit sec aux fruits hyposodé, sans sucres ajoutés	22.7	47.6	20.7	\N
7	706	0	produits sucrés	biscuits sucrés	-	24007	Biscuit sec croquant au chocolat, allégé en matière grasse	7	69	11	\N
7	706	0	produits sucrés	biscuits sucrés	-	24008	Biscuit sec fourré aux fruits, allégé en matière grasse	4.69	75.3	7.2	\N
7	706	0	produits sucrés	biscuits sucrés	-	24009	Spéculoos	5.94	69	19.7	\N
7	706	0	produits sucrés	biscuits sucrés	-	24010	Biscuit sec, avec matière grasse végétale	7.23	74.7	11.8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24011	Biscuit sec, petits fours en assortiment	6.44	61.4	26.4	\N
7	706	0	produits sucrés	biscuits sucrés	-	24015	Biscuit sec petit beurre	8.06	74.5	12.1	\N
7	706	0	produits sucrés	biscuits sucrés	-	24016	Biscuit sec avec tablette de chocolat	6.62	63.3	24.1	\N
7	706	0	produits sucrés	biscuits sucrés	-	24017	Biscuit sec petit beurre au chocolat	7.19	71.1	16	\N
7	706	0	produits sucrés	biscuits sucrés	-	24030	Biscuit sec au lait	8.25	73.9	11.5	\N
7	706	0	produits sucrés	biscuits sucrés	-	24031	Biscuit sec croquant (ex : tuile) sans chocolat, allégé en matière grasse	5.63	80.1	8.8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24034	Biscuit sec pour petit déjeuner	7.81	65.8	16.3	\N
7	706	0	produits sucrés	biscuits sucrés	-	24035	Biscuit sec pour petit déjeuner, allégé en sucres	7.68	66.3	16	\N
7	706	0	produits sucrés	biscuits sucrés	-	24036	Biscuit sec chocolaté, préemballé	6.43	61.7	26.9	\N
7	706	0	produits sucrés	biscuits sucrés	-	24037	Biscuit sec fourré à la pâte ou purée de fruits	4.43	69.2	9.11	\N
7	706	0	produits sucrés	biscuits sucrés	-	24038	Biscuit sec avec nappage chocolat	6.93	61.9	25	\N
7	706	0	produits sucrés	biscuits sucrés	-	24039	Barre biscuitée fourrée aux fruits, allégée en matière grasse	3.32	75.7	7.12	\N
7	706	0	produits sucrés	biscuits sucrés	-	24040	Biscuit sec pour petit déjeuner, au chocolat	6.5	69.7	16.6	\N
7	706	0	produits sucrés	biscuits sucrés	-	24041	Biscuit aux céréales pour petit déjeuner, enrichis en vitamines et minéraux	7.44	67.7	15.7	445
7	706	0	produits sucrés	biscuits sucrés	-	24049	Biscuit sec au beurre, sablé, galette ou palet	6.4	64.8	22.7	\N
7	706	0	produits sucrés	biscuits sucrés	-	24050	Biscuit sec au beurre, sablé, galette ou palet, au chocolat	6.64	61	25.3	\N
7	706	0	produits sucrés	biscuits sucrés	-	24051	Biscuit sec chocolaté, type barquette	7.39	60.9	22.8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24052	Biscuit sec chocolaté, type tartelette	6.65	60.2	25.8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24053	Biscuit sec chocolaté, type galette	6.84	63.7	23.5	\N
7	706	0	produits sucrés	biscuits sucrés	-	24054	Biscuit sec, sablé, galette ou palet, aux fruits	5.93	67.6	19.3	\N
7	706	0	produits sucrés	biscuits sucrés	-	24055	Biscuit sec fourré fruits à coque (non ou légèrement chocolaté)	5.5	59.8	27.2	511
7	706	0	produits sucrés	biscuits sucrés	-	24056	Florentin (biscuit sec sucré chocolaté aux amandes)	9.31	50.7	28.7	514
7	706	0	produits sucrés	biscuits sucrés	-	24060	Biscuit pâtissier meringué	7.42	56	30.7	\N
7	706	0	produits sucrés	biscuits sucrés	-	24070	Sablé à la noix de coco	7.1	66.5	20.1	\N
7	706	0	produits sucrés	biscuits sucrés	-	24071	Sablé pâtissier, artisanal	8.38	59.4	22.9	\N
7	706	0	produits sucrés	biscuits sucrés	-	24072	Sablé aux fruits (pomme, fruits rouges, etc.)	5.85	66	21.1	\N
7	706	0	produits sucrés	biscuits sucrés	-	24080	Sablé au cacao ou chocolat, au praliné ou autre	6.63	61.2	24.6	\N
7	706	0	produits sucrés	biscuits sucrés	-	24225	Goûter sec fourré ("sandwiché") parfum lait ou vanille	5.36	71.2	18.6	\N
7	706	0	produits sucrés	biscuits sucrés	-	24231	Goûter sec fourré ("sandwiché") parfum chocolat	6.7	67.9	18	\N
7	706	0	produits sucrés	biscuits sucrés	-	24240	Goûter sec fourré ("sandwiché") parfum fruits	6.64	73.3	17.4	\N
7	706	0	produits sucrés	biscuits sucrés	-	24300	Gaufrette ou éventail sans fourrage	9	76.8	8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24311	Gaufrette fourrée chocolat, préemballée	6.38	57.2	29.8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24312	Gaufrette fourrée fruits à coque (noisette, amande, praline, etc.), chocolatée ou non, préemballée	7.31	59.6	26.4	\N
7	706	0	produits sucrés	biscuits sucrés	-	24313	Gaufrette, fourrée vanille, préemballée	5.75	60.1	30.1	538
7	706	0	produits sucrés	biscuits sucrés	-	24320	Gaufrette fourrée, aux fruits	4.43	82.4	1.58	\N
7	706	0	produits sucrés	biscuits sucrés	-	24360	Cigarette	5.29	63	27.5	\N
7	706	0	produits sucrés	biscuits sucrés	-	24370	Crêpe dentelle	6.27	72.1	15.5	\N
7	706	0	produits sucrés	biscuits sucrés	-	24371	Crêpe dentelle au chocolat, préemballée	5.91	67.9	21.8	\N
7	706	0	produits sucrés	biscuits sucrés	-	24430	Biscuit sec aux oeufs à la cuillère (cuiller) ou Boudoir	7.98	79.9	3.77	\N
7	706	0	produits sucrés	biscuits sucrés	-	24441	Biscuit sec type langue de chat ou cigarette russe	5.66	77.9	10.7	\N
7	706	0	produits sucrés	biscuits sucrés	-	24520	Meringue	4.06	94.3	0.5	\N
7	706	0	produits sucrés	biscuits sucrés	-	24615	Biscuit sec ou tuile, aux amandes	7.8	68	18.1	471
7	706	0	produits sucrés	biscuits sucrés	-	24616	Biscuit sec type tuile, aux fruits	5.43	74.9	8.28	384
7	706	0	produits sucrés	biscuits sucrés	-	24659	Biscuit sec feuilleté, type palmier ou autres	6.1	60.5	27.6	\N
7	706	0	produits sucrés	biscuits sucrés	-	24660	Palmier, artisanal	5.93	53.1	28.2	\N
7	706	0	produits sucrés	biscuits sucrés	-	24678	Biscuit sec (génoise) nappage aux fruits, type barquette	4.44	74.4	2.1	341
7	706	0	produits sucrés	biscuits sucrés	-	24679	Biscuit sec nappé aux fruits, tartelette	4.7	71.3	14.2	\N
7	706	0	produits sucrés	biscuits sucrés	-	24680	Biscuit moelleux fourré à l orange et enrobé de sucre glace	4.25	79.3	1.92	\N
7	706	0	produits sucrés	biscuits sucrés	-	24684	Cookie aux pépites de chocolat	6.47	59	25.9	\N
7	706	0	produits sucrés	biscuits sucrés	-	24685	Cône ou cornet classique, pour glace	7.5	80.4	5	\N
7	706	0	produits sucrés	biscuits sucrés	-	24686	Génoise sèche fourrée aux fruits et nappée de chocolat	3.23	69.5	10.6	\N
7	706	0	produits sucrés	biscuits sucrés	-	24690	Biscuit sec pauvre en glucides	20.8	43.8	18.5	\N
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32000	Grains de blé soufflés au miel ou caramel, enrichis en vitamines et minéraux	8	82.2	2.2	391
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32001	Céréales pour petit déjeuner chocolatées, non fourrées, enrichies en vitamines et minéraux	8.13	70.4	8.9	408
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32002	Céréales pour petit déjeuner riches en fibres, avec ou sans fruits, enrichies en vitamines et minéraux	11.5	59.3	4.42	360
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32003	Céréales pour petit déjeuner (aliment moyen)	7.81	75.3	6.08	398
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32004	Muesli (aliment moyen)	7.49	66.6	12.2	418
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32005	Pétales de maïs natures, enrichis en vitamines et minéraux	7.4	83.2	0.87	377
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32006	Riz soufflé nature, enrichi en vitamines et minéraux	7	87	1.5	391
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32008	Céréales pour petit déjeuner riches en fibres, au chocolat, enrichies en vitamines et minéraux	11.5	64	6.75	386
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32009	Pétales de blé chocolatés, enrichis en vitamines et minéraux	9.04	77.7	3.24	388
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32011	Pétales de blé chocolatés (non enrichis en vitamines et minéraux)	8.48	80.1	2.64	388
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32012	Riz soufflé chocolaté (non enrichi en vitamines et minéraux)	6.31	84.2	2.2	388
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32013	Céréales chocolatées pour petit déjeuner, non fourrées, (non enrichies en vitamines et minéraux)	7.73	79.6	2.93	386
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32014	Pétales de maïs natures (non enrichis en vitamines et minéraux)	8.14	82.8	1.05	380
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32016	Céréales pour petit déjeuner fourrées au chocolat ou chocolat-noisettes, enrichies en vitamines et minéraux	7.81	69.2	13	433
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32017	Céréales pour petit déjeuner fourrées au chocolat ou chocolat-noisettes	7.33	67.2	14.8	442
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32018	Céréales pour petit déjeuner fourrées, fourrage autre que chocolat, enrichies en vitamines et minéraux	8.42	64.7	13.3	419
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32021	Céréales pour petit déjeuner "équilibre" nature ou au miel, enrichies en vitamines et minéraux	11.4	78.6	1.65	382
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32022	Céréales pour petit déjeuner "équilibre" au chocolat, enrichies en vitamines et minéraux	7.5	73.9	5.9	394
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32023	Céréales pour petit déjeuner "équilibre" aux fruits, enrichies en vitamines et minéraux	10.5	77.9	1.74	378
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32025	Céréales pour petit déjeuner "équilibre" aux fruits secs (à coque), enrichis en vitamines et minéraux	9.77	75.5	4.93	394
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32028	Céréales pour petit déjeuner "équilibre" au chocolat (non enrichies en vitamines et minéraux)	10.3	74.6	7.01	411
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32029	Céréales pour petit déjeuner "équilibre" aux fruits (non enrichies en vitamines et minéraux)	10.5	78.7	1.4	378
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32030	Céréales pour petit déjeuner "équilibre" nature (non enrichies en vitamines et minéraux)	11.3	79	1.25	379
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32031	Céréales pour petit déjeuner, enrichies en vitamines et minéraux (aliment moyen)	7.51	75	6.77	401
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32032	Céréales pour petit déjeuner, non enrichies en vitamines et minéraux (aliment moyen)	8.26	79.2	3.24	388
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32107	Pétales de maïs glacés au sucre (non enrichis en vitamines et minéraux)	4.4	88	0.6	379
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32108	Muesli croustillant aux fruits et/ou fruits secs, graines (non enrichi en vitamines et minéraux)	8.88	59.7	16.7	436
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32109	Muesli croustillant au chocolat (non enrichi en vitamines et minéraux)	8.57	63.2	16.7	442
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32110	Muesli floconneux aux fruits ou fruits secs, enrichi en vitamines et minéraux	9.19	65.4	5	361
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32111	Muesli croustillant aux fruits ou fruits secs, enrichi en vitamines et minéraux	5.67	68.4	17.3	460
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32112	Muesli croustillant au chocolat, avec ou sans fruits, enrichi en vitamines et minéraux	9.13	62.7	16.7	451
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32113	Muesli floconneux aux fruits ou fruits secs, sans sucres ajoutés	10.7	61.6	11	400
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32115	Grains de blé soufflés chocolatés, enrichis en vitamines et minéraux	8.82	75.2	4.01	385
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32116	Céréales pour petit déjeuner très riches en fibres, enrichies en vitamines et minéraux	14	49	3.5	338
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32121	Pétales de maïs glacés au sucre, enrichis en vitamines et minéraux	5.77	84.7	0.63	374
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32123	Pétales de blé avec noix, noisettes ou amandes, enrichis en vitamines et minéraux	10.3	67.9	6.3	386
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32128	Muesli floconneux ou de type traditionnel	10.6	68.5	4.83	382
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32129	Boules de maïs soufflées au miel (non enrichies en vitamines et minéraux)	5.71	86.2	2.35	393
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32130	Blé khorasan complet soufflé	7.32	80.5	1.96	378
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32131	Riz soufflé chocolaté, enrichi en vitamines et minéraux	6.22	83.2	2.82	390
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32133	Boules de maïs soufflées au miel, enrichies en vitamines et minéraux	5.5	85.3	1.8	384
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32134	Céréales complètes soufflées, enrichies en vitamines et minéraux	7.95	76.8	3.85	385
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32135	Multi-céréales soufflées ou extrudées, enrichies en vitamines et minéraux	7.39	79.4	4.27	392
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32136	Muesli croustillant, au quinoa	10.9	71.2	10.7	\N
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32138	Muesli floconneux aux fruits ou fruits secs (non enrichi en vitamines et minéraux)	9.5	61.7	6.9	369
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32139	Muesli enrichi en vitamines et minéraux (aliment moyen)	6.96	67.3	12.8	424
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32140	Flocon d avoine précuit	11.7	58	7.7	370
7	707	0	produits sucrés	céréales de petit-déjeuner	-	32141	Muesli non enrichi en vitamines et minéraux (aliment moyen)	9.2	60.7	11.6	401
7	708	0	produits sucrés	barres céréalières	-	31100	Barre céréalière pour petit déjeuner au lait, chocolatée ou non, enrichie en vitamines et minéraux	7.06	79.5	3.2	382
7	708	0	produits sucrés	barres céréalières	-	31101	Barre céréalière "équilibre" aux fruits, enrichie en vitamines et minéraux	6.13	72.8	6.53	379
7	708	0	produits sucrés	barres céréalières	-	31102	Barre céréalière "équilibre" chocolatée, enrichie en vitamines et minéraux	5.99	72.9	10.9	418
7	708	0	produits sucrés	barres céréalières	-	31104	Barre céréalière diététique hypocalorique	5.9	65.3	11.2	386
7	708	0	produits sucrés	barres céréalières	-	31106	Barre céréalière chocolatée	6.55	73	14.9	451
7	708	0	produits sucrés	barres céréalières	-	31113	Barre céréalière aux fruits	5.49	73.5	7.07	377
7	708	0	produits sucrés	barres céréalières	-	31114	Barre céréalière aux amandes ou noisettes	8.69	60.6	18.2	444
7	708	0	produits sucrés	barres céréalières	-	31115	Barre céréalière chocolatée aux fruits	5.7	70.4	11.8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	19688	Baba au rhum, préemballé	2.83	23.6	3.86	169
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23000	Gâteau (aliment moyen)	5.27	53.5	17.8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23005	Gâteau Paris-Brest (pâte à choux crème mousseline praliné)	5.44	26.1	24.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23006	Gâteau au chocolat type forêt noire (génoise au chocolat et crème multi-couches, avec ou sans cerises)	4.13	34.2	19	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23007	Gâteau mousse de fruits sur génoise, type miroir, bavarois	3.87	31.6	12.2	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23008	Entremets type Opéra	5.19	39.6	24	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23009	Fraisier ou framboisier	3.31	26.7	15.5	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23021	Baba au rhum	2.25	36.3	9.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23022	Canelé	5.2	59.4	3.7	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23024	Macaron moelleux fourré à la confiture ou à la crème	10	49.7	21.2	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23030	Bûche de Noël pâtissière	4.2	30.7	19.7	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23032	Brownie au chocolat, préemballé	5.94	50.6	25.4	458
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23033	Rocher coco ou Congolais (petit gâteau à la noix de coco)	4.46	53.7	24.1	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23050	Biscuit de Savoie	6.05	56.3	0.8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23080	Quatre-quarts, fabrication artisanale	5.94	46	25.6	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23081	Quatre-quarts, préemballé	5.94	48.2	23.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23082	Barre pâtissière, préemballé	5.38	54.7	14.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23103	Gâteau au citron, tout type	5	54	21.3	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23121	Far aux pruneaux	5.13	32	8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23122	Kouign Amann	5.81	48.7	25.1	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23200	Pain d épices	2.94	71.5	1.1	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23220	Pain d épices fourré ou nonette	4	76	2.5	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23300	Baklava ou Baklawa (pâtisserie orientale aux amandes et sirop)	10.4	49.2	24.5	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23301	Corne de gazelle (pâtisserie orientale aux amandes et sirop)	8.55	60.2	22.1	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23455	Chou à la crème (chantilly ou pâtissière)	4.5	25.2	22.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23456	Chou à la crème chantilly, Saint-honoré	4.63	22.9	26.4	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23457	Chou à la crème pâtissière	4.31	34.9	7.3	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23477	Éclair	5.78	31.6	11.8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23479	Tarte aux fruits et crème pâtissière	2.94	30	7.7	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23481	Tarte normande aux pommes (garniture farine, oeufs, crème, sucre, calvados)	4.44	38.7	15	313
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23485	Tarte au citron	5	42.7	20.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23490	Tarte ou tartelette aux pommes	2.52	32.7	8.79	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23491	Tarte aux fraises	3.19	31	19.8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23493	Crumble aux pommes	2.19	33.8	9.5	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23494	Tarte aux abricots	3.18	41	10.7	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23495	Tarte aux fruits rouges	3.5	38.5	6.87	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23496	Tarte Tatin aux pommes	2.31	37.1	9.3	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23497	Tarte au chocolat, fabrication artisanale	5.94	40.9	30.7	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23499	Tarte ou tartelette aux fruits	3.72	46.9	10.6	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23525	Flan pâtissier aux oeufs ou à la parisienne	3.69	29.2	11.3	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23531	Charlotte aux fruits	5.16	28.2	6.64	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23585	Gâteau au chocolat	5.74	54.6	21.6	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23586	Gâteau moelleux au chocolat, préemballé	6.19	48.2	24	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23588	Gâteau au yaourt	5.87	51.8	21.4	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23589	Gâteau au fromage blanc	6.17	27	11.6	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23594	Gâteau moelleux nature type génoise	5.7	57.6	14.4	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23680	Galette des rois feuilletée	5	29.8	23.3	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23684	Galette des rois feuilletée, fourrée frangipane, et Pithiviers	7.6	33.4	30	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23799	Crêpe, nature, préemballée, rayon frais	6.49	40	7.21	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23800	Crêpe, nature, préemballée, rayon température ambiante	8.5	58.1	14.1	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23801	Galette de sarrasin, nature, préemballée	5.95	30.1	1.51	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23802	Gâteau basque, crème pâtissière	4.03	57.4	13.3	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23803	Gâteau basque, cerises	4.3	63.3	13.5	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23815	Crêpe fourrée au sucre, préemballée	6.62	58.7	15.8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23820	Crêpe fourrée à la confiture, maison	6.51	54	5.74	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23821	Crêpe fourrée au chocolat ou à la pâte à tartiner chocolat et noisettes, maison	8.1	54.3	14.6	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23829	Crêpe fourrée chocolat, préemballée	6.43	58.7	20.4	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23830	Crêpe fourrée fraise, préemballée	5.35	66.7	6.6	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23849	Gaufre fine fourrée au miel, préemballée	4.56	67	18.3	455
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23850	Gaufre bruxelloise ou liégeoise, préparation artisanale	8	36.1	13.4	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23851	Gaufre moelleuse (type bruxelloise ou liégeoise), nature ou sucrée, préemballée	7.1	52.5	25.2	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23852	Gaufre moelleuse (type bruxelloise ou liégeoise), chocolatée, préemballée	6.1	55.9	23.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23853	Gaufre croustillante (fine ou sèche), nature ou sucrée, préemballée	5.18	66.4	17.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23854	Gaufre croustillante (fine ou sèche), chocolatée, préemballée	6.9	70	16	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23880	Beignet rond moelleux, sans fourrage, saupoudré de sucre	7.25	39.4	23.7	404
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23881	Beignet à la confiture	6.36	45.6	18.7	378
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23884	Beignet fourré aux fruits, préemballé	5.65	47.6	16	362
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23885	Beignet fourré goût chocolat, préemballé	7.31	45.9	22.5	420
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23900	Pâtisserie (aliment moyen)	5.03	44	17.2	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23909	Cake aux fruits, préemballé	4.19	55.2	12.6	360
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23925	Gâteau marbré, prémballé	5.76	50.5	23	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23930	Gâteau sablé aux fruits, préemballé	5.13	63.9	16.3	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23937	Gâteau moelleux aux fruits, prémballé	4.61	61.6	14.8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23938	Gâteau moelleux aux fruits à coque, prémballé	6.2	48.8	25.5	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23939	Gâteau moelleux fourré au chocolat ou aux pépites de chocolat ou au lait, prémballé	5.31	60.7	21.7	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23940	Génoise fourrée et nappée au chocolat, prémballé	5.46	53.3	20.8	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23941	Gâteau moelleux fourré aux fruits type mini-roulé ou mini-cake fourré, prémballé	4.41	64.2	6.5	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	23950	Muffin, aux myrtilles ou au chocolat	5.59	48.9	23.4	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	24630	Madeleine, pur beurre, préemballée	5.6	52.6	25.5	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	24631	Madeleine au chocolat, préemballée	6.06	51.5	24.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	24632	Madeleine ordinaire, préemballée	5.2	53.5	25.2	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	24663	Tarte aux poires amandine	4.9	37.7	14.9	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	24664	Gâteau aux amandes type financier	9.1	44.3	27.4	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	24665	Gâteau aux amandes, préemballé	5.78	60.1	17.3	\N
7	709	0	produits sucrés	gâteaux et pâtisseries	-	24666	Mille-feuille	3.88	43.7	11.3	\N
8	0	0	glaces et sorbets	-	-	39500	Glace à l eau ou sorbet ou crème glacée, tout parfum (aliment moyen)	2.66	32.2	12	\N
8	801	0	glaces et sorbets	glaces	-	31035	Barre glacée chocolatée	5.12	35.8	21.4	359
8	801	0	glaces et sorbets	glaces	-	39503	Glace ou crème glacée, bâtonnet, enrobé de chocolat	3.35	33.4	19.8	328
8	801	0	glaces et sorbets	glaces	-	39509	Glace ou crème glacée, cône (taille standard)	3.44	37.8	13.5	\N
8	801	0	glaces et sorbets	glaces	-	39515	Glace ou crème glacée, en bac	2.5	26.1	8.4	\N
8	801	0	glaces et sorbets	glaces	-	39517	Glace au yaourt	3.38	22.7	2.2	\N
8	801	0	glaces et sorbets	glaces	-	39520	Glace ou crème glacée, gourmande, en bac	2.99	29	10.7	\N
8	801	0	glaces et sorbets	glaces	-	39521	Glace ou crème glacée, gourmande, en pot	4.13	24.2	17.9	\N
8	801	0	glaces et sorbets	glaces	-	39522	Glace ou crème glacée, mini cône	4.11	38.5	20.2	\N
8	801	0	glaces et sorbets	glaces	-	39523	Glace ou crème glacée, pot individuel	3.15	26.7	12.7	\N
8	801	0	glaces et sorbets	glaces	-	39527	Glace ou crème glacée, bac ou pot (aliment moyen)	2.81	24.9	6.21	\N
8	801	0	glaces et sorbets	glaces	-	39531	Glace ou crème glacée, petit pot enfant	1.83	25.2	5.94	\N
8	802	0	glaces et sorbets	sorbets	-	31013	Sorbet, bâtonnet	0.28	25.7	0.32	\N
8	802	0	glaces et sorbets	sorbets	-	39524	Sorbet, en bac	0.46	29.6	0.78	\N
8	802	0	glaces et sorbets	sorbets	-	39525	Sorbet, pot individuel	\N	27	2.5	\N
8	802	0	glaces et sorbets	sorbets	-	39526	Glace à l eau	0.066	20.8	0.2	\N
8	802	0	glaces et sorbets	sorbets	-	39528	Sorbet, cône	2.04	39.3	6.74	\N
8	803	0	glaces et sorbets	desserts glacés	-	23472	Profiterole avec glace vanille et sauce chocolat	5.38	31.4	14.9	286
8	803	0	glaces et sorbets	desserts glacés	-	39401	Pêche melba	2.02	18.8	3.62	119
8	803	0	glaces et sorbets	desserts glacés	-	39502	Dessert glacé type mystère ou vacherin	3.12	40.5	10.7	275
8	803	0	glaces et sorbets	desserts glacés	-	39512	Dessert glacé, type sundae	2.52	32.6	9.7	230
8	803	0	glaces et sorbets	desserts glacés	-	39516	Dessert glacé feuilleté, à partager	2.65	26.2	16.1	262
8	803	0	glaces et sorbets	desserts glacés	-	39518	Omelette norvégienne	3.6	34.8	6.5	212
8	803	0	glaces et sorbets	desserts glacés	-	39519	Poire belle Hélène	2.68	23.5	9.57	196
8	803	0	glaces et sorbets	desserts glacés	-	39529	Nougat glacé	4.83	25.3	15.2	263
8	803	0	glaces et sorbets	desserts glacés	-	39530	Citron givré ou Orange givrée (sorbet)	0.14	29.1	1.77	133
8	803	0	glaces et sorbets	desserts glacés	-	39532	Coupe glacée type café ou chocolat liégeois	2.98	28.6	10	220
8	803	0	glaces et sorbets	desserts glacés	-	39533	Bûche glacée	2.42	30	10.4	226
8	803	0	glaces et sorbets	desserts glacés	-	39534	Coupe glacée parfum pêche Melba ou poire Belle-Hélène	0.89	32.2	3.36	163
9	901	0	matières grasses	beurres	-	16400	Beurre à 82% MG, doux	0.69	0.9	82.9	753
9	901	0	matières grasses	beurres	-	16401	Huile de beurre ou Beurre concentré	0.27	0	99.9	\N
9	901	0	matières grasses	beurres	-	16402	Beurre à 80% MG, demi-sel	0.72	0.55	81.4	738
9	901	0	matières grasses	beurres	-	16403	Beurre à 80% MG, salé	0.5	0.68	80.8	732
9	901	0	matières grasses	beurres	-	16410	Beurre à 60-62% MG, à teneur réduite en matière grasse, doux	0.56	0.7	60.6	550
9	901	0	matières grasses	beurres	-	16411	Beurre à 60-62% MG, à teneur réduite en matière grasse, demi-sel	0.9	0.5	61	555
9	901	0	matières grasses	beurres	-	16412	Beurre ou assimilé allégé (léger ou à teneur reduite en matière grasse), doux (aliment moyen)	0.33	3.73	38.9	368
9	901	0	matières grasses	beurres	-	16413	Beurre à teneur en matière grasse inconnue (allégé ou non), demi-sel (aliment moyen)	0.73	0.55	80.2	727
9	901	0	matières grasses	beurres	-	16414	Beurre ou assimilé à teneur en matière grasse inconnue, doux (aliment moyen)	0.68	0.99	81.5	741
9	901	0	matières grasses	beurres	-	16415	Beurre à 39-41% MG, léger, doux	0.5	3.6	41.7	391
9	901	0	matières grasses	beurres	-	16712	Matière grasse laitière à 25% MG, légère, "à tartiner", doux	0.4	3.8	25.6	247
9	901	0	matières grasses	beurres	-	16713	Matière grasse laitière à 20% MG, légère, "à tartiner", doux	0.5	6.2	19.1	201
9	902	0	matières grasses	huiles et graisses végétales	-	16030	Huile ou beurre de cacao	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	16040	Huile ou graisse de coco (coprah), sans précision	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	16060	Huile ou graisse de coco (coprah), raffinée	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	16080	Matière grasse ou graisse végétale solide (type margarine) pour friture	0.5	0	99.8	899
9	902	0	matières grasses	huiles et graisses végétales	-	16110	Huile ou beurre de karité	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	16128	Huile pour friture, sans précision	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	16129	Huile de palme, sans précision	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	16150	Huile de palme raffinée	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	16200	Huile ou graisse de palmiste, sans précision	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17001	Huile végétale (aliment moyen)	0.21	0	99.9	900
9	902	0	matières grasses	huiles et graisses végétales	-	17020	Huile d amandes d abricot	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17030	Huile d amande	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17040	Huile d arachide	0.5	0	99.9	900
9	902	0	matières grasses	huiles et graisses végétales	-	17100	Huile d avocat	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17110	Huile de germe de blé	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17126	Huile de carthame	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17130	Huile de colza	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17170	Huile de coton	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17180	Huile de lin	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17190	Huile de maïs	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17210	Huile de noisette	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17220	Huile de noix	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17270	Huile d olive vierge extra	0.5	0	99.9	900
9	902	0	matières grasses	huiles et graisses végétales	-	17325	Huile de pavot	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17350	Huile de pépins de raisin	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17390	Huile de son de riz	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17400	Huile de sésame	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17420	Huile de soja	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17440	Huile de tournesol	0.5	0	100	901
9	902	0	matières grasses	huiles et graisses végétales	-	17700	Huile combinée (mélange d huiles)	0	0	99.5	896
9	902	0	matières grasses	huiles et graisses végétales	-	17701	Huile combinée, mélange d huile d olive et de graines	0	0	100	900
9	902	0	matières grasses	huiles et graisses végétales	-	17900	Huile d argan ou d argane	0	0	98.7	889
9	903	0	matières grasses	margarines	-	16614	Matière grasse végétale (type margarine) à 80% MG, salée	0.5	0.5	80	722
9	903	0	matières grasses	margarines	-	16615	Matière grasse végétale ou margarine, 80% MG, doux	0.39	0.3	80.4	726
9	903	0	matières grasses	margarines	-	16616	Matière grasse végétale (type margarine) à 70% MG, doux	0.13	0.24	70	631
9	903	0	matières grasses	margarines	-	16654	Matière grasse végétale (type margarine) à 60% de MG, allégée, au tournesol, doux	0.5	0.55	60.6	548
9	903	0	matières grasses	margarines	-	16719	Matière grasse végétale (type margarine), teneur en matière grasse inconue, doux (aliment moyen)	0.16	0.24	67.4	608
9	903	0	matières grasses	margarines	-	16725	Matière grasse végétale (type margarine), teneur réduite en matière grasse inconnue, doux (aliment moyen)	0.28	0.24	58.9	532
9	903	0	matières grasses	margarines	-	16733	Matière grasse végétale (type margarine), à tartiner, à 30-40% MG, légère, doux	1.44	3	38.6	366
9	903	0	matières grasses	margarines	-	16734	Matière grasse végétale (type margarine), à tartiner, à 30-40% MG, légère, demi-sel	0.9	3.05	38	358
9	903	0	matières grasses	margarines	-	16736	Matière grasse végétale (type margarine), à tartiner, à 30-40% MG, légère, doux, riche en oméga 3	0	0	38.8	349
9	903	0	matières grasses	margarines	-	16737	Matière grasse végétale (type margarine) à 50-63% MG, allégée, doux, riche en oméga 3	0.15	0.18	57.8	521
9	903	0	matières grasses	margarines	-	16738	Matière grasse végétale (type margarine) à 50-63% MG, allégée, demi-sel	0.2	0.2	58	523
10	1005	0	aides culinaires et ingrédients divers	épices	-	11065	Vanille, extrait alcoolique	0.05	2.41	0	240
9	903	0	matières grasses	margarines	-	16739	Matière grasse végétale (type margarine) à 50-63% MG, allégée, doux, aux esters de stérol végétal	0.5	0	60.8	548
9	903	0	matières grasses	margarines	-	16740	Matière grasse végétale (type margarine) à 50-63% MG, allégée, demi-sel, riche en oméga 3	0.083	0.12	54.5	491
9	903	0	matières grasses	margarines	-	16741	Matière grasse végétale (type margarine) à 50-63% MG, allégée, doux	0.5	0.18	59.3	536
9	903	0	matières grasses	margarines	-	16742	Matière grasse végétale (type margarine) à 30-40% MG, légère, demi-sel, aux esters de stérol végétal	0.1	2.5	35	325
9	903	0	matières grasses	margarines	-	16743	Matière grasse mélangée (végétale et laitière) à 50-63% MG	0.4	0.6	54	490
9	903	0	matières grasses	margarines	-	16744	Matière grasse mélangée (végétale et laitière) à 50-63% MG, demi-sel	0.4	0.6	53	481
9	903	0	matières grasses	margarines	-	16745	Matière grasse mélangée (végétale et laitière), à tartiner, à 30-40% MG	1.69	5.6	40.9	397
9	903	0	matières grasses	margarines	-	16746	Matière grasse mélangée (végétale et laitière), à tartiner, à 30-40% MG, demi-sel	1.5	5.6	38	370
9	904	0	matières grasses	huiles de poissons	-	17630	Huile de foie de morue	0	0	100	900
9	904	0	matières grasses	huiles de poissons	-	17640	Huile de sardine	0	0	100	900
9	904	0	matières grasses	huiles de poissons	-	17645	Huile de saumon	0	0	100	900
9	904	0	matières grasses	huiles de poissons	-	17650	Huile de hareng	0	0	100	900
9	905	0	matières grasses	autres matières grasses	-	16520	Saindoux	0	0	99.5	896
9	905	0	matières grasses	autres matières grasses	-	16530	Lard gras, cru	2.92	0	88.7	810
9	905	0	matières grasses	autres matières grasses	-	16540	Graisse de poulet	0	0	99.8	898
9	905	0	matières grasses	autres matières grasses	-	16550	Graisse de canard	0	0	99.8	898
9	905	0	matières grasses	autres matières grasses	-	16560	Graisse d oie	0	0	99.8	898
9	905	0	matières grasses	autres matières grasses	-	16570	Graisse de dinde	0	0	99.8	898
9	905	0	matières grasses	autres matières grasses	-	17999	Huile de paraffine	0	0	0	0
10	1001	0	aides culinaires et ingrédients divers	sauces	-	11184	Sauce (aliment moyen)	1.3	6.04	25.7	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11008	Ketchup, préemballé	1.27	21.4	0.19	99
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11051	Sauce tartare, préemballée	0.99	4.6	55	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11054	Mayonnaise (70% MG min.), préemballée	1.36	2.62	75.2	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11073	Ketchup allégé en sucres, préemballé	1.21	14.6	0.11	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11079	Mayonnaise à teneur réduite en matière grasse ou Mayonnaise allégée, préemballée	0.93	8.98	29.9	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11100	Sauce barbecue, préemballée	0.56	30.3	0.6	136
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11104	Sauce soja, préemballée	7.08	3.64	0.1	45.5
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11108	Sauce vinaigrette à l huile d olive (50 à 75% d huile), préemballée	0.53	4.54	52.8	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11109	Sauce vinaigrette allégée en MG (25 à 50% d huile), préemballée	0.5	2.39	26.4	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11110	Sauce vinaigrette (50 à 75% d huile), préemballée	0.54	4.56	52.4	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11112	Harissa (sauce condimentaire), préemballée	2.72	7.3	2.9	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11120	Sauce bourguignonne, préemballée	1.25	7.85	43.9	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11157	Sauce moutarde, préemballée	1.66	3.3	22.8	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11166	Sauce au yaourt	3.64	5.04	6.91	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11167	Sauce américaine, préemballée	1.42	9.48	41.8	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11168	Sauce aïoli, préemballée	1.13	4.7	41	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11187	Sauce crudités ou Sauce salade, préemballée	0.86	5.3	30.9	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11194	Sauce Nuoc Mâm ou Sauce au poisson, préemballée	9.3	10.9	0	81.2
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11196	Sauce burger, préemballée	1.06	13.3	33.8	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11198	Sauce crudités ou Sauce salade, allégée en matière grasse, préemballée	0.76	7.26	14.3	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11203	Sauce kebab, préemballée	1.1	9.15	27.6	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11205	Sauce rouille, préemballée	1.1	1	41.4	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11212	Sauce au poivre, condimentaire, froide, préemballée	0.69	5.8	49.3	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11213	Sauce froide (aliment moyen)	0.86	5.73	31.6	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11215	Caviar de tomates	2.19	6.8	19.2	218
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11216	Sauce soja sucrée, préemballée	2.88	\N	0.5	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11217	Sauce pour nems à base de nuoc-mam dilué, préemballée	1.38	31.2	0.5	135
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11219	Sauce végétale type bolognaise, préemballée	3.56	5.05	3	68
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	11301	Sauce teriyaki, préemballée	3.82	16	1.06	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	19863	Tzatziki, à base yaourt, préemballé	6.06	3.8	10.9	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	19864	Tzatziki, à base fromage frais, préemballé	6.73	3.28	11.1	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	25620	Guacamole, préemballé	2.18	5.85	16.5	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	25621	Houmous, préemballé	8.2	7.1	23.9	\N
10	1001	100101	aides culinaires et ingrédients divers	sauces	sauces condimentaires	25624	Caviar d aubergine, préemballé	0.71	4.3	21	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11101	Sauce béchamel, préemballée	2.56	6.2	7.4	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11102	Sauce béarnaise, préemballée	0.88	4.52	47.7	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11105	Sauce hollandaise, préemballée	1.19	4.58	19.8	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11107	Sauce tomate aux oignons, préemballée	1.52	7.69	4.18	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11111	Sauce armoricaine, préemballée	2.1	3.95	6.6	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11114	Sauce tomate à la viande ou Sauce bolognaise, préemballée	4.22	7.27	4.81	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11115	Sauce au poivre vert, préemballée	1.3	5.3	6.1	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11121	Sauce madère, préemballée	0.6	3.6	2.2	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11122	Sauce à l échalote à la crème, préemballée	1.7	11.9	5.53	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11128	Sauce carbonara, préemballée	5.17	4.7	12.8	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11129	Sauce chasseur, préemballée	1.21	4.66	1.61	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11132	Sauce au curry, préemballée	1.02	10.6	3.16	77.4
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11140	Sauce au beurre blanc, préemballée	1.13	3.4	21.4	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11143	Sauce béchamel, maison	3.84	8.97	10.6	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11158	Sauce au beurre, préemballée	2.2	5.2	17.9	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11159	Sauce à la crème	1.08	5.9	5.55	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11160	Sauce aux champignons, préemballée	3.2	6.3	6.26	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11161	Sauce à la crème aux épices	1.16	6.2	5.75	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11162	Sauce à la crème aux herbes	1.09	5.5	5.49	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11163	Sauce aigre douce, préemballée	0.55	20.1	0.2	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11164	Sauce au vin rouge	0.81	7	2.22	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11170	Sauce basquaise ou Sauce aux poivrons, préemballée	1.17	7.41	2.71	63.1
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11177	Sauce tomate aux champignons, préemballée	1.79	7.78	2.68	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11178	Sauce tomate aux olives, préemballée	1.41	7.5	7.32	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11179	Sauce pesto, préemballée	3.94	6.6	35.4	370
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11182	Sauce au poivre, chaude, préemballée	1	4.8	14.8	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11189	Sauce au fromage pour risotto ou pâtes, préemballée	3.11	4.24	9.53	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11191	Sauce au roquefort, préemballée	2.85	4.4	10.9	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11192	Sauce aux champignons et à la crème, préemballée	1.38	6.2	5	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11199	Sauce grand veneur, préemballée	1.5	8.45	7	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11202	Sauce indienne type tandoori ou tikka masala, préemballée	2.6	14.3	1.7	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11207	Sauce tomate aux petits légumes, préemballée	1.54	7.57	2.9	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11208	Sauce tomate au fromage, préemballée	3.94	8.09	14.2	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11210	Sauce pesto rosso, préemballée	4.8	8.58	27	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11218	Sauce chaude (aliment moyen)	2.66	7.03	7.45	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	11302	Sauce à l oseille, préemballée	1.3	1.7	15	\N
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	25600	Céleri rémoulade, préemballé	0.94	3.14	10.2	113
10	1001	100102	aides culinaires et ingrédients divers	sauces	sauces chaudes	51502	Meloukhia, sauce, artisanale	1.13	0.2	21	\N
10	1001	100103	aides culinaires et ingrédients divers	sauces	sauces sucrées	11300	Sauce au chocolat, préemballée	3.8	26.2	16.8	277
10	1001	100103	aides culinaires et ingrédients divers	sauces	sauces sucrées	39700	Crème anglaise, préemballée	3.44	16.7	2.5	105
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11004	Cornichon, au vinaigre	1.06	0.78	0.6	19.4
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11013	Moutarde	6.92	4.33	11.2	152
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11018	Vinaigre	0.04	0.62	0.1	22.6
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11021	Moutarde à l ancienne	6.6	2.2	9.9	142
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11040	Câpres, au vinaigre	2.18	3.5	0.86	\N
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11043	Tapenade	1.3	2.6	23	\N
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11055	Oignon au vinaigre	0.56	2.5	0.2	\N
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11090	Vinaigre de cidre	0	0.93	0	\N
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11091	Vinaigre balsamique	0.69	25.8	0.6	125
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11097	Cornichon, aigre-doux	1.25	5	0.35	36
10	1002	0	aides culinaires et ingrédients divers	condiments	-	11220	Vinaigre de vin rouge	0.5	\N	0	21.6
10	1002	0	aides culinaires et ingrédients divers	condiments	-	13032	Olive noire, en saumure, égouttée	1.38	0.1	17.2	\N
10	1002	0	aides culinaires et ingrédients divers	condiments	-	13033	Olive verte, en saumure, égouttée	1.31	\N	15.7	155
10	1002	0	aides culinaires et ingrédients divers	condiments	-	13131	Olive noire, à l huile (à la grecque)	2.19	0.1	33.3	332
10	1002	0	aides culinaires et ingrédients divers	condiments	-	13147	Olives vertes, fourrées ou farcies (anchois, poivrons, etc.)	2.09	0.61	15.2	\N
10	1002	0	aides culinaires et ingrédients divers	condiments	-	13184	Olive (aliment moyen)	1.39	0.043	16.5	162
10	1002	0	aides culinaires et ingrédients divers	condiments	-	13186	Olive noire (aliment moyen)	1.49	0.05	19.5	\N
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	11001	Bouillon de boeuf, déshydraté	10.2	19.7	13.3	240
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	11169	Fond de veau pour sauces et cuisson, déshydraté	8.5	59.5	7.4	343
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	11171	Fond de volaille pour sauces et cuisson, déshydraté	7.4	66.3	4.9	341
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	11172	Court-bouillon pour poissons, déshydraté	5	7	23	260
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	11174	Bouillon de volaille, déshydraté	11.3	20.8	11.5	233
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	11175	Gelée au madère, déshydratée	44.5	17	0.2	248
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	11176	Gelée au madère	2	0.8	0.01	11.3
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	11304	Fond de veau, préemballé	3.15	2.4	2.05	40.9
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	25525	Pizza, sauce garniture pour	2.12	3.2	0.73	38.5
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	25918	Bouillon de viande et légumes type pot-au-feu, déshydraté	10.3	17.7	11.1	213
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	25970	Bouillon de viande et légumes type pot-au-feu, non dégraissé, déshydraté	11.6	28.9	5.4	212
10	1003	0	aides culinaires et ingrédients divers	aides culinaires	-	25971	Bouillon de viande et légumes type pot-au-feu, dégraissé, déshydraté	10.8	30.9	3.1	197
10	1004	0	aides culinaires et ingrédients divers	sels	-	11017	Sel blanc alimentaire, non iodé, non fluoré (marin, ignigène ou gemme)	0	0	0	0
10	1004	0	aides culinaires et ingrédients divers	sels	-	11044	Sel au céleri	1.81	4.14	2.53	49
10	1004	0	aides culinaires et ingrédients divers	sels	-	11058	Sel blanc alimentaire, iodé, non fluoré (marin, ignigène ou gemme)	0	0	0	0
10	1004	0	aides culinaires et ingrédients divers	sels	-	11082	Fleur de sel, non iodée, non fluorée	0	0	0	0
10	1004	0	aides culinaires et ingrédients divers	sels	-	11083	Sel marin gris, non iodé, non fluoré	0	0	0	0
10	1004	0	aides culinaires et ingrédients divers	sels	-	11096	Sel blanc alimentaire, iodé, fluoré à 25 mg /100 g (marin, ignigène ou gemme)	0	0	0	0
10	1005	0	aides culinaires et ingrédients divers	épices	-	11005	Curry, poudre	14.5	2.63	14	301
10	1005	0	aides culinaires et ingrédients divers	épices	-	11006	Gingembre, poudre	8.98	58.3	4.24	335
10	1005	0	aides culinaires et ingrédients divers	épices	-	11015	Poivre noir, poudre	13.3	39.5	7.5	330
10	1005	0	aides culinaires et ingrédients divers	épices	-	11019	Poivre blanc, poudre	11.4	48.3	2.11	310
10	1005	0	aides culinaires et ingrédients divers	épices	-	11025	Cannelle, poudre	3.87	27.5	1.22	243
10	1005	0	aides culinaires et ingrédients divers	épices	-	11026	Coriandre, graine	12.4	13	17.8	346
10	1005	0	aides culinaires et ingrédients divers	épices	-	11039	Safran	11.4	61.5	5.85	352
10	1005	0	aides culinaires et ingrédients divers	épices	-	11042	Cumin, graine	17.8	33.7	22.3	427
10	1005	0	aides culinaires et ingrédients divers	épices	-	11048	Noix de muscade	6.26	28.5	36.3	507
10	1005	0	aides culinaires et ingrédients divers	épices	-	11049	Paprika	14.1	19.1	12.9	319
10	1005	0	aides culinaires et ingrédients divers	épices	-	11052	Clou de girofle	5.97	31.6	13	335
10	1005	0	aides culinaires et ingrédients divers	épices	-	11053	Laurier, feuille	7.61	48.6	8.36	353
10	1005	0	aides culinaires et ingrédients divers	épices	-	11056	Quatre épices	6.09	50.5	8.69	348
10	1005	0	aides culinaires et ingrédients divers	épices	-	11057	Vanille, gousse	\N	\N	\N	\N
10	1005	0	aides culinaires et ingrédients divers	épices	-	11061	Pavot, graine	19.7	13.7	43.1	551
10	1005	0	aides culinaires et ingrédients divers	épices	-	11064	Carvi, graine	19.8	11.9	14.6	334
10	1005	0	aides culinaires et ingrédients divers	épices	-	11066	Fenouil, graine	15.7	12.5	14.9	326
10	1005	0	aides culinaires et ingrédients divers	épices	-	11074	Gingembre, racine crue	1.1	3.4	1.1	32.9
10	1005	0	aides culinaires et ingrédients divers	épices	-	11075	Cardamome, poudre	10.8	40.5	6.7	321
10	1005	0	aides culinaires et ingrédients divers	épices	-	11077	Fenugrec, graine	27.1	33.8	6.41	350
10	1005	0	aides culinaires et ingrédients divers	épices	-	11081	Epice (aliment moyen)	12.4	37.7	10.4	346
10	1005	0	aides culinaires et ingrédients divers	épices	-	11088	Poivre de Cayenne ou piment de Cayenne	12	29.4	17.3	376
10	1005	0	aides culinaires et ingrédients divers	épices	-	11089	Curcuma, poudre	9.68	44.4	3.25	291
10	1005	0	aides culinaires et ingrédients divers	épices	-	11098	Vanille, extrait aqueux	0.03	14.4	0	57.7
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11000	Ail, cru	5.31	18.6	0.5	111
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11002	Cerfeuil, frais	3.72	3.63	0.6	39.9
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11003	Ciboule ou Ciboulette, fraîche	2.57	2.1	0.52	29.7
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11014	Persil, frais	3.71	3.48	0.63	43
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11016	Raifort, cru	7.5	13	0.7	\N
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11027	Menthe, fraîche	3.52	5.3	0.84	57.6
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11033	Basilic, frais	3.35	2.55	0.47	34.8
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11068	Romarin, frais	3.31	6.6	5.86	121
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11069	Sauge, fraîche	4	0.97	0.5	36.7
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11070	Thym, frais	5.56	10.5	1.68	107
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11080	Herbes aromatiques fraîches (aliment moyen)	3.58	4.15	0.8	49.4
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11092	Estragon, frais	3.8	4.1	\N	44
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11093	Aneth, frais	3.93	3.9	1.1	48.2
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11094	Coriandre, fraiche	2.13	0.87	0.52	22.3
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11306	Ail, rôti/cuit au four	5.56	23.8	0.5	127
10	1006	100601	aides culinaires et ingrédients divers	herbes	herbes fraîches	11307	Ail, sauté/poêlé, sans matière grasse	6	22	0.4	130
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11023	Ail séché, poudre	16.7	62.8	0.77	344
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11024	Persil, séché	29	16.8	5.34	291
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11029	Menthe, séchée	19.9	22.2	6.03	283
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11032	Basilic, séché	23	10.1	4.07	244
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11034	Marjolaine, séchée	12.7	20.3	7.04	276
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11035	Origan, séché	9	26.4	4.28	265
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11036	Romarin, séché	4.88	21.5	15.2	328
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11037	Sauge, séchée	10.6	20.4	12.8	320
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11038	Thym, séché	9.11	26.9	7.43	285
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11060	Herbes de Provence, séchées	11.5	23	7.2	283
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	11062	Sarriette, séchée	6.73	23	5.91	264
10	1006	100602	aides culinaires et ingrédients divers	herbes	herbes séchées	51500	Meloukhia, feuilles de corète séchées, en poudre	23	12.7	1.8	239
10	1007	0	aides culinaires et ingrédients divers	algues	-	11084	Agar (algue), cru	0.54	6.25	0.03	\N
10	1007	0	aides culinaires et ingrédients divers	algues	-	11085	Agar (algue), séché	4.36	\N	0.3	\N
10	1007	0	aides culinaires et ingrédients divers	algues	-	11086	Spiruline (Spirulina sp.), séchée ou déshydratée	57.5	20.3	7.72	\N
10	1007	0	aides culinaires et ingrédients divers	algues	-	20984	Wakamé (Undaria pinnatifida), séchée ou déshydratée	14.1	5.7	2.51	184
10	1007	0	aides culinaires et ingrédients divers	algues	-	20985	Laitue de mer (Ulva sp.), séchée ou déshydratée	15.9	13.8	2.03	206
10	1007	0	aides culinaires et ingrédients divers	algues	-	20986	Kombu royal (Saccharina latissima), séchée ou déshydratée	10.3	23.6	1.07	204
10	1007	0	aides culinaires et ingrédients divers	algues	-	20987	Nori (Porphyra sp.), séchée ou déshydratée	31.5	10.5	1.63	255
10	1007	0	aides culinaires et ingrédients divers	algues	-	20988	Dulse (Palmaria palmata), séchée ou déshydratée	17.2	22.6	1.33	227
10	1007	0	aides culinaires et ingrédients divers	algues	-	20990	Kombu ou kombu japonais (Laminaria japonica), séchée ou déshydratée	8.38	24.2	2.65	224
10	1007	0	aides culinaires et ingrédients divers	algues	-	20991	Kombu breton (Laminaria digitata), séchée ou déshydratée	9.51	25.6	1.13	217
10	1007	0	aides culinaires et ingrédients divers	algues	-	20992	Haricot de mer (Himanthalia elongata), séchée ou déshydratée	10.1	28.3	2.63	239
10	1007	0	aides culinaires et ingrédients divers	algues	-	20993	Gracilaire ou ogonori (Gracilaria verrucosa), séchée ou déshydratée	16.5	18.8	3.54	243
10	1007	0	aides culinaires et ingrédients divers	algues	-	20994	Fucus vésiculeux (Fucus serratus ou Fucus vesiculosus), séché ou déshydraté	7.41	15.7	1.33	194
10	1007	0	aides culinaires et ingrédients divers	algues	-	20995	Ao-nori (Enteromorpha sp.), séchée ou déshydratée	13.7	18.8	2.47	224
10	1007	0	aides culinaires et ingrédients divers	algues	-	20996	Lichen de mer ou pioca ou goémon rouge (Chondrus crispus), séché ou déshydraté	16.6	21.5	2.3	234
10	1007	0	aides culinaires et ingrédients divers	algues	-	20998	Ascophylle noueux ou goémon noir (Ascophyllum nodosum), séché ou déshydraté	7.22	18.5	2.78	211
10	1007	0	aides culinaires et ingrédients divers	algues	-	20999	Wakamé atlantique (Alaria esculenta), séchée ou déshydratée	12.3	6.28	1.53	187
10	1008	0	aides culinaires et ingrédients divers	denrées destinées à une alimentation particulière	-	18350	Boisson diététique pour le sport	0.05	5.26	0.14	\N
10	1008	0	aides culinaires et ingrédients divers	denrées destinées à une alimentation particulière	-	42000	Substitut de repas hypocalorique, crème dessert	6.3	11.1	2.75	96.8
10	1008	0	aides culinaires et ingrédients divers	denrées destinées à une alimentation particulière	-	42003	Substitut de repas hypocalorique, prêt à boire	6.65	10.4	2.45	90.6
10	1008	0	aides culinaires et ingrédients divers	denrées destinées à une alimentation particulière	-	42004	Substitut de repas hypocalorique, poudre reconstituée avec lait écrémé	5.97	10.1	1.73	82
10	1008	0	aides culinaires et ingrédients divers	denrées destinées à une alimentation particulière	-	42005	Substitut de repas hypocalorique, poudre reconstituée avec lait écrémé, type milk-shake	6.07	10.2	2.28	87
10	1009	0	aides culinaires et ingrédients divers	aides culinaires et ingrédients pour végétariens	-	9621	Son de blé	\N	\N	\N	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	9640	Son d avoine	15.8	51	6.48	359
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	9641	Son de maïs	8.36	6.65	0.92	226
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	9643	Son de riz	13.9	28.1	20.9	398
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	9647	Son (aliment moyen)	15.7	46	6.09	344
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	9660	Germe de blé	29.2	35.1	9.5	375
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	11007	Gélatine, sèche	86.9	0	0.1	348
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	11009	Levure alimentaire	40.4	21.8	4.5	334
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	11010	Levure de boulanger, compressée	8.3	11.9	1.9	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	11045	Levure de boulanger, déshydratée	44.5	17.9	6.37	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	11046	Levure chimique ou Poudre à lever	1.96	33.2	0.2	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	11214	Préparation culinaire à base de soja, type "crème de soja"	3.25	2.03	14.7	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	11507	Bicarbonate de soude	0.1	0	0	0.4
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	20906	Tofu soyeux, préemballé	5	1.53	2.9	54.3
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	20916	Miso	11.7	18.1	5.31	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	20918	Sirop pour fruits appertisés au sirop	0.5	18.4	0.5	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	20919	Sirop léger pour fruits appertisés au sirop	0.34	15	0.5	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	20920	Jus d ananas pour ananas appertisé au jus	0.5	13.7	0.5	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	20924	Sirop léger pour poire appertisée	0.5	14.6	0.3	60.7
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	31047	Gélifiant pour confitures	0	62	0	278
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	31108	Gelée royale	13	14	4	\N
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	31109	Pollen, partiellement séché	21.9	52.5	4.2	358
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	31111	Pollen,frais	17.5	37.7	5.17	285
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	37000	Base de pizza à la crème	7.7	51.1	2.6	261
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	37002	Base de pizza tomatée	6.9	44.6	2.7	232
10	1009	0	aides culinaires et ingrédients divers	ingrédients divers	-	42200	Lécithine de soja	0	8	83	779
11	1101	0	aliments infantiles	laits et boissons infantiles	-	3000	Lait 1er âge, poudre soluble (préparation pour nourrissons)	10.7	55	25.3	496
11	1101	0	aliments infantiles	laits et boissons infantiles	-	3002	Lait 2e âge, poudre soluble (préparation de suite)	11.4	56.3	23.2	484
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13159	Boisson aux fruits pour bébé dès 4/6mois	0.5	9.5	0.5	\N
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13160	Boisson à base de plantes pour bébé	0.5	5.8	0.5	\N
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13161	Boisson infantile céréales lactées aux légumes pour dîner dès 4/6 mois	2.1	11.6	2.83	82.1
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13162	Boisson infantile céréales lactées aux fruits pour le goûter dès 4/6 mois	1.71	7.7	3	67.6
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13163	Boisson infantile céréales lactées pour le petit déjeuner dès 4/6 mois	1.94	12.1	2.7	83.7
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13169	Boisson infantile céréales lactées pour le petit déjeuner dès 8/9 mois	2.31	11.6	2.8	84.2
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13170	Boisson infantile céréales lactées pour le petit déjeuner dès 12 mois	2.18	12.6	2.78	86.3
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13171	Boisson infantile lactées aux fruits pour le goûter dès 4/6 mois (sans céréales)	1.81	10.4	2.6	75.5
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13172	Boisson infantile céréales lactées aux légumes pour diner dès 12 mois	\N	23.6	8.93	\N
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13173	Boisson infantile céréales lactées pour le petit déjeuner	1.86	12.7	2.89	85.5
11	1101	0	aliments infantiles	laits et boissons infantiles	-	13182	Boisson infantile céréales lactées (aliment moyen)	2.18	12.6	2.78	86.3
11	1101	0	aliments infantiles	laits et boissons infantiles	-	19012	Lait de croissance infantile, liquide (aliment lacté destiné aux enfants en bas âge)	1.25	7.77	2.71	60.9
11	1101	0	aliments infantiles	laits et boissons infantiles	-	19013	Lait 1er âge, prêt à consommer (préparation pour nourrissons)	1.19	8.04	3.79	71.8
11	1101	0	aliments infantiles	laits et boissons infantiles	-	19014	Lait 2e âge, prêt à consommer (préparation pour nourrissons)	1.19	8.23	2.9	65.1
11	1101	0	aliments infantiles	laits et boissons infantiles	-	19015	Lait infantile pour prématurés, prêt à consommer	\N	48.5	24.7	\N
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20246	Petit pot légumes, dès 4-6 mois	0.9	3.8	0.5	26.3
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20247	Petit pot légumes, avec féculent, dès 4/6 mois	1.3	6.45	0.8	41.7
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20248	Plat légumes, avec féculent, dès 6-8 mois	1.2	6.9	0.7	42.9
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20249	Plat légumes, avec féculent et lait/crème, dès 6-8 mois	2.38	9.12	2.3	70.2
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20250	Plat légumes, avec féculent et lait/crème, dès 8-12 mois	2.1	8.1	3.5	77.5
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20251	Plat légumes, avec féculent et lait/crème, dès 12 mois	2.88	8.53	2.3	71.6
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20252	Soupe pour bébé légumes et pomme de terre	1	5.88	0.91	38.5
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20253	Soupe pour bébé légumes, céréales et lait	1.5	7.19	2.5	59.5
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	20254	Plat légumes, avec féculent et lait/crème, dès 18 mois	2.56	8.59	2.4	70.3
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	42603	Plat légumes, avec féculent et viande/poisson, dès 6-8 mois	3.6	5.9	1.6	59
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	42604	Plat légumes, avec féculent et viande/poisson, dès 8-12 mois	2.8	6.77	1.31	54.9
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	42605	Plat légumes, avec féculent et viande/poisson, dès 12 mois	2.5	8.95	2.9	75.7
11	1102	0	aliments infantiles	petits pots salés et plats infantiles	-	42606	Plat légumes, avec féculent et viande/poisson, dès 18 mois	2.82	9.02	1.98	68.3
11	1103	0	aliments infantiles	desserts infantiles	-	13157	Petit pot fruit avec banane pour bébé	0.6	12.4	0.5	\N
11	1103	0	aliments infantiles	desserts infantiles	-	13158	Petit pot fruit sans banane pour bébé	0.29	11.9	0.5	\N
11	1103	0	aliments infantiles	desserts infantiles	-	13164	Dessert lacté infantile type crème dessert	3.25	11.3	3.1	90
11	1103	0	aliments infantiles	desserts infantiles	-	13165	Dessert lacté infantile au riz ou à la semoule	3.38	11.7	3.3	93.8
11	1103	0	aliments infantiles	desserts infantiles	-	13166	Dessert lacté infantile nature sucré ou aux fruits	3.13	12.5	3.5	100
11	1104	0	aliments infantiles	céréales et biscuits infantiles	-	13167	Céréales instantanées, poudre à reconstituer, dès 4/6 mois	5.1	88.3	1.7	393
11	1104	0	aliments infantiles	céréales et biscuits infantiles	-	13168	Céréales instantanées, poudre à reconstituer, dès 6 mois	10	81.1	2	391
11	1104	0	aliments infantiles	céréales et biscuits infantiles	-	24689	Biscuit pour bébé	7.5	73.3	12.3	439
11	1104	0	aliments infantiles	céréales et biscuits infantiles	-	42501	Poudre cacaotée pour bébé	8.5	85	1.9	396
\.


--
-- TOC entry 3519 (class 0 OID 16466)
-- Dependencies: 222
-- Data for Name: groupes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groupes (code, nom) FROM stdin;
0	
1	entrées et plats composés
2	fruits, légumes, légumineuses et oléagineux
3	produits céréaliers
4	viandes, œufs, poissons et assimilés
5	produits laitiers et assimilés
6	eaux et autres boissons
7	produits sucrés
8	glaces et sorbets
9	matières grasses
10	aides culinaires et ingrédients divers
11	aliments infantiles
\.


--
-- TOC entry 3517 (class 0 OID 16436)
-- Dependencies: 220
-- Data for Name: recipe_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipe_ingredients (id, recipe_id, aliment_code, quantity_g) FROM stdin;
\.


--
-- TOC entry 3515 (class 0 OID 16404)
-- Dependencies: 218
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipes (id, title, description, steps, author_id, status, created_at, reviewed_at, reviewed_by, servings) FROM stdin;
1	Ratatouille	Legumes du sud	Couper, cuire	4	approved	2026-07-05 13:52:20.104054+00	2026-07-05 13:57:06.617423+00	1	1
\.


--
-- TOC entry 3520 (class 0 OID 16473)
-- Dependencies: 223
-- Data for Name: sous_groupes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sous_groupes (groupe_code, code, nom) FROM stdin;
0	0	
1	101	salades composées et crudités
1	102	soupes
1	103	plats composés
1	104	pizzas, tartes et crêpes salées
1	105	sandwichs
1	106	feuilletées et autres entrées
2	201	légumes
2	202	pommes de terre et autres tubercules
2	203	légumineuses
2	204	fruits
2	205	fruits à coque et graines oléagineuses
3	301	pâtes, riz et céréales
3	302	pains et assimilés
3	303	biscuits apéritifs
3	305	
4	401	viandes cuites
4	402	viandes crues
4	403	charcuteries et assimilés
4	404	autres produits à base de viande
4	405	poissons cuits
4	406	poissons crus
4	407	mollusques et crustacés cuits
4	408	mollusques et crustacés crus
4	409	produits à base de poissons et produits de la mer
4	410	œufs
4	411	substitus de produits carnés
5	501	laits
5	502	produits laitiers frais et assimilés
5	503	fromages et assimilés
5	504	crèmes et spécialités à base de crème
6	601	eaux
6	602	boissons sans alcool
6	603	boisson alcoolisées
7	701	sucres, miels et assimilés
7	702	chocolats et produits à base de chocolat
7	703	confiseries non chocolatées
7	704	confitures et assimilés
7	705	viennoiseries
7	706	biscuits sucrés
7	707	céréales de petit-déjeuner
7	708	barres céréalières
7	709	gâteaux et pâtisseries
8	0	-
8	801	glaces
8	802	sorbets
8	803	desserts glacés
9	901	beurres
9	902	huiles et graisses végétales
9	903	margarines
9	904	huiles de poissons
9	905	autres matières grasses
10	1001	sauces
10	1002	condiments
10	1003	aides culinaires
10	1004	sels
10	1005	épices
10	1006	herbes
10	1007	algues
10	1008	denrées destinées à une alimentation particulière
10	1009	ingrédients divers
11	1101	laits et boissons infantiles
11	1102	petits pots salés et plats infantiles
11	1103	desserts infantiles
11	1104	céréales et biscuits infantiles
\.


--
-- TOC entry 3521 (class 0 OID 16485)
-- Dependencies: 224
-- Data for Name: sous_sous_groupes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sous_sous_groupes (groupe_code, sous_groupe_code, code, nom) FROM stdin;
0	0	0	
1	101	0	-
1	102	0	-
1	103	10301	plats de viande sans garniture
1	103	10307	plats de céréales/pâtes
1	103	10302	plats de viande et féculents
1	103	10303	plats de viande et légumes/légumineuses
1	103	10304	plats de poisson sans garniture
1	103	10305	plats de poisson et féculents
1	103	10306	plats de légumes/légumineuses
1	103	10308	plats de fromage
1	103	10309	plats végétariens
1	104	0	-
1	105	0	-
1	106	0	-
2	201	20101	légumes crus
2	201	20102	légumes cuits
2	201	20103	légumes séchés ou déshydratés
2	201	20104	légumes et leurs produits de la Martinique
2	201	20105	légumes et leurs produits de la Réunion
2	202	0	-
2	203	20301	légumineuses cuites
2	203	20302	légumineuses fraîches
2	203	20303	légumineuses sèches
2	204	20401	fruits crus
2	204	20402	compotes et assimilés
2	204	20403	fruits appertisés
2	204	20404	fruits séchés
2	204	20405	fruits et leurs produits de la Martinique
2	204	20406	fruits et leurs produits de la Réunion
2	205	0	-
3	301	30101	pâtes, riz et céréales cuits
3	301	30102	pâtes, riz et céréales crus
3	302	30201	pains
3	302	30202	biscottes et pains grillés
3	303	0	-
3	305	30501	
3	305	30502	
4	401	0	-
4	401	40101	bœuf et veau
4	401	40102	porc
4	401	40103	poulet
4	401	40104	dinde
4	401	40105	agneau et mouton
4	401	40106	gibier
4	401	40107	autres viandes
4	401	40108	abats
4	402	40201	bœuf et veau
4	402	40202	porc
4	402	40203	poulet
4	402	40204	dinde
4	402	40205	agneau et mouton
4	402	40206	gibier
4	402	40207	autres viandes
4	402	40208	abats
4	403	0	-
4	403	40301	jambons cuits
4	403	40302	jambons secs et crus
4	403	40303	saucisson secs
4	403	40304	saucisses et assimilés
4	403	40305	pâtés et terrines
4	403	40306	rillettes
4	403	40307	quenelles
4	403	40308	autres spécialités charcutières
4	403	40309	substituts de charcuteries pour végétariens
4	404	0	-
4	405	0	-
4	406	0	-
4	407	0	-
4	408	0	-
4	409	0	-
4	410	41001	œufs cuits
4	410	41002	œufs crus
4	410	41003	omelettes et autres ovoproduits
4	411	0	-
5	501	50101	laits de vaches liquides (non concentrés)
5	501	50102	laits autres que de vache
5	501	50103	laits de vache concentrés ou en poudre
5	502	50201	yaourts et spécialités laitières type yaourt
5	502	50202	fromages blancs
5	502	50203	desserts lactés
5	502	50204	autres desserts
5	502	50205	desserts végétaux
5	503	0	-
5	503	50301	fromages à pâte molle
5	503	50302	fromages à pâte persillée
5	503	50303	fromages à pâte pressée
5	503	50304	fromage fondus
5	503	50305	autres fromages et spécialités
5	503	50306	substituts de fromages pour végétariens
5	504	0	-
6	601	0	-
6	602	60201	jus
6	602	60202	nectars
6	602	60203	boissons rafraîchissantes sans alcool
6	602	60204	boissons rafraîchissantes lactées
6	602	60205	boissons végétales
6	602	60206	café, thé, cacao etc. prêts à consommer
6	602	60207	boissons à reconstituer
6	603	60301	vins
6	603	60302	bières et cidres
6	603	60303	liqueurs et alcools
6	603	60304	cocktails
7	701	0	-
7	702	0	-
7	703	0	-
7	704	0	-
7	705	0	-
7	706	0	-
7	707	0	-
7	708	0	-
7	709	0	-
8	0	0	-
8	801	0	-
8	802	0	-
8	803	0	-
9	901	0	-
9	902	0	-
9	903	0	-
9	904	0	-
9	905	0	-
10	1001	0	-
10	1001	100101	sauces condimentaires
10	1001	100102	sauces chaudes
10	1001	100103	sauces sucrées
10	1002	0	-
10	1003	0	-
10	1004	0	-
10	1005	0	-
10	1006	100601	herbes fraîches
10	1006	100602	herbes séchées
10	1007	0	-
10	1008	0	-
10	1009	0	-
11	1101	0	-
11	1102	0	-
11	1103	0	-
11	1104	0	-
\.


--
-- TOC entry 3513 (class 0 OID 16390)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, role, created_at, username, first_name, last_name, phone) FROM stdin;
2	user@example.com	$2b$10$L.TQjgtZ9/bTbAipcV6FD.SdtiaK5uFNcl508440hvQ.KShapwcZ2	user	2026-07-05 13:40:09.247706+00	user2	Inconnu	Inconnu	
4	jean.dupont@example.com	$2b$10$91lf8QuiZcMO/p9QVRlRuOeuz41VdLH9GEgI6r8LzD7nLCB6CB7kq	user	2026-07-05 13:51:42.859839+00	chefjean	Jean	Dupont	0612345678
1	admin@example.com	$2b$10$6QX9UrS2Zm2qkmbNEls/OOCwCCZsa1oQ1cbmjJXaNnkIxGmlNNxX2	admin	2026-07-05 13:29:57.519176+00	admin	Admin	Admin	0000000000
\.


--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 219
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipe_ingredients_id_seq', 4, true);


--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 217
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_id_seq', 4, true);


--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- TOC entry 3354 (class 2606 OID 16464)
-- Name: aliments aliments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aliments
    ADD CONSTRAINT aliments_pkey PRIMARY KEY (t_aliment_code);


--
-- TOC entry 3356 (class 2606 OID 16472)
-- Name: groupes groupes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groupes
    ADD CONSTRAINT groupes_pkey PRIMARY KEY (code);


--
-- TOC entry 3350 (class 2606 OID 16444)
-- Name: recipe_ingredients recipe_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_pkey PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 16446)
-- Name: recipe_ingredients recipe_ingredients_recipe_id_aliment_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_recipe_id_aliment_code_key UNIQUE (recipe_id, aliment_code);


--
-- TOC entry 3347 (class 2606 OID 16414)
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 16479)
-- Name: sous_groupes sous_groupes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sous_groupes
    ADD CONSTRAINT sous_groupes_pkey PRIMARY KEY (groupe_code, code);


--
-- TOC entry 3360 (class 2606 OID 16491)
-- Name: sous_sous_groupes sous_sous_groupes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sous_sous_groupes
    ADD CONSTRAINT sous_sous_groupes_pkey PRIMARY KEY (groupe_code, sous_groupe_code, code);


--
-- TOC entry 3340 (class 2606 OID 16402)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3342 (class 2606 OID 16400)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3348 (class 1259 OID 16457)
-- Name: idx_recipe_ingredients_recipe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recipe_ingredients_recipe ON public.recipe_ingredients USING btree (recipe_id);


--
-- TOC entry 3344 (class 1259 OID 16426)
-- Name: idx_recipes_author; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recipes_author ON public.recipes USING btree (author_id);


--
-- TOC entry 3345 (class 1259 OID 16425)
-- Name: idx_recipes_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recipes_status ON public.recipes USING btree (status);


--
-- TOC entry 3343 (class 1259 OID 16427)
-- Name: ux_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_users_username ON public.users USING btree (username);


--
-- TOC entry 3364 (class 2606 OID 16512)
-- Name: aliments fk_aliments_groupe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aliments
    ADD CONSTRAINT fk_aliments_groupe FOREIGN KEY (t_groupe_code) REFERENCES public.groupes(code);


--
-- TOC entry 3365 (class 2606 OID 16517)
-- Name: aliments fk_aliments_sous_groupe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aliments
    ADD CONSTRAINT fk_aliments_sous_groupe FOREIGN KEY (t_groupe_code, t_ss_groupe_code) REFERENCES public.sous_groupes(groupe_code, code);


--
-- TOC entry 3366 (class 2606 OID 16522)
-- Name: aliments fk_aliments_sous_sous_groupe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aliments
    ADD CONSTRAINT fk_aliments_sous_sous_groupe FOREIGN KEY (t_groupe_code, t_ss_groupe_code, t_ss_ss_groupe_code) REFERENCES public.sous_sous_groupes(groupe_code, sous_groupe_code, code);


--
-- TOC entry 3363 (class 2606 OID 16447)
-- Name: recipe_ingredients recipe_ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- TOC entry 3361 (class 2606 OID 16415)
-- Name: recipes recipes_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3362 (class 2606 OID 16420)
-- Name: recipes recipes_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 3367 (class 2606 OID 16480)
-- Name: sous_groupes sous_groupes_groupe_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sous_groupes
    ADD CONSTRAINT sous_groupes_groupe_code_fkey FOREIGN KEY (groupe_code) REFERENCES public.groupes(code);


--
-- TOC entry 3368 (class 2606 OID 16492)
-- Name: sous_sous_groupes sous_sous_groupes_groupe_code_sous_groupe_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sous_sous_groupes
    ADD CONSTRAINT sous_sous_groupes_groupe_code_sous_groupe_code_fkey FOREIGN KEY (groupe_code, sous_groupe_code) REFERENCES public.sous_groupes(groupe_code, code);


-- Completed on 2026-07-05 16:49:00

--
-- PostgreSQL database dump complete
--

