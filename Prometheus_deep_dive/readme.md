# Prometheus Deep Dive

## Source and Documentation 
[Prometheus Deep Dive Course](.)

## Section 1 - Introduction to Prometheus 


## Section 2 - Promethus Basics

### High-level use cases
- Metric collection about your systems and applications in one place
- Visualization with dashboards and graphs of the health of your systems
- Alerting when something is broken 

### Prometheus Architecture 
The two most basic components of a Prometheus system are;
- Prometheus server - A central server that gathers metrics and makes them available 
- Exporters - Agents that expose data about systems and applications for collection by the Prometheus server

Prometheus Pull Model
- Prometheus server pulls metric data from exporters - agents do not push data to the Prometheus server

Other components to Prometheus are
- Client Libraries - Easily turn your custom application into an epxorter that exoposes metrics into a format that Prometheus can consume
- Prometheus Pushgateway - Allows pushing metrics to Prometheus for certian specific use cases 
- Alertmanager - Sends alerts triggers by metric data
- Visualization Tools - Provide useful ways to view metric data. These tools are not neccessarily a part of Prometheus 

### Prometheus Limitations
It's important to understand when it is not the best tool; 
- 100% accuracy (e.g., per-request billing) - Prometheus is designed to operate even under failure conditions. This means it will continue to provide data even if new data is not available due to failures and outages. If you need 100% up-to-the-minute accuract, such as in the case of per-request billing, Prometheus may not be the best tool to use.      
- Non time-series data (e.g. log aggregation) - not the best choice for collection more generic types of data, such as system logs.

## Section 2 - Installation and Configuration

### Configuring Prometheus 
The basics and what you need to know;
- all changes to the configuration can be applied here - /etc/prometheus/prometheus.yml 
- this configuration file uses the YAML format
- refer to the documentation more detailed information on configuring prometheus
- you must reload Prometheus after applying a new configuration - reload Prometheus with \
`sudo systemctl restart prometheus` or `sudo killall -HUP prometheus`
- after applying changes, you can verify that the changes went into effect by checking the API with; \
`curl localhost:9090/api/v1/status/config`

### Configuring an Exporter

A **Prometheus exporter** is any application that exposes metric data in a format that can be colelcted (or "scraped") by the Prometheus server. (e.g. Node Exporter runs on EC2 and collects a variety of system metrics. It then exposes them to Prometheus) 


The **scrape_configs** section of the Prometheus config file provides a list of targets the Prometheus server will scape, such as a Node Exporter running on a Linux machine. Prometheus server will scrape these targets periodically to collect metric data. 
- while defining targets under scrape_configs, be sure to use the private IP address followed by port 9100 (e.g. ` - targets: ['172.31.110.170:9100']`)



## Section 4 - Prometheus Data Model

### Time-Series Data
Prometheus is built around storing time-series data \
every metric in Prometheus tracks a particular value over time

What is time-series data? 
- Time-series data consists of a series of values associated with different points in time 
- for example, Prometheus might track the available memory for a server, with an entry in the time series for every minute. 

time series data looks like this:
- 08:00AM--0C / 31F
- 09:00AM--3C / 39F
- 10:00AM--6C / 47F

This means Prometheus not only tracks the current value of each metrics but also changes to each metric over time.

### Metrics and Labels 
Every metric in Prometheus has a metric name. The **metric name** refers to the general feature of a systm or application that is being measured. \
An example of a metric name:
- node_cpu_seconds_total (measures the total amount of CPU time being used in CPU seconds)

Simple querying on a metric name alone will return multiple data points, such as multiple CPUs on a server or multiple server CPUs;
- node_cpu_seconds_total{cpu="0", instance="172.31.11.96:9100", job="node", mode="idle"}
- node_cpu_seconds_total{cpu="0", instance="172.31.11.96:9100", job="node", mode="iowait"}
- node_cpu_seconds_total{cpu="0", instance="172.31.11.96:9100", job="node", mode="irq"}

**metric labels** provide a dimensional data model, you'll see them inside {curly braces} of a query result. \
You can use labels to specify additional information with labels. Note the 4 labels above in the query examples, each one seperated by a comma. 

use labels to query narrow or broad series of data; \
query the following: \
`node_cpu_seconds_total{cpu="0", mode="idle"}`

### Metric Types
**Metric Types** refer to differnet ways in which exporters represent the metric data they provide. Metric types are not represented in any sepcial way in a Prometheus server, but it is important to understand them in order to properly interpret your metrics.  

the first metric type is called a counter \
a **counter** is a single number that can only increase or be reset to zero. Counters represent cumulative values. \ 
examples include: 
- number of HTTP request servers by an application
- number of records processed
- number of application restarts
- number of errors
- number of cpu time a server has been running

query the following: \
`node_cpu_seconds_total[5m]`


the second metric type is called a guage\
a **guage** is a single number that can increase or decrease over time - representing the current value during that time series \
examples include: 
- number of concurrent HTTP requests
- CPU usage
- memory usage
- current active threads 

Current HTTP requests active: \
+- 76 \
+- 82 \
+- 23 \
+- 55 

query the following: \
`node_memory_MemAvailable_bytes`


the third metric type is called a Histogram \
A **histogram** counts the number of observations/events that fall into a set of configurable buckets, each with it's own serperate time series. A histogram will use labels to differentiate betweeen buckets. The below example provide the number of HTTP request whose duration falls into each bucket. \
examples include: 
- http_request_duration_seconds_bucket{le="0.3"}
- http_request_duration_seconds_bucket{le="0.6"}
- http_request_duration_seconds_bucket{le="1.0"}

Histrograms also include seperate metric names to expose the _sum of all observed values and the total _count of events. 
- http_request_duration_seconds_sum
- http_request_duration_seconds_count

query the following: \
`prometheus_http_request_duration_seconds_bucket` \
`prometheus_http_request_duration_seconds_bucket{handler="/metrics"}`


the fourth metric type is called a summary \
a **summary** is similar to a histogram, but it exposes metrics in the form of quantiles instead of buckets. While buckets divide values based on specific boundaries, quantiles divide values based on the percentiles into which they fall.

This value represents the number of HTTP request whose duration falls within the 95th percentile of all request or the top 5% longest requests. \
`http_request-duration_seconds{quantile="0.95"}`

Like histograms, summaries also expose the _sum and _count metrics

examples include: 
- .


query the following: \
`go_gc_duration_seconds` \
`go_gc_duration_seconds_sum` \
`go_gc_duration_seconds_count` \

for now, you should be generally aware of these types. As you get further in the course, you'll become more familiar with them. 

## Section 5 - Querying


### Querying
You can use **PromQL** (Prometheus Query Language) to write queries and retrieve useful information from the metric data collected by Prometheus. \
You can use Prometheus queries in a variety of ways to ovtain and work with data:
- expression browser
- prometheus HTTP API
- visualization tools such as Grafana

### Query Basics

**Time-Series selector** \
The most basic component of the PromQL query is a time-series selector. \
A **time-series selector** is simply a metric name, optinoally combined with labels. \ 
Both of the following are valid time-series selectors: \
`node_cpu_seconds_total` \
`node_cpu_seconds_total{cpu="0"}`

When multiple values exists for a label in the prometheus data you do not specify the label in your query, prometheus will simply return data for all the values of that label. 

**Label Matching** \
You can use a variety of operators to perform advanced matches based upon lavel values. 
- =: Equals
- !=: Does not eqaul
- =~: Regex match
- !~: Does not regex match

```
node_cpu_seconds_total{cpu="0"}
node_cpu_seconds_total{cpu!="0"}
node_cpu_seconds_total{cpu=~"1*"}
node_cpu_seconds_total{cpu!~"1*"}
node_cpu_seconds_total{mode=~"s.*"}
node_cpu_seconds_total{mode=~"user|system"}
node_cpu_seconds_total{mode!~"user|system"}
```

**Range Vector Selector** \
Since Prometheus data is fundamentally time-series data, you can select data points over a particular time range. \
This query selects all values for the metric name and label recorded over the last two minutes. \
`node_cpu_seconds_total{cpu="0"}[2m]`

**Offset Modifer** \
You can use an **offset modifier** to provide a time offset to select data from the past, with or without a range selector. \
Select the CPU usage from one hour ago: \
`node_cpu_seconds_total offset 1h` 
Select CPU usage values over a five-minute peroid one hour ago: \
`node_cpu_seconds_total[5m] offset 1h` 

There are more than just these queries, these are just the basics. 

### Query Operators 

## Section 6 - Introduction to Visualization 

## Section 7 - Native Visualization Methods

## Section 8 - Grafana

## Section 9 - Exporters

## Section 10 - Prometheus Pushgateway

## Section 11 - Recording Rules

## Section 12 - ALermanage Setup and Configuration

## Section 13 - Prometheus Alerts

## Section 14 - Using Multiple Prometheus Servers

## Section 15 - Security

## Section 16 - Client Libraries

## Section 17 - Final Steps

