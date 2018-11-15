.. -*- coding: utf-8 -*-
.. URL: https://docs.docker.com/engine/swarm/swarm-tutorial/add-nodes/
.. SOURCE: https://github.com/docker/docker.github.io/blob/master/engine/swarm/swarm-tutorial/add-nodes.md
   doc version: 18.09
      https://github.com/docker/docker/commits/master/engine/swarm/swarm-tutorial/add-nodes.md
.. check date: 2018/11/16
.. Commits on Feb 24, 2017 d4add4ee209378c810d5871ea5f6092704a73dba
.. -----------------------------------------------------------------------------

.. Add nodes to the swarm

.. _add-nodes-to-the-swarm:

=======================================
swarm に他のノードを追加
=======================================

.. sidebar:: 目次

   .. contents:: 
       :depth: 3
       :local:

.. Once you've [created a swarm](create-swarm.md) with a manager node, you're ready
   to add worker nodes.

マネージャ・ノードで :doc:`swarm を作成 <./create-swarm.rst>` した後は、ワーカ・ノードを追加できる状態です。

.. 1.  Open a terminal and ssh into the machine where you want to run a worker node.
       This tutorial uses the name `worker1`.

1. ターミナルを開き、ワーカ・ノードを実行したいマシンに SSH で入ります。このチュートリアルでは ``worker1`` という名前のマシンを使います。

.. 2.  Run the command produced by the `docker swarm init` output from the
       [Create a swarm](create-swarm.md) tutorial step to create a worker node
       joined to the existing swarm:

2. 既存の swarm に参加するワーカ・ノードを作成するには、
   :doc:`swarm の作成 <create-swarm.rst>` チュートリアルステップで実行した
   ``docker swarm init`` コマンドの出力により生成されたコマンドを実行します：

..     ```bash
       $ docker swarm join \
         --token  SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
         192.168.99.100:2377

       This node joined a swarm as a worker.
       ```

.. code-block:: bash

   $ docker swarm join \
     --token  SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
     192.168.99.100:2377

..     If you don't have the command available, you can run the following command
       on a manager node to retrieve the join command for a worker:

もし利用可能なコマンドが手元にない場合は、マネージャ・ノードで以下のコマンドを実行することで
ワーカ・ノードを swarm に参加させるコマンドを表示させることができます：

..     ```bash
       $ docker swarm join-token worker

       To add a worker to this swarm, run the following command:

           docker swarm join \
           --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
           192.168.99.100:2377
       ```

.. code-block:: bash

   $ docker swarm join-token worker

   To add a worker to this swarm, run the following command:

       docker swarm join \
       --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
       192.168.99.100:2377

.. 3.  Open a terminal and ssh into the machine where you want to run a second
       worker node. This tutorial uses the name `worker2`.

3. ターミナルを開き、２つめのワーカ・ノードを実行したいマシンに SSH で入ります。このチュートリアルでは ``worker2`` を使います。

.. 4.  Run the command produced by the `docker swarm init` output from the
       [Create a swarm](create-swarm.md) tutorial step to create a second worker
       node joined to the existing swarm:

4. 既存の swarm に参加するワーカ・ノードを作成するには、
   :doc:`swarm の作成 <./create-swarm.rst>` チュートリアルステップで実行した
   ``docker swarm init`` コマンドの出力により生成されたコマンドを実行します：

..     ```bash
       $ docker swarm join \
         --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
         192.168.99.100:2377

       This node joined a swarm as a worker.
       ```

.. code-block:: bash

   $ docker swarm join \
     --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.99.100:2377

   This node joined a swarm as a worker.

.. 5.  Open a terminal and ssh into the machine where the manager node runs and
       run the `docker node ls` command to see the worker nodes:

5. ターミナルを開き、マネージャ・ノードを実行中のマシンにログインします。そして ``docker node ls`` コマンドを実行し、ワーカ・ノードを確認します。

..     ```bash
       ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
       03g1y59jwfg7cf99w4lt0f662    worker2   Ready   Active
       9j68exjopxe7wfl6yuxml7a7j    worker1   Ready   Active
       dxn1zf6l61qsb1josjja83ngz *  manager1  Ready   Active        Leader
       ```

.. code-block:: bash

   ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
   03g1y59jwfg7cf99w4lt0f662    worker2   Ready   Active
   9j68exjopxe7wfl6yuxml7a7j    worker1   Ready   Active
   dxn1zf6l61qsb1josjja83ngz *  manager1  Ready   Active        Leader

..    The `MANAGER` column identifies the manager nodes in the swarm. The empty
      status in this column for `worker1` and `worker2` identifies them as worker nodes.

swarm 上のマネージャ・ノードは ``MANAGER STATUS`` 列で分かります。 ``worker1`` と ``worker2`` のステータスは何もないため、ワーカーノードだと分かります。

..     Swarm management commands like `docker node ls` only work on manager nodes.

``docker node ls`` のような swarm 管理コマンドは、マネージャ・ノード上でのみ実行できます。

.. What's next?

次は何をしますか？
====================

.. Now your swarm consists of a manager and two worker nodes. In the next step of
   the tutorial, you [deploy a service](deploy-service.md) to the swarm.

これで swarm はマネージャと２つのワーカ・ノードで構成されています。チュートリアルの次のステップは swarm に :doc:`サービスをデプロイ <deploy-service>` します。

.. seealso:: 

   Add nodes to the swarm
      https://docs.docker.com/engine/swarm/swarm-tutorial/add-nodes/
