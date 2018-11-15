.. -*- coding: utf-8 -*-
.. URL: https://docs.docker.com/engine/swarm/key-concepts/
.. SOURCE: https://github.com/docker/docker.github.io/blob/master/engine/swarm/key-concepts.md
   doc version: 18.09
      https://github.com/docker/docker.github.io/commits/master/engine/swarm/key-concepts.md
.. check date: 2016/11/10
.. Commits on Oct 21, 2017 142aee0354669b7cdb114c644c32cb360442d691
.. -----------------------------------------------------------------------------

.. Swarm mode key concepts

.. _swam-mode-key-concepts:

=======================================
Swarm モードの重要な概念
=======================================

.. sidebar:: 目次

   .. contents::
       :depth: 3
       :local:

.. This topic introduces some of the concepts unique to the cluster management and
   orchestration features of Docker Engine 1.12.

このトピックでは、Docker Engine 1.12 の独特の概念であるクラスタ管理とオーケストレーション機能を紹介します。

.. What is a swarm?

.. _what-is-a-swarm:

swarm とは何か？
====================

.. The cluster management and orchestration features embedded in the Docker Engine
   are built using [swarmkit](https://github.com/docker/swarmkit/). Swarmkit is a
   separate project which implements Docker's orchestration layer and is used
   directly within Docker.

クラスタ管理とオーケストレーション機能は、 Docker Engine に組み込まれた（内蔵された）もので、
`SwarmKit <https://github.com/docker/swarmkit/>`_ を使って実現しています。
SwarmKit は Docker のオーケストレーションレイヤを実装するための独立したプロジェクトで、
Docker 内から直接呼び出されます。


.. A swarm consists of multiple Docker hosts which run in **swarm mode** and act as
   managers (to manage membership and delegation) and workers (which run
   [swarm services](key-concepts.md#services-and-tasks)). A given Docker host can
   be a manager, a worker, or perform both roles. When you create a service, you
   define its optimal state (number of replicas, network and storage resources
   available to it, ports the service exposes to the outside world, and more).
   Docker works to maintain that desired state. For instance, if a worker node
   becomes unavailable, Docker schedules that node's tasks on other nodes. A _task_
   is a running container which is part of a swarm service and managed by a swarm
   manager, as opposed to a standalone container.

複数の Docker ホストで構成する swarm は **swarm mode** で動作し、
マネージャ(メンバとデリゲーションを管理)とワーカ( :ref:`swarm サービス <swarm-ceoncepts-services-and-tasks>` を実行)
として動作します。 Docker ホストはマネージャとしてもワーカとしても両方のロールとして
動作する可能性がある。サービスを作成したとき、その期待する状態(レプリカ数や利用可能なネットワークと
ストレージリソース、サービスが世の中に公開するポート番号など)を指定する。
Docker はそのような期待する状態を維持するように動作する。例として、ワーカノードが
利用できなくなったとき、 Docker はそのノードのタスクを他のノードにスケジュールする。
*タスク* とは独立して動作するコンテナとは異なり、 swarm により管理され、 swarm サービスの
一部として動作するコンテナである。

.. One of the key advantages of swarm services over standalone containers is that
   you can modify a service's configuration, including the networks and volumes it
   is connected to, without the need to manually restart the service. Docker will
   update the configuration, stop the service tasks with the out of date
   configuration, and create new ones matching the desired configuration.

単にコンテナを実行することに対する swarm サービスの重要なメリットは、サービスと連携した
ネットワークやボリュームなどの設定をサービスを手動で再起動させることなく修正できることにある。
Docker は設定を更新し、古い設定のサービスタスクを停止し、そして期待する設定と合致した
新しいサービスタスクを作成する。

.. When Docker is running in swarm mode, you can still run standalone containers
   on any of the Docker hosts participating in the swarm, as well as swarm
   services. A key difference between standalone containers and swarm services is
   that only swarm managers can manage a swarm, while standalone containers can be
   started on any daemon. Docker daemons can participate in a swarm as managers,
   workers, or both.

Docker が swarm モードで動作するとき、 Docker ホストが swarm に加わっていたり、
swarm サービスを実行していたりしても、スタンドアローンなコンテナを実行することができる。
スタンドアローンコンテナと swarm サービスの重要な違いとして swarm マネージャのみが
swarm を管理可能であり、スタンドアローンコンテナは任意のデーモンにより実行される。
Docker デーモンは swarm にマネージャとしてもワーカとしてもその両方としても参加可能である。

.. In the same way that you can use [Docker Compose](/compose/) to define and run
   containers, you can define and run swarm service
   [stacks](/get-started/part5.md).

:doc:`Docker Compose </compose/>` を定義し実行するのと同じ方法で
swarm サービス :doc:`stack </get-started/part5>` を定義し実行することができる。

.. Keep reading for details about concepts relating to Docker swarm services,
   including nodes, services, tasks, and load balancing.

Docker swarm サービスに関連するコンセプトとしてノードやサービス、タスク、ロードバランシング
の詳細については、引き続きこのドキュメントを読んで下さい。


.. Node

.. _swarm-concept-node:

ノード
==========

.. A **node** is an instance of the Docker engine participating in the swarm. You can also think of this as a Docker node. You can run one or more nodes on a single physical computer or cloud server, but production swarm deployments typically include Docker nodes distributed across multiple physical and cloud machines.

**ノード（node）** とは、Swarm 内に参加する  Docker engine インスタンスです。
これは Docker ノードとみなすことができます。
1つ以上のノードを1つの物理サーバやクラウドサーバで実行することもできますが、
プロダクション用途の swarm デプロイでは一般的に複数の物理サーバやクラウドサーバ上で分散して実行します。

.. To deploy your application to a swarm, you submit a service definition to a
   **manager node**. The manager node dispatches units of work called
   [tasks](#services-and-tasks) to worker nodes.

アプリケーションを swarm にデプロイするには、 **マネージャ・ノード（manager node）** にサービス定義を送信します。マネージャ・ノードはワーカー・ノードへ :ref:`タスク <swarm-concept-services-and-tasks>` と呼ばれる単位を送ります（ディスパッチします）。

.. Manager nodes also perform the orchestration and cluster management functions
   required to maintain the desired state of the swarm. Manager nodes elect a
   single leader to conduct orchestration tasks.

また、マネージャ・ノードは swarm の期待状態（desired state）を維持するために、オーケストレーションと管理機能を処理します。マネージャ・ノードはオーケストレーション・タスクを処理するため、単一のリーダーを選出（elect）します。

.. **Worker nodes** receive and execute tasks dispatched from manager nodes.
   By default manager nodes also run services as worker nodes, but you can
   configure them to run manager tasks exclusively and be manager-only
   nodes. An agent runs on each worker node and reports on the tasks assigned to
   it. The worker node notifies the manager node of the current state of its
   assigned tasks so that the manager can maintain the desired state of each
   worker.

**ワーカ・ノード（worker nodes）** はマネージャ・ノードから送られてきたタスクの受信と処理をします。
デフォルトでは、マネージャ・ノードはワーカ・ノードとしてサービスも実行しますが、
マネージャタスクを排他的に実行しマネージャのみのノード（manager-only node）としてもマネージャを設定可能です。
エージェントは各ワーカ・ノードで動作し割り当てられたタスクを報告します。
ワーカ・ノードは割り当てられたタスクの現在の状況をマネージャ・ノードに伝えるため、
マネージャは各ワーカの期待状態を維持できます。

.. Services and tasks

.. _swarm-concept-services-and-tasks:

サービスとタスク
====================

.. A **service** is the definition of the tasks to execute on the manager or worker nodes. It
   is the central structure of the swarm system and the primary root of user
   interaction with the swarm.

**サービス（service）** とは、マネージャ・ノードやワーカ・ノードで実行されるタスクを定義したものである。
swarm システムの中心的な仕組みでありユーザが swarm を操作するときの根本的な仕組みである。

.. When you create a service, you specify which container image to use and which
   commands to execute inside running containers.

サービスの作成時に指定するのは、どのコンテナ・イメージを使い、コンテナ内でどのようなコマンドを実行するかです。

.. In the **replicated services** model, the swarm manager distributes a specific
   number of replica tasks among the nodes based upon the scale you set in the
   desired state.

**複製サービス（replicated services）** モデルとは、 期待状態の指定に基づき、swarm マネージャがノード間に複製タスク（replica task）を指定した数だけ分散します。

.. For **global services**, the swarm runs one task for the service on every
   available node in the cluster.

**グローバル・サービス（global services）** とは、特定のタスクをクラスタ内の全ノード上で利用可能になるように swarm が実行します。

.. A **task** carries a Docker container and the commands to run inside the
   container. It is the atomic scheduling unit of swarm. Manager nodes assign tasks
   to worker nodes according to the number of replicas set in the service scale.
   Once a task is assigned to a node, it cannot move to another node. It can only
   run on the assigned node or fail.

**タスク（task）** とは Docker コンテナを運び、コンテナ内でコマンドを実行します。これは Swarm における最小スケジューリング単位です。マネージャ・ノードはワーカ・ノードに対してタスクを割り当てます。割り当てる数はサービスのスケールで設定されたレプリカ数に応じます。タスクがノードに割り当てられれば、他のノードに移動できません。移動できるのはノードに割り当て時か落ちた時だけです。

.. Load balancing

.. _swarm-concept-load-balanicng:

ロード・バランシング（負荷分散）
========================================

.. The swarm manager uses **ingress load balancing** to expose the services you
   want to make available externally to the swarm. The swarm manager can
   automatically assign the service a **PublishedPort** or you can configure a
   PublishedPort for the service. You can specify any unused port. If you do not
   specify a port, the swarm manager assigns the service a port in the 30000-32767
   range.

Swarm の外部で使いたいサービスを公開するため、swarm マネージャは
**イングレス・ロード・バランシング（ingress load balancing）**
（訳者注：入ってくるトラフィックに対する負荷分散機構）を使います。
Swarm はサービスに対して自動的に **PublishedPort （公開用ポート）** を割り当てられます。
あるいは、自分でサービス用の PublishedPort を設定できます。未使用ポートであればどのポートでも利用できます。
もしポートを指定しない場合は、 swarm マネージャは 30000 ～ 32767 の範囲でサービスにポートを割り当てます。

.. External components, such as cloud load balancers, can access the service on the
   PublishedPort of any node in the cluster whether or not the node is currently
   running the task for the service.  All nodes in the swarm route ingress
   connections to a running task instance.

クラウドのロードバランサのような外部コンポーネントは、
クラスタ上のあらゆるノード上の PublishedPort にアクセスできます。
たとえ、対象のノード上でサービス用のタスクが（その時点で）動作していなくてもです。
swarm 上にある全てのノードが、イングレスへの接続をタスクを実行しているインスタンスに転送します。

.. Swarm mode has an internal DNS component that automatically assigns each service
   in the swarm a DNS entry. The swarm manager uses **internal load balancing** to
   distribute requests among services within the cluster based upon the DNS name of
   the service.

Swarm には内部 DNS コンポーネントがあります。これは各サービスを自動的に Swarm DNS エントリに割り当てます。swarm マネージャは **内部ロード・バランシング（internal load balancing）** を使い、クラスタ内におけるサービスの DNS 名に基づき、サービス間でリクエストを分散します。

次はどうしますか？
====================

.. 
    Read the swarm mode overview.
    Get started with the swarm mode tutorial.

* :doc:`swarm モード概要 <index>` を読む
* :doc:`swarm モード・チュートリアル <swarm-tutorial/index>` を始める

.. seealso:: 

   Docker Swarm key concepts
      https://docs.docker.com/engine/swarm/key-concepts/
