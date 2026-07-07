# Data Engineering

Patterns for building data pipelines, analytics infrastructure, and data
platforms. Apply when you need to process, transform, or analyze large
volumes of data.

## Tool Selection

This file describes **patterns**, not specific tools. Tools mentioned are
**examples** to illustrate the pattern — not recommendations. When selecting
tools for this project, the agent MUST:
1. Check `docs/ARCHITECTURE.md` for the declared stack
2. Research current options (never suggest from memory)
3. Present 2-3 options with trade-offs
4. Let the user decide

## When to Apply

- Need to process >1GB of data per day
- Need analytics/reporting dashboards
- Need to integrate data from multiple sources
- Need machine learning infrastructure
- Need real-time data processing

**Don't apply when:**
- Simple CRUD application
- <100MB of data
- No analytics requirements
- Team lacks data engineering experience

## Data Architecture Patterns

### Batch Processing

Process data in large chunks at scheduled intervals.

**Use when:**
- Data volume is large (>1GB)
- Real-time processing not required
- Cost efficiency is important

**Tools:**
- Apache Spark (large-scale processing)
- Apache Beam (unified batch/streaming)
- AWS Glue (serverless ETL)
- dbt (SQL-based transformations)

**Example pipeline:**
```
Source (S3) → Extract → Transform → Load → Destination (Data Warehouse)
         (daily batch)
```

### Streaming Processing

Process data in real-time as it arrives.

**Use when:**
- Real-time processing required
- Low latency needed (<1 second)
- Event-driven architecture (see `event-driven.md`)

**Tools:**
- Apache Kafka (event streaming)
- Apache Flink (stream processing)
- AWS Kinesis (streaming)
- Google Dataflow (streaming)

**Example pipeline:**
```
Source (Kafka) → Process → Sink (Database/Dashboard)
         (real-time)
```

### Lambda Architecture

Combine batch and streaming for comprehensive data processing.

**Setup:**
```
Speed Layer (Streaming) → Real-time views (last few hours)
Batch Layer (Batch) → Historical views (all data)
Serving Layer → Merge views for queries
```

**Benefits:**
- Real-time + historical data
- Fault-tolerant (batch can rebuild from streaming)
- Scalable

## Data Warehouse

### What is a Data Warehouse?

Central repository for structured data optimized for analytics.

**Tools:**
- Snowflake (cloud-native)
- Google BigQuery (cloud-native)
- Amazon Redshift (cloud-native)
- PostgreSQL (open source, small scale)

**When to use:**
- Need to run complex analytical queries
- Need to join data from multiple sources
- Need historical data (time-series analysis)

### Data Modeling

**Star Schema:**
- Fact tables (transactions, events)
- Dimension tables (customers, products, dates)
- Optimized for queries

**Snowflake Schema:**
- Normalized dimension tables
- Less redundant, more complex queries

**Recommendation:** start with star schema, normalize if needed.

### ETL vs ELT

**ETL (Extract, Transform, Load):**
- Transform data before loading
- Good for: small data, complex transformations
- Tools: Apache Airflow, AWS Glue

**ELT (Extract, Load, Transform):**
- Load raw data, transform in warehouse
- Good for: large data, cloud warehouses
- Tools: dbt, Fivetran

**Recommendation:** ELT for cloud warehouses (BigQuery, Snowflake).

## Data Lakes

### What is a Data Lake?

Central repository for raw data in native format.

**Tools:**
- Amazon S3 (object storage)
- Google Cloud Storage (object storage)
- Azure Data Lake Storage (object storage)
- Delta Lake (data lake with ACID transactions)

**When to use:**
- Need to store raw data (before transformation)
- Need to store unstructured data (images, videos)
- Need flexible schema (schema-on-read)

### Data Lakehouse

Combine data lake and data warehouse.

**Setup:**
```
Data Lake (raw data) → Data Warehouse (curated data) → Analytics
```

**Tools:**
- Delta Lake (open source)
- Apache Iceberg (open source)
- Databricks (commercial)

## Data Pipelines

### Orchestration

Schedule and manage data pipelines.

**Tools:**
- Apache Airflow (open source)
- Prefect (open source)
- Dagster (open source)
- AWS Step Functions (cloud-native)

**Example DAG:**
```python
@dag(schedule_interval='@daily')
def etl_pipeline():
    extract = extract_task()
    transform = transform_task(extract)
    load = load_task(transform)
```

### Data Quality

Ensure data is accurate and complete.

**Checks:**
- Schema validation (correct columns, types)
- Row count validation (expected number of rows)
- Null checks (required fields not null)
- Value range checks (values within expected range)
- Referential integrity (foreign keys valid)

**Tools:**
- Great Expectations (open source)
- dbt tests (built-in)
- Soda (commercial)

### Data Lineage

Track data from source to destination.

**Benefits:**
- Debug data issues (trace back to source)
- Impact analysis (what breaks if source changes)
- Compliance (audit trail)

**Tools:**
- Apache Atlas (open source)
- Amundsen (open source)
- DataHub (open source)

## Analytics Infrastructure

### BI Tools

Business intelligence tools for dashboards and reports.

**Tools:**
- Looker (commercial, Google)
- Tableau (commercial)
- Metabase (open source)
- Apache Superset (open source)

### Feature Store

Store machine learning features for training and inference.

**Tools:**
- Feast (open source)
- Tecton (commercial)
- Hopsworks (commercial)

**When to use:**
- Multiple ML models use same features
- Need feature consistency (training vs inference)
- Need feature versioning

## Real-Time Analytics

### OLAP Databases

Online analytical processing for real-time queries.

**Tools:**
- ClickHouse (open source)
- Apache Druid (open source)
- Pinot (open source)
- Rockset (commercial)

**When to use:**
- Need sub-second query latency
- High concurrency (many users querying)
- Real-time dashboards

### Materialized Views

Pre-computed query results for fast reads.

**Tools:**
- PostgreSQL materialized views
- BigQuery materialized views
- dbt incremental models

**When to use:**
- Complex queries run frequently
- Query results change infrequently
- Need fast read performance

## Data Governance

### Data Catalog

Central registry of all data assets.

**Information per asset:**
- Name, description, owner
- Schema (columns, types)
- Lineage (source, transformations)
- Quality metrics (completeness, accuracy)
- Access control (who can read/write)

**Tools:**
- Apache Atlas (open source)
- Amundsen (open source)
- DataHub (open source)
- Alation (commercial)

### Data Access Control

Control who can access what data.

**Strategies:**
- Role-based access control (RBAC)
- Attribute-based access control (ABAC)
- Row-level security (RLS)

**Tools:**
- Apache Ranger (open source)
- AWS IAM (cloud-native)
- Okta (commercial)

### Data Privacy

Ensure compliance with privacy regulations (GDPR, CCPA).

**Requirements:**
- Data classification (PII, sensitive, public)
- Data masking (hide PII in non-production)
- Data retention (delete after retention period)
- Data export (provide data to users)
- Data deletion (delete user data on request)

**Tools:**
- Apache Atlas (data classification)
- OneTrust (privacy management)
- BigQuery data masking

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Decide if data engineering is needed (see "When to Apply")
- Choose data architecture (batch, streaming, lambda)
- Choose data warehouse (Snowflake, BigQuery, Redshift)
- Choose data lake (S3, GCS, ADLS)
- Define data governance strategy
- Document in `docs/ARCHITECTURE.md`

### Phase 4 (Productionization)

- Set up data warehouse
- Set up data lake
- Build ETL/ELT pipelines
- Set up data orchestration (Airflow, Prefect)
- Set up data quality checks

### Phase 6 (Operations)

- Monitor pipeline performance
- Track data quality metrics
- Review data governance policies
- Optimize costs (data storage, compute)

## Anti-Patterns

- **Data Swamp:** data lake with no governance (unusable)
- **No Data Quality:** bad data in, bad decisions out
- **ETL Bottleneck:** transformations take too long (use ELT)
- **No Lineage:** can't trace data issues
- **Ignoring Costs:** data storage and compute are expensive (monitor)
- **No Data Catalog:** can't find data assets
- **Over-Engineering:** complex pipeline when simple query suffices
