# Load Testing Results - CDN w/ Load Balancer

Three tests were conducted to investigate the influence of resources available for the container on the simulation's functionality.

## No Reource-Capping

For the default, the memory is limited the capabilities of the equipment, 8 Gigabytes for my current machine.

Thus, it can be conducted that all Nginx servers can consume up to around **40MiB** of memory.

CPU usage mostly revolves below **1%** for `edge` nodes, below **.25%** for `backend` nodes.

The largest CPU usage is on **load-balancer**, over `5%` on average.

It is important to highlight the fact, that the sum of all CPU usage from `edge` nodes is roughly the same as the `load-balancer` usage. This proves that the routing works just fine.

### Docker Stats

| CONTAINER ID   | NAME            | CPU % | MEM USAGE / LIMIT | MEM % | NET I/O         | BLOCK I/O       | PIDS |
|----------------|-----------------|-------|-------------------|-------|-----------------|-----------------|------|
| e8cd289bc407   | prometheus      | 3.06% | 121MiB / 7.616GiB | 1.55% | 669kB / 53.6kB  | 34.4MB / 77.8kB | 10   |
| 46e2515c6c91   | load-balancer   | 5.37% | 29.32MiB / 7.616GiB | 0.38% | 2.31MB / 2.75MB | 13.2MB / 0B     | 4    |
| d97824402982   | edge2           | 0.76% | 29.05MiB / 7.616GiB | 0.37% | 243kB / 500kB   | 13.2MB / 0B     | 4    |
| 719d6ae96ffe   | edge3           | 0.85% | 28.98MiB / 7.616GiB | 0.37% | 234kB / 485kB   | 13.2MB / 0B     | 4    |
| 0b04bc9b325f   | backend2        | 0.23% | 40.48MiB / 7.616GiB | 0.52% | 14.5kB / 64kB   | 13.3MB / 0B     | 2    |
| 49efb29ff18a   | edge1           | 0.74% | 29.73MiB / 7.616GiB | 0.38% | 234kB / 487kB   | 13.2MB / 0B     | 4    |
| 1a5011e03d09   | backend1        | 0.08% | 40.64MiB / 7.616GiB | 0.52% | 13.3kB / 58.9kB | 13.6MB / 0B     | 2    |
| acf4a9fa2cd7   | edge4           | 2.24% | 29.02MiB / 7.616GiB | 0.37% | 456kB / 869kB   | 13.2MB / 1.65MB | 4    |
| 44ce4696270b   | grafana         | 3.92% | 249MiB / 7.616GiB | 3.19% | 158kB / 134kB   | 62.3MB / 1.02MB | 19   |

### Wrk output for 1m load test

Over 6300 requests in a minute, avg. latency of 134 ms.

```shell
Running 1m test @ [http://localhost:18080](http://localhost:18080)
4 threads and 10 connections
Thread Stats   Avg      Stdev     Max   +/- Stdev
Latency   134.49ms  205.74ms   1.66s    86.80%
Req/Sec    32.67     20.78   110.00     62.60%
Latency Distribution
50%   41.71ms
75%  167.35ms
90%  411.05ms
99%  976.55ms
6385 requests in 1.00m, 2.73MB read
Socket errors: connect 0, read 0, write 0, timeout 7
Non-2xx or 3xx responses: 7
Requests/sec:    106.26
Transfer/sec:     46.54KB
```

## 2% Single CPU & 25M Memory Cap

### Docker Stats, 1st case of capping

In the second case, understanding the resource usage range of each of the nodes, I decided to limit both CPU and memory for every of the Nginx servers.

This time, only the `load-balancer` reached the CPU cap, as expected, since it is the bottleneck in the current implementation.

| CONTAINER ID   | NAME            | CPU % | MEM USAGE / LIMIT | MEM % | NET I/O           | BLOCK I/O         | PIDS |
|----------------|-----------------|-------|-------------------|-------|-------------------|-------------------|------|
| 48907134c430   | load-balancer   | 1.95% | 14.24MiB / 25MiB  | 56.95%| 1.12MB / 1.55MB   | 19.4MB / 8.19kB   | 4    |
| 5f3c26eb2407   | edge3           | 0.54% | 7.094MiB / 25MiB  | 28.38%| 153kB / 354kB     | 19.4MB / 254kB    | 4    |
| 45e2a5b7429a   | edge1           | 0.48% | 22.21MiB / 25MiB  | 88.84%| 128kB / 323kB     | 21.3MB / 254kB    | 4    |
| ee23d0b1d5fe   | edge4           | 0.83% | 10.51MiB / 25MiB  | 42.03%| 237kB / 492kB     | 16.4MB / 221kB    | 4    |
| 8a414fe093c5   | edge2           | 0.06% | 22.57MiB / 25MiB  | 90.27%| 135kB / 327kB     | 21.6MB / 291kB    | 4    |
| 2ce8d3b3add0   | backend1        | 0.12% | 21.92MiB / 25MiB  | 87.67%| 13.9kB / 93.2kB   | 23.1MB / 737kB    | 2    |
| a857db9aa1ae   | backend2        | 0.05% | 22.77MiB / 25MiB  | 91.09%| 14.5kB / 86.7kB   | 17.6MB / 217kB    | 2    |
| fcb487dbd343   | grafana         | 0.05% | 245.1MiB / 7.616GiB | 3.14% | 174kB / 211kB     | 61.3MB / 1.47MB   | 17   |

### Wrk output for 1m load test, 1st case of capping

Roughly 2400 requests in a minute, avg. latency 225 ms.

```shell
Running 1m test @ http://localhost:18080
  4 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   225.68ms  203.51ms   1.76s    85.29%
    Req/Sec    11.68      6.74    50.00     69.21%
  Latency Distribution
     50%  199.22ms
     75%  290.00ms
     90%  426.24ms
     99%    1.10s 
  2339 requests in 1.00m, 1.00MB read
  Socket errors: connect 0, read 0, write 0, timeout 5
  Non-2xx or 3xx responses: 5
Requests/sec:     38.92
Transfer/sec:     17.05KB
```

## 1% Single CPU & 15m Memory Cap

### Docker stats, 2nd case of capping

The third test limited the resources even more.

The memory usage was visibly lower across all the servers.

This time as well, the `load-balancer` being a SPoF, reached 1% cap as the only one.

| CONTAINER ID   | NAME            | CPU % | MEM USAGE / LIMIT | MEM %  | NET I/O          | BLOCK I/O        | PIDS |
|----------------|-----------------|-------|-------------------|--------|------------------|------------------|------|
| 2f5c8c95850f   | prometheus      | 0.00% | 120.3MiB / 7.616GiB | 1.54%  | 898kB / 75.2kB   | 34.2MB / 115kB   | 10   |
| fe08462cafa2   | load-balancer   | 1.01% | 8.711MiB / 15MiB   | 58.07% | 541kB / 813kB    | 52.1MB / 1.42MB  | 4    |
| ce9cba10b7fb   | backend2        | 0.00% | 9.695MiB / 15MiB   | 64.64% | 14.5kB / 83.9kB  | 59.7MB / 2.98MB  | 2    |
| 3c19ca90bb61   | backend1        | 0.02% | 12.47MiB / 15MiB   | 83.15% | 13.8kB / 82.9kB  | 59.5MB / 2.48MB  | 2    |
| 01c48e9170cb   | edge1           | 0.18% | 9.355MiB / 15MiB   | 62.37% | 72.4kB / 213kB   | 32.6MB / 225kB   | 4    |
| 55231aaab0a0   | edge2           | 0.29% | 11.29MiB / 15MiB   | 75.29% | 81.3kB / 226kB   | 30.6MB / 455kB   | 4    |
| 2bde9659bc0a   | edge4           | 0.26% | 5.91MiB / 15MiB    | 39.40% | 123kB / 313kB    | 42.1MB / 1.15MB  | 4    |
| ab468a6caece   | edge3           | 0.30% | 7.789MiB / 15MiB   | 51.93% | 69.3kB / 211kB   | 41.4MB / 926kB   | 4    |
| 86aa7c511264   | grafana         | 0.04% | 251.4MiB / 7.616GiB | 3.22%  | 232kB / 186kB    | 62.2MB / 1.26MB  | 19   |

### Wrk output for 1m load test, 2nd case of capping

Over 1250 requests, avg. latency around 300 ms.

```shell
Running 1m test @ http://localhost:18080
  4 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   356.24ms  272.85ms   2.00s    85.90%
    Req/Sec     7.76      4.89    30.00     81.67%
  Latency Distribution
     50%  299.65ms
     75%  400.02ms
     90%  700.47ms
     99%    1.40s 
  1278 requests in 1.00m, 559.65KB read
  Socket errors: connect 0, read 0, write 0, timeout 20
  Non-2xx or 3xx responses: 7
Requests/sec:     21.27
Transfer/sec:      9.31KB
```
