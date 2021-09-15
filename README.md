# fluent2others
For general purpose fluent Docker Image 
## build
- alpine3.13+fluent-1.13.x + 3つのOutput PluginでBuildする
```
 $ docker build -t fluent2others:0.0.1 .
```
## InPut / OutPut
### plugin追加
- Dockerfileを修正の上、再Buildをお願いします
### 設定
- fluent/etc/conf.d/*.conf を読み込む為、適宜Pluginに応じた追加をしてください
  - e.g. fluent/etc/conf.d/out-machinist.conf
  - e.g. fluent/etc/conf.d/out-promtheus.conf 
## run
- 起動確認
```
$ docker run --name test-fluent -it fluent2others:0.0.1
2021-09-15 06:13:41 +0000 [info]: parsing config file is succeeded path="/fluentd/etc/fluent.conf"
2021-09-15 06:13:41 +0000 [info]: gem 'fluent-plugin-machinist' version '0.1.0'
2021-09-15 06:13:41 +0000 [info]: gem 'fluent-plugin-prometheus' version '2.0.2'
2021-09-15 06:13:41 +0000 [info]: gem 'fluent-plugin-splunk-enterprise' version '0.10.2'
2021-09-15 06:13:41 +0000 [info]: gem 'fluentd' version '1.13.3'
2021-09-15 06:13:41 +0000 [info]: using configuration file: <ROOT>
</ROOT>
2021-09-15 06:13:41 +0000 [info]: starting fluentd-1.13.3 pid=9 ruby="2.7.4"
2021-09-15 06:13:41 +0000 [info]: spawn command to main:  cmdline=["/usr/bin/ruby", "-Eascii-8bit:ascii-8bit", "/usr/bin/fluentd", "--config", "/fluentd/etc/fluent.conf", "--plugin", "/fluentd/plugins", "--under-supervisor"]
2021-09-15 06:13:42 +0000 [info]: #0 starting fluentd worker pid=18 ppid=9 worker=0
2021-09-15 06:13:42 +0000 [info]: #0 fluentd worker is now running worker=0
^C2021-09-15 06:13:50 +0000 [info]: Received graceful stop
2021-09-15 06:13:51 +0000 [info]: #0 fluentd worker is now stopping worker=0
2021-09-15 06:13:51 +0000 [info]: #0 shutting down fluentd worker worker=0
2021-09-15 06:13:51 +0000 [info]: Worker 0 finished with status 0
```
