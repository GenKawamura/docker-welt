--
-- PostgreSQL database cluster dump
--

\connect postgres

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE bill;
ALTER ROLE bill WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB LOGIN NOREPLICATION;






--
-- Database creation
--

CREATE DATABASE billing WITH TEMPLATE = template0 OWNER = srmdcache;


\connect billing

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: billinginfo; Type: TABLE; Schema: public; Owner: srmdcache; Tablespace: 
--

CREATE TABLE billinginfo (
    datestamp timestamp without time zone,
    cellname character varying,
    action character varying,
    transaction character varying,
    pnfsid character varying,
    fullsize numeric,
    transfersize numeric,
    storageclass character varying,
    isnew boolean,
    client character varying,
    connectiontime numeric,
    errorcode numeric,
    errormessage character varying,
    protocol character varying,
    initiator character varying
);


ALTER TABLE public.billinginfo OWNER TO srmdcache;

--
-- Name: costinfo; Type: TABLE; Schema: public; Owner: srmdcache; Tablespace: 
--

CREATE TABLE costinfo (
    datestamp timestamp without time zone,
    cellname character varying,
    action character varying,
    transaction character varying,
    pnfsid character varying,
    cost numeric,
    errorcode numeric,
    errormessage character varying
);


ALTER TABLE public.costinfo OWNER TO srmdcache;

--
-- Name: doorinfo; Type: TABLE; Schema: public; Owner: srmdcache; Tablespace: 
--

CREATE TABLE doorinfo (
    datestamp timestamp without time zone,
    cellname character varying,
    action character varying,
    owner character varying,
    mappeduid numeric,
    mappedgid numeric,
    client character varying,
    transaction character varying,
    pnfsid character varying,
    connectiontime numeric,
    queuedtime numeric,
    errorcode numeric,
    errormessage character varying,
    path character varying
);


ALTER TABLE public.doorinfo OWNER TO srmdcache;

--
-- Name: hitinfo; Type: TABLE; Schema: public; Owner: srmdcache; Tablespace: 
--

CREATE TABLE hitinfo (
    datestamp timestamp without time zone,
    cellname character varying,
    action character varying,
    transaction character varying,
    pnfsid character varying,
    filecached boolean,
    errorcode numeric,
    errormessage character varying
);


ALTER TABLE public.hitinfo OWNER TO srmdcache;

--
-- Name: storageinfo; Type: TABLE; Schema: public; Owner: srmdcache; Tablespace: 
--

CREATE TABLE storageinfo (
    datestamp timestamp without time zone,
    cellname character varying,
    action character varying,
    transaction character varying,
    pnfsid character varying,
    fullsize numeric,
    storageclass character varying,
    connectiontime numeric,
    queuedtime numeric,
    errorcode numeric,
    errormessage character varying
);


ALTER TABLE public.storageinfo OWNER TO srmdcache;

--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: billinginfo; Type: ACL; Schema: public; Owner: srmdcache
--

REVOKE ALL ON TABLE billinginfo FROM PUBLIC;
REVOKE ALL ON TABLE billinginfo FROM srmdcache;
GRANT ALL ON TABLE billinginfo TO srmdcache;



--
-- Name: costinfo; Type: ACL; Schema: public; Owner: srmdcache
--

REVOKE ALL ON TABLE costinfo FROM PUBLIC;
REVOKE ALL ON TABLE costinfo FROM srmdcache;
GRANT ALL ON TABLE costinfo TO srmdcache;



--
-- Name: doorinfo; Type: ACL; Schema: public; Owner: srmdcache
--

REVOKE ALL ON TABLE doorinfo FROM PUBLIC;
REVOKE ALL ON TABLE doorinfo FROM srmdcache;
GRANT ALL ON TABLE doorinfo TO srmdcache;



--
-- Name: hitinfo; Type: ACL; Schema: public; Owner: srmdcache
--

REVOKE ALL ON TABLE hitinfo FROM PUBLIC;
REVOKE ALL ON TABLE hitinfo FROM srmdcache;
GRANT ALL ON TABLE hitinfo TO srmdcache;



--
-- Name: storageinfo; Type: ACL; Schema: public; Owner: srmdcache
--

REVOKE ALL ON TABLE storageinfo FROM PUBLIC;
REVOKE ALL ON TABLE storageinfo FROM srmdcache;
GRANT ALL ON TABLE storageinfo TO srmdcache;















