--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.1

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
-- Name: dutch_samples; Type: SCHEMA; Schema: -; Owner: cogstack
--

CREATE SCHEMA dutch_samples;


ALTER SCHEMA dutch_samples OWNER TO cogstack;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: documents; Type: TABLE; Schema: dutch_samples; Owner: cogstack
--

CREATE TABLE dutch_samples.documents (
    id character varying(50),
    patient_id character varying(50),
    authored timestamp without time zone,
    type character varying(50),
    text text
);


ALTER TABLE dutch_samples.documents OWNER TO cogstack;

--
-- Data for Name: documents; Type: TABLE DATA; Schema: dutch_samples; Owner: cogstack
--

COPY dutch_samples.documents (id, patient_id, authored, type, text) FROM stdin;
1000000000	1234567	2021-12-01 09:24:20	Ontslagbericht	Anne de Vries is een 22-jarige vrouw bij wie enige tijd geleden acute myeloïde leukemie was vastgesteld.
1000000001	1234567	2021-12-02 09:25:19	Poliklinische Brief	De patiënte was alleen als kind gevaccineerd.
1000000002	2345678	2021-12-04 09:25:48	Spoedeisende Hulp	Marie de Jong, een 53-jarige vrouw, bezoekt ons spreekuur vanwege een verhoogde bloeddruk.
1000000003	3456789	2021-12-10 09:26:12	Poliklinische Brief	Piet Jansen werd behandeld voor diabetes mellitus type 2 met metformine 2 dd 1000 mg, gliclazide 3 dd 80 mg en NPH-insuline 32 eenheden voor de nacht.
1000000004	3456789	2021-12-10 21:26:49	Spoedeisende Hulp	Een intensivering van de bloedglucoseverlagende behandeling was nodig, tot 4 maal daags insulinetherapie.
\.


--
-- PostgreSQL database dump complete
--

