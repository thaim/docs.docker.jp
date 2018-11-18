.. -*- coding: utf-8 -*-
.. URL: https://docs.docker.com/engine/swarm/swarm-tutorial/rolling-update/
.. SOURCE: https://github.com/docker/docker.github.io/blob/master/engine/swarm/swarm-tutorial/rolling-update.md
   doc version: 18.09
      https://github.com/docker/docker.github.io/commits/master/docs/swarm/swarm-tutorial/
.. check date: 2018/11/19
.. Commits on Sep 29, 2016 9d5e59d503fdfe8bd2c9fe0f9e965df318a01267
.. -----------------------------------------------------------------------------

.. Apply rolling updates to a service

.. _apply-rolling-updates-to-a-service:

========================================
サービスにローリング・アップデートを適用
========================================

.. sidebar:: 目次

   .. contents:: 
       :depth: 3
       :local:

.. In a previous step of the tutorial, you [scaled](scale-service.md) the number of
   instances of a service. In this part of the tutorial, you deploy a service based
   on the Redis 3.0.6 container image. Then you upgrade the service to use the
   Redis 3.0.7 container image using rolling updates.

チュートリアルの前のステップでは、サービスのインスタンス数を :doc:`スケール <scale-service>` しました。次のチュートリアルは Redis 3.0.6 コンテナ・イメージをベースとしたサービスをデプロイします。そして、ローリング・アップデートで Redis 3.0.7 コンテナ・イメージを使うサービスに更新します。

.. 1.  If you haven't already, open a terminal and ssh into the machine where you
       run your manager node. For example, the tutorial uses a machine named
       `manager1`.

1. 準備がまだであれば、ターミナルを開き、マネージャ・ノードを実行しているマシンに SSH で入ります。たとえば、このチュートリアルでは ``manager1`` という名前のマシンを使います。

.. 2.  Deploy Redis 3.0.6 to the swarm and configure the swarm with a 10 second
       update delay:

2. Redis 3.0.6 を swarm にデプロイします。そして、10秒の更新遅延となるよう
   swarm に設定します。

   .. ```bash
      $ docker service create \
        --replicas 3 \
        --name redis \
        --update-delay 10s \
        redis:3.0.6

      0u6a4s31ybk7yw2wyvtikmu50
      ```

   .. code-block:: bash

      $ docker service create \
        --replicas 3 \
        --name redis \
        --update-delay 10s \
        redis:3.0.6

      0u6a4s31ybk7yw2wyvtikmu50

   .. You configure the rolling update policy at service deployment time.


   サービスのデプロイ時にローリング・アップデート・ポリシーを設定します。

   .. The `--update-delay` flag configures the time delay between updates to a
      service task or sets of tasks. You can describe the time `T` as a
      combination of the number of seconds `Ts`, minutes `Tm`, or hours `Th`. So
      `10m30s` indicates a 10 minute 30 second delay.

   ``--update-delay`` フラグは、サービス・タスクやタスク・セットを更新する遅延時間を指定します。時間 ``T`` を、秒数 ``Ts``  、分 ``Tm``  、時 ``Th`` の組み合わせで記述できます。たとえば ``10m30s`` は 10 分 30 秒の遅延です。

   .. By default the scheduler updates 1 task at a time. You can pass the
      `--update-parallelism` flag to configure the maximum number of service tasks
      that the scheduler updates simultaneously.

   デフォルトではスケジューラは1度に1つのタスクを更新します。 ``--update-parallelism``
   フラグを指定することでスケジューラが同時に更新するサービス・タスクの最大数を設定します。

   .. By default, when an update to an individual task returns a state of
      `RUNNING`, the scheduler schedules another task to update until all tasks
      are updated. If, at any time during an update a task returns `FAILED`, the
      scheduler pauses the update. You can control the behavior using the
      `--update-failure-action` flag for `docker service create` or
      `docker service update`.

   デフォルトでは、個々のタスクに対する更新が状態 ``RUNNING`` を返すとき、
   スケジューラはすべてのタスクが更新されるまでタスクの更新をスケジューリングします。
   もし、タスクの更新中のどのような場合でも状態 ``FAILED`` を返すならば、
   スケジューラは更新を中断します。この挙動は ``docker service create`` や
   ``docker service update`` コマンドを実行するときに ``--update-failure-action`` の
   フラグを利用することで制御できます。

.. 3.  Inspect the `redis` service:

3. ``redis`` サービスを調べます。

   .. ```bash
      $ docker service inspect --pretty redis

      ID:             0u6a4s31ybk7yw2wyvtikmu50
      Name:           redis
      Service Mode:   Replicated
       Replicas:      3
      Placement:
       Strategy:	    Spread
      UpdateConfig:
       Parallelism:   1
       Delay:         10s
      ContainerSpec:
       Image:         redis:3.0.6
      Resources:
      Endpoint Mode:  vip
      ```

   .. code-block:: bash

      $ docker service inspect  --pretty redis

      ID:             0u6a4s31ybk7yw2wyvtikmu50
      Name:           redis
      Service Mode:   Replicated
       Replicas:      3
      Placement:
       Strategy:      Spread
      UpdateConfig:
       Parallelism:   1
       Delay:         10s
      ContainerSpec:
       Image:         redis:3.0.6
      Resources:
      Endpoint Mode:  vip

.. 4.  Now you can update the container image for `redis`. The swarm  manager
       applies the update to nodes according to the `UpdateConfig` policy:

4. ``redis`` 用のコンテナ・イメージを更新します。 swarm マネージャ は ``UpdateConfig`` ポリシーに基づいてノード更新を適用します。

   .. ```bash
      $ docker service update --image redis:3.0.7 redis
      redis
      ```

   .. code-block:: bash

      $ docker service update --image redis:3.0.7 redis
      redis

   .. The scheduler applies rolling updates as follows by default:

   スケジューラはデフォルトではローリング・アップデートを以下のように適用します：

   .. * Stop the first task.
      * Schedule update for the stopped task.
      * Start the container for the updated task.
      * If the update to a task returns `RUNNING`, wait for the
        specified delay period then start the next task.
      * If, at any time during the update, a task returns `FAILED`, pause the
        update.

   * 最初のタスクを停止する
   * スケジューラは停止したタスクを更新する
   * 更新したタスクのコンテナを開始する
   * もし更新したタスクが ``RUNNING`` を返したら指定した更新時間だけ待ってから次のタスクを開始する
   * もし更新の途中でタスクが ``FAILED`` を返したら更新を停止する

.. 5.  Run `docker service inspect --pretty redis` to see the new image in the
       desired state:

5. ``docker service inspect --pretty redis`` を実行し、新しいイメージの期待状態を確認します。

   .. ```bash
      $ docker service inspect --pretty redis

      ID:             0u6a4s31ybk7yw2wyvtikmu50
      Name:           redis
      Service Mode:   Replicated
       Replicas:      3
      Placement:
       Strategy:	    Spread
      UpdateConfig:
       Parallelism:   1
       Delay:         10s
      ContainerSpec:
       Image:         redis:3.0.7
      Resources:
      Endpoint Mode:  vip
      ```

   .. code-block:: bash

      $ docker service inspect --pretty redis

      ID:             0u6a4s31ybk7yw2wyvtikmu50
      Name:           redis
      Mode:           Replicated
       Replicas:      3
      Placement:
       Strategy:      Spread
      UpdateConfig:
       Parallelism:   1
       Delay:         10s
      ContainerSpec:
       Image:         redis:3.0.7
      Resources:
      Endpoint Mode:  vip

   .. The output of `service inspect` shows if your update paused due to failure:

   更新に失敗して停止したかどうかは ``service inspect`` の出力で判断できます。

   .. ```bash
      $ docker service inspect --pretty redis

      ID:             0u6a4s31ybk7yw2wyvtikmu50
      Name:           redis
      ...snip...
      Update status:
       State:      paused
       Started:    11 seconds ago
       Message:    update paused due to failure or early termination of task 9p7ith557h8ndf0ui9s0q951b
      ...snip...
      ```

   .. code-block:: bash

      $ docker service inspect --pretty redis

      ID:             0u6a4s31ybk7yw2wyvtikmu50
      Name:           redis
      ...省略...
      Update status:
       State:      paused
       Started:    11 seconds ago
       Message:    update paused due to failure or early termination of task 9p7ith557h8ndf0ui9s0q951b
      ...省略...

   .. To restart a paused update run `docker service update <SERVICE-ID>`. For example:

   停止した更新処理を再開するには ``docker service update <サービスID>`` を実行します。例えば：

   .. ```bash
      docker service update redis
      ```

   .. code-block:: bash

      docker service update redis

   .. To avoid repeating certain update failures, you may need to reconfigure the
      service by passing flags to `docker service update`.

   特定の原因による更新失敗が繰り返されることを避けるためには、 ``docker service update``
   コマンドのフラグを指定してサービスを再設定する必要があるかもしれません。

.. 6.  Run `docker service ps <SERVICE-ID>` to watch the rolling update:

6. ``docker service ps <サービスID>`` を実行し、ローリング・アップデートを監視します。

   .. ```bash
      $ docker service ps redis

      NAME                                   IMAGE        NODE       DESIRED STATE  CURRENT STATE            ERROR
      redis.1.dos1zffgeofhagnve8w864fco      redis:3.0.7  worker1    Running        Running 37 seconds
       \_ redis.1.88rdo6pa52ki8oqx6dogf04fh  redis:3.0.6  worker2    Shutdown       Shutdown 56 seconds ago
      redis.2.9l3i4j85517skba5o7tn5m8g0      redis:3.0.7  worker2    Running        Running About a minute
       \_ redis.2.66k185wilg8ele7ntu8f6nj6i  redis:3.0.6  worker1    Shutdown       Shutdown 2 minutes ago
      redis.3.egiuiqpzrdbxks3wxgn8qib1g      redis:3.0.7  worker1    Running        Running 48 seconds
       \_ redis.3.ctzktfddb2tepkr45qcmqln04  redis:3.0.6  mmanager1  Shutdown       Shutdown 2 minutes ago
      ```

   .. code-block:: bash

      $ docker service ps redis

      NAME                                   IMAGE        NODE       DESIRED STATE  CURRENT STATE            ERROR
      redis.1.dos1zffgeofhagnve8w864fco      redis:3.0.7  worker1    Running        Running 37 seconds
       \_ redis.1.88rdo6pa52ki8oqx6dogf04fh  redis:3.0.6  worker2    Shutdown       Shutdown 56 seconds ago
      redis.2.9l3i4j85517skba5o7tn5m8g0      redis:3.0.7  worker2    Running        Running About a minute
       \_ redis.2.66k185wilg8ele7ntu8f6nj6i  redis:3.0.6  worker1    Shutdown       Shutdown 2 minutes ago
      redis.3.egiuiqpzrdbxks3wxgn8qib1g      redis:3.0.7  worker1    Running        Running 48 seconds
       \_ redis.3.ctzktfddb2tepkr45qcmqln04  redis:3.0.6  mmanager1  Shutdown       Shutdown 2 minutes ago

   .. Before Swarm updates all of the tasks, you can see that some are running
      `redis:3.0.6` while others are running `redis:3.0.7`. The output above shows
      the state once the rolling updates are done.

   Swarm が全てのタスクを更新するまで、 ``redis:3.0.6`` として実行中のイメージが ``redis:3.0.7`` に切り替わるのが見えるでしょう。
   先ほどの出力はローリング・アップデートが完了した状態です。

.. What's next?

次は何をしますか？
====================

.. Next, learn about how to [drain a node](drain-node.md) in the swarm.

次は swarm から :doc:`ノードを解放 <drain-node>` する方法を学びます。

.. seealso:: 

   Apply rolling updates to a service
      https://docs.docker.com/engine/swarm/swarm-tutorial/rolling-update/
