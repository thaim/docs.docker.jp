.. -*- coding: utf-8 -*-
.. URL: https://docs.docker.com/engine/swarm/swarm-tutorial/
.. SOURCE: https://github.com/docker/docker.github.io/blob/master/engine/swarm/swarm-tutorial/index.md
   doc version: 18.09
      https://github.com/docker/docker/commits/master/engine/swarm/swarm-tutorial/index.md
.. check date: 2018/11/14
.. Commits on Jun 26, 2018 a4f5e3024919b0bbfe294e0a4e65b7b6e09c487e
.. -----------------------------------------------------------------------------

.. Getting Started with swarm mode

.. _getting-started-with-swam-mode:

=======================================
swarm モード導入ガイド
=======================================

.. sidebar:: 目次

   .. contents::
       :depth: 3
       :local:

.. This tutorial introduces you to the features of Docker Engine Swarm mode. You
   may want to familiarize yourself with the [key concepts](../key-concepts.md)
   before you begin.

このチュートリアルは Docker Engine Swarm モードの機能を紹介します。始める前に、よろしければ :doc:`重要な概念 <../key-concepts>` に慣れておいてください。

.. The tutorial guides you through the following activities:

チュートリアルは以下の作業を紹介します。

.. * initializing a cluster of Docker Engines in swarm mode
   * adding nodes to the swarm
   * deploying application services to the swarm
   * managing the swarm once you have everything running

* Docker Engine の swarm モードでクラスタを初期化
* swarm にノードを追加
* アプリケーション・サービスを swarm にデプロイ
* swarm を使い始めた後の管理

.. This tutorial uses Docker Engine CLI commands entered on the command line of a
   terminal window.

このチュートリアルは、ターミナル・ウインドウのコマンドライン上で Docker Engine CLI コマンドを実行します。

.. If you are brand new to Docker, see [About Docker Engine](../../index.md).

Docker を初めて使う場合は、 :doc:`Docker Engine について </engine/index>` をご覧ください。

.. Set up

.. _swarm-tutorial-setup:

セットアップ
====================

.. To run this tutorial, you need the following:

チュートリアルを進めるためには、以下の条件が必要です：

.. * [three Linux hosts which can communicate over a network, with Docker installed](#three-networked-host-machines)
   * [Docker Engine 1.12 or later installed](#docker-engine-1-12-or-newer)
   * [the IP address of the manager machine](#the-ip-address-of-the-manager-machine)
   * [open ports between the hosts](#open-protocols-and-ports-between-the-hosts)

* :ref:`Docker がインストールされ，ネットワークで通信可能な３台の Linux マシン <three-networked-host-machine>`
* :ref:`Docker Engine 1.12 以上をインストール <docker-engine-112-or-later>`
* :ref:`マネージャ・マシンの IP アドレス <the-ip-address-of-the-manager-machine>`
* :ref:`ホスト間でポートを開く <open-ports-between-the-hosts>`

.. Three networked host machines

.. _three-networked-host-machine:

３台のネットワーク上のマシン
==============================

.. This tutorial requires three Linux hosts which have Docker installed and can
   communicate over a network. These can be physical machines, virtual machines,
   Amazon EC2 instances, or hosted in some other way. You can even use Docker Machine
   from a Linux, Mac, or Windows host. Check out
   [Getting started - Swarms](/get-started/part4.md#prerequisites)
   for one possible set-up for the hosts.

チュートリアルでは Docker がインストールされネットワークを介して通信可能な
3台の Linux マシンが必要です。マシンは物理マシン、仮想マシン、 Amazon EC2 インスタンス、
その他の方法でホストされたマシンのどれでも構いません。 Linux や Mac、 Windows ホストにおける
Docker Machine を利用することもできます。個々のセットアップ方法については
:ref:`Docker を始めましょう - Swrams <get-started-part4-swarms-prerequisites>` を参照ください。

.. One of these machines is a manager (called `manager1`) and two of them are
   workers (`worker1` and `worker2`).

チュートリアルで利用するマシンのうち1台はマネージャ(``manager1`` と呼ぶ)とし、
残りの2台はワーカ(``worker1`` と ``worker2`` と呼ぶ)とします。

.. >**Note**: You can follow many of the tutorial steps to test single-node swarm
   as well, in which case you need only one host. Multi-node commands do not
   work, but you can initialize a swarm, create services, and scale them.

.. note::
   いくつものチュートリアルが1台のホストしか利用しないシングルノード swarm で試すことができます。
   マルチノードの操作は動作しませんが、 swarm の初期化やサービスの作成およびスケールは行うことができます。

.. Docker Engine 1.12 or newer

.. _docker-engine-112-or-newer:

Docker Engine 1.12 以上
==============================

.. This tutorial requires Docker Engine 1.12 or newer on each of the host machines.
   Install Docker Engine and verify that the Docker Engine daemon is running on
   each of the machines. You can get the latest version of Docker Engine as
   follows:

このチュートリアルでは Docker Engine 1.12 またはより新しいバージョンが各ホストで必要です。
Docker Engine をインストールし、 Docker Engine デーモンが各マシンで動作していることを確認して下さい。
以下の方法で最新の Docker Engine をインストールすることができます：

.. * [install Docker Engine on Linux machines](#install-docker-engine-on-linux-machines)

   * [use Docker for Mac or Docker for Windows](#use-docker-for-mac-or-docker-for-windows)

* :ref:`Linux マシン上に Docker Engine をインストールする <install-docker-engine-on-linux-machines>`

* :ref:`Docker for Mac または Docker for Windows を利用する <use-docker-for-mac-or-docker-for-windows>`


.. Install Docker Engine on Linux machines

Linux マシンに Docker Engine をインストールする
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. If you are using Linux based physical computers or cloud-provided computers as
   hosts, simply follow the [Linux install
   instructions](../../installation/index.md) for your platform. Spin up the three
   machines, and you are ready. You can test both
   single-node and multi-node swarm scenarios on Linux machines.

もし Linux ベースの物理計算機またはクラウドプロバイダが提供する計算機をホストに利用しているのであれば
プラットフォームに応じた :doc:`Linux インストール手順 <../../installation/index.rst>` に従って下さい。
3つの計算機を登録することで準備が完了します。
Linux 計算機であれば swarm のシングルノードとマルチノードの両方を
試すことができます。

.. Use Docker for Mac or Docker for Windows

.. _use-docker-for-mac-or-docker-for-windows:

Docker for Mac や Docker for Windows を利用する
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. Alternatively, install the latest [Docker for Mac](/docker-for-mac/index.md) or
   [Docker for Windows](/docker-for-windows/index.md) application on one
   computer. You can test both single-node and multi-node swarm from this computer,
   but you need to use Docker Machine to test the multi-node scenarios.

これ以外の方法として、最新の :doc:`Docker for Mac </docker-for-mac/index.md>` や
:doc:`Docker for Windows </docker-for-windows/index.md>` アプリケーションを
1台の計算機にインストールしてください。
その計算機にてシングルノードとマルチノードの swarm を試すことができます。
ただしマルチノードシナリオを試すには Docker Machine を利用する必要があります。

.. * You can use Docker for Mac or Windows to test _single-node_ features of swarm
   mode, including initializing a swarm with a single node, creating services,
   and scaling services. Docker "Moby" on Hyperkit (Mac) or Hyper-V (Windows)
   serve as the single swarm node.

* Docker for Mac や Windows を *シングルノード* の swarm モード機能として
  シングルノード swarm の初期化、サービスの作成、サービスのスケールなどを
  試すことができます。 Hyperkit (Mac) や Hyper-V (Windows) における Docker "Moby"
  がシングルノード swawrm を提供します。

.. * Currently, you cannot use Docker for Mac or Docker for Windows alone to test a
   _multi-node_ swarm. However, you can use the included version of [Docker
   Machine](/machine/overview.md) to create the swarm nodes (see
   [Get started with Docker Machine and a local VM](/machine/get-started.md)), then
   follow the tutorial for all multi-node features. For this scenario, you run
   commands from a Docker for Mac or Docker for Windows host, but that Docker host itself is
   _not_ participating in the swarm. After you create the nodes, you can run all
   swarm commands as shown from the Mac terminal or Windows PowerShell with
   Docker for Mac or Docker for Windows running.

* 現在では、 Docker for Mac や Docker for Windows のみで *マルチノード* swarm を
  試すことはできません。しかし、同時にインストールされる :doc:`Docker Machine </machine/overview.rst>`
  を利用することで swarm ノード群(:doc:`Docker Machine をローカル VM で始めるには </machine/get-started.md>` を参照)を作成し、
  すべてのマルチノードに関する機能を試すチュートリアルをすすめることができます。
  このシナリオでは Docker for Mac や Docker for Windows からコマンドを実行しますが、
  その Docker ホスト自体は swarm に参加して *いません* 。ノード群を作成した後は、
  すべての swarm コマンドを Docker for Mac や Docker for WIndows が動作する
  Mac のターミナルや Windows の PowerShell を利用して実行することができます。

.. The IP address of the manager machine

.. _the-ip-address-of-the-manager-machine:

マネージャ・マシンの IP アドレス
========================================

.. The IP address must be assigned to a network interface available to the host
   operating system. All nodes in the swarm need to connect to the manager at
   the IP address.

ホスト・オペレーティングシステムで利用可能なネットワーク・インターフェースに対し、
IP アドレスが割り当てられている必要があります。
swarm 上の全てのノードは、この IP アドレスを使ってマネージャにアクセスできなければなりません。

.. Because other nodes contact the manager node on its IP address, you should use a
   fixed IP address.

マネージャ以外のノードはこの IP を利用してマネージャに接続するため、
固定 IP アドレスを利用しなければなりません。

.. You can run `ifconfig` on Linux or macOS to see a list of the
   available network interfaces.

``ipconfig`` コマンドを Linux や macOS で実行することで
利用可能なネットワーク・インタフェースの一覧を表示することができます。

.. If you are using Docker Machine, you can get the manager IP with either
   `docker-machine ls` or `docker-machine ip <MACHINE-NAME>` &#8212; for example,
   `docker-machine ip manager1`.

もし Docker Machine を利用しているのであれば、 ``docker-machine ls`` または
``docker-machine ip <MACHINE-NAME>`` コマンドを実行することでマネージャの IP
アドレスを取得できます — 例えば、 ``docker-machine ip manager1`` 。

.. The tutorial uses `manager1` : `192.168.99.100`.

このチュートリアルでは ``manager1``  を ``192.168.99.100`` とします。

.. Open protocols and ports between the hosts

.. _open-protocols-and-ports-between-the-hosts:

ホスト間のプロトコルとポートを開く
========================================

.. The following ports must be available. On some systems, these ports are open by default.

以下のポートが利用できなければなりません。いくつかのシステムでは
これらのポートはデフォルトで開いています。

.. * **TCP port 2377** for cluster management communications
   * **TCP** and **UDP port 7946** for communication among nodes
   * **UDP port 4789** for overlay network traffic

* **TCP ポート 2377** はクラスタ管理通信用
* **TCP・UDP ポート 7946** はノード間の通信
* **UDP ポート 4789** はオーバレイ・ネットワークの通信

.. If you plan on creating an overlay network with encryption (`--opt encrypted`),
   you also need to ensure **ip protocol 50** (**ESP**) traffic is allowed.

もしオーバレイ・ネットワークを暗号化オプション付き(``--opt encrypted``)で作成するのであれば、
**IP プロトコル50** (**ESP**)のトラフィックが許可されていることを確認して下さい。

.. What's next?

次は何をしますか？
====================

.. After you have set up your environment, you are ready to [create a swarm](create-swarm.md).

環境のセットアップを終えたら、 :doc:`swarm を作成 <create-swarm>` する準備が整いました。


.. seealso:: 

   Getting Started with swarm mode
      https://docs.docker.com/engine/swarm/swarm-tutorial/
