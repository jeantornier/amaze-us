-- SCHEMA : public
CREATE TABLE public.RESOURCE (

	RESOURCE_ID integer,

	RESOURCE_NAME varchar(50) NOT NULL,
	RESOURCE_DESCRIPTION text,

	RESOURCE_CRITICALITY integer NOT NULL,
	RESOURCE_QUANTITY_VALUE float NOT NULL CHECK(RESOURCE_QUANTITY_VALUE >= 0.0),
	RESOURCE_QUANTITY_DATE timestamp(6) NOT NULL,
	RESOURCE_WARNING_LEVEL float NOT NULL CHECK(RESOURCE_WARNING_LEVEL >= 0.0),
	RESOURCE_EMERGENCY_LEVEL float NOT NULL CHECK(RESOURCE_EMERGENCY_LEVEL >= 0.0),

	PRIMARY KEY (RESOURCE_ID),
	CONSTRAINT UC_ResourceName UNIQUE (RESOURCE_NAME)
);

CREATE TABLE public.RESOURCE_VARIATION (

	RESOURCE_VARIATION_ID serial,

	RESOURCE_VARIATION_VALUE float NOT NULL CHECK(RESOURCE_VARIATION_VALUE <> 0.0),
	RESOURCE_VARIATION_DATE timestamp(6) NOT NULL,
	RESOURCE_VARIATION_APPLICATION boolean NOT NULL,
	RESOURCE_VARIATION_DESCRIPTION text,

	RESOURCE_ID integer NOT NULL,
	
	PRIMARY KEY (RESOURCE_VARIATION_ID),
	FOREIGN KEY (RESOURCE_ID) REFERENCES public.RESOURCE (RESOURCE_ID)
);

CREATE TABLE public.USER_APPLICATION (

	USER_APPLICATION_ID integer,

	USER_APPLICATION_PROFILE varchar(20) NOT NULL,
	
	PRIMARY KEY (USER_APPLICATION_ID),
	CONSTRAINT UC_UserApplicationProfile UNIQUE (USER_APPLICATION_PROFILE)
);

CREATE TABLE public.PIONEER (

	PIONEER_ID serial,

	PIONEER_LOGIN varchar(20) NOT NULL,
	PIONEER_PASSWORD varchar(20) NOT NULL,
	PIONEER_EMAIL varchar(100) NOT NULL,

	PIONEER_FIRST_NAME varchar(50) NOT NULL,
	PIONEER_LAST_NAME varchar(50) NOT NULL,
	PIONEER_BIRTHDATE timestamp(6) NOT NULL,

	PIONEER_SEX boolean NOT NULL,
	PIONEER_NOTATION integer NOT NULL CHECK(PIONEER_NOTATION >= 0),

	USER_APPLICATION_ID integer NOT NULL,
	
	PRIMARY KEY (PIONEER_ID),
	CONSTRAINT UC_PioneerLogin UNIQUE (PIONEER_LOGIN),
	CONSTRAINT UC_PioneerEmail UNIQUE (PIONEER_EMAIL),
	CONSTRAINT UC_PioneerFirstLastNameBirth UNIQUE (PIONEER_FIRST_NAME,PIONEER_LAST_NAME, PIONEER_BIRTHDATE),

	FOREIGN KEY (USER_APPLICATION_ID) REFERENCES public.USER_APPLICATION (USER_APPLICATION_ID)
);

CREATE TABLE public.BABY_REQUEST (

	REQUEST_ID serial,

	REQUEST_CREATE_DATE timestamp(6) NOT NULL,
	REQUEST_SUBMIT_DATE timestamp(6),
	REQUEST_ACCEPT_DATE_1 timestamp(6),
	REQUEST_ACCEPT_DATE_2 timestamp(6),
	REQUEST_REFUSE_DATE_1 timestamp(6),
	REQUEST_REFUSE_DATE_2 timestamp(6),
	REQUEST_SCHEDULE_DATE timestamp(6),
	REQUEST_CLOSE_DATE timestamp(6),

	BABY_LOGIN varchar(20),
	BABY_PASSWORD varchar(20),
	BABY_EMAIL varchar(100),

	BABY_FIRST_NAME varchar(50) NOT NULL,
	BABY_LAST_NAME varchar(50) NOT NULL,
	BABY_SEX boolean,
	
	PRIMARY KEY (REQUEST_ID),
	CONSTRAINT UC_BabyLogin UNIQUE (BABY_LOGIN),
	CONSTRAINT UC_BabyEmail UNIQUE (BABY_EMAIL)
);

CREATE TABLE public.BABY_PARENT (

	BABY_PARENT_ID serial,

	PIONEER_ID integer NOT NULL,
	REQUEST_ID integer NOT NULL,

	PRIMARY KEY (BABY_PARENT_ID),
	FOREIGN KEY (PIONEER_ID) REFERENCES public.PIONEER (PIONEER_ID),
	FOREIGN KEY (REQUEST_ID) REFERENCES public.BABY_REQUEST (REQUEST_ID)
);

CREATE TABLE public.BABY_CHECKERS (

	BABY_CHECKERS_ID serial,

	PIONEER_ID integer NOT NULL,
	REQUEST_ID integer NOT NULL,

	PRIMARY KEY (BABY_CHECKERS_ID),
	FOREIGN KEY (PIONEER_ID) REFERENCES public.PIONEER (PIONEER_ID),
	FOREIGN KEY (REQUEST_ID) REFERENCES public.BABY_REQUEST (REQUEST_ID)
);

-- ------------------------------------------------------------------------------------------------------
-- AUDITS
-- ------------------------------------------------------------------------------------------------------
-- schema : audits
CREATE TABLE audits.AUDIT_RESOURCE (

	AUDIT_RESOURCE_ID serial,

	AUDIT_RESOURCE_TYPE varchar(10) NOT NULL,
	AUDIT_RESOURCE_DATE timestamp(6) NOT NULL,
	AUDIT_RESOURCE_COMMENT text,

	-- data to audit
	RESOURCE_ID integer,

	RESOURCE_NAME varchar(50),
	RESOURCE_DESCRIPTION text,

	RESOURCE_CRITICALITY integer,
	RESOURCE_QUANTITY_VALUE float,
	RESOURCE_QUANTITY_DATE timestamp(6),
	RESOURCE_WARNING_LEVEL float,
	RESOURCE_EMERGENCY_LEVEL float,
	
	PRIMARY KEY (AUDIT_RESOURCE_ID)
);

CREATE TABLE audits.AUDIT_RESOURCE_VARIATION (

	AUDIT_RESOURCE_VARIATION_ID serial,

	AUDIT_RESOURCE_VARIATION_TYPE varchar(10) NOT NULL,
	AUDIT_RESOURCE_VARIATION_DATE timestamp(6) NOT NULL,
	AUDIT_RESOURCE_VARIATION_COMMENT text,

	-- data to audit
	RESOURCE_VARIATION_ID integer,

	RESOURCE_VARIATION_VALUE float,
	RESOURCE_VARIATION_DATE timestamp(6),
	RESOURCE_VARIATION_APPLICATION boolean,
	RESOURCE_VARIATION_DESCRIPTION text,

	RESOURCE_ID integer,
	
	PRIMARY KEY (AUDIT_RESOURCE_VARIATION_ID)
);

CREATE TABLE audits.AUDIT_USER_APPLICATION (

	AUDIT_USER_APPLICATION_ID serial,

	AUDIT_USER_APPLICATION_TYPE varchar(10) NOT NULL,
	AUDIT_USER_APPLICATION_DATE timestamp(6) NOT NULL,
	AUDIT_USER_APPLICATION_COMMENT text,

	-- data to audit
	USER_APPLICATION_ID integer,

	USER_APPLICATION_PROFILE varchar(20),
	
	PRIMARY KEY (AUDIT_USER_APPLICATION_ID)
);

CREATE TABLE audits.AUDIT_PIONEER (

	AUDIT_PIONEER_ID serial,

	AUDIT_PIONEER_TYPE varchar(10) NOT NULL,
	AUDIT_PIONEER_DATE timestamp(6) NOT NULL,
	AUDIT_PIONEER_COMMENT text,

	-- data to audit
	PIONEER_ID integer,

	PIONEER_LOGIN varchar(20),
	PIONEER_PASSWORD varchar(100),
	PIONEER_EMAIL varchar(100),

	PIONEER_FIRST_NAME varchar(50),
	PIONEER_LAST_NAME varchar(50),
	PIONEER_BIRTHDATE timestamp(6),

	PIONEER_SEX boolean,
	PIONEER_NOTATION integer,

	USER_APPLICATION_ID integer,
	
	PRIMARY KEY (AUDIT_PIONEER_ID)
);

CREATE TABLE audits.AUDIT_BABY_REQUEST (

	AUDIT_BABY_REQUEST_ID serial,

	AUDIT_BABY_REQUEST_TYPE varchar(10) NOT NULL,
	AUDIT_BABY_REQUEST_DATE timestamp(6) NOT NULL,
	AUDIT_BABY_REQUEST_COMMENT text,

	-- data to audit
	REQUEST_ID integer,

	REQUEST_CREATE_DATE timestamp(6),
	REQUEST_SUBMIT_DATE timestamp(6),
	REQUEST_ACCEPT_DATE_1 timestamp(6),
	REQUEST_ACCEPT_DATE_2 timestamp(6),
	REQUEST_REFUSE_DATE_1 timestamp(6),
	REQUEST_REFUSE_DATE_2 timestamp(6),
	REQUEST_SCHEDULE_DATE timestamp(6),
	REQUEST_CLOSE_DATE timestamp(6),

	BABY_LOGIN varchar(20),
	BABY_PASSWORD varchar(20),
	BABY_EMAIL varchar(100),

	BABY_FIRST_NAME varchar(50),
	BABY_LAST_NAME varchar(50),
	BABY_SEX boolean,
	
	PRIMARY KEY (AUDIT_BABY_REQUEST_ID)
);

CREATE TABLE audits.AUDIT_BABY_PARENT (

	AUDIT_BABY_PARENT_ID serial,

	AUDIT_BABY_PARENT_TYPE varchar(10) NOT NULL,
	AUDIT_BABY_PARENT_DATE timestamp(6) NOT NULL,
	AUDIT_BABY_PARENT_COMMENT text,

	-- data to audit
	BABY_PARENT_ID integer,

	PIONEER_ID integer,
	REQUEST_ID integer,

	PRIMARY KEY (AUDIT_BABY_PARENT_ID)
);

CREATE TABLE audits.AUDIT_BABY_CHECKERS (

	AUDIT_BABY_CHECKERS_ID serial,

	AUDIT_BABY_CHECKERS_TYPE varchar(10) NOT NULL,
	AUDIT_BABY_CHECKERS_DATE timestamp(6) NOT NULL,
	AUDIT_BABY_CHECKERS_COMMENT text,

	-- data to audit
	BABY_CHECKERS_ID integer,

	PIONEER_ID integer,
	REQUEST_ID integer,

	PRIMARY KEY (AUDIT_BABY_CHECKERS_ID)
);