.. -*- coding: utf-8 -*-
.. URL: https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/
.. SOURCE: https://github.com/docker/docker.github.io/blob/master/engine/swarm/swarm-tutorial/deploy-service.md
   doc version: 18.09
      https://github.com/docker/docker/commits/master/engine/swarm/swarm-tutorial/deploy-service.md
.. check date: 2018/11/17
.. Commits on Feb 24, 2017 d4add4ee209378c810d5871ea5f6092704a73dba
.. -----------------------------------------------------------------------------

.. Deploy a service to the swarm

.. _deploy-service-to-the-swarm:

=======================================
swarm にサービスをデプロイ
=======================================

.. sidebar:: 目次

   .. contents:: 
       :depth: 3
       :local:

.. After you [create a swarm](create-swarm.md), you can deploy a service to the
   swarm. For this tutorial, you also [added worker nodes](add-nodes.md), but that
   is not a requirement to deploy a service.

:doc:`swarm を作成 <create-swarm>` したら、swarm にサービスをデプロイできます。このチュートリアルでは :doc:`ワーカーノードも追加 <add-nodes>` しましたが、サービスのデプロイには必須ではありません。

.. 1.  Open a terminal and ssh into the machine where you run your manager node.
       For example, the tutorial uses a machine named `manager1`.

1. ターミナルを開き、マネージャ・ノードを実行中のマシンに SSH で入ります。このチュートリアルでは ``manager1`` という名前のマシンを使います。

.. 2.  Run the following command:

2. 次のコマンドを実行します。

   .. ```bash
      $ docker service create --replicas 1 --name helloworld alpine ping docker.com

      9uk4639qpg7npwf3fn2aasksr
      ```

   .. code-block:: bash

      $ docker service create --replicas 1 --name helloworld alpine ping docker.com

      9uk4639qpg7npwf3fn2aasksr

   .. * The `docker service create` command creates the service.
      * The `--name` flag names the service `helloworld`.
      * The `--replicas` flag specifies the desired state of 1 running instance.
      * The arguments `alpine ping docker.com` define the service as an Alpine
      Linux container that executes the command `ping docker.com`.

   * ``docker service create`` コマンドはサービスを作成します。
   * ``--name`` フラグはサービスに ``helloworld`` と名前を付けます。
   * ``--replicas`` フラグは実行インスタンスの期待状態を１と定義します。
   * 引数 ``alpine ping docker.com`` はサービスの定義です。Alpine Linux container で ``ping docker.com`` を実行するサービスです。

.. 3.  Run `docker service ls` to see the list of running services:

3. ``docker service ls`` で実行中のサービスを確認できます。

   .. ```bash
      $ docker service ls

      ID            NAME        SCALE  IMAGE   COMMAND
      9uk4639qpg7n  helloworld  1/1    alpine  ping docker.com
      ```

   .. code-block:: bash

      $ docker service ls

      ID            NAME        SCALE  IMAGE   COMMAND
      9uk4639qpg7n  helloworld  1/1    alpine  ping docker.com

.. What's next?

次は何をしますか？
====================

.. Now you've deployed a service to the swarm, you're ready to [inspect the service](inspect-service.md).

swarm にサービスをデプロイしましたので、 :doc:`サービスを調べる <inspect-service>` 準備が整いました。

.. seealso:: 

   Deploy a service to the swarm
      https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/
