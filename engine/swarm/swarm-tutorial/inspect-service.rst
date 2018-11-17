.. -*- coding: utf-8 -*-
.. URL: https://docs.docker.com/engine/swarm/swarm-tutorial/inspect-service/
.. SOURCE: https://github.com/docker/docker.github.io/blob/master/engine/swarm/swarm-tutorial/inspect-service.md
   doc version: 18.09
      https://github.com/docker/docker/commits/master/engine/swarm/swarm-tutorial/inspect-service.md
.. check date: 2018/11/17
.. Commits on Nov 16, 2017 9308caf1f46c6a8ea5b32799f8fa7949f85b67b4
.. -----------------------------------------------------------------------------

.. Inspect a service on the swarm

.. _inspect-a-service-on-the-swarm:

=======================================
swarm 上のサービスを調べる
=======================================

.. sidebar:: 目次

   .. contents:: 
       :depth: 3
       :local:

.. When you have [deployed a service](deploy-service.md) to your swarm, you can use
   the Docker CLI to see details about the service running in the swarm.

swarm に :doc:`サービスをデプロイ <deploy-service>` したら、swarm 上で実行している全サービスの詳細を Docker CLI で確認できます。

.. 1.  If you haven't already, open a terminal and ssh into the machine where you
       run your manager node. For example, the tutorial uses a machine named
       `manager1`.

1. 準備がまだであれば、ターミナルを開き、マネージャ・ノードを実行しているマシンに SSH で入ります。たとえば、このチュートリアルでは ``manager1`` という名前のマシンを使います。

.. 2.  Run `docker service inspect --pretty <SERVICE-ID>` to display the details
       about a service in an easily readable format.

2. ``docker service inspect --pretty <サービスID>`` を実行したら、サービスに関する詳細を読みやすい形式で表示します。

   .. To see the details on the `helloworld` service:

   ``helloworld`` サービスの詳細を見るには、次のようにします。

   .. ```bash
      [manager1]$ docker service inspect --pretty helloworld

      ID:		9uk4639qpg7npwf3fn2aasksr
      Name:		helloworld
      Service Mode:	REPLICATED
       Replicas:		1
      Placement:
      UpdateConfig:
       Parallelism:	1
      ContainerSpec:
       Image:		alpine
       Args:	ping docker.com
      Resources:
      Endpoint Mode:  vip
      ```

   .. code-block:: bash

      [manager1]$ docker service inspect --pretty helloworld

      ID:		9uk4639qpg7npwf3fn2aasksr
      Name:		helloworld
      Service Mode:	REPLICATED
       Replicas:		1
      Placement:
      UpdateConfig:
       Parallelism:	1
      ContainerSpec:
       Image:		alpine
       Args:	ping docker.com
       Resources:
      Endpoint Mode:  vip

   .. >**Tip**: To return the service details in json format, run the same command
      without the `--pretty` flag.

   .. tip::

      サービスの詳細を json 形式で得るには、同じコマンドで ``--pretty`` フラグを使わずに実行します。

   .. ```bash
      [manager1]$ docker service inspect helloworld
      [
      {
          "ID": "9uk4639qpg7npwf3fn2aasksr",
          "Version": {
              "Index": 418
          },
          "CreatedAt": "2016-06-16T21:57:11.622222327Z",
          "UpdatedAt": "2016-06-16T21:57:11.622222327Z",
          "Spec": {
              "Name": "helloworld",
              "TaskTemplate": {
                  "ContainerSpec": {
                      "Image": "alpine",
                      "Args": [
                          "ping",
                          "docker.com"
                      ]
                  },
                  "Resources": {
                      "Limits": {},
                      "Reservations": {}
                  },
                  "RestartPolicy": {
                      "Condition": "any",
                      "MaxAttempts": 0
                  },
                  "Placement": {}
              },
              "Mode": {
                  "Replicated": {
                      "Replicas": 1
                  }
              },
              "UpdateConfig": {
                  "Parallelism": 1
              },
              "EndpointSpec": {
                  "Mode": "vip"
              }
          },
          "Endpoint": {
              "Spec": {}
          }
      }
      ]
      ```

   .. code-block:: bash

      $ docker service inspect helloworld
      [
      {
          "ID": "9uk4639qpg7npwf3fn2aasksr",
          "Version": {
              "Index": 418
          },
          "CreatedAt": "2016-06-16T21:57:11.622222327Z",
          "UpdatedAt": "2016-06-16T21:57:11.622222327Z",
          "Spec": {
              "Name": "helloworld",
              "TaskTemplate": {
                  "ContainerSpec": {
                      "Image": "alpine",
                      "Args": [
                          "ping",
                          "docker.com"
                      ]
                  },
                  "Resources": {
                      "Limits": {},
                      "Reservations": {}
                  },
                  "RestartPolicy": {
                      "Condition": "any",
                      "MaxAttempts": 0
                  },
                  "Placement": {}
              },
              "Mode": {
                  "Replicated": {
                      "Replicas": 1
                  }
              },
              "UpdateConfig": {
                  "Parallelism": 1
              },
              "EndpointSpec": {
                  "Mode": "vip"
              }
          },
          "Endpoint": {
              "Spec": {}
          }
      }
      ]

..    Run docker service ps <SERVICE-ID> to see which nodes are running the service:

3. ``docker service ps <サービスID>`` を実行すると、サービスがどのノードで動作しているのか分かります。

   .. ```bash
      [manager1]$ docker service ps helloworld

      NAME                                    IMAGE   NODE     DESIRED STATE  LAST STATE
      helloworld.1.8p1vev3fq5zm0mi8g0as41w35  alpine  worker2  Running        Running 3 minutes
      ```

   .. code-block:: bash

      [manager1]$ docker service ps helloworld

      NAME                                    IMAGE   NODE     DESIRED STATE  LAST STATE
      helloworld.1.8p1vev3fq5zm0mi8g0as41w35  alpine  worker2  Running        Running 3 minutes

   .. In this case, the one instance of the `helloworld` service is running on the
      `worker2` node. You may see the service running on your manager node. By
      default, manager nodes in a swarm can execute tasks just like worker nodes.


   この場合、 ``helloworld`` サービスは ``worker2`` ノード上で動作しています。
   マネージャ・ノード上でサービスを実行しているかもしれません。
   デフォルトでは、Swarm 内のマネージャ・ノードはワーカ・ノードのようにタスクを実行可能です。

   .. Swarm also shows you the `DESIRED STATE` and `LAST STATE` of the service
      task so you can see if tasks are running according to the service
      definition.

   また、swarm はサービス・タスクの ``DESIRED STATE`` （期待状態）と ``LAST STATE`` （最新状態）を表示します。これでサービス定義に従ってタスクを実行しているか確認できます。

.. 4.  Run `docker ps` on the node where the task is running to see details about
       the container for the task.

4. タスクを実行中のノード上で ``docker ps`` を実行したら、タスク用のコンテナに関する詳細を確認できます。

   .. >**Tip**: If `helloworld` is running on a node other than your manager node,
      you must ssh to that node.

   .. tip::

      ``helloworld`` がマネージャ・ノード以外で実行中の場合は、対象ノードに SSH する必要があります。

   .. ```bash
      [worker2]$docker ps

      CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
      e609dde94e47        alpine:latest       "ping docker.com"   3 minutes ago       Up 3 minutes                            helloworld.1.8p1vev3fq5zm0mi8g0as41w35
      ```

   .. code-block:: bash

      [worker2]$docker ps

      CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
      e609dde94e47        alpine:latest       "ping docker.com"   3 minutes ago       Up 3 minutes                            helloworld.1.8p1vev3fq5zm0mi8g0as41w35

.. What's next?

次は何をしますか？
====================

.. Next, you can [change the scale](scale-service.md) for the service running in
   the swarm.

次は、スワーム内で実行するサービスの :doc:`スケールを変更 <scale-service>` できます。

.. seealso:: 

   Inspect a service on the swarm
      https://docs.docker.com/engine/swarm/swarm-tutorial/inspect-service/
