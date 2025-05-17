# GitOps Repository Structure and Conventions

A well-organized Git repository is crucial for managing our Flux deployment. We’ll use a mono-repo structure that separates concerns (infrastructure vs. apps) and allows targeting different cluster setups. Below is a proposed structure with explanations.

---

## Repository Layout

```plaintext
gitops/
├── clusters/
│   ├── home-single/
│   │   ├── flux-system/             # Flux Kustomization for single-node cluster
│   │   └── kustomization.yaml       # References infra/apps overlays for single-node
│   └── home-multi/
│       ├── flux-system/             # Flux setup for multi-node cluster
│       └── kustomization.yaml
├── infrastructure/
│   ├── base/                        # Base manifests for infra components
│   │   ├── ingress-nginx.yaml
│   │   ├── metallb.yaml
│   │   ├── cloudflare-tunnel.yaml
│   │   ├── coredns-configmap.yaml
│   │   ├── pihole.yaml
│   │   ├── externaldns.yaml
│   │   └── … (cert-manager, MQTT broker, etc.)
│   └── overlays/
│       ├── home-single/             # Single-node infra overlay
│       │   ├── metallb-pool-patch.yaml
│       │   ├── ingress-patch.yaml
│       │   └── kustomization.yaml
│       └── home-multi/              # Multi-node infra overlay
│           ├── metallb-pool-patch.yaml
│           ├── ingress-patch.yaml
│           └── kustomization.yaml
├── apps/
│   ├── base/                        # Base manifests for applications
│   │   ├── home-assistant.yaml
│   │   ├── node-red.yaml
│   │   ├── zigbee2mqtt.yaml
│   │   ├── mosquitto.yaml
│   │   ├── code-server.yaml
│   │   ├── apigateway.yaml
│   │   └── … (other apps)
│   └── overlays/
│       ├── home-single/             # Single-node app overlay
│       │   ├── ha-hostnetwork-patch.yaml
│       │   ├── zigbee2mqtt-patch.yaml
│       │   ├── replicas-patch.yaml
│       │   └── kustomization.yaml
│       └── home-multi/              # Multi-node app overlay
│           ├── ha-hostnetwork-patch.yaml
│           ├── zigbee2mqtt-patch.yaml
│           ├── replicas-patch.yaml
│           └── kustomization.yaml
└── infrastructure/README.md         # Docs for infra conventions
   apps/README.md                    # Docs for apps conventions
```

---

## How It Works

1. **Base Directories**

   - **`infrastructure/base/`** holds environment-agnostic infra manifests (e.g., Pi-hole, ingress-nginx).
   - **`apps/base/`** contains generic application manifests without hard-coded node or network specifics.

2. **Overlays**

   - Located under `infrastructure/overlays/<env>/` and `apps/overlays/<env>/`.
   - Patches specialize the base for each environment (e.g., single-node or multi-node).
   - Keeps YAML DRY by only declaring differences (nodeSelector, hostNetwork, replica count, IP ranges).

3. **Cluster Entrypoints**

   - The `clusters/<env>/kustomization.yaml` ties together the infra and app overlays for that environment.
   - `flux-system/` directory in each cluster folder contains Flux’s bootstrap manifests (GitRepository, Kustomization CRs).

---

## Conventions & Comments

- **README per Major Directory**

  - Explain contents and conventions (e.g., “Don’t hard-code values in `apps/base/`; use ConfigMaps or overlay patches.”).

- **Inline YAML Comments**

  - Clarify non-obvious patches, e.g.:

    ```yaml
    # Host networking enabled for mDNS discovery on the LAN
    hostNetwork: true
    ```

- **Consistent Naming & Labeling**

  - Prefix resources with the app name and optional env identifier.
  - Always label with `environment=<env>` for easy filtering.

- **Architecture Documentation**

  - A top-level `architecture.md` summarizes repo structure and deployment flow.

---

## Gotchas

- **Secret Management**

  - Use [SOPS](https://github.com/mozilla/sops) to encrypt secrets (e.g., Cloudflare tunnel tokens).
  - Store encrypted files (`*.enc.yaml`) in Git; Flux with SOPS integration decrypts at runtime.

- **Kustomize Order**

  - Ensure infra applies before apps (e.g., DNS must exist before app pods start).
  - Use Flux’s `dependsOn` in Kustomization CRs or list infra overlays first.

- **IP Range Patches**

  - MetalLB ConfigMap differs per env; update overlays when home subnet changes.

- **Extensibility**

  - To add a new app:

    1. Create its manifest in `apps/base/`.
    2. Optionally add architecture-specific patches under `apps/overlays/<env>/`.

---

## Future Ideas

- **Additional Environments**

  - Add `clusters/home-dev/` or staging overlays for testing.

- **Helm Chart Support**

  - Migrate complex manifests to Helm; Flux can manage HelmReleases.

- **Image Automation**

  - Enable Flux Image Update to auto-track container versions (via annotations).

- **Badges & CI**

  - Display GitHub CI status and Flux sync status badges in `README.md` for quick health checks.

---

_This structure guarantees reproducible, DRY deployments, clear separation of concerns, and an auditable Git-based cluster blueprint._
