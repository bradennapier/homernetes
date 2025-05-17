# Initial Stack Discovery Chat with OpenAI o3 Deep Research

<USER>
So I am building out the general concept for what i hope will become a commercial project at some point.  For now i plan for it to be my slow incremental build where i will move from home assistant into my own platform (soe home assistant should be included in the setup at this time)

- I am not suck on any specific kubernetes distro completely up to what you think would be best for us... but i have been a fan of [https://docs.k0sproject.io/stable/](https://docs.k0sproject.io/stable/) quite a bit and it seems like it would be good for our starting with 1controller/1node on 1 device to allowing it to move to a distributed as it grows?

  - Keep in mind we will need to suppport Matter / Thread so proper network setup is critical for discovery
  - I do not think isolation between pods is a HUGE deal - but gvisor or firecracker (whatever you think is best) might be good idea anyway?
  - Setup / config should be 100% immutable which is why i think nixos good idea - although the code editing / hot reload for web app is dynamic ([https://docs.k0sproject.io/v1.32.4+k0s.0/configuration/#using-a-configuration-file](https://docs.k0sproject.io/v1.32.4+k0s.0/configuration/#using-a-configuration-file))

- I am totally open to running this on its own distro specialized for kubernetes ([https://www.siderolabs.com/platform/talos-os-for-kubernetes/](https://www.siderolabs.com/platform/talos-os-for-kubernetes/)) if that maeks the most sense and will be best when it becomes commercial project / expandable / etc -- bare metal is good

  - nixos might be a great choice though?

    - feels like a nixos path is potentially the one that gives us most freedom to adapt / cahnge?

  - i have zero experience with either
  - importantly we likely will want to support installing the system as a app on Mac for example or similar at somep oint for easy install and not needing a whole server

- This will include a nextjs 15 app we need to easily be able to deploy and even run with hot reload during dev when running in the kubernetes

- In the notes I have listed a bnuch of raw random items just to get them down -- i need you to do consider everything i have mentioned so far and do a deep dive on best practices, latest versions, what will work best / what i am missing to make this all work right , what i should probably do differently / perhaps not have on the kube

We will be selling server components which self provision themsleves and have a custom ui , ai capabilities, and can be expanded with new apps which run as servers accessible from the web via cloudflare tunnels , etc.

Here is the raw random notes ive gone through so far just thinking randomly - you will need to do a deep dive and come up with a strategy for the best POC -- a lot of these "extras" are not needed at first - main purpose for the initial implementation is to have a good setup for the nextjs app ( lorely which you should know about ) , another nextjs app which will be the admin config we provide users, home assistant importantly with addon support which i know requires some special handling, and critical infrastructurre

# Random Notes:

```
1. # importantly while we are usign kube and lots of tools - this will be a product we will be selling
   # as our own home automation platform -- for the most part they will only interact with our
   # white labeled interfaces / apps

2. # I do not like docker as a client or container runtime we should absolutely use something better

# cloudflared (tunnel)
 - maybe instead of zerotier we can just have it all use cloudflared / cloudflare one?
# git
# ssh
# ffmpg
# renovate for dependencies?
# supabase - should this be in kube at all?
 - we prob want timescale db for time based?
 - we can also replicate db to something like promethereus etc
# do we need etcd?
# minio or rook/ceph / longhorn for data / openebs ?
  - improtantly data is dynamic we will allow them to add new ssd any time
  - thi sis also how hosts works - it starts as 1 control/node but if you plug in a second device it will switch up to a distributed system
# redis (do we need operator: https://artifacthub.io/packages/olm/community-operators/redis-operator)
 - at my new job we are using NATS - should we replace redis with that?  what do we lose?

# metallb https://metallb.io/concepts/ for load balancing ?
  - zerotier make this obsolete?
  - cilium or something better?
  - kong?
  - calico ?

# We will need to host our main next.js app and tunnel
# we will need a administrator interface as well to control settings and config

# consider the idea of using coder / code-server for a hosted vscode instance to update things



# 1password helm chart for our secret management

- considering NATS since my job uses it and i should know how it works



# notes
benotes: https://github.com/fr0tt/benotes
# snioe-it
https://artifacthub.io/packages/helm/t3n/snipeit
  - unifi-2-snipeit
  -

### ONnly ig er fony hsbr home asssistant
# zigbee2mqtt ?
https://artifacthub.io/packages/helm/andrenarchy/zigbee2mqtt
# esphome
# music assistant (prob not)
https://www.music-assistant.io/
# frigate -- maybe?
https://github.com/blakeblackshear/frigate
# matter server ?
https://github.com/home-assistant/addons/tree/master/matter_server
# matter client
https://github.com/home-assistant/core/tree/dev/homeassistant/components/matter
# piper? (TTS)
https://github.com/rhasspy/piper/
```

Please come up with a plan that we can implement tomorrow on my machine which is currently running Manjaro Linux latest version and has nothing on it but we can do whatever with it! It has 32 gb ram and plenty of storage plus have a USB-C 256gb ssd we can add to the kube!

</USER>

---

Thanks for the detailed info—this is a very exciting and ambitious project. To give you the most actionable and well-grounded plan for tomorrow's POC setup, could you please clarify a few final points:

1. **Platform Scope Tomorrow**

   - Is the POC intended to run only on your **single Manjaro machine**?
   - Should it be a **clean install** (wipe and install Talos/NixOS), or do you want to use Manjaro as the host OS for now?

2. **Initial Component Prioritization**

   - Which components must be working **tomorrow**?

     - Next.js app (Lorely)?
     - Admin panel?
     - Home Assistant (with addon support)?
     - Kubernetes (with preferred distro like k0s or Talos)?
     - Cloudflare Tunnel?

3. **Preferred Dev Style**

   - Do you want to **develop inside Kube** (e.g. hot-reloading Next.js in pods) or **develop locally and deploy to Kube** for production parity?

4. **Future Proofing vs Simplicity**

   - Are you okay starting with a leaner base (e.g. no storage orchestration or observability stack) if it gets you a clean working dev system faster?

Once I have that, I’ll construct a full-stack POC deployment plan for you to execute tomorrow including all required tools, exact steps, and Kube manifests or Helm charts if applicable.

---

<USER>
1. You will have to research and come up with your thoughts on best plan - i go over in the message about nixos or talos but open to anything !  We just need to make sure we have a good plan moving forward as we build the product!

2. Clean install is fine

3. Initially we just should get the core mechanics, network, filesetup, cloudflare tunneling / dns delivery (we will tunnel to the domain i have "mi.house" so app will be available via like "admin.mi.house" using ZeroTrust by Cloudflare and SSO -- lets focus on the best plan for all the core kube stuff and setup a demo web app for the admin config it can just be blank really?

- also look at all the raw notes to see what else we may want to include

3. FluxOps i think its called via Git delivery? I think that sounds like the best choice for a nixos / immutatble setup?

- Would be nice if we could also run the kubernetes locally for development in a less immutable fashion but that isnt critical now

4. We should have a good core that can be expanded on but we need all the crucial components in place -- netowkring, load balancing, orchestration, storage

Remember for now we are just going to research all the mentioned items - find any new products that may be better choices with newest version of kubeneteres for example... and come up with a gameplay for the initial POC before we go through the steps on gettin git working!
</USER>

---

Great. I’ll put together a full architectural and implementation plan for your initial POC of a commercial-ready home automation Kubernetes platform. This will include analysis and selection of:

- The optimal immutable OS and Kubernetes distro (e.g. NixOS vs Talos vs k0s)
- Best tools for GitOps delivery (like FluxCD or alternatives)
- Networking, tunneling (Cloudflare Tunnel / ZeroTrust), service discovery (Matter/Thread support), and load balancing
- Appropriate runtime (e.g. containerd + Firecracker/gVisor if needed)
- Storage options (Rook/Ceph, OpenEBS, etc.) that support dynamic SSD expansion
- Helm charts and operators for Home Assistant with addons, admin UI (Next.js), and observability components
- Optional support for developer hot reload workflows within Kubernetes

I will also review and prioritize items from your raw notes, check the latest stable versions, recommend new/better alternatives where they exist, and ensure the foundation allows seamless transition to multi-node, commercial-ready distribution.

I’ll get back to you with the full plan shortly.

# Home Automation Platform on Kubernetes: Architecture and POC Plan

## Overview and Objectives

**Goal:** Build a **commercial-grade home automation platform** on Kubernetes, starting as a single-node deployment but easily scaling to multiple nodes. The design prioritizes **immutable infrastructure** and **GitOps** practices for reliability and repeatability. All core services for smart home operation – Home Assistant (with Zigbee, Matter, etc.), networking, ingress, storage, secrets, and observability – will run as Kubernetes workloads. We aim for a fully declarative, secure, and scalable setup that can grow from a home lab POC to a production-grade platform.

&#x20;_Example of a home automation network architecture using Kubernetes for IoT devices and services. In this example, Raspberry Pi nodes run Kubernetes; Home Assistant, Node-RED, Grafana, and device hubs (Zigbee/BLE) are deployed as containers. A similar architecture will be implemented, but on a single x86 node with future expansion._

Key design decisions include: an immutable OS (e.g. **Talos or NixOS**) for the Kubernetes node, a lightweight **Kubernetes distribution** (such as k0s or k3s) that can seamlessly scale out, a GitOps-based continuous delivery (with **FluxCD**) including external secrets management, and integration of networking components (CNI, Service Discovery, Ingress via **Cloudflare Tunnel**, internal **MetalLB** load balancer, DNS). Application layers will include a Next.js 15 admin UI, **Home Assistant** with its add-ons (Zigbee2MQTT, ESPHome, Matter), and optional services like **NATS** (for messaging) and **Supabase** (for data/auth). We will also choose a secure container runtime (using containerd, avoiding Docker) with the option of sandboxes (gVisor/Firecracker) for isolation, and set up a dynamic storage stack (possibly **Rook/Ceph** or **OpenEBS**, plus **MinIO** for object storage). Below is a structured plan with each layer of the stack, including rationale and best practices as of May 2025.

## Immutable OS for Kubernetes Nodes

To ensure an **immutable, reproducible environment**, a purpose-built OS is recommended over a generic Linux distro. Two leading options are **Talos Linux** and **NixOS**, with a third option being a minimal immutable container OS like **Flatcar Container Linux**:

- **Talos Linux:** An operating system _designed for Kubernetes_ – minimal, hardened, and managed entirely via declarative config. Talos provides an _immutable OS image_ with no package manager or SSH access (administration is done through an API). This greatly reduces attack surface and eliminates configuration drift. Updates are atomic and automatic, and Talos essentially “packages” Kubernetes as a part of the OS. It is considered one of the most secure, immutable Kubernetes distros. Talos is a strong fit for this project because it simplifies Kubernetes setup (the OS comes with Kubernetes built-in) and ensures all nodes run identically. _Trade-off:_ Talos has a learning curve (no shell, new tooling) and it’s Kubernetes-focused (one cannot easily run non-containerized apps on the host). However, these restrictions are by design for security and consistency.

- **NixOS:** A declarative Linux distribution where the entire system (from OS packages to application services) is built from a single configuration. NixOS offers _reproducibility_ — given the same config, you get the same system every time. This means you can manage the node’s software (including Kubernetes or k3s installation, kernel modules for IoT devices, etc.) as code. NixOS can achieve similar immutability (rollbacks, etc.) and prevents configuration drift. It’s extremely flexible (you could install custom services alongside Kubernetes if needed) but requires familiarity with the Nix language and ecosystem. For this project, NixOS would allow tailoring the system for Home Assistant’s needs (e.g. specific kernel patches for Thread/Matter if required) in a declarative way. _Trade-off:_ Higher complexity in initial setup and fewer out-of-the-box Kubernetes conveniences compared to Talos.

- **Flatcar Container Linux (or Fedora CoreOS):** These are minimal, read-only filesystems with automatic updates, intended to host containers. Flatcar (successor to CoreOS) is also an immutable infrastructure approach: all nodes boot the same image, which avoids drift. Flatcar does not include Kubernetes by default, but you can layer a Kubernetes distribution on top (e.g. using kubeadm, k0s, or RKE2). The advantage is a proven auto-updating base OS with minimal maintenance. The drawback is that you (or an automation tool) must install/manage Kubernetes on it separately, and you don’t get the one-stop declarative management that Talos or NixOS provide.

**Recommended Choice – Talos Linux:** For a **single-node to multi-node Kubernetes** scenario with GitOps, Talos is an excellent fit. It combines the OS and Kubernetes into one coherent, declarative system designed for secure production clusters. By using Talos, we ensure an immutable, uniform setup: no manual tinkering on the node – everything is configured via Talos manifests and Kubernetes manifests. Talos’s security features (no SSH, minimal attack surface) align well with a “commercial-grade” mindset. It also supports easy scaling: adding a node means booting Talos on a new machine with the cluster token, and it auto-joins; no manual OS config or kubeadm steps each time. Talos will run a standard upstream Kubernetes version under the hood (with etcd for control plane). The **trade-off** of a slightly steeper learning curve is acceptable given the benefits in maintainability and security.

_Rationale:_ Talos’s declarative machine configuration can be kept in version control (aligning with GitOps). Updates to the OS or Kubernetes version can be orchestrated via Talos’s controller or Sidero’s Omni if needed (Omni is a new hyperconverged management platform for Talos, which can automate multi-node ops). By choosing Talos, we avoid snowflake server setups – every re-deploy starts from the same state, ensuring reliability.

_Alternative:_ If not using Talos, the next best approach is **NixOS + k3s (or k0s)**. NixOS would give us an immutable server config, and we could install a lightweight Kubernetes like k3s on it. **k3s** is a popular minimal K8s by Rancher, well-suited for home labs (single binary <100MB, low resource use) and even used in production. **k0s** is another lightweight distro (also a single binary, can run as non-root). Both k3s and k0s are fully CNCF-conformant and can scale to multi-node. If Talos was not chosen, we’d likely go with NixOS + k3s: NixOS ensures the host config (Docker/CRI, etc.) is consistent, and k3s provides an easy Kubernetes with minimal overhead. This combo still requires more manual integration than Talos (e.g. using NixOps or Ansible to deploy k3s, and handling upgrades), but would be workable. _Flatcar + k0s_ would be another variant – Flatcar for immutable OS and k0s for K8s – but this is somewhat less GitOps-friendly (Flatcar config is less granular than Nix). In summary, Talos is our top choice for an **immutable Kubernetes OS**, with NixOS+k3s as a close alternative if more flexibility is needed.

## Kubernetes Distribution and Cluster Bootstrap

We need a Kubernetes distribution that is **lightweight, production-ready, and easy to bootstrap on one node**, but can grow to multiple nodes. The choice of base OS influences this (Talos already includes its Kubernetes distribution). Key considerations are the control plane footprint, upgrade process, and multi-node join process:

- **Talos Kubernetes:** Using Talos means Kubernetes is embedded. Talos clusters are essentially stock upstream Kubernetes, but the Talos control plane manages the lifecycle. If we use Talos, we’ll let it handle cluster creation – the process is to supply a cluster config (YAML) that defines the control plane node (our single machine) and any initial settings. Talos will initialize the control plane (etcd, apiserver, controller manager, scheduler) and kubelet with containerd on the node. For multi-node, we’d generate a join token and boot additional Talos nodes with that token; Talos auto-installs the correct Kubernetes version and joins them. This path is streamlined: no manual kubeadm, etc. Talos frequently tracks new K8s versions, and upgrades are applied by updating the Talos machine config (which can be done via GitOps as well).

- **k3s (Lightweight Kubernetes):** If not on Talos, k3s is a strong candidate for ease of use. It’s specifically built for edge/home scenarios – a single binary with built-in etcd (in recent versions) or SQLite for single-node, and it omits cloud-specific controllers to stay lean. k3s can run on a variety of OS (Linux distros, including NixOS or Flatcar). For multi-node, k3s supports joining agents to a server using a token. Rancher’s k3s has a huge community and is well-tested for scenarios like this. It also bundles a simple servicelb (based on Klipper) and a default ingress (Traefik) which can be disabled if we have our own choices. In our case, we might disable the built-in ingress/load-balancer because we have specific components (Cloudflare tunnel, MetalLB, etc.). Upgrades of k3s are easy (just replace the binary and restart, or use Rancher’s system-upgrade controller). If we choose NixOS, we could even pin the k3s version in the Nix config for reproducibility.

- **k0s:** An emerging lightweight distro from Mirantis, k0s is similar in spirit to k3s (single binary, no OS dependencies, can run as non-root). It’s Kubernetes-conformant and uses etcd internally for multi-node. The user has indicated _k0s is a current favorite_, so it’s worth noting that k0s would also meet our needs. It’s known for a simple setup (“zero friction” installation). We could install k0s as a system service on an immutable OS. The difference vs k3s is not huge; k3s has been around longer and has more community adoption, whereas k0s touts a very modular architecture (it even can run worker nodes without root). Either would work; k0s might have slightly less community support than k3s at this point, but it is a solid option.

**Recommended Choice – Use Talos’s integrated Kubernetes (upstream)**: Since we chose Talos OS, we will utilize the Kubernetes that Talos provisions. This is essentially a standard distribution (Talos can bootstrap Kubernetes v1.28+ in 2025, for example) with all control plane components. It is _production-grade_, as Talos is used in enterprise and has baked-in best practices (etcd is configured for you, TLS everywhere, etc.). Scaling to multi-node is trivial: boot another machine with Talos config and have it join; Talos takes care of certificates and etcd membership. We get the benefits of a full Kubernetes (nothing stripped out, unlike k3s which removes some alpha features). The cluster can thus support any CNCF add-ons we need (CSI drivers, operators, etc.) without compatibility concerns.

With Talos, cluster **bootstrapping** can be managed via a GitOps approach as well: e.g., using Sidero or an infrastructure-as-code tool to push the Talos config. However, for an initial POC, we might manually bring up the first node and then install FluxCD to manage further apps (see GitOps section). Notably, Talos also supports **Cluster API** integration if needed in the future (to manage cluster upgrades declaratively).

If we were not using Talos, the recommendation would be **k3s** on an immutable host. k3s has proven reliability and is indeed one of the most popular home lab K8s choices. Many homelab users report success using k3s for Home Assistant and other services. The differences between k3s and Talos’s Kubernetes (upstream) are minor in functionality – both will run our workloads fine. So the decision was more about OS and operations: Talos gives a tighter immutability guarantee. In either case, our cluster will be single-node initially (all control-plane and worker on one machine). When scaling out, we’ll ensure to configure the distribution for high availability (e.g., if k3s, we’d use the embedded etcd HA mode or an external etcd for multi-master; for Talos, just add control plane nodes as it manages an etcd cluster automatically).

**Container Runtime:** We will use **containerd** as the container runtime, avoiding Docker Engine. Modern Kubernetes has removed Dockershim – containerd is now the standard CRI runtime for Kubernetes and comes built-in with both Talos and k3s. This eliminates the need to run the Docker daemon, which reduces overhead and potential security issues (no exposed Docker socket). Containerd will manage pulling images and running containers via the Kubernetes CRI interface. It’s maintained by the CNCF and is considered production-ready (in fact, it’s used under the hood by Docker itself, so it’s very stable).

We’ll also consider container runtime **security enhancements**: gVisor or Firecracker. By default, Kubernetes (containerd + runc) runs containers with namespacing but shares the host kernel. To harden this, we can configure a sandboxed runtime class:

- **gVisor:** gVisor is a user-space kernel that intercepts syscalls, adding an extra isolation layer between containers and the host kernel. We can set up gVisor with containerd and define a `RuntimeClass` in Kubernetes for it. Then, for any particularly untrusted workload, we can schedule it to run with gVisor (which will use the `runsc` runtime instead of runc). This gives stronger security at some performance cost. The nice thing is this can be selective (not all pods, just ones we label). Many guides and blogs describe how to do this by installing gVisor on each node and creating a RuntimeClass. We will implement this so that, for example, if we run any third-party service (say a community add-on or a less-trusted component), we can opt-in to gVisor sandboxing for that pod.

- **Firecracker (via Kata Containers):** Firecracker is an AWS-developed micro-VM hypervisor that can run lightweight VMs almost as fast as containers. Through Kata Containers, Kubernetes pods can be launched inside Firecracker microVMs, giving VM-level isolation with minimal overhead. This essentially means each pod would have its own tiny kernel and VM boundary. Kata + Firecracker is a more complex setup than gVisor (requires installing Kata runtime and configuring it on nodes), and it may be overkill for a home cluster unless we plan to run untrusted third-party code regularly. However, it’s worth noting as a future option: _“By plugging Firecracker into Kubernetes via Kata, teams can enforce VM-grade isolation in container environments”_. For a POC, we likely won’t enable Kata by default (to keep things simple), but the design will leave room for it. If this platform were to be offered to external users or run multi-tenant cloud services, Kata/Firecracker could be introduced to run those workloads securely in microVM sandboxes.

In summary, **containerd+runc** will be the default runtime, with support for a **gVisor RuntimeClass** for sandboxing. We will not use Docker (the Docker CLI can still be used for local development if needed, but it won’t be in the production stack). This aligns with Kubernetes best practices post-2021, where Dockershim deprecation pushed everyone to CRI-compatible runtimes. Both Talos and k3s use containerd internally, so this choice is naturally satisfied. Security-wise, this setup is state-of-the-art: containerd is minimal and stable, and gVisor/Firecracker provide defense in depth if needed.

## GitOps Deployment and Configuration Management

We will implement a **GitOps workflow** to manage both the infrastructure and the applications on the cluster. GitOps means all our cluster configuration (Kubernetes manifests, Helm charts, etc.) lives in Git repositories, and an operator in the cluster continuously applies the desired state from Git. This provides reproducibility and version history for every change (critical for an immutable approach).

**FluxCD (preferred) vs Argo CD:** The two leading GitOps tools are Flux and Argo. We will use **FluxCD** – a CNCF incubating project – because it’s lightweight, Kubernetes-native, and integrates well with our stack. FluxCD will run inside the cluster (as a set of controllers) and sync manifests from a Git repo (for example, a repo containing all our K8s YAML or Helm releases). The user specifically mentioned Flux, and it aligns well with modern GitOps practices (declarative, pull-based deployments). FluxCD has components for managing kustomize overlays, Helm releases, and even syncing from other sources (Helm repos, S3, etc.), which gives us flexibility in how we define our desired state.

- **Repository Structure:** We will create a Git repository (e.g., `mi-house-cluster-config`) that contains all the desired Kubernetes objects and configuration for the platform. This will likely be organized by applications (Home Assistant, NATS, etc.) and infrastructure (ingress, CNI, etc.). We can use **Kustomize** to manage overlays (for example, different settings if we move from dev to prod) or Helm charts for complex apps. Flux will be bootstrapped to this repo – meaning we’ll install Flux on the cluster with a deploy key to the repo, so it has read (or read/write if needed for image updates) access. Thereafter, Flux will reconcile the cluster with any changes pushed to Git.

- **Infrastructure as Code:** Even the base cluster components (CNI, MetalLB, etc.) can be installed via Flux by applying their manifests from Git. Some of these foundational pieces (like installing Flux itself, or on a fresh cluster installing CRDs needed by Flux) might be a chicken-and-egg problem. Typically, one bootstraps Flux by running a CLI command (`flux bootstrap`) that sets up Flux and points it at the repo. After that, everything else is hands-off. In our case, since we have an immutable OS, ideally the only manual step after OS install is to apply Flux. We could automate that too via a Talos machine config (Talos can take an overlay that installs manifests on startup), but doing it manually once is fine for POC.

- **Secrets Management:** Storing secrets (API keys, passwords, certificates) in Git is a challenge. We want a **declarative but secure** way to manage secrets. The user’s notes suggest using the **1Password Helm chart** for secrets, which refers to the _1Password Kubernetes Operator_. We will adopt **1Password Secrets Manager integration**: this means all sensitive secrets (e.g., database passwords, Home Assistant secrets, API tokens for Cloudflare, etc.) will be stored in 1Password vaults, and synced into Kubernetes Secrets as needed. The 1Password Connect Operator watches for custom resources that reference a vault item and creates the corresponding K8s Secret object. This gives us a GitOps-friendly secret management: we can put a reference (non-secret) in Git, and the actual values are fetched from 1Password at runtime.

  _For example_, we might have a `ExternalSecret` or `OnePasswordItem` YAML that says “create a secret for Postgres password from vault item XYZ”. Flux will apply that, and the 1Password operator will fill in the Secret. This avoids ever committing the secret itself to Git. It also centralizes secret management in 1Password, which is great if the team already uses it. We’ll deploy the 1Password Connect service (which requires an API token from 1Password) and the operator in the cluster. According to 1Password’s docs, once configured, it _“provides a seamless connection between your 1Password vaults and your Kubernetes cluster”_, automatically syncing items into K8s secrets. If we prefer, we could also use the generic **External Secrets Operator** (a community tool that supports multiple backends including 1Password via a plugin) – but given 1Password’s official support and our use of it, the official operator is a good choice.

- **Flux Kustomize and Helm Releases:** In Git, we’ll likely use a combination of plain manifests and Helm charts. For instance, community applications (like the NATS operator or Supabase helm chart) can be pulled in via Flux’s HelmRelease resources. Flux’s Helm Controller will ensure those charts are installed/updated. For simpler deployments (like maybe a custom Deployment for our Next.js app), we can keep them as YAML and use Kustomize for environment-specific tweaks (like enabling hot-reload in dev vs not in prod). Flux will handle ordering and dependencies – e.g., we ensure the CNI is installed before deploying other pods, etc., by structuring the Kustomizations with depends-on or just by natural ordering.

- **Policy and Drift Detection:** With GitOps, any drift from the repo can be detected and reverted. For example, if someone kubectl-ed an ad-hoc change on the cluster, Flux would eventually revert it to match Git (or at least flag it). This fits well with our immutable philosophy: treat the Git repo as the single source of truth for cluster state.

In addition to FluxCD, it’s worth noting **Argo CD** as an alternative. Argo CD offers a nice web UI and is also very popular. If a UI dashboard for GitOps is desired (perhaps for a team to manually sync or track apps), Argo could be considered. However, since we are building our own admin UI and prefer CLI/Git workflows, FluxCD is sufficient and has a smaller footprint. Flux is also now inside the CNCF (Argo is as well, but either is fine in terms of maturity). Both support automated sync and health checks. We lean Flux because it integrates nicely with other components like image automation (Flux can monitor container registries for new image tags and update manifests automatically, which could be useful for keeping Home Assistant up to date, for example).

**Bootstrap Process:** After installing the OS and Kubernetes, the sequence will be: install FluxCD (via its install script or manifest) and point it to the config repo. Then Flux takes over. In that repo, we will have definitions for: CNI (probably Cilium manifest or Helm chart), MetalLB, cloudflared tunnel Deployment, Home Assistant, etc. Flux will apply all of those. We will have to provide Flux with access to any private container registries if needed (e.g., 1Password’s operator image or perhaps 1Password requires a Docker image – but it’s likely public). Also, since we use 1Password for secrets, we’ll manually provide the initial 1Password token secret to the cluster (that secret lets the operator connect to the vault). That token could be set as a Talos secret or loaded manually, then thereafter, 1Password operator can pull everything else.

In summary, **FluxCD with 1Password Operator** will yield a fully declarative system: version-controlled manifests define what apps and config should exist, and a secure external store holds secret values. This not only makes our POC easier to reset or reproduce, but also sets the stage for a production pipeline (changes via PRs, code review, and Git history for auditing).

## Networking and Service Discovery

Networking in this platform spans several concerns: cluster networking (pod-to-pod and pod-to-internet), service discovery both within the cluster and on the local LAN (especially important for IoT protocols like mDNS used by Matter), ingress from the internet (via Cloudflare), internal load balancing, and DNS management. We will address each:

### Cluster Networking (CNI)

We will install **Cilium** as the CNI for Kubernetes. Cilium is an advanced eBPF-based networking layer that by 2025 has become a de facto choice for many Kubernetes clusters. It leverages the Linux kernel’s eBPF technology for high-performance packet processing, network policy enforcement, and even layer 7 filtering. Compared to simpler CNIs (flannel or Calico), Cilium offers better scalability and features relevant to our needs (like potential BGP integration for announcing service IPs, and built-in support for multicast/broadcast which can help with service discovery protocols). Importantly, _“Cilium \[is] an open-source project that provides a platform for deploying eBPF for networking, security, and observability”_ and is **the most popular eBPF-based CNI** today. Many managed K8s (like Azure AKS) have adopted Cilium for its enhanced networking and security capabilities.

**Why Cilium:**

- _Performance:_ Using eBPF, Cilium can bypass iptables for service routing and network policy, which improves throughput and lowers latency. This is beneficial if our home automation platform streams data (camera feeds, etc.) or just to ensure snappy response as it scales.
- _Network Policy:_ We might not need strict network segmentation internally now, but as a commercial platform, having fine-grained network policies to isolate services or tenants is a plus. Cilium excels at network policy and even supports DNS-based policies.
- _Load Balancing:_ Cilium can act as a service load balancer by leveraging BGP or direct routing. In fact, Cilium is capable of replacing something like MetalLB by announcing service IPs via BGP to the router (if one has that setup). We might still use MetalLB for simplicity, but it’s good to know Cilium has this capability.
- _Multicast/MDNS:_ IoT protocols like mDNS (for Matter/Thread discovery) use multicast. Some older CNIs don’t handle multicast well (flannel, for instance, might not propagate multicast across nodes). Cilium has support for cluster-wide multicast (it can allow it, and there’s been work on a **beta** multicast feature in Cilium). In a single-node scenario this isn’t an issue, but once multi-node, if we had say Home Assistant on one node and a Thread border router on another, multicast traffic (ff02:: for mDNS queries, etc.) might need to flow. Cilium’s modern approach is more likely to support that or can be configured to let pods join the LAN multicast if needed.

_Alternatives:_ **Calico** is another solid CNI (very widely used, with or without eBPF mode). Calico is known for its simplicity and robust network policy, but out of the box, it uses iptables for service routing (unless using Calico BGP mode with a router). For a home cluster, Calico in default mode would work, but it wouldn’t provide load balancer IPs or some of the extras. **Flannel** is extremely simple (overlay network with vxlan), but lacks network policy and any advanced features; it’s more suited for basic deployments and has fallen out of favor for anything beyond basic networking. Since our aim is “commercial-grade” and forward-looking, we choose Cilium to build on cutting-edge tech. As one source notes, Cilium has been seeing growing interest and is _“designed to address the evolving needs of cloud-native networking”_ with eBPF. This will keep our platform modern and flexible.

We will deploy Cilium via its Helm chart or manifest (likely through Flux). We’ll configure it in **direct routing (layer 3)** mode if possible (so pods can communicate without overlay if on the same subnet; since it’s a single node initially, it’s trivial). When adding nodes, if the network allows, we can enable BGP peering with our router or use encapsulation if not. Cilium also comes with Hubble, an observability layer; we might enable that to get visibility into network flows (useful for debugging IoT device traffic).

### Service Discovery (mDNS, Matter, Thread)

**Local Service Discovery:** Many home automation devices rely on local discovery protocols like mDNS/Bonjour, SSDP/UPnP, or Bluetooth. For example, Home Assistant will use mDNS to find devices like smart TVs, or SSDP to find Philips Hue hubs, etc. When running Home Assistant in a container, special care is needed to ensure it can see multicast broadcasts from the LAN. The simplest approach is to run Home Assistant’s pod in **host network mode** – meaning it shares the host’s network namespace, so it can directly send and receive on the LAN as if it were the host. In Kubernetes, this is done with `hostNetwork: true` on the HA Deployment. By doing so, Home Assistant will be on the LAN (e.g., able to see `224.0.0.0/24` mDNS broadcasts and respond). The downside is that that pod bypasses CNI, but that’s acceptable for a special case like Home Assistant where connectivity is more important than network isolation. We will likely enable hostNetwork for HA specifically to ensure maximum compatibility with device discovery. (This is a known practice – many people run Home Assistant Container with `--net=host` for this reason).

If for some reason we don’t use host networking for HA, an alternative is to use a **multicast relay**: for instance, running Avahi in reflector mode on the host or a small DaemonSet that bridges mDNS between cluster network and LAN. However, that introduces complexity. Given we control the host, hostNetwork is fine for HA and maybe for any add-ons like ESPHome that might also do discovery.

**Matter and Thread:** Matter is the new smart home standard that works over IP (Wi-Fi or Thread) and uses a combination of mDNS (DNS-SD) and a **Matter Controller** to discover and commission devices. Thread is a mesh network protocol (802.15.4 radio) that carries IPv6 packets (via 6LoWPAN) and requires a **Thread Border Router** to connect the Thread network to the IP network (Wi-Fi/Ethernet). Supporting Matter/Thread in Kubernetes is cutting-edge, but here’s our approach:

- We will need a Thread radio. Typically, this is a USB dongle like the **Silicon Labs “SkyConnect”** (which does Zigbee + Thread) or a Nordic nRF stick. This will be attached to our main node via USB. We plan to run an **OpenThread Border Router (OTBR)** container that interfaces with this radio. OTBR (by Google’s OpenThread project) is an open-source border router software that can run on a Linux device with a supported radio (usually via SPI or USB CDC). We can deploy OTBR as a container (there are Docker images available for OTBR). This container will also likely need to run with privileges (to access network and USB). OTBR will create a Thread network and advertise itself on the LAN via mDNS as a Thread Border Router for Matter to use.

- The **Matter Controller/Server:** Home Assistant has a Matter add-on (the “Matter Server”) which basically runs a controller that Home Assistant’s UI can use to commission Matter devices. In 2023, the HA team noted that running this outside of HAOS is not trivial due to kernel requirements. Matter over Thread needed certain kernel modules (for Bluetooth proxies, or certain multicast forwarding for Thread, etc.) that were built into Home Assistant OS. As of 2025, we expect progress: indeed, developers mentioned they would provide a Docker image and instructions for Matter Server outside of HAOS. So one option is to deploy that official Matter Server container in our cluster. We must ensure the host has any needed kernel support (Talos uses a modern kernel; if something like “packet tunnel driver” or “IPv6 network namespace for Thread” is needed, we might have to enable it). If it turns out too problematic to run Matter Server directly, an interim fallback is to use an external Matter controller (like a HomePod or Google Nest Hub) – but since we want it integrated, we’ll strive to run it.

In summary, **Home Assistant (with Matter integration)** will coordinate with a **Thread Border Router** (OTBR container) to handle Thread-based Matter devices. IP-based Matter devices (Wi-Fi) connect over TCP/UDP and are discovered via mDNS – which Home Assistant can handle on host network. For Thread devices, the Matter Server will communicate with OTBR. The OTBR container will likely expose a D-Bus or use UDP to integrate; we might need to configure routing for the Thread mesh prefix into the container network (OTBR usually runs a WPAN interface and an IPv6 prefix for Thread).

We should be prepared that **special network config** may be required. The HA team’s note from 2023 is clear: _“Matter (especially with Thread) relies on kernel patches, specific network config, etc., and simply running a container won’t work out-of-the-box… HAOS includes those patches”_. Since Talos doesn’t easily allow custom kernel modules by an end-user, we rely on what’s upstream. By 2025, many of these patches might be in mainline Linux (e.g., Linux has added support for Thread interface drivers and such). If not, another approach: we could run a **micro-VM** that runs Home Assistant OS inside our cluster (using KubeVirt, as some have attempted). However, this adds complexity and redundancy (HAOS would run its own container engine inside). We prefer the containerized route, acknowledging it might need some trial and error.

We will document clearly in the implementation which kernel features are needed (for instance, multicast routing between Thread interface and LAN interface). If Talos cannot accommodate a needed sysctl or module, using NixOS could be a fallback since NixOS could let us compile a custom kernel. But this is a contingency – likely not needed if things like `CONFIG_IP6_NF_NETWORK` or other Thread-related options are on.

**Zigbee and Bluetooth LE:** These are not IP-based but are critical for Home Assistant. We plan separate service pods for these:

- A **Zigbee2MQTT** container will manage Zigbee devices via a USB dongle (maybe the same dongle as Thread if it’s multi-protocol, or a separate one). Zigbee2MQTT connects to the serial port (like `/dev/ttyUSB0`). We will use Kubernetes device support by mounting the `/dev/ttyUSB0` (or `/dev/ttyACM0`) into the Zigbee2MQTT pod. The pod will run privileged or with specific device access. We’ll ensure the Zigbee2MQTT pod is **scheduled to the node with the USB device** (in a single-node cluster it’s trivial; in multi-node, we’d label that node and use a nodeSelector or NodeAffinity). Zigbee2MQTT will also require an MQTT broker (discussed later in Messaging section). Home Assistant will interact with Zigbee devices via Zigbee2MQTT (which publishes sensor data to MQTT and Home Assistant’s MQTT integration consumes it). This gives full add-on compatibility for Zigbee devices – equivalent to HA’s Zigbee Home Automation (ZHA) or the Zigbee2MQTT add-on, just managed externally.

- A **Bluetooth Low Energy (BLE) daemon** (like `bluetoothd`/BlueZ or something like Home Assistant’s BLE MQTT) might be needed if we have BLE sensors. In the community example we found, they ran a BlueZ service pod to handle BLE sensors and feed data to Home Assistant. BLE in containers is tricky because it requires access to the host’s Bluetooth adapter (could be USB or built-in). We have a few options: if the server has Bluetooth, we could run a container with `--net=host` and `--privileged` to use BlueZ on the host’s DBus. Or use something like Room Assistant or ESPHome bluetooth proxy on separate hardware. Since not explicitly asked, we’ll note it as an option. For completeness, assume we might run a BLE gateway container to handle things like presence detection beacons or plant sensors, similar to what was done on that Jetson cluster (they had a pod capturing BLE data and sending it to Home Assistant).

**Internal Service Discovery (within cluster):** Kubernetes itself has Service Discovery via **CoreDNS** for services. This covers how our microservices find each other _within_ the cluster (e.g., if Home Assistant container needs to reach the MQTT service, it can use the Kubernetes service DNS name). We’ll rely on CoreDNS (the default DNS server in K8s) to provide name resolution for `*.svc.cluster.local` names. For instance, `mqtt.default.svc.cluster.local` might point to our broker. We will configure any applications that need to talk to each other using those DNS names or environment variables set via Kubernetes.

**External & LAN DNS:** We have a domain `mi.house` (as per the ingress spec, subdomains under mi.house to be accessed via Cloudflare Tunnel). We need to manage DNS records in Cloudflare for these services. The plan is to use Cloudflare’s Tunnel with named ingress routes (see below), which actually can create CNAMEs in DNS pointing to Cloudflare’s tunnel endpoint. We can either manually set those up or use an **External DNS** controller to automate it. There is a Kubernetes ExternalDNS integration for Cloudflare that can create DNS records for services or ingresses. However, in our case, Cloudflare Tunnel might register the DNS itself. For example, you can configure a Cloudflare Tunnel to route `home.mi.house` to a local service – when you do that, Cloudflare will automatically create a DNS CNAME like `home.mi.house` -> `<tunnel-hash>.cfargotunnel.com`. We might not need external-dns if we handle DNS via Cloudflare’s tunnel config or API.

For local network access (in case the internet is down or simply to avoid hairpin through Cloudflare when at home), we should consider a local DNS override. Perhaps the simplest: use the home’s router or a Pi-hole (if we deploy one) to resolve `*.mi.house` to the local IP of the cluster. For example, if Home Assistant Service gets an IP 192.168.1.100 via MetalLB, we could have `home.mi.house` resolve to 192.168.1.100 on the LAN. Then phones or laptops on the LAN will go directly. Meanwhile, the public DNS would point to Cloudflare. This split-horizon DNS can be achieved by running an internal DNS server (we could even configure CoreDNS to answer for `mi.house` domain with specific records pointing to service IPs). CoreDNS has an _external DNS_ plugin, but perhaps easier: leverage the existing Pi-hole or router’s DNS. Since the user’s domain is custom, probably using Pi-hole or Dnsmasq to create custom entries is doable. We will include a **Pi-hole (or AdGuardHome)** deployment as an optional service, which can serve DNS to the LAN and we can populate it with our internal records. (The example diagram had Pi-hole on the master node as well.)

### Ingress and Zero-Trust Remote Access

For secure external access, we will use **Cloudflare Tunnel** (previously Argo Tunnel) along with Cloudflare Zero Trust policies. The idea is to avoid exposing _any_ direct open ports on our home network; instead, a lightweight `cloudflared` agent inside the cluster will create an outbound connection to Cloudflare, which in turn will route incoming HTTPS requests on our custom domain to services in the cluster. This gives us Cloudflare’s security, authentication, and edge network benefits without needing a traditional ingress open to the internet.

**Cloudflare Tunnel Setup:** We will create a Cloudflare Tunnel (name it e.g. `mi-house-tunnel`). Cloudflare will generate credentials (a cert for the tunnel) which we will store as a Kubernetes secret (likely pulled from 1Password). We then run the `cloudflared` daemon as either a Deployment or even a DaemonSet on our node. This tunnel can route multiple subdomains to different services internally. Cloudflare supports an **ingress rules config** for cloudflared – we can mount a config file that says, for example:

- `home.mi.house` -> route to `http://home-assistant.default.svc.cluster.local:8123`
- `ui.mi.house` -> route to `http://admin-ui.default.svc.cluster.local:3000` (if our Next.js dev server runs on 3000)
- `grafana.mi.house` -> route to `http://grafana.monitoring.svc.cluster.local:3000` (if we install Grafana)

and so on. The cloudflared process will listen on the cluster for those requests and forward appropriately. Cloudflare’s network will terminate TLS at their edge and the tunnel traffic to our `cloudflared` is encrypted. This means we might not need to run an Nginx/Traefik ingress at all. **Cloudflare Tunnel essentially replaces ingress-nginx** in this architecture (and indeed some users have “ditched ingress-nginx for Cloudflare Tunnels” entirely). One benefit is we don’t have to manage certificates – Cloudflare provides the SSL certs on the public side (and we can even use Cloudflare Access policies for Zero Trust, requiring login to view certain subdomains).

Using Cloudflare Tunnel with K8s is documented by Cloudflare: _“Cloudflare Tunnel can be used to expose services running inside the Kubernetes cluster to the public.”_. We will follow their guide to create the tunnel and a corresponding DNS CNAME. Essentially, once the tunnel is up, `home.mi.house` will be a CNAME to a Cloudflare domain, and Cloudflare knows to send that hostname’s traffic into our tunnel. We will label each service/ingress with the proper host so cloudflared’s config can differentiate.

**Authentication/Zero Trust:** Cloudflare Zero Trust (Access) can be configured so that certain subdomains require login (Google OAuth, etc.) before allowing traffic through. For example, we may want `home.mi.house` (Home Assistant) to be accessible only after login, or we might keep HA open and just rely on HA’s auth. But an admin interface or Grafana might be locked down with Access policies. This is all done on Cloudflare’s side – we just define the policies in Cloudflare’s dashboard. The tunnel covers transport encryption and connectivity; Zero Trust Access adds SSO/ACL on top. This means our cluster can remain completely closed from a network perspective (no ports open, no need for our own OAuth proxy ingress, etc.), greatly simplifying security.

**Ingress Controller:** Because we use cloudflared as a tunnel ingress, we actually might not need a traditional ingress controller like nginx or Traefik. Cloudflared will directly proxy to cluster services. The community setup we referenced did exactly this: they ran a cloudflare tunnel Deployment to connect the cluster out, making Home Assistant reachable from outside. We can still use Kubernetes Ingress objects if we want, by using one of the Cloudflare Tunnel ingress controllers (there are open-source controllers that let you define a Kubernetes Ingress that the controller then programs Cloudflare Tunnel accordingly). However, it might be simpler to manage one config file for cloudflared.

Our plan: run cloudflared as a Deployment (maybe 2 replicas for resiliency, though single is fine if the one node is up). Mount the tunnel credential as a secret. Mount an `ingress.yaml` config to define routing. For example:

```yaml
tunnel: mi-house-tunnel
ingress:
  - hostname: home.mi.house
    service: http://home-assistant.default.svc.cluster.local:8123
  - hostname: ui.mi.house
    service: http://admin-ui.default.svc.cluster.local:80
  - hostname: grafana.mi.house
    service: http://grafana.monitoring.svc.cluster.local:3000
  - service: http_status:404
```

This means any request for those hostnames gets routed to the respective service. The last rule is a catch-all 404. Cloudflare’s docs and community have examples of this kind of config.

Once cloudflared connects, Cloudflare will create the DNS entries (or we create them manually pointing to the tunnel ID). We will then manage access through Cloudflare’s dashboard as needed.

This approach is **secure and low-maintenance**: updates to cloudflared are automatic (we could run the latest image), and Cloudflare’s network handles DDoS protection, TLS certs, etc. We don’t expose our home IP at all. It’s effectively a **Zero Trust ingress**. (In case Cloudflare is down or we need local access, we still have the option of connecting via VPN or using the local IP as mentioned, but Cloudflare has high availability.)

For completeness: If we _did_ want an internal ingress for some reason (say local HTTPS termination), we could deploy ingress-nginx or Traefik as well. But in this design it’s not necessary – we prefer to avoid the extra hop. Cloudflare Tunnel will talk HTTP directly to the services. We can keep those services as HTTP internally (or use Cloudflare Origin CA certs if we want end-to-end TLS). Given it’s all inside a trusted LAN, and Cloudflare tunnel is encrypted, plain HTTP to services is fine.

**MetalLB (Bare-metal Load Balancer):** Even though Cloudflare covers external ingress, we will deploy **MetalLB** in Layer2 mode to handle LoadBalancer services on our LAN. This allows services to get a stable IP address on the home network. For example, we might want Home Assistant to be available at a certain IP (so we can map `home.mi.house` internally to it, or just use the IP). MetalLB will be configured with a pool of IPs from our LAN (e.g., if our DHCP is .1 to .100, we can take .200-.250 for MetalLB). When a Kubernetes Service is of type LoadBalancer, MetalLB will assign one of those IPs and announce it via ARP on the network (since single node, it will use ARP; if multi-node, it could use ARP or BGP). In the community example, they configured MetalLB with a pool `192.168.2.128/25` to serve service IPs. We will do similarly, perhaps `192.168.1.240-192.168.1.250` as a pool.

Why do this if we have Cloudflare? Mainly for **local access and service-to-service integration**. For instance, if an IoT device or mobile app on the LAN wants to talk to Home Assistant using the local network (some integrations auto-discover HA via UPnP and connect to its local IP), having a stable IP for HA is useful. Also, if any service in our cluster needs to be accessed by another device on LAN (say an RTSP camera stream or something from a camera that streams to a service), an IP simplifies firewall rules. It’s also convenient for debugging (you can hit the IP directly without going through Cloudflare).

MetalLB is a simple, proven solution for bare-metal clusters to get LoadBalancer IPs. We’ll deploy MetalLB via its manifest. We’ll generate a secret for MetalLB’s memberlist protocol (for potential multi-node sync). In single node, it’s not strictly needed, but we’ll include it to be ready for multi-node. It’s worth noting: if we were using Cilium in BGP mode and had a router that speaks BGP, we could skip MetalLB and let Cilium announce service IPs. But most home routers do not support BGP advertisements, and setting up FRRouting in the cluster is extra work. So **MetalLB in layer2 mode** is the simplest path. The overhead is minimal, and it only acts when services request an IP.

For example, we will expose the MQTT broker to the LAN (maybe not needed, but if we have some device publishing to MQTT directly, a known IP helps). We might expose Home Assistant as well. Each will get an IP from MetalLB. We then can create DNS entries internally for those (as discussed).

**CoreDNS Customization:** CoreDNS (inside cluster) can be configured to stub-domain for our home LAN’s domain if needed. Unlikely needed, but if we want pods to resolve something like `printer.local` which is mDNS normally, we could add mdns plugins. Probably not required – most IoT discovery will be handled by HA or add-ons rather than raw DNS queries from pods.

### Internal DNS and External DNS

We touched on this above, but to summarize and clarify the DNS strategy:

- **Cluster-internal DNS:** CoreDNS will serve the `cluster.local` domain for service discovery among pods. No change needed here.

- **External DNS (Cloudflare):** We have Cloudflare managing `mi.house`. We will create subdomains in Cloudflare for each service we want to expose (Home Assistant, etc.), either manually or using the Tunnel integration. When using Cloudflare Tunnel, the recommended method is to run `cloudflared tunnel route dns <tunnel> <hostname>` for each hostname, which registers it. We will automate this either via `cloudflared` CLI or possibly via ExternalDNS. There is an ExternalDNS provider for Cloudflare – we could configure it to create a CNAME for each ingress. But since Cloudflare Tunnel might need a specific CNAME, we might manage this outside Kubernetes (like as part of Terraform or manual one-time setup). In any case, we ensure that e.g. `home.mi.house` is a DNS name that points to our tunnel. Cloudflare’s documentation confirms this approach.

- **Local DNS for split-horizon:** We want `home.mi.house` to resolve to the MetalLB IP when inside the LAN. Solutions include:

  - Running a DNS server (like Pi-hole) on the cluster that serves `.mi.house` zone with the internal IPs, and pointing our DHCP/DNS to that for local name resolution.
  - Or if the home router supports it, create static DNS entries on the router for those names to the MetalLB IPs.

Given we may already deploy Pi-hole for ad-blocking (commonly done in home setups), we can leverage it. Pi-hole can be deployed via Helm or a Kustomize which creates a Deployment plus Service (type: LoadBalancer so it gets an IP, or we can run it as hostNetwork on port 53). We’ll have Pi-hole forward unknown queries to the normal DNS (1.1.1.1 or whatever). In Pi-hole’s config, we create local DNS entries for `*.mi.house`. Alternatively, we could configure Pi-hole as the secondary DNS and the primary as something else, but keeping it primary is fine if stable. This part is optional and can be done later – the crucial remote access piece (Cloudflare) does not depend on this.

### Summary of Networking Decisions

- **CNI:** **Cilium** for in-cluster networking (fast, secure, eBPF-based).
- **Pod Access to LAN:** Use hostNetwork for HA (and possibly OTBR) to allow multicast discovery; otherwise rely on Cilium for general connectivity.
- **Service Discovery (IoT):** Ensure mDNS and other broadcasts reach HA (via host network). Provide Thread support with an OTBR container, and plan to run Matter Controller container when available (noting HAOS-specific patches might be needed).
- **Ingress:** **Cloudflare Tunnel** as the primary ingress, replacing the need for a traditional ingress controller. Cloudflare provides secure remote access via tunnel and Zero Trust policies. We run the `cloudflared` agent in-cluster to proxy requests.
- **Load Balancing:** **MetalLB** in layer2 mode to allocate stable LAN IPs for services (especially HA). This complements Cloudflare tunnel by enabling direct LAN access and allowing standard Kubernetes LoadBalancer semantics internally.
- **DNS:** Rely on Cloudflare DNS for public records (with tunnel), and use internal DNS (Pi-hole or router entries) for local name resolution to MetalLB IPs. CoreDNS serves internal service names. Possibly deploy ExternalDNS if we want dynamic DNS record management (not strictly needed for tunnel since hostnames are fixed).

These choices yield a network that is secure from outside (no open ports, Cloudflare protected) yet accessible and efficient internally. Even as we add nodes, MetalLB and Cloudflare Tunnel will handle distribution (Cloudflare Tunnel can run multiple instances for HA, and MetalLB will fail over IPs if a node goes down in BGP mode or using arp-aging in L2 mode).

## Platform Services and Applications

### Home Assistant Deployment (with Add-ons)

**Home Assistant** is the core of the home automation platform. We want it with “full add-on compatibility,” which typically means the Home Assistant **Supervisor** managing add-ons. Running the official Home Assistant OS (HAOS) or Supervisor in Kubernetes is not supported directly, so our approach is to run **Home Assistant Container (Core)** and deploy equivalent services for each needed add-on. This gives the same functionality, with a bit of manual coordination. Many in the community use Home Assistant Container + Docker Compose to run add-ons like MQTT, Zigbee2MQTT, etc.; we will do the same with Kubernetes.

- **Home Assistant Container:** We will use the official `homeassistant/home-assistant:stable` Docker image. This will be deployed as a single-instance Deployment (or StatefulSet) in Kubernetes. We’ll give it a persistent volume for configuration data (so your `config/` directory with `configuration.yaml` and others is stored on disk). We may use a PVC backed by our storage class (see storage section) so that it survives restarts and upgrades. We will run this container with `hostNetwork: true` (for reasons discussed: to allow mDNS, UPnP, etc. device discovery on the LAN). We also likely need to run it with `privileged: true` or at least certain capabilities if we want Home Assistant to access hardware like USB directly; however, we plan to externalize hardware access to other containers (Zigbee2MQTT, etc.), so HA container can probably run unprivileged. One exception: if we want Home Assistant to speak Bluetooth directly, we might consider giving it DBus access or using an external BLE agent.

By using Home Assistant Container, we lose the Supervisor’s GUI for add-on installation, but we can manage those add-ons via Kubernetes/Flux instead – which fits our GitOps model better (no clicking in the HA UI to install an add-on; instead we add a Helm release or manifest to our repo). Home Assistant itself will behave like normal, except a few add-on-specific features (e.g., Ingress feature for add-ons in HA UI might not automatically work, but we can expose those add-on UIs ourselves).

- **MQTT Broker:** Home Assistant commonly uses MQTT for integrations (Zigbee2MQTT, some DIY sensors, etc.). In the official add-ons, typically the Mosquitto MQTT broker is provided as an add-on. We will deploy an MQTT broker as a standard service. The popular choice is **Eclipse Mosquitto** – lightweight and sufficient. Alternatively, since the user is interested in NATS, we could use NATS as the MQTT broker (NATS can accept MQTT connections and translate to NATS subjects). The NATS server v2.2+ has built-in MQTT bridging, allowing IoT devices to connect with MQTT protocol while internally using NATS messaging. This is intriguing because it could unify our messaging layer (NATS could serve both as our internal event bus and as an MQTT broker). There’s an official guide on replacing a standard MQTT broker with NATS, indicating that NATS can support most MQTT 3.1.1 features. For simplicity and familiarity, one might start with Mosquitto. But a modern approach would be to deploy **NATS JetStream with MQTT enabled**, removing the need for two separate brokers.

  We will consider the trade-offs: Mosquitto is very small and focused (easy to run, config via ConfigMap, well-tested with Zigbee2MQTT). NATS is heavier in that it does more (it would bring in JetStream persistence, etc.), but it gives us a unified pub/sub system beyond just MQTT (our own microservices could use NATS for communication). The user specifically noted “NATS vs Redis” – implying a preference for a modern event system. Using NATS here could hit two birds with one stone: it could handle the messaging that might otherwise use Redis or MQTT.

  **Decision:** We’ll deploy **NATS** and enable its MQTT adapter. This way, Zigbee2MQTT can connect using MQTT protocol to NATS (which listens on port 1883), and simultaneously, other services can use NATS clients or key-value stores. NATS is known for high performance and lightweight pub/sub, focusing on simplicity and low latency. In fact, NATS is a great fit for IoT and microservices (it’s used in projects like some smart home platforms and by companies for event streaming). As one source compares: _“Unlike Redis, which is primarily an in-memory datastore, NATS focuses on fast, simple messaging with minimal configuration”_. This aligns with our needs – we want a robust message bus for events (NATS) rather than using Redis pub/sub. We likely don’t need Redis at all, since any caching or ephemeral state can either live in NATS JetStream or be handled in a database. So **we will not deploy Redis**; NATS will fulfill the internal messaging role, and also function as the MQTT broker for IoT devices.

  Technical setup: Deploy `nats-server` (maybe via the official NATS Helm chart for JetStream enabled). Configure it with `mqtt:` enabled on port 1883 and with user credentials. Zigbee2MQTT and any other MQTT clients (ESPHome, etc.) will use those creds to connect. NATS will then translate MQTT topics to NATS subjects (likely under `$MQTT.*`). Home Assistant’s MQTT integration will connect as a normal MQTT client too (pointing to NATS’s MQTT endpoint). This gives HA all the MQTT data as usual. Meanwhile, if we write any custom services that produce or consume events, they can use NATS directly (or even via MQTT if easier). We should ensure persistence: e.g., Zigbee2MQTT can mark messages as retained (for last known sensor state) – NATS JetStream can be configured to store messages, but we might need to tweak the bridging. Possibly simpler: allow retained messages by enabling JetStream KV store or some bridging option. We’ll verify that NATS’s MQTT support covers retained messages (the docs suggest it does with JetStream).

- **Zigbee2MQTT:** Deploy as a Deployment (or StatefulSet if it needs stable host). We’ll mount the USB device into it. Its config (YAML) will be provided via ConfigMap/Secret, including the MQTT broker address (which will be the NATS service). We’ll place Zigbee2MQTT in the same namespace as HA for convenience and allow it to start after NATS (we might add an init check or rely on NATS being up, which is fine if in same cluster – we can set pod ordering with dependencies or just let it retry until broker up). Zigbee2MQTT will handle pairing with Zigbee devices. Home Assistant, via its MQTT integration, will auto-discover devices from Zigbee2MQTT (Z2M supports Home Assistant auto-discovery by publishing to a specific topic that HA listens to). This should work identically to the add-on scenario. **Hardware:** We need a Zigbee coordinator USB (like a TI CC2652 or ConBee). That device must be accessible – on Talos, we have to ensure the Talos config doesn’t prevent USB device access. Talos is minimal but it does allow mounting devices into pods via Kubernetes normally. We might need to run a privileged pod for Zigbee2MQTT to have hardware access (or use the `devicePlugins` feature in K8s – but likely overkill, just use privileged with device mount path). We will attach the device (e.g., `/dev/ttyACM0`) through a hostPath into the container.

- **ESPHome:** ESPHome is usually run to compile IoT firmware for microcontrollers and optionally act as an uploader over network. The ESPHome add-on provides a web UI to create and manage ESP32/ESP8266 nodes. We can deploy the official `esphome` Docker image in Kubernetes. It’s a web service on some port (maybe 8080). We will expose it via Cloudflare as well (e.g., `esphome.mi.house`). For it to work fully, we might consider hostNetwork as well, because ESPHome can discover ESP devices via mDNS and also facilitate OTA updates by acting as a temporary web server that the device connects to. However, OTA and discovery from ESPHome might work without host network since it can connect directly to known IPs. We can try without hostNetwork and add if needed. ESPHome benefits from being on the same subnet as devices when doing initial pairing (they broadcast as `esp-xxxx.local`). We could rely on Home Assistant to handle OTA updates (Home Assistant can integrate with ESPHome API), but having the separate ESPHome dashboard is nice for development. We’ll include it and connect it to HA via the ESPHome integration (which connects to ESPHome’s API on the container).

- **Matter Server:** As discussed, we anticipate deploying the Home Assistant Matter Server as a container when available. If it’s not yet stable, one approach is to run it on the host or a VM. But assuming by mid-2025 they have a container: we will deploy it with similar privileges to access Thread interface. The Matter Server will connect to Home Assistant via the integration (Home Assistant will see it via WebSocket perhaps). Actually, HA Matter integration communicates with the add-on via WebSockets (the add-on runs a websocket server). We would configure HA to use the external Matter server’s address. This might involve setting an environment variable or config in HA to point it to the Matter server container URL (since normally Supervisor handles that). We might need to do some manual config here.

  The Matter container will need access to the Thread network. If we run OTBR separately, the Matter container might connect to OTBR via border router IP (like how HA OS does: via mDNS it finds a border router or via some API). Alternatively, the Matter Server might itself incorporate a Thread stack if given the USB device. However, it’s more likely we keep OTBR as the border router and Matter Server just uses the Thread network through standard IP routes. We’ll ensure the Thread network prefix is routed on the host (OTBR usually sets up a `wpan0` and does prefix advertisement on LAN via mDNS). If hostNetwork is on for OTBR and HA, they can probably talk easily. If needed, we could combine OTBR and Matter server in one container (Home Assistant addon may have done something akin to that). But separating concerns is cleaner.

**Integrating with Home Assistant:** Home Assistant’s config will need to be set to know about these external services:

- We’ll enable the MQTT integration (in configuration.yaml or via UI) and point it to the NATS/MQTT broker service (`nats.default.svc.cluster.local:1883`). Credentials for MQTT will be stored in 1Password and synced to HA as a secret or set via HA env variables.
- ESPHome integration: we’ll configure it with the address of the ESPHome container (or it might auto-discover via mDNS if on host network).
- Matter: we’ll configure the Matter integration to use the Matter Server. Possibly this is automatic if the add-on advertises itself; if not, we may need to manually add the Matter integration and provide IP.
- Zigbee2MQTT doesn’t directly integrate with Home Assistant except through MQTT, so nothing extra needed in HA beyond MQTT.
- Other add-ons we might use: e.g., **Node-RED** is a common addon. It wasn’t in the original list, but it was in the example architecture. If desired, we could deploy Node-RED as well (as a container) and use it for advanced automations. Node-RED connects to Home Assistant via websockets (Home Assistant Companion API). We can add it as an optional component and expose via ingress (Cloudflare).
- **Vault/1Password**: not an HA addon, but secrets are handled by our K8s integration with 1Password – HA might need the 1Password Connect server’s certificate if it calls out, but probably HA doesn’t directly use 1Password; it’s all on Kubernetes side.

**High Availability considerations:** Currently, this is all on one node. If we later add a second node, we have to ensure that stateful components run on only one node or in a highly available way:

- Home Assistant itself cannot be replicated (it’s a single-instance app). In multi-node cluster, we’d use an anti-affinity to avoid accidentally scheduling multiple HA pods. We might set it as a Singleton with a `ReplicaCount=1` Deployment.
- If that node fails, HA fails over only by rescheduling to another node (which is possible if using a PVC backed by distributed storage – see storage section – so the data can appear on another node).
- MQTT Broker (NATS) – NATS can run in clustered mode with multiple servers, but for simplicity we might run it as a single instance (JetStream can have clustering too). In a multi-node scenario, we could scale NATS to 3 pods (with JetStream clustering) for HA. That’s something to consider if reliability is paramount. For POC, one instance is fine.
- Zigbee2MQTT – must run where the USB is. So if multi-node, we’ll “pin” it to the specific node with the hardware (via nodeSelector). That’s fine; if that node goes down, Zigbee network is down until it comes back (unless we moved the dongle).
- Similarly, OTBR – pinned to the dongle node.
- These hardware-tied workloads create a bit of a single-point-of-failure on that node by necessity (unless we had redundant radios on multiple nodes and some failover logic, which is complex and not standard). For a professional product, one might eventually use ethernet-based hubs (like Silabs PoE multiprotocol gateway, etc.) that aren’t tied to the main server. But within our scope, we assume one main server with USB devices.

**Backup strategy:** We will ensure Home Assistant config gets backed up (could schedule HA’s built-in backups to go to cloud or a PVC). Also, because we use GitOps, most of the infrastructure config is in Git already. We might include a Velero or restic backup for volumes, but that might be optional at POC stage.

Notably, one _advantage_ of our approach is we’re effectively recreating Home Assistant “Supervised” environment in Kubernetes. Some in the HA community have done similar. The example with k3s on Jetson Nano proved that _“Home Assistant (official container) plus separate pods for BLE and Zigbee can work and are supported (HA recognized those via integrations)”_. They even used Cloudflare Tunnel in that setup. This validates our approach with a real-world case.

To highlight: the example stated _“Homeassistant (container) using built-in add-ons that are both available and supported… Cloudflare tunnel service is running inside the cluster… making it reachable from outside”_. This shows that even without Supervisor, the functionality is there – “built-in add-ons” likely refers to things like the MQTT integration or ZHA integration; in our case we use external services but the end result in HA is the same user experience.

### Next.js Admin Web UI Deployment (with Hot Reload for Dev)

We have a custom **admin web application** (Next.js 15) that we want to deploy on the cluster. This UI might serve as a control panel or configuration interface for the home automation platform (possibly supplementing or hiding the Home Assistant UI for end users). The requirements include the ability to do rapid development (hot-reload) and also host it in production mode.

**Deployment in Production:** For production, we can build the Next.js app (perhaps using the new `output: standalone` to get a Node.js server bundle or exporting a static app if it’s purely client-side). If it’s a full application (maybe with an API routes, etc.), we’ll run it as a Node.js server. We’ll containerize the Next app with a Dockerfile (install deps, `next build && next start`). We then deploy that container as a Deployment in Kubernetes (replica 1 or more). We expose it via a Service (ClusterIP) and Cloudflare Tunnel (`ui.mi.house`). We might allocate 2 replicas for HA if it’s stateless (Next can be stateless if not using in-memory session, etc.).

We’ll attach this Deployment to our GitOps, possibly building the image via CI (perhaps using GitHub Actions to build and push to a registry on commits). Alternatively, we use a tool like **Flux Image Automation** to automatically update the image tag if we push `:latest`. There are multiple workflows – to keep focus, we’ll assume we manually handle build/push when needed (or use a simple CI pipeline outside of K8s).

**Development Workflow (Hot Reload):** We want to be able to iterate on the Next.js app with hot module replacement (HMR) as if we were running `next dev` locally. There are a couple of strategies to develop against a Kubernetes cluster:

- **Local Development connecting to Cluster:** Run `npm run dev` on a developer machine, and have it talk to the cluster’s services via network. For example, if the Next app calls Home Assistant’s API or NATS, the dev machine could port-forward or connect over the LAN. This is the simplest approach: the cluster stays as is, and you just run the dev server outside. However, if the developer is remote or you want to simulate everything in-cluster, you might want the dev server in the cluster.

- **In-Cluster Dev Pod with Sync:** We can deploy the Next.js app in dev mode inside the cluster, and sync code changes to it. Tools like **Skaffold** or **Tilt** can help here by automating the code sync and rebuild loop. For example, with Skaffold, you can configure file sync so that when you edit a file locally, it is sent into the running container, triggering Next’s HMR. Skaffold can also port-forward the dev server port to your local machine. Essentially, you’d still code on your machine (with your IDE), but Skaffold ensures the cluster is running the latest changes in near-real-time. This gives a “hot reload” experience while the app is actually running in the K8s environment (which is useful if the app needs to interact with cluster-only services or uses internal DNS, etc.). According to an example, Skaffold can _“give you a ‘hot reload’ style workflow where changes saved in your IDE automatically trigger a redeploy, or even sync directly into a running container, sparing a full rebuild”_. This is ideal for something like Next.js where doing a full image build on every save would be too slow – instead, we run `next dev` in the pod and just sync the source files on change, letting Next’s HMR take over.

- **DevPod with Remote IDE:** Alternatively, one could run an editor like VS Code in the cluster (using code-server) and edit in-browser, but that’s probably unnecessary here.

Given the user’s request for hot-reload, we’ll incorporate a solution such as **Skaffold** for the Next.js app. The process would be: Developer runs `skaffold dev` with the config for the Next app. Skaffold builds the initial image or uses a pre-built dev image, deploys it to the cluster (maybe as a separate Deployment or by swapping the existing one to dev mode), then starts syncing changes. The Next.js dev server inside sees changes and HMRs the browser. This way, the cluster-based environment (including any internal APIs, or environment variables from K8s secrets) is used during development, reducing the “worked locally, broke in cluster” issues. Also, you avoid manually rebuilding container each time – Skaffold automates it and even avoids rebuild when possible by file syncing.

We will set up the Next.js Deployment such that it can be switched between “dev mode” and “prod mode” easily. Possibly we maintain two separate Deployments in Git (one for dev, one for prod) or we modify it via a flag. For example, we might have a separate Kustomize overlay for “development” namespace where the Next pod runs `npm run dev` and mounts a volume (NFS or hostPath) with the source code. If the dev environment is on the same machine as cluster (the developer might actually code on the machine itself since it’s a home setup), one could even mount the local filesystem into the container. But assuming the developer might be remote, we stick to Skaffold.

For demonstration, we can mention that with Skaffold, you run one command and _“get a real Kubernetes development loop with one command: `skaffold dev`”_ which sets up automatic redeploy or sync on changes. This provides near-instant reflection of code changes in the cluster environment, achieving the desired hot-reload experience.

We will expose the Next.js dev server as needed. If developing locally, the dev will typically be accessible at localhost:3000 with HMR. If it’s running in cluster, we can either port-forward to the dev’s machine, or even expose it via Cloudflare on a subdomain (maybe a protected dev subdomain). The simplest is port-forward or using something like telepresence if needed to directly connect. But we can also allocate, say, `dev-ui.mi.house` that points to port 3000 of the dev deployment. If we go that route, we should protect it behind Cloudflare Access since dev server might not require auth. For now, perhaps we skip exposing dev server externally and let the developer port-forward when needed (since they presumably have kubectl access).

**Production build pipeline:** We might use GitOps for deployment, but building the Next.js app is another step. We could incorporate this into our CI: e.g., when pushing to main, build the Next app into a container and push to registry, then update a Flux `ImagePolicy` to deploy the new version. That can all be automated. Flux has components for that (image reflector and image automation). For brevity, it’s enough to note we will automate Next.js image builds and let Flux deploy new versions, ensuring the UI is always up to date after tests pass.

### Optional Backend Services (Supabase, NATS, etc.)

Aside from Home Assistant, we have optional services mentioned: **Supabase, NATS vs Redis, database, etc.** We already integrated NATS above as MQTT broker and event bus. Let’s discuss **Supabase**:

**Supabase** is an open-source alternative to Firebase, providing a Postgres database with a RESTful API, real-time subscriptions (via listening to Postgres WAL), authentication, and storage. It’s essentially a suite of services, including:

- PostgreSQL (with PostgREST auto API),
- GoTrue (auth service),
- Realtime (websocket server for live queries),
- Storage (an S3-compatible file storage service plus a CDN layer).

The question asks whether to run Supabase in-cluster or use external.

**Use Case for Supabase:** If our Next.js admin UI or the platform needs to store user accounts, preferences, or any custom data beyond what Home Assistant stores, Supabase could be a convenient way to have those capabilities quickly. For example, if this platform will manage multiple user profiles or maintain logs in a database, having a PostgreSQL + Auth system is necessary. Home Assistant itself has its internal user management and a recorder database (which is SQLite or can be MySQL/Postgres). We might consider using one Postgres for both Home Assistant recorder and other app data – though mixing might not be ideal. Alternatively, keep HA on its own DB (or SQLite) and use Supabase Postgres for our stuff.

**Running Supabase in cluster:** Supabase can be self-hosted. The official docs provide a Docker Compose, and there’s a community Helm chart. Running it is non-trivial but feasible: you’d deploy a Postgres (with the required extensions like pg_cron, pg_net, etc.), and several containers for the other services. The **supabase-community helm chart** does this setup (clones supabase-kubernetes repo, etc.). It would give you all supabase components running inside K8s. The benefit: full control, no external dependencies. The drawback: it’s quite heavy – Postgres itself needs resources and careful storage (we’ll ensure persistent volumes for it, possibly on Ceph or local disk with backup). Also updates to Supabase might require manual intervention.

**Using Supabase Cloud or external DB:** For a POC, one could simply use Supabase’s hosted service or use a managed Postgres on e.g. DigitalOcean and skip self-hosting. But since the brief is to evaluate modern tooling and likely lean self-hosted (for an on-prem product offering maybe), we should consider hosting it.

Given this is an initial POC on a single machine, running Supabase (which includes a full Postgres) is achievable as long as the machine has enough RAM/CPU. It’s not uncommon for home lab clusters to run a database inside them, though one might prefer an external dedicated DB for reliability. We can try in-cluster now and maybe move to external later if needed.

**Recommendation:** We will attempt to run **Supabase in-cluster** using the official containers. This means deploying:

- a **Postgres** 15 container (with Supabase extensions). We’ll give it a persistent volume (on our storage class, likely replicated if using Ceph or at least backed up).
- the **Supabase API** (PostgREST + others) container,
- the **Auth (GoTrue)** container,
- the **Realtime** container (which listens to the WAL and broadcasts via websockets),
- the **Storage** container (which handles file uploads and serves them, storing files on disk or S3; we can configure it to use our MinIO as the storage backend).

There is an official all-in-one helm to simplify this. We’ll use that via Flux. The helm’s `values.yaml` will allow setting resource requests, enabling or disabling components. For example, if we don’t need the Storage service (maybe not immediately needed unless we want to store files, but could be used for e.g. camera snapshots or backup archives), we could disable it. But since MinIO is in plan, enabling it and pointing to MinIO makes sense.

Supabase will give us:

- A **database** for our own application data. Perhaps the Next.js UI or other custom logic will use this for things like custom automation configs, user profiles beyond HA, etc.
- **Authentication**: We could integrate Supabase Auth to manage users (especially if this platform is multi-tenant, say for multiple family members or in a commercial scenario multiple customers). Home Assistant has its own auth for logging into HA UI; if our admin UI is separate, we might let HA handle auth via its API tokens or use Supabase auth for the admin UI and then have it talk to HA’s API using an internal admin account. This part requires thought: possibly simpler to let HA do the heavy-lifting for device control, and Supabase just handle separate data not in HA.
- **Real-time messaging**: Supabase’s real-time could complement or duplicate NATS. Possibly redundant since we have NATS for events. But supabase real-time specifically notifies frontends of DB changes. If our admin UI needs to display sensor data or logs, we might just get that from HA’s WebSocket API rather than Supabase.
- **Storage**: If users upload floorplan images or if we want to store camera recordings in an object store, Supabase Storage with MinIO is a nice built-in solution. Alternatively, Home Assistant has its Media folder, but a dedicated storage might be better for large data.

If running Supabase proves too heavy or unnecessary, we can trim it from the POC. However, since it was explicitly mentioned, we’ll include it as a recommended component for a “complete platform”. It aligns with using modern full-stack tools (Supabase is quite trendy and provides an easy developer experience). A Medium guide even states _“Self-hosting Supabase with Kubernetes is a powerful way to manage your projects and control costs…run Supabase on your own infrastructure”_, confirming that our approach is viable and beneficial for ownership.

One note: Supabase’s Postgres could also potentially serve as Home Assistant’s database (HA uses SQLite by default for recorder history, which can get slow). We could point HA to use this Postgres (just create a DB for HA). That might be advantageous performance-wise if a lot of sensor data is stored. We must ensure the timescale – if the volume is large, a single node Ceph might be slow; but on SSD, Postgres should be okay. We can consider enabling TimescaleDB extension for HA’s recorder (if the Postgres has it, HA can use it to downsample older data). This would truly merge Home Assistant’s data into our database stack. This is optional but worth a thought for “commercial-grade” performance.

**Wrap-up on Supabase:** We’ll proceed with in-cluster Supabase deployment, carefully allocate resources (e.g., give Postgres a decent chunk of memory, configure it with max connections accordingly). We’ll use strong passwords stored in 1Password for the DB and JWT secrets. Our GitOps will contain the values file with references to those secrets (and 1Password operator will inject them). The admin UI or any custom services can then use Supabase endpoints as needed (for example, the Next.js app could use Supabase JS client to handle user login and data retrieval, separate from HA).

### Observability and Operations

To run this platform in a production-like setting, we need a robust **observability stack**: monitoring, logging, and possibly tracing. Our choices follow industry standards for cloud-native environments:

- **Metrics Monitoring (Prometheus):** We will deploy the **Prometheus** stack to collect metrics from Kubernetes and our applications. The Kubernetes control plane and kubelets expose metrics (we’ll scrape those), and many of our apps (like NATS, Home Assistant, etc.) can also export Prometheus metrics. For example, NATS has a /metrics endpoint, and we can use a ServiceMonitor to gather metrics like message rates, memory usage, etc. We can monitor container resource usage, so we know if we’re running out of CPU or memory. Given we are likely to use Flux, we can easily install the **kube-prometheus-stack** (the community Helm chart that includes Prometheus, Alertmanager, Grafana, node exporters, etc.). This chart sets up a lot of monitoring automatically for cluster components. As of 2025, Prometheus is a mature default choice for metrics in K8s (CNCF graduated, widely used). We will configure some alerts (like if CPU is high for long, or if Home Assistant container restarts frequently, etc.) using Alertmanager. Alerts can be routed to something like email or a messaging app – for a POC we might skip that, but in a real deployment one would configure notifications.

- **Logging (Loki):** For logs, instead of the classic ELK stack (ElasticSearch, etc.), we opt for **Grafana Loki**. Loki is a lightweight log aggregator designed for Kubernetes that indexes logs by labels (like pod name, etc.) and stores the log content efficiently (no full-text indexing by default). It integrates nicely with Grafana for querying (Grafana is the UI we’ll use). We’ll run **Loki** and its log agent **Promtail** on the node. Promtail will tail container logs and push to Loki. This allows us to search logs of Home Assistant, NATS, etc., in one place. Loki is much more resource-friendly than Elastic and sufficient for our needs. Grafana has a unified interface to view metrics and logs side by side (the “explore” feature).

- **Grafana:** We will deploy **Grafana** as the visualization UI. Grafana will connect to Prometheus as a data source for metrics and Loki for logs (and possibly other data sources like Prometheus Alertmanager or even directly to Home Assistant if using plugins). Grafana lets us create dashboards. There are already community dashboards for things like Kubernetes cluster health, or NATS monitoring, which we can import. We can also create custom dashboards to monitor home automation specifics – e.g., temperature sensors over time (though HA itself has history graphs; Grafana could combine data from multiple sources). Grafana will be exposed via Cloudflare (`grafana.mi.house`) and we will secure it (Grafana has its own auth, but we can also offload auth to Cloudflare Access or just create admin login). Grafana is essentially our single pane for ops data. We might include some dashboards to track, say, Home Assistant performance (there is an integration to export HA internal metrics to Prometheus via the HA Prometheus exporter integration). If so, we’ll enable that in HA config – Home Assistant can expose a Prom endpoint with stats (like number of state updates, automation timings, etc.), which Prometheus will scrape.

Combining these, we get what’s known as the **Grafana “LGTM” stack** (Loki for logs, Grafana, Tempo for traces, Prometheus for metrics – though we might not include Tempo unless we have custom instrumented apps that need tracing). This is a modern observability stack and considered best practice in cloud-native deployments. As one article notes, _“industry-standard tools like Prometheus, Loki, and Grafana”_ are used for complete observability in Kubernetes. We follow that pattern.

- **Tracing (optional):** If our Next.js app or other microservices had complex distributed tracing needs (e.g., multiple services calls per request), we could deploy Grafana Tempo or OpenTelemetry Collector. In this scenario, it might be overkill. One might instrument perhaps Home Assistant automations with trace logs, but HA already has an internal tracer for automation runs. We can skip distributed tracing until needed.

- **Kubernetes Dashboard:** Though not strictly required, we could deploy the Kubernetes Dashboard for a GUI view of the cluster. However, with Grafana and Flux’s UI (if any), it might not be needed. We can rely on CLI (kubectl) or Lens IDE for cluster management. Given this is a “platform” and we’re building a custom UI for admin, we likely don’t expose Kubernetes directly to users, so the Dashboard is mostly for ops – and Grafana/Prom + kubectl suffice for that.

- **Resource Management:** We will set resource requests/limits for each component to ensure the node isn’t oversubscribed. For example, we’ll allocate memory to Postgres, to NATS, etc. and leave headroom.

- **Backup/Resilience:** We might deploy **Velero** to enable backups of persistent volumes to external storage (like to a cloud bucket). With MinIO, we could even use MinIO as a backup target (since it’s S3-compatible). This would let us snapshot Home Assistant config, Postgres DB, etc., on a schedule. This is more of an ops consideration – possibly beyond initial POC, but we mention it as part of being production-ready.

- **Operators & CRDs:** We have already decided on a number of “operators”: FluxCD controllers, 1Password operator, maybe NATS operator if we cluster NATS (Synadia provides one, but for single node we don’t need it), Prometheus Operator (bundled in kube-prom-stack), possibly Cert-Manager for certificates (which we included in the community example config). Let’s consider **Cert-Manager**: If we want any internal certificates or to issue certs for say Ingress (but Cloudflare covers public certs), maybe we use it to generate self-signed or to manage ACME DNS-01 for something. It might not be strictly necessary since we are doing tunnel (cloudflared will use Cloudflare’s cert). But if we did want, for example, to use TLS between cloudflared and our services, we could use Cloudflare Origin CA: we generate an origin cert via Cloudflare and deploy it to our ingress service. Or simpler, let cloudflared connect over HTTP to local services (less overhead). For now, we can skip Cert-Manager in the plan unless needed by something else (e.g., if Supabase requires TLS termination on some endpoint without Cloudflare, but presumably we can route that through Cloudflare or just access it internally).

- **In-Cluster Alerting/Repair:** We might deploy **Kured** (a reboot daemon for OS upgrades) if using something like Flatcar; for Talos, it auto-updates and reboots in a controlled way, and we can coordinate that manually in single-node (Talos will only reboot on explicit command unless auto-update is configured). We should plan maintenance windows since a single node cluster will go down if the node reboots. However, the immutability helps that reboots are quick and system comes up reliably.

- **Upgrading Components:** Via Flux, upgrades are as easy as bumping Helm chart versions in Git. For OS/Talos upgrades, we’ll use Talos’s documented process (likely using talosctl to cordon -> drain -> upgrade -> uncordon, although with one node we just take a brief outage).

In essence, our **observability stack** ensures we have full insight: _Prometheus_ for metrics and performance, _Loki_ for logs, _Grafana_ as the analytics UI. These are production-grade tools that are now common even in enterprise (meaning we are not using any toy solutions – it’s the same stack that runs on large clusters, just right-sized for our environment).

## Storage Strategy

Given the diverse data in this platform – databases, media files, configuration – a flexible storage solution is needed. We want the ability to expand storage (add disks) and possibly tolerate node failures when we go multi-node. We also have the need for both **block storage** (for databases, volumes) and **object storage** (for files, backups, etc.).

**Dynamic Block Storage (PVCs):**
For Kubernetes Persistent Volume Claims (PVCs) like those used by Postgres, Home Assistant config, NATS (if it uses file storage for JetStream), etc., we need a **CSI driver**. The options considered: **Rook/Ceph**, **OpenEBS**, **Longhorn**, or using local volumes.

- **Rook/Ceph:** Ceph is a battle-tested distributed storage system providing block (RBD), file, and object (Ceph RGW) storage. With Rook (the K8s operator for Ceph), we can run a Ceph cluster within Kubernetes. Ceph shines in multi-node environments where you can replicate data across nodes for resilience. It can also allow adding OSDs (disks) to grow capacity. In a single-node POC, Ceph is an overkill – it would run 3 mon pods (for quorum) and likely just one OSD (one disk). That doesn’t give any replication (since there’s one node) and adds overhead. However, if we plan to scale to, say, 3 nodes, Ceph would become very attractive: we could have, for example, 3 OSDs (one per node) replicating each block volume 3-way, so any node loss doesn’t lose data. Ceph also has the advantage of offering an object storage gateway (S3) through RadosGW, though we might not need that if using MinIO. Ceph’s performance on small scale can be fine, but it requires some tuning and consumes memory.

- **OpenEBS:** OpenEBS is another approach which focuses on per-workload storage “engines”. For instance, OpenEBS has a **Local PV** mode (which simply provisions hostPath-like volumes on a disk or directory – no replication, just management). It also has **Jiva** and **cStor** (older replication engines) and newer **Mayastor** (high-performance with NVMe if available) for replicated volumes. OpenEBS local PV could be a simple solution: basically, it automates creating a PV on the node’s filesystem for each claim (similar to how k3s’s built-in local-path provisioner works). That gives no redundancy but is lightweight – in single node that’s fine. For multi-node, you’d either pin each volume to a node (not fault tolerant) or use their replicated engine (cStor/Mayastor) to get redundancy. OpenEBS is known to be easy to use for homelabs, and Mayastor in particular is cited as efficient (one user noted _“for a homelab, OpenEBS Mayastor is the clear winner: faster and uses less memory”_ compared to Longhorn). However, Mayastor requires iSCSI or NVMe and is somewhat complex to set up.

- **Longhorn:** Longhorn (by Rancher) is a popular lightweight distributed storage solution tailor-made for Kubernetes. It runs as pods and uses each node’s disks to create replicated volumes (default 3 replicas). Many homelab folks use Longhorn for ease of setup (it has a nice UI, etc.). It’s simpler than Ceph to manage, but can have performance overhead for heavy DB workloads due to replication at the software level. Still, for our use (handful of volumes, moderate size), Longhorn might be fine. It’s also easy to add disks (just register new disk to Longhorn and it will utilize it). On small clusters, Longhorn often outperforms Ceph in raw I/O because Ceph’s minimum 3x replication and background operations can overwhelm limited resources. On a single node, Longhorn can still run (it will just keep one replica or still do 2 replicas on same node which is redundant on the same disk, not useful). The community often suggests local PV for single-node and Longhorn when multi-node for simplicity.

Given the user specifically listed _MinIO, Rook/Ceph, OpenEBS_, they did not mention Longhorn explicitly. Possibly they’re more interested in Ceph vs OpenEBS comparisons. They also mention _“supports dynamic disk expansion for user data”_. Ceph and Longhorn both support adding disks dynamically. OpenEBS cStor can as well.

**Recommendation:** For the POC, since it starts single-node, we might use a **simple local storage provisioner initially, then plan to migrate to a replicated setup once multiple nodes are available**. Concretely, we can start with **OpenEBS LocalPV** (or even just use the K3s default local-path provisioner if we had k3s, but in Talos we’d pick something like OpenEBS or a similar provisioner). This will create volumes on the host filesystem (we can designate a directory or disk for it). This meets “dynamic provisioning” (PVCs get created without manual intervention) and “dynamic expansion” in the sense we can enlarge a PVC if the underlying storage supports it (ext4 can be grown if FS is mounted, or use LVM under the hood). But if the question specifically wants evaluating MinIO, Ceph, etc., likely they expect a lean towards one of them for the long run.

**User-Generated Data and scaling:** The type of data:

- Home Assistant config and history: not huge (unless many cameras).
- Database (Supabase Postgres): could grow if storing lots of app data or logs.
- Media: If we allow camera recordings or user file uploads, that’s potentially large. That’s where **MinIO** comes in. **MinIO** is an object storage server compatible with Amazon S3 APIs. It can be run as a single server or a distributed cluster. For our home cluster, we can run a single MinIO server on the main node, storing files on a mount (like a big disk or NAS). If later multi-node, MinIO can be federated or expanded (MinIO supports distributed mode across nodes, requiring at least 2 or 4 nodes/disks to shard). But even single-node MinIO is fine for home use, it just won’t replicate unless you configure erasure coding across drives.

We will deploy **MinIO** to handle:

- Supabase Storage backend: Supabase by default can use the local filesystem to save files. Instead, we can point it to our MinIO (it supports S3 compatible storage configuration). This way, any files uploaded via Supabase go into MinIO.
- Home Assistant backups or media: We could integrate HA to upload backups to MinIO or serve media out of it (though HA usually just keeps media locally or in its DB). Possibly we could mount an S3 bucket into HA as a media folder via an integration. Not urgent, but an idea.
- General file serving: If in future the platform needs to serve app downloads or large assets, MinIO is useful.

We’ll run MinIO in a single-instance (statefulset with one replica) for now, with a PVC for its data (which in single node is fine). We could configure it with erasure coding across multiple drives if we have them in that node (MinIO can use multiple disks on one node for redundancy). Or if the node has one disk, we can either not use erasure coding (just straight storage) or use an external RAID under the hood.

MinIO’s benefit is it’s lightweight and very fast for object operations. Clients (like the Supabase storage service or any other microservice) can use S3 SDKs to put/get files.

**Ceph vs Others for block storage:** If we anticipate adding nodes soon and want a production-grade solution, **Ceph (via Rook)** might be the way to go. It requires more memory overhead (it’s not uncommon for Ceph to use a few GB RAM for monitors and OSDs). In a single-node POC, Ceph can run but not shine. We might opt to start with **OpenEBS** or **Longhorn**, then possibly migrate to Ceph when scaling.

However, the phrasing “supports dynamic disk expansion” suggests that as data grows, we can add disks. Ceph is excellent at that: you add an OSD (disk) and it rebalances data across. Longhorn also can use new disks by creating new replicas or distributing new volumes onto them. OpenEBS Local just uses whatever disk (if you set it to a directory, you could expand that directory by mounting new storage or extending LVM).

Maybe the safe recommendation: **Use Rook/Ceph for the long-term**, with an initial single-node deployment configured to use one OSD. Then when new nodes come, add more OSDs and let Ceph replicate. Rook/Ceph is well-documented and by 2025 quite stable (CNCF graduated). Ceph would provide:

- RBD for block (we can create a StorageClass with 1 replica (no replication) initially, and update to 3 replicas when multi-node).
- CephFS or RGW if needed (though we likely won’t use CephFS; and RGW overlaps with MinIO).

Given the complexity, we might also mention that some teams prefer separate solutions: e.g., use **OpenEBS LocalPV** for simplicity on local cluster storage (fast, no overhead) and rely on **regular backups** for data safety, instead of live replication. The user did mention “dynamic expansion” rather than explicitly “fault tolerance”, so maybe they are more concerned with being able to grow storage by adding disks than with replicating across nodes. If it’s a home setup with a single powerful server, one might just keep all data on that server and ensure it’s backed up, rather than splitting across nodes. If expansion is the main concern, using **LVM on the host** to combine disks and then a local PV provisioner on top could be a straightforward path: one could add a disk, extend the volume group, filesystem grows, and Kubernetes volumes (or MinIO) see more space. But handling that manually is not as elegant as Ceph auto-managing distribution of data.

**Recommended Storage Stack:**

- Deploy **OpenEBS** for now with a Local PV default StorageClass (each PVC just makes a directory under say `/var/openebs/local` or on a designated data partition). This will be simple and fast. Use it for things like Home Assistant config, Grafana storage, etc.

- For critical data like the PostgreSQL database and NATS JetStream, consider using a **replicated storage class** from day one. Possibly use OpenEBS **cStor** or **Longhorn** so that even on single node, it replicates to itself (not useful) but when another node is present, it can migrate a replica. Alternatively, accept that in POC it’s single node anyway – if the node dies all is down regardless of storage replication (unless using an external NAS).

- Keep **Rook/Ceph** on the roadmap. We can say: when scaling to multi-node, we recommend migrating to Rook/Ceph for robust distributed storage. Ceph would give enterprise-level reliability (at cost of complexity). There is also the possibility to use Ceph for object storage (Ceph RGW instead of MinIO), but MinIO is simpler for now.

- **MinIO:** Definitely include MinIO for object storage needs. It directly addresses “user-generated data” which often means files/media. It’s easier to expand – you can attach an external disk to the server and mount it to MinIO (MinIO can even span multiple drives in erasure-coded sets). For instance, if the server has an initial 1TB disk for everything and later you add another 2TB disk for camera recordings, we could either expand the existing PV (if using LVM or Ceph) or add a new MinIO instance for that (MinIO allows expansion but might require reconfiguration if not in distributed mode from the start). Actually, MinIO expansion is easier if from the start you run it in distributed mode across multiple drives, but on one node you can specify multiple drives in one instance with erasure coding (like 4 drives with EC:2 parity, etc.). On adding drives, one approach is to add them as a new erasure set (MinIO supports adding new sets of drives to cluster to expand capacity). So we’ll configure MinIO with whatever drives we have, and know we can extend.

We should cite maybe something about the replicated storage preferences. For example, that _Replicated.com_ blog that said they moved away from Longhorn to recommending OpenEBS local or Ceph, because in their experience, Longhorn had some limitations. That might be relevant: it suggests using local PV (with backup) unless you truly need distributed (then Ceph). We can mention that viewpoint to justify not using Longhorn in production but rather Ceph for a truly robust solution.

So final plan:

- Use **OpenEBS Local PV** as the current default StorageClass (simple, no overhead). All PVCs by default get a host path on the server (we’ll allocate a directory or mount point for it).
- Set up **Rook/Ceph** in the background if possible (maybe not immediately, or perhaps just one OSD for now but no replication). When more nodes or disks come, expand Ceph to use them. Then we could migrate PVCs to Ceph RBD storage class which will then replicate.
- If Ceph is too heavy to run in parallel with everything on one node, we might hold off until at least 2 nodes are available. So maybe don't deploy Ceph at POC, but plan for it. Alternatively, deploy **Longhorn** for easier interim replication – but that might be unnecessary if we accept single node risk.

The user’s list implies they want us to evaluate and pick one. Perhaps they expect one of Ceph or OpenEBS to be chosen. Ceph is more “production-grade”, OpenEBS caters to both small and larger clusters with different engines. Perhaps the answer can say: For true production with multi-node, Ceph via Rook is recommended (due to maturity and features), whereas for initial single-node, simpler solutions suffice.

**Backups:** Regardless of storage solution, regular backups of volumes (especially DBs) to external storage (like cloud or NAS) is crucial for disaster recovery. We can mention using Velero to dump to e.g. Backblaze B2 or even to MinIO (MinIO could serve as backup target if we run another MinIO external or just use the same with different bucket). For now, we ensure we snapshot the database (perhaps with a CronJob in K8s to do pg_dump to MinIO daily, etc.).

Finally, Summarize with citations:

- Mention that Ceph has good performance and a nice dashboard, Longhorn is promising for ease, and OpenEBS (especially Mayastor) is very fast in homelab scenario. Possibly cite those just to show we considered.

Yes, let's use \[13†L9-L17] which shows someone saying "OpenEBS Mayastor is clear winner in homelab, faster and uses less memory, maybe in future Longhorn will catch up..." – that supports if we lean OpenEBS. And \[13†L0-L7] maybe has a note "Longhorn can outperform Ceph on small scale due to how replication works, Ceph spreads writes..." Actually \[13] line 0-7 is a Reddit: "_Longhorn can outperform ceph on small-scale, due to data being replicated AFTER being written... Ceph's writes gets spread around to ..._". That’s interesting – it implies on small scale Longhorn might have better write performance because it replicates asynchronously (?). Ceph replicates synchronously to multiple OSDs, adding latency. That indicates for small clusters, Ceph is heavier. We can cite that to justify initially not using Ceph in one-node scenario.

Yes, \[13†L1-L4] from reddit says: "Longhorn can outperform ceph, especially on small-scale... Ceph's writes get spread around...". That reinforces our phased approach (start simple, avoid Ceph overhead until needed).

**Conclusion of Storage:**

- Use **MinIO** for object storage (user files, large media).
- For block storage: initially **OpenEBS Local PV** (lightweight), with a plan to adopt **Rook/Ceph** when high availability across nodes is required.
- Keep volumes expandable either via underlying LVM or migrating to a bigger disk as needed. With Ceph later, you just add OSDs which automatically increases capacity – meeting the “dynamic expansion” criterion smoothly.
- Also mention that this design allows adding more disks or nodes without reconfiguring apps: we just add to storage layer.

---

Finally, after covering all these sections, we should provide a cohesive **Conclusion** summarizing the recommended stack and why it’s modern and production-ready:

In conclusion: Use Talos OS + embedded K8s for immutable infrastructure; FluxCD for GitOps (with 1Password for secrets); Cilium CNI and Cloudflare Tunnel for networking; MetalLB for internal LB; Next.js UI containerized with dev support via Skaffold; Home Assistant Container with separate add-on containers (MQTT via NATS, Zigbee2MQTT, ESPHome, Matter, etc.) giving full functionality; containerd runtime with gVisor option for security; storage using MinIO for objects and Kubernetes PVs via local/ceph solution; and observability via Prometheus+Loki+Grafana stack. This architecture uses cutting-edge but stable open-source components (most are CNCF graduated or incubating projects) as of 2025, ensuring the platform is **cloud-native, declarative, and extensible**.

We should ensure each key decision had rationale (which we did in each section). We should try to preserve the style of being thorough yet not too repetitive.

Double-check that we cited at least something for each main area:

- OS (Talos, Nix, Flatcar) – yes, used virtualizationhowto \[27] and Nix manual \[30].
- K8s distribution (k3s mention \[7], k0s \[9]).
- GitOps (1Password \[14]).
- Networking (Cloudflare \[48], example \[39], Cilium \[43], matter issues \[11]).
- UI dev (skaffold \[44]).
- HA stuff (example \[39] lines, HA matter \[11]).
- Container runtime (gVisor \[33], Firecracker \[47]).
- Storage (OpenEBS vs etc \[13]).
- NATS vs Redis (Medium \[19]).
- Observability (Grafana \[21]).

Yes, looks good.

Let's finalize this answer with a short conclusion after all sections maybe, just tying it together (though the last section of storage kind of is the last piece; we might add a final note: all decisions were made with best practices and future-proofing in mind, etc).

## Conclusion and Next Steps

The above plan outlines a **modern, production-ready home automation platform** built on Kubernetes and GitOps principles. In summary:

- **Infrastructure:** Use an immutable OS (Talos Linux) to run Kubernetes, ensuring a secure and reproducible baseline. This gives us a one-node cluster now with easy scalability to more nodes later. Containerd will be the runtime (no Docker), and we enable sandboxing (gVisor/Firecracker) for any untrusted workloads.
- **GitOps & Secrets:** Manage all cluster config and app manifests in Git using FluxCD. This provides traceability and fast recovery. Sensitive secrets are stored in 1Password and synced into the cluster via the 1Password operator – no plaintext secrets in git. This approach enforces immutability at both OS and cluster config levels.
- **Networking:** Leverage Cilium CNI for high-performance pod networking and future-proof features (eBPF, network policy). IoT discovery is handled by giving Home Assistant direct LAN access (host networking) for mDNS and similar protocols. We deploy a Thread Border Router container to support Matter devices, and plan to run the Matter controller as an addon when fully available. External access is secured via Cloudflare Tunnel – no ports are open to the internet, and Cloudflare’s network exposes services on **`*.mi.house`** domains with optional Zero Trust policies. Internally, MetalLB provides stable IPs for services (like Home Assistant) on the home LAN. DNS is managed such that external queries go through Cloudflare, and local queries can resolve directly to local IPs, ensuring efficient access both remotely and at home.
- **Core Services (Home Automation):** Home Assistant runs as a container (Core edition) with full functionality enabled through companion services. We deploy **NATS JetStream** as the unified messaging backbone (replacing the need for Redis and acting as an MQTT broker for Zigbee2MQTT et al.). Key add-ons run as separate pods: **Zigbee2MQTT** (with USB passthrough) for Zigbee device integration, **ESPHome** for IoT device management, and a Matter Server (planned) for Matter/Thread devices. These communicate with Home Assistant via standard APIs (MQTT, integrations), achieving the same outcome as Home Assistant’s add-on system. The cluster approach has been validated by community examples – e.g. Home Assistant + Zigbee + BLE on K8s with Cloudflare ingress works reliably. We thus get Home Assistant’s power plus the resiliency of Kubernetes (if a component crashes, it will be auto-restarted, etc.).
- **Applications and UI:** The custom admin UI (Next.js 15) is containerized and deployed in Kubernetes. In production it runs as a hardened container behind Cloudflare Tunnel. For development, we enable rapid iteration with tools like Skaffold – giving a “hot reload” dev loop where code changes sync directly into a running pod. This allows the developer to experience the app in-cluster (with all backend services available) while preserving the convenience of Next.js hot-refresh during development. The UI can interface with both Home Assistant (for controlling devices) and Supabase (for any additional app data or user management) via their APIs.
- **Ancillary Services:** We deploy **Supabase** in-cluster to provide a scalable Postgres database with RESTful and real-time APIs for any custom platform needs. This gives us user authentication, a JSON API, and an optional file storage layer out-of-the-box. Self-hosting Supabase is achievable via the community Helm chart and aligns with our GitOps workflow. The Postgres DB can also be used by Home Assistant (if we configure HA’s recorder to use Postgres) and by any custom automations or apps. For secrets and config, we integrate the Supabase services with our 1Password-managed secrets (JWT secrets, database passwords, etc. pulled in via the operator).
- **Storage:** We adopt a hybrid storage approach. **MinIO** is deployed for object storage (S3-compatible) to handle user-generated files, camera recordings, and Supabase Storage needs. It’s a lightweight solution that we can scale by adding drives or instances, and it keeps large binary data out of the database. For block storage (Kubernetes PVCs), we start with a simple **OpenEBS Local PV** provisioner (fast, no-frills storage on the node) and plan to migrate to **Rook Ceph** for distributed storage as the cluster grows. In the POC (single-node), replication isn’t critical – using local volumes is efficient. When we add nodes or require higher resilience, we’ll bring up Ceph via Rook to get replicated, self-healing volumes across nodes (Ceph will ensure no single disk/node failure causes data loss, and allows on-the-fly expansion by adding OSDs/disks). This two-phase approach avoids Ceph’s overhead on day 1 while keeping us ready for production scaling. All important data (Home Assistant config, Postgres DB, etc.) will be on persistent volumes, and we will institute backup policies (e.g., using Velero to snapshot to MinIO or cloud) to cover disaster recovery.
- **Observability:** We integrate a full observability stack to monitor and maintain the platform. **Prometheus** is deployed (via the kube-prometheus-stack) to gather metrics from Kubernetes (node metrics, pod metrics) and from our apps (we’ll enable metrics endpoints where available, e.g., NATS provides metrics, and Home Assistant can expose Prometheus stats via an integration). **Grafana** provides dashboards and a unified view – we’ll have dashboards for cluster health (CPU, memory, etc.), and custom ones for Home Assistant (e.g., automations timing) and NATS (throughput) as needed. **Loki** aggregates logs from all pods, so we can search logs of any component in one place (e.g., filter Home Assistant logs for errors, or see Supabase logs). This stack (Prometheus + Loki + Grafana) is a proven, industry-standard solution for cloud-native environments, giving us deep visibility into the system. We’ll set up alerts (via Alertmanager) for critical conditions – for example, if Home Assistant is not responding, if a container restarts repeatedly, or if disk space is running low, etc. This ensures that issues can be detected and addressed proactively.
- **Security and Updates:** The platform is designed with security in mind: OS-level immutability (Talos with no SSH), network-level zero-trust ingress (Cloudflare proxy with optional SSO), and isolation of services in containers. Role-Based Access Control (RBAC) in Kubernetes will be configured so that, for instance, the Home Assistant pod only has access to the specific device mount it needs and nothing else. We avoid privileged containers except where absolutely necessary (Zigbee2MQTT needs device access, etc.). Secrets are never logged or exposed in plaintext (1Password operator ensures they are injected at runtime). Regular updates will be performed via GitOps: e.g., bumping container images in the Git repo which Flux will apply. Talos OS can auto-update or be updated with one command, and Kubernetes version upgrades are facilitated by Talos as well. We plan to follow a **continuous update strategy** – applying minor updates frequently (for Home Assistant, addons, etc.) rather than big jumps, which is feasible thanks to Flux (just update a version number in Git and let automation do the rest).

Overall, this architecture uses **cloud-native, CNCF-graduated technologies** where possible, ensuring both **maturity and community support**. By using Kubernetes as the substrate, we achieve an immutable, declarative deployment of traditionally “pet” home automation services – making them easier to manage and scale. The design is **modular** (each function is a separate microservice that can be individually updated or replaced), and **extensible** (new services or integrations can be added via GitOps with minimal impact on the rest). For example, if we later decide to add Node-RED for advanced automations or an AI service for smart alerts, we simply deploy it as another workload and tie it into the message bus (NATS or MQTT). The platform is cloud-agnostic as well – while we run on bare-metal now, the same setup could be deployed to a cloud Kubernetes or a mini cluster of Raspberry Pis (Cilium and Flux would work the same, perhaps swapping out Talos for another OS). It is truly **homelab-grade and production-grade** at the same time.

With this foundation in place, the next steps would be implementing the bootstrap: bringing up Talos on the server, initializing the K8s control plane, and applying the FluxCD GitOps repo. From there, all components (network, storage, Home Assistant, etc.) come alive in sequence. We would then proceed to pair devices (Zigbee devices via Zigbee2MQTT, Matter devices via the Matter service, etc.) and verify that the home automation functions (control via the Next.js UI and HA UI, automations firing, remote access through Cloudflare, etc.) work as expected. Because everything is defined declaratively, we can iterate quickly – any configuration tweaks (e.g., increase memory for Postgres, or add a new integration) is a Git commit away, and we can be confident the cluster will converge to the desired state.

In conclusion, the proposed stack brings together best-in-class open-source projects as of 2025 to create a **flexible, secure, and scalable home automation platform**. It embraces GitOps and immutability for maintainability, Kubernetes for orchestration and resilience, and includes all necessary pieces: from networking (Cilium, Cloudflare) to application services (Home Assistant, NATS, Supabase) to observability (Grafana/Prometheus) – each chosen for robust performance and active community support. This approach will enable an initial POC on one machine to seamlessly evolve into a multi-node, commercially deployable solution, all while keeping management overhead low and ensuring the smart home remains **always-on and accessible**. The architecture is **future-proof** and can adapt to new requirements (more users, new IoT protocols, etc.) by leveraging the power of the cloud-native ecosystem.
