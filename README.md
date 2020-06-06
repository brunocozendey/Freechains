# Freechains: Peer-to-peer Content Dissemination

- Local-first publish-subscribe topic-based model
- Unstructured peer-to-peer gossip dissemination
- Happened-before best-effort partial order
- **Per-topic reputation system for healthiness**
- **Multiple flavors of public and private communication** (`1->N`, `1<-N`, `N<->N`, `1<-`)
- Free in all senses

*(In bold we highlight what we believe is particular to Freechains.)*

A user posts a message to a chain (a topic) and all other users subscribed to
the same chain eventually receive the message.
Users spend their reputation to post new messages and gain reputation from
consolidated posts.
Users can like and dislike messages from other users, which transfer reputation
between them.

<!---
Freechains is (intended to be) decentralized, fair, free (*as-in-speech*), free
(*as-in-beer*), privacy aware, secure, persistent, SPAM resistant, and
scalable.
-->

- Comparison with [other](docs/others.md) systems
- Concepts:
    - [Post / Message / Block](docs/blocks.md)
    - [Chain / Topic / Feed](docs/chains.md)
    - [Reputation System](docs/reps.md)
- List of all [commands](docs/cmds.md)
- Discussion [group](https://groups.google.com/forum/#!forum/freechains) about Freechains
- List of [publicly available resources](docs/join.md)
<!--
- Using an [e-mail client](https://github.com/Freechains/mail/) to interface with Freechains (very hacky)
-->
- Introductory videos:
    [1/3](https://www.youtube.com/watch?v=7_jM0lgWL2c) |
    [2/3](https://www.youtube.com/watch?v=bL0yyeVz_xk) |
    [3/3](https://www.youtube.com/watch?v=APlHK6YmmFw)

## Install

First, you need to install `java` and `libsodium`:

```
$ sudo apt install default-jre libsodium23
```

Then, you are ready to install `freechains`:

```
$ wget https://github.com/Freechains/README/releases/download/v0.6.2/install-v0.6.2.sh

# choose one:
$ sh install-v0.6.2.sh .                    # either unzip to current directory (must be in the PATH)
$ sudo sh install-v0.6.2.sh /usr/local/bin  # or     unzip to system  directory
```

## Basics

The basic API of Freechains is very straightforward:

- `host start`:      starts the local peer to serve requests (executed on every restart)
- `crypto create`:   creates an identity
- `chains join`:     joins a chain locally to post and read content
- `chain post`:      posts to a chain locally
- `chain get`:       reads a post locally
- `chain traverse`:  iterates over (discovers) local posts
- `peer send/recv`:  synchronizes a local chain with a remote peer

Follows a step-by-step execution:

- Start host:

```
$ freechains host start /tmp/myhost
```

- Switch to another terminal.

- Join the `#chat` chain:

```
$ freechains chains "#chat" join
```

- Create an identity:

```
$ freechains crypto create pubpvt "My very strong passphrase"
EB172ED6C782145B8D4FD043252206192C302E164C0BD16D49EB9D36D5188070 96700ACD1128035FFEF5DC264DF87D5FEE45FF15E2A880708AE40675C9AD039EEB172ED6C782145B8D4FD043252206192C302E164C0BD16D49EB9D36D5188070
$ PVT=96700ACD1128035FFEF5DC264DF87D5FEE45FF15E2A880708AE40675C9AD039EEB172ED6C782145B8D4FD043252206192C302E164C0BD16D49EB9D36D5188070
```

- Post some content:

```
$ freechains chain "#chat" post inline "Hello World!" --sign=$PVT
$ freechains chain "#chat" post inline "I am here!"   --sign=$PVT
```

- Communicate with other peers:
   - Start another `freechains` host.
   - Join the `"#chat"` chain.
   - Synchronize with the first host.

```
$ freechains host start /tmp/othost 8331
# switch to another terminal
$ freechains --host=localhost:8331 chains join "#chat"
$ freechains --host=localhost:8330 peer localhost:8331 send "#chat"
```

The last command sends all new posts from `8330` to `8331`, which can
then be traversed as follows:
    - Identify the predefined "genesis" post of `"#chat"`.
    - Acquire it to see what comes next.
    - Iterate over its `fronts` posts recursively.

```
$ freechains --host=localhost:8331 chain "#chat" genesis
0_A80B5390F7CF66A8781F42AEB68912F2745FC026A71885D7A3CB70AB81764FB2
$ freechains --host=localhost:8331 chain "#chat" get block 0_A80B5390F7CF66A8781F42AEB68912F2745FC026A71885D7A3CB70AB81764FB2
{
    ...
    "fronts": [
        "1_1D5D2B146B49AF22F7E738778F08E678D48C6DAAF84AF4128A17D058B6F0D852"
    ],
    ...
}
$ freechains --host=localhost:8331 chain "#chat" get block 1_1D5D2B146B49AF22F7E738778F08E678D48C6DAAF84AF4128A17D058B6F0D852
{
    "immut": {
        ...
        "backs": [
            "0_A80B5390F7CF66A8781F42AEB68912F2745FC026A71885D7A3CB70AB81764FB2"
        ]
    },
    "fronts": [
        "2_DFDC784B4609F16F4487163CAC531A9FE6A0C588DA39D597769DA279AB53C862"
    ],
    ...
}
$ freechains --host=localhost:8331 chain "#chat" get payload 1_1D5D2B146B49AF22F7E738778F08E678D48C6DAAF84AF4128A17D058B6F0D852
Hello World!
```

<!--
- Visualize the chain:

```
$ freechains-dot /tmp/othost/chains/chat/ | dot -Tpng -o /tmp/chat.png
$ eog /tmp/chat.png
```
-->
