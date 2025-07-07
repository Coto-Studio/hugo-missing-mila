---
services:
  main:
    image: {{ op://${VAULT_ID}/$ITEM_ID/deploy/image }}:main
    networks:
      - traefik-public
    deploy:
      replicas: 2
      labels:
        # Enable Traefik
        - "traefik.enable=true"
        - "traefik.docker.network=traefik-public"
        - "traefik.constraint-label=traefik-public"
        # Config
        - "traefik.http.services.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main.loadbalancer.server.port={{ op://${VAULT_ID}/$ITEM_ID/deploy/port }}"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main-http.middlewares=https-redirect"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main-https.tls.certresolver=le"
        # www Redirect
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-https.middlewares={{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect.redirectregex.regex=^https?://www.{{ op://${VAULT_ID}/$ITEM_ID/domain/${GIT_BRANCH:-main} }}/(.*)"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect.redirectregex.replacement=https://{{ op://${VAULT_ID}/$ITEM_ID/domain/${GIT_BRANCH:-main} }}/$${1}"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect.redirectregex.permanent=true"

  dev:
    image: {{ op://${VAULT_ID}/$ITEM_ID/deploy/image }}:dev
    networks:
      - traefik-public
    deploy:
      labels:
        # Enable Traefik
        - "traefik.enable=true"
        - "traefik.docker.network=traefik-public"
        - "traefik.constraint-label=traefik-public"
        # Config
        - "traefik.http.services.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev.loadbalancer.server.port={{ op://${VAULT_ID}/$ITEM_ID/deploy/port }}"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-http.middlewares=https-redirect"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-https.tls.certresolver=le"
        

networks:
  traefik-public:
    external: true
