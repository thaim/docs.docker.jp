.. -*- coding: utf-8 -*-
.. URL: https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/
.. SOURCE: https://github.com/docker/docker.github.io/blob/master/engine/swarm/swarm-tutorial/create-swarm.md
   doc version: 18.09
      https://github.com/docker/docker/commits/master/engine/swarm/swarm-tutorial/create-swarm.md
.. check date: 2018/11/16
.. Commits on Jan 26, 2018 a4f5e3024919b0bbfe294e0a4e65b7b6e09c487e
.. -----------------------------------------------------------------------------

.. Create a swarm

.. _create-a-swam:

=======================================
swarm （群れ）の作成
=======================================

.. sidebar:: 目次

   .. contents::
       :depth: 3
       :local:

.. After you complete the [tutorial setup](index.md) steps, you're ready
   to create a swarm. Make sure the Docker Engine daemon is started on the host
   machines.

:doc:`チュートリアルのセットアップ <index>` ステップを終えたら、 sarm （群れ；クラスタの意味）を作成する準備が整いました。ホストマシン上で Docker Engine デーモンが起動しているか確認してください。

.. 1.  Open a terminal and ssh into the machine where you want to run your manager
       node. This tutorial uses a machine named `manager1`. If you use Docker Machine,
       you can connect to it via SSH using the following command:

       ```bash
       $ docker-machine ssh manager1
       ```

1. ターミナルを開き、マネージャ・ノードにしたいマシンに SSH で入ります。
   このチュートリアルでは ``manager1`` という名前のマシンを使います。
   もし Docker Machine を利用しているのであれば、以下のコマンドを実行して
   SSH で接続することができます。

.. code-block::

   $ docker-machine ssh manager1

.. 2.  Run the following command to create a new swarm:

       ```bash
       docker swarm init --advertise-addr <MANAGER-IP>

2. 新しい swarm を作成するために、次のコマンドを実行します。

.. code-block:: bash

   docker swarm init --listen-addr <MANAGER-IP>

.. >**Note**: If you are using Docker for Mac or Docker for Windows to test
   single-node swarm, simply run `docker swarm init` with no arguments. There is no
   need to specify `--advertise-addr` in this case. To learn more, see the topic
   on how to [Use Docker for Mac or Docker for
   Windows](/engine/swarm/swarm-tutorial/index.md#use-docker-for-mac-or-docker-for-windows) with Swarm.

.. note::

   シングルノード swarm を試すために Docker for Mac や Docker for Windows を利用しているのであれば、
   単に ``docker swarm init`` を引数なしで実行してください。その場合は ``--advertise-addr`` を指定
   する必要はありません。より詳細を確認するためには、 Swarm における
   :ref:`Docker for Mac や Docker for Windows を利用する <use-docker-for-mac-or-docker-for-windows>`
   を参照してください。

..     In the tutorial, the following command creates a swarm on the `manager1`
       machine:

このチュートリアルでは、 ``manager1`` マシン上で次の swarm 作成コマンドを実行します。

..     ```bash
       $ docker swarm init --advertise-addr 192.168.99.100
       Swarm initialized: current node (dxn1zf6l61qsb1josjja83ngz) is now a manager.

       To add a worker to this swarm, run the following command:

           docker swarm join \
           --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
           192.168.99.100:2377

       To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
       ```

.. code-block:: bash

   $ docker swarm init --listen-addr 192.168.99.100
   Swarm initialized: current node (dxn1zf6l61qsb1josjja83ngz) is now a manager.

   To add a worker to this swarm, run the following command:

       docker swarm join \
       --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
       192.168.99.100:2377

   To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.


..  The `--advertise-addr` flag configures the manager node to publish its
    address as `192.168.99.100`. The other nodes in the swarm must be able
    to access the manager at the IP address.

``--listen-addr`` フラグは、マネージャ・ノードでアドレス ``192.168.99.100`` を公開する設定です。
swarm における他のノードは、この IP アドレスでマネージャに接続できます。

..  The output includes the commands to join new nodes to the swarm. Nodes will
    join as managers or workers depending on the value for the `--token`
    flag.

出力結果は新しいノードを swarm に参加させるコマンドを示しています。
``--token`` フラグの値によって、ノードはマネージャまたはノードとして参加します。


.. 2.  Run `docker info` to view the current state of the swarm:

       ```bash
       $ docker info

       Containers: 2
       Running: 0
       Paused: 0
       Stopped: 2
         ...snip...
       Swarm: active
         NodeID: dxn1zf6l61qsb1josjja83ngz
         Is Manager: true
         Managers: 1
         Nodes: 1
         ...snip...
       ```

3. ``docker info`` を実行し、現在の swarm の状況を表示します：

.. code-block:: bash

    $ docker info

    Containers: 2
     Running: 0
     Paused: 0
     Stopped: 2
    ...省略...
    Swarm: active
     NodeID: dxn1zf6l61qsb1josjja83ngz
     Is Manager: true
     Managers: 1
     Nodes: 1
    ...省略...

.. 3.  Run the `docker node ls` command to view information about nodes:

       ```bash
       $ docker node ls

       ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
       dxn1zf6l61qsb1josjja83ngz *  manager1  Ready   Active        Leader

       ```

4. ``docker node ls`` コマンドを実行し、ノードに関する情報を表示します。

.. code-block:: bash

   $ docker node ls

   ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
   dxn1zf6l61qsb1josjja83ngz *  manager1  Ready   Active        Leader


..    The `*` next to the node ID indicates that you're currently connected on
      this node.

   ノード ID の横にある ``*`` 印は、現在接続中のノードを表します。

..    Docker Engine swarm mode automatically names the node for the machine host
      name. The tutorial covers other columns in later steps.

Docker Engine swarm モードはノードに対して、マシンのホスト名を自動的に付けます。他の列については、後半のステップで扱います。

.. What's next?

次は何をしますか？
====================

.. In the next section of the tutorial, we [add two more nodes](add-nodes.md) to
   the cluster.

チュートリアルの次のセクションで、クラスタに :doc:`さらに２つのノードを追加 <add-nodes>` します。

.. seealso:: 

   Create a swarm
      https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/
