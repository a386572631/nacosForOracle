/*
 * Copyright 1999-2018 Alibaba Group Holding Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info   */
/******************************************/
CREATE TABLE config_info (
                             id number(20) NOT NULL ,
                             data_id varchar2(255) NOT NULL ,
                             group_id varchar2(255) default NULL,
                             content clob NOT NULL ,
                             md5 varchar2(32) default NULL ,
                             gmt_create date NOT NULL ,
                             gmt_modified date NOT NULL ,
                             src_user clob,
                             src_ip varchar2(20) default NULL,
                             app_name varchar2(128) default NULL,
                             tenant_id varchar2(128) default '',
                             c_desc varchar2(256) default NULL,
                             c_use varchar2(64) default NULL,
                             effect varchar2(64) default NULL,
                             type varchar2(64) default NULL,
                             c_schema clob,
                             encrypted_data_key clob NOT NULL,
                             CONSTRAINT PK_CONFIG_INFO PRIMARY KEY (id),
                             UNIQUE (data_id,group_id,tenant_id)
);

CREATE SEQUENCE SEQ_CONFIG_INFO
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_CONFIG_INFO
before insert on config_info
for each row
begin
select SEQ_CONFIG_INFO.nextval into :new.id from dual;
end;
/
-------------------------------------------------------------------------------------------------------

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_aggr   */
/******************************************/
CREATE TABLE config_info_aggr (
                                  id number(20) NOT NULL,
                                  data_id varchar2(255) NOT NULL,
                                  group_id varchar2(255) NOT NULL,
                                  datum_id varchar2(255) NOT NULL,
                                  content clob NOT NULL,
                                  gmt_modified date NOT NULL,
                                  app_name varchar2(128) DEFAULT NULL,
                                  tenant_id varchar2(128) DEFAULT '',
                                  CONSTRAINT PK_CONFIG_INFO_AGGR PRIMARY KEY (id),
                                  UNIQUE(data_id,group_id,tenant_id,datum_id)
);
CREATE SEQUENCE SEQ_CONFIG_INFO_AGGR
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_CONFIG_INFO_AGGR
before insert on config_info_aggr
for each row
begin
select SEQ_CONFIG_INFO_AGGR.nextval into :new.id from dual;
end;
/
-------------------------------------------------------------------------------------------------------

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_beta   */
/******************************************/
CREATE TABLE config_info_beta (
                                  id number(20) NOT NULL,
                                  data_id varchar2(255) NOT NULL,
                                  group_id varchar2(128) NOT NULL,
                                  app_name varchar2(128) DEFAULT NULL,
                                  content clob NOT NULL,
                                  beta_ips varchar2(1024) DEFAULT NULL,
                                  md5 varchar2(32) DEFAULT NULL,
                                  gmt_create date NOT NULL,
                                  gmt_modified date NOT NULL,
                                  src_user clob,
                                  src_ip varchar2(20) DEFAULT NULL,
                                  tenant_id varchar2(128) DEFAULT '',
                                  encrypted_data_key clob NOT NULL,
                                  CONSTRAINT PK_CONFIG_INFO_BETA PRIMARY KEY (id),
                                  UNIQUE(data_id,group_id,tenant_id)
);
CREATE SEQUENCE SEQ_CONFIG_INFO_BETA
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_CONFIG_INFO_BETA
before insert on config_info_beta
for each row
begin
select SEQ_CONFIG_INFO_BETA.nextval into :new.id from dual;
end;
/
-------------------------------------------------------------------------------------------------------

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_tag   */
/******************************************/
CREATE TABLE config_info_tag (
                                 id number(20) NOT NULL,
                                 data_id varchar2(255) NOT NULL,
                                 group_id varchar2(128) NOT NULL,
                                 tenant_id varchar2(128) DEFAULT '',
                                 tag_id varchar2(128) NOT NULL,
                                 app_name varchar2(128) DEFAULT NULL,
                                 content clob NOT NULL,
                                 md5 varchar2(32) DEFAULT NULL,
                                 gmt_create date NOT NULL,
                                 gmt_modified date NOT NULL,
                                 src_user clob,
                                 src_ip varchar2(20) DEFAULT NULL,
                                 CONSTRAINT PK_CONFIG_INFO_TAG PRIMARY KEY (id),
                                 UNIQUE(data_id,group_id,tenant_id,tag_id)
);
CREATE SEQUENCE SEQ_CONFIG_INFO_TAG
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_CONFIG_INFO_TAG
before insert on config_info_tag
for each row
begin
select SEQ_CONFIG_INFO_TAG.nextval into :new.id from dual;
end;
/
-------------------------------------------------------------------------------------------------------

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_tags_relation   */
/******************************************/
CREATE TABLE config_tags_relation (
                                      id number(20) NOT NULL,
                                      tag_name varchar2(128) NOT NULL,
                                      tag_type varchar2(64) DEFAULT NULL,
                                      data_id varchar2(255) NOT NULL,
                                      group_id varchar2(128) NOT NULL,
                                      tenant_id varchar2(128) DEFAULT '',
                                      nid number(20) NOT NULL,
                                      CONSTRAINT PK_CONFIG_TAG_RELATION PRIMARY KEY (nid),
                                      UNIQUE (id,tag_name,tag_type)
);
create index idx_tenant_id on config_tags_relation (tenant_id);

CREATE SEQUENCE SEQ_CONFIG_TAG_RELATION
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_CONFIG_TAG_RELATION
before insert on config_tags_relation
for each row
begin
select SEQ_CONFIG_TAG_RELATION.nextval into :new.id from dual;
end;
/
-------------------------------------------------------------------------------------------------------

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = group_capacity   */
/******************************************/
CREATE TABLE group_capacity (
                                id number(20)  NOT NULL,
                                group_id varchar2(128) NOT NULL,
                                quota number   DEFAULT 0,
                                usage number   DEFAULT 0,
                                max_size number    DEFAULT 0,
                                max_aggr_count number    DEFAULT 0,
                                max_aggr_size number    DEFAULT 0,
                                max_history_count number    DEFAULT 0,
                                gmt_create date NOT NULL ,
                                gmt_modified date NOT NULL ,
                                CONSTRAINT PK_GROUP_CAPACITY PRIMARY KEY (id),
                                UNIQUE(group_id)
);
comment on table group_capacity is '集群、各Group容量信息表';
--comment on columm group_capacity.id is '主键ID';
--comment on columm group_capacity.group_id is 'Group ID，空字符表示整个集群';
--comment on columm group_capacity.quota is '配额，0表示使用默认值';
--comment on columm group_capacity.usage is '使用量';
--comment on columm group_capacity.max_size is '单个配置大小上限，单位为字节，0表示使用默认值';
--comment on columm group_capacity.max_aggr_count is '聚合子配置最大个数，，0表示使用默认值';
--comment on columm group_capacity.max_aggr_size is '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值';
--comment on columm group_capacity.max_history_count is '最大变更历史数量';
--comment on columm group_capacity.gmt_create is '创建时间';
--comment on columm group_capacity.gmt_modified is '修改时间';

CREATE SEQUENCE SEQ_GROUP_CAPACITY
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_GROUP_CAPACITY
before insert on group_capacity
for each row
begin
select SEQ_GROUP_CAPACITY.nextval into :new.id from dual;
end;
/
-------------------------------------------------------------------------------------------------------

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = his_config_info   */
/******************************************/
CREATE TABLE his_config_info (
                                 id number  NOT NULL,
                                 nid number(20)  NOT NULL,
                                 data_id varchar2(255) NOT NULL,
                                 group_id varchar2(128) NOT NULL,
                                 app_name varchar2(128) DEFAULT NULL ,
                                 content clob NOT NULL,
                                 md5 varchar2(32) DEFAULT NULL,
                                 gmt_create date NOT NULL,
                                 gmt_modified date NOT NULL,
                                 src_user clob,
                                 src_ip varchar2(20) DEFAULT NULL,
                                 op_type char(10) DEFAULT NULL,
                                 tenant_id varchar2(128) DEFAULT '',
                                 encrypted_data_key clob NOT NULL,
                                 CONSTRAINT PK_HIS_CONFIG_INFO PRIMARY KEY (nid)
);
create index idx_gmt_create on his_config_info (gmt_create);
create index idx_gmt_modified on his_config_info (gmt_modified);
create index idx_did on his_config_info (data_id);
comment on table his_config_info is '多租户改造';

CREATE SEQUENCE SEQ_HIS_CONFIG_INFO
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_HIS_CONFIG_INFO
before insert on his_config_info
for each row
begin
select SEQ_HIS_CONFIG_INFO.nextval into :new.id from dual;
end;
/
-------------------------------------------------------------------------------------------------------

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = tenant_capacity   */
/******************************************/
CREATE TABLE tenant_capacity (
                                 id number(20)  NOT NULL,
                                 tenant_id varchar2(128) DEFAULT '',
                                 quota number  DEFAULT 0,
                                 usage number  DEFAULT 0,
                                 max_size number  DEFAULT 0,
                                 max_aggr_count number  DEFAULT 0,
                                 max_aggr_size number  DEFAULT 0,
                                 max_history_count number  DEFAULT 0,
                                 gmt_create date NOT NULL,
                                 gmt_modified date NOT NULL,
                                 CONSTRAINT PK_TENANT_CAPACITY_ID PRIMARY KEY (id),
                                 UNIQUE(tenant_id)
);
comment on table tenant_capacity is '租户容量信息表';

CREATE SEQUENCE SEQ_TENANT_CAPACITY
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_TENANT_CAPACITY
before insert on tenant_capacity
for each row
begin
select SEQ_TENANT_CAPACITY.nextval into :new.id from dual;
end;
/
-------------------------------------------------------------------------------------------------------

CREATE TABLE tenant_info (
                             id number(20) NOT NULL,
                             kp varchar2(128) NOT NULL,
                             tenant_id varchar2(128) default '',
                             tenant_name varchar2(128) default '',
                             tenant_desc varchar2(256) DEFAULT NULL,
                             create_source varchar2(32) DEFAULT NULL ,
                             gmt_create number(20) NOT NULL,
                             gmt_modified number(20) NOT NULL,
                             CONSTRAINT PK_TENANT_INFO_ID PRIMARY KEY (id),
                             UNIQUE(kp,tenant_id)
);
create index idx_tenant_info_id on tenant_info (tenant_id);

CREATE SEQUENCE SEQ_TENANT_INFO
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOCYCLE
NOCACHE;

create or replace trigger TRI_TENANT_INFO
before insert on tenant_info
for each row
begin
select SEQ_TENANT_INFO.nextval into :new.id from dual;
end;
/


CREATE TABLE users (
                       username varchar2(50) NOT NULL PRIMARY KEY,
                       password varchar2(500) NOT NULL,
                       enabled char(1) default '1'
);

CREATE TABLE roles (
                       username varchar2(50) NOT NULL,
                       role varchar2(50) NOT NULL,
                       constraint uk_username_role UNIQUE (username,role)
);

CREATE TABLE permissions (
                             role varchar2(50) NOT NULL,
                             resources varchar2(512) NOT NULL,
                             action varchar2(8) NOT NULL,
                             constraint uk_role_permission UNIQUE (role,resources,action)
);

INSERT INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', '1');

INSERT INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN');
