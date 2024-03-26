
# Load Testing with no Load Balancer Limits

## Control Test

### Docker Stats for the Control Test

Similarly to the test for limiting all the Nginx servers, a control trial has been conducted as a reference.

| CONTAINER ID   | NAME            | CPU % | MEM USAGE / LIMIT   | MEM % | NET I/O         | BLOCK I/O       | PIDS |
|----------------|-----------------|-------|---------------------|-------|-----------------|-----------------|------|
| f5e7e809b3be   | load-balancer   | 6.25% | 10.26MiB / 7.616GiB | 0.13% | 1.79MB / 2.16MB | 17.6MB / 2.15MB | 4    |
| 858b049e2ccf   | edge1           | 0.78% | 10.3MiB / 7.616GiB  | 0.13% | 180kB / 398kB   | 18MB / 2.35MB   | 4    |
| a586d75ac410   | edge2           | 1.41% | 7.008MiB / 7.616GiB | 0.09% | 202kB / 442kB   | 16.4MB / 2.35MB | 4    |
| 0912e49185ea   | edge3           | 0.87% | 9.809MiB / 7.616GiB | 0.13% | 174kB / 390kB   | 17.5MB / 4.67MB | 4    |
| 1c231e280dbb   | edge4           | 1.99% | 4.125MiB / 7.616GiB | 0.05% | 358kB / 716kB   | 14.6MB / 2.34MB | 4    |
| 935230a9c531   | backend1        | 0.09% | 29.23MiB / 7.616GiB | 0.37% | 12.9kB / 76kB   | 20.6MB / 0B     | 2    |
| 39e40aa25d21   | backend2        | 0.05% | 21.54MiB / 7.616GiB | 0.28% | 13kB / 75.6kB   | 16.8MB / 1.07MB | 2    |

### Wrk output for 1m, Control Test

Over 6300 requests in 1m, avg. latency of 135 ms.

```shell
Running 1m test @ http://localhost:18080
  4 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   135.09ms  210.96ms   2.00s    87.26%
    Req/Sec    31.61     20.45   111.00     62.77%
  Latency Distribution
     50%   41.52ms
     75%  168.83ms
     90%  404.19ms
     99%    1.01s 
  6306 requests in 1.00m, 2.70MB read
  Socket errors: connect 0, read 0, write 0, timeout 8
  Non-2xx or 3xx responses: 9
Requests/sec:    105.00
Transfer/sec:     46.01KB
```

## Limiting Edge CPU

Knowing the rough numbers that are achievable by the servers I decided to test how will the system perform when `edge` nodes are limited to only **1% CPU**. Here are the results:

### Docker stats for the 1st case

| CONTAINER ID   | NAME            | CPU % | MEM USAGE / LIMIT   | MEM % | NET I/O         | BLOCK I/O       | PIDS |
|----------------|-----------------|-------|---------------------|-------|-----------------|-----------------|------|
| 9e5a3342d251   | load-balancer   | 3.51% | 30.08MiB / 7.616GiB | 0.39% | 1.08MB / 1.4MB  | 13.3MB / 0B     | 4    |
| 2b4aa8df641c   | edge1           | 0.61% | 29.36MiB / 7.616GiB | 0.38% | 96.2kB / 272kB  | 13.2MB / 0B     | 4    |
| 8bce1bb57bd3   | edge2           | 0.54% | 29.75MiB / 7.616GiB | 0.38% | 134kB / 327kB   | 13.2MB / 0B     | 4    |
| 4805c4fb56bc   | edge3           | 0.81% | 29.71MiB / 7.616GiB | 0.38% | 113kB / 295kB   | 13.2MB / 0B     | 4    |
| 88005920852f   | edge4           | 0.83% | 29.94MiB / 7.616GiB | 0.38% | 224kB / 488kB   | 13.5MB / 0B     | 4    |
| c326de938d7d   | backend1        | 0.11% | 15.91MiB / 7.616GiB | 0.20% | 13.7kB / 85kB   | 13.5MB / 0B     | 2    |
| 6a1f752b2b9b   | backend2        | 0.03% | 40.45MiB / 7.616GiB | 0.52% | 12.3kB / 74.6kB | 13.3MB / 0B     | 2    |

### Wrk output for 1m, 1% CPU Cap

Roughly 3100 requests in 1m, avg. latency 195 ms.

```shell
Running 1m test @ http://localhost:18080
  4 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   195.25ms  239.56ms   1.89s    88.97%
    Req/Sec    15.76     10.96    70.00     77.27%
  Latency Distribution
     50%  111.93ms
     75%  256.05ms
     90%  471.28ms
     99%    1.26s 
  3104 requests in 1.00m, 1.33MB read
  Socket errors: connect 0, read 0, write 0, timeout 5
  Non-2xx or 3xx responses: 4
Requests/sec:     51.68
Transfer/sec:     22.64KB
```

## Limiting Edge CPU & Memory

Now I wanted to check how the simulation changes upon limiting the memory for `edge` servers.
I decided to set a limit as a half of the average memory consumption for the last test, so roughty **15MiB**.

### Docker Stats for the 2nd case

| CONTAINER ID   | NAME            | CPU % | MEM USAGE / LIMIT   | MEM %  | NET I/O         | BLOCK I/O       | PIDS |
|----------------|-----------------|-------|---------------------|--------|-----------------|-----------------|------|
| 92288fe362be   | load-balancer   | 0.59% | 28.89MiB / 7.616GiB | 0.37%  | 1.68MB / 2.2MB  | 13.2MB / 0B     | 3    |
| 8210bad84cd6   | edge1           | 0.56% | 11.21MiB / 15MiB    | 74.77% | 169kB / 450kB   | 49.5MB / 1.79MB | 4    |
| 384b53e3944d   | edge2           | 0.93% | 9.945MiB / 15MiB    | 66.30% | 188kB / 494kB   | 41.6MB / 2.91MB | 4    |
| a48a64746d5c   | edge3           | 0.05% | 10.96MiB / 15MiB    | 73.05% | 189kB / 495kB   | 42.6MB / 2.31MB | 3    |
| 79044c53f438   | edge4           | 1.09% | 10.44MiB / 15MiB    | 69.58% | 327kB / 726kB   | 54.5MB / 2.19MB | 4    |
| 965ff2d69c44   | backend1        | 0.02% | 39.99MiB / 7.616GiB | 0.51%  | 16.6kB / 122kB  | 13.6MB / 0B     | 2    |
| d13ab5e47dae   | backend2        | 0.05% | 39.73MiB / 7.616GiB | 0.51%  | 16.9kB / 116kB  | 13.3MB / 65.5kB | 2    |

### Wrk output for 1m, 1% CPU and 15 MiB memory cap

Nearly 3000 requests in 1m, avg. latency of 205 ms.

The difference is small, considering that the memory usage was cut more than in half in respect to the previous measurement.

```shell
Running 1m test @ http://localhost:18080
  4 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   205.65ms  251.09ms   2.00s    87.26%
    Req/Sec    15.87     11.22   100.00     74.44%
  Latency Distribution
     50%  108.29ms
     75%  287.49ms
     90%  512.18ms
     99%    1.19s 
  2970 requests in 1.00m, 1.27MB read
  Socket errors: connect 0, read 0, write 0, timeout 7
  Non-2xx or 3xx responses: 7
Requests/sec:     49.42
Transfer/sec:     21.66KB
```
