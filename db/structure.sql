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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_controls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_controls (
    id bigint NOT NULL,
    doctor_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    expires_at timestamp(6) without time zone,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: access_controls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.access_controls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_controls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.access_controls_id_seq OWNED BY public.access_controls.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: biodata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.biodata (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    exam_id bigint NOT NULL,
    systolic_pressure integer,
    diastolic_pressure integer,
    glycemia integer,
    heart_rate integer,
    cholesterol integer,
    triglyceride integer,
    creatinine numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: biodata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.biodata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: biodata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.biodata_id_seq OWNED BY public.biodata.id;


--
-- Name: consultations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consultations (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    doctor_id bigint NOT NULL,
    date date NOT NULL,
    reason character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: consultations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.consultations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consultations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.consultations_id_seq OWNED BY public.consultations.id;


--
-- Name: diagnostics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagnostics (
    id bigint NOT NULL,
    disease_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    diagnosed_at date NOT NULL,
    cured_at date,
    related_symptoms character varying,
    status integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: diagnostics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diagnostics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diagnostics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diagnostics_id_seq OWNED BY public.diagnostics.id;


--
-- Name: diets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diets (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    date date NOT NULL,
    breakfast character varying,
    lunch character varying,
    dinner character varying,
    morning_snack character varying,
    afternoon_snack character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: diets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diets_id_seq OWNED BY public.diets.id;


--
-- Name: diseases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diseases (
    id bigint NOT NULL,
    name character varying NOT NULL,
    treatment_indicated character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: diseases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diseases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diseases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diseases_id_seq OWNED BY public.diseases.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    last_name character varying NOT NULL,
    crm character varying NOT NULL,
    cpf character varying NOT NULL,
    specialty character varying NOT NULL,
    email character varying,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.doctors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: exams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exams (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    classification integer NOT NULL,
    date date NOT NULL,
    local character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: exams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exams_id_seq OWNED BY public.exams.id;


--
-- Name: medication_prescriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medication_prescriptions (
    id bigint NOT NULL,
    prescription_id bigint NOT NULL,
    medication_id bigint NOT NULL,
    dosage character varying NOT NULL,
    schedule character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: medication_prescriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medication_prescriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medication_prescriptions_id_seq OWNED BY public.medication_prescriptions.id;


--
-- Name: medication_surgeries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medication_surgeries (
    id bigint NOT NULL,
    surgery_id bigint NOT NULL,
    medication_id bigint NOT NULL,
    dosage character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: medication_surgeries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medication_surgeries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_surgeries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medication_surgeries_id_seq OWNED BY public.medication_surgeries.id;


--
-- Name: medications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: medications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medications_id_seq OWNED BY public.medications.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id bigint NOT NULL,
    name character varying NOT NULL,
    last_name character varying NOT NULL,
    rg character varying,
    cpf character varying,
    email character varying,
    state character varying NOT NULL,
    city character varying NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: prescriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prescriptions (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    medications_count integer NOT NULL,
    date date NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: prescriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prescriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prescriptions_id_seq OWNED BY public.prescriptions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: surgeries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.surgeries (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    classification integer NOT NULL,
    medications_count integer NOT NULL,
    date date NOT NULL,
    hospital character varying,
    discharged_at date,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: surgeries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.surgeries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: surgeries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.surgeries_id_seq OWNED BY public.surgeries.id;


--
-- Name: treatments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.treatments (
    id bigint NOT NULL,
    diagnostic_id bigint NOT NULL,
    treatable_type character varying NOT NULL,
    treatable_id bigint NOT NULL,
    started_at date,
    ended_at date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.treatments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.treatments_id_seq OWNED BY public.treatments.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    encrypted_password character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    classification integer NOT NULL,
    name character varying NOT NULL,
    last_name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: access_controls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_controls ALTER COLUMN id SET DEFAULT nextval('public.access_controls_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: biodata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biodata ALTER COLUMN id SET DEFAULT nextval('public.biodata_id_seq'::regclass);


--
-- Name: consultations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations ALTER COLUMN id SET DEFAULT nextval('public.consultations_id_seq'::regclass);


--
-- Name: diagnostics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics ALTER COLUMN id SET DEFAULT nextval('public.diagnostics_id_seq'::regclass);


--
-- Name: diets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets ALTER COLUMN id SET DEFAULT nextval('public.diets_id_seq'::regclass);


--
-- Name: diseases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diseases ALTER COLUMN id SET DEFAULT nextval('public.diseases_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: exams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams ALTER COLUMN id SET DEFAULT nextval('public.exams_id_seq'::regclass);


--
-- Name: medication_prescriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medication_prescriptions ALTER COLUMN id SET DEFAULT nextval('public.medication_prescriptions_id_seq'::regclass);


--
-- Name: medication_surgeries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medication_surgeries ALTER COLUMN id SET DEFAULT nextval('public.medication_surgeries_id_seq'::regclass);


--
-- Name: medications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medications ALTER COLUMN id SET DEFAULT nextval('public.medications_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Name: prescriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions ALTER COLUMN id SET DEFAULT nextval('public.prescriptions_id_seq'::regclass);


--
-- Name: surgeries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.surgeries ALTER COLUMN id SET DEFAULT nextval('public.surgeries_id_seq'::regclass);


--
-- Name: treatments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treatments ALTER COLUMN id SET DEFAULT nextval('public.treatments_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: access_controls access_controls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_controls
    ADD CONSTRAINT access_controls_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: biodata biodata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biodata
    ADD CONSTRAINT biodata_pkey PRIMARY KEY (id);


--
-- Name: consultations consultations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT consultations_pkey PRIMARY KEY (id);


--
-- Name: diagnostics diagnostics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT diagnostics_pkey PRIMARY KEY (id);


--
-- Name: diets diets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets
    ADD CONSTRAINT diets_pkey PRIMARY KEY (id);


--
-- Name: diseases diseases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diseases
    ADD CONSTRAINT diseases_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: medication_prescriptions medication_prescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medication_prescriptions
    ADD CONSTRAINT medication_prescriptions_pkey PRIMARY KEY (id);


--
-- Name: medication_surgeries medication_surgeries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medication_surgeries
    ADD CONSTRAINT medication_surgeries_pkey PRIMARY KEY (id);


--
-- Name: medications medications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medications
    ADD CONSTRAINT medications_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: prescriptions prescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: surgeries surgeries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.surgeries
    ADD CONSTRAINT surgeries_pkey PRIMARY KEY (id);


--
-- Name: treatments treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT treatments_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_doctor_patient_status_on_ac; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_doctor_patient_status_on_ac ON public.access_controls USING btree (doctor_id, patient_id, status);


--
-- Name: index_access_controls_on_doctor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_controls_on_doctor_id ON public.access_controls USING btree (doctor_id);


--
-- Name: index_access_controls_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_controls_on_patient_id ON public.access_controls USING btree (patient_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_biodata_on_exam_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_biodata_on_exam_id ON public.biodata USING btree (exam_id);


--
-- Name: index_biodata_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_biodata_on_patient_id ON public.biodata USING btree (patient_id);


--
-- Name: index_consultations_on_doctor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consultations_on_doctor_id ON public.consultations USING btree (doctor_id);


--
-- Name: index_consultations_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consultations_on_patient_id ON public.consultations USING btree (patient_id);


--
-- Name: index_diagnostics_on_disease_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_diagnostics_on_disease_id ON public.diagnostics USING btree (disease_id);


--
-- Name: index_diagnostics_on_disease_id_and_patient_id_and_status; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_diagnostics_on_disease_id_and_patient_id_and_status ON public.diagnostics USING btree (disease_id, patient_id, status);


--
-- Name: index_diagnostics_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_diagnostics_on_patient_id ON public.diagnostics USING btree (patient_id);


--
-- Name: index_diets_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_diets_on_patient_id ON public.diets USING btree (patient_id);


--
-- Name: index_diseases_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_diseases_on_name ON public.diseases USING btree (name);


--
-- Name: index_doctors_on_cpf; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_doctors_on_cpf ON public.doctors USING btree (cpf);


--
-- Name: index_doctors_on_crm; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_doctors_on_crm ON public.doctors USING btree (crm);


--
-- Name: index_doctors_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_doctors_on_email ON public.doctors USING btree (email);


--
-- Name: index_doctors_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_doctors_on_user_id ON public.doctors USING btree (user_id);


--
-- Name: index_exams_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exams_on_patient_id ON public.exams USING btree (patient_id);


--
-- Name: index_medication_prescriptions_on_medication_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_medication_id ON public.medication_prescriptions USING btree (medication_id);


--
-- Name: index_medication_prescriptions_on_prescription_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_prescription_id ON public.medication_prescriptions USING btree (prescription_id);


--
-- Name: index_medication_surgeries_on_medication_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_surgeries_on_medication_id ON public.medication_surgeries USING btree (medication_id);


--
-- Name: index_medication_surgeries_on_surgery_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_surgeries_on_surgery_id ON public.medication_surgeries USING btree (surgery_id);


--
-- Name: index_medications_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medications_on_name ON public.medications USING btree (name);


--
-- Name: index_patients_on_cpf; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_cpf ON public.patients USING btree (cpf);


--
-- Name: index_patients_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_email ON public.patients USING btree (email);


--
-- Name: index_patients_on_rg; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_rg ON public.patients USING btree (rg);


--
-- Name: index_patients_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_user_id ON public.patients USING btree (user_id);


--
-- Name: index_prescriptions_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prescriptions_on_patient_id ON public.prescriptions USING btree (patient_id);


--
-- Name: index_surgeries_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_surgeries_on_patient_id ON public.surgeries USING btree (patient_id);


--
-- Name: index_treatments_on_diagnostic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_treatments_on_diagnostic_id ON public.treatments USING btree (diagnostic_id);


--
-- Name: index_treatments_on_treatable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_treatments_on_treatable ON public.treatments USING btree (treatable_type, treatable_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: treatments fk_rails_259bed4182; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT fk_rails_259bed4182 FOREIGN KEY (diagnostic_id) REFERENCES public.diagnostics(id);


--
-- Name: medication_surgeries fk_rails_2b54c177d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medication_surgeries
    ADD CONSTRAINT fk_rails_2b54c177d5 FOREIGN KEY (medication_id) REFERENCES public.medications(id);


--
-- Name: biodata fk_rails_2d11119ff7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biodata
    ADD CONSTRAINT fk_rails_2d11119ff7 FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: consultations fk_rails_33c52f1c05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT fk_rails_33c52f1c05 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: diets fk_rails_3900be8572; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets
    ADD CONSTRAINT fk_rails_3900be8572 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: medication_prescriptions fk_rails_449d392c82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medication_prescriptions
    ADD CONSTRAINT fk_rails_449d392c82 FOREIGN KEY (medication_id) REFERENCES public.medications(id);


--
-- Name: biodata fk_rails_48ae59c127; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biodata
    ADD CONSTRAINT fk_rails_48ae59c127 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: surgeries fk_rails_509be18665; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.surgeries
    ADD CONSTRAINT fk_rails_509be18665 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: patients fk_rails_623f05c630; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT fk_rails_623f05c630 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: diagnostics fk_rails_69125e86e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT fk_rails_69125e86e7 FOREIGN KEY (disease_id) REFERENCES public.diseases(id);


--
-- Name: exams fk_rails_6989b69bff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT fk_rails_6989b69bff FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: access_controls fk_rails_6ade8072eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_controls
    ADD CONSTRAINT fk_rails_6ade8072eb FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: doctors fk_rails_899b01ef33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT fk_rails_899b01ef33 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: medication_surgeries fk_rails_90bec0496e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medication_surgeries
    ADD CONSTRAINT fk_rails_90bec0496e FOREIGN KEY (surgery_id) REFERENCES public.surgeries(id);


--
-- Name: medication_prescriptions fk_rails_96c6b20244; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medication_prescriptions
    ADD CONSTRAINT fk_rails_96c6b20244 FOREIGN KEY (prescription_id) REFERENCES public.prescriptions(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: diagnostics fk_rails_a388f83a55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnostics
    ADD CONSTRAINT fk_rails_a388f83a55 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: consultations fk_rails_b1f629cdac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT fk_rails_b1f629cdac FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- Name: prescriptions fk_rails_bede94f0a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT fk_rails_bede94f0a0 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: access_controls fk_rails_e682fd5c31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_controls
    ADD CONSTRAINT fk_rails_e682fd5c31 FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20230403210132'),
('20230403224044'),
('20230404170059'),
('20230404185602'),
('20230404192324'),
('20230404200012'),
('20230404200757'),
('20230404212152'),
('20230405153238'),
('20230405154840'),
('20230405162025'),
('20230405183706'),
('20230405184217'),
('20230405185444'),
('20230405192424'),
('20230409191321'),
('20230622021649');


