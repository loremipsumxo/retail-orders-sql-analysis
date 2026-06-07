-- ============================================================
-- Retail Orders SQL Analysis
-- 01_schema.sql
--
-- Purpose:
-- Create the database schema for the Retail Orders SQL Analysis project.
--
-- Phase:
-- Phase 2 — SQL Implementation
--
-- Notes:
-- This script creates:
-- 1. Raw staging tables
-- 2. Dimension tables
-- 3. Fact table
--
-- Data import and cleaning are handled separately in:
-- - sql/02_import_notes.md
-- - sql/03_data_cleaning.sql
-- ============================================================

-- ============================================================
-- Database Setup
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_orders_sql_analysis;

USE retail_orders_sql_analysis;

-- ============================================================
-- Drop Tables
-- ============================================================
-- Drop fact table first because it depends on dimension tables.

DROP TABLE IF EXISTS fact_orders;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_supplier;
DROP TABLE IF EXISTS dim_customer_status;
DROP TABLE IF EXISTS orders_raw;
DROP TABLE IF EXISTS product_supplier_raw;

-- ============================================================
-- Raw Staging Tables
-- ============================================================
-- Raw staging tables preserve source data before cleaning.
-- Column names are converted to SQL-friendly snake_case,
-- but values should remain as close as possible to the source CSV.

CREATE TABLE orders_raw (
    customer_id INT,
    customer_status VARCHAR(50),
    order_date_raw VARCHAR(20),
    delivery_date_raw VARCHAR(20),
    order_id BIGINT,
    product_id BIGINT,
    quantity_ordered INT,
    revenue DECIMAL(12,2),
    cost_price_per_unit DECIMAL(12,2)
);

CREATE TABLE product_supplier_raw (
    product_id BIGINT,
    product_line VARCHAR(100),
    product_category VARCHAR(100),
    product_group VARCHAR(255),
    product_name VARCHAR(255),
    supplier_country VARCHAR(10),
    supplier_name VARCHAR(255),
    supplier_id INT
);

-- ============================================================
-- Dimension Tables
-- ============================================================

CREATE TABLE dim_supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    supplier_country VARCHAR(10) NOT NULL
);

CREATE TABLE dim_product (
    product_id BIGINT PRIMARY KEY,
    product_line VARCHAR(100) NOT NULL,
    product_category VARCHAR(100) NOT NULL,
    product_group VARCHAR(255) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    supplier_id INT NOT NULL,

    CONSTRAINT fk_dim_product_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES dim_supplier(supplier_id)
);

CREATE TABLE dim_customer_status (
    customer_status_id INT PRIMARY KEY,
    customer_status VARCHAR(50) NOT NULL UNIQUE
);

-- ============================================================
-- Fact Table
-- ============================================================
-- Grain:
-- One row per order-product transaction.
--
-- Metric assumptions:
-- estimated_cost = quantity_ordered * cost_price_per_unit
-- estimated_profit = revenue - estimated_cost
-- gross_margin_pct = estimated_profit / revenue
--
-- Profitability metrics are estimates based on available source data.

CREATE TABLE fact_orders (
    fact_order_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    order_id BIGINT NOT NULL,
    customer_id INT NOT NULL,
    customer_status_id INT NOT NULL,
    product_id BIGINT NOT NULL,

    order_date DATE NOT NULL,
    delivery_date DATE NOT NULL,
    delivery_days INT,

    quantity_ordered INT NOT NULL,
    revenue DECIMAL(12,2) NOT NULL,
    cost_price_per_unit DECIMAL(12,2) NOT NULL,
    estimated_cost DECIMAL(12,2),
    estimated_profit DECIMAL(12,2),
    gross_margin_pct DECIMAL(10,4),

    CONSTRAINT fk_fact_orders_product
        FOREIGN KEY (product_id)
        REFERENCES dim_product(product_id),

    CONSTRAINT fk_fact_orders_customer_status
        FOREIGN KEY (customer_status_id)
        REFERENCES dim_customer_status(customer_status_id)
);

-- ============================================================
-- Indexes
-- ============================================================
-- Indexes support joins and common business analysis queries.

CREATE INDEX idx_fact_orders_order_id
    ON fact_orders(order_id);

CREATE INDEX idx_fact_orders_customer_id
    ON fact_orders(customer_id);

CREATE INDEX idx_fact_orders_product_id
    ON fact_orders(product_id);

CREATE INDEX idx_fact_orders_customer_status_id
    ON fact_orders(customer_status_id);

CREATE INDEX idx_fact_orders_order_date
    ON fact_orders(order_date);

CREATE INDEX idx_dim_product_supplier_id
    ON dim_product(supplier_id);

-- ============================================================
-- Schema Validation Notes
-- ============================================================
-- After running this script, validate:
--
-- 1. Tables created successfully.
-- 2. Raw staging tables exist.
-- 3. Dimension tables exist.
-- 4. Fact table exists.
-- 5. Primary keys are defined.
-- 6. Foreign keys are defined.
--
-- Data import, population, and row-count validation will happen
-- after this schema is reviewed and approved.
-- ============================================================
