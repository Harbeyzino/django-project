--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: productiondatabase_wth6_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO productiondatabase_wth6_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO productiondatabase_wth6_user;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO productiondatabase_wth6_user;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO productiondatabase_wth6_user;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO productiondatabase_wth6_user;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO productiondatabase_wth6_user;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO productiondatabase_wth6_user;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: digiApp_product; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public."digiApp_product" (
    id bigint NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL,
    affiliate_link character varying(200),
    is_approved boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    image character varying(100)
);


ALTER TABLE public."digiApp_product" OWNER TO productiondatabase_wth6_user;

--
-- Name: digiApp_product_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public."digiApp_product" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."digiApp_product_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: digiApp_profile; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public."digiApp_profile" (
    id bigint NOT NULL,
    phone_number character varying(15),
    profile_picture character varying(100),
    user_id integer NOT NULL,
    about text,
    address text,
    company character varying(255),
    country character varying(100),
    role character varying(100),
    full_name character varying(255)
);


ALTER TABLE public."digiApp_profile" OWNER TO productiondatabase_wth6_user;

--
-- Name: digiApp_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public."digiApp_profile" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."digiApp_profile_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO productiondatabase_wth6_user;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO productiondatabase_wth6_user;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO productiondatabase_wth6_user;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO productiondatabase_wth6_user;

--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.auth_group (id, name) FROM stdin;
1	admin
2	customer
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add product	7	add_product
26	Can change product	7	change_product
27	Can delete product	7	delete_product
28	Can view product	7	view_product
29	Can add profile	8	add_profile
30	Can change profile	8	change_profile
31	Can delete profile	8	delete_profile
32	Can view profile	8	view_profile
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
2	pbkdf2_sha256$870000$MkPPYqPw8Gw7ZXmMWpgqT7$9bLNT9nCKFb39KieAedv2v/Tl0QgYdc26tX2ny8rvOs=	2024-11-26 09:33:12.916224+00	f	Kolly	Adebayo	Kolapo	abbeyzinoemmanuel@gmail.com	f	t	2024-11-26 09:32:22.793147+00
1	pbkdf2_sha256$870000$fS5xVAVP3fPYf07z4CqirV$Iz8D1ArWa6YC5KpnRQng/QzvtVgBKfW1HuXlz/Ugz6Q=	2024-11-26 14:31:31.610217+00	t	Emma			abbeyzino52@gmail.com	t	t	2024-11-25 23:44:30+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
1	1	1
2	2	2
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: digiApp_product; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public."digiApp_product" (id, title, description, price, affiliate_link, is_approved, created_at, updated_at, image) FROM stdin;
\.


--
-- Data for Name: digiApp_profile; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public."digiApp_profile" (id, phone_number, profile_picture, user_id, about, address, company, country, role, full_name) FROM stdin;
2	\N		2	\N	\N	\N	\N	\N	\N
1	None	profile_pics/Untitled_3_1_dI4O6H9.jpg	1	None	None	None	None	None	None
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2024-11-25 23:46:24.232593+00	1	admin	1	[{"added": {}}]	3	1
2	2024-11-25 23:46:58.153864+00	2	customer	1	[{"added": {}}]	3	1
3	2024-11-25 23:48:06.103972+00	1	Emma	2	[{"changed": {"fields": ["Groups"]}}]	4	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	digiApp	product
8	digiApp	profile
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2024-11-25 14:15:49.061245+00
2	auth	0001_initial	2024-11-25 14:16:00.740103+00
3	admin	0001_initial	2024-11-25 14:16:03.141122+00
4	admin	0002_logentry_remove_auto_add	2024-11-25 14:16:03.575549+00
5	admin	0003_logentry_add_action_flag_choices	2024-11-25 14:16:04.448006+00
6	contenttypes	0002_remove_content_type_name	2024-11-25 14:16:06.128649+00
7	auth	0002_alter_permission_name_max_length	2024-11-25 14:16:07.277909+00
8	auth	0003_alter_user_email_max_length	2024-11-25 14:16:08.443577+00
9	auth	0004_alter_user_username_opts	2024-11-25 14:16:09.023814+00
10	auth	0005_alter_user_last_login_null	2024-11-25 14:16:10.438246+00
11	auth	0006_require_contenttypes_0002	2024-11-25 14:16:11.018219+00
12	auth	0007_alter_validators_add_error_messages	2024-11-25 14:16:12.37792+00
13	auth	0008_alter_user_username_max_length	2024-11-25 14:16:15.163095+00
14	auth	0009_alter_user_last_name_max_length	2024-11-25 14:16:17.504+00
15	auth	0010_alter_group_name_max_length	2024-11-25 14:16:19.367734+00
16	auth	0011_update_proxy_permissions	2024-11-25 14:16:19.93025+00
17	auth	0012_alter_user_first_name_max_length	2024-11-25 14:16:21.334742+00
18	digiApp	0001_initial	2024-11-25 14:16:22.527849+00
19	digiApp	0002_alter_product_image	2024-11-25 14:16:23.087948+00
20	digiApp	0003_profile	2024-11-25 14:16:25.047939+00
21	digiApp	0004_profile_about_profile_address_profile_company_and_more	2024-11-25 14:16:27.042979+00
22	digiApp	0005_profile_full_name	2024-11-25 14:16:28.160706+00
23	sessions	0001_initial	2024-11-25 14:16:30.159414+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: productiondatabase_wth6_user
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
30hgi6bjjyq4ba55ngjmmw1hyhzwofqe	.eJxVjMsOwiAQRf-FtSFAh0dcuvcbyDAMUjWQlHZl_Hdt0oVu7znnvkTEba1xG7zEOYuz0OL0uyWkB7cd5Du2W5fU27rMSe6KPOiQ1575eTncv4OKo35rX7jk5K2jokIi4EAEynu2OihDxaBmR1iQUrITsKY8TQBoQDlG7cT7AxamONw:1tFsgZ:EjmC8gd5dDSh9PDwIhrHvqO1YoQuJyR-Aq1-W-y19RM	2024-12-10 10:20:47.976502+00
l2vvcsvwh5uchhjsnzqtkrrcmqzwyio1	.eJxVjstqwzAQRX9FaJNNMLbj2CG7JtBdaSndVSWMRqNajSyBHk1DyL83jkNJVwPn3jkzJ76DnPpdjhR2RvE1r_j8nknAPbkxUF_gPn2B3qVgZDFWilsaiyevyG5u3X-CHmJ_2e40aSW7ZYu6XElsaIXYlF1Hy2pV1qhrqKhF0IBSLhcNVagWi6aBuilbgqq9SOOBKBl9vNhOgsfeH7beaROGTU7JO8HXLIVMcyZ4MgOFEbhs7QjAWn94zikaRVtrcD-GGmy81vHe80Y_aUwFf6UUjoJfhX_wwTEKwQfmEXMIpNbsfSZErssKp6HYN9hMbMgxMUkMmCI0A9jLN4OkUMw-JqnB6WvBr8bbJZMsTfQleJUxsW0gSMY79gjGkhL8zM-_vTyTvQ:1tFwc3:Be95PPWcPRapH0zb1hoc-UT_uoUb5mUwZppD8sHoaRo	2024-12-10 14:32:23.93253+00
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 2, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 32, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 2, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 2, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: digiApp_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public."digiApp_product_id_seq"', 1, false);


--
-- Name: digiApp_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public."digiApp_profile_id_seq"', 2, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 3, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 8, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: productiondatabase_wth6_user
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 23, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: digiApp_product digiApp_product_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public."digiApp_product"
    ADD CONSTRAINT "digiApp_product_pkey" PRIMARY KEY (id);


--
-- Name: digiApp_profile digiApp_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public."digiApp_profile"
    ADD CONSTRAINT "digiApp_profile_pkey" PRIMARY KEY (id);


--
-- Name: digiApp_profile digiApp_profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public."digiApp_profile"
    ADD CONSTRAINT "digiApp_profile_user_id_key" UNIQUE (user_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: productiondatabase_wth6_user
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: digiApp_profile digiApp_profile_user_id_287db376_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public."digiApp_profile"
    ADD CONSTRAINT "digiApp_profile_user_id_287db376_fk_auth_user_id" FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: productiondatabase_wth6_user
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO productiondatabase_wth6_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO productiondatabase_wth6_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO productiondatabase_wth6_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO productiondatabase_wth6_user;


--
-- PostgreSQL database dump complete
--
